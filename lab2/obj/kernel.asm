
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 13 59 00 00       	call   c0105969 <memset>

    cons_init();                // init the console
c0100056:	e8 83 15 00 00       	call   c01015de <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 80 61 10 c0 	movl   $0xc0106180,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 9c 61 10 c0 	movl   $0xc010619c,(%esp)
c0100070:	e8 1c 02 00 00       	call   c0100291 <cprintf>

    print_kerninfo();
c0100075:	e8 bd 08 00 00       	call   c0100937 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 71 32 00 00       	call   c01032f5 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 b2 16 00 00       	call   c010173b <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 36 18 00 00       	call   c01018c4 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 01 0d 00 00       	call   c0100d94 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 de 17 00 00       	call   c0101876 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 c6 0c 00 00       	call   c0100d82 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 a1 61 10 c0 	movl   $0xc01061a1,(%esp)
c010015c:	e8 30 01 00 00       	call   c0100291 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 af 61 10 c0 	movl   $0xc01061af,(%esp)
c010017c:	e8 10 01 00 00       	call   c0100291 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 bd 61 10 c0 	movl   $0xc01061bd,(%esp)
c010019c:	e8 f0 00 00 00       	call   c0100291 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 cb 61 10 c0 	movl   $0xc01061cb,(%esp)
c01001bc:	e8 d0 00 00 00       	call   c0100291 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 d9 61 10 c0 	movl   $0xc01061d9,(%esp)
c01001dc:	e8 b0 00 00 00       	call   c0100291 <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile(
c01001f3:	83 ec 08             	sub    $0x8,%esp
c01001f6:	cd 78                	int    $0x78
c01001f8:	89 ec                	mov    %ebp,%esp
		"int %0 \n"//调用 T_SWITCH_TOU 中断
		"movl %%ebp,%%esp"//恢复栈指针
		:
		: "i"(T_SWITCH_TOU)
	);
}
c01001fa:	5d                   	pop    %ebp
c01001fb:	c3                   	ret    

c01001fc <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001fc:	55                   	push   %ebp
c01001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	//把tf->tf_cs和tf->tf_ds都设置为内核代码段和内核数据段
	asm volatile(
c01001ff:	cd 79                	int    $0x79
c0100201:	89 ec                	mov    %ebp,%esp
		"int %0 \n"// //调用T_SWITCH_TOK号中断
		"movl %%ebp, %%esp \n"//强行改为内核态，会让cpu认为没有发生特权级转换，%esp的值就不对了
		:
		: "i"(T_SWITCH_TOK)
	);
}
c0100203:	5d                   	pop    %ebp
c0100204:	c3                   	ret    

c0100205 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100205:	55                   	push   %ebp
c0100206:	89 e5                	mov    %esp,%ebp
c0100208:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020b:	e8 1a ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100210:	c7 04 24 e8 61 10 c0 	movl   $0xc01061e8,(%esp)
c0100217:	e8 75 00 00 00       	call   c0100291 <cprintf>
    lab1_switch_to_user();
c010021c:	e8 cf ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100221:	e8 04 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100226:	c7 04 24 08 62 10 c0 	movl   $0xc0106208,(%esp)
c010022d:	e8 5f 00 00 00       	call   c0100291 <cprintf>
    lab1_switch_to_kernel();
c0100232:	e8 c5 ff ff ff       	call   c01001fc <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100237:	e8 ee fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c010023c:	c9                   	leave  
c010023d:	c3                   	ret    

c010023e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010023e:	55                   	push   %ebp
c010023f:	89 e5                	mov    %esp,%ebp
c0100241:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100244:	8b 45 08             	mov    0x8(%ebp),%eax
c0100247:	89 04 24             	mov    %eax,(%esp)
c010024a:	e8 bb 13 00 00       	call   c010160a <cons_putc>
    (*cnt) ++;
c010024f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100252:	8b 00                	mov    (%eax),%eax
c0100254:	8d 50 01             	lea    0x1(%eax),%edx
c0100257:	8b 45 0c             	mov    0xc(%ebp),%eax
c010025a:	89 10                	mov    %edx,(%eax)
}
c010025c:	c9                   	leave  
c010025d:	c3                   	ret    

c010025e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010025e:	55                   	push   %ebp
c010025f:	89 e5                	mov    %esp,%ebp
c0100261:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100264:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010026b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010026e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100272:	8b 45 08             	mov    0x8(%ebp),%eax
c0100275:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100279:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010027c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100280:	c7 04 24 3e 02 10 c0 	movl   $0xc010023e,(%esp)
c0100287:	e8 2f 5a 00 00       	call   c0105cbb <vprintfmt>
    return cnt;
c010028c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010028f:	c9                   	leave  
c0100290:	c3                   	ret    

c0100291 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100291:	55                   	push   %ebp
c0100292:	89 e5                	mov    %esp,%ebp
c0100294:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100297:	8d 45 0c             	lea    0xc(%ebp),%eax
c010029a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010029d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01002a7:	89 04 24             	mov    %eax,(%esp)
c01002aa:	e8 af ff ff ff       	call   c010025e <vcprintf>
c01002af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002b5:	c9                   	leave  
c01002b6:	c3                   	ret    

c01002b7 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002b7:	55                   	push   %ebp
c01002b8:	89 e5                	mov    %esp,%ebp
c01002ba:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01002c0:	89 04 24             	mov    %eax,(%esp)
c01002c3:	e8 42 13 00 00       	call   c010160a <cons_putc>
}
c01002c8:	c9                   	leave  
c01002c9:	c3                   	ret    

c01002ca <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002ca:	55                   	push   %ebp
c01002cb:	89 e5                	mov    %esp,%ebp
c01002cd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002d7:	eb 13                	jmp    c01002ec <cputs+0x22>
        cputch(c, &cnt);
c01002d9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002dd:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002e0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002e4:	89 04 24             	mov    %eax,(%esp)
c01002e7:	e8 52 ff ff ff       	call   c010023e <cputch>
    while ((c = *str ++) != '\0') {
c01002ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ef:	8d 50 01             	lea    0x1(%eax),%edx
c01002f2:	89 55 08             	mov    %edx,0x8(%ebp)
c01002f5:	0f b6 00             	movzbl (%eax),%eax
c01002f8:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002fb:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002ff:	75 d8                	jne    c01002d9 <cputs+0xf>
    }
    cputch('\n', &cnt);
c0100301:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100304:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100308:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c010030f:	e8 2a ff ff ff       	call   c010023e <cputch>
    return cnt;
c0100314:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100317:	c9                   	leave  
c0100318:	c3                   	ret    

c0100319 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100319:	55                   	push   %ebp
c010031a:	89 e5                	mov    %esp,%ebp
c010031c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c010031f:	e8 22 13 00 00       	call   c0101646 <cons_getc>
c0100324:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100327:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010032b:	74 f2                	je     c010031f <getchar+0x6>
        /* do nothing */;
    return c;
c010032d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100330:	c9                   	leave  
c0100331:	c3                   	ret    

c0100332 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100332:	55                   	push   %ebp
c0100333:	89 e5                	mov    %esp,%ebp
c0100335:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100338:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010033c:	74 13                	je     c0100351 <readline+0x1f>
        cprintf("%s", prompt);
c010033e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100341:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100345:	c7 04 24 27 62 10 c0 	movl   $0xc0106227,(%esp)
c010034c:	e8 40 ff ff ff       	call   c0100291 <cprintf>
    }
    int i = 0, c;
c0100351:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100358:	e8 bc ff ff ff       	call   c0100319 <getchar>
c010035d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100360:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100364:	79 07                	jns    c010036d <readline+0x3b>
            return NULL;
c0100366:	b8 00 00 00 00       	mov    $0x0,%eax
c010036b:	eb 79                	jmp    c01003e6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010036d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100371:	7e 28                	jle    c010039b <readline+0x69>
c0100373:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010037a:	7f 1f                	jg     c010039b <readline+0x69>
            cputchar(c);
c010037c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010037f:	89 04 24             	mov    %eax,(%esp)
c0100382:	e8 30 ff ff ff       	call   c01002b7 <cputchar>
            buf[i ++] = c;
c0100387:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010038a:	8d 50 01             	lea    0x1(%eax),%edx
c010038d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100390:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100393:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c0100399:	eb 46                	jmp    c01003e1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010039b:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c010039f:	75 17                	jne    c01003b8 <readline+0x86>
c01003a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003a5:	7e 11                	jle    c01003b8 <readline+0x86>
            cputchar(c);
c01003a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003aa:	89 04 24             	mov    %eax,(%esp)
c01003ad:	e8 05 ff ff ff       	call   c01002b7 <cputchar>
            i --;
c01003b2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01003b6:	eb 29                	jmp    c01003e1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01003b8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003bc:	74 06                	je     c01003c4 <readline+0x92>
c01003be:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003c2:	75 1d                	jne    c01003e1 <readline+0xaf>
            cputchar(c);
c01003c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003c7:	89 04 24             	mov    %eax,(%esp)
c01003ca:	e8 e8 fe ff ff       	call   c01002b7 <cputchar>
            buf[i] = '\0';
c01003cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003d2:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01003d7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003da:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01003df:	eb 05                	jmp    c01003e6 <readline+0xb4>
        }
    }
c01003e1:	e9 72 ff ff ff       	jmp    c0100358 <readline+0x26>
}
c01003e6:	c9                   	leave  
c01003e7:	c3                   	ret    

c01003e8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003e8:	55                   	push   %ebp
c01003e9:	89 e5                	mov    %esp,%ebp
c01003eb:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c01003ee:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c01003f3:	85 c0                	test   %eax,%eax
c01003f5:	74 02                	je     c01003f9 <__panic+0x11>
        goto panic_dead;
c01003f7:	eb 48                	jmp    c0100441 <__panic+0x59>
    }
    is_panic = 1;
c01003f9:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100400:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100403:	8d 45 14             	lea    0x14(%ebp),%eax
c0100406:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100409:	8b 45 0c             	mov    0xc(%ebp),%eax
c010040c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100410:	8b 45 08             	mov    0x8(%ebp),%eax
c0100413:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100417:	c7 04 24 2a 62 10 c0 	movl   $0xc010622a,(%esp)
c010041e:	e8 6e fe ff ff       	call   c0100291 <cprintf>
    vcprintf(fmt, ap);
c0100423:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100426:	89 44 24 04          	mov    %eax,0x4(%esp)
c010042a:	8b 45 10             	mov    0x10(%ebp),%eax
c010042d:	89 04 24             	mov    %eax,(%esp)
c0100430:	e8 29 fe ff ff       	call   c010025e <vcprintf>
    cprintf("\n");
c0100435:	c7 04 24 46 62 10 c0 	movl   $0xc0106246,(%esp)
c010043c:	e8 50 fe ff ff       	call   c0100291 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100441:	e8 36 14 00 00       	call   c010187c <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100446:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010044d:	e8 61 08 00 00       	call   c0100cb3 <kmonitor>
    }
c0100452:	eb f2                	jmp    c0100446 <__panic+0x5e>

c0100454 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100454:	55                   	push   %ebp
c0100455:	89 e5                	mov    %esp,%ebp
c0100457:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c010045a:	8d 45 14             	lea    0x14(%ebp),%eax
c010045d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100460:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100463:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100467:	8b 45 08             	mov    0x8(%ebp),%eax
c010046a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010046e:	c7 04 24 48 62 10 c0 	movl   $0xc0106248,(%esp)
c0100475:	e8 17 fe ff ff       	call   c0100291 <cprintf>
    vcprintf(fmt, ap);
c010047a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010047d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100481:	8b 45 10             	mov    0x10(%ebp),%eax
c0100484:	89 04 24             	mov    %eax,(%esp)
c0100487:	e8 d2 fd ff ff       	call   c010025e <vcprintf>
    cprintf("\n");
c010048c:	c7 04 24 46 62 10 c0 	movl   $0xc0106246,(%esp)
c0100493:	e8 f9 fd ff ff       	call   c0100291 <cprintf>
    va_end(ap);
}
c0100498:	c9                   	leave  
c0100499:	c3                   	ret    

c010049a <is_kernel_panic>:

bool
is_kernel_panic(void) {
c010049a:	55                   	push   %ebp
c010049b:	89 e5                	mov    %esp,%ebp
    return is_panic;
c010049d:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c01004a2:	5d                   	pop    %ebp
c01004a3:	c3                   	ret    

c01004a4 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004a4:	55                   	push   %ebp
c01004a5:	89 e5                	mov    %esp,%ebp
c01004a7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ad:	8b 00                	mov    (%eax),%eax
c01004af:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b5:	8b 00                	mov    (%eax),%eax
c01004b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004c1:	e9 d2 00 00 00       	jmp    c0100598 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004cc:	01 d0                	add    %edx,%eax
c01004ce:	89 c2                	mov    %eax,%edx
c01004d0:	c1 ea 1f             	shr    $0x1f,%edx
c01004d3:	01 d0                	add    %edx,%eax
c01004d5:	d1 f8                	sar    %eax
c01004d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004dd:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004e0:	eb 04                	jmp    c01004e6 <stab_binsearch+0x42>
            m --;
c01004e2:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c01004e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004ec:	7c 1f                	jl     c010050d <stab_binsearch+0x69>
c01004ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004f1:	89 d0                	mov    %edx,%eax
c01004f3:	01 c0                	add    %eax,%eax
c01004f5:	01 d0                	add    %edx,%eax
c01004f7:	c1 e0 02             	shl    $0x2,%eax
c01004fa:	89 c2                	mov    %eax,%edx
c01004fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ff:	01 d0                	add    %edx,%eax
c0100501:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100505:	0f b6 c0             	movzbl %al,%eax
c0100508:	3b 45 14             	cmp    0x14(%ebp),%eax
c010050b:	75 d5                	jne    c01004e2 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c010050d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100510:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100513:	7d 0b                	jge    c0100520 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100515:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100518:	83 c0 01             	add    $0x1,%eax
c010051b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010051e:	eb 78                	jmp    c0100598 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100520:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100527:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010052a:	89 d0                	mov    %edx,%eax
c010052c:	01 c0                	add    %eax,%eax
c010052e:	01 d0                	add    %edx,%eax
c0100530:	c1 e0 02             	shl    $0x2,%eax
c0100533:	89 c2                	mov    %eax,%edx
c0100535:	8b 45 08             	mov    0x8(%ebp),%eax
c0100538:	01 d0                	add    %edx,%eax
c010053a:	8b 40 08             	mov    0x8(%eax),%eax
c010053d:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100540:	73 13                	jae    c0100555 <stab_binsearch+0xb1>
            *region_left = m;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100548:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010054a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010054d:	83 c0 01             	add    $0x1,%eax
c0100550:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100553:	eb 43                	jmp    c0100598 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100555:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100558:	89 d0                	mov    %edx,%eax
c010055a:	01 c0                	add    %eax,%eax
c010055c:	01 d0                	add    %edx,%eax
c010055e:	c1 e0 02             	shl    $0x2,%eax
c0100561:	89 c2                	mov    %eax,%edx
c0100563:	8b 45 08             	mov    0x8(%ebp),%eax
c0100566:	01 d0                	add    %edx,%eax
c0100568:	8b 40 08             	mov    0x8(%eax),%eax
c010056b:	3b 45 18             	cmp    0x18(%ebp),%eax
c010056e:	76 16                	jbe    c0100586 <stab_binsearch+0xe2>
            *region_right = m - 1;
c0100570:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100573:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100576:	8b 45 10             	mov    0x10(%ebp),%eax
c0100579:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c010057b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010057e:	83 e8 01             	sub    $0x1,%eax
c0100581:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100584:	eb 12                	jmp    c0100598 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c0100586:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100589:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010058c:	89 10                	mov    %edx,(%eax)
            l = m;
c010058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100591:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c0100594:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c0100598:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010059b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c010059e:	0f 8e 22 ff ff ff    	jle    c01004c6 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01005a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005a8:	75 0f                	jne    c01005b9 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ad:	8b 00                	mov    (%eax),%eax
c01005af:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01005b5:	89 10                	mov    %edx,(%eax)
c01005b7:	eb 3f                	jmp    c01005f8 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01005bc:	8b 00                	mov    (%eax),%eax
c01005be:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005c1:	eb 04                	jmp    c01005c7 <stab_binsearch+0x123>
c01005c3:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ca:	8b 00                	mov    (%eax),%eax
c01005cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005cf:	7d 1f                	jge    c01005f0 <stab_binsearch+0x14c>
c01005d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005d4:	89 d0                	mov    %edx,%eax
c01005d6:	01 c0                	add    %eax,%eax
c01005d8:	01 d0                	add    %edx,%eax
c01005da:	c1 e0 02             	shl    $0x2,%eax
c01005dd:	89 c2                	mov    %eax,%edx
c01005df:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e2:	01 d0                	add    %edx,%eax
c01005e4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005e8:	0f b6 c0             	movzbl %al,%eax
c01005eb:	3b 45 14             	cmp    0x14(%ebp),%eax
c01005ee:	75 d3                	jne    c01005c3 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c01005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005f6:	89 10                	mov    %edx,(%eax)
    }
}
c01005f8:	c9                   	leave  
c01005f9:	c3                   	ret    

c01005fa <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c01005fa:	55                   	push   %ebp
c01005fb:	89 e5                	mov    %esp,%ebp
c01005fd:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100600:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100603:	c7 00 68 62 10 c0    	movl   $0xc0106268,(%eax)
    info->eip_line = 0;
c0100609:	8b 45 0c             	mov    0xc(%ebp),%eax
c010060c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100613:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100616:	c7 40 08 68 62 10 c0 	movl   $0xc0106268,0x8(%eax)
    info->eip_fn_namelen = 9;
c010061d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100620:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100627:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062a:	8b 55 08             	mov    0x8(%ebp),%edx
c010062d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100630:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100633:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010063a:	c7 45 f4 b8 74 10 c0 	movl   $0xc01074b8,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100641:	c7 45 f0 e0 21 11 c0 	movl   $0xc01121e0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100648:	c7 45 ec e1 21 11 c0 	movl   $0xc01121e1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010064f:	c7 45 e8 26 4c 11 c0 	movl   $0xc0114c26,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100656:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100659:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010065c:	76 0d                	jbe    c010066b <debuginfo_eip+0x71>
c010065e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100661:	83 e8 01             	sub    $0x1,%eax
c0100664:	0f b6 00             	movzbl (%eax),%eax
c0100667:	84 c0                	test   %al,%al
c0100669:	74 0a                	je     c0100675 <debuginfo_eip+0x7b>
        return -1;
c010066b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100670:	e9 c0 02 00 00       	jmp    c0100935 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100675:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c010067c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010067f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100682:	29 c2                	sub    %eax,%edx
c0100684:	89 d0                	mov    %edx,%eax
c0100686:	c1 f8 02             	sar    $0x2,%eax
c0100689:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c010068f:	83 e8 01             	sub    $0x1,%eax
c0100692:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c0100695:	8b 45 08             	mov    0x8(%ebp),%eax
c0100698:	89 44 24 10          	mov    %eax,0x10(%esp)
c010069c:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006a3:	00 
c01006a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006a7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b5:	89 04 24             	mov    %eax,(%esp)
c01006b8:	e8 e7 fd ff ff       	call   c01004a4 <stab_binsearch>
    if (lfile == 0)
c01006bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006c0:	85 c0                	test   %eax,%eax
c01006c2:	75 0a                	jne    c01006ce <debuginfo_eip+0xd4>
        return -1;
c01006c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006c9:	e9 67 02 00 00       	jmp    c0100935 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006da:	8b 45 08             	mov    0x8(%ebp),%eax
c01006dd:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006e1:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c01006e8:	00 
c01006e9:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006ec:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006f0:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006fa:	89 04 24             	mov    %eax,(%esp)
c01006fd:	e8 a2 fd ff ff       	call   c01004a4 <stab_binsearch>

    if (lfun <= rfun) {
c0100702:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100705:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100708:	39 c2                	cmp    %eax,%edx
c010070a:	7f 7c                	jg     c0100788 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010070c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010070f:	89 c2                	mov    %eax,%edx
c0100711:	89 d0                	mov    %edx,%eax
c0100713:	01 c0                	add    %eax,%eax
c0100715:	01 d0                	add    %edx,%eax
c0100717:	c1 e0 02             	shl    $0x2,%eax
c010071a:	89 c2                	mov    %eax,%edx
c010071c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071f:	01 d0                	add    %edx,%eax
c0100721:	8b 10                	mov    (%eax),%edx
c0100723:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100726:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100729:	29 c1                	sub    %eax,%ecx
c010072b:	89 c8                	mov    %ecx,%eax
c010072d:	39 c2                	cmp    %eax,%edx
c010072f:	73 22                	jae    c0100753 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100731:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100734:	89 c2                	mov    %eax,%edx
c0100736:	89 d0                	mov    %edx,%eax
c0100738:	01 c0                	add    %eax,%eax
c010073a:	01 d0                	add    %edx,%eax
c010073c:	c1 e0 02             	shl    $0x2,%eax
c010073f:	89 c2                	mov    %eax,%edx
c0100741:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100744:	01 d0                	add    %edx,%eax
c0100746:	8b 10                	mov    (%eax),%edx
c0100748:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010074b:	01 c2                	add    %eax,%edx
c010074d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100750:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100753:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100756:	89 c2                	mov    %eax,%edx
c0100758:	89 d0                	mov    %edx,%eax
c010075a:	01 c0                	add    %eax,%eax
c010075c:	01 d0                	add    %edx,%eax
c010075e:	c1 e0 02             	shl    $0x2,%eax
c0100761:	89 c2                	mov    %eax,%edx
c0100763:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100766:	01 d0                	add    %edx,%eax
c0100768:	8b 50 08             	mov    0x8(%eax),%edx
c010076b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010076e:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100771:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100774:	8b 40 10             	mov    0x10(%eax),%eax
c0100777:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c010077a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010077d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100780:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100783:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0100786:	eb 15                	jmp    c010079d <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100788:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078b:	8b 55 08             	mov    0x8(%ebp),%edx
c010078e:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c0100791:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100794:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100797:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010079a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c010079d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a0:	8b 40 08             	mov    0x8(%eax),%eax
c01007a3:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007aa:	00 
c01007ab:	89 04 24             	mov    %eax,(%esp)
c01007ae:	e8 2a 50 00 00       	call   c01057dd <strfind>
c01007b3:	89 c2                	mov    %eax,%edx
c01007b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007b8:	8b 40 08             	mov    0x8(%eax),%eax
c01007bb:	29 c2                	sub    %eax,%edx
c01007bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c0:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01007c6:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007ca:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007d1:	00 
c01007d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007d5:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007d9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01007e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e3:	89 04 24             	mov    %eax,(%esp)
c01007e6:	e8 b9 fc ff ff       	call   c01004a4 <stab_binsearch>
    if (lline <= rline) {
c01007eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007f1:	39 c2                	cmp    %eax,%edx
c01007f3:	7f 24                	jg     c0100819 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c01007f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007f8:	89 c2                	mov    %eax,%edx
c01007fa:	89 d0                	mov    %edx,%eax
c01007fc:	01 c0                	add    %eax,%eax
c01007fe:	01 d0                	add    %edx,%eax
c0100800:	c1 e0 02             	shl    $0x2,%eax
c0100803:	89 c2                	mov    %eax,%edx
c0100805:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100808:	01 d0                	add    %edx,%eax
c010080a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010080e:	0f b7 d0             	movzwl %ax,%edx
c0100811:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100814:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100817:	eb 13                	jmp    c010082c <debuginfo_eip+0x232>
        return -1;
c0100819:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010081e:	e9 12 01 00 00       	jmp    c0100935 <debuginfo_eip+0x33b>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100823:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100826:	83 e8 01             	sub    $0x1,%eax
c0100829:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c010082c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010082f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100832:	39 c2                	cmp    %eax,%edx
c0100834:	7c 56                	jl     c010088c <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c0100836:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100839:	89 c2                	mov    %eax,%edx
c010083b:	89 d0                	mov    %edx,%eax
c010083d:	01 c0                	add    %eax,%eax
c010083f:	01 d0                	add    %edx,%eax
c0100841:	c1 e0 02             	shl    $0x2,%eax
c0100844:	89 c2                	mov    %eax,%edx
c0100846:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100849:	01 d0                	add    %edx,%eax
c010084b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010084f:	3c 84                	cmp    $0x84,%al
c0100851:	74 39                	je     c010088c <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100856:	89 c2                	mov    %eax,%edx
c0100858:	89 d0                	mov    %edx,%eax
c010085a:	01 c0                	add    %eax,%eax
c010085c:	01 d0                	add    %edx,%eax
c010085e:	c1 e0 02             	shl    $0x2,%eax
c0100861:	89 c2                	mov    %eax,%edx
c0100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100866:	01 d0                	add    %edx,%eax
c0100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010086c:	3c 64                	cmp    $0x64,%al
c010086e:	75 b3                	jne    c0100823 <debuginfo_eip+0x229>
c0100870:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100873:	89 c2                	mov    %eax,%edx
c0100875:	89 d0                	mov    %edx,%eax
c0100877:	01 c0                	add    %eax,%eax
c0100879:	01 d0                	add    %edx,%eax
c010087b:	c1 e0 02             	shl    $0x2,%eax
c010087e:	89 c2                	mov    %eax,%edx
c0100880:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100883:	01 d0                	add    %edx,%eax
c0100885:	8b 40 08             	mov    0x8(%eax),%eax
c0100888:	85 c0                	test   %eax,%eax
c010088a:	74 97                	je     c0100823 <debuginfo_eip+0x229>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c010088c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010088f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100892:	39 c2                	cmp    %eax,%edx
c0100894:	7c 46                	jl     c01008dc <debuginfo_eip+0x2e2>
c0100896:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100899:	89 c2                	mov    %eax,%edx
c010089b:	89 d0                	mov    %edx,%eax
c010089d:	01 c0                	add    %eax,%eax
c010089f:	01 d0                	add    %edx,%eax
c01008a1:	c1 e0 02             	shl    $0x2,%eax
c01008a4:	89 c2                	mov    %eax,%edx
c01008a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a9:	01 d0                	add    %edx,%eax
c01008ab:	8b 10                	mov    (%eax),%edx
c01008ad:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008b3:	29 c1                	sub    %eax,%ecx
c01008b5:	89 c8                	mov    %ecx,%eax
c01008b7:	39 c2                	cmp    %eax,%edx
c01008b9:	73 21                	jae    c01008dc <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008be:	89 c2                	mov    %eax,%edx
c01008c0:	89 d0                	mov    %edx,%eax
c01008c2:	01 c0                	add    %eax,%eax
c01008c4:	01 d0                	add    %edx,%eax
c01008c6:	c1 e0 02             	shl    $0x2,%eax
c01008c9:	89 c2                	mov    %eax,%edx
c01008cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ce:	01 d0                	add    %edx,%eax
c01008d0:	8b 10                	mov    (%eax),%edx
c01008d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008d5:	01 c2                	add    %eax,%edx
c01008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008da:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008df:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008e2:	39 c2                	cmp    %eax,%edx
c01008e4:	7d 4a                	jge    c0100930 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c01008e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008e9:	83 c0 01             	add    $0x1,%eax
c01008ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008ef:	eb 18                	jmp    c0100909 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f4:	8b 40 14             	mov    0x14(%eax),%eax
c01008f7:	8d 50 01             	lea    0x1(%eax),%edx
c01008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008fd:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100900:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100903:	83 c0 01             	add    $0x1,%eax
c0100906:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100909:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010090c:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c010090f:	39 c2                	cmp    %eax,%edx
c0100911:	7d 1d                	jge    c0100930 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100913:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100916:	89 c2                	mov    %eax,%edx
c0100918:	89 d0                	mov    %edx,%eax
c010091a:	01 c0                	add    %eax,%eax
c010091c:	01 d0                	add    %edx,%eax
c010091e:	c1 e0 02             	shl    $0x2,%eax
c0100921:	89 c2                	mov    %eax,%edx
c0100923:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100926:	01 d0                	add    %edx,%eax
c0100928:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010092c:	3c a0                	cmp    $0xa0,%al
c010092e:	74 c1                	je     c01008f1 <debuginfo_eip+0x2f7>
        }
    }
    return 0;
c0100930:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100935:	c9                   	leave  
c0100936:	c3                   	ret    

c0100937 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100937:	55                   	push   %ebp
c0100938:	89 e5                	mov    %esp,%ebp
c010093a:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010093d:	c7 04 24 72 62 10 c0 	movl   $0xc0106272,(%esp)
c0100944:	e8 48 f9 ff ff       	call   c0100291 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100949:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100950:	c0 
c0100951:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0100958:	e8 34 f9 ff ff       	call   c0100291 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010095d:	c7 44 24 04 73 61 10 	movl   $0xc0106173,0x4(%esp)
c0100964:	c0 
c0100965:	c7 04 24 a3 62 10 c0 	movl   $0xc01062a3,(%esp)
c010096c:	e8 20 f9 ff ff       	call   c0100291 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100971:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c0100978:	c0 
c0100979:	c7 04 24 bb 62 10 c0 	movl   $0xc01062bb,(%esp)
c0100980:	e8 0c f9 ff ff       	call   c0100291 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c0100985:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c010098c:	c0 
c010098d:	c7 04 24 d3 62 10 c0 	movl   $0xc01062d3,(%esp)
c0100994:	e8 f8 f8 ff ff       	call   c0100291 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c0100999:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c010099e:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009a4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01009a9:	29 c2                	sub    %eax,%edx
c01009ab:	89 d0                	mov    %edx,%eax
c01009ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009b3:	85 c0                	test   %eax,%eax
c01009b5:	0f 48 c2             	cmovs  %edx,%eax
c01009b8:	c1 f8 0a             	sar    $0xa,%eax
c01009bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009bf:	c7 04 24 ec 62 10 c0 	movl   $0xc01062ec,(%esp)
c01009c6:	e8 c6 f8 ff ff       	call   c0100291 <cprintf>
}
c01009cb:	c9                   	leave  
c01009cc:	c3                   	ret    

c01009cd <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009cd:	55                   	push   %ebp
c01009ce:	89 e5                	mov    %esp,%ebp
c01009d0:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009d6:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01009e0:	89 04 24             	mov    %eax,(%esp)
c01009e3:	e8 12 fc ff ff       	call   c01005fa <debuginfo_eip>
c01009e8:	85 c0                	test   %eax,%eax
c01009ea:	74 15                	je     c0100a01 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f3:	c7 04 24 16 63 10 c0 	movl   $0xc0106316,(%esp)
c01009fa:	e8 92 f8 ff ff       	call   c0100291 <cprintf>
c01009ff:	eb 6d                	jmp    c0100a6e <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a08:	eb 1c                	jmp    c0100a26 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100a0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a10:	01 d0                	add    %edx,%eax
c0100a12:	0f b6 00             	movzbl (%eax),%eax
c0100a15:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a1e:	01 ca                	add    %ecx,%edx
c0100a20:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a2c:	7f dc                	jg     c0100a0a <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
c0100a2e:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a37:	01 d0                	add    %edx,%eax
c0100a39:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a3f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a42:	89 d1                	mov    %edx,%ecx
c0100a44:	29 c1                	sub    %eax,%ecx
c0100a46:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a49:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a4c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a50:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a56:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a5a:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a62:	c7 04 24 32 63 10 c0 	movl   $0xc0106332,(%esp)
c0100a69:	e8 23 f8 ff ff       	call   c0100291 <cprintf>
    }
}
c0100a6e:	c9                   	leave  
c0100a6f:	c3                   	ret    

c0100a70 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a70:	55                   	push   %ebp
c0100a71:	89 e5                	mov    %esp,%ebp
c0100a73:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a76:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a79:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a7f:	c9                   	leave  
c0100a80:	c3                   	ret    

c0100a81 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a81:	55                   	push   %ebp
c0100a82:	89 e5                	mov    %esp,%ebp
c0100a84:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a87:	89 e8                	mov    %ebp,%eax
c0100a89:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t v_ebp=read_ebp();
c0100a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t v_eip=read_eip();
c0100a92:	e8 d9 ff ff ff       	call   c0100a70 <read_eip>
c0100a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	for(i=0;i<STACKFRAME_DEPTH&&v_ebp!=0;++i)
c0100a9a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100aa1:	e9 8f 00 00 00       	jmp    c0100b35 <print_stackframe+0xb4>
	{
		cprintf("ebp: 0x%08x , eip: 0x%08x , ",v_ebp,v_eip);
c0100aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100aa9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab4:	c7 04 24 44 63 10 c0 	movl   $0xc0106344,(%esp)
c0100abb:	e8 d1 f7 ff ff       	call   c0100291 <cprintf>
		uint32_t *args=(uint32_t *)v_ebp +2;
c0100ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ac3:	83 c0 08             	add    $0x8,%eax
c0100ac6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int j;
		for(j=0;j<4;++j)
c0100ac9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100ad0:	eb 2c                	jmp    c0100afe <print_stackframe+0x7d>
		{
			cprintf("args[%d] = 0x%08x   ",j,args[j]);
c0100ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100ad5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100adc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100adf:	01 d0                	add    %edx,%eax
c0100ae1:	8b 00                	mov    (%eax),%eax
c0100ae3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100aea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aee:	c7 04 24 61 63 10 c0 	movl   $0xc0106361,(%esp)
c0100af5:	e8 97 f7 ff ff       	call   c0100291 <cprintf>
		for(j=0;j<4;++j)
c0100afa:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100afe:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b02:	7e ce                	jle    c0100ad2 <print_stackframe+0x51>
		}
		cprintf("\n");
c0100b04:	c7 04 24 76 63 10 c0 	movl   $0xc0106376,(%esp)
c0100b0b:	e8 81 f7 ff ff       	call   c0100291 <cprintf>
		print_debuginfo(v_eip-1);
c0100b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b13:	83 e8 01             	sub    $0x1,%eax
c0100b16:	89 04 24             	mov    %eax,(%esp)
c0100b19:	e8 af fe ff ff       	call   c01009cd <print_debuginfo>
		v_eip=((uint32_t *)v_ebp)[1];
c0100b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b21:	83 c0 04             	add    $0x4,%eax
c0100b24:	8b 00                	mov    (%eax),%eax
c0100b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
		v_ebp=((uint32_t *)v_ebp)[0];
c0100b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b2c:	8b 00                	mov    (%eax),%eax
c0100b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(i=0;i<STACKFRAME_DEPTH&&v_ebp!=0;++i)
c0100b31:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b35:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b39:	7f 0a                	jg     c0100b45 <print_stackframe+0xc4>
c0100b3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b3f:	0f 85 61 ff ff ff    	jne    c0100aa6 <print_stackframe+0x25>
	}


}
c0100b45:	c9                   	leave  
c0100b46:	c3                   	ret    

c0100b47 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b47:	55                   	push   %ebp
c0100b48:	89 e5                	mov    %esp,%ebp
c0100b4a:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b54:	eb 0c                	jmp    c0100b62 <parse+0x1b>
            *buf ++ = '\0';
c0100b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b59:	8d 50 01             	lea    0x1(%eax),%edx
c0100b5c:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b5f:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b62:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b65:	0f b6 00             	movzbl (%eax),%eax
c0100b68:	84 c0                	test   %al,%al
c0100b6a:	74 1d                	je     c0100b89 <parse+0x42>
c0100b6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b6f:	0f b6 00             	movzbl (%eax),%eax
c0100b72:	0f be c0             	movsbl %al,%eax
c0100b75:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b79:	c7 04 24 f8 63 10 c0 	movl   $0xc01063f8,(%esp)
c0100b80:	e8 25 4c 00 00       	call   c01057aa <strchr>
c0100b85:	85 c0                	test   %eax,%eax
c0100b87:	75 cd                	jne    c0100b56 <parse+0xf>
        }
        if (*buf == '\0') {
c0100b89:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b8c:	0f b6 00             	movzbl (%eax),%eax
c0100b8f:	84 c0                	test   %al,%al
c0100b91:	75 02                	jne    c0100b95 <parse+0x4e>
            break;
c0100b93:	eb 67                	jmp    c0100bfc <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b95:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b99:	75 14                	jne    c0100baf <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b9b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ba2:	00 
c0100ba3:	c7 04 24 fd 63 10 c0 	movl   $0xc01063fd,(%esp)
c0100baa:	e8 e2 f6 ff ff       	call   c0100291 <cprintf>
        }
        argv[argc ++] = buf;
c0100baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bb2:	8d 50 01             	lea    0x1(%eax),%edx
c0100bb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bb8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bc2:	01 c2                	add    %eax,%edx
c0100bc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bc7:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bc9:	eb 04                	jmp    c0100bcf <parse+0x88>
            buf ++;
c0100bcb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bd2:	0f b6 00             	movzbl (%eax),%eax
c0100bd5:	84 c0                	test   %al,%al
c0100bd7:	74 1d                	je     c0100bf6 <parse+0xaf>
c0100bd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bdc:	0f b6 00             	movzbl (%eax),%eax
c0100bdf:	0f be c0             	movsbl %al,%eax
c0100be2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be6:	c7 04 24 f8 63 10 c0 	movl   $0xc01063f8,(%esp)
c0100bed:	e8 b8 4b 00 00       	call   c01057aa <strchr>
c0100bf2:	85 c0                	test   %eax,%eax
c0100bf4:	74 d5                	je     c0100bcb <parse+0x84>
        }
    }
c0100bf6:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bf7:	e9 66 ff ff ff       	jmp    c0100b62 <parse+0x1b>
    return argc;
c0100bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bff:	c9                   	leave  
c0100c00:	c3                   	ret    

c0100c01 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c01:	55                   	push   %ebp
c0100c02:	89 e5                	mov    %esp,%ebp
c0100c04:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c07:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c11:	89 04 24             	mov    %eax,(%esp)
c0100c14:	e8 2e ff ff ff       	call   c0100b47 <parse>
c0100c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c20:	75 0a                	jne    c0100c2c <runcmd+0x2b>
        return 0;
c0100c22:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c27:	e9 85 00 00 00       	jmp    c0100cb1 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c33:	eb 5c                	jmp    c0100c91 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c35:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c3b:	89 d0                	mov    %edx,%eax
c0100c3d:	01 c0                	add    %eax,%eax
c0100c3f:	01 d0                	add    %edx,%eax
c0100c41:	c1 e0 02             	shl    $0x2,%eax
c0100c44:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c49:	8b 00                	mov    (%eax),%eax
c0100c4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c4f:	89 04 24             	mov    %eax,(%esp)
c0100c52:	e8 b4 4a 00 00       	call   c010570b <strcmp>
c0100c57:	85 c0                	test   %eax,%eax
c0100c59:	75 32                	jne    c0100c8d <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5e:	89 d0                	mov    %edx,%eax
c0100c60:	01 c0                	add    %eax,%eax
c0100c62:	01 d0                	add    %edx,%eax
c0100c64:	c1 e0 02             	shl    $0x2,%eax
c0100c67:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c6c:	8b 40 08             	mov    0x8(%eax),%eax
c0100c6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100c72:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100c75:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100c78:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100c7c:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100c7f:	83 c2 04             	add    $0x4,%edx
c0100c82:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100c86:	89 0c 24             	mov    %ecx,(%esp)
c0100c89:	ff d0                	call   *%eax
c0100c8b:	eb 24                	jmp    c0100cb1 <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c8d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c94:	83 f8 02             	cmp    $0x2,%eax
c0100c97:	76 9c                	jbe    c0100c35 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c99:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca0:	c7 04 24 1b 64 10 c0 	movl   $0xc010641b,(%esp)
c0100ca7:	e8 e5 f5 ff ff       	call   c0100291 <cprintf>
    return 0;
c0100cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb1:	c9                   	leave  
c0100cb2:	c3                   	ret    

c0100cb3 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cb3:	55                   	push   %ebp
c0100cb4:	89 e5                	mov    %esp,%ebp
c0100cb6:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cb9:	c7 04 24 34 64 10 c0 	movl   $0xc0106434,(%esp)
c0100cc0:	e8 cc f5 ff ff       	call   c0100291 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100cc5:	c7 04 24 5c 64 10 c0 	movl   $0xc010645c,(%esp)
c0100ccc:	e8 c0 f5 ff ff       	call   c0100291 <cprintf>

    if (tf != NULL) {
c0100cd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cd5:	74 0b                	je     c0100ce2 <kmonitor+0x2f>
        print_trapframe(tf);
c0100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cda:	89 04 24             	mov    %eax,(%esp)
c0100cdd:	e8 1e 0e 00 00       	call   c0101b00 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100ce2:	c7 04 24 81 64 10 c0 	movl   $0xc0106481,(%esp)
c0100ce9:	e8 44 f6 ff ff       	call   c0100332 <readline>
c0100cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cf5:	74 18                	je     c0100d0f <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100cf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d01:	89 04 24             	mov    %eax,(%esp)
c0100d04:	e8 f8 fe ff ff       	call   c0100c01 <runcmd>
c0100d09:	85 c0                	test   %eax,%eax
c0100d0b:	79 02                	jns    c0100d0f <kmonitor+0x5c>
                break;
c0100d0d:	eb 02                	jmp    c0100d11 <kmonitor+0x5e>
            }
        }
    }
c0100d0f:	eb d1                	jmp    c0100ce2 <kmonitor+0x2f>
}
c0100d11:	c9                   	leave  
c0100d12:	c3                   	ret    

c0100d13 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d13:	55                   	push   %ebp
c0100d14:	89 e5                	mov    %esp,%ebp
c0100d16:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d20:	eb 3f                	jmp    c0100d61 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d22:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d25:	89 d0                	mov    %edx,%eax
c0100d27:	01 c0                	add    %eax,%eax
c0100d29:	01 d0                	add    %edx,%eax
c0100d2b:	c1 e0 02             	shl    $0x2,%eax
c0100d2e:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100d33:	8b 48 04             	mov    0x4(%eax),%ecx
c0100d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d39:	89 d0                	mov    %edx,%eax
c0100d3b:	01 c0                	add    %eax,%eax
c0100d3d:	01 d0                	add    %edx,%eax
c0100d3f:	c1 e0 02             	shl    $0x2,%eax
c0100d42:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100d47:	8b 00                	mov    (%eax),%eax
c0100d49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d51:	c7 04 24 85 64 10 c0 	movl   $0xc0106485,(%esp)
c0100d58:	e8 34 f5 ff ff       	call   c0100291 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d5d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d64:	83 f8 02             	cmp    $0x2,%eax
c0100d67:	76 b9                	jbe    c0100d22 <mon_help+0xf>
    }
    return 0;
c0100d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d6e:	c9                   	leave  
c0100d6f:	c3                   	ret    

c0100d70 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d70:	55                   	push   %ebp
c0100d71:	89 e5                	mov    %esp,%ebp
c0100d73:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d76:	e8 bc fb ff ff       	call   c0100937 <print_kerninfo>
    return 0;
c0100d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d80:	c9                   	leave  
c0100d81:	c3                   	ret    

c0100d82 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d82:	55                   	push   %ebp
c0100d83:	89 e5                	mov    %esp,%ebp
c0100d85:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d88:	e8 f4 fc ff ff       	call   c0100a81 <print_stackframe>
    return 0;
c0100d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d92:	c9                   	leave  
c0100d93:	c3                   	ret    

c0100d94 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d94:	55                   	push   %ebp
c0100d95:	89 e5                	mov    %esp,%ebp
c0100d97:	83 ec 28             	sub    $0x28,%esp
c0100d9a:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100da0:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100da8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dac:	ee                   	out    %al,(%dx)
c0100dad:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100db7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dbb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dbf:	ee                   	out    %al,(%dx)
c0100dc0:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dc6:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dca:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dce:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd3:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dda:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100ddd:	c7 04 24 8e 64 10 c0 	movl   $0xc010648e,(%esp)
c0100de4:	e8 a8 f4 ff ff       	call   c0100291 <cprintf>
    pic_enable(IRQ_TIMER);
c0100de9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100df0:	e8 18 09 00 00       	call   c010170d <pic_enable>
}
c0100df5:	c9                   	leave  
c0100df6:	c3                   	ret    

c0100df7 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100df7:	55                   	push   %ebp
c0100df8:	89 e5                	mov    %esp,%ebp
c0100dfa:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dfd:	9c                   	pushf  
c0100dfe:	58                   	pop    %eax
c0100dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e05:	25 00 02 00 00       	and    $0x200,%eax
c0100e0a:	85 c0                	test   %eax,%eax
c0100e0c:	74 0c                	je     c0100e1a <__intr_save+0x23>
        intr_disable();
c0100e0e:	e8 69 0a 00 00       	call   c010187c <intr_disable>
        return 1;
c0100e13:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e18:	eb 05                	jmp    c0100e1f <__intr_save+0x28>
    }
    return 0;
c0100e1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e1f:	c9                   	leave  
c0100e20:	c3                   	ret    

c0100e21 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e21:	55                   	push   %ebp
c0100e22:	89 e5                	mov    %esp,%ebp
c0100e24:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e2b:	74 05                	je     c0100e32 <__intr_restore+0x11>
        intr_enable();
c0100e2d:	e8 44 0a 00 00       	call   c0101876 <intr_enable>
    }
}
c0100e32:	c9                   	leave  
c0100e33:	c3                   	ret    

c0100e34 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e34:	55                   	push   %ebp
c0100e35:	89 e5                	mov    %esp,%ebp
c0100e37:	83 ec 10             	sub    $0x10,%esp
c0100e3a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e40:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e44:	89 c2                	mov    %eax,%edx
c0100e46:	ec                   	in     (%dx),%al
c0100e47:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e4a:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e50:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e54:	89 c2                	mov    %eax,%edx
c0100e56:	ec                   	in     (%dx),%al
c0100e57:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e5a:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e60:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e64:	89 c2                	mov    %eax,%edx
c0100e66:	ec                   	in     (%dx),%al
c0100e67:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e6a:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e70:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e74:	89 c2                	mov    %eax,%edx
c0100e76:	ec                   	in     (%dx),%al
c0100e77:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e7a:	c9                   	leave  
c0100e7b:	c3                   	ret    

c0100e7c <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e7c:	55                   	push   %ebp
c0100e7d:	89 e5                	mov    %esp,%ebp
c0100e7f:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e82:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8c:	0f b7 00             	movzwl (%eax),%eax
c0100e8f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e96:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9e:	0f b7 00             	movzwl (%eax),%eax
c0100ea1:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ea5:	74 12                	je     c0100eb9 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ea7:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eae:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100eb5:	b4 03 
c0100eb7:	eb 13                	jmp    c0100ecc <cga_init+0x50>
    } else {
        *cp = was;
c0100eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ebc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ec0:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec3:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100eca:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ecc:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ed3:	0f b7 c0             	movzwl %ax,%eax
c0100ed6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100eda:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ede:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ee2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ee6:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ee7:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100eee:	83 c0 01             	add    $0x1,%eax
c0100ef1:	0f b7 c0             	movzwl %ax,%eax
c0100ef4:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ef8:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100efc:	89 c2                	mov    %eax,%edx
c0100efe:	ec                   	in     (%dx),%al
c0100eff:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f02:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f06:	0f b6 c0             	movzbl %al,%eax
c0100f09:	c1 e0 08             	shl    $0x8,%eax
c0100f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f0f:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f16:	0f b7 c0             	movzwl %ax,%eax
c0100f19:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f1d:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f21:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f25:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f29:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f2a:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f31:	83 c0 01             	add    $0x1,%eax
c0100f34:	0f b7 c0             	movzwl %ax,%eax
c0100f37:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f3b:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f3f:	89 c2                	mov    %eax,%edx
c0100f41:	ec                   	in     (%dx),%al
c0100f42:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f45:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f49:	0f b6 c0             	movzbl %al,%eax
c0100f4c:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f52:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f5a:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f60:	c9                   	leave  
c0100f61:	c3                   	ret    

c0100f62 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f62:	55                   	push   %ebp
c0100f63:	89 e5                	mov    %esp,%ebp
c0100f65:	83 ec 48             	sub    $0x48,%esp
c0100f68:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f6e:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f72:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f76:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f7a:	ee                   	out    %al,(%dx)
c0100f7b:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f81:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f85:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f89:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f8d:	ee                   	out    %al,(%dx)
c0100f8e:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f94:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f98:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f9c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fa0:	ee                   	out    %al,(%dx)
c0100fa1:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fa7:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fab:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100faf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb3:	ee                   	out    %al,(%dx)
c0100fb4:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fba:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fbe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fc2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fc6:	ee                   	out    %al,(%dx)
c0100fc7:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fcd:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fd1:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fd5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fd9:	ee                   	out    %al,(%dx)
c0100fda:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe0:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe4:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fe8:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fec:	ee                   	out    %al,(%dx)
c0100fed:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff3:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ff7:	89 c2                	mov    %eax,%edx
c0100ff9:	ec                   	in     (%dx),%al
c0100ffa:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ffd:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101001:	3c ff                	cmp    $0xff,%al
c0101003:	0f 95 c0             	setne  %al
c0101006:	0f b6 c0             	movzbl %al,%eax
c0101009:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c010100e:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101014:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101018:	89 c2                	mov    %eax,%edx
c010101a:	ec                   	in     (%dx),%al
c010101b:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010101e:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101024:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101028:	89 c2                	mov    %eax,%edx
c010102a:	ec                   	in     (%dx),%al
c010102b:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010102e:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101033:	85 c0                	test   %eax,%eax
c0101035:	74 0c                	je     c0101043 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101037:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010103e:	e8 ca 06 00 00       	call   c010170d <pic_enable>
    }
}
c0101043:	c9                   	leave  
c0101044:	c3                   	ret    

c0101045 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101045:	55                   	push   %ebp
c0101046:	89 e5                	mov    %esp,%ebp
c0101048:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101052:	eb 09                	jmp    c010105d <lpt_putc_sub+0x18>
        delay();
c0101054:	e8 db fd ff ff       	call   c0100e34 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101059:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010105d:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101063:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101067:	89 c2                	mov    %eax,%edx
c0101069:	ec                   	in     (%dx),%al
c010106a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010106d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101071:	84 c0                	test   %al,%al
c0101073:	78 09                	js     c010107e <lpt_putc_sub+0x39>
c0101075:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010107c:	7e d6                	jle    c0101054 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c010107e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101081:	0f b6 c0             	movzbl %al,%eax
c0101084:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010108a:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010108d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101091:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101095:	ee                   	out    %al,(%dx)
c0101096:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010109c:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010a0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010a8:	ee                   	out    %al,(%dx)
c01010a9:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010af:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010b7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010bb:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010bc:	c9                   	leave  
c01010bd:	c3                   	ret    

c01010be <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010be:	55                   	push   %ebp
c01010bf:	89 e5                	mov    %esp,%ebp
c01010c1:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c4:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010c8:	74 0d                	je     c01010d7 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01010cd:	89 04 24             	mov    %eax,(%esp)
c01010d0:	e8 70 ff ff ff       	call   c0101045 <lpt_putc_sub>
c01010d5:	eb 24                	jmp    c01010fb <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010d7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010de:	e8 62 ff ff ff       	call   c0101045 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010ea:	e8 56 ff ff ff       	call   c0101045 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010ef:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f6:	e8 4a ff ff ff       	call   c0101045 <lpt_putc_sub>
    }
}
c01010fb:	c9                   	leave  
c01010fc:	c3                   	ret    

c01010fd <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010fd:	55                   	push   %ebp
c01010fe:	89 e5                	mov    %esp,%ebp
c0101100:	53                   	push   %ebx
c0101101:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101104:	8b 45 08             	mov    0x8(%ebp),%eax
c0101107:	b0 00                	mov    $0x0,%al
c0101109:	85 c0                	test   %eax,%eax
c010110b:	75 07                	jne    c0101114 <cga_putc+0x17>
        c |= 0x0700;
c010110d:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101114:	8b 45 08             	mov    0x8(%ebp),%eax
c0101117:	0f b6 c0             	movzbl %al,%eax
c010111a:	83 f8 0a             	cmp    $0xa,%eax
c010111d:	74 4c                	je     c010116b <cga_putc+0x6e>
c010111f:	83 f8 0d             	cmp    $0xd,%eax
c0101122:	74 57                	je     c010117b <cga_putc+0x7e>
c0101124:	83 f8 08             	cmp    $0x8,%eax
c0101127:	0f 85 88 00 00 00    	jne    c01011b5 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010112d:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101134:	66 85 c0             	test   %ax,%ax
c0101137:	74 30                	je     c0101169 <cga_putc+0x6c>
            crt_pos --;
c0101139:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101140:	83 e8 01             	sub    $0x1,%eax
c0101143:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101149:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010114e:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101155:	0f b7 d2             	movzwl %dx,%edx
c0101158:	01 d2                	add    %edx,%edx
c010115a:	01 c2                	add    %eax,%edx
c010115c:	8b 45 08             	mov    0x8(%ebp),%eax
c010115f:	b0 00                	mov    $0x0,%al
c0101161:	83 c8 20             	or     $0x20,%eax
c0101164:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101167:	eb 72                	jmp    c01011db <cga_putc+0xde>
c0101169:	eb 70                	jmp    c01011db <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010116b:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101172:	83 c0 50             	add    $0x50,%eax
c0101175:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010117b:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101182:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101189:	0f b7 c1             	movzwl %cx,%eax
c010118c:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101192:	c1 e8 10             	shr    $0x10,%eax
c0101195:	89 c2                	mov    %eax,%edx
c0101197:	66 c1 ea 06          	shr    $0x6,%dx
c010119b:	89 d0                	mov    %edx,%eax
c010119d:	c1 e0 02             	shl    $0x2,%eax
c01011a0:	01 d0                	add    %edx,%eax
c01011a2:	c1 e0 04             	shl    $0x4,%eax
c01011a5:	29 c1                	sub    %eax,%ecx
c01011a7:	89 ca                	mov    %ecx,%edx
c01011a9:	89 d8                	mov    %ebx,%eax
c01011ab:	29 d0                	sub    %edx,%eax
c01011ad:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011b3:	eb 26                	jmp    c01011db <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011b5:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011bb:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011c2:	8d 50 01             	lea    0x1(%eax),%edx
c01011c5:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011cc:	0f b7 c0             	movzwl %ax,%eax
c01011cf:	01 c0                	add    %eax,%eax
c01011d1:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d7:	66 89 02             	mov    %ax,(%edx)
        break;
c01011da:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011db:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011e2:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011e6:	76 5b                	jbe    c0101243 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011e8:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011ed:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f3:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011f8:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011ff:	00 
c0101200:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101204:	89 04 24             	mov    %eax,(%esp)
c0101207:	e8 9c 47 00 00       	call   c01059a8 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010120c:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101213:	eb 15                	jmp    c010122a <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101215:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010121a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010121d:	01 d2                	add    %edx,%edx
c010121f:	01 d0                	add    %edx,%eax
c0101221:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101226:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010122a:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101231:	7e e2                	jle    c0101215 <cga_putc+0x118>
        }
        crt_pos -= CRT_COLS;
c0101233:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010123a:	83 e8 50             	sub    $0x50,%eax
c010123d:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101243:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010124a:	0f b7 c0             	movzwl %ax,%eax
c010124d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101251:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101255:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101259:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010125d:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010125e:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101265:	66 c1 e8 08          	shr    $0x8,%ax
c0101269:	0f b6 c0             	movzbl %al,%eax
c010126c:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101273:	83 c2 01             	add    $0x1,%edx
c0101276:	0f b7 d2             	movzwl %dx,%edx
c0101279:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010127d:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101280:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101284:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101288:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101289:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101290:	0f b7 c0             	movzwl %ax,%eax
c0101293:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101297:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c010129b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010129f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a3:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a4:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01012ab:	0f b6 c0             	movzbl %al,%eax
c01012ae:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012b5:	83 c2 01             	add    $0x1,%edx
c01012b8:	0f b7 d2             	movzwl %dx,%edx
c01012bb:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012bf:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012c2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012ca:	ee                   	out    %al,(%dx)
}
c01012cb:	83 c4 34             	add    $0x34,%esp
c01012ce:	5b                   	pop    %ebx
c01012cf:	5d                   	pop    %ebp
c01012d0:	c3                   	ret    

c01012d1 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012d1:	55                   	push   %ebp
c01012d2:	89 e5                	mov    %esp,%ebp
c01012d4:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012de:	eb 09                	jmp    c01012e9 <serial_putc_sub+0x18>
        delay();
c01012e0:	e8 4f fb ff ff       	call   c0100e34 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012e9:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012ef:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f3:	89 c2                	mov    %eax,%edx
c01012f5:	ec                   	in     (%dx),%al
c01012f6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012f9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012fd:	0f b6 c0             	movzbl %al,%eax
c0101300:	83 e0 20             	and    $0x20,%eax
c0101303:	85 c0                	test   %eax,%eax
c0101305:	75 09                	jne    c0101310 <serial_putc_sub+0x3f>
c0101307:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010130e:	7e d0                	jle    c01012e0 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101310:	8b 45 08             	mov    0x8(%ebp),%eax
c0101313:	0f b6 c0             	movzbl %al,%eax
c0101316:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010131c:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010131f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101323:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101327:	ee                   	out    %al,(%dx)
}
c0101328:	c9                   	leave  
c0101329:	c3                   	ret    

c010132a <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010132a:	55                   	push   %ebp
c010132b:	89 e5                	mov    %esp,%ebp
c010132d:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101330:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101334:	74 0d                	je     c0101343 <serial_putc+0x19>
        serial_putc_sub(c);
c0101336:	8b 45 08             	mov    0x8(%ebp),%eax
c0101339:	89 04 24             	mov    %eax,(%esp)
c010133c:	e8 90 ff ff ff       	call   c01012d1 <serial_putc_sub>
c0101341:	eb 24                	jmp    c0101367 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101343:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010134a:	e8 82 ff ff ff       	call   c01012d1 <serial_putc_sub>
        serial_putc_sub(' ');
c010134f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101356:	e8 76 ff ff ff       	call   c01012d1 <serial_putc_sub>
        serial_putc_sub('\b');
c010135b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101362:	e8 6a ff ff ff       	call   c01012d1 <serial_putc_sub>
    }
}
c0101367:	c9                   	leave  
c0101368:	c3                   	ret    

c0101369 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101369:	55                   	push   %ebp
c010136a:	89 e5                	mov    %esp,%ebp
c010136c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010136f:	eb 33                	jmp    c01013a4 <cons_intr+0x3b>
        if (c != 0) {
c0101371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101375:	74 2d                	je     c01013a4 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101377:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010137c:	8d 50 01             	lea    0x1(%eax),%edx
c010137f:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101385:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101388:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010138e:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101393:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101398:	75 0a                	jne    c01013a4 <cons_intr+0x3b>
                cons.wpos = 0;
c010139a:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c01013a1:	00 00 00 
    while ((c = (*proc)()) != -1) {
c01013a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a7:	ff d0                	call   *%eax
c01013a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013ac:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013b0:	75 bf                	jne    c0101371 <cons_intr+0x8>
            }
        }
    }
}
c01013b2:	c9                   	leave  
c01013b3:	c3                   	ret    

c01013b4 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b4:	55                   	push   %ebp
c01013b5:	89 e5                	mov    %esp,%ebp
c01013b7:	83 ec 10             	sub    $0x10,%esp
c01013ba:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c4:	89 c2                	mov    %eax,%edx
c01013c6:	ec                   	in     (%dx),%al
c01013c7:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013ca:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013ce:	0f b6 c0             	movzbl %al,%eax
c01013d1:	83 e0 01             	and    $0x1,%eax
c01013d4:	85 c0                	test   %eax,%eax
c01013d6:	75 07                	jne    c01013df <serial_proc_data+0x2b>
        return -1;
c01013d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013dd:	eb 2a                	jmp    c0101409 <serial_proc_data+0x55>
c01013df:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013e9:	89 c2                	mov    %eax,%edx
c01013eb:	ec                   	in     (%dx),%al
c01013ec:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013ef:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f3:	0f b6 c0             	movzbl %al,%eax
c01013f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013f9:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013fd:	75 07                	jne    c0101406 <serial_proc_data+0x52>
        c = '\b';
c01013ff:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101406:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101409:	c9                   	leave  
c010140a:	c3                   	ret    

c010140b <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010140b:	55                   	push   %ebp
c010140c:	89 e5                	mov    %esp,%ebp
c010140e:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101411:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101416:	85 c0                	test   %eax,%eax
c0101418:	74 0c                	je     c0101426 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010141a:	c7 04 24 b4 13 10 c0 	movl   $0xc01013b4,(%esp)
c0101421:	e8 43 ff ff ff       	call   c0101369 <cons_intr>
    }
}
c0101426:	c9                   	leave  
c0101427:	c3                   	ret    

c0101428 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101428:	55                   	push   %ebp
c0101429:	89 e5                	mov    %esp,%ebp
c010142b:	83 ec 38             	sub    $0x38,%esp
c010142e:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101434:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101438:	89 c2                	mov    %eax,%edx
c010143a:	ec                   	in     (%dx),%al
c010143b:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010143e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101442:	0f b6 c0             	movzbl %al,%eax
c0101445:	83 e0 01             	and    $0x1,%eax
c0101448:	85 c0                	test   %eax,%eax
c010144a:	75 0a                	jne    c0101456 <kbd_proc_data+0x2e>
        return -1;
c010144c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101451:	e9 59 01 00 00       	jmp    c01015af <kbd_proc_data+0x187>
c0101456:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010145c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101460:	89 c2                	mov    %eax,%edx
c0101462:	ec                   	in     (%dx),%al
c0101463:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101466:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010146a:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010146d:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101471:	75 17                	jne    c010148a <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101473:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101478:	83 c8 40             	or     $0x40,%eax
c010147b:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101480:	b8 00 00 00 00       	mov    $0x0,%eax
c0101485:	e9 25 01 00 00       	jmp    c01015af <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010148a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148e:	84 c0                	test   %al,%al
c0101490:	79 47                	jns    c01014d9 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101492:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101497:	83 e0 40             	and    $0x40,%eax
c010149a:	85 c0                	test   %eax,%eax
c010149c:	75 09                	jne    c01014a7 <kbd_proc_data+0x7f>
c010149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a2:	83 e0 7f             	and    $0x7f,%eax
c01014a5:	eb 04                	jmp    c01014ab <kbd_proc_data+0x83>
c01014a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ab:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014ae:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b2:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014b9:	83 c8 40             	or     $0x40,%eax
c01014bc:	0f b6 c0             	movzbl %al,%eax
c01014bf:	f7 d0                	not    %eax
c01014c1:	89 c2                	mov    %eax,%edx
c01014c3:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014c8:	21 d0                	and    %edx,%eax
c01014ca:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014cf:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d4:	e9 d6 00 00 00       	jmp    c01015af <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014d9:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014de:	83 e0 40             	and    $0x40,%eax
c01014e1:	85 c0                	test   %eax,%eax
c01014e3:	74 11                	je     c01014f6 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014e5:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e9:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014ee:	83 e0 bf             	and    $0xffffffbf,%eax
c01014f1:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014f6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014fa:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c0101501:	0f b6 d0             	movzbl %al,%edx
c0101504:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101509:	09 d0                	or     %edx,%eax
c010150b:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c0101510:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101514:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c010151b:	0f b6 d0             	movzbl %al,%edx
c010151e:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101523:	31 d0                	xor    %edx,%eax
c0101525:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c010152a:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010152f:	83 e0 03             	and    $0x3,%eax
c0101532:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101539:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010153d:	01 d0                	add    %edx,%eax
c010153f:	0f b6 00             	movzbl (%eax),%eax
c0101542:	0f b6 c0             	movzbl %al,%eax
c0101545:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101548:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010154d:	83 e0 08             	and    $0x8,%eax
c0101550:	85 c0                	test   %eax,%eax
c0101552:	74 22                	je     c0101576 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101554:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101558:	7e 0c                	jle    c0101566 <kbd_proc_data+0x13e>
c010155a:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010155e:	7f 06                	jg     c0101566 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101560:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101564:	eb 10                	jmp    c0101576 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101566:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010156a:	7e 0a                	jle    c0101576 <kbd_proc_data+0x14e>
c010156c:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101570:	7f 04                	jg     c0101576 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101572:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101576:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010157b:	f7 d0                	not    %eax
c010157d:	83 e0 06             	and    $0x6,%eax
c0101580:	85 c0                	test   %eax,%eax
c0101582:	75 28                	jne    c01015ac <kbd_proc_data+0x184>
c0101584:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010158b:	75 1f                	jne    c01015ac <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010158d:	c7 04 24 a9 64 10 c0 	movl   $0xc01064a9,(%esp)
c0101594:	e8 f8 ec ff ff       	call   c0100291 <cprintf>
c0101599:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010159f:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a3:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015a7:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015ab:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015af:	c9                   	leave  
c01015b0:	c3                   	ret    

c01015b1 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015b1:	55                   	push   %ebp
c01015b2:	89 e5                	mov    %esp,%ebp
c01015b4:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015b7:	c7 04 24 28 14 10 c0 	movl   $0xc0101428,(%esp)
c01015be:	e8 a6 fd ff ff       	call   c0101369 <cons_intr>
}
c01015c3:	c9                   	leave  
c01015c4:	c3                   	ret    

c01015c5 <kbd_init>:

static void
kbd_init(void) {
c01015c5:	55                   	push   %ebp
c01015c6:	89 e5                	mov    %esp,%ebp
c01015c8:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015cb:	e8 e1 ff ff ff       	call   c01015b1 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015d7:	e8 31 01 00 00       	call   c010170d <pic_enable>
}
c01015dc:	c9                   	leave  
c01015dd:	c3                   	ret    

c01015de <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015de:	55                   	push   %ebp
c01015df:	89 e5                	mov    %esp,%ebp
c01015e1:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e4:	e8 93 f8 ff ff       	call   c0100e7c <cga_init>
    serial_init();
c01015e9:	e8 74 f9 ff ff       	call   c0100f62 <serial_init>
    kbd_init();
c01015ee:	e8 d2 ff ff ff       	call   c01015c5 <kbd_init>
    if (!serial_exists) {
c01015f3:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015f8:	85 c0                	test   %eax,%eax
c01015fa:	75 0c                	jne    c0101608 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015fc:	c7 04 24 b5 64 10 c0 	movl   $0xc01064b5,(%esp)
c0101603:	e8 89 ec ff ff       	call   c0100291 <cprintf>
    }
}
c0101608:	c9                   	leave  
c0101609:	c3                   	ret    

c010160a <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010160a:	55                   	push   %ebp
c010160b:	89 e5                	mov    %esp,%ebp
c010160d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101610:	e8 e2 f7 ff ff       	call   c0100df7 <__intr_save>
c0101615:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101618:	8b 45 08             	mov    0x8(%ebp),%eax
c010161b:	89 04 24             	mov    %eax,(%esp)
c010161e:	e8 9b fa ff ff       	call   c01010be <lpt_putc>
        cga_putc(c);
c0101623:	8b 45 08             	mov    0x8(%ebp),%eax
c0101626:	89 04 24             	mov    %eax,(%esp)
c0101629:	e8 cf fa ff ff       	call   c01010fd <cga_putc>
        serial_putc(c);
c010162e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101631:	89 04 24             	mov    %eax,(%esp)
c0101634:	e8 f1 fc ff ff       	call   c010132a <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101639:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010163c:	89 04 24             	mov    %eax,(%esp)
c010163f:	e8 dd f7 ff ff       	call   c0100e21 <__intr_restore>
}
c0101644:	c9                   	leave  
c0101645:	c3                   	ret    

c0101646 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101646:	55                   	push   %ebp
c0101647:	89 e5                	mov    %esp,%ebp
c0101649:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010164c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101653:	e8 9f f7 ff ff       	call   c0100df7 <__intr_save>
c0101658:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010165b:	e8 ab fd ff ff       	call   c010140b <serial_intr>
        kbd_intr();
c0101660:	e8 4c ff ff ff       	call   c01015b1 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101665:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c010166b:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101670:	39 c2                	cmp    %eax,%edx
c0101672:	74 31                	je     c01016a5 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101674:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101679:	8d 50 01             	lea    0x1(%eax),%edx
c010167c:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101682:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101689:	0f b6 c0             	movzbl %al,%eax
c010168c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010168f:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101694:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101699:	75 0a                	jne    c01016a5 <cons_getc+0x5f>
                cons.rpos = 0;
c010169b:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c01016a2:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016a8:	89 04 24             	mov    %eax,(%esp)
c01016ab:	e8 71 f7 ff ff       	call   c0100e21 <__intr_restore>
    return c;
c01016b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b3:	c9                   	leave  
c01016b4:	c3                   	ret    

c01016b5 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016b5:	55                   	push   %ebp
c01016b6:	89 e5                	mov    %esp,%ebp
c01016b8:	83 ec 14             	sub    $0x14,%esp
c01016bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01016be:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016c2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c6:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016cc:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016d1:	85 c0                	test   %eax,%eax
c01016d3:	74 36                	je     c010170b <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016d5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d9:	0f b6 c0             	movzbl %al,%eax
c01016dc:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016e2:	88 45 fd             	mov    %al,-0x3(%ebp)
c01016e5:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016e9:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016ed:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016ee:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f2:	66 c1 e8 08          	shr    $0x8,%ax
c01016f6:	0f b6 c0             	movzbl %al,%eax
c01016f9:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016ff:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101702:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101706:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010170a:	ee                   	out    %al,(%dx)
    }
}
c010170b:	c9                   	leave  
c010170c:	c3                   	ret    

c010170d <pic_enable>:

void
pic_enable(unsigned int irq) {
c010170d:	55                   	push   %ebp
c010170e:	89 e5                	mov    %esp,%ebp
c0101710:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101713:	8b 45 08             	mov    0x8(%ebp),%eax
c0101716:	ba 01 00 00 00       	mov    $0x1,%edx
c010171b:	89 c1                	mov    %eax,%ecx
c010171d:	d3 e2                	shl    %cl,%edx
c010171f:	89 d0                	mov    %edx,%eax
c0101721:	f7 d0                	not    %eax
c0101723:	89 c2                	mov    %eax,%edx
c0101725:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010172c:	21 d0                	and    %edx,%eax
c010172e:	0f b7 c0             	movzwl %ax,%eax
c0101731:	89 04 24             	mov    %eax,(%esp)
c0101734:	e8 7c ff ff ff       	call   c01016b5 <pic_setmask>
}
c0101739:	c9                   	leave  
c010173a:	c3                   	ret    

c010173b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010173b:	55                   	push   %ebp
c010173c:	89 e5                	mov    %esp,%ebp
c010173e:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101741:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101748:	00 00 00 
c010174b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101751:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101755:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101759:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010175d:	ee                   	out    %al,(%dx)
c010175e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101764:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101768:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010176c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101770:	ee                   	out    %al,(%dx)
c0101771:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101777:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010177b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010177f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101783:	ee                   	out    %al,(%dx)
c0101784:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010178a:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010178e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101792:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101796:	ee                   	out    %al,(%dx)
c0101797:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010179d:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017a9:	ee                   	out    %al,(%dx)
c01017aa:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017b0:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017b4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017bc:	ee                   	out    %al,(%dx)
c01017bd:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017c3:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017cb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017cf:	ee                   	out    %al,(%dx)
c01017d0:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d6:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017da:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017de:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017e2:	ee                   	out    %al,(%dx)
c01017e3:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017e9:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017ed:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017f1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017f5:	ee                   	out    %al,(%dx)
c01017f6:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017fc:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101800:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101804:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101808:	ee                   	out    %al,(%dx)
c0101809:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010180f:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101813:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101817:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010181b:	ee                   	out    %al,(%dx)
c010181c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101822:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101826:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010182a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010182e:	ee                   	out    %al,(%dx)
c010182f:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101835:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101839:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010183d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101841:	ee                   	out    %al,(%dx)
c0101842:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101848:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010184c:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101850:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101854:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101855:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010185c:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101860:	74 12                	je     c0101874 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101862:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101869:	0f b7 c0             	movzwl %ax,%eax
c010186c:	89 04 24             	mov    %eax,(%esp)
c010186f:	e8 41 fe ff ff       	call   c01016b5 <pic_setmask>
    }
}
c0101874:	c9                   	leave  
c0101875:	c3                   	ret    

c0101876 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101876:	55                   	push   %ebp
c0101877:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101879:	fb                   	sti    
    sti();
}
c010187a:	5d                   	pop    %ebp
c010187b:	c3                   	ret    

c010187c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010187c:	55                   	push   %ebp
c010187d:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010187f:	fa                   	cli    
    cli();
}
c0101880:	5d                   	pop    %ebp
c0101881:	c3                   	ret    

c0101882 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101882:	55                   	push   %ebp
c0101883:	89 e5                	mov    %esp,%ebp
c0101885:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101888:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010188f:	00 
c0101890:	c7 04 24 e0 64 10 c0 	movl   $0xc01064e0,(%esp)
c0101897:	e8 f5 e9 ff ff       	call   c0100291 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010189c:	c7 04 24 ea 64 10 c0 	movl   $0xc01064ea,(%esp)
c01018a3:	e8 e9 e9 ff ff       	call   c0100291 <cprintf>
    panic("EOT: kernel seems ok.");
c01018a8:	c7 44 24 08 f8 64 10 	movl   $0xc01064f8,0x8(%esp)
c01018af:	c0 
c01018b0:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018b7:	00 
c01018b8:	c7 04 24 0e 65 10 c0 	movl   $0xc010650e,(%esp)
c01018bf:	e8 24 eb ff ff       	call   c01003e8 <__panic>

c01018c4 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018c4:	55                   	push   %ebp
c01018c5:	89 e5                	mov    %esp,%ebp
c01018c7:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
        int num=sizeof(idt)/sizeof(struct gatedesc);
c01018ca:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
	int i;
        for(i=0;i<num;++i)
c01018d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018d8:	e9 c3 00 00 00       	jmp    c01019a0 <idt_init+0xdc>
        {
                SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
c01018dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e0:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018e7:	89 c2                	mov    %eax,%edx
c01018e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ec:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018f3:	c0 
c01018f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f7:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018fe:	c0 08 00 
c0101901:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101904:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c010190b:	c0 
c010190c:	83 e2 e0             	and    $0xffffffe0,%edx
c010190f:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101916:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101919:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101920:	c0 
c0101921:	83 e2 1f             	and    $0x1f,%edx
c0101924:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c010192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192e:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101935:	c0 
c0101936:	83 e2 f0             	and    $0xfffffff0,%edx
c0101939:	83 ca 0e             	or     $0xe,%edx
c010193c:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101946:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010194d:	c0 
c010194e:	83 e2 ef             	and    $0xffffffef,%edx
c0101951:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195b:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101962:	c0 
c0101963:	83 e2 9f             	and    $0xffffff9f,%edx
c0101966:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010196d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101970:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101977:	c0 
c0101978:	83 ca 80             	or     $0xffffff80,%edx
c010197b:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101982:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101985:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010198c:	c1 e8 10             	shr    $0x10,%eax
c010198f:	89 c2                	mov    %eax,%edx
c0101991:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101994:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c010199b:	c0 
        for(i=0;i<num;++i)
c010199c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01019a6:	0f 8c 31 ff ff ff    	jl     c01018dd <idt_init+0x19>
        }

        SETGATE(idt[T_SWITCH_TOU],0,GD_KTEXT,__vectors[T_SWITCH_TOU],DPL_USER);
c01019ac:	a1 e0 77 11 c0       	mov    0xc01177e0,%eax
c01019b1:	66 a3 80 84 11 c0    	mov    %ax,0xc0118480
c01019b7:	66 c7 05 82 84 11 c0 	movw   $0x8,0xc0118482
c01019be:	08 00 
c01019c0:	0f b6 05 84 84 11 c0 	movzbl 0xc0118484,%eax
c01019c7:	83 e0 e0             	and    $0xffffffe0,%eax
c01019ca:	a2 84 84 11 c0       	mov    %al,0xc0118484
c01019cf:	0f b6 05 84 84 11 c0 	movzbl 0xc0118484,%eax
c01019d6:	83 e0 1f             	and    $0x1f,%eax
c01019d9:	a2 84 84 11 c0       	mov    %al,0xc0118484
c01019de:	0f b6 05 85 84 11 c0 	movzbl 0xc0118485,%eax
c01019e5:	83 e0 f0             	and    $0xfffffff0,%eax
c01019e8:	83 c8 0e             	or     $0xe,%eax
c01019eb:	a2 85 84 11 c0       	mov    %al,0xc0118485
c01019f0:	0f b6 05 85 84 11 c0 	movzbl 0xc0118485,%eax
c01019f7:	83 e0 ef             	and    $0xffffffef,%eax
c01019fa:	a2 85 84 11 c0       	mov    %al,0xc0118485
c01019ff:	0f b6 05 85 84 11 c0 	movzbl 0xc0118485,%eax
c0101a06:	83 c8 60             	or     $0x60,%eax
c0101a09:	a2 85 84 11 c0       	mov    %al,0xc0118485
c0101a0e:	0f b6 05 85 84 11 c0 	movzbl 0xc0118485,%eax
c0101a15:	83 c8 80             	or     $0xffffff80,%eax
c0101a18:	a2 85 84 11 c0       	mov    %al,0xc0118485
c0101a1d:	a1 e0 77 11 c0       	mov    0xc01177e0,%eax
c0101a22:	c1 e8 10             	shr    $0x10,%eax
c0101a25:	66 a3 86 84 11 c0    	mov    %ax,0xc0118486
	SETGATE(idt[T_SWITCH_TOK], 0, KERNEL_CS, __vectors[T_SWITCH_TOK], 3);        
c0101a2b:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101a30:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c0101a36:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c0101a3d:	08 00 
c0101a3f:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c0101a46:	83 e0 e0             	and    $0xffffffe0,%eax
c0101a49:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c0101a4e:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c0101a55:	83 e0 1f             	and    $0x1f,%eax
c0101a58:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c0101a5d:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101a64:	83 e0 f0             	and    $0xfffffff0,%eax
c0101a67:	83 c8 0e             	or     $0xe,%eax
c0101a6a:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101a6f:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101a76:	83 e0 ef             	and    $0xffffffef,%eax
c0101a79:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101a7e:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101a85:	83 c8 60             	or     $0x60,%eax
c0101a88:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101a8d:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101a94:	83 c8 80             	or     $0xffffff80,%eax
c0101a97:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101a9c:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101aa1:	c1 e8 10             	shr    $0x10,%eax
c0101aa4:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c0101aaa:	c7 45 f4 80 75 11 c0 	movl   $0xc0117580,-0xc(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ab4:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
c0101ab7:	c9                   	leave  
c0101ab8:	c3                   	ret    

c0101ab9 <trapname>:

static const char *
trapname(int trapno) {
c0101ab9:	55                   	push   %ebp
c0101aba:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101abc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abf:	83 f8 13             	cmp    $0x13,%eax
c0101ac2:	77 0c                	ja     c0101ad0 <trapname+0x17>
        return excnames[trapno];
c0101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac7:	8b 04 85 60 68 10 c0 	mov    -0x3fef97a0(,%eax,4),%eax
c0101ace:	eb 18                	jmp    c0101ae8 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101ad0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101ad4:	7e 0d                	jle    c0101ae3 <trapname+0x2a>
c0101ad6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101ada:	7f 07                	jg     c0101ae3 <trapname+0x2a>
        return "Hardware Interrupt";
c0101adc:	b8 1f 65 10 c0       	mov    $0xc010651f,%eax
c0101ae1:	eb 05                	jmp    c0101ae8 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101ae3:	b8 32 65 10 c0       	mov    $0xc0106532,%eax
}
c0101ae8:	5d                   	pop    %ebp
c0101ae9:	c3                   	ret    

c0101aea <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101aea:	55                   	push   %ebp
c0101aeb:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101aed:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101af4:	66 83 f8 08          	cmp    $0x8,%ax
c0101af8:	0f 94 c0             	sete   %al
c0101afb:	0f b6 c0             	movzbl %al,%eax
}
c0101afe:	5d                   	pop    %ebp
c0101aff:	c3                   	ret    

c0101b00 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101b00:	55                   	push   %ebp
c0101b01:	89 e5                	mov    %esp,%ebp
c0101b03:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101b06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b09:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b0d:	c7 04 24 73 65 10 c0 	movl   $0xc0106573,(%esp)
c0101b14:	e8 78 e7 ff ff       	call   c0100291 <cprintf>
    print_regs(&tf->tf_regs);
c0101b19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1c:	89 04 24             	mov    %eax,(%esp)
c0101b1f:	e8 a1 01 00 00       	call   c0101cc5 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b24:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b27:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b2b:	0f b7 c0             	movzwl %ax,%eax
c0101b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b32:	c7 04 24 84 65 10 c0 	movl   $0xc0106584,(%esp)
c0101b39:	e8 53 e7 ff ff       	call   c0100291 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b41:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b45:	0f b7 c0             	movzwl %ax,%eax
c0101b48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b4c:	c7 04 24 97 65 10 c0 	movl   $0xc0106597,(%esp)
c0101b53:	e8 39 e7 ff ff       	call   c0100291 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b58:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5b:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b5f:	0f b7 c0             	movzwl %ax,%eax
c0101b62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b66:	c7 04 24 aa 65 10 c0 	movl   $0xc01065aa,(%esp)
c0101b6d:	e8 1f e7 ff ff       	call   c0100291 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b75:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b79:	0f b7 c0             	movzwl %ax,%eax
c0101b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b80:	c7 04 24 bd 65 10 c0 	movl   $0xc01065bd,(%esp)
c0101b87:	e8 05 e7 ff ff       	call   c0100291 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8f:	8b 40 30             	mov    0x30(%eax),%eax
c0101b92:	89 04 24             	mov    %eax,(%esp)
c0101b95:	e8 1f ff ff ff       	call   c0101ab9 <trapname>
c0101b9a:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b9d:	8b 52 30             	mov    0x30(%edx),%edx
c0101ba0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101ba4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101ba8:	c7 04 24 d0 65 10 c0 	movl   $0xc01065d0,(%esp)
c0101baf:	e8 dd e6 ff ff       	call   c0100291 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb7:	8b 40 34             	mov    0x34(%eax),%eax
c0101bba:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bbe:	c7 04 24 e2 65 10 c0 	movl   $0xc01065e2,(%esp)
c0101bc5:	e8 c7 e6 ff ff       	call   c0100291 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101bca:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bcd:	8b 40 38             	mov    0x38(%eax),%eax
c0101bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd4:	c7 04 24 f1 65 10 c0 	movl   $0xc01065f1,(%esp)
c0101bdb:	e8 b1 e6 ff ff       	call   c0100291 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101be0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101be7:	0f b7 c0             	movzwl %ax,%eax
c0101bea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bee:	c7 04 24 00 66 10 c0 	movl   $0xc0106600,(%esp)
c0101bf5:	e8 97 e6 ff ff       	call   c0100291 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfd:	8b 40 40             	mov    0x40(%eax),%eax
c0101c00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c04:	c7 04 24 13 66 10 c0 	movl   $0xc0106613,(%esp)
c0101c0b:	e8 81 e6 ff ff       	call   c0100291 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c17:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101c1e:	eb 3e                	jmp    c0101c5e <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101c20:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c23:	8b 50 40             	mov    0x40(%eax),%edx
c0101c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c29:	21 d0                	and    %edx,%eax
c0101c2b:	85 c0                	test   %eax,%eax
c0101c2d:	74 28                	je     c0101c57 <print_trapframe+0x157>
c0101c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c32:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101c39:	85 c0                	test   %eax,%eax
c0101c3b:	74 1a                	je     c0101c57 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c40:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c4b:	c7 04 24 22 66 10 c0 	movl   $0xc0106622,(%esp)
c0101c52:	e8 3a e6 ff ff       	call   c0100291 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c57:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c5b:	d1 65 f0             	shll   -0x10(%ebp)
c0101c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c61:	83 f8 17             	cmp    $0x17,%eax
c0101c64:	76 ba                	jbe    c0101c20 <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c69:	8b 40 40             	mov    0x40(%eax),%eax
c0101c6c:	25 00 30 00 00       	and    $0x3000,%eax
c0101c71:	c1 e8 0c             	shr    $0xc,%eax
c0101c74:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c78:	c7 04 24 26 66 10 c0 	movl   $0xc0106626,(%esp)
c0101c7f:	e8 0d e6 ff ff       	call   c0100291 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c84:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c87:	89 04 24             	mov    %eax,(%esp)
c0101c8a:	e8 5b fe ff ff       	call   c0101aea <trap_in_kernel>
c0101c8f:	85 c0                	test   %eax,%eax
c0101c91:	75 30                	jne    c0101cc3 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c96:	8b 40 44             	mov    0x44(%eax),%eax
c0101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9d:	c7 04 24 2f 66 10 c0 	movl   $0xc010662f,(%esp)
c0101ca4:	e8 e8 e5 ff ff       	call   c0100291 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cac:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101cb0:	0f b7 c0             	movzwl %ax,%eax
c0101cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb7:	c7 04 24 3e 66 10 c0 	movl   $0xc010663e,(%esp)
c0101cbe:	e8 ce e5 ff ff       	call   c0100291 <cprintf>
    }
}
c0101cc3:	c9                   	leave  
c0101cc4:	c3                   	ret    

c0101cc5 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101cc5:	55                   	push   %ebp
c0101cc6:	89 e5                	mov    %esp,%ebp
c0101cc8:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101ccb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cce:	8b 00                	mov    (%eax),%eax
c0101cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd4:	c7 04 24 51 66 10 c0 	movl   $0xc0106651,(%esp)
c0101cdb:	e8 b1 e5 ff ff       	call   c0100291 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101ce0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce3:	8b 40 04             	mov    0x4(%eax),%eax
c0101ce6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cea:	c7 04 24 60 66 10 c0 	movl   $0xc0106660,(%esp)
c0101cf1:	e8 9b e5 ff ff       	call   c0100291 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101cf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf9:	8b 40 08             	mov    0x8(%eax),%eax
c0101cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d00:	c7 04 24 6f 66 10 c0 	movl   $0xc010666f,(%esp)
c0101d07:	e8 85 e5 ff ff       	call   c0100291 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0f:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d16:	c7 04 24 7e 66 10 c0 	movl   $0xc010667e,(%esp)
c0101d1d:	e8 6f e5 ff ff       	call   c0100291 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d22:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d25:	8b 40 10             	mov    0x10(%eax),%eax
c0101d28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d2c:	c7 04 24 8d 66 10 c0 	movl   $0xc010668d,(%esp)
c0101d33:	e8 59 e5 ff ff       	call   c0100291 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d38:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d3b:	8b 40 14             	mov    0x14(%eax),%eax
c0101d3e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d42:	c7 04 24 9c 66 10 c0 	movl   $0xc010669c,(%esp)
c0101d49:	e8 43 e5 ff ff       	call   c0100291 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d51:	8b 40 18             	mov    0x18(%eax),%eax
c0101d54:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d58:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0101d5f:	e8 2d e5 ff ff       	call   c0100291 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d67:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d6e:	c7 04 24 ba 66 10 c0 	movl   $0xc01066ba,(%esp)
c0101d75:	e8 17 e5 ff ff       	call   c0100291 <cprintf>
}
c0101d7a:	c9                   	leave  
c0101d7b:	c3                   	ret    

c0101d7c <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d7c:	55                   	push   %ebp
c0101d7d:	89 e5                	mov    %esp,%ebp
c0101d7f:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d85:	8b 40 30             	mov    0x30(%eax),%eax
c0101d88:	83 f8 2f             	cmp    $0x2f,%eax
c0101d8b:	77 1d                	ja     c0101daa <trap_dispatch+0x2e>
c0101d8d:	83 f8 2e             	cmp    $0x2e,%eax
c0101d90:	0f 83 91 01 00 00    	jae    c0101f27 <trap_dispatch+0x1ab>
c0101d96:	83 f8 21             	cmp    $0x21,%eax
c0101d99:	74 7f                	je     c0101e1a <trap_dispatch+0x9e>
c0101d9b:	83 f8 24             	cmp    $0x24,%eax
c0101d9e:	74 51                	je     c0101df1 <trap_dispatch+0x75>
c0101da0:	83 f8 20             	cmp    $0x20,%eax
c0101da3:	74 1c                	je     c0101dc1 <trap_dispatch+0x45>
c0101da5:	e9 45 01 00 00       	jmp    c0101eef <trap_dispatch+0x173>
c0101daa:	83 f8 78             	cmp    $0x78,%eax
c0101dad:	0f 84 90 00 00 00    	je     c0101e43 <trap_dispatch+0xc7>
c0101db3:	83 f8 79             	cmp    $0x79,%eax
c0101db6:	0f 84 e7 00 00 00    	je     c0101ea3 <trap_dispatch+0x127>
c0101dbc:	e9 2e 01 00 00       	jmp    c0101eef <trap_dispatch+0x173>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */

	ticks++;
c0101dc1:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101dc6:	83 c0 01             	add    $0x1,%eax
c0101dc9:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
	if(ticks==TICK_NUM)
c0101dce:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101dd3:	83 f8 64             	cmp    $0x64,%eax
c0101dd6:	75 14                	jne    c0101dec <trap_dispatch+0x70>
	{
		ticks=0;
c0101dd8:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0101ddf:	00 00 00 
		print_ticks();
c0101de2:	e8 9b fa ff ff       	call   c0101882 <print_ticks>
	}		
        break;
c0101de7:	e9 3c 01 00 00       	jmp    c0101f28 <trap_dispatch+0x1ac>
c0101dec:	e9 37 01 00 00       	jmp    c0101f28 <trap_dispatch+0x1ac>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101df1:	e8 50 f8 ff ff       	call   c0101646 <cons_getc>
c0101df6:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101df9:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101dfd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e01:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e05:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e09:	c7 04 24 c9 66 10 c0 	movl   $0xc01066c9,(%esp)
c0101e10:	e8 7c e4 ff ff       	call   c0100291 <cprintf>
        break;
c0101e15:	e9 0e 01 00 00       	jmp    c0101f28 <trap_dispatch+0x1ac>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101e1a:	e8 27 f8 ff ff       	call   c0101646 <cons_getc>
c0101e1f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101e22:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e26:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e2a:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e32:	c7 04 24 db 66 10 c0 	movl   $0xc01066db,(%esp)
c0101e39:	e8 53 e4 ff ff       	call   c0100291 <cprintf>
        break;
c0101e3e:	e9 e5 00 00 00       	jmp    c0101f28 <trap_dispatch+0x1ac>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
	tf->tf_eflags |= FL_IOPL_MASK;
c0101e43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e46:	8b 40 40             	mov    0x40(%eax),%eax
c0101e49:	80 cc 30             	or     $0x30,%ah
c0101e4c:	89 c2                	mov    %eax,%edx
c0101e4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e51:	89 50 40             	mov    %edx,0x40(%eax)
	tf->tf_cs = USER_CS;
c0101e54:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e57:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
	tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = USER_DS;
c0101e5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e60:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
c0101e66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e69:	0f b7 50 24          	movzwl 0x24(%eax),%edx
c0101e6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e70:	66 89 50 48          	mov    %dx,0x48(%eax)
c0101e74:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e77:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101e7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e7e:	66 89 50 20          	mov    %dx,0x20(%eax)
c0101e82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e85:	0f b7 50 20          	movzwl 0x20(%eax),%edx
c0101e89:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8c:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101e90:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e93:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101e97:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e9a:	66 89 50 2c          	mov    %dx,0x2c(%eax)
	break;
c0101e9e:	e9 85 00 00 00       	jmp    c0101f28 <trap_dispatch+0x1ac>
    case T_SWITCH_TOK:
	tf->tf_cs = KERNEL_CS;
c0101ea3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea6:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
	tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = KERNEL_DS;
c0101eac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eaf:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
c0101eb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb8:	0f b7 50 24          	movzwl 0x24(%eax),%edx
c0101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ebf:	66 89 50 48          	mov    %dx,0x48(%eax)
c0101ec3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec6:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101eca:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ecd:	66 89 50 20          	mov    %dx,0x20(%eax)
c0101ed1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed4:	0f b7 50 20          	movzwl 0x20(%eax),%edx
c0101ed8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101edb:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101edf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee2:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101ee6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee9:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        break;
c0101eed:	eb 39                	jmp    c0101f28 <trap_dispatch+0x1ac>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101eef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ef2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ef6:	0f b7 c0             	movzwl %ax,%eax
c0101ef9:	83 e0 03             	and    $0x3,%eax
c0101efc:	85 c0                	test   %eax,%eax
c0101efe:	75 28                	jne    c0101f28 <trap_dispatch+0x1ac>
            print_trapframe(tf);
c0101f00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f03:	89 04 24             	mov    %eax,(%esp)
c0101f06:	e8 f5 fb ff ff       	call   c0101b00 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101f0b:	c7 44 24 08 ea 66 10 	movl   $0xc01066ea,0x8(%esp)
c0101f12:	c0 
c0101f13:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0101f1a:	00 
c0101f1b:	c7 04 24 0e 65 10 c0 	movl   $0xc010650e,(%esp)
c0101f22:	e8 c1 e4 ff ff       	call   c01003e8 <__panic>
        break;
c0101f27:	90                   	nop
        }
    }
}
c0101f28:	c9                   	leave  
c0101f29:	c3                   	ret    

c0101f2a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101f2a:	55                   	push   %ebp
c0101f2b:	89 e5                	mov    %esp,%ebp
c0101f2d:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101f30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f33:	89 04 24             	mov    %eax,(%esp)
c0101f36:	e8 41 fe ff ff       	call   c0101d7c <trap_dispatch>
}
c0101f3b:	c9                   	leave  
c0101f3c:	c3                   	ret    

c0101f3d <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101f3d:	6a 00                	push   $0x0
  pushl $0
c0101f3f:	6a 00                	push   $0x0
  jmp __alltraps
c0101f41:	e9 67 0a 00 00       	jmp    c01029ad <__alltraps>

c0101f46 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101f46:	6a 00                	push   $0x0
  pushl $1
c0101f48:	6a 01                	push   $0x1
  jmp __alltraps
c0101f4a:	e9 5e 0a 00 00       	jmp    c01029ad <__alltraps>

c0101f4f <vector2>:
.globl vector2
vector2:
  pushl $0
c0101f4f:	6a 00                	push   $0x0
  pushl $2
c0101f51:	6a 02                	push   $0x2
  jmp __alltraps
c0101f53:	e9 55 0a 00 00       	jmp    c01029ad <__alltraps>

c0101f58 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101f58:	6a 00                	push   $0x0
  pushl $3
c0101f5a:	6a 03                	push   $0x3
  jmp __alltraps
c0101f5c:	e9 4c 0a 00 00       	jmp    c01029ad <__alltraps>

c0101f61 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101f61:	6a 00                	push   $0x0
  pushl $4
c0101f63:	6a 04                	push   $0x4
  jmp __alltraps
c0101f65:	e9 43 0a 00 00       	jmp    c01029ad <__alltraps>

c0101f6a <vector5>:
.globl vector5
vector5:
  pushl $0
c0101f6a:	6a 00                	push   $0x0
  pushl $5
c0101f6c:	6a 05                	push   $0x5
  jmp __alltraps
c0101f6e:	e9 3a 0a 00 00       	jmp    c01029ad <__alltraps>

c0101f73 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101f73:	6a 00                	push   $0x0
  pushl $6
c0101f75:	6a 06                	push   $0x6
  jmp __alltraps
c0101f77:	e9 31 0a 00 00       	jmp    c01029ad <__alltraps>

c0101f7c <vector7>:
.globl vector7
vector7:
  pushl $0
c0101f7c:	6a 00                	push   $0x0
  pushl $7
c0101f7e:	6a 07                	push   $0x7
  jmp __alltraps
c0101f80:	e9 28 0a 00 00       	jmp    c01029ad <__alltraps>

c0101f85 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101f85:	6a 08                	push   $0x8
  jmp __alltraps
c0101f87:	e9 21 0a 00 00       	jmp    c01029ad <__alltraps>

c0101f8c <vector9>:
.globl vector9
vector9:
  pushl $9
c0101f8c:	6a 09                	push   $0x9
  jmp __alltraps
c0101f8e:	e9 1a 0a 00 00       	jmp    c01029ad <__alltraps>

c0101f93 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f93:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f95:	e9 13 0a 00 00       	jmp    c01029ad <__alltraps>

c0101f9a <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f9a:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f9c:	e9 0c 0a 00 00       	jmp    c01029ad <__alltraps>

c0101fa1 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101fa1:	6a 0c                	push   $0xc
  jmp __alltraps
c0101fa3:	e9 05 0a 00 00       	jmp    c01029ad <__alltraps>

c0101fa8 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101fa8:	6a 0d                	push   $0xd
  jmp __alltraps
c0101faa:	e9 fe 09 00 00       	jmp    c01029ad <__alltraps>

c0101faf <vector14>:
.globl vector14
vector14:
  pushl $14
c0101faf:	6a 0e                	push   $0xe
  jmp __alltraps
c0101fb1:	e9 f7 09 00 00       	jmp    c01029ad <__alltraps>

c0101fb6 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101fb6:	6a 00                	push   $0x0
  pushl $15
c0101fb8:	6a 0f                	push   $0xf
  jmp __alltraps
c0101fba:	e9 ee 09 00 00       	jmp    c01029ad <__alltraps>

c0101fbf <vector16>:
.globl vector16
vector16:
  pushl $0
c0101fbf:	6a 00                	push   $0x0
  pushl $16
c0101fc1:	6a 10                	push   $0x10
  jmp __alltraps
c0101fc3:	e9 e5 09 00 00       	jmp    c01029ad <__alltraps>

c0101fc8 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101fc8:	6a 11                	push   $0x11
  jmp __alltraps
c0101fca:	e9 de 09 00 00       	jmp    c01029ad <__alltraps>

c0101fcf <vector18>:
.globl vector18
vector18:
  pushl $0
c0101fcf:	6a 00                	push   $0x0
  pushl $18
c0101fd1:	6a 12                	push   $0x12
  jmp __alltraps
c0101fd3:	e9 d5 09 00 00       	jmp    c01029ad <__alltraps>

c0101fd8 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101fd8:	6a 00                	push   $0x0
  pushl $19
c0101fda:	6a 13                	push   $0x13
  jmp __alltraps
c0101fdc:	e9 cc 09 00 00       	jmp    c01029ad <__alltraps>

c0101fe1 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101fe1:	6a 00                	push   $0x0
  pushl $20
c0101fe3:	6a 14                	push   $0x14
  jmp __alltraps
c0101fe5:	e9 c3 09 00 00       	jmp    c01029ad <__alltraps>

c0101fea <vector21>:
.globl vector21
vector21:
  pushl $0
c0101fea:	6a 00                	push   $0x0
  pushl $21
c0101fec:	6a 15                	push   $0x15
  jmp __alltraps
c0101fee:	e9 ba 09 00 00       	jmp    c01029ad <__alltraps>

c0101ff3 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101ff3:	6a 00                	push   $0x0
  pushl $22
c0101ff5:	6a 16                	push   $0x16
  jmp __alltraps
c0101ff7:	e9 b1 09 00 00       	jmp    c01029ad <__alltraps>

c0101ffc <vector23>:
.globl vector23
vector23:
  pushl $0
c0101ffc:	6a 00                	push   $0x0
  pushl $23
c0101ffe:	6a 17                	push   $0x17
  jmp __alltraps
c0102000:	e9 a8 09 00 00       	jmp    c01029ad <__alltraps>

c0102005 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102005:	6a 00                	push   $0x0
  pushl $24
c0102007:	6a 18                	push   $0x18
  jmp __alltraps
c0102009:	e9 9f 09 00 00       	jmp    c01029ad <__alltraps>

c010200e <vector25>:
.globl vector25
vector25:
  pushl $0
c010200e:	6a 00                	push   $0x0
  pushl $25
c0102010:	6a 19                	push   $0x19
  jmp __alltraps
c0102012:	e9 96 09 00 00       	jmp    c01029ad <__alltraps>

c0102017 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102017:	6a 00                	push   $0x0
  pushl $26
c0102019:	6a 1a                	push   $0x1a
  jmp __alltraps
c010201b:	e9 8d 09 00 00       	jmp    c01029ad <__alltraps>

c0102020 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102020:	6a 00                	push   $0x0
  pushl $27
c0102022:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102024:	e9 84 09 00 00       	jmp    c01029ad <__alltraps>

c0102029 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102029:	6a 00                	push   $0x0
  pushl $28
c010202b:	6a 1c                	push   $0x1c
  jmp __alltraps
c010202d:	e9 7b 09 00 00       	jmp    c01029ad <__alltraps>

c0102032 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102032:	6a 00                	push   $0x0
  pushl $29
c0102034:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102036:	e9 72 09 00 00       	jmp    c01029ad <__alltraps>

c010203b <vector30>:
.globl vector30
vector30:
  pushl $0
c010203b:	6a 00                	push   $0x0
  pushl $30
c010203d:	6a 1e                	push   $0x1e
  jmp __alltraps
c010203f:	e9 69 09 00 00       	jmp    c01029ad <__alltraps>

c0102044 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102044:	6a 00                	push   $0x0
  pushl $31
c0102046:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102048:	e9 60 09 00 00       	jmp    c01029ad <__alltraps>

c010204d <vector32>:
.globl vector32
vector32:
  pushl $0
c010204d:	6a 00                	push   $0x0
  pushl $32
c010204f:	6a 20                	push   $0x20
  jmp __alltraps
c0102051:	e9 57 09 00 00       	jmp    c01029ad <__alltraps>

c0102056 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102056:	6a 00                	push   $0x0
  pushl $33
c0102058:	6a 21                	push   $0x21
  jmp __alltraps
c010205a:	e9 4e 09 00 00       	jmp    c01029ad <__alltraps>

c010205f <vector34>:
.globl vector34
vector34:
  pushl $0
c010205f:	6a 00                	push   $0x0
  pushl $34
c0102061:	6a 22                	push   $0x22
  jmp __alltraps
c0102063:	e9 45 09 00 00       	jmp    c01029ad <__alltraps>

c0102068 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102068:	6a 00                	push   $0x0
  pushl $35
c010206a:	6a 23                	push   $0x23
  jmp __alltraps
c010206c:	e9 3c 09 00 00       	jmp    c01029ad <__alltraps>

c0102071 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102071:	6a 00                	push   $0x0
  pushl $36
c0102073:	6a 24                	push   $0x24
  jmp __alltraps
c0102075:	e9 33 09 00 00       	jmp    c01029ad <__alltraps>

c010207a <vector37>:
.globl vector37
vector37:
  pushl $0
c010207a:	6a 00                	push   $0x0
  pushl $37
c010207c:	6a 25                	push   $0x25
  jmp __alltraps
c010207e:	e9 2a 09 00 00       	jmp    c01029ad <__alltraps>

c0102083 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102083:	6a 00                	push   $0x0
  pushl $38
c0102085:	6a 26                	push   $0x26
  jmp __alltraps
c0102087:	e9 21 09 00 00       	jmp    c01029ad <__alltraps>

c010208c <vector39>:
.globl vector39
vector39:
  pushl $0
c010208c:	6a 00                	push   $0x0
  pushl $39
c010208e:	6a 27                	push   $0x27
  jmp __alltraps
c0102090:	e9 18 09 00 00       	jmp    c01029ad <__alltraps>

c0102095 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102095:	6a 00                	push   $0x0
  pushl $40
c0102097:	6a 28                	push   $0x28
  jmp __alltraps
c0102099:	e9 0f 09 00 00       	jmp    c01029ad <__alltraps>

c010209e <vector41>:
.globl vector41
vector41:
  pushl $0
c010209e:	6a 00                	push   $0x0
  pushl $41
c01020a0:	6a 29                	push   $0x29
  jmp __alltraps
c01020a2:	e9 06 09 00 00       	jmp    c01029ad <__alltraps>

c01020a7 <vector42>:
.globl vector42
vector42:
  pushl $0
c01020a7:	6a 00                	push   $0x0
  pushl $42
c01020a9:	6a 2a                	push   $0x2a
  jmp __alltraps
c01020ab:	e9 fd 08 00 00       	jmp    c01029ad <__alltraps>

c01020b0 <vector43>:
.globl vector43
vector43:
  pushl $0
c01020b0:	6a 00                	push   $0x0
  pushl $43
c01020b2:	6a 2b                	push   $0x2b
  jmp __alltraps
c01020b4:	e9 f4 08 00 00       	jmp    c01029ad <__alltraps>

c01020b9 <vector44>:
.globl vector44
vector44:
  pushl $0
c01020b9:	6a 00                	push   $0x0
  pushl $44
c01020bb:	6a 2c                	push   $0x2c
  jmp __alltraps
c01020bd:	e9 eb 08 00 00       	jmp    c01029ad <__alltraps>

c01020c2 <vector45>:
.globl vector45
vector45:
  pushl $0
c01020c2:	6a 00                	push   $0x0
  pushl $45
c01020c4:	6a 2d                	push   $0x2d
  jmp __alltraps
c01020c6:	e9 e2 08 00 00       	jmp    c01029ad <__alltraps>

c01020cb <vector46>:
.globl vector46
vector46:
  pushl $0
c01020cb:	6a 00                	push   $0x0
  pushl $46
c01020cd:	6a 2e                	push   $0x2e
  jmp __alltraps
c01020cf:	e9 d9 08 00 00       	jmp    c01029ad <__alltraps>

c01020d4 <vector47>:
.globl vector47
vector47:
  pushl $0
c01020d4:	6a 00                	push   $0x0
  pushl $47
c01020d6:	6a 2f                	push   $0x2f
  jmp __alltraps
c01020d8:	e9 d0 08 00 00       	jmp    c01029ad <__alltraps>

c01020dd <vector48>:
.globl vector48
vector48:
  pushl $0
c01020dd:	6a 00                	push   $0x0
  pushl $48
c01020df:	6a 30                	push   $0x30
  jmp __alltraps
c01020e1:	e9 c7 08 00 00       	jmp    c01029ad <__alltraps>

c01020e6 <vector49>:
.globl vector49
vector49:
  pushl $0
c01020e6:	6a 00                	push   $0x0
  pushl $49
c01020e8:	6a 31                	push   $0x31
  jmp __alltraps
c01020ea:	e9 be 08 00 00       	jmp    c01029ad <__alltraps>

c01020ef <vector50>:
.globl vector50
vector50:
  pushl $0
c01020ef:	6a 00                	push   $0x0
  pushl $50
c01020f1:	6a 32                	push   $0x32
  jmp __alltraps
c01020f3:	e9 b5 08 00 00       	jmp    c01029ad <__alltraps>

c01020f8 <vector51>:
.globl vector51
vector51:
  pushl $0
c01020f8:	6a 00                	push   $0x0
  pushl $51
c01020fa:	6a 33                	push   $0x33
  jmp __alltraps
c01020fc:	e9 ac 08 00 00       	jmp    c01029ad <__alltraps>

c0102101 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102101:	6a 00                	push   $0x0
  pushl $52
c0102103:	6a 34                	push   $0x34
  jmp __alltraps
c0102105:	e9 a3 08 00 00       	jmp    c01029ad <__alltraps>

c010210a <vector53>:
.globl vector53
vector53:
  pushl $0
c010210a:	6a 00                	push   $0x0
  pushl $53
c010210c:	6a 35                	push   $0x35
  jmp __alltraps
c010210e:	e9 9a 08 00 00       	jmp    c01029ad <__alltraps>

c0102113 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102113:	6a 00                	push   $0x0
  pushl $54
c0102115:	6a 36                	push   $0x36
  jmp __alltraps
c0102117:	e9 91 08 00 00       	jmp    c01029ad <__alltraps>

c010211c <vector55>:
.globl vector55
vector55:
  pushl $0
c010211c:	6a 00                	push   $0x0
  pushl $55
c010211e:	6a 37                	push   $0x37
  jmp __alltraps
c0102120:	e9 88 08 00 00       	jmp    c01029ad <__alltraps>

c0102125 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102125:	6a 00                	push   $0x0
  pushl $56
c0102127:	6a 38                	push   $0x38
  jmp __alltraps
c0102129:	e9 7f 08 00 00       	jmp    c01029ad <__alltraps>

c010212e <vector57>:
.globl vector57
vector57:
  pushl $0
c010212e:	6a 00                	push   $0x0
  pushl $57
c0102130:	6a 39                	push   $0x39
  jmp __alltraps
c0102132:	e9 76 08 00 00       	jmp    c01029ad <__alltraps>

c0102137 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102137:	6a 00                	push   $0x0
  pushl $58
c0102139:	6a 3a                	push   $0x3a
  jmp __alltraps
c010213b:	e9 6d 08 00 00       	jmp    c01029ad <__alltraps>

c0102140 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102140:	6a 00                	push   $0x0
  pushl $59
c0102142:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102144:	e9 64 08 00 00       	jmp    c01029ad <__alltraps>

c0102149 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102149:	6a 00                	push   $0x0
  pushl $60
c010214b:	6a 3c                	push   $0x3c
  jmp __alltraps
c010214d:	e9 5b 08 00 00       	jmp    c01029ad <__alltraps>

c0102152 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102152:	6a 00                	push   $0x0
  pushl $61
c0102154:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102156:	e9 52 08 00 00       	jmp    c01029ad <__alltraps>

c010215b <vector62>:
.globl vector62
vector62:
  pushl $0
c010215b:	6a 00                	push   $0x0
  pushl $62
c010215d:	6a 3e                	push   $0x3e
  jmp __alltraps
c010215f:	e9 49 08 00 00       	jmp    c01029ad <__alltraps>

c0102164 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102164:	6a 00                	push   $0x0
  pushl $63
c0102166:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102168:	e9 40 08 00 00       	jmp    c01029ad <__alltraps>

c010216d <vector64>:
.globl vector64
vector64:
  pushl $0
c010216d:	6a 00                	push   $0x0
  pushl $64
c010216f:	6a 40                	push   $0x40
  jmp __alltraps
c0102171:	e9 37 08 00 00       	jmp    c01029ad <__alltraps>

c0102176 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102176:	6a 00                	push   $0x0
  pushl $65
c0102178:	6a 41                	push   $0x41
  jmp __alltraps
c010217a:	e9 2e 08 00 00       	jmp    c01029ad <__alltraps>

c010217f <vector66>:
.globl vector66
vector66:
  pushl $0
c010217f:	6a 00                	push   $0x0
  pushl $66
c0102181:	6a 42                	push   $0x42
  jmp __alltraps
c0102183:	e9 25 08 00 00       	jmp    c01029ad <__alltraps>

c0102188 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102188:	6a 00                	push   $0x0
  pushl $67
c010218a:	6a 43                	push   $0x43
  jmp __alltraps
c010218c:	e9 1c 08 00 00       	jmp    c01029ad <__alltraps>

c0102191 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102191:	6a 00                	push   $0x0
  pushl $68
c0102193:	6a 44                	push   $0x44
  jmp __alltraps
c0102195:	e9 13 08 00 00       	jmp    c01029ad <__alltraps>

c010219a <vector69>:
.globl vector69
vector69:
  pushl $0
c010219a:	6a 00                	push   $0x0
  pushl $69
c010219c:	6a 45                	push   $0x45
  jmp __alltraps
c010219e:	e9 0a 08 00 00       	jmp    c01029ad <__alltraps>

c01021a3 <vector70>:
.globl vector70
vector70:
  pushl $0
c01021a3:	6a 00                	push   $0x0
  pushl $70
c01021a5:	6a 46                	push   $0x46
  jmp __alltraps
c01021a7:	e9 01 08 00 00       	jmp    c01029ad <__alltraps>

c01021ac <vector71>:
.globl vector71
vector71:
  pushl $0
c01021ac:	6a 00                	push   $0x0
  pushl $71
c01021ae:	6a 47                	push   $0x47
  jmp __alltraps
c01021b0:	e9 f8 07 00 00       	jmp    c01029ad <__alltraps>

c01021b5 <vector72>:
.globl vector72
vector72:
  pushl $0
c01021b5:	6a 00                	push   $0x0
  pushl $72
c01021b7:	6a 48                	push   $0x48
  jmp __alltraps
c01021b9:	e9 ef 07 00 00       	jmp    c01029ad <__alltraps>

c01021be <vector73>:
.globl vector73
vector73:
  pushl $0
c01021be:	6a 00                	push   $0x0
  pushl $73
c01021c0:	6a 49                	push   $0x49
  jmp __alltraps
c01021c2:	e9 e6 07 00 00       	jmp    c01029ad <__alltraps>

c01021c7 <vector74>:
.globl vector74
vector74:
  pushl $0
c01021c7:	6a 00                	push   $0x0
  pushl $74
c01021c9:	6a 4a                	push   $0x4a
  jmp __alltraps
c01021cb:	e9 dd 07 00 00       	jmp    c01029ad <__alltraps>

c01021d0 <vector75>:
.globl vector75
vector75:
  pushl $0
c01021d0:	6a 00                	push   $0x0
  pushl $75
c01021d2:	6a 4b                	push   $0x4b
  jmp __alltraps
c01021d4:	e9 d4 07 00 00       	jmp    c01029ad <__alltraps>

c01021d9 <vector76>:
.globl vector76
vector76:
  pushl $0
c01021d9:	6a 00                	push   $0x0
  pushl $76
c01021db:	6a 4c                	push   $0x4c
  jmp __alltraps
c01021dd:	e9 cb 07 00 00       	jmp    c01029ad <__alltraps>

c01021e2 <vector77>:
.globl vector77
vector77:
  pushl $0
c01021e2:	6a 00                	push   $0x0
  pushl $77
c01021e4:	6a 4d                	push   $0x4d
  jmp __alltraps
c01021e6:	e9 c2 07 00 00       	jmp    c01029ad <__alltraps>

c01021eb <vector78>:
.globl vector78
vector78:
  pushl $0
c01021eb:	6a 00                	push   $0x0
  pushl $78
c01021ed:	6a 4e                	push   $0x4e
  jmp __alltraps
c01021ef:	e9 b9 07 00 00       	jmp    c01029ad <__alltraps>

c01021f4 <vector79>:
.globl vector79
vector79:
  pushl $0
c01021f4:	6a 00                	push   $0x0
  pushl $79
c01021f6:	6a 4f                	push   $0x4f
  jmp __alltraps
c01021f8:	e9 b0 07 00 00       	jmp    c01029ad <__alltraps>

c01021fd <vector80>:
.globl vector80
vector80:
  pushl $0
c01021fd:	6a 00                	push   $0x0
  pushl $80
c01021ff:	6a 50                	push   $0x50
  jmp __alltraps
c0102201:	e9 a7 07 00 00       	jmp    c01029ad <__alltraps>

c0102206 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102206:	6a 00                	push   $0x0
  pushl $81
c0102208:	6a 51                	push   $0x51
  jmp __alltraps
c010220a:	e9 9e 07 00 00       	jmp    c01029ad <__alltraps>

c010220f <vector82>:
.globl vector82
vector82:
  pushl $0
c010220f:	6a 00                	push   $0x0
  pushl $82
c0102211:	6a 52                	push   $0x52
  jmp __alltraps
c0102213:	e9 95 07 00 00       	jmp    c01029ad <__alltraps>

c0102218 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102218:	6a 00                	push   $0x0
  pushl $83
c010221a:	6a 53                	push   $0x53
  jmp __alltraps
c010221c:	e9 8c 07 00 00       	jmp    c01029ad <__alltraps>

c0102221 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102221:	6a 00                	push   $0x0
  pushl $84
c0102223:	6a 54                	push   $0x54
  jmp __alltraps
c0102225:	e9 83 07 00 00       	jmp    c01029ad <__alltraps>

c010222a <vector85>:
.globl vector85
vector85:
  pushl $0
c010222a:	6a 00                	push   $0x0
  pushl $85
c010222c:	6a 55                	push   $0x55
  jmp __alltraps
c010222e:	e9 7a 07 00 00       	jmp    c01029ad <__alltraps>

c0102233 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102233:	6a 00                	push   $0x0
  pushl $86
c0102235:	6a 56                	push   $0x56
  jmp __alltraps
c0102237:	e9 71 07 00 00       	jmp    c01029ad <__alltraps>

c010223c <vector87>:
.globl vector87
vector87:
  pushl $0
c010223c:	6a 00                	push   $0x0
  pushl $87
c010223e:	6a 57                	push   $0x57
  jmp __alltraps
c0102240:	e9 68 07 00 00       	jmp    c01029ad <__alltraps>

c0102245 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102245:	6a 00                	push   $0x0
  pushl $88
c0102247:	6a 58                	push   $0x58
  jmp __alltraps
c0102249:	e9 5f 07 00 00       	jmp    c01029ad <__alltraps>

c010224e <vector89>:
.globl vector89
vector89:
  pushl $0
c010224e:	6a 00                	push   $0x0
  pushl $89
c0102250:	6a 59                	push   $0x59
  jmp __alltraps
c0102252:	e9 56 07 00 00       	jmp    c01029ad <__alltraps>

c0102257 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102257:	6a 00                	push   $0x0
  pushl $90
c0102259:	6a 5a                	push   $0x5a
  jmp __alltraps
c010225b:	e9 4d 07 00 00       	jmp    c01029ad <__alltraps>

c0102260 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102260:	6a 00                	push   $0x0
  pushl $91
c0102262:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102264:	e9 44 07 00 00       	jmp    c01029ad <__alltraps>

c0102269 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102269:	6a 00                	push   $0x0
  pushl $92
c010226b:	6a 5c                	push   $0x5c
  jmp __alltraps
c010226d:	e9 3b 07 00 00       	jmp    c01029ad <__alltraps>

c0102272 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102272:	6a 00                	push   $0x0
  pushl $93
c0102274:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102276:	e9 32 07 00 00       	jmp    c01029ad <__alltraps>

c010227b <vector94>:
.globl vector94
vector94:
  pushl $0
c010227b:	6a 00                	push   $0x0
  pushl $94
c010227d:	6a 5e                	push   $0x5e
  jmp __alltraps
c010227f:	e9 29 07 00 00       	jmp    c01029ad <__alltraps>

c0102284 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102284:	6a 00                	push   $0x0
  pushl $95
c0102286:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102288:	e9 20 07 00 00       	jmp    c01029ad <__alltraps>

c010228d <vector96>:
.globl vector96
vector96:
  pushl $0
c010228d:	6a 00                	push   $0x0
  pushl $96
c010228f:	6a 60                	push   $0x60
  jmp __alltraps
c0102291:	e9 17 07 00 00       	jmp    c01029ad <__alltraps>

c0102296 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102296:	6a 00                	push   $0x0
  pushl $97
c0102298:	6a 61                	push   $0x61
  jmp __alltraps
c010229a:	e9 0e 07 00 00       	jmp    c01029ad <__alltraps>

c010229f <vector98>:
.globl vector98
vector98:
  pushl $0
c010229f:	6a 00                	push   $0x0
  pushl $98
c01022a1:	6a 62                	push   $0x62
  jmp __alltraps
c01022a3:	e9 05 07 00 00       	jmp    c01029ad <__alltraps>

c01022a8 <vector99>:
.globl vector99
vector99:
  pushl $0
c01022a8:	6a 00                	push   $0x0
  pushl $99
c01022aa:	6a 63                	push   $0x63
  jmp __alltraps
c01022ac:	e9 fc 06 00 00       	jmp    c01029ad <__alltraps>

c01022b1 <vector100>:
.globl vector100
vector100:
  pushl $0
c01022b1:	6a 00                	push   $0x0
  pushl $100
c01022b3:	6a 64                	push   $0x64
  jmp __alltraps
c01022b5:	e9 f3 06 00 00       	jmp    c01029ad <__alltraps>

c01022ba <vector101>:
.globl vector101
vector101:
  pushl $0
c01022ba:	6a 00                	push   $0x0
  pushl $101
c01022bc:	6a 65                	push   $0x65
  jmp __alltraps
c01022be:	e9 ea 06 00 00       	jmp    c01029ad <__alltraps>

c01022c3 <vector102>:
.globl vector102
vector102:
  pushl $0
c01022c3:	6a 00                	push   $0x0
  pushl $102
c01022c5:	6a 66                	push   $0x66
  jmp __alltraps
c01022c7:	e9 e1 06 00 00       	jmp    c01029ad <__alltraps>

c01022cc <vector103>:
.globl vector103
vector103:
  pushl $0
c01022cc:	6a 00                	push   $0x0
  pushl $103
c01022ce:	6a 67                	push   $0x67
  jmp __alltraps
c01022d0:	e9 d8 06 00 00       	jmp    c01029ad <__alltraps>

c01022d5 <vector104>:
.globl vector104
vector104:
  pushl $0
c01022d5:	6a 00                	push   $0x0
  pushl $104
c01022d7:	6a 68                	push   $0x68
  jmp __alltraps
c01022d9:	e9 cf 06 00 00       	jmp    c01029ad <__alltraps>

c01022de <vector105>:
.globl vector105
vector105:
  pushl $0
c01022de:	6a 00                	push   $0x0
  pushl $105
c01022e0:	6a 69                	push   $0x69
  jmp __alltraps
c01022e2:	e9 c6 06 00 00       	jmp    c01029ad <__alltraps>

c01022e7 <vector106>:
.globl vector106
vector106:
  pushl $0
c01022e7:	6a 00                	push   $0x0
  pushl $106
c01022e9:	6a 6a                	push   $0x6a
  jmp __alltraps
c01022eb:	e9 bd 06 00 00       	jmp    c01029ad <__alltraps>

c01022f0 <vector107>:
.globl vector107
vector107:
  pushl $0
c01022f0:	6a 00                	push   $0x0
  pushl $107
c01022f2:	6a 6b                	push   $0x6b
  jmp __alltraps
c01022f4:	e9 b4 06 00 00       	jmp    c01029ad <__alltraps>

c01022f9 <vector108>:
.globl vector108
vector108:
  pushl $0
c01022f9:	6a 00                	push   $0x0
  pushl $108
c01022fb:	6a 6c                	push   $0x6c
  jmp __alltraps
c01022fd:	e9 ab 06 00 00       	jmp    c01029ad <__alltraps>

c0102302 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102302:	6a 00                	push   $0x0
  pushl $109
c0102304:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102306:	e9 a2 06 00 00       	jmp    c01029ad <__alltraps>

c010230b <vector110>:
.globl vector110
vector110:
  pushl $0
c010230b:	6a 00                	push   $0x0
  pushl $110
c010230d:	6a 6e                	push   $0x6e
  jmp __alltraps
c010230f:	e9 99 06 00 00       	jmp    c01029ad <__alltraps>

c0102314 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102314:	6a 00                	push   $0x0
  pushl $111
c0102316:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102318:	e9 90 06 00 00       	jmp    c01029ad <__alltraps>

c010231d <vector112>:
.globl vector112
vector112:
  pushl $0
c010231d:	6a 00                	push   $0x0
  pushl $112
c010231f:	6a 70                	push   $0x70
  jmp __alltraps
c0102321:	e9 87 06 00 00       	jmp    c01029ad <__alltraps>

c0102326 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102326:	6a 00                	push   $0x0
  pushl $113
c0102328:	6a 71                	push   $0x71
  jmp __alltraps
c010232a:	e9 7e 06 00 00       	jmp    c01029ad <__alltraps>

c010232f <vector114>:
.globl vector114
vector114:
  pushl $0
c010232f:	6a 00                	push   $0x0
  pushl $114
c0102331:	6a 72                	push   $0x72
  jmp __alltraps
c0102333:	e9 75 06 00 00       	jmp    c01029ad <__alltraps>

c0102338 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102338:	6a 00                	push   $0x0
  pushl $115
c010233a:	6a 73                	push   $0x73
  jmp __alltraps
c010233c:	e9 6c 06 00 00       	jmp    c01029ad <__alltraps>

c0102341 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102341:	6a 00                	push   $0x0
  pushl $116
c0102343:	6a 74                	push   $0x74
  jmp __alltraps
c0102345:	e9 63 06 00 00       	jmp    c01029ad <__alltraps>

c010234a <vector117>:
.globl vector117
vector117:
  pushl $0
c010234a:	6a 00                	push   $0x0
  pushl $117
c010234c:	6a 75                	push   $0x75
  jmp __alltraps
c010234e:	e9 5a 06 00 00       	jmp    c01029ad <__alltraps>

c0102353 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102353:	6a 00                	push   $0x0
  pushl $118
c0102355:	6a 76                	push   $0x76
  jmp __alltraps
c0102357:	e9 51 06 00 00       	jmp    c01029ad <__alltraps>

c010235c <vector119>:
.globl vector119
vector119:
  pushl $0
c010235c:	6a 00                	push   $0x0
  pushl $119
c010235e:	6a 77                	push   $0x77
  jmp __alltraps
c0102360:	e9 48 06 00 00       	jmp    c01029ad <__alltraps>

c0102365 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102365:	6a 00                	push   $0x0
  pushl $120
c0102367:	6a 78                	push   $0x78
  jmp __alltraps
c0102369:	e9 3f 06 00 00       	jmp    c01029ad <__alltraps>

c010236e <vector121>:
.globl vector121
vector121:
  pushl $0
c010236e:	6a 00                	push   $0x0
  pushl $121
c0102370:	6a 79                	push   $0x79
  jmp __alltraps
c0102372:	e9 36 06 00 00       	jmp    c01029ad <__alltraps>

c0102377 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102377:	6a 00                	push   $0x0
  pushl $122
c0102379:	6a 7a                	push   $0x7a
  jmp __alltraps
c010237b:	e9 2d 06 00 00       	jmp    c01029ad <__alltraps>

c0102380 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102380:	6a 00                	push   $0x0
  pushl $123
c0102382:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102384:	e9 24 06 00 00       	jmp    c01029ad <__alltraps>

c0102389 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102389:	6a 00                	push   $0x0
  pushl $124
c010238b:	6a 7c                	push   $0x7c
  jmp __alltraps
c010238d:	e9 1b 06 00 00       	jmp    c01029ad <__alltraps>

c0102392 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102392:	6a 00                	push   $0x0
  pushl $125
c0102394:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102396:	e9 12 06 00 00       	jmp    c01029ad <__alltraps>

c010239b <vector126>:
.globl vector126
vector126:
  pushl $0
c010239b:	6a 00                	push   $0x0
  pushl $126
c010239d:	6a 7e                	push   $0x7e
  jmp __alltraps
c010239f:	e9 09 06 00 00       	jmp    c01029ad <__alltraps>

c01023a4 <vector127>:
.globl vector127
vector127:
  pushl $0
c01023a4:	6a 00                	push   $0x0
  pushl $127
c01023a6:	6a 7f                	push   $0x7f
  jmp __alltraps
c01023a8:	e9 00 06 00 00       	jmp    c01029ad <__alltraps>

c01023ad <vector128>:
.globl vector128
vector128:
  pushl $0
c01023ad:	6a 00                	push   $0x0
  pushl $128
c01023af:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01023b4:	e9 f4 05 00 00       	jmp    c01029ad <__alltraps>

c01023b9 <vector129>:
.globl vector129
vector129:
  pushl $0
c01023b9:	6a 00                	push   $0x0
  pushl $129
c01023bb:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01023c0:	e9 e8 05 00 00       	jmp    c01029ad <__alltraps>

c01023c5 <vector130>:
.globl vector130
vector130:
  pushl $0
c01023c5:	6a 00                	push   $0x0
  pushl $130
c01023c7:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01023cc:	e9 dc 05 00 00       	jmp    c01029ad <__alltraps>

c01023d1 <vector131>:
.globl vector131
vector131:
  pushl $0
c01023d1:	6a 00                	push   $0x0
  pushl $131
c01023d3:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01023d8:	e9 d0 05 00 00       	jmp    c01029ad <__alltraps>

c01023dd <vector132>:
.globl vector132
vector132:
  pushl $0
c01023dd:	6a 00                	push   $0x0
  pushl $132
c01023df:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01023e4:	e9 c4 05 00 00       	jmp    c01029ad <__alltraps>

c01023e9 <vector133>:
.globl vector133
vector133:
  pushl $0
c01023e9:	6a 00                	push   $0x0
  pushl $133
c01023eb:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01023f0:	e9 b8 05 00 00       	jmp    c01029ad <__alltraps>

c01023f5 <vector134>:
.globl vector134
vector134:
  pushl $0
c01023f5:	6a 00                	push   $0x0
  pushl $134
c01023f7:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01023fc:	e9 ac 05 00 00       	jmp    c01029ad <__alltraps>

c0102401 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102401:	6a 00                	push   $0x0
  pushl $135
c0102403:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102408:	e9 a0 05 00 00       	jmp    c01029ad <__alltraps>

c010240d <vector136>:
.globl vector136
vector136:
  pushl $0
c010240d:	6a 00                	push   $0x0
  pushl $136
c010240f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102414:	e9 94 05 00 00       	jmp    c01029ad <__alltraps>

c0102419 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102419:	6a 00                	push   $0x0
  pushl $137
c010241b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102420:	e9 88 05 00 00       	jmp    c01029ad <__alltraps>

c0102425 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102425:	6a 00                	push   $0x0
  pushl $138
c0102427:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010242c:	e9 7c 05 00 00       	jmp    c01029ad <__alltraps>

c0102431 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102431:	6a 00                	push   $0x0
  pushl $139
c0102433:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102438:	e9 70 05 00 00       	jmp    c01029ad <__alltraps>

c010243d <vector140>:
.globl vector140
vector140:
  pushl $0
c010243d:	6a 00                	push   $0x0
  pushl $140
c010243f:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102444:	e9 64 05 00 00       	jmp    c01029ad <__alltraps>

c0102449 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102449:	6a 00                	push   $0x0
  pushl $141
c010244b:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102450:	e9 58 05 00 00       	jmp    c01029ad <__alltraps>

c0102455 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102455:	6a 00                	push   $0x0
  pushl $142
c0102457:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010245c:	e9 4c 05 00 00       	jmp    c01029ad <__alltraps>

c0102461 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102461:	6a 00                	push   $0x0
  pushl $143
c0102463:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102468:	e9 40 05 00 00       	jmp    c01029ad <__alltraps>

c010246d <vector144>:
.globl vector144
vector144:
  pushl $0
c010246d:	6a 00                	push   $0x0
  pushl $144
c010246f:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102474:	e9 34 05 00 00       	jmp    c01029ad <__alltraps>

c0102479 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102479:	6a 00                	push   $0x0
  pushl $145
c010247b:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102480:	e9 28 05 00 00       	jmp    c01029ad <__alltraps>

c0102485 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102485:	6a 00                	push   $0x0
  pushl $146
c0102487:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010248c:	e9 1c 05 00 00       	jmp    c01029ad <__alltraps>

c0102491 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102491:	6a 00                	push   $0x0
  pushl $147
c0102493:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102498:	e9 10 05 00 00       	jmp    c01029ad <__alltraps>

c010249d <vector148>:
.globl vector148
vector148:
  pushl $0
c010249d:	6a 00                	push   $0x0
  pushl $148
c010249f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01024a4:	e9 04 05 00 00       	jmp    c01029ad <__alltraps>

c01024a9 <vector149>:
.globl vector149
vector149:
  pushl $0
c01024a9:	6a 00                	push   $0x0
  pushl $149
c01024ab:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01024b0:	e9 f8 04 00 00       	jmp    c01029ad <__alltraps>

c01024b5 <vector150>:
.globl vector150
vector150:
  pushl $0
c01024b5:	6a 00                	push   $0x0
  pushl $150
c01024b7:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01024bc:	e9 ec 04 00 00       	jmp    c01029ad <__alltraps>

c01024c1 <vector151>:
.globl vector151
vector151:
  pushl $0
c01024c1:	6a 00                	push   $0x0
  pushl $151
c01024c3:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01024c8:	e9 e0 04 00 00       	jmp    c01029ad <__alltraps>

c01024cd <vector152>:
.globl vector152
vector152:
  pushl $0
c01024cd:	6a 00                	push   $0x0
  pushl $152
c01024cf:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01024d4:	e9 d4 04 00 00       	jmp    c01029ad <__alltraps>

c01024d9 <vector153>:
.globl vector153
vector153:
  pushl $0
c01024d9:	6a 00                	push   $0x0
  pushl $153
c01024db:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01024e0:	e9 c8 04 00 00       	jmp    c01029ad <__alltraps>

c01024e5 <vector154>:
.globl vector154
vector154:
  pushl $0
c01024e5:	6a 00                	push   $0x0
  pushl $154
c01024e7:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01024ec:	e9 bc 04 00 00       	jmp    c01029ad <__alltraps>

c01024f1 <vector155>:
.globl vector155
vector155:
  pushl $0
c01024f1:	6a 00                	push   $0x0
  pushl $155
c01024f3:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01024f8:	e9 b0 04 00 00       	jmp    c01029ad <__alltraps>

c01024fd <vector156>:
.globl vector156
vector156:
  pushl $0
c01024fd:	6a 00                	push   $0x0
  pushl $156
c01024ff:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102504:	e9 a4 04 00 00       	jmp    c01029ad <__alltraps>

c0102509 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102509:	6a 00                	push   $0x0
  pushl $157
c010250b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102510:	e9 98 04 00 00       	jmp    c01029ad <__alltraps>

c0102515 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102515:	6a 00                	push   $0x0
  pushl $158
c0102517:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010251c:	e9 8c 04 00 00       	jmp    c01029ad <__alltraps>

c0102521 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102521:	6a 00                	push   $0x0
  pushl $159
c0102523:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102528:	e9 80 04 00 00       	jmp    c01029ad <__alltraps>

c010252d <vector160>:
.globl vector160
vector160:
  pushl $0
c010252d:	6a 00                	push   $0x0
  pushl $160
c010252f:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102534:	e9 74 04 00 00       	jmp    c01029ad <__alltraps>

c0102539 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102539:	6a 00                	push   $0x0
  pushl $161
c010253b:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102540:	e9 68 04 00 00       	jmp    c01029ad <__alltraps>

c0102545 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102545:	6a 00                	push   $0x0
  pushl $162
c0102547:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010254c:	e9 5c 04 00 00       	jmp    c01029ad <__alltraps>

c0102551 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102551:	6a 00                	push   $0x0
  pushl $163
c0102553:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102558:	e9 50 04 00 00       	jmp    c01029ad <__alltraps>

c010255d <vector164>:
.globl vector164
vector164:
  pushl $0
c010255d:	6a 00                	push   $0x0
  pushl $164
c010255f:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102564:	e9 44 04 00 00       	jmp    c01029ad <__alltraps>

c0102569 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102569:	6a 00                	push   $0x0
  pushl $165
c010256b:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102570:	e9 38 04 00 00       	jmp    c01029ad <__alltraps>

c0102575 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102575:	6a 00                	push   $0x0
  pushl $166
c0102577:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010257c:	e9 2c 04 00 00       	jmp    c01029ad <__alltraps>

c0102581 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102581:	6a 00                	push   $0x0
  pushl $167
c0102583:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102588:	e9 20 04 00 00       	jmp    c01029ad <__alltraps>

c010258d <vector168>:
.globl vector168
vector168:
  pushl $0
c010258d:	6a 00                	push   $0x0
  pushl $168
c010258f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102594:	e9 14 04 00 00       	jmp    c01029ad <__alltraps>

c0102599 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102599:	6a 00                	push   $0x0
  pushl $169
c010259b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01025a0:	e9 08 04 00 00       	jmp    c01029ad <__alltraps>

c01025a5 <vector170>:
.globl vector170
vector170:
  pushl $0
c01025a5:	6a 00                	push   $0x0
  pushl $170
c01025a7:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01025ac:	e9 fc 03 00 00       	jmp    c01029ad <__alltraps>

c01025b1 <vector171>:
.globl vector171
vector171:
  pushl $0
c01025b1:	6a 00                	push   $0x0
  pushl $171
c01025b3:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01025b8:	e9 f0 03 00 00       	jmp    c01029ad <__alltraps>

c01025bd <vector172>:
.globl vector172
vector172:
  pushl $0
c01025bd:	6a 00                	push   $0x0
  pushl $172
c01025bf:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01025c4:	e9 e4 03 00 00       	jmp    c01029ad <__alltraps>

c01025c9 <vector173>:
.globl vector173
vector173:
  pushl $0
c01025c9:	6a 00                	push   $0x0
  pushl $173
c01025cb:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01025d0:	e9 d8 03 00 00       	jmp    c01029ad <__alltraps>

c01025d5 <vector174>:
.globl vector174
vector174:
  pushl $0
c01025d5:	6a 00                	push   $0x0
  pushl $174
c01025d7:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01025dc:	e9 cc 03 00 00       	jmp    c01029ad <__alltraps>

c01025e1 <vector175>:
.globl vector175
vector175:
  pushl $0
c01025e1:	6a 00                	push   $0x0
  pushl $175
c01025e3:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01025e8:	e9 c0 03 00 00       	jmp    c01029ad <__alltraps>

c01025ed <vector176>:
.globl vector176
vector176:
  pushl $0
c01025ed:	6a 00                	push   $0x0
  pushl $176
c01025ef:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01025f4:	e9 b4 03 00 00       	jmp    c01029ad <__alltraps>

c01025f9 <vector177>:
.globl vector177
vector177:
  pushl $0
c01025f9:	6a 00                	push   $0x0
  pushl $177
c01025fb:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102600:	e9 a8 03 00 00       	jmp    c01029ad <__alltraps>

c0102605 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102605:	6a 00                	push   $0x0
  pushl $178
c0102607:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010260c:	e9 9c 03 00 00       	jmp    c01029ad <__alltraps>

c0102611 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102611:	6a 00                	push   $0x0
  pushl $179
c0102613:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102618:	e9 90 03 00 00       	jmp    c01029ad <__alltraps>

c010261d <vector180>:
.globl vector180
vector180:
  pushl $0
c010261d:	6a 00                	push   $0x0
  pushl $180
c010261f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102624:	e9 84 03 00 00       	jmp    c01029ad <__alltraps>

c0102629 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102629:	6a 00                	push   $0x0
  pushl $181
c010262b:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102630:	e9 78 03 00 00       	jmp    c01029ad <__alltraps>

c0102635 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102635:	6a 00                	push   $0x0
  pushl $182
c0102637:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010263c:	e9 6c 03 00 00       	jmp    c01029ad <__alltraps>

c0102641 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102641:	6a 00                	push   $0x0
  pushl $183
c0102643:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102648:	e9 60 03 00 00       	jmp    c01029ad <__alltraps>

c010264d <vector184>:
.globl vector184
vector184:
  pushl $0
c010264d:	6a 00                	push   $0x0
  pushl $184
c010264f:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102654:	e9 54 03 00 00       	jmp    c01029ad <__alltraps>

c0102659 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102659:	6a 00                	push   $0x0
  pushl $185
c010265b:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102660:	e9 48 03 00 00       	jmp    c01029ad <__alltraps>

c0102665 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102665:	6a 00                	push   $0x0
  pushl $186
c0102667:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010266c:	e9 3c 03 00 00       	jmp    c01029ad <__alltraps>

c0102671 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102671:	6a 00                	push   $0x0
  pushl $187
c0102673:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102678:	e9 30 03 00 00       	jmp    c01029ad <__alltraps>

c010267d <vector188>:
.globl vector188
vector188:
  pushl $0
c010267d:	6a 00                	push   $0x0
  pushl $188
c010267f:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102684:	e9 24 03 00 00       	jmp    c01029ad <__alltraps>

c0102689 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102689:	6a 00                	push   $0x0
  pushl $189
c010268b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102690:	e9 18 03 00 00       	jmp    c01029ad <__alltraps>

c0102695 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102695:	6a 00                	push   $0x0
  pushl $190
c0102697:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010269c:	e9 0c 03 00 00       	jmp    c01029ad <__alltraps>

c01026a1 <vector191>:
.globl vector191
vector191:
  pushl $0
c01026a1:	6a 00                	push   $0x0
  pushl $191
c01026a3:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01026a8:	e9 00 03 00 00       	jmp    c01029ad <__alltraps>

c01026ad <vector192>:
.globl vector192
vector192:
  pushl $0
c01026ad:	6a 00                	push   $0x0
  pushl $192
c01026af:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01026b4:	e9 f4 02 00 00       	jmp    c01029ad <__alltraps>

c01026b9 <vector193>:
.globl vector193
vector193:
  pushl $0
c01026b9:	6a 00                	push   $0x0
  pushl $193
c01026bb:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01026c0:	e9 e8 02 00 00       	jmp    c01029ad <__alltraps>

c01026c5 <vector194>:
.globl vector194
vector194:
  pushl $0
c01026c5:	6a 00                	push   $0x0
  pushl $194
c01026c7:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01026cc:	e9 dc 02 00 00       	jmp    c01029ad <__alltraps>

c01026d1 <vector195>:
.globl vector195
vector195:
  pushl $0
c01026d1:	6a 00                	push   $0x0
  pushl $195
c01026d3:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01026d8:	e9 d0 02 00 00       	jmp    c01029ad <__alltraps>

c01026dd <vector196>:
.globl vector196
vector196:
  pushl $0
c01026dd:	6a 00                	push   $0x0
  pushl $196
c01026df:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01026e4:	e9 c4 02 00 00       	jmp    c01029ad <__alltraps>

c01026e9 <vector197>:
.globl vector197
vector197:
  pushl $0
c01026e9:	6a 00                	push   $0x0
  pushl $197
c01026eb:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01026f0:	e9 b8 02 00 00       	jmp    c01029ad <__alltraps>

c01026f5 <vector198>:
.globl vector198
vector198:
  pushl $0
c01026f5:	6a 00                	push   $0x0
  pushl $198
c01026f7:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01026fc:	e9 ac 02 00 00       	jmp    c01029ad <__alltraps>

c0102701 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102701:	6a 00                	push   $0x0
  pushl $199
c0102703:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102708:	e9 a0 02 00 00       	jmp    c01029ad <__alltraps>

c010270d <vector200>:
.globl vector200
vector200:
  pushl $0
c010270d:	6a 00                	push   $0x0
  pushl $200
c010270f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102714:	e9 94 02 00 00       	jmp    c01029ad <__alltraps>

c0102719 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102719:	6a 00                	push   $0x0
  pushl $201
c010271b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102720:	e9 88 02 00 00       	jmp    c01029ad <__alltraps>

c0102725 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102725:	6a 00                	push   $0x0
  pushl $202
c0102727:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010272c:	e9 7c 02 00 00       	jmp    c01029ad <__alltraps>

c0102731 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102731:	6a 00                	push   $0x0
  pushl $203
c0102733:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102738:	e9 70 02 00 00       	jmp    c01029ad <__alltraps>

c010273d <vector204>:
.globl vector204
vector204:
  pushl $0
c010273d:	6a 00                	push   $0x0
  pushl $204
c010273f:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102744:	e9 64 02 00 00       	jmp    c01029ad <__alltraps>

c0102749 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102749:	6a 00                	push   $0x0
  pushl $205
c010274b:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102750:	e9 58 02 00 00       	jmp    c01029ad <__alltraps>

c0102755 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102755:	6a 00                	push   $0x0
  pushl $206
c0102757:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010275c:	e9 4c 02 00 00       	jmp    c01029ad <__alltraps>

c0102761 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102761:	6a 00                	push   $0x0
  pushl $207
c0102763:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102768:	e9 40 02 00 00       	jmp    c01029ad <__alltraps>

c010276d <vector208>:
.globl vector208
vector208:
  pushl $0
c010276d:	6a 00                	push   $0x0
  pushl $208
c010276f:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102774:	e9 34 02 00 00       	jmp    c01029ad <__alltraps>

c0102779 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102779:	6a 00                	push   $0x0
  pushl $209
c010277b:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102780:	e9 28 02 00 00       	jmp    c01029ad <__alltraps>

c0102785 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102785:	6a 00                	push   $0x0
  pushl $210
c0102787:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010278c:	e9 1c 02 00 00       	jmp    c01029ad <__alltraps>

c0102791 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102791:	6a 00                	push   $0x0
  pushl $211
c0102793:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102798:	e9 10 02 00 00       	jmp    c01029ad <__alltraps>

c010279d <vector212>:
.globl vector212
vector212:
  pushl $0
c010279d:	6a 00                	push   $0x0
  pushl $212
c010279f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01027a4:	e9 04 02 00 00       	jmp    c01029ad <__alltraps>

c01027a9 <vector213>:
.globl vector213
vector213:
  pushl $0
c01027a9:	6a 00                	push   $0x0
  pushl $213
c01027ab:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01027b0:	e9 f8 01 00 00       	jmp    c01029ad <__alltraps>

c01027b5 <vector214>:
.globl vector214
vector214:
  pushl $0
c01027b5:	6a 00                	push   $0x0
  pushl $214
c01027b7:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01027bc:	e9 ec 01 00 00       	jmp    c01029ad <__alltraps>

c01027c1 <vector215>:
.globl vector215
vector215:
  pushl $0
c01027c1:	6a 00                	push   $0x0
  pushl $215
c01027c3:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01027c8:	e9 e0 01 00 00       	jmp    c01029ad <__alltraps>

c01027cd <vector216>:
.globl vector216
vector216:
  pushl $0
c01027cd:	6a 00                	push   $0x0
  pushl $216
c01027cf:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01027d4:	e9 d4 01 00 00       	jmp    c01029ad <__alltraps>

c01027d9 <vector217>:
.globl vector217
vector217:
  pushl $0
c01027d9:	6a 00                	push   $0x0
  pushl $217
c01027db:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01027e0:	e9 c8 01 00 00       	jmp    c01029ad <__alltraps>

c01027e5 <vector218>:
.globl vector218
vector218:
  pushl $0
c01027e5:	6a 00                	push   $0x0
  pushl $218
c01027e7:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01027ec:	e9 bc 01 00 00       	jmp    c01029ad <__alltraps>

c01027f1 <vector219>:
.globl vector219
vector219:
  pushl $0
c01027f1:	6a 00                	push   $0x0
  pushl $219
c01027f3:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01027f8:	e9 b0 01 00 00       	jmp    c01029ad <__alltraps>

c01027fd <vector220>:
.globl vector220
vector220:
  pushl $0
c01027fd:	6a 00                	push   $0x0
  pushl $220
c01027ff:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102804:	e9 a4 01 00 00       	jmp    c01029ad <__alltraps>

c0102809 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102809:	6a 00                	push   $0x0
  pushl $221
c010280b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102810:	e9 98 01 00 00       	jmp    c01029ad <__alltraps>

c0102815 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102815:	6a 00                	push   $0x0
  pushl $222
c0102817:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010281c:	e9 8c 01 00 00       	jmp    c01029ad <__alltraps>

c0102821 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102821:	6a 00                	push   $0x0
  pushl $223
c0102823:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102828:	e9 80 01 00 00       	jmp    c01029ad <__alltraps>

c010282d <vector224>:
.globl vector224
vector224:
  pushl $0
c010282d:	6a 00                	push   $0x0
  pushl $224
c010282f:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102834:	e9 74 01 00 00       	jmp    c01029ad <__alltraps>

c0102839 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102839:	6a 00                	push   $0x0
  pushl $225
c010283b:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102840:	e9 68 01 00 00       	jmp    c01029ad <__alltraps>

c0102845 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102845:	6a 00                	push   $0x0
  pushl $226
c0102847:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010284c:	e9 5c 01 00 00       	jmp    c01029ad <__alltraps>

c0102851 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102851:	6a 00                	push   $0x0
  pushl $227
c0102853:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102858:	e9 50 01 00 00       	jmp    c01029ad <__alltraps>

c010285d <vector228>:
.globl vector228
vector228:
  pushl $0
c010285d:	6a 00                	push   $0x0
  pushl $228
c010285f:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102864:	e9 44 01 00 00       	jmp    c01029ad <__alltraps>

c0102869 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102869:	6a 00                	push   $0x0
  pushl $229
c010286b:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102870:	e9 38 01 00 00       	jmp    c01029ad <__alltraps>

c0102875 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102875:	6a 00                	push   $0x0
  pushl $230
c0102877:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010287c:	e9 2c 01 00 00       	jmp    c01029ad <__alltraps>

c0102881 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102881:	6a 00                	push   $0x0
  pushl $231
c0102883:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102888:	e9 20 01 00 00       	jmp    c01029ad <__alltraps>

c010288d <vector232>:
.globl vector232
vector232:
  pushl $0
c010288d:	6a 00                	push   $0x0
  pushl $232
c010288f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102894:	e9 14 01 00 00       	jmp    c01029ad <__alltraps>

c0102899 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102899:	6a 00                	push   $0x0
  pushl $233
c010289b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01028a0:	e9 08 01 00 00       	jmp    c01029ad <__alltraps>

c01028a5 <vector234>:
.globl vector234
vector234:
  pushl $0
c01028a5:	6a 00                	push   $0x0
  pushl $234
c01028a7:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01028ac:	e9 fc 00 00 00       	jmp    c01029ad <__alltraps>

c01028b1 <vector235>:
.globl vector235
vector235:
  pushl $0
c01028b1:	6a 00                	push   $0x0
  pushl $235
c01028b3:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01028b8:	e9 f0 00 00 00       	jmp    c01029ad <__alltraps>

c01028bd <vector236>:
.globl vector236
vector236:
  pushl $0
c01028bd:	6a 00                	push   $0x0
  pushl $236
c01028bf:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01028c4:	e9 e4 00 00 00       	jmp    c01029ad <__alltraps>

c01028c9 <vector237>:
.globl vector237
vector237:
  pushl $0
c01028c9:	6a 00                	push   $0x0
  pushl $237
c01028cb:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01028d0:	e9 d8 00 00 00       	jmp    c01029ad <__alltraps>

c01028d5 <vector238>:
.globl vector238
vector238:
  pushl $0
c01028d5:	6a 00                	push   $0x0
  pushl $238
c01028d7:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01028dc:	e9 cc 00 00 00       	jmp    c01029ad <__alltraps>

c01028e1 <vector239>:
.globl vector239
vector239:
  pushl $0
c01028e1:	6a 00                	push   $0x0
  pushl $239
c01028e3:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01028e8:	e9 c0 00 00 00       	jmp    c01029ad <__alltraps>

c01028ed <vector240>:
.globl vector240
vector240:
  pushl $0
c01028ed:	6a 00                	push   $0x0
  pushl $240
c01028ef:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01028f4:	e9 b4 00 00 00       	jmp    c01029ad <__alltraps>

c01028f9 <vector241>:
.globl vector241
vector241:
  pushl $0
c01028f9:	6a 00                	push   $0x0
  pushl $241
c01028fb:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102900:	e9 a8 00 00 00       	jmp    c01029ad <__alltraps>

c0102905 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102905:	6a 00                	push   $0x0
  pushl $242
c0102907:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010290c:	e9 9c 00 00 00       	jmp    c01029ad <__alltraps>

c0102911 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102911:	6a 00                	push   $0x0
  pushl $243
c0102913:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102918:	e9 90 00 00 00       	jmp    c01029ad <__alltraps>

c010291d <vector244>:
.globl vector244
vector244:
  pushl $0
c010291d:	6a 00                	push   $0x0
  pushl $244
c010291f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102924:	e9 84 00 00 00       	jmp    c01029ad <__alltraps>

c0102929 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102929:	6a 00                	push   $0x0
  pushl $245
c010292b:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102930:	e9 78 00 00 00       	jmp    c01029ad <__alltraps>

c0102935 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102935:	6a 00                	push   $0x0
  pushl $246
c0102937:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010293c:	e9 6c 00 00 00       	jmp    c01029ad <__alltraps>

c0102941 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102941:	6a 00                	push   $0x0
  pushl $247
c0102943:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102948:	e9 60 00 00 00       	jmp    c01029ad <__alltraps>

c010294d <vector248>:
.globl vector248
vector248:
  pushl $0
c010294d:	6a 00                	push   $0x0
  pushl $248
c010294f:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102954:	e9 54 00 00 00       	jmp    c01029ad <__alltraps>

c0102959 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102959:	6a 00                	push   $0x0
  pushl $249
c010295b:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102960:	e9 48 00 00 00       	jmp    c01029ad <__alltraps>

c0102965 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102965:	6a 00                	push   $0x0
  pushl $250
c0102967:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010296c:	e9 3c 00 00 00       	jmp    c01029ad <__alltraps>

c0102971 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102971:	6a 00                	push   $0x0
  pushl $251
c0102973:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102978:	e9 30 00 00 00       	jmp    c01029ad <__alltraps>

c010297d <vector252>:
.globl vector252
vector252:
  pushl $0
c010297d:	6a 00                	push   $0x0
  pushl $252
c010297f:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102984:	e9 24 00 00 00       	jmp    c01029ad <__alltraps>

c0102989 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102989:	6a 00                	push   $0x0
  pushl $253
c010298b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102990:	e9 18 00 00 00       	jmp    c01029ad <__alltraps>

c0102995 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102995:	6a 00                	push   $0x0
  pushl $254
c0102997:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010299c:	e9 0c 00 00 00       	jmp    c01029ad <__alltraps>

c01029a1 <vector255>:
.globl vector255
vector255:
  pushl $0
c01029a1:	6a 00                	push   $0x0
  pushl $255
c01029a3:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01029a8:	e9 00 00 00 00       	jmp    c01029ad <__alltraps>

c01029ad <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01029ad:	1e                   	push   %ds
    pushl %es
c01029ae:	06                   	push   %es
    pushl %fs
c01029af:	0f a0                	push   %fs
    pushl %gs
c01029b1:	0f a8                	push   %gs
    pushal
c01029b3:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01029b4:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01029b9:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01029bb:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01029bd:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01029be:	e8 67 f5 ff ff       	call   c0101f2a <trap>

    # pop the pushed stack pointer
    popl %esp
c01029c3:	5c                   	pop    %esp

c01029c4 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01029c4:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01029c5:	0f a9                	pop    %gs
    popl %fs
c01029c7:	0f a1                	pop    %fs
    popl %es
c01029c9:	07                   	pop    %es
    popl %ds
c01029ca:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01029cb:	83 c4 08             	add    $0x8,%esp
    iret
c01029ce:	cf                   	iret   

c01029cf <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01029cf:	55                   	push   %ebp
c01029d0:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01029d2:	8b 55 08             	mov    0x8(%ebp),%edx
c01029d5:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01029da:	29 c2                	sub    %eax,%edx
c01029dc:	89 d0                	mov    %edx,%eax
c01029de:	c1 f8 02             	sar    $0x2,%eax
c01029e1:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01029e7:	5d                   	pop    %ebp
c01029e8:	c3                   	ret    

c01029e9 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01029e9:	55                   	push   %ebp
c01029ea:	89 e5                	mov    %esp,%ebp
c01029ec:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01029ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01029f2:	89 04 24             	mov    %eax,(%esp)
c01029f5:	e8 d5 ff ff ff       	call   c01029cf <page2ppn>
c01029fa:	c1 e0 0c             	shl    $0xc,%eax
}
c01029fd:	c9                   	leave  
c01029fe:	c3                   	ret    

c01029ff <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01029ff:	55                   	push   %ebp
c0102a00:	89 e5                	mov    %esp,%ebp
c0102a02:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102a05:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a08:	c1 e8 0c             	shr    $0xc,%eax
c0102a0b:	89 c2                	mov    %eax,%edx
c0102a0d:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102a12:	39 c2                	cmp    %eax,%edx
c0102a14:	72 1c                	jb     c0102a32 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102a16:	c7 44 24 08 b0 68 10 	movl   $0xc01068b0,0x8(%esp)
c0102a1d:	c0 
c0102a1e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102a25:	00 
c0102a26:	c7 04 24 cf 68 10 c0 	movl   $0xc01068cf,(%esp)
c0102a2d:	e8 b6 d9 ff ff       	call   c01003e8 <__panic>
    }
    return &pages[PPN(pa)];
c0102a32:	8b 0d 58 89 11 c0    	mov    0xc0118958,%ecx
c0102a38:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a3b:	c1 e8 0c             	shr    $0xc,%eax
c0102a3e:	89 c2                	mov    %eax,%edx
c0102a40:	89 d0                	mov    %edx,%eax
c0102a42:	c1 e0 02             	shl    $0x2,%eax
c0102a45:	01 d0                	add    %edx,%eax
c0102a47:	c1 e0 02             	shl    $0x2,%eax
c0102a4a:	01 c8                	add    %ecx,%eax
}
c0102a4c:	c9                   	leave  
c0102a4d:	c3                   	ret    

c0102a4e <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102a4e:	55                   	push   %ebp
c0102a4f:	89 e5                	mov    %esp,%ebp
c0102a51:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102a54:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a57:	89 04 24             	mov    %eax,(%esp)
c0102a5a:	e8 8a ff ff ff       	call   c01029e9 <page2pa>
c0102a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a65:	c1 e8 0c             	shr    $0xc,%eax
c0102a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a6b:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102a70:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102a73:	72 23                	jb     c0102a98 <page2kva+0x4a>
c0102a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a78:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102a7c:	c7 44 24 08 e0 68 10 	movl   $0xc01068e0,0x8(%esp)
c0102a83:	c0 
c0102a84:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102a8b:	00 
c0102a8c:	c7 04 24 cf 68 10 c0 	movl   $0xc01068cf,(%esp)
c0102a93:	e8 50 d9 ff ff       	call   c01003e8 <__panic>
c0102a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a9b:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102aa0:	c9                   	leave  
c0102aa1:	c3                   	ret    

c0102aa2 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102aa2:	55                   	push   %ebp
c0102aa3:	89 e5                	mov    %esp,%ebp
c0102aa5:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102aa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aab:	83 e0 01             	and    $0x1,%eax
c0102aae:	85 c0                	test   %eax,%eax
c0102ab0:	75 1c                	jne    c0102ace <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102ab2:	c7 44 24 08 04 69 10 	movl   $0xc0106904,0x8(%esp)
c0102ab9:	c0 
c0102aba:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102ac1:	00 
c0102ac2:	c7 04 24 cf 68 10 c0 	movl   $0xc01068cf,(%esp)
c0102ac9:	e8 1a d9 ff ff       	call   c01003e8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102ace:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ad1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102ad6:	89 04 24             	mov    %eax,(%esp)
c0102ad9:	e8 21 ff ff ff       	call   c01029ff <pa2page>
}
c0102ade:	c9                   	leave  
c0102adf:	c3                   	ret    

c0102ae0 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102ae0:	55                   	push   %ebp
c0102ae1:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102ae3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ae6:	8b 00                	mov    (%eax),%eax
}
c0102ae8:	5d                   	pop    %ebp
c0102ae9:	c3                   	ret    

c0102aea <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102aea:	55                   	push   %ebp
c0102aeb:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102aed:	8b 45 08             	mov    0x8(%ebp),%eax
c0102af0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102af3:	89 10                	mov    %edx,(%eax)
}
c0102af5:	5d                   	pop    %ebp
c0102af6:	c3                   	ret    

c0102af7 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102af7:	55                   	push   %ebp
c0102af8:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102afa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102afd:	8b 00                	mov    (%eax),%eax
c0102aff:	8d 50 01             	lea    0x1(%eax),%edx
c0102b02:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b05:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102b07:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b0a:	8b 00                	mov    (%eax),%eax
}
c0102b0c:	5d                   	pop    %ebp
c0102b0d:	c3                   	ret    

c0102b0e <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102b0e:	55                   	push   %ebp
c0102b0f:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b14:	8b 00                	mov    (%eax),%eax
c0102b16:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102b19:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b1c:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b21:	8b 00                	mov    (%eax),%eax
}
c0102b23:	5d                   	pop    %ebp
c0102b24:	c3                   	ret    

c0102b25 <__intr_save>:
__intr_save(void) {
c0102b25:	55                   	push   %ebp
c0102b26:	89 e5                	mov    %esp,%ebp
c0102b28:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102b2b:	9c                   	pushf  
c0102b2c:	58                   	pop    %eax
c0102b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102b33:	25 00 02 00 00       	and    $0x200,%eax
c0102b38:	85 c0                	test   %eax,%eax
c0102b3a:	74 0c                	je     c0102b48 <__intr_save+0x23>
        intr_disable();
c0102b3c:	e8 3b ed ff ff       	call   c010187c <intr_disable>
        return 1;
c0102b41:	b8 01 00 00 00       	mov    $0x1,%eax
c0102b46:	eb 05                	jmp    c0102b4d <__intr_save+0x28>
    return 0;
c0102b48:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102b4d:	c9                   	leave  
c0102b4e:	c3                   	ret    

c0102b4f <__intr_restore>:
__intr_restore(bool flag) {
c0102b4f:	55                   	push   %ebp
c0102b50:	89 e5                	mov    %esp,%ebp
c0102b52:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102b55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102b59:	74 05                	je     c0102b60 <__intr_restore+0x11>
        intr_enable();
c0102b5b:	e8 16 ed ff ff       	call   c0101876 <intr_enable>
}
c0102b60:	c9                   	leave  
c0102b61:	c3                   	ret    

c0102b62 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102b62:	55                   	push   %ebp
c0102b63:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102b65:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b68:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102b6b:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b70:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102b72:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b77:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102b79:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b7e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102b80:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b85:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102b87:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b8c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102b8e:	ea 95 2b 10 c0 08 00 	ljmp   $0x8,$0xc0102b95
}
c0102b95:	5d                   	pop    %ebp
c0102b96:	c3                   	ret    

c0102b97 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102b97:	55                   	push   %ebp
c0102b98:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102b9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b9d:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0102ba2:	5d                   	pop    %ebp
c0102ba3:	c3                   	ret    

c0102ba4 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102ba4:	55                   	push   %ebp
c0102ba5:	89 e5                	mov    %esp,%ebp
c0102ba7:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102baa:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102baf:	89 04 24             	mov    %eax,(%esp)
c0102bb2:	e8 e0 ff ff ff       	call   c0102b97 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102bb7:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0102bbe:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102bc0:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102bc7:	68 00 
c0102bc9:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102bce:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102bd4:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102bd9:	c1 e8 10             	shr    $0x10,%eax
c0102bdc:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102be1:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102be8:	83 e0 f0             	and    $0xfffffff0,%eax
c0102beb:	83 c8 09             	or     $0x9,%eax
c0102bee:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102bf3:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102bfa:	83 e0 ef             	and    $0xffffffef,%eax
c0102bfd:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102c02:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102c09:	83 e0 9f             	and    $0xffffff9f,%eax
c0102c0c:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102c11:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102c18:	83 c8 80             	or     $0xffffff80,%eax
c0102c1b:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102c20:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102c27:	83 e0 f0             	and    $0xfffffff0,%eax
c0102c2a:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c2f:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102c36:	83 e0 ef             	and    $0xffffffef,%eax
c0102c39:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c3e:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102c45:	83 e0 df             	and    $0xffffffdf,%eax
c0102c48:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c4d:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102c54:	83 c8 40             	or     $0x40,%eax
c0102c57:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c5c:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102c63:	83 e0 7f             	and    $0x7f,%eax
c0102c66:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c6b:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102c70:	c1 e8 18             	shr    $0x18,%eax
c0102c73:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102c78:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0102c7f:	e8 de fe ff ff       	call   c0102b62 <lgdt>
c0102c84:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102c8a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102c8e:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102c91:	c9                   	leave  
c0102c92:	c3                   	ret    

c0102c93 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102c93:	55                   	push   %ebp
c0102c94:	89 e5                	mov    %esp,%ebp
c0102c96:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0102c99:	c7 05 50 89 11 c0 a0 	movl   $0xc01072a0,0xc0118950
c0102ca0:	72 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102ca3:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102ca8:	8b 00                	mov    (%eax),%eax
c0102caa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102cae:	c7 04 24 30 69 10 c0 	movl   $0xc0106930,(%esp)
c0102cb5:	e8 d7 d5 ff ff       	call   c0100291 <cprintf>
    pmm_manager->init();
c0102cba:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102cbf:	8b 40 04             	mov    0x4(%eax),%eax
c0102cc2:	ff d0                	call   *%eax
}
c0102cc4:	c9                   	leave  
c0102cc5:	c3                   	ret    

c0102cc6 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102cc6:	55                   	push   %ebp
c0102cc7:	89 e5                	mov    %esp,%ebp
c0102cc9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102ccc:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102cd1:	8b 40 08             	mov    0x8(%eax),%eax
c0102cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cd7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102cdb:	8b 55 08             	mov    0x8(%ebp),%edx
c0102cde:	89 14 24             	mov    %edx,(%esp)
c0102ce1:	ff d0                	call   *%eax
}
c0102ce3:	c9                   	leave  
c0102ce4:	c3                   	ret    

c0102ce5 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102ce5:	55                   	push   %ebp
c0102ce6:	89 e5                	mov    %esp,%ebp
c0102ce8:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102ceb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102cf2:	e8 2e fe ff ff       	call   c0102b25 <__intr_save>
c0102cf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102cfa:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102cff:	8b 40 0c             	mov    0xc(%eax),%eax
c0102d02:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d05:	89 14 24             	mov    %edx,(%esp)
c0102d08:	ff d0                	call   *%eax
c0102d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d10:	89 04 24             	mov    %eax,(%esp)
c0102d13:	e8 37 fe ff ff       	call   c0102b4f <__intr_restore>
    return page;
c0102d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102d1b:	c9                   	leave  
c0102d1c:	c3                   	ret    

c0102d1d <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102d1d:	55                   	push   %ebp
c0102d1e:	89 e5                	mov    %esp,%ebp
c0102d20:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d23:	e8 fd fd ff ff       	call   c0102b25 <__intr_save>
c0102d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102d2b:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102d30:	8b 40 10             	mov    0x10(%eax),%eax
c0102d33:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d36:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102d3a:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d3d:	89 14 24             	mov    %edx,(%esp)
c0102d40:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d45:	89 04 24             	mov    %eax,(%esp)
c0102d48:	e8 02 fe ff ff       	call   c0102b4f <__intr_restore>
}
c0102d4d:	c9                   	leave  
c0102d4e:	c3                   	ret    

c0102d4f <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102d4f:	55                   	push   %ebp
c0102d50:	89 e5                	mov    %esp,%ebp
c0102d52:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d55:	e8 cb fd ff ff       	call   c0102b25 <__intr_save>
c0102d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102d5d:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102d62:	8b 40 14             	mov    0x14(%eax),%eax
c0102d65:	ff d0                	call   *%eax
c0102d67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d6d:	89 04 24             	mov    %eax,(%esp)
c0102d70:	e8 da fd ff ff       	call   c0102b4f <__intr_restore>
    return ret;
c0102d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102d78:	c9                   	leave  
c0102d79:	c3                   	ret    

c0102d7a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102d7a:	55                   	push   %ebp
c0102d7b:	89 e5                	mov    %esp,%ebp
c0102d7d:	57                   	push   %edi
c0102d7e:	56                   	push   %esi
c0102d7f:	53                   	push   %ebx
c0102d80:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102d86:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102d8d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102d94:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102d9b:	c7 04 24 47 69 10 c0 	movl   $0xc0106947,(%esp)
c0102da2:	e8 ea d4 ff ff       	call   c0100291 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102da7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102dae:	e9 15 01 00 00       	jmp    c0102ec8 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102db3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102db6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102db9:	89 d0                	mov    %edx,%eax
c0102dbb:	c1 e0 02             	shl    $0x2,%eax
c0102dbe:	01 d0                	add    %edx,%eax
c0102dc0:	c1 e0 02             	shl    $0x2,%eax
c0102dc3:	01 c8                	add    %ecx,%eax
c0102dc5:	8b 50 08             	mov    0x8(%eax),%edx
c0102dc8:	8b 40 04             	mov    0x4(%eax),%eax
c0102dcb:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102dce:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102dd1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102dd4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dd7:	89 d0                	mov    %edx,%eax
c0102dd9:	c1 e0 02             	shl    $0x2,%eax
c0102ddc:	01 d0                	add    %edx,%eax
c0102dde:	c1 e0 02             	shl    $0x2,%eax
c0102de1:	01 c8                	add    %ecx,%eax
c0102de3:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102de6:	8b 58 10             	mov    0x10(%eax),%ebx
c0102de9:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102dec:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102def:	01 c8                	add    %ecx,%eax
c0102df1:	11 da                	adc    %ebx,%edx
c0102df3:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102df6:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102df9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102dfc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dff:	89 d0                	mov    %edx,%eax
c0102e01:	c1 e0 02             	shl    $0x2,%eax
c0102e04:	01 d0                	add    %edx,%eax
c0102e06:	c1 e0 02             	shl    $0x2,%eax
c0102e09:	01 c8                	add    %ecx,%eax
c0102e0b:	83 c0 14             	add    $0x14,%eax
c0102e0e:	8b 00                	mov    (%eax),%eax
c0102e10:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0102e16:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e19:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102e1c:	83 c0 ff             	add    $0xffffffff,%eax
c0102e1f:	83 d2 ff             	adc    $0xffffffff,%edx
c0102e22:	89 c6                	mov    %eax,%esi
c0102e24:	89 d7                	mov    %edx,%edi
c0102e26:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e29:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e2c:	89 d0                	mov    %edx,%eax
c0102e2e:	c1 e0 02             	shl    $0x2,%eax
c0102e31:	01 d0                	add    %edx,%eax
c0102e33:	c1 e0 02             	shl    $0x2,%eax
c0102e36:	01 c8                	add    %ecx,%eax
c0102e38:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e3b:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e3e:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0102e44:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0102e48:	89 74 24 14          	mov    %esi,0x14(%esp)
c0102e4c:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0102e50:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102e53:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102e56:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102e5a:	89 54 24 10          	mov    %edx,0x10(%esp)
c0102e5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0102e62:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102e66:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0102e6d:	e8 1f d4 ff ff       	call   c0100291 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102e72:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e75:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e78:	89 d0                	mov    %edx,%eax
c0102e7a:	c1 e0 02             	shl    $0x2,%eax
c0102e7d:	01 d0                	add    %edx,%eax
c0102e7f:	c1 e0 02             	shl    $0x2,%eax
c0102e82:	01 c8                	add    %ecx,%eax
c0102e84:	83 c0 14             	add    $0x14,%eax
c0102e87:	8b 00                	mov    (%eax),%eax
c0102e89:	83 f8 01             	cmp    $0x1,%eax
c0102e8c:	75 36                	jne    c0102ec4 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0102e8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102e94:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102e97:	77 2b                	ja     c0102ec4 <page_init+0x14a>
c0102e99:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102e9c:	72 05                	jb     c0102ea3 <page_init+0x129>
c0102e9e:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102ea1:	73 21                	jae    c0102ec4 <page_init+0x14a>
c0102ea3:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102ea7:	77 1b                	ja     c0102ec4 <page_init+0x14a>
c0102ea9:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102ead:	72 09                	jb     c0102eb8 <page_init+0x13e>
c0102eaf:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102eb6:	77 0c                	ja     c0102ec4 <page_init+0x14a>
                maxpa = end;
c0102eb8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102ebb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102ebe:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102ec1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102ec4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102ec8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102ecb:	8b 00                	mov    (%eax),%eax
c0102ecd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102ed0:	0f 8f dd fe ff ff    	jg     c0102db3 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102ed6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102eda:	72 1d                	jb     c0102ef9 <page_init+0x17f>
c0102edc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102ee0:	77 09                	ja     c0102eeb <page_init+0x171>
c0102ee2:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102ee9:	76 0e                	jbe    c0102ef9 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0102eeb:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102ef2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102ef9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102efc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102eff:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102f03:	c1 ea 0c             	shr    $0xc,%edx
c0102f06:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102f0b:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102f12:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0102f17:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102f1a:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102f1d:	01 d0                	add    %edx,%eax
c0102f1f:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102f22:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102f25:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f2a:	f7 75 ac             	divl   -0x54(%ebp)
c0102f2d:	89 d0                	mov    %edx,%eax
c0102f2f:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102f32:	29 c2                	sub    %eax,%edx
c0102f34:	89 d0                	mov    %edx,%eax
c0102f36:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    for (i = 0; i < npage; i ++) {
c0102f3b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f42:	eb 2f                	jmp    c0102f73 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0102f44:	8b 0d 58 89 11 c0    	mov    0xc0118958,%ecx
c0102f4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f4d:	89 d0                	mov    %edx,%eax
c0102f4f:	c1 e0 02             	shl    $0x2,%eax
c0102f52:	01 d0                	add    %edx,%eax
c0102f54:	c1 e0 02             	shl    $0x2,%eax
c0102f57:	01 c8                	add    %ecx,%eax
c0102f59:	83 c0 04             	add    $0x4,%eax
c0102f5c:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102f63:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f66:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102f69:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102f6c:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0102f6f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102f73:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f76:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102f7b:	39 c2                	cmp    %eax,%edx
c0102f7d:	72 c5                	jb     c0102f44 <page_init+0x1ca>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102f7f:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f85:	89 d0                	mov    %edx,%eax
c0102f87:	c1 e0 02             	shl    $0x2,%eax
c0102f8a:	01 d0                	add    %edx,%eax
c0102f8c:	c1 e0 02             	shl    $0x2,%eax
c0102f8f:	89 c2                	mov    %eax,%edx
c0102f91:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102f96:	01 d0                	add    %edx,%eax
c0102f98:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102f9b:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0102fa2:	77 23                	ja     c0102fc7 <page_init+0x24d>
c0102fa4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102fa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102fab:	c7 44 24 08 84 69 10 	movl   $0xc0106984,0x8(%esp)
c0102fb2:	c0 
c0102fb3:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0102fba:	00 
c0102fbb:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0102fc2:	e8 21 d4 ff ff       	call   c01003e8 <__panic>
c0102fc7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102fca:	05 00 00 00 40       	add    $0x40000000,%eax
c0102fcf:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102fd2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102fd9:	e9 74 01 00 00       	jmp    c0103152 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102fde:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fe1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fe4:	89 d0                	mov    %edx,%eax
c0102fe6:	c1 e0 02             	shl    $0x2,%eax
c0102fe9:	01 d0                	add    %edx,%eax
c0102feb:	c1 e0 02             	shl    $0x2,%eax
c0102fee:	01 c8                	add    %ecx,%eax
c0102ff0:	8b 50 08             	mov    0x8(%eax),%edx
c0102ff3:	8b 40 04             	mov    0x4(%eax),%eax
c0102ff6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102ff9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102ffc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fff:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103002:	89 d0                	mov    %edx,%eax
c0103004:	c1 e0 02             	shl    $0x2,%eax
c0103007:	01 d0                	add    %edx,%eax
c0103009:	c1 e0 02             	shl    $0x2,%eax
c010300c:	01 c8                	add    %ecx,%eax
c010300e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103011:	8b 58 10             	mov    0x10(%eax),%ebx
c0103014:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103017:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010301a:	01 c8                	add    %ecx,%eax
c010301c:	11 da                	adc    %ebx,%edx
c010301e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103021:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103024:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103027:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010302a:	89 d0                	mov    %edx,%eax
c010302c:	c1 e0 02             	shl    $0x2,%eax
c010302f:	01 d0                	add    %edx,%eax
c0103031:	c1 e0 02             	shl    $0x2,%eax
c0103034:	01 c8                	add    %ecx,%eax
c0103036:	83 c0 14             	add    $0x14,%eax
c0103039:	8b 00                	mov    (%eax),%eax
c010303b:	83 f8 01             	cmp    $0x1,%eax
c010303e:	0f 85 0a 01 00 00    	jne    c010314e <page_init+0x3d4>
            if (begin < freemem) {
c0103044:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103047:	ba 00 00 00 00       	mov    $0x0,%edx
c010304c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010304f:	72 17                	jb     c0103068 <page_init+0x2ee>
c0103051:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103054:	77 05                	ja     c010305b <page_init+0x2e1>
c0103056:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0103059:	76 0d                	jbe    c0103068 <page_init+0x2ee>
                begin = freemem;
c010305b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010305e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103061:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103068:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010306c:	72 1d                	jb     c010308b <page_init+0x311>
c010306e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103072:	77 09                	ja     c010307d <page_init+0x303>
c0103074:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010307b:	76 0e                	jbe    c010308b <page_init+0x311>
                end = KMEMSIZE;
c010307d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103084:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010308b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010308e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103091:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103094:	0f 87 b4 00 00 00    	ja     c010314e <page_init+0x3d4>
c010309a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010309d:	72 09                	jb     c01030a8 <page_init+0x32e>
c010309f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01030a2:	0f 83 a6 00 00 00    	jae    c010314e <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c01030a8:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01030af:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01030b2:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01030b5:	01 d0                	add    %edx,%eax
c01030b7:	83 e8 01             	sub    $0x1,%eax
c01030ba:	89 45 98             	mov    %eax,-0x68(%ebp)
c01030bd:	8b 45 98             	mov    -0x68(%ebp),%eax
c01030c0:	ba 00 00 00 00       	mov    $0x0,%edx
c01030c5:	f7 75 9c             	divl   -0x64(%ebp)
c01030c8:	89 d0                	mov    %edx,%eax
c01030ca:	8b 55 98             	mov    -0x68(%ebp),%edx
c01030cd:	29 c2                	sub    %eax,%edx
c01030cf:	89 d0                	mov    %edx,%eax
c01030d1:	ba 00 00 00 00       	mov    $0x0,%edx
c01030d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01030d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01030dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01030df:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01030e2:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01030e5:	ba 00 00 00 00       	mov    $0x0,%edx
c01030ea:	89 c7                	mov    %eax,%edi
c01030ec:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01030f2:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01030f5:	89 d0                	mov    %edx,%eax
c01030f7:	83 e0 00             	and    $0x0,%eax
c01030fa:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01030fd:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103100:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103103:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103106:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0103109:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010310c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010310f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103112:	77 3a                	ja     c010314e <page_init+0x3d4>
c0103114:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103117:	72 05                	jb     c010311e <page_init+0x3a4>
c0103119:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010311c:	73 30                	jae    c010314e <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010311e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0103121:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0103124:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103127:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010312a:	29 c8                	sub    %ecx,%eax
c010312c:	19 da                	sbb    %ebx,%edx
c010312e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103132:	c1 ea 0c             	shr    $0xc,%edx
c0103135:	89 c3                	mov    %eax,%ebx
c0103137:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010313a:	89 04 24             	mov    %eax,(%esp)
c010313d:	e8 bd f8 ff ff       	call   c01029ff <pa2page>
c0103142:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0103146:	89 04 24             	mov    %eax,(%esp)
c0103149:	e8 78 fb ff ff       	call   c0102cc6 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c010314e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103152:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103155:	8b 00                	mov    (%eax),%eax
c0103157:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010315a:	0f 8f 7e fe ff ff    	jg     c0102fde <page_init+0x264>
                }
            }
        }
    }
}
c0103160:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0103166:	5b                   	pop    %ebx
c0103167:	5e                   	pop    %esi
c0103168:	5f                   	pop    %edi
c0103169:	5d                   	pop    %ebp
c010316a:	c3                   	ret    

c010316b <enable_paging>:

static void
enable_paging(void) {
c010316b:	55                   	push   %ebp
c010316c:	89 e5                	mov    %esp,%ebp
c010316e:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0103171:	a1 54 89 11 c0       	mov    0xc0118954,%eax
c0103176:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0103179:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010317c:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010317f:	0f 20 c0             	mov    %cr0,%eax
c0103182:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0103185:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0103188:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010318b:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0103192:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0103196:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103199:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010319c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010319f:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01031a2:	c9                   	leave  
c01031a3:	c3                   	ret    

c01031a4 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01031a4:	55                   	push   %ebp
c01031a5:	89 e5                	mov    %esp,%ebp
c01031a7:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01031aa:	8b 45 14             	mov    0x14(%ebp),%eax
c01031ad:	8b 55 0c             	mov    0xc(%ebp),%edx
c01031b0:	31 d0                	xor    %edx,%eax
c01031b2:	25 ff 0f 00 00       	and    $0xfff,%eax
c01031b7:	85 c0                	test   %eax,%eax
c01031b9:	74 24                	je     c01031df <boot_map_segment+0x3b>
c01031bb:	c7 44 24 0c b6 69 10 	movl   $0xc01069b6,0xc(%esp)
c01031c2:	c0 
c01031c3:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c01031ca:	c0 
c01031cb:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01031d2:	00 
c01031d3:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c01031da:	e8 09 d2 ff ff       	call   c01003e8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01031df:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01031e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031e9:	25 ff 0f 00 00       	and    $0xfff,%eax
c01031ee:	89 c2                	mov    %eax,%edx
c01031f0:	8b 45 10             	mov    0x10(%ebp),%eax
c01031f3:	01 c2                	add    %eax,%edx
c01031f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031f8:	01 d0                	add    %edx,%eax
c01031fa:	83 e8 01             	sub    $0x1,%eax
c01031fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103200:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103203:	ba 00 00 00 00       	mov    $0x0,%edx
c0103208:	f7 75 f0             	divl   -0x10(%ebp)
c010320b:	89 d0                	mov    %edx,%eax
c010320d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103210:	29 c2                	sub    %eax,%edx
c0103212:	89 d0                	mov    %edx,%eax
c0103214:	c1 e8 0c             	shr    $0xc,%eax
c0103217:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010321a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010321d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103220:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103223:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103228:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010322b:	8b 45 14             	mov    0x14(%ebp),%eax
c010322e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103231:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103234:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103239:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010323c:	eb 6b                	jmp    c01032a9 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010323e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103245:	00 
c0103246:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103249:	89 44 24 04          	mov    %eax,0x4(%esp)
c010324d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103250:	89 04 24             	mov    %eax,(%esp)
c0103253:	e8 cc 01 00 00       	call   c0103424 <get_pte>
c0103258:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010325b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010325f:	75 24                	jne    c0103285 <boot_map_segment+0xe1>
c0103261:	c7 44 24 0c e2 69 10 	movl   $0xc01069e2,0xc(%esp)
c0103268:	c0 
c0103269:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103270:	c0 
c0103271:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0103278:	00 
c0103279:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103280:	e8 63 d1 ff ff       	call   c01003e8 <__panic>
        *ptep = pa | PTE_P | perm;
c0103285:	8b 45 18             	mov    0x18(%ebp),%eax
c0103288:	8b 55 14             	mov    0x14(%ebp),%edx
c010328b:	09 d0                	or     %edx,%eax
c010328d:	83 c8 01             	or     $0x1,%eax
c0103290:	89 c2                	mov    %eax,%edx
c0103292:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103295:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103297:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010329b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01032a2:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01032a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01032ad:	75 8f                	jne    c010323e <boot_map_segment+0x9a>
    }
}
c01032af:	c9                   	leave  
c01032b0:	c3                   	ret    

c01032b1 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01032b1:	55                   	push   %ebp
c01032b2:	89 e5                	mov    %esp,%ebp
c01032b4:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01032b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032be:	e8 22 fa ff ff       	call   c0102ce5 <alloc_pages>
c01032c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01032c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01032ca:	75 1c                	jne    c01032e8 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01032cc:	c7 44 24 08 ef 69 10 	movl   $0xc01069ef,0x8(%esp)
c01032d3:	c0 
c01032d4:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01032db:	00 
c01032dc:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c01032e3:	e8 00 d1 ff ff       	call   c01003e8 <__panic>
    }
    return page2kva(p);
c01032e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032eb:	89 04 24             	mov    %eax,(%esp)
c01032ee:	e8 5b f7 ff ff       	call   c0102a4e <page2kva>
}
c01032f3:	c9                   	leave  
c01032f4:	c3                   	ret    

c01032f5 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01032f5:	55                   	push   %ebp
c01032f6:	89 e5                	mov    %esp,%ebp
c01032f8:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01032fb:	e8 93 f9 ff ff       	call   c0102c93 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103300:	e8 75 fa ff ff       	call   c0102d7a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103305:	e8 66 04 00 00       	call   c0103770 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c010330a:	e8 a2 ff ff ff       	call   c01032b1 <boot_alloc_page>
c010330f:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c0103314:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103319:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103320:	00 
c0103321:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103328:	00 
c0103329:	89 04 24             	mov    %eax,(%esp)
c010332c:	e8 38 26 00 00       	call   c0105969 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0103331:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103336:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103339:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103340:	77 23                	ja     c0103365 <pmm_init+0x70>
c0103342:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103345:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103349:	c7 44 24 08 84 69 10 	movl   $0xc0106984,0x8(%esp)
c0103350:	c0 
c0103351:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0103358:	00 
c0103359:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103360:	e8 83 d0 ff ff       	call   c01003e8 <__panic>
c0103365:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103368:	05 00 00 00 40       	add    $0x40000000,%eax
c010336d:	a3 54 89 11 c0       	mov    %eax,0xc0118954

    check_pgdir();
c0103372:	e8 17 04 00 00       	call   c010378e <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103377:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010337c:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0103382:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103387:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010338a:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103391:	77 23                	ja     c01033b6 <pmm_init+0xc1>
c0103393:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103396:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010339a:	c7 44 24 08 84 69 10 	movl   $0xc0106984,0x8(%esp)
c01033a1:	c0 
c01033a2:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01033a9:	00 
c01033aa:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c01033b1:	e8 32 d0 ff ff       	call   c01003e8 <__panic>
c01033b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033b9:	05 00 00 00 40       	add    $0x40000000,%eax
c01033be:	83 c8 03             	or     $0x3,%eax
c01033c1:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01033c3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01033c8:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01033cf:	00 
c01033d0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01033d7:	00 
c01033d8:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01033df:	38 
c01033e0:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01033e7:	c0 
c01033e8:	89 04 24             	mov    %eax,(%esp)
c01033eb:	e8 b4 fd ff ff       	call   c01031a4 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01033f0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01033f5:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c01033fb:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0103401:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0103403:	e8 63 fd ff ff       	call   c010316b <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0103408:	e8 97 f7 ff ff       	call   c0102ba4 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c010340d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0103418:	e8 0c 0a 00 00       	call   c0103e29 <check_boot_pgdir>

    print_pgdir();
c010341d:	e8 99 0e 00 00       	call   c01042bb <print_pgdir>

}
c0103422:	c9                   	leave  
c0103423:	c3                   	ret    

c0103424 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0103424:	55                   	push   %ebp
c0103425:	89 e5                	mov    %esp,%ebp
c0103427:	83 ec 38             	sub    $0x38,%esp
     * typedef uintptr_t pte_t;
     * typedef uintptr_t pde_t;
     */
    //pgdir是一级页表本身,pde_t是一级页表的表项, pte_t表示二级页表的表项
    //pgdir给出页表起始地址。通过查找这个页表，我们可以得到一级页表项(二级页表的入口地址)。
    pde_t *pdep = &pgdir[PDX(la)];//根据虚地址的高十位查询页目录，找到页表项的pdep
c010342a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010342d:	c1 e8 16             	shr    $0x16,%eax
c0103430:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103437:	8b 45 08             	mov    0x8(%ebp),%eax
c010343a:	01 d0                	add    %edx,%eax
c010343c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c010343f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103442:	8b 00                	mov    (%eax),%eax
c0103444:	83 e0 01             	and    $0x1,%eax
c0103447:	85 c0                	test   %eax,%eax
c0103449:	0f 85 af 00 00 00    	jne    c01034fe <get_pte+0xda>
        //如果在查找二级页表项时，发现对应的二级页表不存在，则需要根据create参数的值来处理是否创建新的二级页表。
        struct  Page* page = alloc_page();
c010344f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103456:	e8 8a f8 ff ff       	call   c0102ce5 <alloc_pages>
c010345b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(!create||page==NULL){
c010345e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103462:	74 06                	je     c010346a <get_pte+0x46>
c0103464:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103468:	75 0a                	jne    c0103474 <get_pte+0x50>
            return NULL;
c010346a:	b8 00 00 00 00       	mov    $0x0,%eax
c010346f:	e9 e6 00 00 00       	jmp    c010355a <get_pte+0x136>
        }                  
        set_page_ref(page,1);//引用次数加一
c0103474:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010347b:	00 
c010347c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010347f:	89 04 24             	mov    %eax,(%esp)
c0103482:	e8 63 f6 ff ff       	call   c0102aea <set_page_ref>
        uintptr_t pa = page2pa(page); //获取页的线性地址
c0103487:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010348a:	89 04 24             	mov    %eax,(%esp)
c010348d:	e8 57 f5 ff ff       	call   c01029e9 <page2pa>
c0103492:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa),0,PGSIZE);//初始化,新申请的页全设为零，因为这个页所代表的虚拟地址都没有被映射。
c0103495:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103498:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010349b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010349e:	c1 e8 0c             	shr    $0xc,%eax
c01034a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01034a4:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01034a9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01034ac:	72 23                	jb     c01034d1 <get_pte+0xad>
c01034ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01034b5:	c7 44 24 08 e0 68 10 	movl   $0xc01068e0,0x8(%esp)
c01034bc:	c0 
c01034bd:	c7 44 24 04 7a 01 00 	movl   $0x17a,0x4(%esp)
c01034c4:	00 
c01034c5:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c01034cc:	e8 17 cf ff ff       	call   c01003e8 <__panic>
c01034d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034d4:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01034d9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01034e0:	00 
c01034e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01034e8:	00 
c01034e9:	89 04 24             	mov    %eax,(%esp)
c01034ec:	e8 78 24 00 00       	call   c0105969 <memset>
        *pdep=pa|PTE_U|PTE_W|PTE_P;//设置控制位
c01034f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034f4:	83 c8 07             	or     $0x7,%eax
c01034f7:	89 c2                	mov    %eax,%edx
c01034f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034fc:	89 10                	mov    %edx,(%eax)
    }
    //KADDR(PDE_ADDR(*pdep)):这部分是由页目录项地址得到关联的页表物理地址， 再转成虚拟地址。
    //PTX(la)：返回虚拟地址la的页表项索引
    //最后返回的是虚拟地址la对应的页表项入口地址  
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; 
c01034fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103501:	8b 00                	mov    (%eax),%eax
c0103503:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103508:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010350b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010350e:	c1 e8 0c             	shr    $0xc,%eax
c0103511:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103514:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103519:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010351c:	72 23                	jb     c0103541 <get_pte+0x11d>
c010351e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103521:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103525:	c7 44 24 08 e0 68 10 	movl   $0xc01068e0,0x8(%esp)
c010352c:	c0 
c010352d:	c7 44 24 04 80 01 00 	movl   $0x180,0x4(%esp)
c0103534:	00 
c0103535:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c010353c:	e8 a7 ce ff ff       	call   c01003e8 <__panic>
c0103541:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103544:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103549:	8b 55 0c             	mov    0xc(%ebp),%edx
c010354c:	c1 ea 0c             	shr    $0xc,%edx
c010354f:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0103555:	c1 e2 02             	shl    $0x2,%edx
c0103558:	01 d0                	add    %edx,%eax
}
c010355a:	c9                   	leave  
c010355b:	c3                   	ret    

c010355c <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010355c:	55                   	push   %ebp
c010355d:	89 e5                	mov    %esp,%ebp
c010355f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103562:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103569:	00 
c010356a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010356d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103571:	8b 45 08             	mov    0x8(%ebp),%eax
c0103574:	89 04 24             	mov    %eax,(%esp)
c0103577:	e8 a8 fe ff ff       	call   c0103424 <get_pte>
c010357c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010357f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103583:	74 08                	je     c010358d <get_page+0x31>
        *ptep_store = ptep;
c0103585:	8b 45 10             	mov    0x10(%ebp),%eax
c0103588:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010358b:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010358d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103591:	74 1b                	je     c01035ae <get_page+0x52>
c0103593:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103596:	8b 00                	mov    (%eax),%eax
c0103598:	83 e0 01             	and    $0x1,%eax
c010359b:	85 c0                	test   %eax,%eax
c010359d:	74 0f                	je     c01035ae <get_page+0x52>
        return pa2page(*ptep);
c010359f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035a2:	8b 00                	mov    (%eax),%eax
c01035a4:	89 04 24             	mov    %eax,(%esp)
c01035a7:	e8 53 f4 ff ff       	call   c01029ff <pa2page>
c01035ac:	eb 05                	jmp    c01035b3 <get_page+0x57>
    }
    return NULL;
c01035ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01035b3:	c9                   	leave  
c01035b4:	c3                   	ret    

c01035b5 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01035b5:	55                   	push   %ebp
c01035b6:	89 e5                	mov    %esp,%ebp
c01035b8:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     *                        当修改的页表是进程正在使用的那些页表，使之无效。
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
    if (*ptep & PTE_P) {// 页表项存在
c01035bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01035be:	8b 00                	mov    (%eax),%eax
c01035c0:	83 e0 01             	and    $0x1,%eax
c01035c3:	85 c0                	test   %eax,%eax
c01035c5:	74 4d                	je     c0103614 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep); //找到页表项
c01035c7:	8b 45 10             	mov    0x10(%ebp),%eax
c01035ca:	8b 00                	mov    (%eax),%eax
c01035cc:	89 04 24             	mov    %eax,(%esp)
c01035cf:	e8 ce f4 ff ff       	call   c0102aa2 <pte2page>
c01035d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(page_ref_dec(page)==0)
c01035d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035da:	89 04 24             	mov    %eax,(%esp)
c01035dd:	e8 2c f5 ff ff       	call   c0102b0e <page_ref_dec>
c01035e2:	85 c0                	test   %eax,%eax
c01035e4:	75 13                	jne    c01035f9 <page_remove_pte+0x44>
        {//判断此页被引用的次数，如果仅仅被引用一次，则这个页也可以被释放。否则，只能释放页表入口
            free_page(page);//释放页
c01035e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035ed:	00 
c01035ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035f1:	89 04 24             	mov    %eax,(%esp)
c01035f4:	e8 24 f7 ff ff       	call   c0102d1d <free_pages>
        }                         
        *ptep=0;//该页目录项清零
c01035f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01035fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir,la);//flush tlb
c0103602:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103605:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103609:	8b 45 08             	mov    0x8(%ebp),%eax
c010360c:	89 04 24             	mov    %eax,(%esp)
c010360f:	e8 ff 00 00 00       	call   c0103713 <tlb_invalidate>
    }
}
c0103614:	c9                   	leave  
c0103615:	c3                   	ret    

c0103616 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103616:	55                   	push   %ebp
c0103617:	89 e5                	mov    %esp,%ebp
c0103619:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010361c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103623:	00 
c0103624:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103627:	89 44 24 04          	mov    %eax,0x4(%esp)
c010362b:	8b 45 08             	mov    0x8(%ebp),%eax
c010362e:	89 04 24             	mov    %eax,(%esp)
c0103631:	e8 ee fd ff ff       	call   c0103424 <get_pte>
c0103636:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010363d:	74 19                	je     c0103658 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010363f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103642:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103646:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103649:	89 44 24 04          	mov    %eax,0x4(%esp)
c010364d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103650:	89 04 24             	mov    %eax,(%esp)
c0103653:	e8 5d ff ff ff       	call   c01035b5 <page_remove_pte>
    }
}
c0103658:	c9                   	leave  
c0103659:	c3                   	ret    

c010365a <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010365a:	55                   	push   %ebp
c010365b:	89 e5                	mov    %esp,%ebp
c010365d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103660:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103667:	00 
c0103668:	8b 45 10             	mov    0x10(%ebp),%eax
c010366b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010366f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103672:	89 04 24             	mov    %eax,(%esp)
c0103675:	e8 aa fd ff ff       	call   c0103424 <get_pte>
c010367a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010367d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103681:	75 0a                	jne    c010368d <page_insert+0x33>
        return -E_NO_MEM;
c0103683:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103688:	e9 84 00 00 00       	jmp    c0103711 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010368d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103690:	89 04 24             	mov    %eax,(%esp)
c0103693:	e8 5f f4 ff ff       	call   c0102af7 <page_ref_inc>
    if (*ptep & PTE_P) {
c0103698:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010369b:	8b 00                	mov    (%eax),%eax
c010369d:	83 e0 01             	and    $0x1,%eax
c01036a0:	85 c0                	test   %eax,%eax
c01036a2:	74 3e                	je     c01036e2 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01036a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036a7:	8b 00                	mov    (%eax),%eax
c01036a9:	89 04 24             	mov    %eax,(%esp)
c01036ac:	e8 f1 f3 ff ff       	call   c0102aa2 <pte2page>
c01036b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01036b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01036ba:	75 0d                	jne    c01036c9 <page_insert+0x6f>
            page_ref_dec(page);
c01036bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036bf:	89 04 24             	mov    %eax,(%esp)
c01036c2:	e8 47 f4 ff ff       	call   c0102b0e <page_ref_dec>
c01036c7:	eb 19                	jmp    c01036e2 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01036c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036cc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01036d0:	8b 45 10             	mov    0x10(%ebp),%eax
c01036d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01036d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01036da:	89 04 24             	mov    %eax,(%esp)
c01036dd:	e8 d3 fe ff ff       	call   c01035b5 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01036e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036e5:	89 04 24             	mov    %eax,(%esp)
c01036e8:	e8 fc f2 ff ff       	call   c01029e9 <page2pa>
c01036ed:	0b 45 14             	or     0x14(%ebp),%eax
c01036f0:	83 c8 01             	or     $0x1,%eax
c01036f3:	89 c2                	mov    %eax,%edx
c01036f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036f8:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01036fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01036fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103701:	8b 45 08             	mov    0x8(%ebp),%eax
c0103704:	89 04 24             	mov    %eax,(%esp)
c0103707:	e8 07 00 00 00       	call   c0103713 <tlb_invalidate>
    return 0;
c010370c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103711:	c9                   	leave  
c0103712:	c3                   	ret    

c0103713 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103713:	55                   	push   %ebp
c0103714:	89 e5                	mov    %esp,%ebp
c0103716:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103719:	0f 20 d8             	mov    %cr3,%eax
c010371c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010371f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0103722:	89 c2                	mov    %eax,%edx
c0103724:	8b 45 08             	mov    0x8(%ebp),%eax
c0103727:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010372a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103731:	77 23                	ja     c0103756 <tlb_invalidate+0x43>
c0103733:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103736:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010373a:	c7 44 24 08 84 69 10 	movl   $0xc0106984,0x8(%esp)
c0103741:	c0 
c0103742:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c0103749:	00 
c010374a:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103751:	e8 92 cc ff ff       	call   c01003e8 <__panic>
c0103756:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103759:	05 00 00 00 40       	add    $0x40000000,%eax
c010375e:	39 c2                	cmp    %eax,%edx
c0103760:	75 0c                	jne    c010376e <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0103762:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103765:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103768:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010376b:	0f 01 38             	invlpg (%eax)
    }
}
c010376e:	c9                   	leave  
c010376f:	c3                   	ret    

c0103770 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103770:	55                   	push   %ebp
c0103771:	89 e5                	mov    %esp,%ebp
c0103773:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0103776:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c010377b:	8b 40 18             	mov    0x18(%eax),%eax
c010377e:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0103780:	c7 04 24 08 6a 10 c0 	movl   $0xc0106a08,(%esp)
c0103787:	e8 05 cb ff ff       	call   c0100291 <cprintf>
}
c010378c:	c9                   	leave  
c010378d:	c3                   	ret    

c010378e <check_pgdir>:

static void
check_pgdir(void) {
c010378e:	55                   	push   %ebp
c010378f:	89 e5                	mov    %esp,%ebp
c0103791:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0103794:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103799:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010379e:	76 24                	jbe    c01037c4 <check_pgdir+0x36>
c01037a0:	c7 44 24 0c 27 6a 10 	movl   $0xc0106a27,0xc(%esp)
c01037a7:	c0 
c01037a8:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c01037af:	c0 
c01037b0:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c01037b7:	00 
c01037b8:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c01037bf:	e8 24 cc ff ff       	call   c01003e8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01037c4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01037c9:	85 c0                	test   %eax,%eax
c01037cb:	74 0e                	je     c01037db <check_pgdir+0x4d>
c01037cd:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01037d2:	25 ff 0f 00 00       	and    $0xfff,%eax
c01037d7:	85 c0                	test   %eax,%eax
c01037d9:	74 24                	je     c01037ff <check_pgdir+0x71>
c01037db:	c7 44 24 0c 44 6a 10 	movl   $0xc0106a44,0xc(%esp)
c01037e2:	c0 
c01037e3:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c01037ea:	c0 
c01037eb:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c01037f2:	00 
c01037f3:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c01037fa:	e8 e9 cb ff ff       	call   c01003e8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01037ff:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103804:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010380b:	00 
c010380c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103813:	00 
c0103814:	89 04 24             	mov    %eax,(%esp)
c0103817:	e8 40 fd ff ff       	call   c010355c <get_page>
c010381c:	85 c0                	test   %eax,%eax
c010381e:	74 24                	je     c0103844 <check_pgdir+0xb6>
c0103820:	c7 44 24 0c 7c 6a 10 	movl   $0xc0106a7c,0xc(%esp)
c0103827:	c0 
c0103828:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c010382f:	c0 
c0103830:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0103837:	00 
c0103838:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c010383f:	e8 a4 cb ff ff       	call   c01003e8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103844:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010384b:	e8 95 f4 ff ff       	call   c0102ce5 <alloc_pages>
c0103850:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103853:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103858:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010385f:	00 
c0103860:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103867:	00 
c0103868:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010386b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010386f:	89 04 24             	mov    %eax,(%esp)
c0103872:	e8 e3 fd ff ff       	call   c010365a <page_insert>
c0103877:	85 c0                	test   %eax,%eax
c0103879:	74 24                	je     c010389f <check_pgdir+0x111>
c010387b:	c7 44 24 0c a4 6a 10 	movl   $0xc0106aa4,0xc(%esp)
c0103882:	c0 
c0103883:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c010388a:	c0 
c010388b:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0103892:	00 
c0103893:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c010389a:	e8 49 cb ff ff       	call   c01003e8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010389f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01038a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01038ab:	00 
c01038ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01038b3:	00 
c01038b4:	89 04 24             	mov    %eax,(%esp)
c01038b7:	e8 68 fb ff ff       	call   c0103424 <get_pte>
c01038bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038c3:	75 24                	jne    c01038e9 <check_pgdir+0x15b>
c01038c5:	c7 44 24 0c d0 6a 10 	movl   $0xc0106ad0,0xc(%esp)
c01038cc:	c0 
c01038cd:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c01038d4:	c0 
c01038d5:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c01038dc:	00 
c01038dd:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c01038e4:	e8 ff ca ff ff       	call   c01003e8 <__panic>
    assert(pa2page(*ptep) == p1);
c01038e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038ec:	8b 00                	mov    (%eax),%eax
c01038ee:	89 04 24             	mov    %eax,(%esp)
c01038f1:	e8 09 f1 ff ff       	call   c01029ff <pa2page>
c01038f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01038f9:	74 24                	je     c010391f <check_pgdir+0x191>
c01038fb:	c7 44 24 0c fd 6a 10 	movl   $0xc0106afd,0xc(%esp)
c0103902:	c0 
c0103903:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c010390a:	c0 
c010390b:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c0103912:	00 
c0103913:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c010391a:	e8 c9 ca ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p1) == 1);
c010391f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103922:	89 04 24             	mov    %eax,(%esp)
c0103925:	e8 b6 f1 ff ff       	call   c0102ae0 <page_ref>
c010392a:	83 f8 01             	cmp    $0x1,%eax
c010392d:	74 24                	je     c0103953 <check_pgdir+0x1c5>
c010392f:	c7 44 24 0c 12 6b 10 	movl   $0xc0106b12,0xc(%esp)
c0103936:	c0 
c0103937:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c010393e:	c0 
c010393f:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c0103946:	00 
c0103947:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c010394e:	e8 95 ca ff ff       	call   c01003e8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103953:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103958:	8b 00                	mov    (%eax),%eax
c010395a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010395f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103962:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103965:	c1 e8 0c             	shr    $0xc,%eax
c0103968:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010396b:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103970:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103973:	72 23                	jb     c0103998 <check_pgdir+0x20a>
c0103975:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103978:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010397c:	c7 44 24 08 e0 68 10 	movl   $0xc01068e0,0x8(%esp)
c0103983:	c0 
c0103984:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c010398b:	00 
c010398c:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103993:	e8 50 ca ff ff       	call   c01003e8 <__panic>
c0103998:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010399b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01039a0:	83 c0 04             	add    $0x4,%eax
c01039a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01039a6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01039ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01039b2:	00 
c01039b3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01039ba:	00 
c01039bb:	89 04 24             	mov    %eax,(%esp)
c01039be:	e8 61 fa ff ff       	call   c0103424 <get_pte>
c01039c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01039c6:	74 24                	je     c01039ec <check_pgdir+0x25e>
c01039c8:	c7 44 24 0c 24 6b 10 	movl   $0xc0106b24,0xc(%esp)
c01039cf:	c0 
c01039d0:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c01039d7:	c0 
c01039d8:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c01039df:	00 
c01039e0:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c01039e7:	e8 fc c9 ff ff       	call   c01003e8 <__panic>

    p2 = alloc_page();
c01039ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039f3:	e8 ed f2 ff ff       	call   c0102ce5 <alloc_pages>
c01039f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01039fb:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a00:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0103a07:	00 
c0103a08:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103a0f:	00 
c0103a10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103a13:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103a17:	89 04 24             	mov    %eax,(%esp)
c0103a1a:	e8 3b fc ff ff       	call   c010365a <page_insert>
c0103a1f:	85 c0                	test   %eax,%eax
c0103a21:	74 24                	je     c0103a47 <check_pgdir+0x2b9>
c0103a23:	c7 44 24 0c 4c 6b 10 	movl   $0xc0106b4c,0xc(%esp)
c0103a2a:	c0 
c0103a2b:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103a32:	c0 
c0103a33:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0103a3a:	00 
c0103a3b:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103a42:	e8 a1 c9 ff ff       	call   c01003e8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103a47:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a4c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103a53:	00 
c0103a54:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103a5b:	00 
c0103a5c:	89 04 24             	mov    %eax,(%esp)
c0103a5f:	e8 c0 f9 ff ff       	call   c0103424 <get_pte>
c0103a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a6b:	75 24                	jne    c0103a91 <check_pgdir+0x303>
c0103a6d:	c7 44 24 0c 84 6b 10 	movl   $0xc0106b84,0xc(%esp)
c0103a74:	c0 
c0103a75:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103a7c:	c0 
c0103a7d:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0103a84:	00 
c0103a85:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103a8c:	e8 57 c9 ff ff       	call   c01003e8 <__panic>
    assert(*ptep & PTE_U);
c0103a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a94:	8b 00                	mov    (%eax),%eax
c0103a96:	83 e0 04             	and    $0x4,%eax
c0103a99:	85 c0                	test   %eax,%eax
c0103a9b:	75 24                	jne    c0103ac1 <check_pgdir+0x333>
c0103a9d:	c7 44 24 0c b4 6b 10 	movl   $0xc0106bb4,0xc(%esp)
c0103aa4:	c0 
c0103aa5:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103aac:	c0 
c0103aad:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0103ab4:	00 
c0103ab5:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103abc:	e8 27 c9 ff ff       	call   c01003e8 <__panic>
    assert(*ptep & PTE_W);
c0103ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ac4:	8b 00                	mov    (%eax),%eax
c0103ac6:	83 e0 02             	and    $0x2,%eax
c0103ac9:	85 c0                	test   %eax,%eax
c0103acb:	75 24                	jne    c0103af1 <check_pgdir+0x363>
c0103acd:	c7 44 24 0c c2 6b 10 	movl   $0xc0106bc2,0xc(%esp)
c0103ad4:	c0 
c0103ad5:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103adc:	c0 
c0103add:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0103ae4:	00 
c0103ae5:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103aec:	e8 f7 c8 ff ff       	call   c01003e8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103af1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103af6:	8b 00                	mov    (%eax),%eax
c0103af8:	83 e0 04             	and    $0x4,%eax
c0103afb:	85 c0                	test   %eax,%eax
c0103afd:	75 24                	jne    c0103b23 <check_pgdir+0x395>
c0103aff:	c7 44 24 0c d0 6b 10 	movl   $0xc0106bd0,0xc(%esp)
c0103b06:	c0 
c0103b07:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103b0e:	c0 
c0103b0f:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0103b16:	00 
c0103b17:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103b1e:	e8 c5 c8 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p2) == 1);
c0103b23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b26:	89 04 24             	mov    %eax,(%esp)
c0103b29:	e8 b2 ef ff ff       	call   c0102ae0 <page_ref>
c0103b2e:	83 f8 01             	cmp    $0x1,%eax
c0103b31:	74 24                	je     c0103b57 <check_pgdir+0x3c9>
c0103b33:	c7 44 24 0c e6 6b 10 	movl   $0xc0106be6,0xc(%esp)
c0103b3a:	c0 
c0103b3b:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103b42:	c0 
c0103b43:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0103b4a:	00 
c0103b4b:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103b52:	e8 91 c8 ff ff       	call   c01003e8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103b57:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b5c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103b63:	00 
c0103b64:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103b6b:	00 
c0103b6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103b6f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103b73:	89 04 24             	mov    %eax,(%esp)
c0103b76:	e8 df fa ff ff       	call   c010365a <page_insert>
c0103b7b:	85 c0                	test   %eax,%eax
c0103b7d:	74 24                	je     c0103ba3 <check_pgdir+0x415>
c0103b7f:	c7 44 24 0c f8 6b 10 	movl   $0xc0106bf8,0xc(%esp)
c0103b86:	c0 
c0103b87:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103b8e:	c0 
c0103b8f:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0103b96:	00 
c0103b97:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103b9e:	e8 45 c8 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p1) == 2);
c0103ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ba6:	89 04 24             	mov    %eax,(%esp)
c0103ba9:	e8 32 ef ff ff       	call   c0102ae0 <page_ref>
c0103bae:	83 f8 02             	cmp    $0x2,%eax
c0103bb1:	74 24                	je     c0103bd7 <check_pgdir+0x449>
c0103bb3:	c7 44 24 0c 24 6c 10 	movl   $0xc0106c24,0xc(%esp)
c0103bba:	c0 
c0103bbb:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103bc2:	c0 
c0103bc3:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0103bca:	00 
c0103bcb:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103bd2:	e8 11 c8 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p2) == 0);
c0103bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bda:	89 04 24             	mov    %eax,(%esp)
c0103bdd:	e8 fe ee ff ff       	call   c0102ae0 <page_ref>
c0103be2:	85 c0                	test   %eax,%eax
c0103be4:	74 24                	je     c0103c0a <check_pgdir+0x47c>
c0103be6:	c7 44 24 0c 36 6c 10 	movl   $0xc0106c36,0xc(%esp)
c0103bed:	c0 
c0103bee:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103bf5:	c0 
c0103bf6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0103bfd:	00 
c0103bfe:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103c05:	e8 de c7 ff ff       	call   c01003e8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103c0a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103c16:	00 
c0103c17:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103c1e:	00 
c0103c1f:	89 04 24             	mov    %eax,(%esp)
c0103c22:	e8 fd f7 ff ff       	call   c0103424 <get_pte>
c0103c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c2e:	75 24                	jne    c0103c54 <check_pgdir+0x4c6>
c0103c30:	c7 44 24 0c 84 6b 10 	movl   $0xc0106b84,0xc(%esp)
c0103c37:	c0 
c0103c38:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103c3f:	c0 
c0103c40:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0103c47:	00 
c0103c48:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103c4f:	e8 94 c7 ff ff       	call   c01003e8 <__panic>
    assert(pa2page(*ptep) == p1);
c0103c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c57:	8b 00                	mov    (%eax),%eax
c0103c59:	89 04 24             	mov    %eax,(%esp)
c0103c5c:	e8 9e ed ff ff       	call   c01029ff <pa2page>
c0103c61:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103c64:	74 24                	je     c0103c8a <check_pgdir+0x4fc>
c0103c66:	c7 44 24 0c fd 6a 10 	movl   $0xc0106afd,0xc(%esp)
c0103c6d:	c0 
c0103c6e:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103c75:	c0 
c0103c76:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0103c7d:	00 
c0103c7e:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103c85:	e8 5e c7 ff ff       	call   c01003e8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c8d:	8b 00                	mov    (%eax),%eax
c0103c8f:	83 e0 04             	and    $0x4,%eax
c0103c92:	85 c0                	test   %eax,%eax
c0103c94:	74 24                	je     c0103cba <check_pgdir+0x52c>
c0103c96:	c7 44 24 0c 48 6c 10 	movl   $0xc0106c48,0xc(%esp)
c0103c9d:	c0 
c0103c9e:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103ca5:	c0 
c0103ca6:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0103cad:	00 
c0103cae:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103cb5:	e8 2e c7 ff ff       	call   c01003e8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103cba:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103cbf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103cc6:	00 
c0103cc7:	89 04 24             	mov    %eax,(%esp)
c0103cca:	e8 47 f9 ff ff       	call   c0103616 <page_remove>
    assert(page_ref(p1) == 1);
c0103ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cd2:	89 04 24             	mov    %eax,(%esp)
c0103cd5:	e8 06 ee ff ff       	call   c0102ae0 <page_ref>
c0103cda:	83 f8 01             	cmp    $0x1,%eax
c0103cdd:	74 24                	je     c0103d03 <check_pgdir+0x575>
c0103cdf:	c7 44 24 0c 12 6b 10 	movl   $0xc0106b12,0xc(%esp)
c0103ce6:	c0 
c0103ce7:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103cee:	c0 
c0103cef:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0103cf6:	00 
c0103cf7:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103cfe:	e8 e5 c6 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p2) == 0);
c0103d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d06:	89 04 24             	mov    %eax,(%esp)
c0103d09:	e8 d2 ed ff ff       	call   c0102ae0 <page_ref>
c0103d0e:	85 c0                	test   %eax,%eax
c0103d10:	74 24                	je     c0103d36 <check_pgdir+0x5a8>
c0103d12:	c7 44 24 0c 36 6c 10 	movl   $0xc0106c36,0xc(%esp)
c0103d19:	c0 
c0103d1a:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103d21:	c0 
c0103d22:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0103d29:	00 
c0103d2a:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103d31:	e8 b2 c6 ff ff       	call   c01003e8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103d36:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103d3b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103d42:	00 
c0103d43:	89 04 24             	mov    %eax,(%esp)
c0103d46:	e8 cb f8 ff ff       	call   c0103616 <page_remove>
    assert(page_ref(p1) == 0);
c0103d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d4e:	89 04 24             	mov    %eax,(%esp)
c0103d51:	e8 8a ed ff ff       	call   c0102ae0 <page_ref>
c0103d56:	85 c0                	test   %eax,%eax
c0103d58:	74 24                	je     c0103d7e <check_pgdir+0x5f0>
c0103d5a:	c7 44 24 0c 5d 6c 10 	movl   $0xc0106c5d,0xc(%esp)
c0103d61:	c0 
c0103d62:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103d69:	c0 
c0103d6a:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0103d71:	00 
c0103d72:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103d79:	e8 6a c6 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p2) == 0);
c0103d7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d81:	89 04 24             	mov    %eax,(%esp)
c0103d84:	e8 57 ed ff ff       	call   c0102ae0 <page_ref>
c0103d89:	85 c0                	test   %eax,%eax
c0103d8b:	74 24                	je     c0103db1 <check_pgdir+0x623>
c0103d8d:	c7 44 24 0c 36 6c 10 	movl   $0xc0106c36,0xc(%esp)
c0103d94:	c0 
c0103d95:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103d9c:	c0 
c0103d9d:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0103da4:	00 
c0103da5:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103dac:	e8 37 c6 ff ff       	call   c01003e8 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0103db1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103db6:	8b 00                	mov    (%eax),%eax
c0103db8:	89 04 24             	mov    %eax,(%esp)
c0103dbb:	e8 3f ec ff ff       	call   c01029ff <pa2page>
c0103dc0:	89 04 24             	mov    %eax,(%esp)
c0103dc3:	e8 18 ed ff ff       	call   c0102ae0 <page_ref>
c0103dc8:	83 f8 01             	cmp    $0x1,%eax
c0103dcb:	74 24                	je     c0103df1 <check_pgdir+0x663>
c0103dcd:	c7 44 24 0c 70 6c 10 	movl   $0xc0106c70,0xc(%esp)
c0103dd4:	c0 
c0103dd5:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103ddc:	c0 
c0103ddd:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0103de4:	00 
c0103de5:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103dec:	e8 f7 c5 ff ff       	call   c01003e8 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0103df1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103df6:	8b 00                	mov    (%eax),%eax
c0103df8:	89 04 24             	mov    %eax,(%esp)
c0103dfb:	e8 ff eb ff ff       	call   c01029ff <pa2page>
c0103e00:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103e07:	00 
c0103e08:	89 04 24             	mov    %eax,(%esp)
c0103e0b:	e8 0d ef ff ff       	call   c0102d1d <free_pages>
    boot_pgdir[0] = 0;
c0103e10:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103e15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103e1b:	c7 04 24 96 6c 10 c0 	movl   $0xc0106c96,(%esp)
c0103e22:	e8 6a c4 ff ff       	call   c0100291 <cprintf>
}
c0103e27:	c9                   	leave  
c0103e28:	c3                   	ret    

c0103e29 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103e29:	55                   	push   %ebp
c0103e2a:	89 e5                	mov    %esp,%ebp
c0103e2c:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103e2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103e36:	e9 ca 00 00 00       	jmp    c0103f05 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e44:	c1 e8 0c             	shr    $0xc,%eax
c0103e47:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103e4a:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103e4f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103e52:	72 23                	jb     c0103e77 <check_boot_pgdir+0x4e>
c0103e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e57:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e5b:	c7 44 24 08 e0 68 10 	movl   $0xc01068e0,0x8(%esp)
c0103e62:	c0 
c0103e63:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0103e6a:	00 
c0103e6b:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103e72:	e8 71 c5 ff ff       	call   c01003e8 <__panic>
c0103e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e7a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103e7f:	89 c2                	mov    %eax,%edx
c0103e81:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103e86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103e8d:	00 
c0103e8e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e92:	89 04 24             	mov    %eax,(%esp)
c0103e95:	e8 8a f5 ff ff       	call   c0103424 <get_pte>
c0103e9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103e9d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103ea1:	75 24                	jne    c0103ec7 <check_boot_pgdir+0x9e>
c0103ea3:	c7 44 24 0c b0 6c 10 	movl   $0xc0106cb0,0xc(%esp)
c0103eaa:	c0 
c0103eab:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103eb2:	c0 
c0103eb3:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0103eba:	00 
c0103ebb:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103ec2:	e8 21 c5 ff ff       	call   c01003e8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103eca:	8b 00                	mov    (%eax),%eax
c0103ecc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ed1:	89 c2                	mov    %eax,%edx
c0103ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ed6:	39 c2                	cmp    %eax,%edx
c0103ed8:	74 24                	je     c0103efe <check_boot_pgdir+0xd5>
c0103eda:	c7 44 24 0c ed 6c 10 	movl   $0xc0106ced,0xc(%esp)
c0103ee1:	c0 
c0103ee2:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103ee9:	c0 
c0103eea:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0103ef1:	00 
c0103ef2:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103ef9:	e8 ea c4 ff ff       	call   c01003e8 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103efe:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103f08:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103f0d:	39 c2                	cmp    %eax,%edx
c0103f0f:	0f 82 26 ff ff ff    	jb     c0103e3b <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103f15:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103f1a:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103f1f:	8b 00                	mov    (%eax),%eax
c0103f21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103f26:	89 c2                	mov    %eax,%edx
c0103f28:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103f2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103f30:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0103f37:	77 23                	ja     c0103f5c <check_boot_pgdir+0x133>
c0103f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f3c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f40:	c7 44 24 08 84 69 10 	movl   $0xc0106984,0x8(%esp)
c0103f47:	c0 
c0103f48:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0103f4f:	00 
c0103f50:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103f57:	e8 8c c4 ff ff       	call   c01003e8 <__panic>
c0103f5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f5f:	05 00 00 00 40       	add    $0x40000000,%eax
c0103f64:	39 c2                	cmp    %eax,%edx
c0103f66:	74 24                	je     c0103f8c <check_boot_pgdir+0x163>
c0103f68:	c7 44 24 0c 04 6d 10 	movl   $0xc0106d04,0xc(%esp)
c0103f6f:	c0 
c0103f70:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103f77:	c0 
c0103f78:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0103f7f:	00 
c0103f80:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103f87:	e8 5c c4 ff ff       	call   c01003e8 <__panic>

    assert(boot_pgdir[0] == 0);
c0103f8c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103f91:	8b 00                	mov    (%eax),%eax
c0103f93:	85 c0                	test   %eax,%eax
c0103f95:	74 24                	je     c0103fbb <check_boot_pgdir+0x192>
c0103f97:	c7 44 24 0c 38 6d 10 	movl   $0xc0106d38,0xc(%esp)
c0103f9e:	c0 
c0103f9f:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0103fa6:	c0 
c0103fa7:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0103fae:	00 
c0103faf:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103fb6:	e8 2d c4 ff ff       	call   c01003e8 <__panic>

    struct Page *p;
    p = alloc_page();
c0103fbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fc2:	e8 1e ed ff ff       	call   c0102ce5 <alloc_pages>
c0103fc7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103fca:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103fcf:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103fd6:	00 
c0103fd7:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0103fde:	00 
c0103fdf:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103fe2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103fe6:	89 04 24             	mov    %eax,(%esp)
c0103fe9:	e8 6c f6 ff ff       	call   c010365a <page_insert>
c0103fee:	85 c0                	test   %eax,%eax
c0103ff0:	74 24                	je     c0104016 <check_boot_pgdir+0x1ed>
c0103ff2:	c7 44 24 0c 4c 6d 10 	movl   $0xc0106d4c,0xc(%esp)
c0103ff9:	c0 
c0103ffa:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0104001:	c0 
c0104002:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0104009:	00 
c010400a:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0104011:	e8 d2 c3 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p) == 1);
c0104016:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104019:	89 04 24             	mov    %eax,(%esp)
c010401c:	e8 bf ea ff ff       	call   c0102ae0 <page_ref>
c0104021:	83 f8 01             	cmp    $0x1,%eax
c0104024:	74 24                	je     c010404a <check_boot_pgdir+0x221>
c0104026:	c7 44 24 0c 7a 6d 10 	movl   $0xc0106d7a,0xc(%esp)
c010402d:	c0 
c010402e:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0104035:	c0 
c0104036:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c010403d:	00 
c010403e:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0104045:	e8 9e c3 ff ff       	call   c01003e8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010404a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010404f:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104056:	00 
c0104057:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010405e:	00 
c010405f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104062:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104066:	89 04 24             	mov    %eax,(%esp)
c0104069:	e8 ec f5 ff ff       	call   c010365a <page_insert>
c010406e:	85 c0                	test   %eax,%eax
c0104070:	74 24                	je     c0104096 <check_boot_pgdir+0x26d>
c0104072:	c7 44 24 0c 8c 6d 10 	movl   $0xc0106d8c,0xc(%esp)
c0104079:	c0 
c010407a:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0104081:	c0 
c0104082:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c0104089:	00 
c010408a:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0104091:	e8 52 c3 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p) == 2);
c0104096:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104099:	89 04 24             	mov    %eax,(%esp)
c010409c:	e8 3f ea ff ff       	call   c0102ae0 <page_ref>
c01040a1:	83 f8 02             	cmp    $0x2,%eax
c01040a4:	74 24                	je     c01040ca <check_boot_pgdir+0x2a1>
c01040a6:	c7 44 24 0c c3 6d 10 	movl   $0xc0106dc3,0xc(%esp)
c01040ad:	c0 
c01040ae:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c01040b5:	c0 
c01040b6:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c01040bd:	00 
c01040be:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c01040c5:	e8 1e c3 ff ff       	call   c01003e8 <__panic>

    const char *str = "ucore: Hello world!!";
c01040ca:	c7 45 dc d4 6d 10 c0 	movl   $0xc0106dd4,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01040d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01040d8:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01040df:	e8 ae 15 00 00       	call   c0105692 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01040e4:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01040eb:	00 
c01040ec:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01040f3:	e8 13 16 00 00       	call   c010570b <strcmp>
c01040f8:	85 c0                	test   %eax,%eax
c01040fa:	74 24                	je     c0104120 <check_boot_pgdir+0x2f7>
c01040fc:	c7 44 24 0c ec 6d 10 	movl   $0xc0106dec,0xc(%esp)
c0104103:	c0 
c0104104:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c010410b:	c0 
c010410c:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104113:	00 
c0104114:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c010411b:	e8 c8 c2 ff ff       	call   c01003e8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104120:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104123:	89 04 24             	mov    %eax,(%esp)
c0104126:	e8 23 e9 ff ff       	call   c0102a4e <page2kva>
c010412b:	05 00 01 00 00       	add    $0x100,%eax
c0104130:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104133:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010413a:	e8 fb 14 00 00       	call   c010563a <strlen>
c010413f:	85 c0                	test   %eax,%eax
c0104141:	74 24                	je     c0104167 <check_boot_pgdir+0x33e>
c0104143:	c7 44 24 0c 24 6e 10 	movl   $0xc0106e24,0xc(%esp)
c010414a:	c0 
c010414b:	c7 44 24 08 cd 69 10 	movl   $0xc01069cd,0x8(%esp)
c0104152:	c0 
c0104153:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c010415a:	00 
c010415b:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0104162:	e8 81 c2 ff ff       	call   c01003e8 <__panic>

    free_page(p);
c0104167:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010416e:	00 
c010416f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104172:	89 04 24             	mov    %eax,(%esp)
c0104175:	e8 a3 eb ff ff       	call   c0102d1d <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c010417a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010417f:	8b 00                	mov    (%eax),%eax
c0104181:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104186:	89 04 24             	mov    %eax,(%esp)
c0104189:	e8 71 e8 ff ff       	call   c01029ff <pa2page>
c010418e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104195:	00 
c0104196:	89 04 24             	mov    %eax,(%esp)
c0104199:	e8 7f eb ff ff       	call   c0102d1d <free_pages>
    boot_pgdir[0] = 0;
c010419e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01041a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01041a9:	c7 04 24 48 6e 10 c0 	movl   $0xc0106e48,(%esp)
c01041b0:	e8 dc c0 ff ff       	call   c0100291 <cprintf>
}
c01041b5:	c9                   	leave  
c01041b6:	c3                   	ret    

c01041b7 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01041b7:	55                   	push   %ebp
c01041b8:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01041ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01041bd:	83 e0 04             	and    $0x4,%eax
c01041c0:	85 c0                	test   %eax,%eax
c01041c2:	74 07                	je     c01041cb <perm2str+0x14>
c01041c4:	b8 75 00 00 00       	mov    $0x75,%eax
c01041c9:	eb 05                	jmp    c01041d0 <perm2str+0x19>
c01041cb:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01041d0:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c01041d5:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01041dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01041df:	83 e0 02             	and    $0x2,%eax
c01041e2:	85 c0                	test   %eax,%eax
c01041e4:	74 07                	je     c01041ed <perm2str+0x36>
c01041e6:	b8 77 00 00 00       	mov    $0x77,%eax
c01041eb:	eb 05                	jmp    c01041f2 <perm2str+0x3b>
c01041ed:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01041f2:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c01041f7:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c01041fe:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0104203:	5d                   	pop    %ebp
c0104204:	c3                   	ret    

c0104205 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104205:	55                   	push   %ebp
c0104206:	89 e5                	mov    %esp,%ebp
c0104208:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010420b:	8b 45 10             	mov    0x10(%ebp),%eax
c010420e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104211:	72 0a                	jb     c010421d <get_pgtable_items+0x18>
        return 0;
c0104213:	b8 00 00 00 00       	mov    $0x0,%eax
c0104218:	e9 9c 00 00 00       	jmp    c01042b9 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c010421d:	eb 04                	jmp    c0104223 <get_pgtable_items+0x1e>
        start ++;
c010421f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104223:	8b 45 10             	mov    0x10(%ebp),%eax
c0104226:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104229:	73 18                	jae    c0104243 <get_pgtable_items+0x3e>
c010422b:	8b 45 10             	mov    0x10(%ebp),%eax
c010422e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104235:	8b 45 14             	mov    0x14(%ebp),%eax
c0104238:	01 d0                	add    %edx,%eax
c010423a:	8b 00                	mov    (%eax),%eax
c010423c:	83 e0 01             	and    $0x1,%eax
c010423f:	85 c0                	test   %eax,%eax
c0104241:	74 dc                	je     c010421f <get_pgtable_items+0x1a>
    }
    if (start < right) {
c0104243:	8b 45 10             	mov    0x10(%ebp),%eax
c0104246:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104249:	73 69                	jae    c01042b4 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c010424b:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010424f:	74 08                	je     c0104259 <get_pgtable_items+0x54>
            *left_store = start;
c0104251:	8b 45 18             	mov    0x18(%ebp),%eax
c0104254:	8b 55 10             	mov    0x10(%ebp),%edx
c0104257:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104259:	8b 45 10             	mov    0x10(%ebp),%eax
c010425c:	8d 50 01             	lea    0x1(%eax),%edx
c010425f:	89 55 10             	mov    %edx,0x10(%ebp)
c0104262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104269:	8b 45 14             	mov    0x14(%ebp),%eax
c010426c:	01 d0                	add    %edx,%eax
c010426e:	8b 00                	mov    (%eax),%eax
c0104270:	83 e0 07             	and    $0x7,%eax
c0104273:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104276:	eb 04                	jmp    c010427c <get_pgtable_items+0x77>
            start ++;
c0104278:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010427c:	8b 45 10             	mov    0x10(%ebp),%eax
c010427f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104282:	73 1d                	jae    c01042a1 <get_pgtable_items+0x9c>
c0104284:	8b 45 10             	mov    0x10(%ebp),%eax
c0104287:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010428e:	8b 45 14             	mov    0x14(%ebp),%eax
c0104291:	01 d0                	add    %edx,%eax
c0104293:	8b 00                	mov    (%eax),%eax
c0104295:	83 e0 07             	and    $0x7,%eax
c0104298:	89 c2                	mov    %eax,%edx
c010429a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010429d:	39 c2                	cmp    %eax,%edx
c010429f:	74 d7                	je     c0104278 <get_pgtable_items+0x73>
        }
        if (right_store != NULL) {
c01042a1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01042a5:	74 08                	je     c01042af <get_pgtable_items+0xaa>
            *right_store = start;
c01042a7:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01042aa:	8b 55 10             	mov    0x10(%ebp),%edx
c01042ad:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01042af:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01042b2:	eb 05                	jmp    c01042b9 <get_pgtable_items+0xb4>
    }
    return 0;
c01042b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01042b9:	c9                   	leave  
c01042ba:	c3                   	ret    

c01042bb <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01042bb:	55                   	push   %ebp
c01042bc:	89 e5                	mov    %esp,%ebp
c01042be:	57                   	push   %edi
c01042bf:	56                   	push   %esi
c01042c0:	53                   	push   %ebx
c01042c1:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01042c4:	c7 04 24 68 6e 10 c0 	movl   $0xc0106e68,(%esp)
c01042cb:	e8 c1 bf ff ff       	call   c0100291 <cprintf>
    size_t left, right = 0, perm;
c01042d0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01042d7:	e9 fa 00 00 00       	jmp    c01043d6 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01042dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042df:	89 04 24             	mov    %eax,(%esp)
c01042e2:	e8 d0 fe ff ff       	call   c01041b7 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01042e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01042ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01042ed:	29 d1                	sub    %edx,%ecx
c01042ef:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01042f1:	89 d6                	mov    %edx,%esi
c01042f3:	c1 e6 16             	shl    $0x16,%esi
c01042f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01042f9:	89 d3                	mov    %edx,%ebx
c01042fb:	c1 e3 16             	shl    $0x16,%ebx
c01042fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104301:	89 d1                	mov    %edx,%ecx
c0104303:	c1 e1 16             	shl    $0x16,%ecx
c0104306:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104309:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010430c:	29 d7                	sub    %edx,%edi
c010430e:	89 fa                	mov    %edi,%edx
c0104310:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104314:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104318:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010431c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104320:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104324:	c7 04 24 99 6e 10 c0 	movl   $0xc0106e99,(%esp)
c010432b:	e8 61 bf ff ff       	call   c0100291 <cprintf>
        size_t l, r = left * NPTEENTRY;
c0104330:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104333:	c1 e0 0a             	shl    $0xa,%eax
c0104336:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104339:	eb 54                	jmp    c010438f <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010433b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010433e:	89 04 24             	mov    %eax,(%esp)
c0104341:	e8 71 fe ff ff       	call   c01041b7 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104346:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104349:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010434c:	29 d1                	sub    %edx,%ecx
c010434e:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104350:	89 d6                	mov    %edx,%esi
c0104352:	c1 e6 0c             	shl    $0xc,%esi
c0104355:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104358:	89 d3                	mov    %edx,%ebx
c010435a:	c1 e3 0c             	shl    $0xc,%ebx
c010435d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104360:	c1 e2 0c             	shl    $0xc,%edx
c0104363:	89 d1                	mov    %edx,%ecx
c0104365:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0104368:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010436b:	29 d7                	sub    %edx,%edi
c010436d:	89 fa                	mov    %edi,%edx
c010436f:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104373:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104377:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010437b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010437f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104383:	c7 04 24 b8 6e 10 c0 	movl   $0xc0106eb8,(%esp)
c010438a:	e8 02 bf ff ff       	call   c0100291 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010438f:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0104394:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104397:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010439a:	89 ce                	mov    %ecx,%esi
c010439c:	c1 e6 0a             	shl    $0xa,%esi
c010439f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01043a2:	89 cb                	mov    %ecx,%ebx
c01043a4:	c1 e3 0a             	shl    $0xa,%ebx
c01043a7:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01043aa:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01043ae:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01043b1:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01043b5:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01043b9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01043bd:	89 74 24 04          	mov    %esi,0x4(%esp)
c01043c1:	89 1c 24             	mov    %ebx,(%esp)
c01043c4:	e8 3c fe ff ff       	call   c0104205 <get_pgtable_items>
c01043c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01043d0:	0f 85 65 ff ff ff    	jne    c010433b <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01043d6:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01043db:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043de:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01043e1:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01043e5:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01043e8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01043ec:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01043f0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01043f4:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01043fb:	00 
c01043fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0104403:	e8 fd fd ff ff       	call   c0104205 <get_pgtable_items>
c0104408:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010440b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010440f:	0f 85 c7 fe ff ff    	jne    c01042dc <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104415:	c7 04 24 dc 6e 10 c0 	movl   $0xc0106edc,(%esp)
c010441c:	e8 70 be ff ff       	call   c0100291 <cprintf>
}
c0104421:	83 c4 4c             	add    $0x4c,%esp
c0104424:	5b                   	pop    %ebx
c0104425:	5e                   	pop    %esi
c0104426:	5f                   	pop    %edi
c0104427:	5d                   	pop    %ebp
c0104428:	c3                   	ret    

c0104429 <page2ppn>:
page2ppn(struct Page *page) {
c0104429:	55                   	push   %ebp
c010442a:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010442c:	8b 55 08             	mov    0x8(%ebp),%edx
c010442f:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0104434:	29 c2                	sub    %eax,%edx
c0104436:	89 d0                	mov    %edx,%eax
c0104438:	c1 f8 02             	sar    $0x2,%eax
c010443b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0104441:	5d                   	pop    %ebp
c0104442:	c3                   	ret    

c0104443 <page2pa>:
page2pa(struct Page *page) {
c0104443:	55                   	push   %ebp
c0104444:	89 e5                	mov    %esp,%ebp
c0104446:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104449:	8b 45 08             	mov    0x8(%ebp),%eax
c010444c:	89 04 24             	mov    %eax,(%esp)
c010444f:	e8 d5 ff ff ff       	call   c0104429 <page2ppn>
c0104454:	c1 e0 0c             	shl    $0xc,%eax
}
c0104457:	c9                   	leave  
c0104458:	c3                   	ret    

c0104459 <page_ref>:
page_ref(struct Page *page) {
c0104459:	55                   	push   %ebp
c010445a:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010445c:	8b 45 08             	mov    0x8(%ebp),%eax
c010445f:	8b 00                	mov    (%eax),%eax
}
c0104461:	5d                   	pop    %ebp
c0104462:	c3                   	ret    

c0104463 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0104463:	55                   	push   %ebp
c0104464:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104466:	8b 45 08             	mov    0x8(%ebp),%eax
c0104469:	8b 55 0c             	mov    0xc(%ebp),%edx
c010446c:	89 10                	mov    %edx,(%eax)
}
c010446e:	5d                   	pop    %ebp
c010446f:	c3                   	ret    

c0104470 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0104470:	55                   	push   %ebp
c0104471:	89 e5                	mov    %esp,%ebp
c0104473:	83 ec 10             	sub    $0x10,%esp
c0104476:	c7 45 fc 5c 89 11 c0 	movl   $0xc011895c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010447d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104480:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104483:	89 50 04             	mov    %edx,0x4(%eax)
c0104486:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104489:	8b 50 04             	mov    0x4(%eax),%edx
c010448c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010448f:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0104491:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c0104498:	00 00 00 
}
c010449b:	c9                   	leave  
c010449c:	c3                   	ret    

c010449d <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010449d:	55                   	push   %ebp
c010449e:	89 e5                	mov    %esp,%ebp
c01044a0:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01044a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01044a7:	75 24                	jne    c01044cd <default_init_memmap+0x30>
c01044a9:	c7 44 24 0c 10 6f 10 	movl   $0xc0106f10,0xc(%esp)
c01044b0:	c0 
c01044b1:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c01044b8:	c0 
c01044b9:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01044c0:	00 
c01044c1:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c01044c8:	e8 1b bf ff ff       	call   c01003e8 <__panic>
    struct Page *p = base;
c01044cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01044d3:	eb 7d                	jmp    c0104552 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01044d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d8:	83 c0 04             	add    $0x4,%eax
c01044db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01044e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01044e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01044eb:	0f a3 10             	bt     %edx,(%eax)
c01044ee:	19 c0                	sbb    %eax,%eax
c01044f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01044f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01044f7:	0f 95 c0             	setne  %al
c01044fa:	0f b6 c0             	movzbl %al,%eax
c01044fd:	85 c0                	test   %eax,%eax
c01044ff:	75 24                	jne    c0104525 <default_init_memmap+0x88>
c0104501:	c7 44 24 0c 41 6f 10 	movl   $0xc0106f41,0xc(%esp)
c0104508:	c0 
c0104509:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104510:	c0 
c0104511:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0104518:	00 
c0104519:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104520:	e8 c3 be ff ff       	call   c01003e8 <__panic>
        p->flags = p->property = 0;
c0104525:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104528:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010452f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104532:	8b 50 08             	mov    0x8(%eax),%edx
c0104535:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104538:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010453b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104542:	00 
c0104543:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104546:	89 04 24             	mov    %eax,(%esp)
c0104549:	e8 15 ff ff ff       	call   c0104463 <set_page_ref>
    for (; p != base + n; p ++) {
c010454e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104552:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104555:	89 d0                	mov    %edx,%eax
c0104557:	c1 e0 02             	shl    $0x2,%eax
c010455a:	01 d0                	add    %edx,%eax
c010455c:	c1 e0 02             	shl    $0x2,%eax
c010455f:	89 c2                	mov    %eax,%edx
c0104561:	8b 45 08             	mov    0x8(%ebp),%eax
c0104564:	01 d0                	add    %edx,%eax
c0104566:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104569:	0f 85 66 ff ff ff    	jne    c01044d5 <default_init_memmap+0x38>
    }
    base->property = n;
c010456f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104572:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104575:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104578:	8b 45 08             	mov    0x8(%ebp),%eax
c010457b:	83 c0 04             	add    $0x4,%eax
c010457e:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0104585:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104588:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010458b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010458e:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0104591:	8b 15 64 89 11 c0    	mov    0xc0118964,%edx
c0104597:	8b 45 0c             	mov    0xc(%ebp),%eax
c010459a:	01 d0                	add    %edx,%eax
c010459c:	a3 64 89 11 c0       	mov    %eax,0xc0118964
    list_add_before(&free_list, &(base->page_link));
c01045a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01045a4:	83 c0 0c             	add    $0xc,%eax
c01045a7:	c7 45 dc 5c 89 11 c0 	movl   $0xc011895c,-0x24(%ebp)
c01045ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01045b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01045b4:	8b 00                	mov    (%eax),%eax
c01045b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01045b9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01045bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01045bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01045c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01045c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01045c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01045cb:	89 10                	mov    %edx,(%eax)
c01045cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01045d0:	8b 10                	mov    (%eax),%edx
c01045d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01045d5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01045d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01045db:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01045de:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01045e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01045e4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01045e7:	89 10                	mov    %edx,(%eax)
}
c01045e9:	c9                   	leave  
c01045ea:	c3                   	ret    

c01045eb <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01045eb:	55                   	push   %ebp
c01045ec:	89 e5                	mov    %esp,%ebp
c01045ee:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);//判断n是否大于0
c01045f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01045f5:	75 24                	jne    c010461b <default_alloc_pages+0x30>
c01045f7:	c7 44 24 0c 10 6f 10 	movl   $0xc0106f10,0xc(%esp)
c01045fe:	c0 
c01045ff:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104606:	c0 
c0104607:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c010460e:	00 
c010460f:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104616:	e8 cd bd ff ff       	call   c01003e8 <__panic>
    if (n > nr_free) {//需要分配页的个数小于空闲页的总数,直接返回
c010461b:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104620:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104623:	73 0a                	jae    c010462f <default_alloc_pages+0x44>
        return NULL;
c0104625:	b8 00 00 00 00       	mov    $0x0,%eax
c010462a:	e9 3d 01 00 00       	jmp    c010476c <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
c010462f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104636:	c7 45 f0 5c 89 11 c0 	movl   $0xc011895c,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c010463d:	eb 1c                	jmp    c010465b <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c010463f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104642:	83 e8 0c             	sub    $0xc,%eax
c0104645:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0104648:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010464b:	8b 40 08             	mov    0x8(%eax),%eax
c010464e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104651:	72 08                	jb     c010465b <default_alloc_pages+0x70>
            page = p;
c0104653:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104656:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0104659:	eb 18                	jmp    c0104673 <default_alloc_pages+0x88>
c010465b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010465e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0104661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104664:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104667:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010466a:	81 7d f0 5c 89 11 c0 	cmpl   $0xc011895c,-0x10(%ebp)
c0104671:	75 cc                	jne    c010463f <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c0104673:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104677:	0f 84 ec 00 00 00    	je     c0104769 <default_alloc_pages+0x17e>
        if (page->property > n) {
c010467d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104680:	8b 40 08             	mov    0x8(%eax),%eax
c0104683:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104686:	0f 86 8c 00 00 00    	jbe    c0104718 <default_alloc_pages+0x12d>
            struct Page *p = page + n;
c010468c:	8b 55 08             	mov    0x8(%ebp),%edx
c010468f:	89 d0                	mov    %edx,%eax
c0104691:	c1 e0 02             	shl    $0x2,%eax
c0104694:	01 d0                	add    %edx,%eax
c0104696:	c1 e0 02             	shl    $0x2,%eax
c0104699:	89 c2                	mov    %eax,%edx
c010469b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010469e:	01 d0                	add    %edx,%eax
c01046a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c01046a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a6:	8b 40 08             	mov    0x8(%eax),%eax
c01046a9:	2b 45 08             	sub    0x8(%ebp),%eax
c01046ac:	89 c2                	mov    %eax,%edx
c01046ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01046b1:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c01046b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01046b7:	83 c0 04             	add    $0x4,%eax
c01046ba:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01046c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01046c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01046c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01046ca:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c01046cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01046d0:	83 c0 0c             	add    $0xc,%eax
c01046d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01046d6:	83 c2 0c             	add    $0xc,%edx
c01046d9:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01046dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c01046df:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01046e2:	8b 40 04             	mov    0x4(%eax),%eax
c01046e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01046e8:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01046eb:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01046ee:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01046f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c01046f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01046f7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01046fa:	89 10                	mov    %edx,(%eax)
c01046fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01046ff:	8b 10                	mov    (%eax),%edx
c0104701:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104704:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104707:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010470a:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010470d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104710:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104713:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104716:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0104718:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010471b:	83 c0 0c             	add    $0xc,%eax
c010471e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104721:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104724:	8b 40 04             	mov    0x4(%eax),%eax
c0104727:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010472a:	8b 12                	mov    (%edx),%edx
c010472c:	89 55 c0             	mov    %edx,-0x40(%ebp)
c010472f:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104732:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104735:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104738:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010473b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010473e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104741:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0104743:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104748:	2b 45 08             	sub    0x8(%ebp),%eax
c010474b:	a3 64 89 11 c0       	mov    %eax,0xc0118964
        ClearPageProperty(page);
c0104750:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104753:	83 c0 04             	add    $0x4,%eax
c0104756:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c010475d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104760:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104763:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104766:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0104769:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010476c:	c9                   	leave  
c010476d:	c3                   	ret    

c010476e <default_free_pages>:
    

static void
default_free_pages(struct Page *base, size_t n) {
c010476e:	55                   	push   %ebp
c010476f:	89 e5                	mov    %esp,%ebp
c0104771:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0104777:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010477b:	75 24                	jne    c01047a1 <default_free_pages+0x33>
c010477d:	c7 44 24 0c 10 6f 10 	movl   $0xc0106f10,0xc(%esp)
c0104784:	c0 
c0104785:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c010478c:	c0 
c010478d:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0104794:	00 
c0104795:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c010479c:	e8 47 bc ff ff       	call   c01003e8 <__panic>
    struct Page *p = base;
c01047a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01047a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01047a7:	e9 9d 00 00 00       	jmp    c0104849 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c01047ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047af:	83 c0 04             	add    $0x4,%eax
c01047b2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01047b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01047bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01047bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01047c2:	0f a3 10             	bt     %edx,(%eax)
c01047c5:	19 c0                	sbb    %eax,%eax
c01047c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c01047ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01047ce:	0f 95 c0             	setne  %al
c01047d1:	0f b6 c0             	movzbl %al,%eax
c01047d4:	85 c0                	test   %eax,%eax
c01047d6:	75 2c                	jne    c0104804 <default_free_pages+0x96>
c01047d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047db:	83 c0 04             	add    $0x4,%eax
c01047de:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01047e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01047e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01047eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01047ee:	0f a3 10             	bt     %edx,(%eax)
c01047f1:	19 c0                	sbb    %eax,%eax
c01047f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c01047f6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01047fa:	0f 95 c0             	setne  %al
c01047fd:	0f b6 c0             	movzbl %al,%eax
c0104800:	85 c0                	test   %eax,%eax
c0104802:	74 24                	je     c0104828 <default_free_pages+0xba>
c0104804:	c7 44 24 0c 54 6f 10 	movl   $0xc0106f54,0xc(%esp)
c010480b:	c0 
c010480c:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104813:	c0 
c0104814:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
c010481b:	00 
c010481c:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104823:	e8 c0 bb ff ff       	call   c01003e8 <__panic>
        p->flags = 0;
c0104828:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010482b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0104832:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104839:	00 
c010483a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010483d:	89 04 24             	mov    %eax,(%esp)
c0104840:	e8 1e fc ff ff       	call   c0104463 <set_page_ref>
    for (; p != base + n; p ++) {
c0104845:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104849:	8b 55 0c             	mov    0xc(%ebp),%edx
c010484c:	89 d0                	mov    %edx,%eax
c010484e:	c1 e0 02             	shl    $0x2,%eax
c0104851:	01 d0                	add    %edx,%eax
c0104853:	c1 e0 02             	shl    $0x2,%eax
c0104856:	89 c2                	mov    %eax,%edx
c0104858:	8b 45 08             	mov    0x8(%ebp),%eax
c010485b:	01 d0                	add    %edx,%eax
c010485d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104860:	0f 85 46 ff ff ff    	jne    c01047ac <default_free_pages+0x3e>
    }
    base->property = n;
c0104866:	8b 45 08             	mov    0x8(%ebp),%eax
c0104869:	8b 55 0c             	mov    0xc(%ebp),%edx
c010486c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010486f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104872:	83 c0 04             	add    $0x4,%eax
c0104875:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c010487c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010487f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104882:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104885:	0f ab 10             	bts    %edx,(%eax)
c0104888:	c7 45 cc 5c 89 11 c0 	movl   $0xc011895c,-0x34(%ebp)
    return listelm->next;
c010488f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104892:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0104895:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104898:	e9 08 01 00 00       	jmp    c01049a5 <default_free_pages+0x237>
        p = le2page(le, page_link);
c010489d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048a0:	83 e8 0c             	sub    $0xc,%eax
c01048a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048a9:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01048ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01048af:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01048b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c01048b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01048b8:	8b 50 08             	mov    0x8(%eax),%edx
c01048bb:	89 d0                	mov    %edx,%eax
c01048bd:	c1 e0 02             	shl    $0x2,%eax
c01048c0:	01 d0                	add    %edx,%eax
c01048c2:	c1 e0 02             	shl    $0x2,%eax
c01048c5:	89 c2                	mov    %eax,%edx
c01048c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01048ca:	01 d0                	add    %edx,%eax
c01048cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01048cf:	75 5a                	jne    c010492b <default_free_pages+0x1bd>
            base->property += p->property;
c01048d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01048d4:	8b 50 08             	mov    0x8(%eax),%edx
c01048d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048da:	8b 40 08             	mov    0x8(%eax),%eax
c01048dd:	01 c2                	add    %eax,%edx
c01048df:	8b 45 08             	mov    0x8(%ebp),%eax
c01048e2:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c01048e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048e8:	83 c0 04             	add    $0x4,%eax
c01048eb:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01048f2:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01048f5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01048f8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01048fb:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c01048fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104901:	83 c0 0c             	add    $0xc,%eax
c0104904:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104907:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010490a:	8b 40 04             	mov    0x4(%eax),%eax
c010490d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104910:	8b 12                	mov    (%edx),%edx
c0104912:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0104915:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next;
c0104918:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010491b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010491e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104921:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104924:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104927:	89 10                	mov    %edx,(%eax)
c0104929:	eb 7a                	jmp    c01049a5 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c010492b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010492e:	8b 50 08             	mov    0x8(%eax),%edx
c0104931:	89 d0                	mov    %edx,%eax
c0104933:	c1 e0 02             	shl    $0x2,%eax
c0104936:	01 d0                	add    %edx,%eax
c0104938:	c1 e0 02             	shl    $0x2,%eax
c010493b:	89 c2                	mov    %eax,%edx
c010493d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104940:	01 d0                	add    %edx,%eax
c0104942:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104945:	75 5e                	jne    c01049a5 <default_free_pages+0x237>
            p->property += base->property;
c0104947:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010494a:	8b 50 08             	mov    0x8(%eax),%edx
c010494d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104950:	8b 40 08             	mov    0x8(%eax),%eax
c0104953:	01 c2                	add    %eax,%edx
c0104955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104958:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c010495b:	8b 45 08             	mov    0x8(%ebp),%eax
c010495e:	83 c0 04             	add    $0x4,%eax
c0104961:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0104968:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010496b:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010496e:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104971:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0104974:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104977:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c010497a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010497d:	83 c0 0c             	add    $0xc,%eax
c0104980:	89 45 a8             	mov    %eax,-0x58(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104983:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104986:	8b 40 04             	mov    0x4(%eax),%eax
c0104989:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010498c:	8b 12                	mov    (%edx),%edx
c010498e:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0104991:	89 45 a0             	mov    %eax,-0x60(%ebp)
    prev->next = next;
c0104994:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104997:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010499a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010499d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01049a0:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01049a3:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
c01049a5:	81 7d f0 5c 89 11 c0 	cmpl   $0xc011895c,-0x10(%ebp)
c01049ac:	0f 85 eb fe ff ff    	jne    c010489d <default_free_pages+0x12f>
        }
    }
    nr_free += n;
c01049b2:	8b 15 64 89 11 c0    	mov    0xc0118964,%edx
c01049b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049bb:	01 d0                	add    %edx,%eax
c01049bd:	a3 64 89 11 c0       	mov    %eax,0xc0118964
c01049c2:	c7 45 9c 5c 89 11 c0 	movl   $0xc011895c,-0x64(%ebp)
    return listelm->next;
c01049c9:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01049cc:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c01049cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01049d2:	eb 76                	jmp    c0104a4a <default_free_pages+0x2dc>
        p = le2page(le, page_link);
c01049d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049d7:	83 e8 0c             	sub    $0xc,%eax
c01049da:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c01049dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01049e0:	8b 50 08             	mov    0x8(%eax),%edx
c01049e3:	89 d0                	mov    %edx,%eax
c01049e5:	c1 e0 02             	shl    $0x2,%eax
c01049e8:	01 d0                	add    %edx,%eax
c01049ea:	c1 e0 02             	shl    $0x2,%eax
c01049ed:	89 c2                	mov    %eax,%edx
c01049ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01049f2:	01 d0                	add    %edx,%eax
c01049f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01049f7:	77 42                	ja     c0104a3b <default_free_pages+0x2cd>
            assert(base + base->property != p);
c01049f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01049fc:	8b 50 08             	mov    0x8(%eax),%edx
c01049ff:	89 d0                	mov    %edx,%eax
c0104a01:	c1 e0 02             	shl    $0x2,%eax
c0104a04:	01 d0                	add    %edx,%eax
c0104a06:	c1 e0 02             	shl    $0x2,%eax
c0104a09:	89 c2                	mov    %eax,%edx
c0104a0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a0e:	01 d0                	add    %edx,%eax
c0104a10:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104a13:	75 24                	jne    c0104a39 <default_free_pages+0x2cb>
c0104a15:	c7 44 24 0c 79 6f 10 	movl   $0xc0106f79,0xc(%esp)
c0104a1c:	c0 
c0104a1d:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104a24:	c0 
c0104a25:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
c0104a2c:	00 
c0104a2d:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104a34:	e8 af b9 ff ff       	call   c01003e8 <__panic>
            break;
c0104a39:	eb 18                	jmp    c0104a53 <default_free_pages+0x2e5>
c0104a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a3e:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104a41:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104a44:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
c0104a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104a4a:	81 7d f0 5c 89 11 c0 	cmpl   $0xc011895c,-0x10(%ebp)
c0104a51:	75 81                	jne    c01049d4 <default_free_pages+0x266>
    }
    list_add_before(le, &(base->page_link));
c0104a53:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a56:	8d 50 0c             	lea    0xc(%eax),%edx
c0104a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a5c:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104a5f:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0104a62:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104a65:	8b 00                	mov    (%eax),%eax
c0104a67:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104a6a:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104a6d:	89 45 88             	mov    %eax,-0x78(%ebp)
c0104a70:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104a73:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0104a76:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104a79:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104a7c:	89 10                	mov    %edx,(%eax)
c0104a7e:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104a81:	8b 10                	mov    (%eax),%edx
c0104a83:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104a86:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104a89:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104a8c:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104a8f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104a92:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104a95:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104a98:	89 10                	mov    %edx,(%eax)
}
c0104a9a:	c9                   	leave  
c0104a9b:	c3                   	ret    

c0104a9c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104a9c:	55                   	push   %ebp
c0104a9d:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104a9f:	a1 64 89 11 c0       	mov    0xc0118964,%eax
}
c0104aa4:	5d                   	pop    %ebp
c0104aa5:	c3                   	ret    

c0104aa6 <basic_check>:

static void
basic_check(void) {
c0104aa6:	55                   	push   %ebp
c0104aa7:	89 e5                	mov    %esp,%ebp
c0104aa9:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104aac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104abc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104abf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ac6:	e8 1a e2 ff ff       	call   c0102ce5 <alloc_pages>
c0104acb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104ace:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104ad2:	75 24                	jne    c0104af8 <basic_check+0x52>
c0104ad4:	c7 44 24 0c 94 6f 10 	movl   $0xc0106f94,0xc(%esp)
c0104adb:	c0 
c0104adc:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104ae3:	c0 
c0104ae4:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0104aeb:	00 
c0104aec:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104af3:	e8 f0 b8 ff ff       	call   c01003e8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104af8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104aff:	e8 e1 e1 ff ff       	call   c0102ce5 <alloc_pages>
c0104b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b0b:	75 24                	jne    c0104b31 <basic_check+0x8b>
c0104b0d:	c7 44 24 0c b0 6f 10 	movl   $0xc0106fb0,0xc(%esp)
c0104b14:	c0 
c0104b15:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104b1c:	c0 
c0104b1d:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c0104b24:	00 
c0104b25:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104b2c:	e8 b7 b8 ff ff       	call   c01003e8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104b31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104b38:	e8 a8 e1 ff ff       	call   c0102ce5 <alloc_pages>
c0104b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104b44:	75 24                	jne    c0104b6a <basic_check+0xc4>
c0104b46:	c7 44 24 0c cc 6f 10 	movl   $0xc0106fcc,0xc(%esp)
c0104b4d:	c0 
c0104b4e:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104b55:	c0 
c0104b56:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c0104b5d:	00 
c0104b5e:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104b65:	e8 7e b8 ff ff       	call   c01003e8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b6d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104b70:	74 10                	je     c0104b82 <basic_check+0xdc>
c0104b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b75:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104b78:	74 08                	je     c0104b82 <basic_check+0xdc>
c0104b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b7d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104b80:	75 24                	jne    c0104ba6 <basic_check+0x100>
c0104b82:	c7 44 24 0c e8 6f 10 	movl   $0xc0106fe8,0xc(%esp)
c0104b89:	c0 
c0104b8a:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104b91:	c0 
c0104b92:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0104b99:	00 
c0104b9a:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104ba1:	e8 42 b8 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ba9:	89 04 24             	mov    %eax,(%esp)
c0104bac:	e8 a8 f8 ff ff       	call   c0104459 <page_ref>
c0104bb1:	85 c0                	test   %eax,%eax
c0104bb3:	75 1e                	jne    c0104bd3 <basic_check+0x12d>
c0104bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bb8:	89 04 24             	mov    %eax,(%esp)
c0104bbb:	e8 99 f8 ff ff       	call   c0104459 <page_ref>
c0104bc0:	85 c0                	test   %eax,%eax
c0104bc2:	75 0f                	jne    c0104bd3 <basic_check+0x12d>
c0104bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bc7:	89 04 24             	mov    %eax,(%esp)
c0104bca:	e8 8a f8 ff ff       	call   c0104459 <page_ref>
c0104bcf:	85 c0                	test   %eax,%eax
c0104bd1:	74 24                	je     c0104bf7 <basic_check+0x151>
c0104bd3:	c7 44 24 0c 0c 70 10 	movl   $0xc010700c,0xc(%esp)
c0104bda:	c0 
c0104bdb:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104be2:	c0 
c0104be3:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0104bea:	00 
c0104beb:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104bf2:	e8 f1 b7 ff ff       	call   c01003e8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104bf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bfa:	89 04 24             	mov    %eax,(%esp)
c0104bfd:	e8 41 f8 ff ff       	call   c0104443 <page2pa>
c0104c02:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0104c08:	c1 e2 0c             	shl    $0xc,%edx
c0104c0b:	39 d0                	cmp    %edx,%eax
c0104c0d:	72 24                	jb     c0104c33 <basic_check+0x18d>
c0104c0f:	c7 44 24 0c 48 70 10 	movl   $0xc0107048,0xc(%esp)
c0104c16:	c0 
c0104c17:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104c1e:	c0 
c0104c1f:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
c0104c26:	00 
c0104c27:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104c2e:	e8 b5 b7 ff ff       	call   c01003e8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c36:	89 04 24             	mov    %eax,(%esp)
c0104c39:	e8 05 f8 ff ff       	call   c0104443 <page2pa>
c0104c3e:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0104c44:	c1 e2 0c             	shl    $0xc,%edx
c0104c47:	39 d0                	cmp    %edx,%eax
c0104c49:	72 24                	jb     c0104c6f <basic_check+0x1c9>
c0104c4b:	c7 44 24 0c 65 70 10 	movl   $0xc0107065,0xc(%esp)
c0104c52:	c0 
c0104c53:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104c5a:	c0 
c0104c5b:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0104c62:	00 
c0104c63:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104c6a:	e8 79 b7 ff ff       	call   c01003e8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c72:	89 04 24             	mov    %eax,(%esp)
c0104c75:	e8 c9 f7 ff ff       	call   c0104443 <page2pa>
c0104c7a:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0104c80:	c1 e2 0c             	shl    $0xc,%edx
c0104c83:	39 d0                	cmp    %edx,%eax
c0104c85:	72 24                	jb     c0104cab <basic_check+0x205>
c0104c87:	c7 44 24 0c 82 70 10 	movl   $0xc0107082,0xc(%esp)
c0104c8e:	c0 
c0104c8f:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104c96:	c0 
c0104c97:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
c0104c9e:	00 
c0104c9f:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104ca6:	e8 3d b7 ff ff       	call   c01003e8 <__panic>

    list_entry_t free_list_store = free_list;
c0104cab:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104cb0:	8b 15 60 89 11 c0    	mov    0xc0118960,%edx
c0104cb6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104cb9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104cbc:	c7 45 e0 5c 89 11 c0 	movl   $0xc011895c,-0x20(%ebp)
    elm->prev = elm->next = elm;
c0104cc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104cc6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104cc9:	89 50 04             	mov    %edx,0x4(%eax)
c0104ccc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ccf:	8b 50 04             	mov    0x4(%eax),%edx
c0104cd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104cd5:	89 10                	mov    %edx,(%eax)
c0104cd7:	c7 45 dc 5c 89 11 c0 	movl   $0xc011895c,-0x24(%ebp)
    return list->next == list;
c0104cde:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ce1:	8b 40 04             	mov    0x4(%eax),%eax
c0104ce4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104ce7:	0f 94 c0             	sete   %al
c0104cea:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104ced:	85 c0                	test   %eax,%eax
c0104cef:	75 24                	jne    c0104d15 <basic_check+0x26f>
c0104cf1:	c7 44 24 0c 9f 70 10 	movl   $0xc010709f,0xc(%esp)
c0104cf8:	c0 
c0104cf9:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104d00:	c0 
c0104d01:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0104d08:	00 
c0104d09:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104d10:	e8 d3 b6 ff ff       	call   c01003e8 <__panic>

    unsigned int nr_free_store = nr_free;
c0104d15:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104d1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104d1d:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c0104d24:	00 00 00 

    assert(alloc_page() == NULL);
c0104d27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d2e:	e8 b2 df ff ff       	call   c0102ce5 <alloc_pages>
c0104d33:	85 c0                	test   %eax,%eax
c0104d35:	74 24                	je     c0104d5b <basic_check+0x2b5>
c0104d37:	c7 44 24 0c b6 70 10 	movl   $0xc01070b6,0xc(%esp)
c0104d3e:	c0 
c0104d3f:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104d46:	c0 
c0104d47:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0104d4e:	00 
c0104d4f:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104d56:	e8 8d b6 ff ff       	call   c01003e8 <__panic>

    free_page(p0);
c0104d5b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d62:	00 
c0104d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d66:	89 04 24             	mov    %eax,(%esp)
c0104d69:	e8 af df ff ff       	call   c0102d1d <free_pages>
    free_page(p1);
c0104d6e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d75:	00 
c0104d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d79:	89 04 24             	mov    %eax,(%esp)
c0104d7c:	e8 9c df ff ff       	call   c0102d1d <free_pages>
    free_page(p2);
c0104d81:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d88:	00 
c0104d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d8c:	89 04 24             	mov    %eax,(%esp)
c0104d8f:	e8 89 df ff ff       	call   c0102d1d <free_pages>
    assert(nr_free == 3);
c0104d94:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104d99:	83 f8 03             	cmp    $0x3,%eax
c0104d9c:	74 24                	je     c0104dc2 <basic_check+0x31c>
c0104d9e:	c7 44 24 0c cb 70 10 	movl   $0xc01070cb,0xc(%esp)
c0104da5:	c0 
c0104da6:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104dad:	c0 
c0104dae:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c0104db5:	00 
c0104db6:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104dbd:	e8 26 b6 ff ff       	call   c01003e8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104dc2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104dc9:	e8 17 df ff ff       	call   c0102ce5 <alloc_pages>
c0104dce:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104dd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104dd5:	75 24                	jne    c0104dfb <basic_check+0x355>
c0104dd7:	c7 44 24 0c 94 6f 10 	movl   $0xc0106f94,0xc(%esp)
c0104dde:	c0 
c0104ddf:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104de6:	c0 
c0104de7:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0104dee:	00 
c0104def:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104df6:	e8 ed b5 ff ff       	call   c01003e8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104dfb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e02:	e8 de de ff ff       	call   c0102ce5 <alloc_pages>
c0104e07:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e0e:	75 24                	jne    c0104e34 <basic_check+0x38e>
c0104e10:	c7 44 24 0c b0 6f 10 	movl   $0xc0106fb0,0xc(%esp)
c0104e17:	c0 
c0104e18:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104e1f:	c0 
c0104e20:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0104e27:	00 
c0104e28:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104e2f:	e8 b4 b5 ff ff       	call   c01003e8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104e34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e3b:	e8 a5 de ff ff       	call   c0102ce5 <alloc_pages>
c0104e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104e43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e47:	75 24                	jne    c0104e6d <basic_check+0x3c7>
c0104e49:	c7 44 24 0c cc 6f 10 	movl   $0xc0106fcc,0xc(%esp)
c0104e50:	c0 
c0104e51:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104e58:	c0 
c0104e59:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0104e60:	00 
c0104e61:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104e68:	e8 7b b5 ff ff       	call   c01003e8 <__panic>

    assert(alloc_page() == NULL);
c0104e6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e74:	e8 6c de ff ff       	call   c0102ce5 <alloc_pages>
c0104e79:	85 c0                	test   %eax,%eax
c0104e7b:	74 24                	je     c0104ea1 <basic_check+0x3fb>
c0104e7d:	c7 44 24 0c b6 70 10 	movl   $0xc01070b6,0xc(%esp)
c0104e84:	c0 
c0104e85:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104e8c:	c0 
c0104e8d:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0104e94:	00 
c0104e95:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104e9c:	e8 47 b5 ff ff       	call   c01003e8 <__panic>

    free_page(p0);
c0104ea1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ea8:	00 
c0104ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104eac:	89 04 24             	mov    %eax,(%esp)
c0104eaf:	e8 69 de ff ff       	call   c0102d1d <free_pages>
c0104eb4:	c7 45 d8 5c 89 11 c0 	movl   $0xc011895c,-0x28(%ebp)
c0104ebb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104ebe:	8b 40 04             	mov    0x4(%eax),%eax
c0104ec1:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104ec4:	0f 94 c0             	sete   %al
c0104ec7:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104eca:	85 c0                	test   %eax,%eax
c0104ecc:	74 24                	je     c0104ef2 <basic_check+0x44c>
c0104ece:	c7 44 24 0c d8 70 10 	movl   $0xc01070d8,0xc(%esp)
c0104ed5:	c0 
c0104ed6:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104edd:	c0 
c0104ede:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0104ee5:	00 
c0104ee6:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104eed:	e8 f6 b4 ff ff       	call   c01003e8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104ef2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ef9:	e8 e7 dd ff ff       	call   c0102ce5 <alloc_pages>
c0104efe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f04:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104f07:	74 24                	je     c0104f2d <basic_check+0x487>
c0104f09:	c7 44 24 0c f0 70 10 	movl   $0xc01070f0,0xc(%esp)
c0104f10:	c0 
c0104f11:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104f18:	c0 
c0104f19:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0104f20:	00 
c0104f21:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104f28:	e8 bb b4 ff ff       	call   c01003e8 <__panic>
    assert(alloc_page() == NULL);
c0104f2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f34:	e8 ac dd ff ff       	call   c0102ce5 <alloc_pages>
c0104f39:	85 c0                	test   %eax,%eax
c0104f3b:	74 24                	je     c0104f61 <basic_check+0x4bb>
c0104f3d:	c7 44 24 0c b6 70 10 	movl   $0xc01070b6,0xc(%esp)
c0104f44:	c0 
c0104f45:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104f4c:	c0 
c0104f4d:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0104f54:	00 
c0104f55:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104f5c:	e8 87 b4 ff ff       	call   c01003e8 <__panic>

    assert(nr_free == 0);
c0104f61:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104f66:	85 c0                	test   %eax,%eax
c0104f68:	74 24                	je     c0104f8e <basic_check+0x4e8>
c0104f6a:	c7 44 24 0c 09 71 10 	movl   $0xc0107109,0xc(%esp)
c0104f71:	c0 
c0104f72:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0104f79:	c0 
c0104f7a:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0104f81:	00 
c0104f82:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0104f89:	e8 5a b4 ff ff       	call   c01003e8 <__panic>
    free_list = free_list_store;
c0104f8e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104f91:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f94:	a3 5c 89 11 c0       	mov    %eax,0xc011895c
c0104f99:	89 15 60 89 11 c0    	mov    %edx,0xc0118960
    nr_free = nr_free_store;
c0104f9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fa2:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    free_page(p);
c0104fa7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fae:	00 
c0104faf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fb2:	89 04 24             	mov    %eax,(%esp)
c0104fb5:	e8 63 dd ff ff       	call   c0102d1d <free_pages>
    free_page(p1);
c0104fba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fc1:	00 
c0104fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fc5:	89 04 24             	mov    %eax,(%esp)
c0104fc8:	e8 50 dd ff ff       	call   c0102d1d <free_pages>
    free_page(p2);
c0104fcd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fd4:	00 
c0104fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fd8:	89 04 24             	mov    %eax,(%esp)
c0104fdb:	e8 3d dd ff ff       	call   c0102d1d <free_pages>
}
c0104fe0:	c9                   	leave  
c0104fe1:	c3                   	ret    

c0104fe2 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104fe2:	55                   	push   %ebp
c0104fe3:	89 e5                	mov    %esp,%ebp
c0104fe5:	53                   	push   %ebx
c0104fe6:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0104fec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104ff3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104ffa:	c7 45 ec 5c 89 11 c0 	movl   $0xc011895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105001:	eb 6b                	jmp    c010506e <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0105003:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105006:	83 e8 0c             	sub    $0xc,%eax
c0105009:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c010500c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010500f:	83 c0 04             	add    $0x4,%eax
c0105012:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105019:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010501c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010501f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105022:	0f a3 10             	bt     %edx,(%eax)
c0105025:	19 c0                	sbb    %eax,%eax
c0105027:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010502a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010502e:	0f 95 c0             	setne  %al
c0105031:	0f b6 c0             	movzbl %al,%eax
c0105034:	85 c0                	test   %eax,%eax
c0105036:	75 24                	jne    c010505c <default_check+0x7a>
c0105038:	c7 44 24 0c 16 71 10 	movl   $0xc0107116,0xc(%esp)
c010503f:	c0 
c0105040:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0105047:	c0 
c0105048:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c010504f:	00 
c0105050:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0105057:	e8 8c b3 ff ff       	call   c01003e8 <__panic>
        count ++, total += p->property;
c010505c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0105060:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105063:	8b 50 08             	mov    0x8(%eax),%edx
c0105066:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105069:	01 d0                	add    %edx,%eax
c010506b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010506e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105071:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0105074:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105077:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010507a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010507d:	81 7d ec 5c 89 11 c0 	cmpl   $0xc011895c,-0x14(%ebp)
c0105084:	0f 85 79 ff ff ff    	jne    c0105003 <default_check+0x21>
    }
    assert(total == nr_free_pages());
c010508a:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010508d:	e8 bd dc ff ff       	call   c0102d4f <nr_free_pages>
c0105092:	39 c3                	cmp    %eax,%ebx
c0105094:	74 24                	je     c01050ba <default_check+0xd8>
c0105096:	c7 44 24 0c 26 71 10 	movl   $0xc0107126,0xc(%esp)
c010509d:	c0 
c010509e:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c01050a5:	c0 
c01050a6:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c01050ad:	00 
c01050ae:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c01050b5:	e8 2e b3 ff ff       	call   c01003e8 <__panic>

    basic_check();
c01050ba:	e8 e7 f9 ff ff       	call   c0104aa6 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01050bf:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01050c6:	e8 1a dc ff ff       	call   c0102ce5 <alloc_pages>
c01050cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01050ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01050d2:	75 24                	jne    c01050f8 <default_check+0x116>
c01050d4:	c7 44 24 0c 3f 71 10 	movl   $0xc010713f,0xc(%esp)
c01050db:	c0 
c01050dc:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c01050e3:	c0 
c01050e4:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01050eb:	00 
c01050ec:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c01050f3:	e8 f0 b2 ff ff       	call   c01003e8 <__panic>
    assert(!PageProperty(p0));
c01050f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01050fb:	83 c0 04             	add    $0x4,%eax
c01050fe:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0105105:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105108:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010510b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010510e:	0f a3 10             	bt     %edx,(%eax)
c0105111:	19 c0                	sbb    %eax,%eax
c0105113:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0105116:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010511a:	0f 95 c0             	setne  %al
c010511d:	0f b6 c0             	movzbl %al,%eax
c0105120:	85 c0                	test   %eax,%eax
c0105122:	74 24                	je     c0105148 <default_check+0x166>
c0105124:	c7 44 24 0c 4a 71 10 	movl   $0xc010714a,0xc(%esp)
c010512b:	c0 
c010512c:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0105133:	c0 
c0105134:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c010513b:	00 
c010513c:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0105143:	e8 a0 b2 ff ff       	call   c01003e8 <__panic>

    list_entry_t free_list_store = free_list;
c0105148:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c010514d:	8b 15 60 89 11 c0    	mov    0xc0118960,%edx
c0105153:	89 45 80             	mov    %eax,-0x80(%ebp)
c0105156:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0105159:	c7 45 b4 5c 89 11 c0 	movl   $0xc011895c,-0x4c(%ebp)
    elm->prev = elm->next = elm;
c0105160:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105163:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105166:	89 50 04             	mov    %edx,0x4(%eax)
c0105169:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010516c:	8b 50 04             	mov    0x4(%eax),%edx
c010516f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105172:	89 10                	mov    %edx,(%eax)
c0105174:	c7 45 b0 5c 89 11 c0 	movl   $0xc011895c,-0x50(%ebp)
    return list->next == list;
c010517b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010517e:	8b 40 04             	mov    0x4(%eax),%eax
c0105181:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0105184:	0f 94 c0             	sete   %al
c0105187:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010518a:	85 c0                	test   %eax,%eax
c010518c:	75 24                	jne    c01051b2 <default_check+0x1d0>
c010518e:	c7 44 24 0c 9f 70 10 	movl   $0xc010709f,0xc(%esp)
c0105195:	c0 
c0105196:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c010519d:	c0 
c010519e:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c01051a5:	00 
c01051a6:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c01051ad:	e8 36 b2 ff ff       	call   c01003e8 <__panic>
    assert(alloc_page() == NULL);
c01051b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01051b9:	e8 27 db ff ff       	call   c0102ce5 <alloc_pages>
c01051be:	85 c0                	test   %eax,%eax
c01051c0:	74 24                	je     c01051e6 <default_check+0x204>
c01051c2:	c7 44 24 0c b6 70 10 	movl   $0xc01070b6,0xc(%esp)
c01051c9:	c0 
c01051ca:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c01051d1:	c0 
c01051d2:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01051d9:	00 
c01051da:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c01051e1:	e8 02 b2 ff ff       	call   c01003e8 <__panic>

    unsigned int nr_free_store = nr_free;
c01051e6:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01051eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01051ee:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c01051f5:	00 00 00 

    free_pages(p0 + 2, 3);
c01051f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051fb:	83 c0 28             	add    $0x28,%eax
c01051fe:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0105205:	00 
c0105206:	89 04 24             	mov    %eax,(%esp)
c0105209:	e8 0f db ff ff       	call   c0102d1d <free_pages>
    assert(alloc_pages(4) == NULL);
c010520e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0105215:	e8 cb da ff ff       	call   c0102ce5 <alloc_pages>
c010521a:	85 c0                	test   %eax,%eax
c010521c:	74 24                	je     c0105242 <default_check+0x260>
c010521e:	c7 44 24 0c 5c 71 10 	movl   $0xc010715c,0xc(%esp)
c0105225:	c0 
c0105226:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c010522d:	c0 
c010522e:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0105235:	00 
c0105236:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c010523d:	e8 a6 b1 ff ff       	call   c01003e8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0105242:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105245:	83 c0 28             	add    $0x28,%eax
c0105248:	83 c0 04             	add    $0x4,%eax
c010524b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0105252:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105255:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105258:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010525b:	0f a3 10             	bt     %edx,(%eax)
c010525e:	19 c0                	sbb    %eax,%eax
c0105260:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0105263:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0105267:	0f 95 c0             	setne  %al
c010526a:	0f b6 c0             	movzbl %al,%eax
c010526d:	85 c0                	test   %eax,%eax
c010526f:	74 0e                	je     c010527f <default_check+0x29d>
c0105271:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105274:	83 c0 28             	add    $0x28,%eax
c0105277:	8b 40 08             	mov    0x8(%eax),%eax
c010527a:	83 f8 03             	cmp    $0x3,%eax
c010527d:	74 24                	je     c01052a3 <default_check+0x2c1>
c010527f:	c7 44 24 0c 74 71 10 	movl   $0xc0107174,0xc(%esp)
c0105286:	c0 
c0105287:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c010528e:	c0 
c010528f:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0105296:	00 
c0105297:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c010529e:	e8 45 b1 ff ff       	call   c01003e8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01052a3:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01052aa:	e8 36 da ff ff       	call   c0102ce5 <alloc_pages>
c01052af:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01052b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01052b6:	75 24                	jne    c01052dc <default_check+0x2fa>
c01052b8:	c7 44 24 0c a0 71 10 	movl   $0xc01071a0,0xc(%esp)
c01052bf:	c0 
c01052c0:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c01052c7:	c0 
c01052c8:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c01052cf:	00 
c01052d0:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c01052d7:	e8 0c b1 ff ff       	call   c01003e8 <__panic>
    assert(alloc_page() == NULL);
c01052dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01052e3:	e8 fd d9 ff ff       	call   c0102ce5 <alloc_pages>
c01052e8:	85 c0                	test   %eax,%eax
c01052ea:	74 24                	je     c0105310 <default_check+0x32e>
c01052ec:	c7 44 24 0c b6 70 10 	movl   $0xc01070b6,0xc(%esp)
c01052f3:	c0 
c01052f4:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c01052fb:	c0 
c01052fc:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0105303:	00 
c0105304:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c010530b:	e8 d8 b0 ff ff       	call   c01003e8 <__panic>
    assert(p0 + 2 == p1);
c0105310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105313:	83 c0 28             	add    $0x28,%eax
c0105316:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105319:	74 24                	je     c010533f <default_check+0x35d>
c010531b:	c7 44 24 0c be 71 10 	movl   $0xc01071be,0xc(%esp)
c0105322:	c0 
c0105323:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c010532a:	c0 
c010532b:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0105332:	00 
c0105333:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c010533a:	e8 a9 b0 ff ff       	call   c01003e8 <__panic>

    p2 = p0 + 1;
c010533f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105342:	83 c0 14             	add    $0x14,%eax
c0105345:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0105348:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010534f:	00 
c0105350:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105353:	89 04 24             	mov    %eax,(%esp)
c0105356:	e8 c2 d9 ff ff       	call   c0102d1d <free_pages>
    free_pages(p1, 3);
c010535b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0105362:	00 
c0105363:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105366:	89 04 24             	mov    %eax,(%esp)
c0105369:	e8 af d9 ff ff       	call   c0102d1d <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010536e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105371:	83 c0 04             	add    $0x4,%eax
c0105374:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010537b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010537e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105381:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105384:	0f a3 10             	bt     %edx,(%eax)
c0105387:	19 c0                	sbb    %eax,%eax
c0105389:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010538c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105390:	0f 95 c0             	setne  %al
c0105393:	0f b6 c0             	movzbl %al,%eax
c0105396:	85 c0                	test   %eax,%eax
c0105398:	74 0b                	je     c01053a5 <default_check+0x3c3>
c010539a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010539d:	8b 40 08             	mov    0x8(%eax),%eax
c01053a0:	83 f8 01             	cmp    $0x1,%eax
c01053a3:	74 24                	je     c01053c9 <default_check+0x3e7>
c01053a5:	c7 44 24 0c cc 71 10 	movl   $0xc01071cc,0xc(%esp)
c01053ac:	c0 
c01053ad:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c01053b4:	c0 
c01053b5:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01053bc:	00 
c01053bd:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c01053c4:	e8 1f b0 ff ff       	call   c01003e8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01053c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053cc:	83 c0 04             	add    $0x4,%eax
c01053cf:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01053d6:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01053d9:	8b 45 90             	mov    -0x70(%ebp),%eax
c01053dc:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01053df:	0f a3 10             	bt     %edx,(%eax)
c01053e2:	19 c0                	sbb    %eax,%eax
c01053e4:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01053e7:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01053eb:	0f 95 c0             	setne  %al
c01053ee:	0f b6 c0             	movzbl %al,%eax
c01053f1:	85 c0                	test   %eax,%eax
c01053f3:	74 0b                	je     c0105400 <default_check+0x41e>
c01053f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053f8:	8b 40 08             	mov    0x8(%eax),%eax
c01053fb:	83 f8 03             	cmp    $0x3,%eax
c01053fe:	74 24                	je     c0105424 <default_check+0x442>
c0105400:	c7 44 24 0c f4 71 10 	movl   $0xc01071f4,0xc(%esp)
c0105407:	c0 
c0105408:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c010540f:	c0 
c0105410:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0105417:	00 
c0105418:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c010541f:	e8 c4 af ff ff       	call   c01003e8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0105424:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010542b:	e8 b5 d8 ff ff       	call   c0102ce5 <alloc_pages>
c0105430:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105433:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105436:	83 e8 14             	sub    $0x14,%eax
c0105439:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010543c:	74 24                	je     c0105462 <default_check+0x480>
c010543e:	c7 44 24 0c 1a 72 10 	movl   $0xc010721a,0xc(%esp)
c0105445:	c0 
c0105446:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c010544d:	c0 
c010544e:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0105455:	00 
c0105456:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c010545d:	e8 86 af ff ff       	call   c01003e8 <__panic>
    free_page(p0);
c0105462:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105469:	00 
c010546a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010546d:	89 04 24             	mov    %eax,(%esp)
c0105470:	e8 a8 d8 ff ff       	call   c0102d1d <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0105475:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010547c:	e8 64 d8 ff ff       	call   c0102ce5 <alloc_pages>
c0105481:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105484:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105487:	83 c0 14             	add    $0x14,%eax
c010548a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010548d:	74 24                	je     c01054b3 <default_check+0x4d1>
c010548f:	c7 44 24 0c 38 72 10 	movl   $0xc0107238,0xc(%esp)
c0105496:	c0 
c0105497:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c010549e:	c0 
c010549f:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01054a6:	00 
c01054a7:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c01054ae:	e8 35 af ff ff       	call   c01003e8 <__panic>

    free_pages(p0, 2);
c01054b3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01054ba:	00 
c01054bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054be:	89 04 24             	mov    %eax,(%esp)
c01054c1:	e8 57 d8 ff ff       	call   c0102d1d <free_pages>
    free_page(p2);
c01054c6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01054cd:	00 
c01054ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01054d1:	89 04 24             	mov    %eax,(%esp)
c01054d4:	e8 44 d8 ff ff       	call   c0102d1d <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01054d9:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01054e0:	e8 00 d8 ff ff       	call   c0102ce5 <alloc_pages>
c01054e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01054ec:	75 24                	jne    c0105512 <default_check+0x530>
c01054ee:	c7 44 24 0c 58 72 10 	movl   $0xc0107258,0xc(%esp)
c01054f5:	c0 
c01054f6:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c01054fd:	c0 
c01054fe:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0105505:	00 
c0105506:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c010550d:	e8 d6 ae ff ff       	call   c01003e8 <__panic>
    assert(alloc_page() == NULL);
c0105512:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105519:	e8 c7 d7 ff ff       	call   c0102ce5 <alloc_pages>
c010551e:	85 c0                	test   %eax,%eax
c0105520:	74 24                	je     c0105546 <default_check+0x564>
c0105522:	c7 44 24 0c b6 70 10 	movl   $0xc01070b6,0xc(%esp)
c0105529:	c0 
c010552a:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c0105531:	c0 
c0105532:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0105539:	00 
c010553a:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0105541:	e8 a2 ae ff ff       	call   c01003e8 <__panic>

    assert(nr_free == 0);
c0105546:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010554b:	85 c0                	test   %eax,%eax
c010554d:	74 24                	je     c0105573 <default_check+0x591>
c010554f:	c7 44 24 0c 09 71 10 	movl   $0xc0107109,0xc(%esp)
c0105556:	c0 
c0105557:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c010555e:	c0 
c010555f:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0105566:	00 
c0105567:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c010556e:	e8 75 ae ff ff       	call   c01003e8 <__panic>
    nr_free = nr_free_store;
c0105573:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105576:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    free_list = free_list_store;
c010557b:	8b 45 80             	mov    -0x80(%ebp),%eax
c010557e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105581:	a3 5c 89 11 c0       	mov    %eax,0xc011895c
c0105586:	89 15 60 89 11 c0    	mov    %edx,0xc0118960
    free_pages(p0, 5);
c010558c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0105593:	00 
c0105594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105597:	89 04 24             	mov    %eax,(%esp)
c010559a:	e8 7e d7 ff ff       	call   c0102d1d <free_pages>

    le = &free_list;
c010559f:	c7 45 ec 5c 89 11 c0 	movl   $0xc011895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01055a6:	eb 1d                	jmp    c01055c5 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01055a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055ab:	83 e8 0c             	sub    $0xc,%eax
c01055ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01055b1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01055b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01055b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01055bb:	8b 40 08             	mov    0x8(%eax),%eax
c01055be:	29 c2                	sub    %eax,%edx
c01055c0:	89 d0                	mov    %edx,%eax
c01055c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01055c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055c8:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c01055cb:	8b 45 88             	mov    -0x78(%ebp),%eax
c01055ce:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01055d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01055d4:	81 7d ec 5c 89 11 c0 	cmpl   $0xc011895c,-0x14(%ebp)
c01055db:	75 cb                	jne    c01055a8 <default_check+0x5c6>
    }
    assert(count == 0);
c01055dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01055e1:	74 24                	je     c0105607 <default_check+0x625>
c01055e3:	c7 44 24 0c 76 72 10 	movl   $0xc0107276,0xc(%esp)
c01055ea:	c0 
c01055eb:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c01055f2:	c0 
c01055f3:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c01055fa:	00 
c01055fb:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c0105602:	e8 e1 ad ff ff       	call   c01003e8 <__panic>
    assert(total == 0);
c0105607:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010560b:	74 24                	je     c0105631 <default_check+0x64f>
c010560d:	c7 44 24 0c 81 72 10 	movl   $0xc0107281,0xc(%esp)
c0105614:	c0 
c0105615:	c7 44 24 08 16 6f 10 	movl   $0xc0106f16,0x8(%esp)
c010561c:	c0 
c010561d:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0105624:	00 
c0105625:	c7 04 24 2b 6f 10 c0 	movl   $0xc0106f2b,(%esp)
c010562c:	e8 b7 ad ff ff       	call   c01003e8 <__panic>
}
c0105631:	81 c4 94 00 00 00    	add    $0x94,%esp
c0105637:	5b                   	pop    %ebx
c0105638:	5d                   	pop    %ebp
c0105639:	c3                   	ret    

c010563a <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010563a:	55                   	push   %ebp
c010563b:	89 e5                	mov    %esp,%ebp
c010563d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105640:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105647:	eb 04                	jmp    c010564d <strlen+0x13>
        cnt ++;
c0105649:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c010564d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105650:	8d 50 01             	lea    0x1(%eax),%edx
c0105653:	89 55 08             	mov    %edx,0x8(%ebp)
c0105656:	0f b6 00             	movzbl (%eax),%eax
c0105659:	84 c0                	test   %al,%al
c010565b:	75 ec                	jne    c0105649 <strlen+0xf>
    }
    return cnt;
c010565d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105660:	c9                   	leave  
c0105661:	c3                   	ret    

c0105662 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105662:	55                   	push   %ebp
c0105663:	89 e5                	mov    %esp,%ebp
c0105665:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105668:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010566f:	eb 04                	jmp    c0105675 <strnlen+0x13>
        cnt ++;
c0105671:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105675:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105678:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010567b:	73 10                	jae    c010568d <strnlen+0x2b>
c010567d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105680:	8d 50 01             	lea    0x1(%eax),%edx
c0105683:	89 55 08             	mov    %edx,0x8(%ebp)
c0105686:	0f b6 00             	movzbl (%eax),%eax
c0105689:	84 c0                	test   %al,%al
c010568b:	75 e4                	jne    c0105671 <strnlen+0xf>
    }
    return cnt;
c010568d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105690:	c9                   	leave  
c0105691:	c3                   	ret    

c0105692 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105692:	55                   	push   %ebp
c0105693:	89 e5                	mov    %esp,%ebp
c0105695:	57                   	push   %edi
c0105696:	56                   	push   %esi
c0105697:	83 ec 20             	sub    $0x20,%esp
c010569a:	8b 45 08             	mov    0x8(%ebp),%eax
c010569d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01056a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01056a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01056a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056ac:	89 d1                	mov    %edx,%ecx
c01056ae:	89 c2                	mov    %eax,%edx
c01056b0:	89 ce                	mov    %ecx,%esi
c01056b2:	89 d7                	mov    %edx,%edi
c01056b4:	ac                   	lods   %ds:(%esi),%al
c01056b5:	aa                   	stos   %al,%es:(%edi)
c01056b6:	84 c0                	test   %al,%al
c01056b8:	75 fa                	jne    c01056b4 <strcpy+0x22>
c01056ba:	89 fa                	mov    %edi,%edx
c01056bc:	89 f1                	mov    %esi,%ecx
c01056be:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01056c1:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01056c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01056c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01056ca:	83 c4 20             	add    $0x20,%esp
c01056cd:	5e                   	pop    %esi
c01056ce:	5f                   	pop    %edi
c01056cf:	5d                   	pop    %ebp
c01056d0:	c3                   	ret    

c01056d1 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01056d1:	55                   	push   %ebp
c01056d2:	89 e5                	mov    %esp,%ebp
c01056d4:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01056d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01056da:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01056dd:	eb 21                	jmp    c0105700 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01056df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056e2:	0f b6 10             	movzbl (%eax),%edx
c01056e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01056e8:	88 10                	mov    %dl,(%eax)
c01056ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01056ed:	0f b6 00             	movzbl (%eax),%eax
c01056f0:	84 c0                	test   %al,%al
c01056f2:	74 04                	je     c01056f8 <strncpy+0x27>
            src ++;
c01056f4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01056f8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01056fc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c0105700:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105704:	75 d9                	jne    c01056df <strncpy+0xe>
    }
    return dst;
c0105706:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105709:	c9                   	leave  
c010570a:	c3                   	ret    

c010570b <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010570b:	55                   	push   %ebp
c010570c:	89 e5                	mov    %esp,%ebp
c010570e:	57                   	push   %edi
c010570f:	56                   	push   %esi
c0105710:	83 ec 20             	sub    $0x20,%esp
c0105713:	8b 45 08             	mov    0x8(%ebp),%eax
c0105716:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105719:	8b 45 0c             	mov    0xc(%ebp),%eax
c010571c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c010571f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105722:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105725:	89 d1                	mov    %edx,%ecx
c0105727:	89 c2                	mov    %eax,%edx
c0105729:	89 ce                	mov    %ecx,%esi
c010572b:	89 d7                	mov    %edx,%edi
c010572d:	ac                   	lods   %ds:(%esi),%al
c010572e:	ae                   	scas   %es:(%edi),%al
c010572f:	75 08                	jne    c0105739 <strcmp+0x2e>
c0105731:	84 c0                	test   %al,%al
c0105733:	75 f8                	jne    c010572d <strcmp+0x22>
c0105735:	31 c0                	xor    %eax,%eax
c0105737:	eb 04                	jmp    c010573d <strcmp+0x32>
c0105739:	19 c0                	sbb    %eax,%eax
c010573b:	0c 01                	or     $0x1,%al
c010573d:	89 fa                	mov    %edi,%edx
c010573f:	89 f1                	mov    %esi,%ecx
c0105741:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105744:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105747:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c010574a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010574d:	83 c4 20             	add    $0x20,%esp
c0105750:	5e                   	pop    %esi
c0105751:	5f                   	pop    %edi
c0105752:	5d                   	pop    %ebp
c0105753:	c3                   	ret    

c0105754 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105754:	55                   	push   %ebp
c0105755:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105757:	eb 0c                	jmp    c0105765 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105759:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010575d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105761:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105765:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105769:	74 1a                	je     c0105785 <strncmp+0x31>
c010576b:	8b 45 08             	mov    0x8(%ebp),%eax
c010576e:	0f b6 00             	movzbl (%eax),%eax
c0105771:	84 c0                	test   %al,%al
c0105773:	74 10                	je     c0105785 <strncmp+0x31>
c0105775:	8b 45 08             	mov    0x8(%ebp),%eax
c0105778:	0f b6 10             	movzbl (%eax),%edx
c010577b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010577e:	0f b6 00             	movzbl (%eax),%eax
c0105781:	38 c2                	cmp    %al,%dl
c0105783:	74 d4                	je     c0105759 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105785:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105789:	74 18                	je     c01057a3 <strncmp+0x4f>
c010578b:	8b 45 08             	mov    0x8(%ebp),%eax
c010578e:	0f b6 00             	movzbl (%eax),%eax
c0105791:	0f b6 d0             	movzbl %al,%edx
c0105794:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105797:	0f b6 00             	movzbl (%eax),%eax
c010579a:	0f b6 c0             	movzbl %al,%eax
c010579d:	29 c2                	sub    %eax,%edx
c010579f:	89 d0                	mov    %edx,%eax
c01057a1:	eb 05                	jmp    c01057a8 <strncmp+0x54>
c01057a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01057a8:	5d                   	pop    %ebp
c01057a9:	c3                   	ret    

c01057aa <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01057aa:	55                   	push   %ebp
c01057ab:	89 e5                	mov    %esp,%ebp
c01057ad:	83 ec 04             	sub    $0x4,%esp
c01057b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057b3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01057b6:	eb 14                	jmp    c01057cc <strchr+0x22>
        if (*s == c) {
c01057b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01057bb:	0f b6 00             	movzbl (%eax),%eax
c01057be:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01057c1:	75 05                	jne    c01057c8 <strchr+0x1e>
            return (char *)s;
c01057c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c6:	eb 13                	jmp    c01057db <strchr+0x31>
        }
        s ++;
c01057c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c01057cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01057cf:	0f b6 00             	movzbl (%eax),%eax
c01057d2:	84 c0                	test   %al,%al
c01057d4:	75 e2                	jne    c01057b8 <strchr+0xe>
    }
    return NULL;
c01057d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01057db:	c9                   	leave  
c01057dc:	c3                   	ret    

c01057dd <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01057dd:	55                   	push   %ebp
c01057de:	89 e5                	mov    %esp,%ebp
c01057e0:	83 ec 04             	sub    $0x4,%esp
c01057e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057e6:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01057e9:	eb 11                	jmp    c01057fc <strfind+0x1f>
        if (*s == c) {
c01057eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ee:	0f b6 00             	movzbl (%eax),%eax
c01057f1:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01057f4:	75 02                	jne    c01057f8 <strfind+0x1b>
            break;
c01057f6:	eb 0e                	jmp    c0105806 <strfind+0x29>
        }
        s ++;
c01057f8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c01057fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ff:	0f b6 00             	movzbl (%eax),%eax
c0105802:	84 c0                	test   %al,%al
c0105804:	75 e5                	jne    c01057eb <strfind+0xe>
    }
    return (char *)s;
c0105806:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105809:	c9                   	leave  
c010580a:	c3                   	ret    

c010580b <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010580b:	55                   	push   %ebp
c010580c:	89 e5                	mov    %esp,%ebp
c010580e:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105811:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105818:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010581f:	eb 04                	jmp    c0105825 <strtol+0x1a>
        s ++;
c0105821:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105825:	8b 45 08             	mov    0x8(%ebp),%eax
c0105828:	0f b6 00             	movzbl (%eax),%eax
c010582b:	3c 20                	cmp    $0x20,%al
c010582d:	74 f2                	je     c0105821 <strtol+0x16>
c010582f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105832:	0f b6 00             	movzbl (%eax),%eax
c0105835:	3c 09                	cmp    $0x9,%al
c0105837:	74 e8                	je     c0105821 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105839:	8b 45 08             	mov    0x8(%ebp),%eax
c010583c:	0f b6 00             	movzbl (%eax),%eax
c010583f:	3c 2b                	cmp    $0x2b,%al
c0105841:	75 06                	jne    c0105849 <strtol+0x3e>
        s ++;
c0105843:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105847:	eb 15                	jmp    c010585e <strtol+0x53>
    }
    else if (*s == '-') {
c0105849:	8b 45 08             	mov    0x8(%ebp),%eax
c010584c:	0f b6 00             	movzbl (%eax),%eax
c010584f:	3c 2d                	cmp    $0x2d,%al
c0105851:	75 0b                	jne    c010585e <strtol+0x53>
        s ++, neg = 1;
c0105853:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105857:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010585e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105862:	74 06                	je     c010586a <strtol+0x5f>
c0105864:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105868:	75 24                	jne    c010588e <strtol+0x83>
c010586a:	8b 45 08             	mov    0x8(%ebp),%eax
c010586d:	0f b6 00             	movzbl (%eax),%eax
c0105870:	3c 30                	cmp    $0x30,%al
c0105872:	75 1a                	jne    c010588e <strtol+0x83>
c0105874:	8b 45 08             	mov    0x8(%ebp),%eax
c0105877:	83 c0 01             	add    $0x1,%eax
c010587a:	0f b6 00             	movzbl (%eax),%eax
c010587d:	3c 78                	cmp    $0x78,%al
c010587f:	75 0d                	jne    c010588e <strtol+0x83>
        s += 2, base = 16;
c0105881:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105885:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010588c:	eb 2a                	jmp    c01058b8 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010588e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105892:	75 17                	jne    c01058ab <strtol+0xa0>
c0105894:	8b 45 08             	mov    0x8(%ebp),%eax
c0105897:	0f b6 00             	movzbl (%eax),%eax
c010589a:	3c 30                	cmp    $0x30,%al
c010589c:	75 0d                	jne    c01058ab <strtol+0xa0>
        s ++, base = 8;
c010589e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01058a2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01058a9:	eb 0d                	jmp    c01058b8 <strtol+0xad>
    }
    else if (base == 0) {
c01058ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01058af:	75 07                	jne    c01058b8 <strtol+0xad>
        base = 10;
c01058b1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01058b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01058bb:	0f b6 00             	movzbl (%eax),%eax
c01058be:	3c 2f                	cmp    $0x2f,%al
c01058c0:	7e 1b                	jle    c01058dd <strtol+0xd2>
c01058c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01058c5:	0f b6 00             	movzbl (%eax),%eax
c01058c8:	3c 39                	cmp    $0x39,%al
c01058ca:	7f 11                	jg     c01058dd <strtol+0xd2>
            dig = *s - '0';
c01058cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01058cf:	0f b6 00             	movzbl (%eax),%eax
c01058d2:	0f be c0             	movsbl %al,%eax
c01058d5:	83 e8 30             	sub    $0x30,%eax
c01058d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01058db:	eb 48                	jmp    c0105925 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01058dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e0:	0f b6 00             	movzbl (%eax),%eax
c01058e3:	3c 60                	cmp    $0x60,%al
c01058e5:	7e 1b                	jle    c0105902 <strtol+0xf7>
c01058e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ea:	0f b6 00             	movzbl (%eax),%eax
c01058ed:	3c 7a                	cmp    $0x7a,%al
c01058ef:	7f 11                	jg     c0105902 <strtol+0xf7>
            dig = *s - 'a' + 10;
c01058f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f4:	0f b6 00             	movzbl (%eax),%eax
c01058f7:	0f be c0             	movsbl %al,%eax
c01058fa:	83 e8 57             	sub    $0x57,%eax
c01058fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105900:	eb 23                	jmp    c0105925 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105902:	8b 45 08             	mov    0x8(%ebp),%eax
c0105905:	0f b6 00             	movzbl (%eax),%eax
c0105908:	3c 40                	cmp    $0x40,%al
c010590a:	7e 3d                	jle    c0105949 <strtol+0x13e>
c010590c:	8b 45 08             	mov    0x8(%ebp),%eax
c010590f:	0f b6 00             	movzbl (%eax),%eax
c0105912:	3c 5a                	cmp    $0x5a,%al
c0105914:	7f 33                	jg     c0105949 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105916:	8b 45 08             	mov    0x8(%ebp),%eax
c0105919:	0f b6 00             	movzbl (%eax),%eax
c010591c:	0f be c0             	movsbl %al,%eax
c010591f:	83 e8 37             	sub    $0x37,%eax
c0105922:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105925:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105928:	3b 45 10             	cmp    0x10(%ebp),%eax
c010592b:	7c 02                	jl     c010592f <strtol+0x124>
            break;
c010592d:	eb 1a                	jmp    c0105949 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c010592f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105933:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105936:	0f af 45 10          	imul   0x10(%ebp),%eax
c010593a:	89 c2                	mov    %eax,%edx
c010593c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010593f:	01 d0                	add    %edx,%eax
c0105941:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105944:	e9 6f ff ff ff       	jmp    c01058b8 <strtol+0xad>

    if (endptr) {
c0105949:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010594d:	74 08                	je     c0105957 <strtol+0x14c>
        *endptr = (char *) s;
c010594f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105952:	8b 55 08             	mov    0x8(%ebp),%edx
c0105955:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105957:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010595b:	74 07                	je     c0105964 <strtol+0x159>
c010595d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105960:	f7 d8                	neg    %eax
c0105962:	eb 03                	jmp    c0105967 <strtol+0x15c>
c0105964:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105967:	c9                   	leave  
c0105968:	c3                   	ret    

c0105969 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105969:	55                   	push   %ebp
c010596a:	89 e5                	mov    %esp,%ebp
c010596c:	57                   	push   %edi
c010596d:	83 ec 24             	sub    $0x24,%esp
c0105970:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105973:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105976:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c010597a:	8b 55 08             	mov    0x8(%ebp),%edx
c010597d:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105980:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105983:	8b 45 10             	mov    0x10(%ebp),%eax
c0105986:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105989:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010598c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105990:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105993:	89 d7                	mov    %edx,%edi
c0105995:	f3 aa                	rep stos %al,%es:(%edi)
c0105997:	89 fa                	mov    %edi,%edx
c0105999:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010599c:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010599f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01059a2:	83 c4 24             	add    $0x24,%esp
c01059a5:	5f                   	pop    %edi
c01059a6:	5d                   	pop    %ebp
c01059a7:	c3                   	ret    

c01059a8 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01059a8:	55                   	push   %ebp
c01059a9:	89 e5                	mov    %esp,%ebp
c01059ab:	57                   	push   %edi
c01059ac:	56                   	push   %esi
c01059ad:	53                   	push   %ebx
c01059ae:	83 ec 30             	sub    $0x30,%esp
c01059b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01059bd:	8b 45 10             	mov    0x10(%ebp),%eax
c01059c0:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01059c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059c6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01059c9:	73 42                	jae    c0105a0d <memmove+0x65>
c01059cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01059d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01059d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059da:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01059dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01059e0:	c1 e8 02             	shr    $0x2,%eax
c01059e3:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01059e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01059e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059eb:	89 d7                	mov    %edx,%edi
c01059ed:	89 c6                	mov    %eax,%esi
c01059ef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01059f1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01059f4:	83 e1 03             	and    $0x3,%ecx
c01059f7:	74 02                	je     c01059fb <memmove+0x53>
c01059f9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01059fb:	89 f0                	mov    %esi,%eax
c01059fd:	89 fa                	mov    %edi,%edx
c01059ff:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105a02:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105a05:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105a08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a0b:	eb 36                	jmp    c0105a43 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a10:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a16:	01 c2                	add    %eax,%edx
c0105a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a1b:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a21:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a27:	89 c1                	mov    %eax,%ecx
c0105a29:	89 d8                	mov    %ebx,%eax
c0105a2b:	89 d6                	mov    %edx,%esi
c0105a2d:	89 c7                	mov    %eax,%edi
c0105a2f:	fd                   	std    
c0105a30:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105a32:	fc                   	cld    
c0105a33:	89 f8                	mov    %edi,%eax
c0105a35:	89 f2                	mov    %esi,%edx
c0105a37:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105a3a:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105a3d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105a43:	83 c4 30             	add    $0x30,%esp
c0105a46:	5b                   	pop    %ebx
c0105a47:	5e                   	pop    %esi
c0105a48:	5f                   	pop    %edi
c0105a49:	5d                   	pop    %ebp
c0105a4a:	c3                   	ret    

c0105a4b <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105a4b:	55                   	push   %ebp
c0105a4c:	89 e5                	mov    %esp,%ebp
c0105a4e:	57                   	push   %edi
c0105a4f:	56                   	push   %esi
c0105a50:	83 ec 20             	sub    $0x20,%esp
c0105a53:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a59:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a5f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a62:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a68:	c1 e8 02             	shr    $0x2,%eax
c0105a6b:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a73:	89 d7                	mov    %edx,%edi
c0105a75:	89 c6                	mov    %eax,%esi
c0105a77:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105a79:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105a7c:	83 e1 03             	and    $0x3,%ecx
c0105a7f:	74 02                	je     c0105a83 <memcpy+0x38>
c0105a81:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105a83:	89 f0                	mov    %esi,%eax
c0105a85:	89 fa                	mov    %edi,%edx
c0105a87:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105a8a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105a8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105a93:	83 c4 20             	add    $0x20,%esp
c0105a96:	5e                   	pop    %esi
c0105a97:	5f                   	pop    %edi
c0105a98:	5d                   	pop    %ebp
c0105a99:	c3                   	ret    

c0105a9a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105a9a:	55                   	push   %ebp
c0105a9b:	89 e5                	mov    %esp,%ebp
c0105a9d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105aa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105aac:	eb 30                	jmp    c0105ade <memcmp+0x44>
        if (*s1 != *s2) {
c0105aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ab1:	0f b6 10             	movzbl (%eax),%edx
c0105ab4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105ab7:	0f b6 00             	movzbl (%eax),%eax
c0105aba:	38 c2                	cmp    %al,%dl
c0105abc:	74 18                	je     c0105ad6 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105abe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ac1:	0f b6 00             	movzbl (%eax),%eax
c0105ac4:	0f b6 d0             	movzbl %al,%edx
c0105ac7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105aca:	0f b6 00             	movzbl (%eax),%eax
c0105acd:	0f b6 c0             	movzbl %al,%eax
c0105ad0:	29 c2                	sub    %eax,%edx
c0105ad2:	89 d0                	mov    %edx,%eax
c0105ad4:	eb 1a                	jmp    c0105af0 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105ad6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105ada:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c0105ade:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ae1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ae4:	89 55 10             	mov    %edx,0x10(%ebp)
c0105ae7:	85 c0                	test   %eax,%eax
c0105ae9:	75 c3                	jne    c0105aae <memcmp+0x14>
    }
    return 0;
c0105aeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105af0:	c9                   	leave  
c0105af1:	c3                   	ret    

c0105af2 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105af2:	55                   	push   %ebp
c0105af3:	89 e5                	mov    %esp,%ebp
c0105af5:	83 ec 58             	sub    $0x58,%esp
c0105af8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105afb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105afe:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b01:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105b04:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105b07:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105b0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105b0d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105b10:	8b 45 18             	mov    0x18(%ebp),%eax
c0105b13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105b16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b19:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105b1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105b1f:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105b2c:	74 1c                	je     c0105b4a <printnum+0x58>
c0105b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b31:	ba 00 00 00 00       	mov    $0x0,%edx
c0105b36:	f7 75 e4             	divl   -0x1c(%ebp)
c0105b39:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b3f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105b44:	f7 75 e4             	divl   -0x1c(%ebp)
c0105b47:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b50:	f7 75 e4             	divl   -0x1c(%ebp)
c0105b53:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105b56:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105b59:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105b62:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105b65:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b68:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105b6b:	8b 45 18             	mov    0x18(%ebp),%eax
c0105b6e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105b73:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105b76:	77 56                	ja     c0105bce <printnum+0xdc>
c0105b78:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105b7b:	72 05                	jb     c0105b82 <printnum+0x90>
c0105b7d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105b80:	77 4c                	ja     c0105bce <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105b82:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105b85:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105b88:	8b 45 20             	mov    0x20(%ebp),%eax
c0105b8b:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105b8f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105b93:	8b 45 18             	mov    0x18(%ebp),%eax
c0105b96:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105b9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105ba0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ba4:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105baf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb2:	89 04 24             	mov    %eax,(%esp)
c0105bb5:	e8 38 ff ff ff       	call   c0105af2 <printnum>
c0105bba:	eb 1c                	jmp    c0105bd8 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bc3:	8b 45 20             	mov    0x20(%ebp),%eax
c0105bc6:	89 04 24             	mov    %eax,(%esp)
c0105bc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bcc:	ff d0                	call   *%eax
        while (-- width > 0)
c0105bce:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105bd2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105bd6:	7f e4                	jg     c0105bbc <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105bd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105bdb:	05 3c 73 10 c0       	add    $0xc010733c,%eax
c0105be0:	0f b6 00             	movzbl (%eax),%eax
c0105be3:	0f be c0             	movsbl %al,%eax
c0105be6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105be9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105bed:	89 04 24             	mov    %eax,(%esp)
c0105bf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf3:	ff d0                	call   *%eax
}
c0105bf5:	c9                   	leave  
c0105bf6:	c3                   	ret    

c0105bf7 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105bf7:	55                   	push   %ebp
c0105bf8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105bfa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105bfe:	7e 14                	jle    c0105c14 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105c00:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c03:	8b 00                	mov    (%eax),%eax
c0105c05:	8d 48 08             	lea    0x8(%eax),%ecx
c0105c08:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c0b:	89 0a                	mov    %ecx,(%edx)
c0105c0d:	8b 50 04             	mov    0x4(%eax),%edx
c0105c10:	8b 00                	mov    (%eax),%eax
c0105c12:	eb 30                	jmp    c0105c44 <getuint+0x4d>
    }
    else if (lflag) {
c0105c14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105c18:	74 16                	je     c0105c30 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1d:	8b 00                	mov    (%eax),%eax
c0105c1f:	8d 48 04             	lea    0x4(%eax),%ecx
c0105c22:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c25:	89 0a                	mov    %ecx,(%edx)
c0105c27:	8b 00                	mov    (%eax),%eax
c0105c29:	ba 00 00 00 00       	mov    $0x0,%edx
c0105c2e:	eb 14                	jmp    c0105c44 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c33:	8b 00                	mov    (%eax),%eax
c0105c35:	8d 48 04             	lea    0x4(%eax),%ecx
c0105c38:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c3b:	89 0a                	mov    %ecx,(%edx)
c0105c3d:	8b 00                	mov    (%eax),%eax
c0105c3f:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105c44:	5d                   	pop    %ebp
c0105c45:	c3                   	ret    

c0105c46 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105c46:	55                   	push   %ebp
c0105c47:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105c49:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105c4d:	7e 14                	jle    c0105c63 <getint+0x1d>
        return va_arg(*ap, long long);
c0105c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c52:	8b 00                	mov    (%eax),%eax
c0105c54:	8d 48 08             	lea    0x8(%eax),%ecx
c0105c57:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c5a:	89 0a                	mov    %ecx,(%edx)
c0105c5c:	8b 50 04             	mov    0x4(%eax),%edx
c0105c5f:	8b 00                	mov    (%eax),%eax
c0105c61:	eb 28                	jmp    c0105c8b <getint+0x45>
    }
    else if (lflag) {
c0105c63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105c67:	74 12                	je     c0105c7b <getint+0x35>
        return va_arg(*ap, long);
c0105c69:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c6c:	8b 00                	mov    (%eax),%eax
c0105c6e:	8d 48 04             	lea    0x4(%eax),%ecx
c0105c71:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c74:	89 0a                	mov    %ecx,(%edx)
c0105c76:	8b 00                	mov    (%eax),%eax
c0105c78:	99                   	cltd   
c0105c79:	eb 10                	jmp    c0105c8b <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105c7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c7e:	8b 00                	mov    (%eax),%eax
c0105c80:	8d 48 04             	lea    0x4(%eax),%ecx
c0105c83:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c86:	89 0a                	mov    %ecx,(%edx)
c0105c88:	8b 00                	mov    (%eax),%eax
c0105c8a:	99                   	cltd   
    }
}
c0105c8b:	5d                   	pop    %ebp
c0105c8c:	c3                   	ret    

c0105c8d <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105c8d:	55                   	push   %ebp
c0105c8e:	89 e5                	mov    %esp,%ebp
c0105c90:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105c93:	8d 45 14             	lea    0x14(%ebp),%eax
c0105c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c9c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ca0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ca3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105caa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cae:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb1:	89 04 24             	mov    %eax,(%esp)
c0105cb4:	e8 02 00 00 00       	call   c0105cbb <vprintfmt>
    va_end(ap);
}
c0105cb9:	c9                   	leave  
c0105cba:	c3                   	ret    

c0105cbb <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105cbb:	55                   	push   %ebp
c0105cbc:	89 e5                	mov    %esp,%ebp
c0105cbe:	56                   	push   %esi
c0105cbf:	53                   	push   %ebx
c0105cc0:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105cc3:	eb 18                	jmp    c0105cdd <vprintfmt+0x22>
            if (ch == '\0') {
c0105cc5:	85 db                	test   %ebx,%ebx
c0105cc7:	75 05                	jne    c0105cce <vprintfmt+0x13>
                return;
c0105cc9:	e9 d1 03 00 00       	jmp    c010609f <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105cce:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cd5:	89 1c 24             	mov    %ebx,(%esp)
c0105cd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cdb:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105cdd:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ce0:	8d 50 01             	lea    0x1(%eax),%edx
c0105ce3:	89 55 10             	mov    %edx,0x10(%ebp)
c0105ce6:	0f b6 00             	movzbl (%eax),%eax
c0105ce9:	0f b6 d8             	movzbl %al,%ebx
c0105cec:	83 fb 25             	cmp    $0x25,%ebx
c0105cef:	75 d4                	jne    c0105cc5 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105cf1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105cf5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105cfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105cff:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105d02:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105d09:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105d0c:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105d0f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d12:	8d 50 01             	lea    0x1(%eax),%edx
c0105d15:	89 55 10             	mov    %edx,0x10(%ebp)
c0105d18:	0f b6 00             	movzbl (%eax),%eax
c0105d1b:	0f b6 d8             	movzbl %al,%ebx
c0105d1e:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105d21:	83 f8 55             	cmp    $0x55,%eax
c0105d24:	0f 87 44 03 00 00    	ja     c010606e <vprintfmt+0x3b3>
c0105d2a:	8b 04 85 60 73 10 c0 	mov    -0x3fef8ca0(,%eax,4),%eax
c0105d31:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105d33:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105d37:	eb d6                	jmp    c0105d0f <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105d39:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105d3d:	eb d0                	jmp    c0105d0f <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105d3f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105d46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105d49:	89 d0                	mov    %edx,%eax
c0105d4b:	c1 e0 02             	shl    $0x2,%eax
c0105d4e:	01 d0                	add    %edx,%eax
c0105d50:	01 c0                	add    %eax,%eax
c0105d52:	01 d8                	add    %ebx,%eax
c0105d54:	83 e8 30             	sub    $0x30,%eax
c0105d57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105d5a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d5d:	0f b6 00             	movzbl (%eax),%eax
c0105d60:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105d63:	83 fb 2f             	cmp    $0x2f,%ebx
c0105d66:	7e 0b                	jle    c0105d73 <vprintfmt+0xb8>
c0105d68:	83 fb 39             	cmp    $0x39,%ebx
c0105d6b:	7f 06                	jg     c0105d73 <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
c0105d6d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
c0105d71:	eb d3                	jmp    c0105d46 <vprintfmt+0x8b>
            goto process_precision;
c0105d73:	eb 33                	jmp    c0105da8 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0105d75:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d78:	8d 50 04             	lea    0x4(%eax),%edx
c0105d7b:	89 55 14             	mov    %edx,0x14(%ebp)
c0105d7e:	8b 00                	mov    (%eax),%eax
c0105d80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105d83:	eb 23                	jmp    c0105da8 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105d85:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105d89:	79 0c                	jns    c0105d97 <vprintfmt+0xdc>
                width = 0;
c0105d8b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105d92:	e9 78 ff ff ff       	jmp    c0105d0f <vprintfmt+0x54>
c0105d97:	e9 73 ff ff ff       	jmp    c0105d0f <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0105d9c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105da3:	e9 67 ff ff ff       	jmp    c0105d0f <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105da8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105dac:	79 12                	jns    c0105dc0 <vprintfmt+0x105>
                width = precision, precision = -1;
c0105dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105db1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105db4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105dbb:	e9 4f ff ff ff       	jmp    c0105d0f <vprintfmt+0x54>
c0105dc0:	e9 4a ff ff ff       	jmp    c0105d0f <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105dc5:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105dc9:	e9 41 ff ff ff       	jmp    c0105d0f <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105dce:	8b 45 14             	mov    0x14(%ebp),%eax
c0105dd1:	8d 50 04             	lea    0x4(%eax),%edx
c0105dd4:	89 55 14             	mov    %edx,0x14(%ebp)
c0105dd7:	8b 00                	mov    (%eax),%eax
c0105dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105ddc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105de0:	89 04 24             	mov    %eax,(%esp)
c0105de3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de6:	ff d0                	call   *%eax
            break;
c0105de8:	e9 ac 02 00 00       	jmp    c0106099 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105ded:	8b 45 14             	mov    0x14(%ebp),%eax
c0105df0:	8d 50 04             	lea    0x4(%eax),%edx
c0105df3:	89 55 14             	mov    %edx,0x14(%ebp)
c0105df6:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105df8:	85 db                	test   %ebx,%ebx
c0105dfa:	79 02                	jns    c0105dfe <vprintfmt+0x143>
                err = -err;
c0105dfc:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105dfe:	83 fb 06             	cmp    $0x6,%ebx
c0105e01:	7f 0b                	jg     c0105e0e <vprintfmt+0x153>
c0105e03:	8b 34 9d 20 73 10 c0 	mov    -0x3fef8ce0(,%ebx,4),%esi
c0105e0a:	85 f6                	test   %esi,%esi
c0105e0c:	75 23                	jne    c0105e31 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105e0e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105e12:	c7 44 24 08 4d 73 10 	movl   $0xc010734d,0x8(%esp)
c0105e19:	c0 
c0105e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e21:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e24:	89 04 24             	mov    %eax,(%esp)
c0105e27:	e8 61 fe ff ff       	call   c0105c8d <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105e2c:	e9 68 02 00 00       	jmp    c0106099 <vprintfmt+0x3de>
                printfmt(putch, putdat, "%s", p);
c0105e31:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105e35:	c7 44 24 08 56 73 10 	movl   $0xc0107356,0x8(%esp)
c0105e3c:	c0 
c0105e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e47:	89 04 24             	mov    %eax,(%esp)
c0105e4a:	e8 3e fe ff ff       	call   c0105c8d <printfmt>
            break;
c0105e4f:	e9 45 02 00 00       	jmp    c0106099 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105e54:	8b 45 14             	mov    0x14(%ebp),%eax
c0105e57:	8d 50 04             	lea    0x4(%eax),%edx
c0105e5a:	89 55 14             	mov    %edx,0x14(%ebp)
c0105e5d:	8b 30                	mov    (%eax),%esi
c0105e5f:	85 f6                	test   %esi,%esi
c0105e61:	75 05                	jne    c0105e68 <vprintfmt+0x1ad>
                p = "(null)";
c0105e63:	be 59 73 10 c0       	mov    $0xc0107359,%esi
            }
            if (width > 0 && padc != '-') {
c0105e68:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105e6c:	7e 3e                	jle    c0105eac <vprintfmt+0x1f1>
c0105e6e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105e72:	74 38                	je     c0105eac <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105e74:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e7a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e7e:	89 34 24             	mov    %esi,(%esp)
c0105e81:	e8 dc f7 ff ff       	call   c0105662 <strnlen>
c0105e86:	29 c3                	sub    %eax,%ebx
c0105e88:	89 d8                	mov    %ebx,%eax
c0105e8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105e8d:	eb 17                	jmp    c0105ea6 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0105e8f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105e93:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105e96:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e9a:	89 04 24             	mov    %eax,(%esp)
c0105e9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ea0:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105ea2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105ea6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105eaa:	7f e3                	jg     c0105e8f <vprintfmt+0x1d4>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105eac:	eb 38                	jmp    c0105ee6 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105eae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105eb2:	74 1f                	je     c0105ed3 <vprintfmt+0x218>
c0105eb4:	83 fb 1f             	cmp    $0x1f,%ebx
c0105eb7:	7e 05                	jle    c0105ebe <vprintfmt+0x203>
c0105eb9:	83 fb 7e             	cmp    $0x7e,%ebx
c0105ebc:	7e 15                	jle    c0105ed3 <vprintfmt+0x218>
                    putch('?', putdat);
c0105ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ec1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ec5:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105ecc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ecf:	ff d0                	call   *%eax
c0105ed1:	eb 0f                	jmp    c0105ee2 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ed6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105eda:	89 1c 24             	mov    %ebx,(%esp)
c0105edd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ee0:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105ee2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105ee6:	89 f0                	mov    %esi,%eax
c0105ee8:	8d 70 01             	lea    0x1(%eax),%esi
c0105eeb:	0f b6 00             	movzbl (%eax),%eax
c0105eee:	0f be d8             	movsbl %al,%ebx
c0105ef1:	85 db                	test   %ebx,%ebx
c0105ef3:	74 10                	je     c0105f05 <vprintfmt+0x24a>
c0105ef5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105ef9:	78 b3                	js     c0105eae <vprintfmt+0x1f3>
c0105efb:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105eff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105f03:	79 a9                	jns    c0105eae <vprintfmt+0x1f3>
                }
            }
            for (; width > 0; width --) {
c0105f05:	eb 17                	jmp    c0105f1e <vprintfmt+0x263>
                putch(' ', putdat);
c0105f07:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f0e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105f15:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f18:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105f1a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105f1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105f22:	7f e3                	jg     c0105f07 <vprintfmt+0x24c>
            }
            break;
c0105f24:	e9 70 01 00 00       	jmp    c0106099 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105f29:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f30:	8d 45 14             	lea    0x14(%ebp),%eax
c0105f33:	89 04 24             	mov    %eax,(%esp)
c0105f36:	e8 0b fd ff ff       	call   c0105c46 <getint>
c0105f3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f44:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f47:	85 d2                	test   %edx,%edx
c0105f49:	79 26                	jns    c0105f71 <vprintfmt+0x2b6>
                putch('-', putdat);
c0105f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f52:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105f59:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f5c:	ff d0                	call   *%eax
                num = -(long long)num;
c0105f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f61:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f64:	f7 d8                	neg    %eax
c0105f66:	83 d2 00             	adc    $0x0,%edx
c0105f69:	f7 da                	neg    %edx
c0105f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f6e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105f71:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105f78:	e9 a8 00 00 00       	jmp    c0106025 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105f7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f80:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f84:	8d 45 14             	lea    0x14(%ebp),%eax
c0105f87:	89 04 24             	mov    %eax,(%esp)
c0105f8a:	e8 68 fc ff ff       	call   c0105bf7 <getuint>
c0105f8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f92:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105f95:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105f9c:	e9 84 00 00 00       	jmp    c0106025 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105fa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105fa4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fa8:	8d 45 14             	lea    0x14(%ebp),%eax
c0105fab:	89 04 24             	mov    %eax,(%esp)
c0105fae:	e8 44 fc ff ff       	call   c0105bf7 <getuint>
c0105fb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105fb9:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105fc0:	eb 63                	jmp    c0106025 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fc9:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105fd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fd3:	ff d0                	call   *%eax
            putch('x', putdat);
c0105fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fdc:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105fe3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fe6:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105fe8:	8b 45 14             	mov    0x14(%ebp),%eax
c0105feb:	8d 50 04             	lea    0x4(%eax),%edx
c0105fee:	89 55 14             	mov    %edx,0x14(%ebp)
c0105ff1:	8b 00                	mov    (%eax),%eax
c0105ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ff6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105ffd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0106004:	eb 1f                	jmp    c0106025 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0106006:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106009:	89 44 24 04          	mov    %eax,0x4(%esp)
c010600d:	8d 45 14             	lea    0x14(%ebp),%eax
c0106010:	89 04 24             	mov    %eax,(%esp)
c0106013:	e8 df fb ff ff       	call   c0105bf7 <getuint>
c0106018:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010601b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010601e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0106025:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0106029:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010602c:	89 54 24 18          	mov    %edx,0x18(%esp)
c0106030:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106033:	89 54 24 14          	mov    %edx,0x14(%esp)
c0106037:	89 44 24 10          	mov    %eax,0x10(%esp)
c010603b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010603e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106041:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106045:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106049:	8b 45 0c             	mov    0xc(%ebp),%eax
c010604c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106050:	8b 45 08             	mov    0x8(%ebp),%eax
c0106053:	89 04 24             	mov    %eax,(%esp)
c0106056:	e8 97 fa ff ff       	call   c0105af2 <printnum>
            break;
c010605b:	eb 3c                	jmp    c0106099 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010605d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106060:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106064:	89 1c 24             	mov    %ebx,(%esp)
c0106067:	8b 45 08             	mov    0x8(%ebp),%eax
c010606a:	ff d0                	call   *%eax
            break;
c010606c:	eb 2b                	jmp    c0106099 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010606e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106075:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010607c:	8b 45 08             	mov    0x8(%ebp),%eax
c010607f:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0106081:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106085:	eb 04                	jmp    c010608b <vprintfmt+0x3d0>
c0106087:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010608b:	8b 45 10             	mov    0x10(%ebp),%eax
c010608e:	83 e8 01             	sub    $0x1,%eax
c0106091:	0f b6 00             	movzbl (%eax),%eax
c0106094:	3c 25                	cmp    $0x25,%al
c0106096:	75 ef                	jne    c0106087 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0106098:	90                   	nop
        }
    }
c0106099:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010609a:	e9 3e fc ff ff       	jmp    c0105cdd <vprintfmt+0x22>
}
c010609f:	83 c4 40             	add    $0x40,%esp
c01060a2:	5b                   	pop    %ebx
c01060a3:	5e                   	pop    %esi
c01060a4:	5d                   	pop    %ebp
c01060a5:	c3                   	ret    

c01060a6 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01060a6:	55                   	push   %ebp
c01060a7:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01060a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060ac:	8b 40 08             	mov    0x8(%eax),%eax
c01060af:	8d 50 01             	lea    0x1(%eax),%edx
c01060b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060b5:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01060b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060bb:	8b 10                	mov    (%eax),%edx
c01060bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060c0:	8b 40 04             	mov    0x4(%eax),%eax
c01060c3:	39 c2                	cmp    %eax,%edx
c01060c5:	73 12                	jae    c01060d9 <sprintputch+0x33>
        *b->buf ++ = ch;
c01060c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060ca:	8b 00                	mov    (%eax),%eax
c01060cc:	8d 48 01             	lea    0x1(%eax),%ecx
c01060cf:	8b 55 0c             	mov    0xc(%ebp),%edx
c01060d2:	89 0a                	mov    %ecx,(%edx)
c01060d4:	8b 55 08             	mov    0x8(%ebp),%edx
c01060d7:	88 10                	mov    %dl,(%eax)
    }
}
c01060d9:	5d                   	pop    %ebp
c01060da:	c3                   	ret    

c01060db <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01060db:	55                   	push   %ebp
c01060dc:	89 e5                	mov    %esp,%ebp
c01060de:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01060e1:	8d 45 14             	lea    0x14(%ebp),%eax
c01060e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01060e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01060ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01060f1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01060f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01060ff:	89 04 24             	mov    %eax,(%esp)
c0106102:	e8 08 00 00 00       	call   c010610f <vsnprintf>
c0106107:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010610a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010610d:	c9                   	leave  
c010610e:	c3                   	ret    

c010610f <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010610f:	55                   	push   %ebp
c0106110:	89 e5                	mov    %esp,%ebp
c0106112:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0106115:	8b 45 08             	mov    0x8(%ebp),%eax
c0106118:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010611b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010611e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106121:	8b 45 08             	mov    0x8(%ebp),%eax
c0106124:	01 d0                	add    %edx,%eax
c0106126:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106129:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0106130:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106134:	74 0a                	je     c0106140 <vsnprintf+0x31>
c0106136:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106139:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010613c:	39 c2                	cmp    %eax,%edx
c010613e:	76 07                	jbe    c0106147 <vsnprintf+0x38>
        return -E_INVAL;
c0106140:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0106145:	eb 2a                	jmp    c0106171 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0106147:	8b 45 14             	mov    0x14(%ebp),%eax
c010614a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010614e:	8b 45 10             	mov    0x10(%ebp),%eax
c0106151:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106155:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0106158:	89 44 24 04          	mov    %eax,0x4(%esp)
c010615c:	c7 04 24 a6 60 10 c0 	movl   $0xc01060a6,(%esp)
c0106163:	e8 53 fb ff ff       	call   c0105cbb <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0106168:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010616b:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010616e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106171:	c9                   	leave  
c0106172:	c3                   	ret    
