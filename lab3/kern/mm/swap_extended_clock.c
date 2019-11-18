#include <defs.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <swap_extended_clock.h>
#include <list.h>

//维护一个与物理页面数目相等的环形链表，发生访问时，
//如果要访问的页存在，则将accessed位置为1，如果访问的同时也进行了修改，则将dirty位变为1。
//维护的环形链表为`pra_list_head`，头指针为`clock_p` 
list_entry_t *clock_p;
list_entry_t pra_list_head;


//当访问页时，相应的A位和D位都会被CPU修改
//不用操作系统进行专门修改，所以只要对发生缺页时的情况进行处理即可。

static int
_extended_clock_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
     // 将头指针指向pra_list_head的起始地址
     clock_p = (list_entry_t*)&pra_list_head;
     //cprintf(" mm->sm_priv %x in extended_clock_init_mm\n",mm->sm_priv);
     return 0;
}
/*
 * (3)_extended_clock_map_swappable: According extended_clock PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_extended_clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    list_entry_t *entry=&(page->pra_page_link);
 
    assert(entry != NULL && head != NULL);
    //将换进的页加入链表
    list_add_before(clock_p, entry);
    //pte_t *pte = get_pte(mm->pgdir, page2kva(page), 0);
	pte_t *pte = get_pte(mm->pgdir, addr, 0);
    //int access = (*pte)&(PTE_A)?1:0;
    //int dirty = (*pte)&(PTE_D)?1:0;
    return 0;
}
/*
如果发生了缺页，则从指针的位置开始循环寻找，同时对accessed位和dirty位进行修改，修改的方式是：  
	accessed  dirty
	(1,1)- > (0,1)
	(1,0)- >（0，0）
	(0,1)- > (0,0)
	(0,0) 置换        
当找到（0，0）时置换此页，并将指针下移。
*/
static int
_extended_clock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
         assert(head != NULL);
     assert(in_tick==0);
     list_entry_t *le = clock_p;
     le = head->next;
     cprintf("\n---start---\n");
     while (1) {
    	 struct Page *page = le2page(le, pra_page_link);
    	 pte_t * pte = get_pte(mm->pgdir, page->pra_vaddr, 0);
    	 int accessed = (*pte)&(PTE_A)?1:0;
    	 int dirty = (*pte)&(PTE_D)?1:0;
		 if (le==clock_p)
			 cprintf("->");
		 else
			 cprintf("  ");
    	 cprintf("clock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, accessed, dirty);
    	 le = le->next;
    	 if (le == head) {
    		 break;
    	 }
     }
     cprintf("----end----\n");

     le = clock_p;
     while (1) {
    	 if (le == head) {
    		 le = le->next;
    		 clock_p = clock_p -> next;
    	 }
    	 struct Page *page = le2page(le, pra_page_link);
    	 pte_t * pte = get_pte(mm->pgdir, page->pra_vaddr, 0);
    	 int accessed = (*pte)&(PTE_A)?1:0;
    	 int dirty = (*pte)&(PTE_D)?1:0;
    	 if (accessed) {//如果A为1，则将其变为0；
    		 cprintf("clock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, accessed, dirty);
    		 (*pte) = (*pte) & (~PTE_A);
    		 cprintf("\tclock state: 0x%4x: A:%x, D:%x\n",page->pra_vaddr, (*pte)&(PTE_A)?1:0, (*pte)&(PTE_D)?1:0);
    	 }
    	 else if (!accessed && dirty) {//如果A为0，D为1 ，则D变为0；
    		 cprintf("clock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, accessed, dirty);
    		 (*pte) = (*pte) & (~PTE_D);
    		 cprintf("\tclock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, (*pte)&(PTE_A)?1:0, (*pte)&(PTE_D)?1:0);
    	 } else if (!accessed && !dirty){//如果都为0，则置换此页，且clock_p指针下移一位；
    	     struct Page *p = le2page(le, pra_page_link);
    	     list_del(le);
    	     clock_p = clock_p->next;
    	     assert(p !=NULL);
    	     *ptr_page = p;

			 le = head->next;
			 cprintf("\n--after--start---\n");
			 while (1) {
				 struct Page *page = le2page(le, pra_page_link);
				 pte_t * pte = get_pte(mm->pgdir, page->pra_vaddr, 0);
				 int accessed = (*pte)&(PTE_A)?1:0;
				 int dirty = (*pte)&(PTE_D)?1:0;
				 if (le==clock_p)
					 cprintf("->");
				 else
					 cprintf("  ");
				 cprintf("clock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, accessed, dirty);
				 le = le->next;
				 if (le == head) {
					 break;
				 }
			 }
			 cprintf("--after--end----\n");
    	     return 0;
    	 }
    	 le = le->next;
    	 clock_p = clock_p->next;
     }

}

static int
_extended_clock_check_swap(void) {
    //初始状态置入了abcd四页，然后进行了写e，读c，写d，读a，写b，
    //写e，写c，写e，读c，写e，写a，写a，读b，读c，读d，写e，读a，写b，写e 这些操作
	unsigned char tmp;
	cprintf("write Virt Page e in extended_clock_check_swap\n");
    *(unsigned char *)0x5000 = 0x1e;
	
	
    cprintf("read Virt Page c in extended_clock_check_swap\n");
    tmp = *(unsigned char *)0x3000;
    //cprintf("tmp = 0x%4x\n", tmp);
	
    cprintf("write Virt Page d in extended_clock_check_swap\n");
    *(unsigned char *)0x4000 = 0x0a;

    cprintf("read Virt Page a in extended_clock_check_swap\n");
    tmp = *(unsigned char *)0x1000;
    //cprintf("tmp = 0x%4x\n", tmp);

	
    cprintf("write Virt Page b in extended_clock_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;

    cprintf("write Virt Page e in extended_clock_check_swap\n");
    *(unsigned char *)0x5000 = 0x1e;
	
	cprintf("write Virt Page c in extended_clock_check_swap\n");
    *(unsigned char *)0x3000 = 0x0e;
	
	cprintf("write Virt Page e in extended_clock_check_swap\n");
    *(unsigned char *)0x5000 = 0x2e;
	
	cprintf("read Virt Page c in extended_clock_check_swap\n");
    tmp = *(unsigned char *)0x3000;
	
	cprintf("write Virt Page e in extended_clock_check_swap\n");
    *(unsigned char *)0x5000 = 0x2e;
	//cprintf("--------\n");
	cprintf("write Virt Page a in extended_clock_check_swap\n");
    *(unsigned char *)0x1000 = 0x1a;
	cprintf("write Virt Page a in extended_clock_check_swap\n");
    *(unsigned char *)0x1000 = 0x1a;
    
	//cprintf("--------\n");
    cprintf("read Virt Page b in extended_clock_check_swap\n");
    tmp = *(unsigned char *)0x2000;
    //cprintf("tmp = 0x%4x\n", tmp);
	//cprintf("--------\n");

    cprintf("read Virt Page c in extended_clock_check_swap\n");
    tmp = *(unsigned char *)0x3000;
    //cprintf("tmp = 0x%4x\n", tmp);

    cprintf("read Virt Page d in extended_clock_check_swap\n");
    tmp = *(unsigned char *)0x4000;
    //cprintf("tmp = 0x%4x\n", tmp);

    cprintf("write Virt Page e in extended_clock_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;

    cprintf("read Virt Page a in extended_clock_check_swap\n");
    tmp = *(unsigned char *)0x1000;
    //cprintf("tmp = 0x%4x\n", tmp);

    cprintf("write Virt Page b in extended_clock_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;

    cprintf("write Virt Page e in extended_clock_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;


    return 0;
}


static int
_extended_clock_init(void)
{
    return 0;
}

static int
_extended_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_extended_clock_tick_event(struct mm_struct *mm)
{ return 0; }


struct swap_manager swap_manager_extended_clock =
{
     .name            = "extended_clock swap manager",
     .init            = &_extended_clock_init,
     .init_mm         = &_extended_clock_init_mm,
     .tick_event      = &_extended_clock_tick_event,
     .map_swappable   = &_extended_clock_map_swappable,
     .set_unswappable = &_extended_clock_set_unswappable,
     .swap_out_victim = &_extended_clock_swap_out_victim,
     .check_swap      = &_extended_clock_check_swap,
};