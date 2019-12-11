#include <stdio.h>
#include <monitor.h>
#include <kmalloc.h>
#include <assert.h>


// Initialize monitor.
void     
monitor_init (monitor_t * mtp, size_t num_cv) {
    int i;
    assert(num_cv>0);
    mtp->next_count = 0;
    mtp->cv = NULL;
    sem_init(&(mtp->mutex), 1); //unlocked
    sem_init(&(mtp->next), 0);
    mtp->cv =(condvar_t *) kmalloc(sizeof(condvar_t)*num_cv);
    assert(mtp->cv!=NULL);
    for(i=0; i<num_cv; i++){
        mtp->cv[i].count=0;
        sem_init(&(mtp->cv[i].sem),0);
        mtp->cv[i].owner=mtp;
    }
}

// Unlock one of threads waiting on the condition variable. 
/*
分支1. 因为条件不成立而睡眠的进程计数小于等于0 时 说明 没有进程需要唤醒 则直接返回
分支2. 因为条件不成立而睡眠的进程计数大于0 说明有进程需要唤醒 就将其唤醒
同时设置 条件变量所属管程的 next_count 加1 以用来告诉 wait操作 有进程睡在了 signal操作上
然后自己将自己阻塞 等待条件同步 被唤醒 被唤醒后 睡在 signal 操作上的进程应该减少 故 next_count 应减 1
*/
void 
cond_signal (condvar_t *cvp) {
   //LAB7 EXERCISE1: YOUR CODE
   cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
  /*
   *      cond_signal(cv) {
   *          if(cv.count>0) {
   *             mt.next_count ++;
   *             signal(cv.sem);
   *             wait(mt.next);
   *             mt.next_count--;
   *          }
   *       }
   */
     if(cvp->count>0) {
        cvp->owner->next_count ++;
        up(&(cvp->sem));
        down(&(cvp->owner->next));
        cvp->owner->next_count --;
      }
   cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
}

// Suspend calling thread on a condition variable waiting for condition Atomically unlocks 
// mutex and suspends calling thread on conditional variable after waking up locks mutex. Notice: mp is mutex semaphore for monitor's procedures
/*
先将 因为条件不成立而睡眠的进程计数加1
分支1. 当 管程的 next_count 大于 0 说明 有进程睡在了 signal 操作上 我们将其唤醒
分支2. 当 管程的 next_count 小于 0 说明 当前没有进程睡在 signal操作数 只需要释放互斥体
然后 再将 自身阻塞 等待 条件变量的条件为真 被唤醒后 将条件不成立而睡眠的进程计数减1 因为现在成立了
*/
void
cond_wait (condvar_t *cvp) {
    //LAB7 EXERCISE1: YOUR CODE
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
   /*
    *         cv.count ++;
    *         if(mt.next_count>0)
    *            signal(mt.next)
    *         else
    *            signal(mt.mutex);
    *         wait(cv.sem);
    *         cv.count --;
    */
      cvp->count++;
      if(cvp->owner->next_count > 0)
         up(&(cvp->owner->next));
      else
         up(&(cvp->owner->mutex));
      down(&(cvp->sem));
      cvp->count --;
    cprintf("cond_wait end:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
}
