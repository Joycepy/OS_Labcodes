#include <defs.h>
#include <wait.h>
#include <atomic.h>
#include <kmalloc.h>
#include <sem.h>
#include <proc.h>
#include <sync.h>
#include <assert.h>

void
sem_init(semaphore_t *sem, int value) {
    sem->value = value;
    wait_queue_init(&(sem->wait_queue));
}
/*
    V操作 也要关闭中断 并保存 eflag 寄存器的值 防止共享变量同时被多个线程访问或修改
    先判断等待队列是否为空 若为空 则将计数值 加 1 并返回
    若不为空 则说明还有线程在等待 此时取出等待队列的第一个线程 并将其 唤醒 唤醒的过程中 
    将其从等待队列中删除
*/
static __noinline void __up(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        wait_t *wait;
        if ((wait = wait_queue_first(&(sem->wait_queue))) == NULL) {
            sem->value ++;
        }
        else {
            assert(wait->proc->wait_state == wait_state);
            wakeup_wait(&(sem->wait_queue), wait, wait_state, 1);
        }
    }
    local_intr_restore(intr_flag);
}
/*
    P操作 要关闭中断并保存 eflag 寄存器的值 避免共享变量被多个线程同时修改
    判断 计数值是否大于 0 若大于 0 说明此时没有其他线程访问临界区 则直接将计数值 减 1 并 返回
    若 计数值小于 0 则 已经有其他线程访问临界区了 就将当前线程放入等待队列中 并调用调度函数
    等到进程被唤醒 再将当前进程从等待队列中 取出并删去 最后判断等待的线程是因为什么原因被唤醒
*/
static __noinline uint32_t __down(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag);
    if (sem->value > 0) {
        sem->value --;
        local_intr_restore(intr_flag);
        return 0;
    }
    wait_t __wait, *wait = &__wait;
    wait_current_set(&(sem->wait_queue), wait, wait_state);
    local_intr_restore(intr_flag);

    schedule();

    local_intr_save(intr_flag);
    wait_current_del(&(sem->wait_queue), wait);
    local_intr_restore(intr_flag);

    if (wait->wakeup_flags != wait_state) {
        return wait->wakeup_flags;
    }
    return 0;
}

void
up(semaphore_t *sem) {
    __up(sem, WT_KSEM);
}

void
down(semaphore_t *sem) {
    uint32_t flags = __down(sem, WT_KSEM);
    assert(flags == 0);
}

bool
try_down(semaphore_t *sem) {
    bool intr_flag, ret = 0;
    local_intr_save(intr_flag);
    if (sem->value > 0) {
        sem->value --, ret = 1;
    }
    local_intr_restore(intr_flag);
    return ret;
}

