
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 13 59 00 00       	call   105969 <memset>

    cons_init();                // init the console
  100056:	e8 83 15 00 00       	call   1015de <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 80 61 10 00 	movl   $0x106180,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 9c 61 10 00 	movl   $0x10619c,(%esp)
  100070:	e8 1c 02 00 00       	call   100291 <cprintf>

    print_kerninfo();
  100075:	e8 bd 08 00 00       	call   100937 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 71 32 00 00       	call   1032f5 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 b2 16 00 00       	call   10173b <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 36 18 00 00       	call   1018c4 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 01 0d 00 00       	call   100d94 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 de 17 00 00       	call   101876 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 c6 0c 00 00       	call   100d82 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 a1 61 10 00 	movl   $0x1061a1,(%esp)
  10015c:	e8 30 01 00 00       	call   100291 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 af 61 10 00 	movl   $0x1061af,(%esp)
  10017c:	e8 10 01 00 00       	call   100291 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 bd 61 10 00 	movl   $0x1061bd,(%esp)
  10019c:	e8 f0 00 00 00       	call   100291 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 cb 61 10 00 	movl   $0x1061cb,(%esp)
  1001bc:	e8 d0 00 00 00       	call   100291 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 d9 61 10 00 	movl   $0x1061d9,(%esp)
  1001dc:	e8 b0 00 00 00       	call   100291 <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile(
  1001f3:	83 ec 08             	sub    $0x8,%esp
  1001f6:	cd 78                	int    $0x78
  1001f8:	89 ec                	mov    %ebp,%esp
		"int %0 \n"//调用 T_SWITCH_TOU 中断
		"movl %%ebp,%%esp"//恢复栈指针
		:
		: "i"(T_SWITCH_TOU)
	);
}
  1001fa:	5d                   	pop    %ebp
  1001fb:	c3                   	ret    

001001fc <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001fc:	55                   	push   %ebp
  1001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	//把tf->tf_cs和tf->tf_ds都设置为内核代码段和内核数据段
	asm volatile(
  1001ff:	cd 79                	int    $0x79
  100201:	89 ec                	mov    %ebp,%esp
		"int %0 \n"// //调用T_SWITCH_TOK号中断
		"movl %%ebp, %%esp \n"//强行改为内核态，会让cpu认为没有发生特权级转换，%esp的值就不对了
		:
		: "i"(T_SWITCH_TOK)
	);
}
  100203:	5d                   	pop    %ebp
  100204:	c3                   	ret    

00100205 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100205:	55                   	push   %ebp
  100206:	89 e5                	mov    %esp,%ebp
  100208:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10020b:	e8 1a ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100210:	c7 04 24 e8 61 10 00 	movl   $0x1061e8,(%esp)
  100217:	e8 75 00 00 00       	call   100291 <cprintf>
    lab1_switch_to_user();
  10021c:	e8 cf ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100221:	e8 04 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100226:	c7 04 24 08 62 10 00 	movl   $0x106208,(%esp)
  10022d:	e8 5f 00 00 00       	call   100291 <cprintf>
    lab1_switch_to_kernel();
  100232:	e8 c5 ff ff ff       	call   1001fc <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100237:	e8 ee fe ff ff       	call   10012a <lab1_print_cur_status>
}
  10023c:	c9                   	leave  
  10023d:	c3                   	ret    

0010023e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10023e:	55                   	push   %ebp
  10023f:	89 e5                	mov    %esp,%ebp
  100241:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100244:	8b 45 08             	mov    0x8(%ebp),%eax
  100247:	89 04 24             	mov    %eax,(%esp)
  10024a:	e8 bb 13 00 00       	call   10160a <cons_putc>
    (*cnt) ++;
  10024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100252:	8b 00                	mov    (%eax),%eax
  100254:	8d 50 01             	lea    0x1(%eax),%edx
  100257:	8b 45 0c             	mov    0xc(%ebp),%eax
  10025a:	89 10                	mov    %edx,(%eax)
}
  10025c:	c9                   	leave  
  10025d:	c3                   	ret    

0010025e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10025e:	55                   	push   %ebp
  10025f:	89 e5                	mov    %esp,%ebp
  100261:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100264:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10026b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10026e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100272:	8b 45 08             	mov    0x8(%ebp),%eax
  100275:	89 44 24 08          	mov    %eax,0x8(%esp)
  100279:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10027c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100280:	c7 04 24 3e 02 10 00 	movl   $0x10023e,(%esp)
  100287:	e8 2f 5a 00 00       	call   105cbb <vprintfmt>
    return cnt;
  10028c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10028f:	c9                   	leave  
  100290:	c3                   	ret    

00100291 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100291:	55                   	push   %ebp
  100292:	89 e5                	mov    %esp,%ebp
  100294:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100297:	8d 45 0c             	lea    0xc(%ebp),%eax
  10029a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10029d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a7:	89 04 24             	mov    %eax,(%esp)
  1002aa:	e8 af ff ff ff       	call   10025e <vcprintf>
  1002af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002b5:	c9                   	leave  
  1002b6:	c3                   	ret    

001002b7 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002b7:	55                   	push   %ebp
  1002b8:	89 e5                	mov    %esp,%ebp
  1002ba:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c0:	89 04 24             	mov    %eax,(%esp)
  1002c3:	e8 42 13 00 00       	call   10160a <cons_putc>
}
  1002c8:	c9                   	leave  
  1002c9:	c3                   	ret    

001002ca <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002ca:	55                   	push   %ebp
  1002cb:	89 e5                	mov    %esp,%ebp
  1002cd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002d7:	eb 13                	jmp    1002ec <cputs+0x22>
        cputch(c, &cnt);
  1002d9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002dd:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002e4:	89 04 24             	mov    %eax,(%esp)
  1002e7:	e8 52 ff ff ff       	call   10023e <cputch>
    while ((c = *str ++) != '\0') {
  1002ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ef:	8d 50 01             	lea    0x1(%eax),%edx
  1002f2:	89 55 08             	mov    %edx,0x8(%ebp)
  1002f5:	0f b6 00             	movzbl (%eax),%eax
  1002f8:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002fb:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002ff:	75 d8                	jne    1002d9 <cputs+0xf>
    }
    cputch('\n', &cnt);
  100301:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100304:	89 44 24 04          	mov    %eax,0x4(%esp)
  100308:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10030f:	e8 2a ff ff ff       	call   10023e <cputch>
    return cnt;
  100314:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100317:	c9                   	leave  
  100318:	c3                   	ret    

00100319 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100319:	55                   	push   %ebp
  10031a:	89 e5                	mov    %esp,%ebp
  10031c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  10031f:	e8 22 13 00 00       	call   101646 <cons_getc>
  100324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100327:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10032b:	74 f2                	je     10031f <getchar+0x6>
        /* do nothing */;
    return c;
  10032d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100330:	c9                   	leave  
  100331:	c3                   	ret    

00100332 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100332:	55                   	push   %ebp
  100333:	89 e5                	mov    %esp,%ebp
  100335:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100338:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10033c:	74 13                	je     100351 <readline+0x1f>
        cprintf("%s", prompt);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 44 24 04          	mov    %eax,0x4(%esp)
  100345:	c7 04 24 27 62 10 00 	movl   $0x106227,(%esp)
  10034c:	e8 40 ff ff ff       	call   100291 <cprintf>
    }
    int i = 0, c;
  100351:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100358:	e8 bc ff ff ff       	call   100319 <getchar>
  10035d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100360:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100364:	79 07                	jns    10036d <readline+0x3b>
            return NULL;
  100366:	b8 00 00 00 00       	mov    $0x0,%eax
  10036b:	eb 79                	jmp    1003e6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10036d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100371:	7e 28                	jle    10039b <readline+0x69>
  100373:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10037a:	7f 1f                	jg     10039b <readline+0x69>
            cputchar(c);
  10037c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10037f:	89 04 24             	mov    %eax,(%esp)
  100382:	e8 30 ff ff ff       	call   1002b7 <cputchar>
            buf[i ++] = c;
  100387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10038a:	8d 50 01             	lea    0x1(%eax),%edx
  10038d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100390:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100393:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  100399:	eb 46                	jmp    1003e1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10039b:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10039f:	75 17                	jne    1003b8 <readline+0x86>
  1003a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003a5:	7e 11                	jle    1003b8 <readline+0x86>
            cputchar(c);
  1003a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003aa:	89 04 24             	mov    %eax,(%esp)
  1003ad:	e8 05 ff ff ff       	call   1002b7 <cputchar>
            i --;
  1003b2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1003b6:	eb 29                	jmp    1003e1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1003b8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003bc:	74 06                	je     1003c4 <readline+0x92>
  1003be:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003c2:	75 1d                	jne    1003e1 <readline+0xaf>
            cputchar(c);
  1003c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c7:	89 04 24             	mov    %eax,(%esp)
  1003ca:	e8 e8 fe ff ff       	call   1002b7 <cputchar>
            buf[i] = '\0';
  1003cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003d2:	05 60 7a 11 00       	add    $0x117a60,%eax
  1003d7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003da:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1003df:	eb 05                	jmp    1003e6 <readline+0xb4>
        }
    }
  1003e1:	e9 72 ff ff ff       	jmp    100358 <readline+0x26>
}
  1003e6:	c9                   	leave  
  1003e7:	c3                   	ret    

001003e8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003e8:	55                   	push   %ebp
  1003e9:	89 e5                	mov    %esp,%ebp
  1003eb:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003ee:	a1 60 7e 11 00       	mov    0x117e60,%eax
  1003f3:	85 c0                	test   %eax,%eax
  1003f5:	74 02                	je     1003f9 <__panic+0x11>
        goto panic_dead;
  1003f7:	eb 48                	jmp    100441 <__panic+0x59>
    }
    is_panic = 1;
  1003f9:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100400:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100403:	8d 45 14             	lea    0x14(%ebp),%eax
  100406:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100409:	8b 45 0c             	mov    0xc(%ebp),%eax
  10040c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100410:	8b 45 08             	mov    0x8(%ebp),%eax
  100413:	89 44 24 04          	mov    %eax,0x4(%esp)
  100417:	c7 04 24 2a 62 10 00 	movl   $0x10622a,(%esp)
  10041e:	e8 6e fe ff ff       	call   100291 <cprintf>
    vcprintf(fmt, ap);
  100423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100426:	89 44 24 04          	mov    %eax,0x4(%esp)
  10042a:	8b 45 10             	mov    0x10(%ebp),%eax
  10042d:	89 04 24             	mov    %eax,(%esp)
  100430:	e8 29 fe ff ff       	call   10025e <vcprintf>
    cprintf("\n");
  100435:	c7 04 24 46 62 10 00 	movl   $0x106246,(%esp)
  10043c:	e8 50 fe ff ff       	call   100291 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100441:	e8 36 14 00 00       	call   10187c <intr_disable>
    while (1) {
        kmonitor(NULL);
  100446:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10044d:	e8 61 08 00 00       	call   100cb3 <kmonitor>
    }
  100452:	eb f2                	jmp    100446 <__panic+0x5e>

00100454 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100454:	55                   	push   %ebp
  100455:	89 e5                	mov    %esp,%ebp
  100457:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10045a:	8d 45 14             	lea    0x14(%ebp),%eax
  10045d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100460:	8b 45 0c             	mov    0xc(%ebp),%eax
  100463:	89 44 24 08          	mov    %eax,0x8(%esp)
  100467:	8b 45 08             	mov    0x8(%ebp),%eax
  10046a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10046e:	c7 04 24 48 62 10 00 	movl   $0x106248,(%esp)
  100475:	e8 17 fe ff ff       	call   100291 <cprintf>
    vcprintf(fmt, ap);
  10047a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10047d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100481:	8b 45 10             	mov    0x10(%ebp),%eax
  100484:	89 04 24             	mov    %eax,(%esp)
  100487:	e8 d2 fd ff ff       	call   10025e <vcprintf>
    cprintf("\n");
  10048c:	c7 04 24 46 62 10 00 	movl   $0x106246,(%esp)
  100493:	e8 f9 fd ff ff       	call   100291 <cprintf>
    va_end(ap);
}
  100498:	c9                   	leave  
  100499:	c3                   	ret    

0010049a <is_kernel_panic>:

bool
is_kernel_panic(void) {
  10049a:	55                   	push   %ebp
  10049b:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10049d:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  1004a2:	5d                   	pop    %ebp
  1004a3:	c3                   	ret    

001004a4 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004a4:	55                   	push   %ebp
  1004a5:	89 e5                	mov    %esp,%ebp
  1004a7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ad:	8b 00                	mov    (%eax),%eax
  1004af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b5:	8b 00                	mov    (%eax),%eax
  1004b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004c1:	e9 d2 00 00 00       	jmp    100598 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004cc:	01 d0                	add    %edx,%eax
  1004ce:	89 c2                	mov    %eax,%edx
  1004d0:	c1 ea 1f             	shr    $0x1f,%edx
  1004d3:	01 d0                	add    %edx,%eax
  1004d5:	d1 f8                	sar    %eax
  1004d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004dd:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004e0:	eb 04                	jmp    1004e6 <stab_binsearch+0x42>
            m --;
  1004e2:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ec:	7c 1f                	jl     10050d <stab_binsearch+0x69>
  1004ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004f1:	89 d0                	mov    %edx,%eax
  1004f3:	01 c0                	add    %eax,%eax
  1004f5:	01 d0                	add    %edx,%eax
  1004f7:	c1 e0 02             	shl    $0x2,%eax
  1004fa:	89 c2                	mov    %eax,%edx
  1004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ff:	01 d0                	add    %edx,%eax
  100501:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100505:	0f b6 c0             	movzbl %al,%eax
  100508:	3b 45 14             	cmp    0x14(%ebp),%eax
  10050b:	75 d5                	jne    1004e2 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  10050d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100510:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100513:	7d 0b                	jge    100520 <stab_binsearch+0x7c>
            l = true_m + 1;
  100515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100518:	83 c0 01             	add    $0x1,%eax
  10051b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10051e:	eb 78                	jmp    100598 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100520:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100527:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10052a:	89 d0                	mov    %edx,%eax
  10052c:	01 c0                	add    %eax,%eax
  10052e:	01 d0                	add    %edx,%eax
  100530:	c1 e0 02             	shl    $0x2,%eax
  100533:	89 c2                	mov    %eax,%edx
  100535:	8b 45 08             	mov    0x8(%ebp),%eax
  100538:	01 d0                	add    %edx,%eax
  10053a:	8b 40 08             	mov    0x8(%eax),%eax
  10053d:	3b 45 18             	cmp    0x18(%ebp),%eax
  100540:	73 13                	jae    100555 <stab_binsearch+0xb1>
            *region_left = m;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100548:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10054a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10054d:	83 c0 01             	add    $0x1,%eax
  100550:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100553:	eb 43                	jmp    100598 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100555:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100558:	89 d0                	mov    %edx,%eax
  10055a:	01 c0                	add    %eax,%eax
  10055c:	01 d0                	add    %edx,%eax
  10055e:	c1 e0 02             	shl    $0x2,%eax
  100561:	89 c2                	mov    %eax,%edx
  100563:	8b 45 08             	mov    0x8(%ebp),%eax
  100566:	01 d0                	add    %edx,%eax
  100568:	8b 40 08             	mov    0x8(%eax),%eax
  10056b:	3b 45 18             	cmp    0x18(%ebp),%eax
  10056e:	76 16                	jbe    100586 <stab_binsearch+0xe2>
            *region_right = m - 1;
  100570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100573:	8d 50 ff             	lea    -0x1(%eax),%edx
  100576:	8b 45 10             	mov    0x10(%ebp),%eax
  100579:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10057b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10057e:	83 e8 01             	sub    $0x1,%eax
  100581:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100584:	eb 12                	jmp    100598 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100586:	8b 45 0c             	mov    0xc(%ebp),%eax
  100589:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058c:	89 10                	mov    %edx,(%eax)
            l = m;
  10058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100591:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100594:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  100598:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10059b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10059e:	0f 8e 22 ff ff ff    	jle    1004c6 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1005a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005a8:	75 0f                	jne    1005b9 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ad:	8b 00                	mov    (%eax),%eax
  1005af:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1005b5:	89 10                	mov    %edx,(%eax)
  1005b7:	eb 3f                	jmp    1005f8 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005b9:	8b 45 10             	mov    0x10(%ebp),%eax
  1005bc:	8b 00                	mov    (%eax),%eax
  1005be:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005c1:	eb 04                	jmp    1005c7 <stab_binsearch+0x123>
  1005c3:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ca:	8b 00                	mov    (%eax),%eax
  1005cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005cf:	7d 1f                	jge    1005f0 <stab_binsearch+0x14c>
  1005d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005d4:	89 d0                	mov    %edx,%eax
  1005d6:	01 c0                	add    %eax,%eax
  1005d8:	01 d0                	add    %edx,%eax
  1005da:	c1 e0 02             	shl    $0x2,%eax
  1005dd:	89 c2                	mov    %eax,%edx
  1005df:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e2:	01 d0                	add    %edx,%eax
  1005e4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005e8:	0f b6 c0             	movzbl %al,%eax
  1005eb:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005ee:	75 d3                	jne    1005c3 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005f6:	89 10                	mov    %edx,(%eax)
    }
}
  1005f8:	c9                   	leave  
  1005f9:	c3                   	ret    

001005fa <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005fa:	55                   	push   %ebp
  1005fb:	89 e5                	mov    %esp,%ebp
  1005fd:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100600:	8b 45 0c             	mov    0xc(%ebp),%eax
  100603:	c7 00 68 62 10 00    	movl   $0x106268,(%eax)
    info->eip_line = 0;
  100609:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100613:	8b 45 0c             	mov    0xc(%ebp),%eax
  100616:	c7 40 08 68 62 10 00 	movl   $0x106268,0x8(%eax)
    info->eip_fn_namelen = 9;
  10061d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100620:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100627:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062a:	8b 55 08             	mov    0x8(%ebp),%edx
  10062d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100630:	8b 45 0c             	mov    0xc(%ebp),%eax
  100633:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10063a:	c7 45 f4 b8 74 10 00 	movl   $0x1074b8,-0xc(%ebp)
    stab_end = __STAB_END__;
  100641:	c7 45 f0 e0 21 11 00 	movl   $0x1121e0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100648:	c7 45 ec e1 21 11 00 	movl   $0x1121e1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10064f:	c7 45 e8 26 4c 11 00 	movl   $0x114c26,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100659:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10065c:	76 0d                	jbe    10066b <debuginfo_eip+0x71>
  10065e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100661:	83 e8 01             	sub    $0x1,%eax
  100664:	0f b6 00             	movzbl (%eax),%eax
  100667:	84 c0                	test   %al,%al
  100669:	74 0a                	je     100675 <debuginfo_eip+0x7b>
        return -1;
  10066b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100670:	e9 c0 02 00 00       	jmp    100935 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100675:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10067c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10067f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100682:	29 c2                	sub    %eax,%edx
  100684:	89 d0                	mov    %edx,%eax
  100686:	c1 f8 02             	sar    $0x2,%eax
  100689:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10068f:	83 e8 01             	sub    $0x1,%eax
  100692:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100695:	8b 45 08             	mov    0x8(%ebp),%eax
  100698:	89 44 24 10          	mov    %eax,0x10(%esp)
  10069c:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006a3:	00 
  1006a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006b5:	89 04 24             	mov    %eax,(%esp)
  1006b8:	e8 e7 fd ff ff       	call   1004a4 <stab_binsearch>
    if (lfile == 0)
  1006bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006c0:	85 c0                	test   %eax,%eax
  1006c2:	75 0a                	jne    1006ce <debuginfo_eip+0xd4>
        return -1;
  1006c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006c9:	e9 67 02 00 00       	jmp    100935 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006da:	8b 45 08             	mov    0x8(%ebp),%eax
  1006dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006e1:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006e8:	00 
  1006e9:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006f0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006fa:	89 04 24             	mov    %eax,(%esp)
  1006fd:	e8 a2 fd ff ff       	call   1004a4 <stab_binsearch>

    if (lfun <= rfun) {
  100702:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100705:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100708:	39 c2                	cmp    %eax,%edx
  10070a:	7f 7c                	jg     100788 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10070c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10070f:	89 c2                	mov    %eax,%edx
  100711:	89 d0                	mov    %edx,%eax
  100713:	01 c0                	add    %eax,%eax
  100715:	01 d0                	add    %edx,%eax
  100717:	c1 e0 02             	shl    $0x2,%eax
  10071a:	89 c2                	mov    %eax,%edx
  10071c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071f:	01 d0                	add    %edx,%eax
  100721:	8b 10                	mov    (%eax),%edx
  100723:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100726:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100729:	29 c1                	sub    %eax,%ecx
  10072b:	89 c8                	mov    %ecx,%eax
  10072d:	39 c2                	cmp    %eax,%edx
  10072f:	73 22                	jae    100753 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100731:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100734:	89 c2                	mov    %eax,%edx
  100736:	89 d0                	mov    %edx,%eax
  100738:	01 c0                	add    %eax,%eax
  10073a:	01 d0                	add    %edx,%eax
  10073c:	c1 e0 02             	shl    $0x2,%eax
  10073f:	89 c2                	mov    %eax,%edx
  100741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100744:	01 d0                	add    %edx,%eax
  100746:	8b 10                	mov    (%eax),%edx
  100748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10074b:	01 c2                	add    %eax,%edx
  10074d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100750:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100753:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100756:	89 c2                	mov    %eax,%edx
  100758:	89 d0                	mov    %edx,%eax
  10075a:	01 c0                	add    %eax,%eax
  10075c:	01 d0                	add    %edx,%eax
  10075e:	c1 e0 02             	shl    $0x2,%eax
  100761:	89 c2                	mov    %eax,%edx
  100763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100766:	01 d0                	add    %edx,%eax
  100768:	8b 50 08             	mov    0x8(%eax),%edx
  10076b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076e:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100771:	8b 45 0c             	mov    0xc(%ebp),%eax
  100774:	8b 40 10             	mov    0x10(%eax),%eax
  100777:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10077a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10077d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100780:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100783:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100786:	eb 15                	jmp    10079d <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100788:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078b:	8b 55 08             	mov    0x8(%ebp),%edx
  10078e:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100791:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100794:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10079a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10079d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a0:	8b 40 08             	mov    0x8(%eax),%eax
  1007a3:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007aa:	00 
  1007ab:	89 04 24             	mov    %eax,(%esp)
  1007ae:	e8 2a 50 00 00       	call   1057dd <strfind>
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b8:	8b 40 08             	mov    0x8(%eax),%eax
  1007bb:	29 c2                	sub    %eax,%edx
  1007bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c0:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1007c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007ca:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007d1:	00 
  1007d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007d9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e3:	89 04 24             	mov    %eax,(%esp)
  1007e6:	e8 b9 fc ff ff       	call   1004a4 <stab_binsearch>
    if (lline <= rline) {
  1007eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7f 24                	jg     100819 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  1007f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007f8:	89 c2                	mov    %eax,%edx
  1007fa:	89 d0                	mov    %edx,%eax
  1007fc:	01 c0                	add    %eax,%eax
  1007fe:	01 d0                	add    %edx,%eax
  100800:	c1 e0 02             	shl    $0x2,%eax
  100803:	89 c2                	mov    %eax,%edx
  100805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100808:	01 d0                	add    %edx,%eax
  10080a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10080e:	0f b7 d0             	movzwl %ax,%edx
  100811:	8b 45 0c             	mov    0xc(%ebp),%eax
  100814:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100817:	eb 13                	jmp    10082c <debuginfo_eip+0x232>
        return -1;
  100819:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10081e:	e9 12 01 00 00       	jmp    100935 <debuginfo_eip+0x33b>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100823:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100826:	83 e8 01             	sub    $0x1,%eax
  100829:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10082c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100832:	39 c2                	cmp    %eax,%edx
  100834:	7c 56                	jl     10088c <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100836:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100839:	89 c2                	mov    %eax,%edx
  10083b:	89 d0                	mov    %edx,%eax
  10083d:	01 c0                	add    %eax,%eax
  10083f:	01 d0                	add    %edx,%eax
  100841:	c1 e0 02             	shl    $0x2,%eax
  100844:	89 c2                	mov    %eax,%edx
  100846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100849:	01 d0                	add    %edx,%eax
  10084b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084f:	3c 84                	cmp    $0x84,%al
  100851:	74 39                	je     10088c <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100856:	89 c2                	mov    %eax,%edx
  100858:	89 d0                	mov    %edx,%eax
  10085a:	01 c0                	add    %eax,%eax
  10085c:	01 d0                	add    %edx,%eax
  10085e:	c1 e0 02             	shl    $0x2,%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100866:	01 d0                	add    %edx,%eax
  100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10086c:	3c 64                	cmp    $0x64,%al
  10086e:	75 b3                	jne    100823 <debuginfo_eip+0x229>
  100870:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100873:	89 c2                	mov    %eax,%edx
  100875:	89 d0                	mov    %edx,%eax
  100877:	01 c0                	add    %eax,%eax
  100879:	01 d0                	add    %edx,%eax
  10087b:	c1 e0 02             	shl    $0x2,%eax
  10087e:	89 c2                	mov    %eax,%edx
  100880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100883:	01 d0                	add    %edx,%eax
  100885:	8b 40 08             	mov    0x8(%eax),%eax
  100888:	85 c0                	test   %eax,%eax
  10088a:	74 97                	je     100823 <debuginfo_eip+0x229>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10088c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10088f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100892:	39 c2                	cmp    %eax,%edx
  100894:	7c 46                	jl     1008dc <debuginfo_eip+0x2e2>
  100896:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100899:	89 c2                	mov    %eax,%edx
  10089b:	89 d0                	mov    %edx,%eax
  10089d:	01 c0                	add    %eax,%eax
  10089f:	01 d0                	add    %edx,%eax
  1008a1:	c1 e0 02             	shl    $0x2,%eax
  1008a4:	89 c2                	mov    %eax,%edx
  1008a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a9:	01 d0                	add    %edx,%eax
  1008ab:	8b 10                	mov    (%eax),%edx
  1008ad:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1008b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008b3:	29 c1                	sub    %eax,%ecx
  1008b5:	89 c8                	mov    %ecx,%eax
  1008b7:	39 c2                	cmp    %eax,%edx
  1008b9:	73 21                	jae    1008dc <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008be:	89 c2                	mov    %eax,%edx
  1008c0:	89 d0                	mov    %edx,%eax
  1008c2:	01 c0                	add    %eax,%eax
  1008c4:	01 d0                	add    %edx,%eax
  1008c6:	c1 e0 02             	shl    $0x2,%eax
  1008c9:	89 c2                	mov    %eax,%edx
  1008cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ce:	01 d0                	add    %edx,%eax
  1008d0:	8b 10                	mov    (%eax),%edx
  1008d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008d5:	01 c2                	add    %eax,%edx
  1008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008da:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008e2:	39 c2                	cmp    %eax,%edx
  1008e4:	7d 4a                	jge    100930 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1008e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008e9:	83 c0 01             	add    $0x1,%eax
  1008ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008ef:	eb 18                	jmp    100909 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f4:	8b 40 14             	mov    0x14(%eax),%eax
  1008f7:	8d 50 01             	lea    0x1(%eax),%edx
  1008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008fd:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100900:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100903:	83 c0 01             	add    $0x1,%eax
  100906:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100909:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10090c:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10090f:	39 c2                	cmp    %eax,%edx
  100911:	7d 1d                	jge    100930 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100913:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100916:	89 c2                	mov    %eax,%edx
  100918:	89 d0                	mov    %edx,%eax
  10091a:	01 c0                	add    %eax,%eax
  10091c:	01 d0                	add    %edx,%eax
  10091e:	c1 e0 02             	shl    $0x2,%eax
  100921:	89 c2                	mov    %eax,%edx
  100923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100926:	01 d0                	add    %edx,%eax
  100928:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10092c:	3c a0                	cmp    $0xa0,%al
  10092e:	74 c1                	je     1008f1 <debuginfo_eip+0x2f7>
        }
    }
    return 0;
  100930:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100935:	c9                   	leave  
  100936:	c3                   	ret    

00100937 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100937:	55                   	push   %ebp
  100938:	89 e5                	mov    %esp,%ebp
  10093a:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10093d:	c7 04 24 72 62 10 00 	movl   $0x106272,(%esp)
  100944:	e8 48 f9 ff ff       	call   100291 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100949:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100950:	00 
  100951:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  100958:	e8 34 f9 ff ff       	call   100291 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10095d:	c7 44 24 04 73 61 10 	movl   $0x106173,0x4(%esp)
  100964:	00 
  100965:	c7 04 24 a3 62 10 00 	movl   $0x1062a3,(%esp)
  10096c:	e8 20 f9 ff ff       	call   100291 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100971:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  100978:	00 
  100979:	c7 04 24 bb 62 10 00 	movl   $0x1062bb,(%esp)
  100980:	e8 0c f9 ff ff       	call   100291 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100985:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  10098c:	00 
  10098d:	c7 04 24 d3 62 10 00 	movl   $0x1062d3,(%esp)
  100994:	e8 f8 f8 ff ff       	call   100291 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100999:	b8 68 89 11 00       	mov    $0x118968,%eax
  10099e:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009a4:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1009a9:	29 c2                	sub    %eax,%edx
  1009ab:	89 d0                	mov    %edx,%eax
  1009ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009b3:	85 c0                	test   %eax,%eax
  1009b5:	0f 48 c2             	cmovs  %edx,%eax
  1009b8:	c1 f8 0a             	sar    $0xa,%eax
  1009bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009bf:	c7 04 24 ec 62 10 00 	movl   $0x1062ec,(%esp)
  1009c6:	e8 c6 f8 ff ff       	call   100291 <cprintf>
}
  1009cb:	c9                   	leave  
  1009cc:	c3                   	ret    

001009cd <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009cd:	55                   	push   %ebp
  1009ce:	89 e5                	mov    %esp,%ebp
  1009d0:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009d6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1009e0:	89 04 24             	mov    %eax,(%esp)
  1009e3:	e8 12 fc ff ff       	call   1005fa <debuginfo_eip>
  1009e8:	85 c0                	test   %eax,%eax
  1009ea:	74 15                	je     100a01 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f3:	c7 04 24 16 63 10 00 	movl   $0x106316,(%esp)
  1009fa:	e8 92 f8 ff ff       	call   100291 <cprintf>
  1009ff:	eb 6d                	jmp    100a6e <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a08:	eb 1c                	jmp    100a26 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100a0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a10:	01 d0                	add    %edx,%eax
  100a12:	0f b6 00             	movzbl (%eax),%eax
  100a15:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a1e:	01 ca                	add    %ecx,%edx
  100a20:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100a2c:	7f dc                	jg     100a0a <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
  100a2e:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a37:	01 d0                	add    %edx,%eax
  100a39:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a3f:	8b 55 08             	mov    0x8(%ebp),%edx
  100a42:	89 d1                	mov    %edx,%ecx
  100a44:	29 c1                	sub    %eax,%ecx
  100a46:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a4c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a50:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a56:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a5a:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a62:	c7 04 24 32 63 10 00 	movl   $0x106332,(%esp)
  100a69:	e8 23 f8 ff ff       	call   100291 <cprintf>
    }
}
  100a6e:	c9                   	leave  
  100a6f:	c3                   	ret    

00100a70 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a70:	55                   	push   %ebp
  100a71:	89 e5                	mov    %esp,%ebp
  100a73:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a76:	8b 45 04             	mov    0x4(%ebp),%eax
  100a79:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a7f:	c9                   	leave  
  100a80:	c3                   	ret    

00100a81 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a81:	55                   	push   %ebp
  100a82:	89 e5                	mov    %esp,%ebp
  100a84:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a87:	89 e8                	mov    %ebp,%eax
  100a89:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t v_ebp=read_ebp();
  100a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t v_eip=read_eip();
  100a92:	e8 d9 ff ff ff       	call   100a70 <read_eip>
  100a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	for(i=0;i<STACKFRAME_DEPTH&&v_ebp!=0;++i)
  100a9a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100aa1:	e9 8f 00 00 00       	jmp    100b35 <print_stackframe+0xb4>
	{
		cprintf("ebp: 0x%08x , eip: 0x%08x , ",v_ebp,v_eip);
  100aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aa9:	89 44 24 08          	mov    %eax,0x8(%esp)
  100aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab4:	c7 04 24 44 63 10 00 	movl   $0x106344,(%esp)
  100abb:	e8 d1 f7 ff ff       	call   100291 <cprintf>
		uint32_t *args=(uint32_t *)v_ebp +2;
  100ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac3:	83 c0 08             	add    $0x8,%eax
  100ac6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int j;
		for(j=0;j<4;++j)
  100ac9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100ad0:	eb 2c                	jmp    100afe <print_stackframe+0x7d>
		{
			cprintf("args[%d] = 0x%08x   ",j,args[j]);
  100ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ad5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100adc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100adf:	01 d0                	add    %edx,%eax
  100ae1:	8b 00                	mov    (%eax),%eax
  100ae3:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100aea:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aee:	c7 04 24 61 63 10 00 	movl   $0x106361,(%esp)
  100af5:	e8 97 f7 ff ff       	call   100291 <cprintf>
		for(j=0;j<4;++j)
  100afa:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100afe:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b02:	7e ce                	jle    100ad2 <print_stackframe+0x51>
		}
		cprintf("\n");
  100b04:	c7 04 24 76 63 10 00 	movl   $0x106376,(%esp)
  100b0b:	e8 81 f7 ff ff       	call   100291 <cprintf>
		print_debuginfo(v_eip-1);
  100b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b13:	83 e8 01             	sub    $0x1,%eax
  100b16:	89 04 24             	mov    %eax,(%esp)
  100b19:	e8 af fe ff ff       	call   1009cd <print_debuginfo>
		v_eip=((uint32_t *)v_ebp)[1];
  100b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b21:	83 c0 04             	add    $0x4,%eax
  100b24:	8b 00                	mov    (%eax),%eax
  100b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
		v_ebp=((uint32_t *)v_ebp)[0];
  100b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b2c:	8b 00                	mov    (%eax),%eax
  100b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(i=0;i<STACKFRAME_DEPTH&&v_ebp!=0;++i)
  100b31:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100b35:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b39:	7f 0a                	jg     100b45 <print_stackframe+0xc4>
  100b3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b3f:	0f 85 61 ff ff ff    	jne    100aa6 <print_stackframe+0x25>
	}


}
  100b45:	c9                   	leave  
  100b46:	c3                   	ret    

00100b47 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b47:	55                   	push   %ebp
  100b48:	89 e5                	mov    %esp,%ebp
  100b4a:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b54:	eb 0c                	jmp    100b62 <parse+0x1b>
            *buf ++ = '\0';
  100b56:	8b 45 08             	mov    0x8(%ebp),%eax
  100b59:	8d 50 01             	lea    0x1(%eax),%edx
  100b5c:	89 55 08             	mov    %edx,0x8(%ebp)
  100b5f:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b62:	8b 45 08             	mov    0x8(%ebp),%eax
  100b65:	0f b6 00             	movzbl (%eax),%eax
  100b68:	84 c0                	test   %al,%al
  100b6a:	74 1d                	je     100b89 <parse+0x42>
  100b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6f:	0f b6 00             	movzbl (%eax),%eax
  100b72:	0f be c0             	movsbl %al,%eax
  100b75:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b79:	c7 04 24 f8 63 10 00 	movl   $0x1063f8,(%esp)
  100b80:	e8 25 4c 00 00       	call   1057aa <strchr>
  100b85:	85 c0                	test   %eax,%eax
  100b87:	75 cd                	jne    100b56 <parse+0xf>
        }
        if (*buf == '\0') {
  100b89:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8c:	0f b6 00             	movzbl (%eax),%eax
  100b8f:	84 c0                	test   %al,%al
  100b91:	75 02                	jne    100b95 <parse+0x4e>
            break;
  100b93:	eb 67                	jmp    100bfc <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b95:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b99:	75 14                	jne    100baf <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b9b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ba2:	00 
  100ba3:	c7 04 24 fd 63 10 00 	movl   $0x1063fd,(%esp)
  100baa:	e8 e2 f6 ff ff       	call   100291 <cprintf>
        }
        argv[argc ++] = buf;
  100baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb2:	8d 50 01             	lea    0x1(%eax),%edx
  100bb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bb8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bc2:	01 c2                	add    %eax,%edx
  100bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc7:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bc9:	eb 04                	jmp    100bcf <parse+0x88>
            buf ++;
  100bcb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd2:	0f b6 00             	movzbl (%eax),%eax
  100bd5:	84 c0                	test   %al,%al
  100bd7:	74 1d                	je     100bf6 <parse+0xaf>
  100bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bdc:	0f b6 00             	movzbl (%eax),%eax
  100bdf:	0f be c0             	movsbl %al,%eax
  100be2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100be6:	c7 04 24 f8 63 10 00 	movl   $0x1063f8,(%esp)
  100bed:	e8 b8 4b 00 00       	call   1057aa <strchr>
  100bf2:	85 c0                	test   %eax,%eax
  100bf4:	74 d5                	je     100bcb <parse+0x84>
        }
    }
  100bf6:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bf7:	e9 66 ff ff ff       	jmp    100b62 <parse+0x1b>
    return argc;
  100bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bff:	c9                   	leave  
  100c00:	c3                   	ret    

00100c01 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c01:	55                   	push   %ebp
  100c02:	89 e5                	mov    %esp,%ebp
  100c04:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c07:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c11:	89 04 24             	mov    %eax,(%esp)
  100c14:	e8 2e ff ff ff       	call   100b47 <parse>
  100c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c20:	75 0a                	jne    100c2c <runcmd+0x2b>
        return 0;
  100c22:	b8 00 00 00 00       	mov    $0x0,%eax
  100c27:	e9 85 00 00 00       	jmp    100cb1 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c33:	eb 5c                	jmp    100c91 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c35:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3b:	89 d0                	mov    %edx,%eax
  100c3d:	01 c0                	add    %eax,%eax
  100c3f:	01 d0                	add    %edx,%eax
  100c41:	c1 e0 02             	shl    $0x2,%eax
  100c44:	05 20 70 11 00       	add    $0x117020,%eax
  100c49:	8b 00                	mov    (%eax),%eax
  100c4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c4f:	89 04 24             	mov    %eax,(%esp)
  100c52:	e8 b4 4a 00 00       	call   10570b <strcmp>
  100c57:	85 c0                	test   %eax,%eax
  100c59:	75 32                	jne    100c8d <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5e:	89 d0                	mov    %edx,%eax
  100c60:	01 c0                	add    %eax,%eax
  100c62:	01 d0                	add    %edx,%eax
  100c64:	c1 e0 02             	shl    $0x2,%eax
  100c67:	05 20 70 11 00       	add    $0x117020,%eax
  100c6c:	8b 40 08             	mov    0x8(%eax),%eax
  100c6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100c72:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  100c78:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c7c:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100c7f:	83 c2 04             	add    $0x4,%edx
  100c82:	89 54 24 04          	mov    %edx,0x4(%esp)
  100c86:	89 0c 24             	mov    %ecx,(%esp)
  100c89:	ff d0                	call   *%eax
  100c8b:	eb 24                	jmp    100cb1 <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c8d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c94:	83 f8 02             	cmp    $0x2,%eax
  100c97:	76 9c                	jbe    100c35 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c99:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ca0:	c7 04 24 1b 64 10 00 	movl   $0x10641b,(%esp)
  100ca7:	e8 e5 f5 ff ff       	call   100291 <cprintf>
    return 0;
  100cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb1:	c9                   	leave  
  100cb2:	c3                   	ret    

00100cb3 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cb3:	55                   	push   %ebp
  100cb4:	89 e5                	mov    %esp,%ebp
  100cb6:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100cb9:	c7 04 24 34 64 10 00 	movl   $0x106434,(%esp)
  100cc0:	e8 cc f5 ff ff       	call   100291 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cc5:	c7 04 24 5c 64 10 00 	movl   $0x10645c,(%esp)
  100ccc:	e8 c0 f5 ff ff       	call   100291 <cprintf>

    if (tf != NULL) {
  100cd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cd5:	74 0b                	je     100ce2 <kmonitor+0x2f>
        print_trapframe(tf);
  100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  100cda:	89 04 24             	mov    %eax,(%esp)
  100cdd:	e8 1e 0e 00 00       	call   101b00 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100ce2:	c7 04 24 81 64 10 00 	movl   $0x106481,(%esp)
  100ce9:	e8 44 f6 ff ff       	call   100332 <readline>
  100cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cf5:	74 18                	je     100d0f <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  100cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d01:	89 04 24             	mov    %eax,(%esp)
  100d04:	e8 f8 fe ff ff       	call   100c01 <runcmd>
  100d09:	85 c0                	test   %eax,%eax
  100d0b:	79 02                	jns    100d0f <kmonitor+0x5c>
                break;
  100d0d:	eb 02                	jmp    100d11 <kmonitor+0x5e>
            }
        }
    }
  100d0f:	eb d1                	jmp    100ce2 <kmonitor+0x2f>
}
  100d11:	c9                   	leave  
  100d12:	c3                   	ret    

00100d13 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d13:	55                   	push   %ebp
  100d14:	89 e5                	mov    %esp,%ebp
  100d16:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d20:	eb 3f                	jmp    100d61 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d25:	89 d0                	mov    %edx,%eax
  100d27:	01 c0                	add    %eax,%eax
  100d29:	01 d0                	add    %edx,%eax
  100d2b:	c1 e0 02             	shl    $0x2,%eax
  100d2e:	05 20 70 11 00       	add    $0x117020,%eax
  100d33:	8b 48 04             	mov    0x4(%eax),%ecx
  100d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d39:	89 d0                	mov    %edx,%eax
  100d3b:	01 c0                	add    %eax,%eax
  100d3d:	01 d0                	add    %edx,%eax
  100d3f:	c1 e0 02             	shl    $0x2,%eax
  100d42:	05 20 70 11 00       	add    $0x117020,%eax
  100d47:	8b 00                	mov    (%eax),%eax
  100d49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d51:	c7 04 24 85 64 10 00 	movl   $0x106485,(%esp)
  100d58:	e8 34 f5 ff ff       	call   100291 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d5d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d64:	83 f8 02             	cmp    $0x2,%eax
  100d67:	76 b9                	jbe    100d22 <mon_help+0xf>
    }
    return 0;
  100d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d6e:	c9                   	leave  
  100d6f:	c3                   	ret    

00100d70 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d70:	55                   	push   %ebp
  100d71:	89 e5                	mov    %esp,%ebp
  100d73:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d76:	e8 bc fb ff ff       	call   100937 <print_kerninfo>
    return 0;
  100d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d80:	c9                   	leave  
  100d81:	c3                   	ret    

00100d82 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d82:	55                   	push   %ebp
  100d83:	89 e5                	mov    %esp,%ebp
  100d85:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d88:	e8 f4 fc ff ff       	call   100a81 <print_stackframe>
    return 0;
  100d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d92:	c9                   	leave  
  100d93:	c3                   	ret    

00100d94 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d94:	55                   	push   %ebp
  100d95:	89 e5                	mov    %esp,%ebp
  100d97:	83 ec 28             	sub    $0x28,%esp
  100d9a:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100da0:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100da4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100da8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dac:	ee                   	out    %al,(%dx)
  100dad:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100db3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100db7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dbb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dbf:	ee                   	out    %al,(%dx)
  100dc0:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dc6:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dca:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dce:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dd2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dd3:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dda:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100ddd:	c7 04 24 8e 64 10 00 	movl   $0x10648e,(%esp)
  100de4:	e8 a8 f4 ff ff       	call   100291 <cprintf>
    pic_enable(IRQ_TIMER);
  100de9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100df0:	e8 18 09 00 00       	call   10170d <pic_enable>
}
  100df5:	c9                   	leave  
  100df6:	c3                   	ret    

00100df7 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100df7:	55                   	push   %ebp
  100df8:	89 e5                	mov    %esp,%ebp
  100dfa:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dfd:	9c                   	pushf  
  100dfe:	58                   	pop    %eax
  100dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e05:	25 00 02 00 00       	and    $0x200,%eax
  100e0a:	85 c0                	test   %eax,%eax
  100e0c:	74 0c                	je     100e1a <__intr_save+0x23>
        intr_disable();
  100e0e:	e8 69 0a 00 00       	call   10187c <intr_disable>
        return 1;
  100e13:	b8 01 00 00 00       	mov    $0x1,%eax
  100e18:	eb 05                	jmp    100e1f <__intr_save+0x28>
    }
    return 0;
  100e1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e1f:	c9                   	leave  
  100e20:	c3                   	ret    

00100e21 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e21:	55                   	push   %ebp
  100e22:	89 e5                	mov    %esp,%ebp
  100e24:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e2b:	74 05                	je     100e32 <__intr_restore+0x11>
        intr_enable();
  100e2d:	e8 44 0a 00 00       	call   101876 <intr_enable>
    }
}
  100e32:	c9                   	leave  
  100e33:	c3                   	ret    

00100e34 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e34:	55                   	push   %ebp
  100e35:	89 e5                	mov    %esp,%ebp
  100e37:	83 ec 10             	sub    $0x10,%esp
  100e3a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e40:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e44:	89 c2                	mov    %eax,%edx
  100e46:	ec                   	in     (%dx),%al
  100e47:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e4a:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e50:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e54:	89 c2                	mov    %eax,%edx
  100e56:	ec                   	in     (%dx),%al
  100e57:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e5a:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e60:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e64:	89 c2                	mov    %eax,%edx
  100e66:	ec                   	in     (%dx),%al
  100e67:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e6a:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e70:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e74:	89 c2                	mov    %eax,%edx
  100e76:	ec                   	in     (%dx),%al
  100e77:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e7a:	c9                   	leave  
  100e7b:	c3                   	ret    

00100e7c <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e7c:	55                   	push   %ebp
  100e7d:	89 e5                	mov    %esp,%ebp
  100e7f:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e82:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8c:	0f b7 00             	movzwl (%eax),%eax
  100e8f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e96:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9e:	0f b7 00             	movzwl (%eax),%eax
  100ea1:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100ea5:	74 12                	je     100eb9 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ea7:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100eae:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100eb5:	b4 03 
  100eb7:	eb 13                	jmp    100ecc <cga_init+0x50>
    } else {
        *cp = was;
  100eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ebc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ec0:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ec3:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100eca:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ecc:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ed3:	0f b7 c0             	movzwl %ax,%eax
  100ed6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100eda:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ede:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ee2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ee6:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ee7:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100eee:	83 c0 01             	add    $0x1,%eax
  100ef1:	0f b7 c0             	movzwl %ax,%eax
  100ef4:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ef8:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100efc:	89 c2                	mov    %eax,%edx
  100efe:	ec                   	in     (%dx),%al
  100eff:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f02:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f06:	0f b6 c0             	movzbl %al,%eax
  100f09:	c1 e0 08             	shl    $0x8,%eax
  100f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f0f:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f16:	0f b7 c0             	movzwl %ax,%eax
  100f19:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f1d:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f21:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f25:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f29:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f2a:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f31:	83 c0 01             	add    $0x1,%eax
  100f34:	0f b7 c0             	movzwl %ax,%eax
  100f37:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f3b:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f3f:	89 c2                	mov    %eax,%edx
  100f41:	ec                   	in     (%dx),%al
  100f42:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f45:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f49:	0f b6 c0             	movzbl %al,%eax
  100f4c:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f52:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f5a:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f60:	c9                   	leave  
  100f61:	c3                   	ret    

00100f62 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f62:	55                   	push   %ebp
  100f63:	89 e5                	mov    %esp,%ebp
  100f65:	83 ec 48             	sub    $0x48,%esp
  100f68:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f6e:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f72:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f76:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f7a:	ee                   	out    %al,(%dx)
  100f7b:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f81:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f85:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f89:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f8d:	ee                   	out    %al,(%dx)
  100f8e:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f94:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f98:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f9c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fa0:	ee                   	out    %al,(%dx)
  100fa1:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fa7:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fab:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100faf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fb3:	ee                   	out    %al,(%dx)
  100fb4:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fba:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fbe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fc2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fc6:	ee                   	out    %al,(%dx)
  100fc7:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fcd:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fd1:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fd5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fd9:	ee                   	out    %al,(%dx)
  100fda:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fe0:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fe4:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fe8:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fec:	ee                   	out    %al,(%dx)
  100fed:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ff3:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100ff7:	89 c2                	mov    %eax,%edx
  100ff9:	ec                   	in     (%dx),%al
  100ffa:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100ffd:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101001:	3c ff                	cmp    $0xff,%al
  101003:	0f 95 c0             	setne  %al
  101006:	0f b6 c0             	movzbl %al,%eax
  101009:	a3 88 7e 11 00       	mov    %eax,0x117e88
  10100e:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101014:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101018:	89 c2                	mov    %eax,%edx
  10101a:	ec                   	in     (%dx),%al
  10101b:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10101e:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101024:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101028:	89 c2                	mov    %eax,%edx
  10102a:	ec                   	in     (%dx),%al
  10102b:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10102e:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101033:	85 c0                	test   %eax,%eax
  101035:	74 0c                	je     101043 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101037:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10103e:	e8 ca 06 00 00       	call   10170d <pic_enable>
    }
}
  101043:	c9                   	leave  
  101044:	c3                   	ret    

00101045 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101045:	55                   	push   %ebp
  101046:	89 e5                	mov    %esp,%ebp
  101048:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10104b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101052:	eb 09                	jmp    10105d <lpt_putc_sub+0x18>
        delay();
  101054:	e8 db fd ff ff       	call   100e34 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101059:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10105d:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101063:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101067:	89 c2                	mov    %eax,%edx
  101069:	ec                   	in     (%dx),%al
  10106a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10106d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101071:	84 c0                	test   %al,%al
  101073:	78 09                	js     10107e <lpt_putc_sub+0x39>
  101075:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10107c:	7e d6                	jle    101054 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  10107e:	8b 45 08             	mov    0x8(%ebp),%eax
  101081:	0f b6 c0             	movzbl %al,%eax
  101084:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10108a:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10108d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101091:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101095:	ee                   	out    %al,(%dx)
  101096:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10109c:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1010a0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010a4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010a8:	ee                   	out    %al,(%dx)
  1010a9:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010af:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010b3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010b7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010bb:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010bc:	c9                   	leave  
  1010bd:	c3                   	ret    

001010be <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010be:	55                   	push   %ebp
  1010bf:	89 e5                	mov    %esp,%ebp
  1010c1:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010c4:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010c8:	74 0d                	je     1010d7 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1010cd:	89 04 24             	mov    %eax,(%esp)
  1010d0:	e8 70 ff ff ff       	call   101045 <lpt_putc_sub>
  1010d5:	eb 24                	jmp    1010fb <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010d7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010de:	e8 62 ff ff ff       	call   101045 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010e3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010ea:	e8 56 ff ff ff       	call   101045 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010ef:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010f6:	e8 4a ff ff ff       	call   101045 <lpt_putc_sub>
    }
}
  1010fb:	c9                   	leave  
  1010fc:	c3                   	ret    

001010fd <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010fd:	55                   	push   %ebp
  1010fe:	89 e5                	mov    %esp,%ebp
  101100:	53                   	push   %ebx
  101101:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101104:	8b 45 08             	mov    0x8(%ebp),%eax
  101107:	b0 00                	mov    $0x0,%al
  101109:	85 c0                	test   %eax,%eax
  10110b:	75 07                	jne    101114 <cga_putc+0x17>
        c |= 0x0700;
  10110d:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101114:	8b 45 08             	mov    0x8(%ebp),%eax
  101117:	0f b6 c0             	movzbl %al,%eax
  10111a:	83 f8 0a             	cmp    $0xa,%eax
  10111d:	74 4c                	je     10116b <cga_putc+0x6e>
  10111f:	83 f8 0d             	cmp    $0xd,%eax
  101122:	74 57                	je     10117b <cga_putc+0x7e>
  101124:	83 f8 08             	cmp    $0x8,%eax
  101127:	0f 85 88 00 00 00    	jne    1011b5 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  10112d:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101134:	66 85 c0             	test   %ax,%ax
  101137:	74 30                	je     101169 <cga_putc+0x6c>
            crt_pos --;
  101139:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101140:	83 e8 01             	sub    $0x1,%eax
  101143:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101149:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10114e:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101155:	0f b7 d2             	movzwl %dx,%edx
  101158:	01 d2                	add    %edx,%edx
  10115a:	01 c2                	add    %eax,%edx
  10115c:	8b 45 08             	mov    0x8(%ebp),%eax
  10115f:	b0 00                	mov    $0x0,%al
  101161:	83 c8 20             	or     $0x20,%eax
  101164:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101167:	eb 72                	jmp    1011db <cga_putc+0xde>
  101169:	eb 70                	jmp    1011db <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  10116b:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101172:	83 c0 50             	add    $0x50,%eax
  101175:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10117b:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101182:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101189:	0f b7 c1             	movzwl %cx,%eax
  10118c:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101192:	c1 e8 10             	shr    $0x10,%eax
  101195:	89 c2                	mov    %eax,%edx
  101197:	66 c1 ea 06          	shr    $0x6,%dx
  10119b:	89 d0                	mov    %edx,%eax
  10119d:	c1 e0 02             	shl    $0x2,%eax
  1011a0:	01 d0                	add    %edx,%eax
  1011a2:	c1 e0 04             	shl    $0x4,%eax
  1011a5:	29 c1                	sub    %eax,%ecx
  1011a7:	89 ca                	mov    %ecx,%edx
  1011a9:	89 d8                	mov    %ebx,%eax
  1011ab:	29 d0                	sub    %edx,%eax
  1011ad:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011b3:	eb 26                	jmp    1011db <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011b5:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011bb:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011c2:	8d 50 01             	lea    0x1(%eax),%edx
  1011c5:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011cc:	0f b7 c0             	movzwl %ax,%eax
  1011cf:	01 c0                	add    %eax,%eax
  1011d1:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1011d7:	66 89 02             	mov    %ax,(%edx)
        break;
  1011da:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011db:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011e2:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011e6:	76 5b                	jbe    101243 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011e8:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011ed:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011f3:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011f8:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011ff:	00 
  101200:	89 54 24 04          	mov    %edx,0x4(%esp)
  101204:	89 04 24             	mov    %eax,(%esp)
  101207:	e8 9c 47 00 00       	call   1059a8 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10120c:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101213:	eb 15                	jmp    10122a <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101215:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10121a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10121d:	01 d2                	add    %edx,%edx
  10121f:	01 d0                	add    %edx,%eax
  101221:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101226:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10122a:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101231:	7e e2                	jle    101215 <cga_putc+0x118>
        }
        crt_pos -= CRT_COLS;
  101233:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10123a:	83 e8 50             	sub    $0x50,%eax
  10123d:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101243:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10124a:	0f b7 c0             	movzwl %ax,%eax
  10124d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101251:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101255:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101259:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10125d:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10125e:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101265:	66 c1 e8 08          	shr    $0x8,%ax
  101269:	0f b6 c0             	movzbl %al,%eax
  10126c:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101273:	83 c2 01             	add    $0x1,%edx
  101276:	0f b7 d2             	movzwl %dx,%edx
  101279:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10127d:	88 45 ed             	mov    %al,-0x13(%ebp)
  101280:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101284:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101288:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101289:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101290:	0f b7 c0             	movzwl %ax,%eax
  101293:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101297:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10129b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10129f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012a3:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012a4:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1012ab:	0f b6 c0             	movzbl %al,%eax
  1012ae:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012b5:	83 c2 01             	add    $0x1,%edx
  1012b8:	0f b7 d2             	movzwl %dx,%edx
  1012bb:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012bf:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012c2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012c6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012ca:	ee                   	out    %al,(%dx)
}
  1012cb:	83 c4 34             	add    $0x34,%esp
  1012ce:	5b                   	pop    %ebx
  1012cf:	5d                   	pop    %ebp
  1012d0:	c3                   	ret    

001012d1 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012d1:	55                   	push   %ebp
  1012d2:	89 e5                	mov    %esp,%ebp
  1012d4:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012de:	eb 09                	jmp    1012e9 <serial_putc_sub+0x18>
        delay();
  1012e0:	e8 4f fb ff ff       	call   100e34 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012e5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012e9:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012ef:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012f3:	89 c2                	mov    %eax,%edx
  1012f5:	ec                   	in     (%dx),%al
  1012f6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012f9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012fd:	0f b6 c0             	movzbl %al,%eax
  101300:	83 e0 20             	and    $0x20,%eax
  101303:	85 c0                	test   %eax,%eax
  101305:	75 09                	jne    101310 <serial_putc_sub+0x3f>
  101307:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10130e:	7e d0                	jle    1012e0 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101310:	8b 45 08             	mov    0x8(%ebp),%eax
  101313:	0f b6 c0             	movzbl %al,%eax
  101316:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10131c:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10131f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101323:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101327:	ee                   	out    %al,(%dx)
}
  101328:	c9                   	leave  
  101329:	c3                   	ret    

0010132a <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10132a:	55                   	push   %ebp
  10132b:	89 e5                	mov    %esp,%ebp
  10132d:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101330:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101334:	74 0d                	je     101343 <serial_putc+0x19>
        serial_putc_sub(c);
  101336:	8b 45 08             	mov    0x8(%ebp),%eax
  101339:	89 04 24             	mov    %eax,(%esp)
  10133c:	e8 90 ff ff ff       	call   1012d1 <serial_putc_sub>
  101341:	eb 24                	jmp    101367 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101343:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10134a:	e8 82 ff ff ff       	call   1012d1 <serial_putc_sub>
        serial_putc_sub(' ');
  10134f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101356:	e8 76 ff ff ff       	call   1012d1 <serial_putc_sub>
        serial_putc_sub('\b');
  10135b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101362:	e8 6a ff ff ff       	call   1012d1 <serial_putc_sub>
    }
}
  101367:	c9                   	leave  
  101368:	c3                   	ret    

00101369 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101369:	55                   	push   %ebp
  10136a:	89 e5                	mov    %esp,%ebp
  10136c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10136f:	eb 33                	jmp    1013a4 <cons_intr+0x3b>
        if (c != 0) {
  101371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101375:	74 2d                	je     1013a4 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101377:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10137c:	8d 50 01             	lea    0x1(%eax),%edx
  10137f:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101385:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101388:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10138e:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101393:	3d 00 02 00 00       	cmp    $0x200,%eax
  101398:	75 0a                	jne    1013a4 <cons_intr+0x3b>
                cons.wpos = 0;
  10139a:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  1013a1:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1013a7:	ff d0                	call   *%eax
  1013a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013ac:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013b0:	75 bf                	jne    101371 <cons_intr+0x8>
            }
        }
    }
}
  1013b2:	c9                   	leave  
  1013b3:	c3                   	ret    

001013b4 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013b4:	55                   	push   %ebp
  1013b5:	89 e5                	mov    %esp,%ebp
  1013b7:	83 ec 10             	sub    $0x10,%esp
  1013ba:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013c0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013c4:	89 c2                	mov    %eax,%edx
  1013c6:	ec                   	in     (%dx),%al
  1013c7:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013ca:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013ce:	0f b6 c0             	movzbl %al,%eax
  1013d1:	83 e0 01             	and    $0x1,%eax
  1013d4:	85 c0                	test   %eax,%eax
  1013d6:	75 07                	jne    1013df <serial_proc_data+0x2b>
        return -1;
  1013d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013dd:	eb 2a                	jmp    101409 <serial_proc_data+0x55>
  1013df:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013e5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013e9:	89 c2                	mov    %eax,%edx
  1013eb:	ec                   	in     (%dx),%al
  1013ec:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013ef:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013f3:	0f b6 c0             	movzbl %al,%eax
  1013f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013f9:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013fd:	75 07                	jne    101406 <serial_proc_data+0x52>
        c = '\b';
  1013ff:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101406:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101409:	c9                   	leave  
  10140a:	c3                   	ret    

0010140b <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10140b:	55                   	push   %ebp
  10140c:	89 e5                	mov    %esp,%ebp
  10140e:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101411:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101416:	85 c0                	test   %eax,%eax
  101418:	74 0c                	je     101426 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10141a:	c7 04 24 b4 13 10 00 	movl   $0x1013b4,(%esp)
  101421:	e8 43 ff ff ff       	call   101369 <cons_intr>
    }
}
  101426:	c9                   	leave  
  101427:	c3                   	ret    

00101428 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101428:	55                   	push   %ebp
  101429:	89 e5                	mov    %esp,%ebp
  10142b:	83 ec 38             	sub    $0x38,%esp
  10142e:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101434:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101438:	89 c2                	mov    %eax,%edx
  10143a:	ec                   	in     (%dx),%al
  10143b:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10143e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101442:	0f b6 c0             	movzbl %al,%eax
  101445:	83 e0 01             	and    $0x1,%eax
  101448:	85 c0                	test   %eax,%eax
  10144a:	75 0a                	jne    101456 <kbd_proc_data+0x2e>
        return -1;
  10144c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101451:	e9 59 01 00 00       	jmp    1015af <kbd_proc_data+0x187>
  101456:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10145c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101460:	89 c2                	mov    %eax,%edx
  101462:	ec                   	in     (%dx),%al
  101463:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101466:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10146a:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10146d:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101471:	75 17                	jne    10148a <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101473:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101478:	83 c8 40             	or     $0x40,%eax
  10147b:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101480:	b8 00 00 00 00       	mov    $0x0,%eax
  101485:	e9 25 01 00 00       	jmp    1015af <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10148a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148e:	84 c0                	test   %al,%al
  101490:	79 47                	jns    1014d9 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101492:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101497:	83 e0 40             	and    $0x40,%eax
  10149a:	85 c0                	test   %eax,%eax
  10149c:	75 09                	jne    1014a7 <kbd_proc_data+0x7f>
  10149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a2:	83 e0 7f             	and    $0x7f,%eax
  1014a5:	eb 04                	jmp    1014ab <kbd_proc_data+0x83>
  1014a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ab:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014ae:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b2:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014b9:	83 c8 40             	or     $0x40,%eax
  1014bc:	0f b6 c0             	movzbl %al,%eax
  1014bf:	f7 d0                	not    %eax
  1014c1:	89 c2                	mov    %eax,%edx
  1014c3:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014c8:	21 d0                	and    %edx,%eax
  1014ca:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014cf:	b8 00 00 00 00       	mov    $0x0,%eax
  1014d4:	e9 d6 00 00 00       	jmp    1015af <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014d9:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014de:	83 e0 40             	and    $0x40,%eax
  1014e1:	85 c0                	test   %eax,%eax
  1014e3:	74 11                	je     1014f6 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014e5:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014e9:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014ee:	83 e0 bf             	and    $0xffffffbf,%eax
  1014f1:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014f6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014fa:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  101501:	0f b6 d0             	movzbl %al,%edx
  101504:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101509:	09 d0                	or     %edx,%eax
  10150b:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  101510:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101514:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  10151b:	0f b6 d0             	movzbl %al,%edx
  10151e:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101523:	31 d0                	xor    %edx,%eax
  101525:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  10152a:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10152f:	83 e0 03             	and    $0x3,%eax
  101532:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101539:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10153d:	01 d0                	add    %edx,%eax
  10153f:	0f b6 00             	movzbl (%eax),%eax
  101542:	0f b6 c0             	movzbl %al,%eax
  101545:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101548:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10154d:	83 e0 08             	and    $0x8,%eax
  101550:	85 c0                	test   %eax,%eax
  101552:	74 22                	je     101576 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101554:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101558:	7e 0c                	jle    101566 <kbd_proc_data+0x13e>
  10155a:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10155e:	7f 06                	jg     101566 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101560:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101564:	eb 10                	jmp    101576 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101566:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10156a:	7e 0a                	jle    101576 <kbd_proc_data+0x14e>
  10156c:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101570:	7f 04                	jg     101576 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101572:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101576:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10157b:	f7 d0                	not    %eax
  10157d:	83 e0 06             	and    $0x6,%eax
  101580:	85 c0                	test   %eax,%eax
  101582:	75 28                	jne    1015ac <kbd_proc_data+0x184>
  101584:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10158b:	75 1f                	jne    1015ac <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10158d:	c7 04 24 a9 64 10 00 	movl   $0x1064a9,(%esp)
  101594:	e8 f8 ec ff ff       	call   100291 <cprintf>
  101599:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10159f:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015a3:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015a7:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015ab:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015af:	c9                   	leave  
  1015b0:	c3                   	ret    

001015b1 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015b1:	55                   	push   %ebp
  1015b2:	89 e5                	mov    %esp,%ebp
  1015b4:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015b7:	c7 04 24 28 14 10 00 	movl   $0x101428,(%esp)
  1015be:	e8 a6 fd ff ff       	call   101369 <cons_intr>
}
  1015c3:	c9                   	leave  
  1015c4:	c3                   	ret    

001015c5 <kbd_init>:

static void
kbd_init(void) {
  1015c5:	55                   	push   %ebp
  1015c6:	89 e5                	mov    %esp,%ebp
  1015c8:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015cb:	e8 e1 ff ff ff       	call   1015b1 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015d7:	e8 31 01 00 00       	call   10170d <pic_enable>
}
  1015dc:	c9                   	leave  
  1015dd:	c3                   	ret    

001015de <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015de:	55                   	push   %ebp
  1015df:	89 e5                	mov    %esp,%ebp
  1015e1:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015e4:	e8 93 f8 ff ff       	call   100e7c <cga_init>
    serial_init();
  1015e9:	e8 74 f9 ff ff       	call   100f62 <serial_init>
    kbd_init();
  1015ee:	e8 d2 ff ff ff       	call   1015c5 <kbd_init>
    if (!serial_exists) {
  1015f3:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015f8:	85 c0                	test   %eax,%eax
  1015fa:	75 0c                	jne    101608 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015fc:	c7 04 24 b5 64 10 00 	movl   $0x1064b5,(%esp)
  101603:	e8 89 ec ff ff       	call   100291 <cprintf>
    }
}
  101608:	c9                   	leave  
  101609:	c3                   	ret    

0010160a <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10160a:	55                   	push   %ebp
  10160b:	89 e5                	mov    %esp,%ebp
  10160d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101610:	e8 e2 f7 ff ff       	call   100df7 <__intr_save>
  101615:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101618:	8b 45 08             	mov    0x8(%ebp),%eax
  10161b:	89 04 24             	mov    %eax,(%esp)
  10161e:	e8 9b fa ff ff       	call   1010be <lpt_putc>
        cga_putc(c);
  101623:	8b 45 08             	mov    0x8(%ebp),%eax
  101626:	89 04 24             	mov    %eax,(%esp)
  101629:	e8 cf fa ff ff       	call   1010fd <cga_putc>
        serial_putc(c);
  10162e:	8b 45 08             	mov    0x8(%ebp),%eax
  101631:	89 04 24             	mov    %eax,(%esp)
  101634:	e8 f1 fc ff ff       	call   10132a <serial_putc>
    }
    local_intr_restore(intr_flag);
  101639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10163c:	89 04 24             	mov    %eax,(%esp)
  10163f:	e8 dd f7 ff ff       	call   100e21 <__intr_restore>
}
  101644:	c9                   	leave  
  101645:	c3                   	ret    

00101646 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101646:	55                   	push   %ebp
  101647:	89 e5                	mov    %esp,%ebp
  101649:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10164c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101653:	e8 9f f7 ff ff       	call   100df7 <__intr_save>
  101658:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10165b:	e8 ab fd ff ff       	call   10140b <serial_intr>
        kbd_intr();
  101660:	e8 4c ff ff ff       	call   1015b1 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101665:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  10166b:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101670:	39 c2                	cmp    %eax,%edx
  101672:	74 31                	je     1016a5 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101674:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101679:	8d 50 01             	lea    0x1(%eax),%edx
  10167c:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101682:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101689:	0f b6 c0             	movzbl %al,%eax
  10168c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10168f:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101694:	3d 00 02 00 00       	cmp    $0x200,%eax
  101699:	75 0a                	jne    1016a5 <cons_getc+0x5f>
                cons.rpos = 0;
  10169b:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  1016a2:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016a8:	89 04 24             	mov    %eax,(%esp)
  1016ab:	e8 71 f7 ff ff       	call   100e21 <__intr_restore>
    return c;
  1016b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016b3:	c9                   	leave  
  1016b4:	c3                   	ret    

001016b5 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016b5:	55                   	push   %ebp
  1016b6:	89 e5                	mov    %esp,%ebp
  1016b8:	83 ec 14             	sub    $0x14,%esp
  1016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1016be:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c6:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016cc:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016d1:	85 c0                	test   %eax,%eax
  1016d3:	74 36                	je     10170b <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016d5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d9:	0f b6 c0             	movzbl %al,%eax
  1016dc:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e2:	88 45 fd             	mov    %al,-0x3(%ebp)
  1016e5:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e9:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ed:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016ee:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f2:	66 c1 e8 08          	shr    $0x8,%ax
  1016f6:	0f b6 c0             	movzbl %al,%eax
  1016f9:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016ff:	88 45 f9             	mov    %al,-0x7(%ebp)
  101702:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101706:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10170a:	ee                   	out    %al,(%dx)
    }
}
  10170b:	c9                   	leave  
  10170c:	c3                   	ret    

0010170d <pic_enable>:

void
pic_enable(unsigned int irq) {
  10170d:	55                   	push   %ebp
  10170e:	89 e5                	mov    %esp,%ebp
  101710:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101713:	8b 45 08             	mov    0x8(%ebp),%eax
  101716:	ba 01 00 00 00       	mov    $0x1,%edx
  10171b:	89 c1                	mov    %eax,%ecx
  10171d:	d3 e2                	shl    %cl,%edx
  10171f:	89 d0                	mov    %edx,%eax
  101721:	f7 d0                	not    %eax
  101723:	89 c2                	mov    %eax,%edx
  101725:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10172c:	21 d0                	and    %edx,%eax
  10172e:	0f b7 c0             	movzwl %ax,%eax
  101731:	89 04 24             	mov    %eax,(%esp)
  101734:	e8 7c ff ff ff       	call   1016b5 <pic_setmask>
}
  101739:	c9                   	leave  
  10173a:	c3                   	ret    

0010173b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10173b:	55                   	push   %ebp
  10173c:	89 e5                	mov    %esp,%ebp
  10173e:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101741:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101748:	00 00 00 
  10174b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101751:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101755:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101759:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10175d:	ee                   	out    %al,(%dx)
  10175e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101764:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101768:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10176c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101770:	ee                   	out    %al,(%dx)
  101771:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101777:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10177b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10177f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101783:	ee                   	out    %al,(%dx)
  101784:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10178a:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10178e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101792:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101796:	ee                   	out    %al,(%dx)
  101797:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10179d:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a9:	ee                   	out    %al,(%dx)
  1017aa:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017b0:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017b4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017bc:	ee                   	out    %al,(%dx)
  1017bd:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017c3:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017cb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017cf:	ee                   	out    %al,(%dx)
  1017d0:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d6:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017da:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017de:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e2:	ee                   	out    %al,(%dx)
  1017e3:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017e9:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017ed:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017f1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017f5:	ee                   	out    %al,(%dx)
  1017f6:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017fc:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101800:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101804:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101808:	ee                   	out    %al,(%dx)
  101809:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10180f:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101813:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101817:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10181b:	ee                   	out    %al,(%dx)
  10181c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101822:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101826:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10182a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10182e:	ee                   	out    %al,(%dx)
  10182f:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101835:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101839:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10183d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101841:	ee                   	out    %al,(%dx)
  101842:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101848:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10184c:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101850:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101854:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101855:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10185c:	66 83 f8 ff          	cmp    $0xffff,%ax
  101860:	74 12                	je     101874 <pic_init+0x139>
        pic_setmask(irq_mask);
  101862:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101869:	0f b7 c0             	movzwl %ax,%eax
  10186c:	89 04 24             	mov    %eax,(%esp)
  10186f:	e8 41 fe ff ff       	call   1016b5 <pic_setmask>
    }
}
  101874:	c9                   	leave  
  101875:	c3                   	ret    

00101876 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101876:	55                   	push   %ebp
  101877:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101879:	fb                   	sti    
    sti();
}
  10187a:	5d                   	pop    %ebp
  10187b:	c3                   	ret    

0010187c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10187c:	55                   	push   %ebp
  10187d:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  10187f:	fa                   	cli    
    cli();
}
  101880:	5d                   	pop    %ebp
  101881:	c3                   	ret    

00101882 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101882:	55                   	push   %ebp
  101883:	89 e5                	mov    %esp,%ebp
  101885:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101888:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10188f:	00 
  101890:	c7 04 24 e0 64 10 00 	movl   $0x1064e0,(%esp)
  101897:	e8 f5 e9 ff ff       	call   100291 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10189c:	c7 04 24 ea 64 10 00 	movl   $0x1064ea,(%esp)
  1018a3:	e8 e9 e9 ff ff       	call   100291 <cprintf>
    panic("EOT: kernel seems ok.");
  1018a8:	c7 44 24 08 f8 64 10 	movl   $0x1064f8,0x8(%esp)
  1018af:	00 
  1018b0:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018b7:	00 
  1018b8:	c7 04 24 0e 65 10 00 	movl   $0x10650e,(%esp)
  1018bf:	e8 24 eb ff ff       	call   1003e8 <__panic>

001018c4 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018c4:	55                   	push   %ebp
  1018c5:	89 e5                	mov    %esp,%ebp
  1018c7:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
        int num=sizeof(idt)/sizeof(struct gatedesc);
  1018ca:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
	int i;
        for(i=0;i<num;++i)
  1018d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018d8:	e9 c3 00 00 00       	jmp    1019a0 <idt_init+0xdc>
        {
                SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
  1018dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e0:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018e7:	89 c2                	mov    %eax,%edx
  1018e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ec:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018f3:	00 
  1018f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f7:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018fe:	00 08 00 
  101901:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101904:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  10190b:	00 
  10190c:	83 e2 e0             	and    $0xffffffe0,%edx
  10190f:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101916:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101919:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101920:	00 
  101921:	83 e2 1f             	and    $0x1f,%edx
  101924:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  10192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192e:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101935:	00 
  101936:	83 e2 f0             	and    $0xfffffff0,%edx
  101939:	83 ca 0e             	or     $0xe,%edx
  10193c:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101946:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10194d:	00 
  10194e:	83 e2 ef             	and    $0xffffffef,%edx
  101951:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195b:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101962:	00 
  101963:	83 e2 9f             	and    $0xffffff9f,%edx
  101966:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10196d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101970:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101977:	00 
  101978:	83 ca 80             	or     $0xffffff80,%edx
  10197b:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101982:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101985:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10198c:	c1 e8 10             	shr    $0x10,%eax
  10198f:	89 c2                	mov    %eax,%edx
  101991:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101994:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  10199b:	00 
        for(i=0;i<num;++i)
  10199c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1019a6:	0f 8c 31 ff ff ff    	jl     1018dd <idt_init+0x19>
        }

        SETGATE(idt[T_SWITCH_TOU],0,GD_KTEXT,__vectors[T_SWITCH_TOU],DPL_USER);
  1019ac:	a1 e0 77 11 00       	mov    0x1177e0,%eax
  1019b1:	66 a3 80 84 11 00    	mov    %ax,0x118480
  1019b7:	66 c7 05 82 84 11 00 	movw   $0x8,0x118482
  1019be:	08 00 
  1019c0:	0f b6 05 84 84 11 00 	movzbl 0x118484,%eax
  1019c7:	83 e0 e0             	and    $0xffffffe0,%eax
  1019ca:	a2 84 84 11 00       	mov    %al,0x118484
  1019cf:	0f b6 05 84 84 11 00 	movzbl 0x118484,%eax
  1019d6:	83 e0 1f             	and    $0x1f,%eax
  1019d9:	a2 84 84 11 00       	mov    %al,0x118484
  1019de:	0f b6 05 85 84 11 00 	movzbl 0x118485,%eax
  1019e5:	83 e0 f0             	and    $0xfffffff0,%eax
  1019e8:	83 c8 0e             	or     $0xe,%eax
  1019eb:	a2 85 84 11 00       	mov    %al,0x118485
  1019f0:	0f b6 05 85 84 11 00 	movzbl 0x118485,%eax
  1019f7:	83 e0 ef             	and    $0xffffffef,%eax
  1019fa:	a2 85 84 11 00       	mov    %al,0x118485
  1019ff:	0f b6 05 85 84 11 00 	movzbl 0x118485,%eax
  101a06:	83 c8 60             	or     $0x60,%eax
  101a09:	a2 85 84 11 00       	mov    %al,0x118485
  101a0e:	0f b6 05 85 84 11 00 	movzbl 0x118485,%eax
  101a15:	83 c8 80             	or     $0xffffff80,%eax
  101a18:	a2 85 84 11 00       	mov    %al,0x118485
  101a1d:	a1 e0 77 11 00       	mov    0x1177e0,%eax
  101a22:	c1 e8 10             	shr    $0x10,%eax
  101a25:	66 a3 86 84 11 00    	mov    %ax,0x118486
	SETGATE(idt[T_SWITCH_TOK], 0, KERNEL_CS, __vectors[T_SWITCH_TOK], 3);        
  101a2b:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101a30:	66 a3 88 84 11 00    	mov    %ax,0x118488
  101a36:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  101a3d:	08 00 
  101a3f:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  101a46:	83 e0 e0             	and    $0xffffffe0,%eax
  101a49:	a2 8c 84 11 00       	mov    %al,0x11848c
  101a4e:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  101a55:	83 e0 1f             	and    $0x1f,%eax
  101a58:	a2 8c 84 11 00       	mov    %al,0x11848c
  101a5d:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101a64:	83 e0 f0             	and    $0xfffffff0,%eax
  101a67:	83 c8 0e             	or     $0xe,%eax
  101a6a:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a6f:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101a76:	83 e0 ef             	and    $0xffffffef,%eax
  101a79:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a7e:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101a85:	83 c8 60             	or     $0x60,%eax
  101a88:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a8d:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101a94:	83 c8 80             	or     $0xffffff80,%eax
  101a97:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a9c:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101aa1:	c1 e8 10             	shr    $0x10,%eax
  101aa4:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  101aaa:	c7 45 f4 80 75 11 00 	movl   $0x117580,-0xc(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ab4:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  101ab7:	c9                   	leave  
  101ab8:	c3                   	ret    

00101ab9 <trapname>:

static const char *
trapname(int trapno) {
  101ab9:	55                   	push   %ebp
  101aba:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101abc:	8b 45 08             	mov    0x8(%ebp),%eax
  101abf:	83 f8 13             	cmp    $0x13,%eax
  101ac2:	77 0c                	ja     101ad0 <trapname+0x17>
        return excnames[trapno];
  101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac7:	8b 04 85 60 68 10 00 	mov    0x106860(,%eax,4),%eax
  101ace:	eb 18                	jmp    101ae8 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101ad0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101ad4:	7e 0d                	jle    101ae3 <trapname+0x2a>
  101ad6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101ada:	7f 07                	jg     101ae3 <trapname+0x2a>
        return "Hardware Interrupt";
  101adc:	b8 1f 65 10 00       	mov    $0x10651f,%eax
  101ae1:	eb 05                	jmp    101ae8 <trapname+0x2f>
    }
    return "(unknown trap)";
  101ae3:	b8 32 65 10 00       	mov    $0x106532,%eax
}
  101ae8:	5d                   	pop    %ebp
  101ae9:	c3                   	ret    

00101aea <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101aea:	55                   	push   %ebp
  101aeb:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101aed:	8b 45 08             	mov    0x8(%ebp),%eax
  101af0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101af4:	66 83 f8 08          	cmp    $0x8,%ax
  101af8:	0f 94 c0             	sete   %al
  101afb:	0f b6 c0             	movzbl %al,%eax
}
  101afe:	5d                   	pop    %ebp
  101aff:	c3                   	ret    

00101b00 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b00:	55                   	push   %ebp
  101b01:	89 e5                	mov    %esp,%ebp
  101b03:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b06:	8b 45 08             	mov    0x8(%ebp),%eax
  101b09:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0d:	c7 04 24 73 65 10 00 	movl   $0x106573,(%esp)
  101b14:	e8 78 e7 ff ff       	call   100291 <cprintf>
    print_regs(&tf->tf_regs);
  101b19:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1c:	89 04 24             	mov    %eax,(%esp)
  101b1f:	e8 a1 01 00 00       	call   101cc5 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b24:	8b 45 08             	mov    0x8(%ebp),%eax
  101b27:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b2b:	0f b7 c0             	movzwl %ax,%eax
  101b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b32:	c7 04 24 84 65 10 00 	movl   $0x106584,(%esp)
  101b39:	e8 53 e7 ff ff       	call   100291 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b41:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b45:	0f b7 c0             	movzwl %ax,%eax
  101b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4c:	c7 04 24 97 65 10 00 	movl   $0x106597,(%esp)
  101b53:	e8 39 e7 ff ff       	call   100291 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b58:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5b:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b5f:	0f b7 c0             	movzwl %ax,%eax
  101b62:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b66:	c7 04 24 aa 65 10 00 	movl   $0x1065aa,(%esp)
  101b6d:	e8 1f e7 ff ff       	call   100291 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b72:	8b 45 08             	mov    0x8(%ebp),%eax
  101b75:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b79:	0f b7 c0             	movzwl %ax,%eax
  101b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b80:	c7 04 24 bd 65 10 00 	movl   $0x1065bd,(%esp)
  101b87:	e8 05 e7 ff ff       	call   100291 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8f:	8b 40 30             	mov    0x30(%eax),%eax
  101b92:	89 04 24             	mov    %eax,(%esp)
  101b95:	e8 1f ff ff ff       	call   101ab9 <trapname>
  101b9a:	8b 55 08             	mov    0x8(%ebp),%edx
  101b9d:	8b 52 30             	mov    0x30(%edx),%edx
  101ba0:	89 44 24 08          	mov    %eax,0x8(%esp)
  101ba4:	89 54 24 04          	mov    %edx,0x4(%esp)
  101ba8:	c7 04 24 d0 65 10 00 	movl   $0x1065d0,(%esp)
  101baf:	e8 dd e6 ff ff       	call   100291 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb7:	8b 40 34             	mov    0x34(%eax),%eax
  101bba:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbe:	c7 04 24 e2 65 10 00 	movl   $0x1065e2,(%esp)
  101bc5:	e8 c7 e6 ff ff       	call   100291 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bca:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcd:	8b 40 38             	mov    0x38(%eax),%eax
  101bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd4:	c7 04 24 f1 65 10 00 	movl   $0x1065f1,(%esp)
  101bdb:	e8 b1 e6 ff ff       	call   100291 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101be0:	8b 45 08             	mov    0x8(%ebp),%eax
  101be3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101be7:	0f b7 c0             	movzwl %ax,%eax
  101bea:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bee:	c7 04 24 00 66 10 00 	movl   $0x106600,(%esp)
  101bf5:	e8 97 e6 ff ff       	call   100291 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfd:	8b 40 40             	mov    0x40(%eax),%eax
  101c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c04:	c7 04 24 13 66 10 00 	movl   $0x106613,(%esp)
  101c0b:	e8 81 e6 ff ff       	call   100291 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c17:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c1e:	eb 3e                	jmp    101c5e <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c20:	8b 45 08             	mov    0x8(%ebp),%eax
  101c23:	8b 50 40             	mov    0x40(%eax),%edx
  101c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c29:	21 d0                	and    %edx,%eax
  101c2b:	85 c0                	test   %eax,%eax
  101c2d:	74 28                	je     101c57 <print_trapframe+0x157>
  101c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c32:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101c39:	85 c0                	test   %eax,%eax
  101c3b:	74 1a                	je     101c57 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c40:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4b:	c7 04 24 22 66 10 00 	movl   $0x106622,(%esp)
  101c52:	e8 3a e6 ff ff       	call   100291 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c57:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101c5b:	d1 65 f0             	shll   -0x10(%ebp)
  101c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c61:	83 f8 17             	cmp    $0x17,%eax
  101c64:	76 ba                	jbe    101c20 <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c66:	8b 45 08             	mov    0x8(%ebp),%eax
  101c69:	8b 40 40             	mov    0x40(%eax),%eax
  101c6c:	25 00 30 00 00       	and    $0x3000,%eax
  101c71:	c1 e8 0c             	shr    $0xc,%eax
  101c74:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c78:	c7 04 24 26 66 10 00 	movl   $0x106626,(%esp)
  101c7f:	e8 0d e6 ff ff       	call   100291 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c84:	8b 45 08             	mov    0x8(%ebp),%eax
  101c87:	89 04 24             	mov    %eax,(%esp)
  101c8a:	e8 5b fe ff ff       	call   101aea <trap_in_kernel>
  101c8f:	85 c0                	test   %eax,%eax
  101c91:	75 30                	jne    101cc3 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c93:	8b 45 08             	mov    0x8(%ebp),%eax
  101c96:	8b 40 44             	mov    0x44(%eax),%eax
  101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9d:	c7 04 24 2f 66 10 00 	movl   $0x10662f,(%esp)
  101ca4:	e8 e8 e5 ff ff       	call   100291 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cac:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cb0:	0f b7 c0             	movzwl %ax,%eax
  101cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb7:	c7 04 24 3e 66 10 00 	movl   $0x10663e,(%esp)
  101cbe:	e8 ce e5 ff ff       	call   100291 <cprintf>
    }
}
  101cc3:	c9                   	leave  
  101cc4:	c3                   	ret    

00101cc5 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101cc5:	55                   	push   %ebp
  101cc6:	89 e5                	mov    %esp,%ebp
  101cc8:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cce:	8b 00                	mov    (%eax),%eax
  101cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd4:	c7 04 24 51 66 10 00 	movl   $0x106651,(%esp)
  101cdb:	e8 b1 e5 ff ff       	call   100291 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce3:	8b 40 04             	mov    0x4(%eax),%eax
  101ce6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cea:	c7 04 24 60 66 10 00 	movl   $0x106660,(%esp)
  101cf1:	e8 9b e5 ff ff       	call   100291 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf9:	8b 40 08             	mov    0x8(%eax),%eax
  101cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d00:	c7 04 24 6f 66 10 00 	movl   $0x10666f,(%esp)
  101d07:	e8 85 e5 ff ff       	call   100291 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0f:	8b 40 0c             	mov    0xc(%eax),%eax
  101d12:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d16:	c7 04 24 7e 66 10 00 	movl   $0x10667e,(%esp)
  101d1d:	e8 6f e5 ff ff       	call   100291 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d22:	8b 45 08             	mov    0x8(%ebp),%eax
  101d25:	8b 40 10             	mov    0x10(%eax),%eax
  101d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d2c:	c7 04 24 8d 66 10 00 	movl   $0x10668d,(%esp)
  101d33:	e8 59 e5 ff ff       	call   100291 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d38:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3b:	8b 40 14             	mov    0x14(%eax),%eax
  101d3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d42:	c7 04 24 9c 66 10 00 	movl   $0x10669c,(%esp)
  101d49:	e8 43 e5 ff ff       	call   100291 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d51:	8b 40 18             	mov    0x18(%eax),%eax
  101d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d58:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  101d5f:	e8 2d e5 ff ff       	call   100291 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d64:	8b 45 08             	mov    0x8(%ebp),%eax
  101d67:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d6e:	c7 04 24 ba 66 10 00 	movl   $0x1066ba,(%esp)
  101d75:	e8 17 e5 ff ff       	call   100291 <cprintf>
}
  101d7a:	c9                   	leave  
  101d7b:	c3                   	ret    

00101d7c <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d7c:	55                   	push   %ebp
  101d7d:	89 e5                	mov    %esp,%ebp
  101d7f:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d82:	8b 45 08             	mov    0x8(%ebp),%eax
  101d85:	8b 40 30             	mov    0x30(%eax),%eax
  101d88:	83 f8 2f             	cmp    $0x2f,%eax
  101d8b:	77 1d                	ja     101daa <trap_dispatch+0x2e>
  101d8d:	83 f8 2e             	cmp    $0x2e,%eax
  101d90:	0f 83 91 01 00 00    	jae    101f27 <trap_dispatch+0x1ab>
  101d96:	83 f8 21             	cmp    $0x21,%eax
  101d99:	74 7f                	je     101e1a <trap_dispatch+0x9e>
  101d9b:	83 f8 24             	cmp    $0x24,%eax
  101d9e:	74 51                	je     101df1 <trap_dispatch+0x75>
  101da0:	83 f8 20             	cmp    $0x20,%eax
  101da3:	74 1c                	je     101dc1 <trap_dispatch+0x45>
  101da5:	e9 45 01 00 00       	jmp    101eef <trap_dispatch+0x173>
  101daa:	83 f8 78             	cmp    $0x78,%eax
  101dad:	0f 84 90 00 00 00    	je     101e43 <trap_dispatch+0xc7>
  101db3:	83 f8 79             	cmp    $0x79,%eax
  101db6:	0f 84 e7 00 00 00    	je     101ea3 <trap_dispatch+0x127>
  101dbc:	e9 2e 01 00 00       	jmp    101eef <trap_dispatch+0x173>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */

	ticks++;
  101dc1:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101dc6:	83 c0 01             	add    $0x1,%eax
  101dc9:	a3 4c 89 11 00       	mov    %eax,0x11894c
	if(ticks==TICK_NUM)
  101dce:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101dd3:	83 f8 64             	cmp    $0x64,%eax
  101dd6:	75 14                	jne    101dec <trap_dispatch+0x70>
	{
		ticks=0;
  101dd8:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  101ddf:	00 00 00 
		print_ticks();
  101de2:	e8 9b fa ff ff       	call   101882 <print_ticks>
	}		
        break;
  101de7:	e9 3c 01 00 00       	jmp    101f28 <trap_dispatch+0x1ac>
  101dec:	e9 37 01 00 00       	jmp    101f28 <trap_dispatch+0x1ac>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101df1:	e8 50 f8 ff ff       	call   101646 <cons_getc>
  101df6:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101df9:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dfd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e01:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e05:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e09:	c7 04 24 c9 66 10 00 	movl   $0x1066c9,(%esp)
  101e10:	e8 7c e4 ff ff       	call   100291 <cprintf>
        break;
  101e15:	e9 0e 01 00 00       	jmp    101f28 <trap_dispatch+0x1ac>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e1a:	e8 27 f8 ff ff       	call   101646 <cons_getc>
  101e1f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e22:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e26:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e2a:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e32:	c7 04 24 db 66 10 00 	movl   $0x1066db,(%esp)
  101e39:	e8 53 e4 ff ff       	call   100291 <cprintf>
        break;
  101e3e:	e9 e5 00 00 00       	jmp    101f28 <trap_dispatch+0x1ac>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
	tf->tf_eflags |= FL_IOPL_MASK;
  101e43:	8b 45 08             	mov    0x8(%ebp),%eax
  101e46:	8b 40 40             	mov    0x40(%eax),%eax
  101e49:	80 cc 30             	or     $0x30,%ah
  101e4c:	89 c2                	mov    %eax,%edx
  101e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e51:	89 50 40             	mov    %edx,0x40(%eax)
	tf->tf_cs = USER_CS;
  101e54:	8b 45 08             	mov    0x8(%ebp),%eax
  101e57:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
	tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = USER_DS;
  101e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e60:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  101e66:	8b 45 08             	mov    0x8(%ebp),%eax
  101e69:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e70:	66 89 50 48          	mov    %dx,0x48(%eax)
  101e74:	8b 45 08             	mov    0x8(%ebp),%eax
  101e77:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7e:	66 89 50 20          	mov    %dx,0x20(%eax)
  101e82:	8b 45 08             	mov    0x8(%ebp),%eax
  101e85:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101e89:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8c:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e90:	8b 45 08             	mov    0x8(%ebp),%eax
  101e93:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e97:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9a:	66 89 50 2c          	mov    %dx,0x2c(%eax)
	break;
  101e9e:	e9 85 00 00 00       	jmp    101f28 <trap_dispatch+0x1ac>
    case T_SWITCH_TOK:
	tf->tf_cs = KERNEL_CS;
  101ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea6:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
	tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = KERNEL_DS;
  101eac:	8b 45 08             	mov    0x8(%ebp),%eax
  101eaf:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  101eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb8:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  101ebf:	66 89 50 48          	mov    %dx,0x48(%eax)
  101ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec6:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101eca:	8b 45 08             	mov    0x8(%ebp),%eax
  101ecd:	66 89 50 20          	mov    %dx,0x20(%eax)
  101ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed4:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  101edb:	66 89 50 28          	mov    %dx,0x28(%eax)
  101edf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee2:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee9:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        break;
  101eed:	eb 39                	jmp    101f28 <trap_dispatch+0x1ac>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101eef:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ef6:	0f b7 c0             	movzwl %ax,%eax
  101ef9:	83 e0 03             	and    $0x3,%eax
  101efc:	85 c0                	test   %eax,%eax
  101efe:	75 28                	jne    101f28 <trap_dispatch+0x1ac>
            print_trapframe(tf);
  101f00:	8b 45 08             	mov    0x8(%ebp),%eax
  101f03:	89 04 24             	mov    %eax,(%esp)
  101f06:	e8 f5 fb ff ff       	call   101b00 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101f0b:	c7 44 24 08 ea 66 10 	movl   $0x1066ea,0x8(%esp)
  101f12:	00 
  101f13:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  101f1a:	00 
  101f1b:	c7 04 24 0e 65 10 00 	movl   $0x10650e,(%esp)
  101f22:	e8 c1 e4 ff ff       	call   1003e8 <__panic>
        break;
  101f27:	90                   	nop
        }
    }
}
  101f28:	c9                   	leave  
  101f29:	c3                   	ret    

00101f2a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f2a:	55                   	push   %ebp
  101f2b:	89 e5                	mov    %esp,%ebp
  101f2d:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f30:	8b 45 08             	mov    0x8(%ebp),%eax
  101f33:	89 04 24             	mov    %eax,(%esp)
  101f36:	e8 41 fe ff ff       	call   101d7c <trap_dispatch>
}
  101f3b:	c9                   	leave  
  101f3c:	c3                   	ret    

00101f3d <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f3d:	6a 00                	push   $0x0
  pushl $0
  101f3f:	6a 00                	push   $0x0
  jmp __alltraps
  101f41:	e9 67 0a 00 00       	jmp    1029ad <__alltraps>

00101f46 <vector1>:
.globl vector1
vector1:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $1
  101f48:	6a 01                	push   $0x1
  jmp __alltraps
  101f4a:	e9 5e 0a 00 00       	jmp    1029ad <__alltraps>

00101f4f <vector2>:
.globl vector2
vector2:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $2
  101f51:	6a 02                	push   $0x2
  jmp __alltraps
  101f53:	e9 55 0a 00 00       	jmp    1029ad <__alltraps>

00101f58 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $3
  101f5a:	6a 03                	push   $0x3
  jmp __alltraps
  101f5c:	e9 4c 0a 00 00       	jmp    1029ad <__alltraps>

00101f61 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $4
  101f63:	6a 04                	push   $0x4
  jmp __alltraps
  101f65:	e9 43 0a 00 00       	jmp    1029ad <__alltraps>

00101f6a <vector5>:
.globl vector5
vector5:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $5
  101f6c:	6a 05                	push   $0x5
  jmp __alltraps
  101f6e:	e9 3a 0a 00 00       	jmp    1029ad <__alltraps>

00101f73 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $6
  101f75:	6a 06                	push   $0x6
  jmp __alltraps
  101f77:	e9 31 0a 00 00       	jmp    1029ad <__alltraps>

00101f7c <vector7>:
.globl vector7
vector7:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $7
  101f7e:	6a 07                	push   $0x7
  jmp __alltraps
  101f80:	e9 28 0a 00 00       	jmp    1029ad <__alltraps>

00101f85 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f85:	6a 08                	push   $0x8
  jmp __alltraps
  101f87:	e9 21 0a 00 00       	jmp    1029ad <__alltraps>

00101f8c <vector9>:
.globl vector9
vector9:
  pushl $9
  101f8c:	6a 09                	push   $0x9
  jmp __alltraps
  101f8e:	e9 1a 0a 00 00       	jmp    1029ad <__alltraps>

00101f93 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f93:	6a 0a                	push   $0xa
  jmp __alltraps
  101f95:	e9 13 0a 00 00       	jmp    1029ad <__alltraps>

00101f9a <vector11>:
.globl vector11
vector11:
  pushl $11
  101f9a:	6a 0b                	push   $0xb
  jmp __alltraps
  101f9c:	e9 0c 0a 00 00       	jmp    1029ad <__alltraps>

00101fa1 <vector12>:
.globl vector12
vector12:
  pushl $12
  101fa1:	6a 0c                	push   $0xc
  jmp __alltraps
  101fa3:	e9 05 0a 00 00       	jmp    1029ad <__alltraps>

00101fa8 <vector13>:
.globl vector13
vector13:
  pushl $13
  101fa8:	6a 0d                	push   $0xd
  jmp __alltraps
  101faa:	e9 fe 09 00 00       	jmp    1029ad <__alltraps>

00101faf <vector14>:
.globl vector14
vector14:
  pushl $14
  101faf:	6a 0e                	push   $0xe
  jmp __alltraps
  101fb1:	e9 f7 09 00 00       	jmp    1029ad <__alltraps>

00101fb6 <vector15>:
.globl vector15
vector15:
  pushl $0
  101fb6:	6a 00                	push   $0x0
  pushl $15
  101fb8:	6a 0f                	push   $0xf
  jmp __alltraps
  101fba:	e9 ee 09 00 00       	jmp    1029ad <__alltraps>

00101fbf <vector16>:
.globl vector16
vector16:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $16
  101fc1:	6a 10                	push   $0x10
  jmp __alltraps
  101fc3:	e9 e5 09 00 00       	jmp    1029ad <__alltraps>

00101fc8 <vector17>:
.globl vector17
vector17:
  pushl $17
  101fc8:	6a 11                	push   $0x11
  jmp __alltraps
  101fca:	e9 de 09 00 00       	jmp    1029ad <__alltraps>

00101fcf <vector18>:
.globl vector18
vector18:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $18
  101fd1:	6a 12                	push   $0x12
  jmp __alltraps
  101fd3:	e9 d5 09 00 00       	jmp    1029ad <__alltraps>

00101fd8 <vector19>:
.globl vector19
vector19:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $19
  101fda:	6a 13                	push   $0x13
  jmp __alltraps
  101fdc:	e9 cc 09 00 00       	jmp    1029ad <__alltraps>

00101fe1 <vector20>:
.globl vector20
vector20:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $20
  101fe3:	6a 14                	push   $0x14
  jmp __alltraps
  101fe5:	e9 c3 09 00 00       	jmp    1029ad <__alltraps>

00101fea <vector21>:
.globl vector21
vector21:
  pushl $0
  101fea:	6a 00                	push   $0x0
  pushl $21
  101fec:	6a 15                	push   $0x15
  jmp __alltraps
  101fee:	e9 ba 09 00 00       	jmp    1029ad <__alltraps>

00101ff3 <vector22>:
.globl vector22
vector22:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $22
  101ff5:	6a 16                	push   $0x16
  jmp __alltraps
  101ff7:	e9 b1 09 00 00       	jmp    1029ad <__alltraps>

00101ffc <vector23>:
.globl vector23
vector23:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $23
  101ffe:	6a 17                	push   $0x17
  jmp __alltraps
  102000:	e9 a8 09 00 00       	jmp    1029ad <__alltraps>

00102005 <vector24>:
.globl vector24
vector24:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $24
  102007:	6a 18                	push   $0x18
  jmp __alltraps
  102009:	e9 9f 09 00 00       	jmp    1029ad <__alltraps>

0010200e <vector25>:
.globl vector25
vector25:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $25
  102010:	6a 19                	push   $0x19
  jmp __alltraps
  102012:	e9 96 09 00 00       	jmp    1029ad <__alltraps>

00102017 <vector26>:
.globl vector26
vector26:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $26
  102019:	6a 1a                	push   $0x1a
  jmp __alltraps
  10201b:	e9 8d 09 00 00       	jmp    1029ad <__alltraps>

00102020 <vector27>:
.globl vector27
vector27:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $27
  102022:	6a 1b                	push   $0x1b
  jmp __alltraps
  102024:	e9 84 09 00 00       	jmp    1029ad <__alltraps>

00102029 <vector28>:
.globl vector28
vector28:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $28
  10202b:	6a 1c                	push   $0x1c
  jmp __alltraps
  10202d:	e9 7b 09 00 00       	jmp    1029ad <__alltraps>

00102032 <vector29>:
.globl vector29
vector29:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $29
  102034:	6a 1d                	push   $0x1d
  jmp __alltraps
  102036:	e9 72 09 00 00       	jmp    1029ad <__alltraps>

0010203b <vector30>:
.globl vector30
vector30:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $30
  10203d:	6a 1e                	push   $0x1e
  jmp __alltraps
  10203f:	e9 69 09 00 00       	jmp    1029ad <__alltraps>

00102044 <vector31>:
.globl vector31
vector31:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $31
  102046:	6a 1f                	push   $0x1f
  jmp __alltraps
  102048:	e9 60 09 00 00       	jmp    1029ad <__alltraps>

0010204d <vector32>:
.globl vector32
vector32:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $32
  10204f:	6a 20                	push   $0x20
  jmp __alltraps
  102051:	e9 57 09 00 00       	jmp    1029ad <__alltraps>

00102056 <vector33>:
.globl vector33
vector33:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $33
  102058:	6a 21                	push   $0x21
  jmp __alltraps
  10205a:	e9 4e 09 00 00       	jmp    1029ad <__alltraps>

0010205f <vector34>:
.globl vector34
vector34:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $34
  102061:	6a 22                	push   $0x22
  jmp __alltraps
  102063:	e9 45 09 00 00       	jmp    1029ad <__alltraps>

00102068 <vector35>:
.globl vector35
vector35:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $35
  10206a:	6a 23                	push   $0x23
  jmp __alltraps
  10206c:	e9 3c 09 00 00       	jmp    1029ad <__alltraps>

00102071 <vector36>:
.globl vector36
vector36:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $36
  102073:	6a 24                	push   $0x24
  jmp __alltraps
  102075:	e9 33 09 00 00       	jmp    1029ad <__alltraps>

0010207a <vector37>:
.globl vector37
vector37:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $37
  10207c:	6a 25                	push   $0x25
  jmp __alltraps
  10207e:	e9 2a 09 00 00       	jmp    1029ad <__alltraps>

00102083 <vector38>:
.globl vector38
vector38:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $38
  102085:	6a 26                	push   $0x26
  jmp __alltraps
  102087:	e9 21 09 00 00       	jmp    1029ad <__alltraps>

0010208c <vector39>:
.globl vector39
vector39:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $39
  10208e:	6a 27                	push   $0x27
  jmp __alltraps
  102090:	e9 18 09 00 00       	jmp    1029ad <__alltraps>

00102095 <vector40>:
.globl vector40
vector40:
  pushl $0
  102095:	6a 00                	push   $0x0
  pushl $40
  102097:	6a 28                	push   $0x28
  jmp __alltraps
  102099:	e9 0f 09 00 00       	jmp    1029ad <__alltraps>

0010209e <vector41>:
.globl vector41
vector41:
  pushl $0
  10209e:	6a 00                	push   $0x0
  pushl $41
  1020a0:	6a 29                	push   $0x29
  jmp __alltraps
  1020a2:	e9 06 09 00 00       	jmp    1029ad <__alltraps>

001020a7 <vector42>:
.globl vector42
vector42:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $42
  1020a9:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020ab:	e9 fd 08 00 00       	jmp    1029ad <__alltraps>

001020b0 <vector43>:
.globl vector43
vector43:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $43
  1020b2:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020b4:	e9 f4 08 00 00       	jmp    1029ad <__alltraps>

001020b9 <vector44>:
.globl vector44
vector44:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $44
  1020bb:	6a 2c                	push   $0x2c
  jmp __alltraps
  1020bd:	e9 eb 08 00 00       	jmp    1029ad <__alltraps>

001020c2 <vector45>:
.globl vector45
vector45:
  pushl $0
  1020c2:	6a 00                	push   $0x0
  pushl $45
  1020c4:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020c6:	e9 e2 08 00 00       	jmp    1029ad <__alltraps>

001020cb <vector46>:
.globl vector46
vector46:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $46
  1020cd:	6a 2e                	push   $0x2e
  jmp __alltraps
  1020cf:	e9 d9 08 00 00       	jmp    1029ad <__alltraps>

001020d4 <vector47>:
.globl vector47
vector47:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $47
  1020d6:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020d8:	e9 d0 08 00 00       	jmp    1029ad <__alltraps>

001020dd <vector48>:
.globl vector48
vector48:
  pushl $0
  1020dd:	6a 00                	push   $0x0
  pushl $48
  1020df:	6a 30                	push   $0x30
  jmp __alltraps
  1020e1:	e9 c7 08 00 00       	jmp    1029ad <__alltraps>

001020e6 <vector49>:
.globl vector49
vector49:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $49
  1020e8:	6a 31                	push   $0x31
  jmp __alltraps
  1020ea:	e9 be 08 00 00       	jmp    1029ad <__alltraps>

001020ef <vector50>:
.globl vector50
vector50:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $50
  1020f1:	6a 32                	push   $0x32
  jmp __alltraps
  1020f3:	e9 b5 08 00 00       	jmp    1029ad <__alltraps>

001020f8 <vector51>:
.globl vector51
vector51:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $51
  1020fa:	6a 33                	push   $0x33
  jmp __alltraps
  1020fc:	e9 ac 08 00 00       	jmp    1029ad <__alltraps>

00102101 <vector52>:
.globl vector52
vector52:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $52
  102103:	6a 34                	push   $0x34
  jmp __alltraps
  102105:	e9 a3 08 00 00       	jmp    1029ad <__alltraps>

0010210a <vector53>:
.globl vector53
vector53:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $53
  10210c:	6a 35                	push   $0x35
  jmp __alltraps
  10210e:	e9 9a 08 00 00       	jmp    1029ad <__alltraps>

00102113 <vector54>:
.globl vector54
vector54:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $54
  102115:	6a 36                	push   $0x36
  jmp __alltraps
  102117:	e9 91 08 00 00       	jmp    1029ad <__alltraps>

0010211c <vector55>:
.globl vector55
vector55:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $55
  10211e:	6a 37                	push   $0x37
  jmp __alltraps
  102120:	e9 88 08 00 00       	jmp    1029ad <__alltraps>

00102125 <vector56>:
.globl vector56
vector56:
  pushl $0
  102125:	6a 00                	push   $0x0
  pushl $56
  102127:	6a 38                	push   $0x38
  jmp __alltraps
  102129:	e9 7f 08 00 00       	jmp    1029ad <__alltraps>

0010212e <vector57>:
.globl vector57
vector57:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $57
  102130:	6a 39                	push   $0x39
  jmp __alltraps
  102132:	e9 76 08 00 00       	jmp    1029ad <__alltraps>

00102137 <vector58>:
.globl vector58
vector58:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $58
  102139:	6a 3a                	push   $0x3a
  jmp __alltraps
  10213b:	e9 6d 08 00 00       	jmp    1029ad <__alltraps>

00102140 <vector59>:
.globl vector59
vector59:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $59
  102142:	6a 3b                	push   $0x3b
  jmp __alltraps
  102144:	e9 64 08 00 00       	jmp    1029ad <__alltraps>

00102149 <vector60>:
.globl vector60
vector60:
  pushl $0
  102149:	6a 00                	push   $0x0
  pushl $60
  10214b:	6a 3c                	push   $0x3c
  jmp __alltraps
  10214d:	e9 5b 08 00 00       	jmp    1029ad <__alltraps>

00102152 <vector61>:
.globl vector61
vector61:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $61
  102154:	6a 3d                	push   $0x3d
  jmp __alltraps
  102156:	e9 52 08 00 00       	jmp    1029ad <__alltraps>

0010215b <vector62>:
.globl vector62
vector62:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $62
  10215d:	6a 3e                	push   $0x3e
  jmp __alltraps
  10215f:	e9 49 08 00 00       	jmp    1029ad <__alltraps>

00102164 <vector63>:
.globl vector63
vector63:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $63
  102166:	6a 3f                	push   $0x3f
  jmp __alltraps
  102168:	e9 40 08 00 00       	jmp    1029ad <__alltraps>

0010216d <vector64>:
.globl vector64
vector64:
  pushl $0
  10216d:	6a 00                	push   $0x0
  pushl $64
  10216f:	6a 40                	push   $0x40
  jmp __alltraps
  102171:	e9 37 08 00 00       	jmp    1029ad <__alltraps>

00102176 <vector65>:
.globl vector65
vector65:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $65
  102178:	6a 41                	push   $0x41
  jmp __alltraps
  10217a:	e9 2e 08 00 00       	jmp    1029ad <__alltraps>

0010217f <vector66>:
.globl vector66
vector66:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $66
  102181:	6a 42                	push   $0x42
  jmp __alltraps
  102183:	e9 25 08 00 00       	jmp    1029ad <__alltraps>

00102188 <vector67>:
.globl vector67
vector67:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $67
  10218a:	6a 43                	push   $0x43
  jmp __alltraps
  10218c:	e9 1c 08 00 00       	jmp    1029ad <__alltraps>

00102191 <vector68>:
.globl vector68
vector68:
  pushl $0
  102191:	6a 00                	push   $0x0
  pushl $68
  102193:	6a 44                	push   $0x44
  jmp __alltraps
  102195:	e9 13 08 00 00       	jmp    1029ad <__alltraps>

0010219a <vector69>:
.globl vector69
vector69:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $69
  10219c:	6a 45                	push   $0x45
  jmp __alltraps
  10219e:	e9 0a 08 00 00       	jmp    1029ad <__alltraps>

001021a3 <vector70>:
.globl vector70
vector70:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $70
  1021a5:	6a 46                	push   $0x46
  jmp __alltraps
  1021a7:	e9 01 08 00 00       	jmp    1029ad <__alltraps>

001021ac <vector71>:
.globl vector71
vector71:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $71
  1021ae:	6a 47                	push   $0x47
  jmp __alltraps
  1021b0:	e9 f8 07 00 00       	jmp    1029ad <__alltraps>

001021b5 <vector72>:
.globl vector72
vector72:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $72
  1021b7:	6a 48                	push   $0x48
  jmp __alltraps
  1021b9:	e9 ef 07 00 00       	jmp    1029ad <__alltraps>

001021be <vector73>:
.globl vector73
vector73:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $73
  1021c0:	6a 49                	push   $0x49
  jmp __alltraps
  1021c2:	e9 e6 07 00 00       	jmp    1029ad <__alltraps>

001021c7 <vector74>:
.globl vector74
vector74:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $74
  1021c9:	6a 4a                	push   $0x4a
  jmp __alltraps
  1021cb:	e9 dd 07 00 00       	jmp    1029ad <__alltraps>

001021d0 <vector75>:
.globl vector75
vector75:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $75
  1021d2:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021d4:	e9 d4 07 00 00       	jmp    1029ad <__alltraps>

001021d9 <vector76>:
.globl vector76
vector76:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $76
  1021db:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021dd:	e9 cb 07 00 00       	jmp    1029ad <__alltraps>

001021e2 <vector77>:
.globl vector77
vector77:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $77
  1021e4:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021e6:	e9 c2 07 00 00       	jmp    1029ad <__alltraps>

001021eb <vector78>:
.globl vector78
vector78:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $78
  1021ed:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021ef:	e9 b9 07 00 00       	jmp    1029ad <__alltraps>

001021f4 <vector79>:
.globl vector79
vector79:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $79
  1021f6:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021f8:	e9 b0 07 00 00       	jmp    1029ad <__alltraps>

001021fd <vector80>:
.globl vector80
vector80:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $80
  1021ff:	6a 50                	push   $0x50
  jmp __alltraps
  102201:	e9 a7 07 00 00       	jmp    1029ad <__alltraps>

00102206 <vector81>:
.globl vector81
vector81:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $81
  102208:	6a 51                	push   $0x51
  jmp __alltraps
  10220a:	e9 9e 07 00 00       	jmp    1029ad <__alltraps>

0010220f <vector82>:
.globl vector82
vector82:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $82
  102211:	6a 52                	push   $0x52
  jmp __alltraps
  102213:	e9 95 07 00 00       	jmp    1029ad <__alltraps>

00102218 <vector83>:
.globl vector83
vector83:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $83
  10221a:	6a 53                	push   $0x53
  jmp __alltraps
  10221c:	e9 8c 07 00 00       	jmp    1029ad <__alltraps>

00102221 <vector84>:
.globl vector84
vector84:
  pushl $0
  102221:	6a 00                	push   $0x0
  pushl $84
  102223:	6a 54                	push   $0x54
  jmp __alltraps
  102225:	e9 83 07 00 00       	jmp    1029ad <__alltraps>

0010222a <vector85>:
.globl vector85
vector85:
  pushl $0
  10222a:	6a 00                	push   $0x0
  pushl $85
  10222c:	6a 55                	push   $0x55
  jmp __alltraps
  10222e:	e9 7a 07 00 00       	jmp    1029ad <__alltraps>

00102233 <vector86>:
.globl vector86
vector86:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $86
  102235:	6a 56                	push   $0x56
  jmp __alltraps
  102237:	e9 71 07 00 00       	jmp    1029ad <__alltraps>

0010223c <vector87>:
.globl vector87
vector87:
  pushl $0
  10223c:	6a 00                	push   $0x0
  pushl $87
  10223e:	6a 57                	push   $0x57
  jmp __alltraps
  102240:	e9 68 07 00 00       	jmp    1029ad <__alltraps>

00102245 <vector88>:
.globl vector88
vector88:
  pushl $0
  102245:	6a 00                	push   $0x0
  pushl $88
  102247:	6a 58                	push   $0x58
  jmp __alltraps
  102249:	e9 5f 07 00 00       	jmp    1029ad <__alltraps>

0010224e <vector89>:
.globl vector89
vector89:
  pushl $0
  10224e:	6a 00                	push   $0x0
  pushl $89
  102250:	6a 59                	push   $0x59
  jmp __alltraps
  102252:	e9 56 07 00 00       	jmp    1029ad <__alltraps>

00102257 <vector90>:
.globl vector90
vector90:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $90
  102259:	6a 5a                	push   $0x5a
  jmp __alltraps
  10225b:	e9 4d 07 00 00       	jmp    1029ad <__alltraps>

00102260 <vector91>:
.globl vector91
vector91:
  pushl $0
  102260:	6a 00                	push   $0x0
  pushl $91
  102262:	6a 5b                	push   $0x5b
  jmp __alltraps
  102264:	e9 44 07 00 00       	jmp    1029ad <__alltraps>

00102269 <vector92>:
.globl vector92
vector92:
  pushl $0
  102269:	6a 00                	push   $0x0
  pushl $92
  10226b:	6a 5c                	push   $0x5c
  jmp __alltraps
  10226d:	e9 3b 07 00 00       	jmp    1029ad <__alltraps>

00102272 <vector93>:
.globl vector93
vector93:
  pushl $0
  102272:	6a 00                	push   $0x0
  pushl $93
  102274:	6a 5d                	push   $0x5d
  jmp __alltraps
  102276:	e9 32 07 00 00       	jmp    1029ad <__alltraps>

0010227b <vector94>:
.globl vector94
vector94:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $94
  10227d:	6a 5e                	push   $0x5e
  jmp __alltraps
  10227f:	e9 29 07 00 00       	jmp    1029ad <__alltraps>

00102284 <vector95>:
.globl vector95
vector95:
  pushl $0
  102284:	6a 00                	push   $0x0
  pushl $95
  102286:	6a 5f                	push   $0x5f
  jmp __alltraps
  102288:	e9 20 07 00 00       	jmp    1029ad <__alltraps>

0010228d <vector96>:
.globl vector96
vector96:
  pushl $0
  10228d:	6a 00                	push   $0x0
  pushl $96
  10228f:	6a 60                	push   $0x60
  jmp __alltraps
  102291:	e9 17 07 00 00       	jmp    1029ad <__alltraps>

00102296 <vector97>:
.globl vector97
vector97:
  pushl $0
  102296:	6a 00                	push   $0x0
  pushl $97
  102298:	6a 61                	push   $0x61
  jmp __alltraps
  10229a:	e9 0e 07 00 00       	jmp    1029ad <__alltraps>

0010229f <vector98>:
.globl vector98
vector98:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $98
  1022a1:	6a 62                	push   $0x62
  jmp __alltraps
  1022a3:	e9 05 07 00 00       	jmp    1029ad <__alltraps>

001022a8 <vector99>:
.globl vector99
vector99:
  pushl $0
  1022a8:	6a 00                	push   $0x0
  pushl $99
  1022aa:	6a 63                	push   $0x63
  jmp __alltraps
  1022ac:	e9 fc 06 00 00       	jmp    1029ad <__alltraps>

001022b1 <vector100>:
.globl vector100
vector100:
  pushl $0
  1022b1:	6a 00                	push   $0x0
  pushl $100
  1022b3:	6a 64                	push   $0x64
  jmp __alltraps
  1022b5:	e9 f3 06 00 00       	jmp    1029ad <__alltraps>

001022ba <vector101>:
.globl vector101
vector101:
  pushl $0
  1022ba:	6a 00                	push   $0x0
  pushl $101
  1022bc:	6a 65                	push   $0x65
  jmp __alltraps
  1022be:	e9 ea 06 00 00       	jmp    1029ad <__alltraps>

001022c3 <vector102>:
.globl vector102
vector102:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $102
  1022c5:	6a 66                	push   $0x66
  jmp __alltraps
  1022c7:	e9 e1 06 00 00       	jmp    1029ad <__alltraps>

001022cc <vector103>:
.globl vector103
vector103:
  pushl $0
  1022cc:	6a 00                	push   $0x0
  pushl $103
  1022ce:	6a 67                	push   $0x67
  jmp __alltraps
  1022d0:	e9 d8 06 00 00       	jmp    1029ad <__alltraps>

001022d5 <vector104>:
.globl vector104
vector104:
  pushl $0
  1022d5:	6a 00                	push   $0x0
  pushl $104
  1022d7:	6a 68                	push   $0x68
  jmp __alltraps
  1022d9:	e9 cf 06 00 00       	jmp    1029ad <__alltraps>

001022de <vector105>:
.globl vector105
vector105:
  pushl $0
  1022de:	6a 00                	push   $0x0
  pushl $105
  1022e0:	6a 69                	push   $0x69
  jmp __alltraps
  1022e2:	e9 c6 06 00 00       	jmp    1029ad <__alltraps>

001022e7 <vector106>:
.globl vector106
vector106:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $106
  1022e9:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022eb:	e9 bd 06 00 00       	jmp    1029ad <__alltraps>

001022f0 <vector107>:
.globl vector107
vector107:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $107
  1022f2:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022f4:	e9 b4 06 00 00       	jmp    1029ad <__alltraps>

001022f9 <vector108>:
.globl vector108
vector108:
  pushl $0
  1022f9:	6a 00                	push   $0x0
  pushl $108
  1022fb:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022fd:	e9 ab 06 00 00       	jmp    1029ad <__alltraps>

00102302 <vector109>:
.globl vector109
vector109:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $109
  102304:	6a 6d                	push   $0x6d
  jmp __alltraps
  102306:	e9 a2 06 00 00       	jmp    1029ad <__alltraps>

0010230b <vector110>:
.globl vector110
vector110:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $110
  10230d:	6a 6e                	push   $0x6e
  jmp __alltraps
  10230f:	e9 99 06 00 00       	jmp    1029ad <__alltraps>

00102314 <vector111>:
.globl vector111
vector111:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $111
  102316:	6a 6f                	push   $0x6f
  jmp __alltraps
  102318:	e9 90 06 00 00       	jmp    1029ad <__alltraps>

0010231d <vector112>:
.globl vector112
vector112:
  pushl $0
  10231d:	6a 00                	push   $0x0
  pushl $112
  10231f:	6a 70                	push   $0x70
  jmp __alltraps
  102321:	e9 87 06 00 00       	jmp    1029ad <__alltraps>

00102326 <vector113>:
.globl vector113
vector113:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $113
  102328:	6a 71                	push   $0x71
  jmp __alltraps
  10232a:	e9 7e 06 00 00       	jmp    1029ad <__alltraps>

0010232f <vector114>:
.globl vector114
vector114:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $114
  102331:	6a 72                	push   $0x72
  jmp __alltraps
  102333:	e9 75 06 00 00       	jmp    1029ad <__alltraps>

00102338 <vector115>:
.globl vector115
vector115:
  pushl $0
  102338:	6a 00                	push   $0x0
  pushl $115
  10233a:	6a 73                	push   $0x73
  jmp __alltraps
  10233c:	e9 6c 06 00 00       	jmp    1029ad <__alltraps>

00102341 <vector116>:
.globl vector116
vector116:
  pushl $0
  102341:	6a 00                	push   $0x0
  pushl $116
  102343:	6a 74                	push   $0x74
  jmp __alltraps
  102345:	e9 63 06 00 00       	jmp    1029ad <__alltraps>

0010234a <vector117>:
.globl vector117
vector117:
  pushl $0
  10234a:	6a 00                	push   $0x0
  pushl $117
  10234c:	6a 75                	push   $0x75
  jmp __alltraps
  10234e:	e9 5a 06 00 00       	jmp    1029ad <__alltraps>

00102353 <vector118>:
.globl vector118
vector118:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $118
  102355:	6a 76                	push   $0x76
  jmp __alltraps
  102357:	e9 51 06 00 00       	jmp    1029ad <__alltraps>

0010235c <vector119>:
.globl vector119
vector119:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $119
  10235e:	6a 77                	push   $0x77
  jmp __alltraps
  102360:	e9 48 06 00 00       	jmp    1029ad <__alltraps>

00102365 <vector120>:
.globl vector120
vector120:
  pushl $0
  102365:	6a 00                	push   $0x0
  pushl $120
  102367:	6a 78                	push   $0x78
  jmp __alltraps
  102369:	e9 3f 06 00 00       	jmp    1029ad <__alltraps>

0010236e <vector121>:
.globl vector121
vector121:
  pushl $0
  10236e:	6a 00                	push   $0x0
  pushl $121
  102370:	6a 79                	push   $0x79
  jmp __alltraps
  102372:	e9 36 06 00 00       	jmp    1029ad <__alltraps>

00102377 <vector122>:
.globl vector122
vector122:
  pushl $0
  102377:	6a 00                	push   $0x0
  pushl $122
  102379:	6a 7a                	push   $0x7a
  jmp __alltraps
  10237b:	e9 2d 06 00 00       	jmp    1029ad <__alltraps>

00102380 <vector123>:
.globl vector123
vector123:
  pushl $0
  102380:	6a 00                	push   $0x0
  pushl $123
  102382:	6a 7b                	push   $0x7b
  jmp __alltraps
  102384:	e9 24 06 00 00       	jmp    1029ad <__alltraps>

00102389 <vector124>:
.globl vector124
vector124:
  pushl $0
  102389:	6a 00                	push   $0x0
  pushl $124
  10238b:	6a 7c                	push   $0x7c
  jmp __alltraps
  10238d:	e9 1b 06 00 00       	jmp    1029ad <__alltraps>

00102392 <vector125>:
.globl vector125
vector125:
  pushl $0
  102392:	6a 00                	push   $0x0
  pushl $125
  102394:	6a 7d                	push   $0x7d
  jmp __alltraps
  102396:	e9 12 06 00 00       	jmp    1029ad <__alltraps>

0010239b <vector126>:
.globl vector126
vector126:
  pushl $0
  10239b:	6a 00                	push   $0x0
  pushl $126
  10239d:	6a 7e                	push   $0x7e
  jmp __alltraps
  10239f:	e9 09 06 00 00       	jmp    1029ad <__alltraps>

001023a4 <vector127>:
.globl vector127
vector127:
  pushl $0
  1023a4:	6a 00                	push   $0x0
  pushl $127
  1023a6:	6a 7f                	push   $0x7f
  jmp __alltraps
  1023a8:	e9 00 06 00 00       	jmp    1029ad <__alltraps>

001023ad <vector128>:
.globl vector128
vector128:
  pushl $0
  1023ad:	6a 00                	push   $0x0
  pushl $128
  1023af:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023b4:	e9 f4 05 00 00       	jmp    1029ad <__alltraps>

001023b9 <vector129>:
.globl vector129
vector129:
  pushl $0
  1023b9:	6a 00                	push   $0x0
  pushl $129
  1023bb:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1023c0:	e9 e8 05 00 00       	jmp    1029ad <__alltraps>

001023c5 <vector130>:
.globl vector130
vector130:
  pushl $0
  1023c5:	6a 00                	push   $0x0
  pushl $130
  1023c7:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1023cc:	e9 dc 05 00 00       	jmp    1029ad <__alltraps>

001023d1 <vector131>:
.globl vector131
vector131:
  pushl $0
  1023d1:	6a 00                	push   $0x0
  pushl $131
  1023d3:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023d8:	e9 d0 05 00 00       	jmp    1029ad <__alltraps>

001023dd <vector132>:
.globl vector132
vector132:
  pushl $0
  1023dd:	6a 00                	push   $0x0
  pushl $132
  1023df:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023e4:	e9 c4 05 00 00       	jmp    1029ad <__alltraps>

001023e9 <vector133>:
.globl vector133
vector133:
  pushl $0
  1023e9:	6a 00                	push   $0x0
  pushl $133
  1023eb:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023f0:	e9 b8 05 00 00       	jmp    1029ad <__alltraps>

001023f5 <vector134>:
.globl vector134
vector134:
  pushl $0
  1023f5:	6a 00                	push   $0x0
  pushl $134
  1023f7:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023fc:	e9 ac 05 00 00       	jmp    1029ad <__alltraps>

00102401 <vector135>:
.globl vector135
vector135:
  pushl $0
  102401:	6a 00                	push   $0x0
  pushl $135
  102403:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102408:	e9 a0 05 00 00       	jmp    1029ad <__alltraps>

0010240d <vector136>:
.globl vector136
vector136:
  pushl $0
  10240d:	6a 00                	push   $0x0
  pushl $136
  10240f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102414:	e9 94 05 00 00       	jmp    1029ad <__alltraps>

00102419 <vector137>:
.globl vector137
vector137:
  pushl $0
  102419:	6a 00                	push   $0x0
  pushl $137
  10241b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102420:	e9 88 05 00 00       	jmp    1029ad <__alltraps>

00102425 <vector138>:
.globl vector138
vector138:
  pushl $0
  102425:	6a 00                	push   $0x0
  pushl $138
  102427:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10242c:	e9 7c 05 00 00       	jmp    1029ad <__alltraps>

00102431 <vector139>:
.globl vector139
vector139:
  pushl $0
  102431:	6a 00                	push   $0x0
  pushl $139
  102433:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102438:	e9 70 05 00 00       	jmp    1029ad <__alltraps>

0010243d <vector140>:
.globl vector140
vector140:
  pushl $0
  10243d:	6a 00                	push   $0x0
  pushl $140
  10243f:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102444:	e9 64 05 00 00       	jmp    1029ad <__alltraps>

00102449 <vector141>:
.globl vector141
vector141:
  pushl $0
  102449:	6a 00                	push   $0x0
  pushl $141
  10244b:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102450:	e9 58 05 00 00       	jmp    1029ad <__alltraps>

00102455 <vector142>:
.globl vector142
vector142:
  pushl $0
  102455:	6a 00                	push   $0x0
  pushl $142
  102457:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10245c:	e9 4c 05 00 00       	jmp    1029ad <__alltraps>

00102461 <vector143>:
.globl vector143
vector143:
  pushl $0
  102461:	6a 00                	push   $0x0
  pushl $143
  102463:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102468:	e9 40 05 00 00       	jmp    1029ad <__alltraps>

0010246d <vector144>:
.globl vector144
vector144:
  pushl $0
  10246d:	6a 00                	push   $0x0
  pushl $144
  10246f:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102474:	e9 34 05 00 00       	jmp    1029ad <__alltraps>

00102479 <vector145>:
.globl vector145
vector145:
  pushl $0
  102479:	6a 00                	push   $0x0
  pushl $145
  10247b:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102480:	e9 28 05 00 00       	jmp    1029ad <__alltraps>

00102485 <vector146>:
.globl vector146
vector146:
  pushl $0
  102485:	6a 00                	push   $0x0
  pushl $146
  102487:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10248c:	e9 1c 05 00 00       	jmp    1029ad <__alltraps>

00102491 <vector147>:
.globl vector147
vector147:
  pushl $0
  102491:	6a 00                	push   $0x0
  pushl $147
  102493:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102498:	e9 10 05 00 00       	jmp    1029ad <__alltraps>

0010249d <vector148>:
.globl vector148
vector148:
  pushl $0
  10249d:	6a 00                	push   $0x0
  pushl $148
  10249f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1024a4:	e9 04 05 00 00       	jmp    1029ad <__alltraps>

001024a9 <vector149>:
.globl vector149
vector149:
  pushl $0
  1024a9:	6a 00                	push   $0x0
  pushl $149
  1024ab:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024b0:	e9 f8 04 00 00       	jmp    1029ad <__alltraps>

001024b5 <vector150>:
.globl vector150
vector150:
  pushl $0
  1024b5:	6a 00                	push   $0x0
  pushl $150
  1024b7:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1024bc:	e9 ec 04 00 00       	jmp    1029ad <__alltraps>

001024c1 <vector151>:
.globl vector151
vector151:
  pushl $0
  1024c1:	6a 00                	push   $0x0
  pushl $151
  1024c3:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1024c8:	e9 e0 04 00 00       	jmp    1029ad <__alltraps>

001024cd <vector152>:
.globl vector152
vector152:
  pushl $0
  1024cd:	6a 00                	push   $0x0
  pushl $152
  1024cf:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024d4:	e9 d4 04 00 00       	jmp    1029ad <__alltraps>

001024d9 <vector153>:
.globl vector153
vector153:
  pushl $0
  1024d9:	6a 00                	push   $0x0
  pushl $153
  1024db:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024e0:	e9 c8 04 00 00       	jmp    1029ad <__alltraps>

001024e5 <vector154>:
.globl vector154
vector154:
  pushl $0
  1024e5:	6a 00                	push   $0x0
  pushl $154
  1024e7:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024ec:	e9 bc 04 00 00       	jmp    1029ad <__alltraps>

001024f1 <vector155>:
.globl vector155
vector155:
  pushl $0
  1024f1:	6a 00                	push   $0x0
  pushl $155
  1024f3:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024f8:	e9 b0 04 00 00       	jmp    1029ad <__alltraps>

001024fd <vector156>:
.globl vector156
vector156:
  pushl $0
  1024fd:	6a 00                	push   $0x0
  pushl $156
  1024ff:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102504:	e9 a4 04 00 00       	jmp    1029ad <__alltraps>

00102509 <vector157>:
.globl vector157
vector157:
  pushl $0
  102509:	6a 00                	push   $0x0
  pushl $157
  10250b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102510:	e9 98 04 00 00       	jmp    1029ad <__alltraps>

00102515 <vector158>:
.globl vector158
vector158:
  pushl $0
  102515:	6a 00                	push   $0x0
  pushl $158
  102517:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10251c:	e9 8c 04 00 00       	jmp    1029ad <__alltraps>

00102521 <vector159>:
.globl vector159
vector159:
  pushl $0
  102521:	6a 00                	push   $0x0
  pushl $159
  102523:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102528:	e9 80 04 00 00       	jmp    1029ad <__alltraps>

0010252d <vector160>:
.globl vector160
vector160:
  pushl $0
  10252d:	6a 00                	push   $0x0
  pushl $160
  10252f:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102534:	e9 74 04 00 00       	jmp    1029ad <__alltraps>

00102539 <vector161>:
.globl vector161
vector161:
  pushl $0
  102539:	6a 00                	push   $0x0
  pushl $161
  10253b:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102540:	e9 68 04 00 00       	jmp    1029ad <__alltraps>

00102545 <vector162>:
.globl vector162
vector162:
  pushl $0
  102545:	6a 00                	push   $0x0
  pushl $162
  102547:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10254c:	e9 5c 04 00 00       	jmp    1029ad <__alltraps>

00102551 <vector163>:
.globl vector163
vector163:
  pushl $0
  102551:	6a 00                	push   $0x0
  pushl $163
  102553:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102558:	e9 50 04 00 00       	jmp    1029ad <__alltraps>

0010255d <vector164>:
.globl vector164
vector164:
  pushl $0
  10255d:	6a 00                	push   $0x0
  pushl $164
  10255f:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102564:	e9 44 04 00 00       	jmp    1029ad <__alltraps>

00102569 <vector165>:
.globl vector165
vector165:
  pushl $0
  102569:	6a 00                	push   $0x0
  pushl $165
  10256b:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102570:	e9 38 04 00 00       	jmp    1029ad <__alltraps>

00102575 <vector166>:
.globl vector166
vector166:
  pushl $0
  102575:	6a 00                	push   $0x0
  pushl $166
  102577:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10257c:	e9 2c 04 00 00       	jmp    1029ad <__alltraps>

00102581 <vector167>:
.globl vector167
vector167:
  pushl $0
  102581:	6a 00                	push   $0x0
  pushl $167
  102583:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102588:	e9 20 04 00 00       	jmp    1029ad <__alltraps>

0010258d <vector168>:
.globl vector168
vector168:
  pushl $0
  10258d:	6a 00                	push   $0x0
  pushl $168
  10258f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102594:	e9 14 04 00 00       	jmp    1029ad <__alltraps>

00102599 <vector169>:
.globl vector169
vector169:
  pushl $0
  102599:	6a 00                	push   $0x0
  pushl $169
  10259b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1025a0:	e9 08 04 00 00       	jmp    1029ad <__alltraps>

001025a5 <vector170>:
.globl vector170
vector170:
  pushl $0
  1025a5:	6a 00                	push   $0x0
  pushl $170
  1025a7:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025ac:	e9 fc 03 00 00       	jmp    1029ad <__alltraps>

001025b1 <vector171>:
.globl vector171
vector171:
  pushl $0
  1025b1:	6a 00                	push   $0x0
  pushl $171
  1025b3:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1025b8:	e9 f0 03 00 00       	jmp    1029ad <__alltraps>

001025bd <vector172>:
.globl vector172
vector172:
  pushl $0
  1025bd:	6a 00                	push   $0x0
  pushl $172
  1025bf:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1025c4:	e9 e4 03 00 00       	jmp    1029ad <__alltraps>

001025c9 <vector173>:
.globl vector173
vector173:
  pushl $0
  1025c9:	6a 00                	push   $0x0
  pushl $173
  1025cb:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025d0:	e9 d8 03 00 00       	jmp    1029ad <__alltraps>

001025d5 <vector174>:
.globl vector174
vector174:
  pushl $0
  1025d5:	6a 00                	push   $0x0
  pushl $174
  1025d7:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025dc:	e9 cc 03 00 00       	jmp    1029ad <__alltraps>

001025e1 <vector175>:
.globl vector175
vector175:
  pushl $0
  1025e1:	6a 00                	push   $0x0
  pushl $175
  1025e3:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025e8:	e9 c0 03 00 00       	jmp    1029ad <__alltraps>

001025ed <vector176>:
.globl vector176
vector176:
  pushl $0
  1025ed:	6a 00                	push   $0x0
  pushl $176
  1025ef:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025f4:	e9 b4 03 00 00       	jmp    1029ad <__alltraps>

001025f9 <vector177>:
.globl vector177
vector177:
  pushl $0
  1025f9:	6a 00                	push   $0x0
  pushl $177
  1025fb:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102600:	e9 a8 03 00 00       	jmp    1029ad <__alltraps>

00102605 <vector178>:
.globl vector178
vector178:
  pushl $0
  102605:	6a 00                	push   $0x0
  pushl $178
  102607:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10260c:	e9 9c 03 00 00       	jmp    1029ad <__alltraps>

00102611 <vector179>:
.globl vector179
vector179:
  pushl $0
  102611:	6a 00                	push   $0x0
  pushl $179
  102613:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102618:	e9 90 03 00 00       	jmp    1029ad <__alltraps>

0010261d <vector180>:
.globl vector180
vector180:
  pushl $0
  10261d:	6a 00                	push   $0x0
  pushl $180
  10261f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102624:	e9 84 03 00 00       	jmp    1029ad <__alltraps>

00102629 <vector181>:
.globl vector181
vector181:
  pushl $0
  102629:	6a 00                	push   $0x0
  pushl $181
  10262b:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102630:	e9 78 03 00 00       	jmp    1029ad <__alltraps>

00102635 <vector182>:
.globl vector182
vector182:
  pushl $0
  102635:	6a 00                	push   $0x0
  pushl $182
  102637:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10263c:	e9 6c 03 00 00       	jmp    1029ad <__alltraps>

00102641 <vector183>:
.globl vector183
vector183:
  pushl $0
  102641:	6a 00                	push   $0x0
  pushl $183
  102643:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102648:	e9 60 03 00 00       	jmp    1029ad <__alltraps>

0010264d <vector184>:
.globl vector184
vector184:
  pushl $0
  10264d:	6a 00                	push   $0x0
  pushl $184
  10264f:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102654:	e9 54 03 00 00       	jmp    1029ad <__alltraps>

00102659 <vector185>:
.globl vector185
vector185:
  pushl $0
  102659:	6a 00                	push   $0x0
  pushl $185
  10265b:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102660:	e9 48 03 00 00       	jmp    1029ad <__alltraps>

00102665 <vector186>:
.globl vector186
vector186:
  pushl $0
  102665:	6a 00                	push   $0x0
  pushl $186
  102667:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10266c:	e9 3c 03 00 00       	jmp    1029ad <__alltraps>

00102671 <vector187>:
.globl vector187
vector187:
  pushl $0
  102671:	6a 00                	push   $0x0
  pushl $187
  102673:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102678:	e9 30 03 00 00       	jmp    1029ad <__alltraps>

0010267d <vector188>:
.globl vector188
vector188:
  pushl $0
  10267d:	6a 00                	push   $0x0
  pushl $188
  10267f:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102684:	e9 24 03 00 00       	jmp    1029ad <__alltraps>

00102689 <vector189>:
.globl vector189
vector189:
  pushl $0
  102689:	6a 00                	push   $0x0
  pushl $189
  10268b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102690:	e9 18 03 00 00       	jmp    1029ad <__alltraps>

00102695 <vector190>:
.globl vector190
vector190:
  pushl $0
  102695:	6a 00                	push   $0x0
  pushl $190
  102697:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10269c:	e9 0c 03 00 00       	jmp    1029ad <__alltraps>

001026a1 <vector191>:
.globl vector191
vector191:
  pushl $0
  1026a1:	6a 00                	push   $0x0
  pushl $191
  1026a3:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1026a8:	e9 00 03 00 00       	jmp    1029ad <__alltraps>

001026ad <vector192>:
.globl vector192
vector192:
  pushl $0
  1026ad:	6a 00                	push   $0x0
  pushl $192
  1026af:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026b4:	e9 f4 02 00 00       	jmp    1029ad <__alltraps>

001026b9 <vector193>:
.globl vector193
vector193:
  pushl $0
  1026b9:	6a 00                	push   $0x0
  pushl $193
  1026bb:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1026c0:	e9 e8 02 00 00       	jmp    1029ad <__alltraps>

001026c5 <vector194>:
.globl vector194
vector194:
  pushl $0
  1026c5:	6a 00                	push   $0x0
  pushl $194
  1026c7:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1026cc:	e9 dc 02 00 00       	jmp    1029ad <__alltraps>

001026d1 <vector195>:
.globl vector195
vector195:
  pushl $0
  1026d1:	6a 00                	push   $0x0
  pushl $195
  1026d3:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026d8:	e9 d0 02 00 00       	jmp    1029ad <__alltraps>

001026dd <vector196>:
.globl vector196
vector196:
  pushl $0
  1026dd:	6a 00                	push   $0x0
  pushl $196
  1026df:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026e4:	e9 c4 02 00 00       	jmp    1029ad <__alltraps>

001026e9 <vector197>:
.globl vector197
vector197:
  pushl $0
  1026e9:	6a 00                	push   $0x0
  pushl $197
  1026eb:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026f0:	e9 b8 02 00 00       	jmp    1029ad <__alltraps>

001026f5 <vector198>:
.globl vector198
vector198:
  pushl $0
  1026f5:	6a 00                	push   $0x0
  pushl $198
  1026f7:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026fc:	e9 ac 02 00 00       	jmp    1029ad <__alltraps>

00102701 <vector199>:
.globl vector199
vector199:
  pushl $0
  102701:	6a 00                	push   $0x0
  pushl $199
  102703:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102708:	e9 a0 02 00 00       	jmp    1029ad <__alltraps>

0010270d <vector200>:
.globl vector200
vector200:
  pushl $0
  10270d:	6a 00                	push   $0x0
  pushl $200
  10270f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102714:	e9 94 02 00 00       	jmp    1029ad <__alltraps>

00102719 <vector201>:
.globl vector201
vector201:
  pushl $0
  102719:	6a 00                	push   $0x0
  pushl $201
  10271b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102720:	e9 88 02 00 00       	jmp    1029ad <__alltraps>

00102725 <vector202>:
.globl vector202
vector202:
  pushl $0
  102725:	6a 00                	push   $0x0
  pushl $202
  102727:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10272c:	e9 7c 02 00 00       	jmp    1029ad <__alltraps>

00102731 <vector203>:
.globl vector203
vector203:
  pushl $0
  102731:	6a 00                	push   $0x0
  pushl $203
  102733:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102738:	e9 70 02 00 00       	jmp    1029ad <__alltraps>

0010273d <vector204>:
.globl vector204
vector204:
  pushl $0
  10273d:	6a 00                	push   $0x0
  pushl $204
  10273f:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102744:	e9 64 02 00 00       	jmp    1029ad <__alltraps>

00102749 <vector205>:
.globl vector205
vector205:
  pushl $0
  102749:	6a 00                	push   $0x0
  pushl $205
  10274b:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102750:	e9 58 02 00 00       	jmp    1029ad <__alltraps>

00102755 <vector206>:
.globl vector206
vector206:
  pushl $0
  102755:	6a 00                	push   $0x0
  pushl $206
  102757:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10275c:	e9 4c 02 00 00       	jmp    1029ad <__alltraps>

00102761 <vector207>:
.globl vector207
vector207:
  pushl $0
  102761:	6a 00                	push   $0x0
  pushl $207
  102763:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102768:	e9 40 02 00 00       	jmp    1029ad <__alltraps>

0010276d <vector208>:
.globl vector208
vector208:
  pushl $0
  10276d:	6a 00                	push   $0x0
  pushl $208
  10276f:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102774:	e9 34 02 00 00       	jmp    1029ad <__alltraps>

00102779 <vector209>:
.globl vector209
vector209:
  pushl $0
  102779:	6a 00                	push   $0x0
  pushl $209
  10277b:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102780:	e9 28 02 00 00       	jmp    1029ad <__alltraps>

00102785 <vector210>:
.globl vector210
vector210:
  pushl $0
  102785:	6a 00                	push   $0x0
  pushl $210
  102787:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10278c:	e9 1c 02 00 00       	jmp    1029ad <__alltraps>

00102791 <vector211>:
.globl vector211
vector211:
  pushl $0
  102791:	6a 00                	push   $0x0
  pushl $211
  102793:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102798:	e9 10 02 00 00       	jmp    1029ad <__alltraps>

0010279d <vector212>:
.globl vector212
vector212:
  pushl $0
  10279d:	6a 00                	push   $0x0
  pushl $212
  10279f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1027a4:	e9 04 02 00 00       	jmp    1029ad <__alltraps>

001027a9 <vector213>:
.globl vector213
vector213:
  pushl $0
  1027a9:	6a 00                	push   $0x0
  pushl $213
  1027ab:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027b0:	e9 f8 01 00 00       	jmp    1029ad <__alltraps>

001027b5 <vector214>:
.globl vector214
vector214:
  pushl $0
  1027b5:	6a 00                	push   $0x0
  pushl $214
  1027b7:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1027bc:	e9 ec 01 00 00       	jmp    1029ad <__alltraps>

001027c1 <vector215>:
.globl vector215
vector215:
  pushl $0
  1027c1:	6a 00                	push   $0x0
  pushl $215
  1027c3:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1027c8:	e9 e0 01 00 00       	jmp    1029ad <__alltraps>

001027cd <vector216>:
.globl vector216
vector216:
  pushl $0
  1027cd:	6a 00                	push   $0x0
  pushl $216
  1027cf:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027d4:	e9 d4 01 00 00       	jmp    1029ad <__alltraps>

001027d9 <vector217>:
.globl vector217
vector217:
  pushl $0
  1027d9:	6a 00                	push   $0x0
  pushl $217
  1027db:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027e0:	e9 c8 01 00 00       	jmp    1029ad <__alltraps>

001027e5 <vector218>:
.globl vector218
vector218:
  pushl $0
  1027e5:	6a 00                	push   $0x0
  pushl $218
  1027e7:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027ec:	e9 bc 01 00 00       	jmp    1029ad <__alltraps>

001027f1 <vector219>:
.globl vector219
vector219:
  pushl $0
  1027f1:	6a 00                	push   $0x0
  pushl $219
  1027f3:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027f8:	e9 b0 01 00 00       	jmp    1029ad <__alltraps>

001027fd <vector220>:
.globl vector220
vector220:
  pushl $0
  1027fd:	6a 00                	push   $0x0
  pushl $220
  1027ff:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102804:	e9 a4 01 00 00       	jmp    1029ad <__alltraps>

00102809 <vector221>:
.globl vector221
vector221:
  pushl $0
  102809:	6a 00                	push   $0x0
  pushl $221
  10280b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102810:	e9 98 01 00 00       	jmp    1029ad <__alltraps>

00102815 <vector222>:
.globl vector222
vector222:
  pushl $0
  102815:	6a 00                	push   $0x0
  pushl $222
  102817:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10281c:	e9 8c 01 00 00       	jmp    1029ad <__alltraps>

00102821 <vector223>:
.globl vector223
vector223:
  pushl $0
  102821:	6a 00                	push   $0x0
  pushl $223
  102823:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102828:	e9 80 01 00 00       	jmp    1029ad <__alltraps>

0010282d <vector224>:
.globl vector224
vector224:
  pushl $0
  10282d:	6a 00                	push   $0x0
  pushl $224
  10282f:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102834:	e9 74 01 00 00       	jmp    1029ad <__alltraps>

00102839 <vector225>:
.globl vector225
vector225:
  pushl $0
  102839:	6a 00                	push   $0x0
  pushl $225
  10283b:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102840:	e9 68 01 00 00       	jmp    1029ad <__alltraps>

00102845 <vector226>:
.globl vector226
vector226:
  pushl $0
  102845:	6a 00                	push   $0x0
  pushl $226
  102847:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10284c:	e9 5c 01 00 00       	jmp    1029ad <__alltraps>

00102851 <vector227>:
.globl vector227
vector227:
  pushl $0
  102851:	6a 00                	push   $0x0
  pushl $227
  102853:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102858:	e9 50 01 00 00       	jmp    1029ad <__alltraps>

0010285d <vector228>:
.globl vector228
vector228:
  pushl $0
  10285d:	6a 00                	push   $0x0
  pushl $228
  10285f:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102864:	e9 44 01 00 00       	jmp    1029ad <__alltraps>

00102869 <vector229>:
.globl vector229
vector229:
  pushl $0
  102869:	6a 00                	push   $0x0
  pushl $229
  10286b:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102870:	e9 38 01 00 00       	jmp    1029ad <__alltraps>

00102875 <vector230>:
.globl vector230
vector230:
  pushl $0
  102875:	6a 00                	push   $0x0
  pushl $230
  102877:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10287c:	e9 2c 01 00 00       	jmp    1029ad <__alltraps>

00102881 <vector231>:
.globl vector231
vector231:
  pushl $0
  102881:	6a 00                	push   $0x0
  pushl $231
  102883:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102888:	e9 20 01 00 00       	jmp    1029ad <__alltraps>

0010288d <vector232>:
.globl vector232
vector232:
  pushl $0
  10288d:	6a 00                	push   $0x0
  pushl $232
  10288f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102894:	e9 14 01 00 00       	jmp    1029ad <__alltraps>

00102899 <vector233>:
.globl vector233
vector233:
  pushl $0
  102899:	6a 00                	push   $0x0
  pushl $233
  10289b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1028a0:	e9 08 01 00 00       	jmp    1029ad <__alltraps>

001028a5 <vector234>:
.globl vector234
vector234:
  pushl $0
  1028a5:	6a 00                	push   $0x0
  pushl $234
  1028a7:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028ac:	e9 fc 00 00 00       	jmp    1029ad <__alltraps>

001028b1 <vector235>:
.globl vector235
vector235:
  pushl $0
  1028b1:	6a 00                	push   $0x0
  pushl $235
  1028b3:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1028b8:	e9 f0 00 00 00       	jmp    1029ad <__alltraps>

001028bd <vector236>:
.globl vector236
vector236:
  pushl $0
  1028bd:	6a 00                	push   $0x0
  pushl $236
  1028bf:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1028c4:	e9 e4 00 00 00       	jmp    1029ad <__alltraps>

001028c9 <vector237>:
.globl vector237
vector237:
  pushl $0
  1028c9:	6a 00                	push   $0x0
  pushl $237
  1028cb:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028d0:	e9 d8 00 00 00       	jmp    1029ad <__alltraps>

001028d5 <vector238>:
.globl vector238
vector238:
  pushl $0
  1028d5:	6a 00                	push   $0x0
  pushl $238
  1028d7:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028dc:	e9 cc 00 00 00       	jmp    1029ad <__alltraps>

001028e1 <vector239>:
.globl vector239
vector239:
  pushl $0
  1028e1:	6a 00                	push   $0x0
  pushl $239
  1028e3:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028e8:	e9 c0 00 00 00       	jmp    1029ad <__alltraps>

001028ed <vector240>:
.globl vector240
vector240:
  pushl $0
  1028ed:	6a 00                	push   $0x0
  pushl $240
  1028ef:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028f4:	e9 b4 00 00 00       	jmp    1029ad <__alltraps>

001028f9 <vector241>:
.globl vector241
vector241:
  pushl $0
  1028f9:	6a 00                	push   $0x0
  pushl $241
  1028fb:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102900:	e9 a8 00 00 00       	jmp    1029ad <__alltraps>

00102905 <vector242>:
.globl vector242
vector242:
  pushl $0
  102905:	6a 00                	push   $0x0
  pushl $242
  102907:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10290c:	e9 9c 00 00 00       	jmp    1029ad <__alltraps>

00102911 <vector243>:
.globl vector243
vector243:
  pushl $0
  102911:	6a 00                	push   $0x0
  pushl $243
  102913:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102918:	e9 90 00 00 00       	jmp    1029ad <__alltraps>

0010291d <vector244>:
.globl vector244
vector244:
  pushl $0
  10291d:	6a 00                	push   $0x0
  pushl $244
  10291f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102924:	e9 84 00 00 00       	jmp    1029ad <__alltraps>

00102929 <vector245>:
.globl vector245
vector245:
  pushl $0
  102929:	6a 00                	push   $0x0
  pushl $245
  10292b:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102930:	e9 78 00 00 00       	jmp    1029ad <__alltraps>

00102935 <vector246>:
.globl vector246
vector246:
  pushl $0
  102935:	6a 00                	push   $0x0
  pushl $246
  102937:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10293c:	e9 6c 00 00 00       	jmp    1029ad <__alltraps>

00102941 <vector247>:
.globl vector247
vector247:
  pushl $0
  102941:	6a 00                	push   $0x0
  pushl $247
  102943:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102948:	e9 60 00 00 00       	jmp    1029ad <__alltraps>

0010294d <vector248>:
.globl vector248
vector248:
  pushl $0
  10294d:	6a 00                	push   $0x0
  pushl $248
  10294f:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102954:	e9 54 00 00 00       	jmp    1029ad <__alltraps>

00102959 <vector249>:
.globl vector249
vector249:
  pushl $0
  102959:	6a 00                	push   $0x0
  pushl $249
  10295b:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102960:	e9 48 00 00 00       	jmp    1029ad <__alltraps>

00102965 <vector250>:
.globl vector250
vector250:
  pushl $0
  102965:	6a 00                	push   $0x0
  pushl $250
  102967:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10296c:	e9 3c 00 00 00       	jmp    1029ad <__alltraps>

00102971 <vector251>:
.globl vector251
vector251:
  pushl $0
  102971:	6a 00                	push   $0x0
  pushl $251
  102973:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102978:	e9 30 00 00 00       	jmp    1029ad <__alltraps>

0010297d <vector252>:
.globl vector252
vector252:
  pushl $0
  10297d:	6a 00                	push   $0x0
  pushl $252
  10297f:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102984:	e9 24 00 00 00       	jmp    1029ad <__alltraps>

00102989 <vector253>:
.globl vector253
vector253:
  pushl $0
  102989:	6a 00                	push   $0x0
  pushl $253
  10298b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102990:	e9 18 00 00 00       	jmp    1029ad <__alltraps>

00102995 <vector254>:
.globl vector254
vector254:
  pushl $0
  102995:	6a 00                	push   $0x0
  pushl $254
  102997:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10299c:	e9 0c 00 00 00       	jmp    1029ad <__alltraps>

001029a1 <vector255>:
.globl vector255
vector255:
  pushl $0
  1029a1:	6a 00                	push   $0x0
  pushl $255
  1029a3:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1029a8:	e9 00 00 00 00       	jmp    1029ad <__alltraps>

001029ad <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1029ad:	1e                   	push   %ds
    pushl %es
  1029ae:	06                   	push   %es
    pushl %fs
  1029af:	0f a0                	push   %fs
    pushl %gs
  1029b1:	0f a8                	push   %gs
    pushal
  1029b3:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1029b4:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1029b9:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1029bb:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1029bd:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1029be:	e8 67 f5 ff ff       	call   101f2a <trap>

    # pop the pushed stack pointer
    popl %esp
  1029c3:	5c                   	pop    %esp

001029c4 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1029c4:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1029c5:	0f a9                	pop    %gs
    popl %fs
  1029c7:	0f a1                	pop    %fs
    popl %es
  1029c9:	07                   	pop    %es
    popl %ds
  1029ca:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1029cb:	83 c4 08             	add    $0x8,%esp
    iret
  1029ce:	cf                   	iret   

001029cf <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1029cf:	55                   	push   %ebp
  1029d0:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1029d2:	8b 55 08             	mov    0x8(%ebp),%edx
  1029d5:	a1 58 89 11 00       	mov    0x118958,%eax
  1029da:	29 c2                	sub    %eax,%edx
  1029dc:	89 d0                	mov    %edx,%eax
  1029de:	c1 f8 02             	sar    $0x2,%eax
  1029e1:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1029e7:	5d                   	pop    %ebp
  1029e8:	c3                   	ret    

001029e9 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1029e9:	55                   	push   %ebp
  1029ea:	89 e5                	mov    %esp,%ebp
  1029ec:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f2:	89 04 24             	mov    %eax,(%esp)
  1029f5:	e8 d5 ff ff ff       	call   1029cf <page2ppn>
  1029fa:	c1 e0 0c             	shl    $0xc,%eax
}
  1029fd:	c9                   	leave  
  1029fe:	c3                   	ret    

001029ff <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1029ff:	55                   	push   %ebp
  102a00:	89 e5                	mov    %esp,%ebp
  102a02:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102a05:	8b 45 08             	mov    0x8(%ebp),%eax
  102a08:	c1 e8 0c             	shr    $0xc,%eax
  102a0b:	89 c2                	mov    %eax,%edx
  102a0d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102a12:	39 c2                	cmp    %eax,%edx
  102a14:	72 1c                	jb     102a32 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102a16:	c7 44 24 08 b0 68 10 	movl   $0x1068b0,0x8(%esp)
  102a1d:	00 
  102a1e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102a25:	00 
  102a26:	c7 04 24 cf 68 10 00 	movl   $0x1068cf,(%esp)
  102a2d:	e8 b6 d9 ff ff       	call   1003e8 <__panic>
    }
    return &pages[PPN(pa)];
  102a32:	8b 0d 58 89 11 00    	mov    0x118958,%ecx
  102a38:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3b:	c1 e8 0c             	shr    $0xc,%eax
  102a3e:	89 c2                	mov    %eax,%edx
  102a40:	89 d0                	mov    %edx,%eax
  102a42:	c1 e0 02             	shl    $0x2,%eax
  102a45:	01 d0                	add    %edx,%eax
  102a47:	c1 e0 02             	shl    $0x2,%eax
  102a4a:	01 c8                	add    %ecx,%eax
}
  102a4c:	c9                   	leave  
  102a4d:	c3                   	ret    

00102a4e <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102a4e:	55                   	push   %ebp
  102a4f:	89 e5                	mov    %esp,%ebp
  102a51:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102a54:	8b 45 08             	mov    0x8(%ebp),%eax
  102a57:	89 04 24             	mov    %eax,(%esp)
  102a5a:	e8 8a ff ff ff       	call   1029e9 <page2pa>
  102a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a65:	c1 e8 0c             	shr    $0xc,%eax
  102a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a6b:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102a70:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102a73:	72 23                	jb     102a98 <page2kva+0x4a>
  102a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a78:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102a7c:	c7 44 24 08 e0 68 10 	movl   $0x1068e0,0x8(%esp)
  102a83:	00 
  102a84:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102a8b:	00 
  102a8c:	c7 04 24 cf 68 10 00 	movl   $0x1068cf,(%esp)
  102a93:	e8 50 d9 ff ff       	call   1003e8 <__panic>
  102a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a9b:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102aa0:	c9                   	leave  
  102aa1:	c3                   	ret    

00102aa2 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102aa2:	55                   	push   %ebp
  102aa3:	89 e5                	mov    %esp,%ebp
  102aa5:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  102aab:	83 e0 01             	and    $0x1,%eax
  102aae:	85 c0                	test   %eax,%eax
  102ab0:	75 1c                	jne    102ace <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102ab2:	c7 44 24 08 04 69 10 	movl   $0x106904,0x8(%esp)
  102ab9:	00 
  102aba:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102ac1:	00 
  102ac2:	c7 04 24 cf 68 10 00 	movl   $0x1068cf,(%esp)
  102ac9:	e8 1a d9 ff ff       	call   1003e8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102ace:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102ad6:	89 04 24             	mov    %eax,(%esp)
  102ad9:	e8 21 ff ff ff       	call   1029ff <pa2page>
}
  102ade:	c9                   	leave  
  102adf:	c3                   	ret    

00102ae0 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102ae0:	55                   	push   %ebp
  102ae1:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae6:	8b 00                	mov    (%eax),%eax
}
  102ae8:	5d                   	pop    %ebp
  102ae9:	c3                   	ret    

00102aea <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102aea:	55                   	push   %ebp
  102aeb:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102aed:	8b 45 08             	mov    0x8(%ebp),%eax
  102af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  102af3:	89 10                	mov    %edx,(%eax)
}
  102af5:	5d                   	pop    %ebp
  102af6:	c3                   	ret    

00102af7 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102af7:	55                   	push   %ebp
  102af8:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102afa:	8b 45 08             	mov    0x8(%ebp),%eax
  102afd:	8b 00                	mov    (%eax),%eax
  102aff:	8d 50 01             	lea    0x1(%eax),%edx
  102b02:	8b 45 08             	mov    0x8(%ebp),%eax
  102b05:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102b07:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0a:	8b 00                	mov    (%eax),%eax
}
  102b0c:	5d                   	pop    %ebp
  102b0d:	c3                   	ret    

00102b0e <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102b0e:	55                   	push   %ebp
  102b0f:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102b11:	8b 45 08             	mov    0x8(%ebp),%eax
  102b14:	8b 00                	mov    (%eax),%eax
  102b16:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b19:	8b 45 08             	mov    0x8(%ebp),%eax
  102b1c:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b21:	8b 00                	mov    (%eax),%eax
}
  102b23:	5d                   	pop    %ebp
  102b24:	c3                   	ret    

00102b25 <__intr_save>:
__intr_save(void) {
  102b25:	55                   	push   %ebp
  102b26:	89 e5                	mov    %esp,%ebp
  102b28:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102b2b:	9c                   	pushf  
  102b2c:	58                   	pop    %eax
  102b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102b33:	25 00 02 00 00       	and    $0x200,%eax
  102b38:	85 c0                	test   %eax,%eax
  102b3a:	74 0c                	je     102b48 <__intr_save+0x23>
        intr_disable();
  102b3c:	e8 3b ed ff ff       	call   10187c <intr_disable>
        return 1;
  102b41:	b8 01 00 00 00       	mov    $0x1,%eax
  102b46:	eb 05                	jmp    102b4d <__intr_save+0x28>
    return 0;
  102b48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b4d:	c9                   	leave  
  102b4e:	c3                   	ret    

00102b4f <__intr_restore>:
__intr_restore(bool flag) {
  102b4f:	55                   	push   %ebp
  102b50:	89 e5                	mov    %esp,%ebp
  102b52:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102b55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102b59:	74 05                	je     102b60 <__intr_restore+0x11>
        intr_enable();
  102b5b:	e8 16 ed ff ff       	call   101876 <intr_enable>
}
  102b60:	c9                   	leave  
  102b61:	c3                   	ret    

00102b62 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102b62:	55                   	push   %ebp
  102b63:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102b65:	8b 45 08             	mov    0x8(%ebp),%eax
  102b68:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102b6b:	b8 23 00 00 00       	mov    $0x23,%eax
  102b70:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102b72:	b8 23 00 00 00       	mov    $0x23,%eax
  102b77:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102b79:	b8 10 00 00 00       	mov    $0x10,%eax
  102b7e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b80:	b8 10 00 00 00       	mov    $0x10,%eax
  102b85:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102b87:	b8 10 00 00 00       	mov    $0x10,%eax
  102b8c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102b8e:	ea 95 2b 10 00 08 00 	ljmp   $0x8,$0x102b95
}
  102b95:	5d                   	pop    %ebp
  102b96:	c3                   	ret    

00102b97 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102b97:	55                   	push   %ebp
  102b98:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b9d:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  102ba2:	5d                   	pop    %ebp
  102ba3:	c3                   	ret    

00102ba4 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102ba4:	55                   	push   %ebp
  102ba5:	89 e5                	mov    %esp,%ebp
  102ba7:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102baa:	b8 00 70 11 00       	mov    $0x117000,%eax
  102baf:	89 04 24             	mov    %eax,(%esp)
  102bb2:	e8 e0 ff ff ff       	call   102b97 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102bb7:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  102bbe:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102bc0:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  102bc7:	68 00 
  102bc9:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102bce:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  102bd4:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102bd9:	c1 e8 10             	shr    $0x10,%eax
  102bdc:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  102be1:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102be8:	83 e0 f0             	and    $0xfffffff0,%eax
  102beb:	83 c8 09             	or     $0x9,%eax
  102bee:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102bf3:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102bfa:	83 e0 ef             	and    $0xffffffef,%eax
  102bfd:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102c02:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102c09:	83 e0 9f             	and    $0xffffff9f,%eax
  102c0c:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102c11:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102c18:	83 c8 80             	or     $0xffffff80,%eax
  102c1b:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102c20:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102c27:	83 e0 f0             	and    $0xfffffff0,%eax
  102c2a:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c2f:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102c36:	83 e0 ef             	and    $0xffffffef,%eax
  102c39:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c3e:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102c45:	83 e0 df             	and    $0xffffffdf,%eax
  102c48:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c4d:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102c54:	83 c8 40             	or     $0x40,%eax
  102c57:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c5c:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102c63:	83 e0 7f             	and    $0x7f,%eax
  102c66:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c6b:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102c70:	c1 e8 18             	shr    $0x18,%eax
  102c73:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102c78:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  102c7f:	e8 de fe ff ff       	call   102b62 <lgdt>
  102c84:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102c8a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102c8e:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102c91:	c9                   	leave  
  102c92:	c3                   	ret    

00102c93 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102c93:	55                   	push   %ebp
  102c94:	89 e5                	mov    %esp,%ebp
  102c96:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102c99:	c7 05 50 89 11 00 a0 	movl   $0x1072a0,0x118950
  102ca0:	72 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102ca3:	a1 50 89 11 00       	mov    0x118950,%eax
  102ca8:	8b 00                	mov    (%eax),%eax
  102caa:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cae:	c7 04 24 30 69 10 00 	movl   $0x106930,(%esp)
  102cb5:	e8 d7 d5 ff ff       	call   100291 <cprintf>
    pmm_manager->init();
  102cba:	a1 50 89 11 00       	mov    0x118950,%eax
  102cbf:	8b 40 04             	mov    0x4(%eax),%eax
  102cc2:	ff d0                	call   *%eax
}
  102cc4:	c9                   	leave  
  102cc5:	c3                   	ret    

00102cc6 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102cc6:	55                   	push   %ebp
  102cc7:	89 e5                	mov    %esp,%ebp
  102cc9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102ccc:	a1 50 89 11 00       	mov    0x118950,%eax
  102cd1:	8b 40 08             	mov    0x8(%eax),%eax
  102cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cd7:	89 54 24 04          	mov    %edx,0x4(%esp)
  102cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  102cde:	89 14 24             	mov    %edx,(%esp)
  102ce1:	ff d0                	call   *%eax
}
  102ce3:	c9                   	leave  
  102ce4:	c3                   	ret    

00102ce5 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102ce5:	55                   	push   %ebp
  102ce6:	89 e5                	mov    %esp,%ebp
  102ce8:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102ceb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102cf2:	e8 2e fe ff ff       	call   102b25 <__intr_save>
  102cf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102cfa:	a1 50 89 11 00       	mov    0x118950,%eax
  102cff:	8b 40 0c             	mov    0xc(%eax),%eax
  102d02:	8b 55 08             	mov    0x8(%ebp),%edx
  102d05:	89 14 24             	mov    %edx,(%esp)
  102d08:	ff d0                	call   *%eax
  102d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d10:	89 04 24             	mov    %eax,(%esp)
  102d13:	e8 37 fe ff ff       	call   102b4f <__intr_restore>
    return page;
  102d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102d1b:	c9                   	leave  
  102d1c:	c3                   	ret    

00102d1d <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102d1d:	55                   	push   %ebp
  102d1e:	89 e5                	mov    %esp,%ebp
  102d20:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102d23:	e8 fd fd ff ff       	call   102b25 <__intr_save>
  102d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102d2b:	a1 50 89 11 00       	mov    0x118950,%eax
  102d30:	8b 40 10             	mov    0x10(%eax),%eax
  102d33:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d36:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  102d3d:	89 14 24             	mov    %edx,(%esp)
  102d40:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d45:	89 04 24             	mov    %eax,(%esp)
  102d48:	e8 02 fe ff ff       	call   102b4f <__intr_restore>
}
  102d4d:	c9                   	leave  
  102d4e:	c3                   	ret    

00102d4f <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102d4f:	55                   	push   %ebp
  102d50:	89 e5                	mov    %esp,%ebp
  102d52:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102d55:	e8 cb fd ff ff       	call   102b25 <__intr_save>
  102d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102d5d:	a1 50 89 11 00       	mov    0x118950,%eax
  102d62:	8b 40 14             	mov    0x14(%eax),%eax
  102d65:	ff d0                	call   *%eax
  102d67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d6d:	89 04 24             	mov    %eax,(%esp)
  102d70:	e8 da fd ff ff       	call   102b4f <__intr_restore>
    return ret;
  102d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102d78:	c9                   	leave  
  102d79:	c3                   	ret    

00102d7a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102d7a:	55                   	push   %ebp
  102d7b:	89 e5                	mov    %esp,%ebp
  102d7d:	57                   	push   %edi
  102d7e:	56                   	push   %esi
  102d7f:	53                   	push   %ebx
  102d80:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102d86:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102d8d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102d94:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102d9b:	c7 04 24 47 69 10 00 	movl   $0x106947,(%esp)
  102da2:	e8 ea d4 ff ff       	call   100291 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102da7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102dae:	e9 15 01 00 00       	jmp    102ec8 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102db3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102db6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102db9:	89 d0                	mov    %edx,%eax
  102dbb:	c1 e0 02             	shl    $0x2,%eax
  102dbe:	01 d0                	add    %edx,%eax
  102dc0:	c1 e0 02             	shl    $0x2,%eax
  102dc3:	01 c8                	add    %ecx,%eax
  102dc5:	8b 50 08             	mov    0x8(%eax),%edx
  102dc8:	8b 40 04             	mov    0x4(%eax),%eax
  102dcb:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102dce:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102dd1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102dd4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102dd7:	89 d0                	mov    %edx,%eax
  102dd9:	c1 e0 02             	shl    $0x2,%eax
  102ddc:	01 d0                	add    %edx,%eax
  102dde:	c1 e0 02             	shl    $0x2,%eax
  102de1:	01 c8                	add    %ecx,%eax
  102de3:	8b 48 0c             	mov    0xc(%eax),%ecx
  102de6:	8b 58 10             	mov    0x10(%eax),%ebx
  102de9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102dec:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102def:	01 c8                	add    %ecx,%eax
  102df1:	11 da                	adc    %ebx,%edx
  102df3:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102df6:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102df9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102dfc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102dff:	89 d0                	mov    %edx,%eax
  102e01:	c1 e0 02             	shl    $0x2,%eax
  102e04:	01 d0                	add    %edx,%eax
  102e06:	c1 e0 02             	shl    $0x2,%eax
  102e09:	01 c8                	add    %ecx,%eax
  102e0b:	83 c0 14             	add    $0x14,%eax
  102e0e:	8b 00                	mov    (%eax),%eax
  102e10:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  102e16:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102e19:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102e1c:	83 c0 ff             	add    $0xffffffff,%eax
  102e1f:	83 d2 ff             	adc    $0xffffffff,%edx
  102e22:	89 c6                	mov    %eax,%esi
  102e24:	89 d7                	mov    %edx,%edi
  102e26:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e29:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e2c:	89 d0                	mov    %edx,%eax
  102e2e:	c1 e0 02             	shl    $0x2,%eax
  102e31:	01 d0                	add    %edx,%eax
  102e33:	c1 e0 02             	shl    $0x2,%eax
  102e36:	01 c8                	add    %ecx,%eax
  102e38:	8b 48 0c             	mov    0xc(%eax),%ecx
  102e3b:	8b 58 10             	mov    0x10(%eax),%ebx
  102e3e:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  102e44:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  102e48:	89 74 24 14          	mov    %esi,0x14(%esp)
  102e4c:	89 7c 24 18          	mov    %edi,0x18(%esp)
  102e50:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102e53:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102e56:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e5a:	89 54 24 10          	mov    %edx,0x10(%esp)
  102e5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102e62:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102e66:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  102e6d:	e8 1f d4 ff ff       	call   100291 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102e72:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e75:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e78:	89 d0                	mov    %edx,%eax
  102e7a:	c1 e0 02             	shl    $0x2,%eax
  102e7d:	01 d0                	add    %edx,%eax
  102e7f:	c1 e0 02             	shl    $0x2,%eax
  102e82:	01 c8                	add    %ecx,%eax
  102e84:	83 c0 14             	add    $0x14,%eax
  102e87:	8b 00                	mov    (%eax),%eax
  102e89:	83 f8 01             	cmp    $0x1,%eax
  102e8c:	75 36                	jne    102ec4 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  102e8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e94:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102e97:	77 2b                	ja     102ec4 <page_init+0x14a>
  102e99:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102e9c:	72 05                	jb     102ea3 <page_init+0x129>
  102e9e:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  102ea1:	73 21                	jae    102ec4 <page_init+0x14a>
  102ea3:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102ea7:	77 1b                	ja     102ec4 <page_init+0x14a>
  102ea9:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102ead:	72 09                	jb     102eb8 <page_init+0x13e>
  102eaf:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  102eb6:	77 0c                	ja     102ec4 <page_init+0x14a>
                maxpa = end;
  102eb8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102ebb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102ebe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ec1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  102ec4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102ec8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102ecb:	8b 00                	mov    (%eax),%eax
  102ecd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102ed0:	0f 8f dd fe ff ff    	jg     102db3 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102ed6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102eda:	72 1d                	jb     102ef9 <page_init+0x17f>
  102edc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102ee0:	77 09                	ja     102eeb <page_init+0x171>
  102ee2:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102ee9:	76 0e                	jbe    102ef9 <page_init+0x17f>
        maxpa = KMEMSIZE;
  102eeb:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102ef2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102ef9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102efc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102eff:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102f03:	c1 ea 0c             	shr    $0xc,%edx
  102f06:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102f0b:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  102f12:	b8 68 89 11 00       	mov    $0x118968,%eax
  102f17:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f1a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102f1d:	01 d0                	add    %edx,%eax
  102f1f:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102f22:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102f25:	ba 00 00 00 00       	mov    $0x0,%edx
  102f2a:	f7 75 ac             	divl   -0x54(%ebp)
  102f2d:	89 d0                	mov    %edx,%eax
  102f2f:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102f32:	29 c2                	sub    %eax,%edx
  102f34:	89 d0                	mov    %edx,%eax
  102f36:	a3 58 89 11 00       	mov    %eax,0x118958

    for (i = 0; i < npage; i ++) {
  102f3b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f42:	eb 2f                	jmp    102f73 <page_init+0x1f9>
        SetPageReserved(pages + i);
  102f44:	8b 0d 58 89 11 00    	mov    0x118958,%ecx
  102f4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f4d:	89 d0                	mov    %edx,%eax
  102f4f:	c1 e0 02             	shl    $0x2,%eax
  102f52:	01 d0                	add    %edx,%eax
  102f54:	c1 e0 02             	shl    $0x2,%eax
  102f57:	01 c8                	add    %ecx,%eax
  102f59:	83 c0 04             	add    $0x4,%eax
  102f5c:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  102f63:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f66:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102f69:	8b 55 90             	mov    -0x70(%ebp),%edx
  102f6c:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
  102f6f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102f73:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f76:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102f7b:	39 c2                	cmp    %eax,%edx
  102f7d:	72 c5                	jb     102f44 <page_init+0x1ca>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102f7f:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f85:	89 d0                	mov    %edx,%eax
  102f87:	c1 e0 02             	shl    $0x2,%eax
  102f8a:	01 d0                	add    %edx,%eax
  102f8c:	c1 e0 02             	shl    $0x2,%eax
  102f8f:	89 c2                	mov    %eax,%edx
  102f91:	a1 58 89 11 00       	mov    0x118958,%eax
  102f96:	01 d0                	add    %edx,%eax
  102f98:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  102f9b:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  102fa2:	77 23                	ja     102fc7 <page_init+0x24d>
  102fa4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102fa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102fab:	c7 44 24 08 84 69 10 	movl   $0x106984,0x8(%esp)
  102fb2:	00 
  102fb3:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  102fba:	00 
  102fbb:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  102fc2:	e8 21 d4 ff ff       	call   1003e8 <__panic>
  102fc7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102fca:	05 00 00 00 40       	add    $0x40000000,%eax
  102fcf:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102fd2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102fd9:	e9 74 01 00 00       	jmp    103152 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102fde:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fe1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fe4:	89 d0                	mov    %edx,%eax
  102fe6:	c1 e0 02             	shl    $0x2,%eax
  102fe9:	01 d0                	add    %edx,%eax
  102feb:	c1 e0 02             	shl    $0x2,%eax
  102fee:	01 c8                	add    %ecx,%eax
  102ff0:	8b 50 08             	mov    0x8(%eax),%edx
  102ff3:	8b 40 04             	mov    0x4(%eax),%eax
  102ff6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ff9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102ffc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103002:	89 d0                	mov    %edx,%eax
  103004:	c1 e0 02             	shl    $0x2,%eax
  103007:	01 d0                	add    %edx,%eax
  103009:	c1 e0 02             	shl    $0x2,%eax
  10300c:	01 c8                	add    %ecx,%eax
  10300e:	8b 48 0c             	mov    0xc(%eax),%ecx
  103011:	8b 58 10             	mov    0x10(%eax),%ebx
  103014:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103017:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10301a:	01 c8                	add    %ecx,%eax
  10301c:	11 da                	adc    %ebx,%edx
  10301e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103021:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103024:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103027:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10302a:	89 d0                	mov    %edx,%eax
  10302c:	c1 e0 02             	shl    $0x2,%eax
  10302f:	01 d0                	add    %edx,%eax
  103031:	c1 e0 02             	shl    $0x2,%eax
  103034:	01 c8                	add    %ecx,%eax
  103036:	83 c0 14             	add    $0x14,%eax
  103039:	8b 00                	mov    (%eax),%eax
  10303b:	83 f8 01             	cmp    $0x1,%eax
  10303e:	0f 85 0a 01 00 00    	jne    10314e <page_init+0x3d4>
            if (begin < freemem) {
  103044:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103047:	ba 00 00 00 00       	mov    $0x0,%edx
  10304c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10304f:	72 17                	jb     103068 <page_init+0x2ee>
  103051:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103054:	77 05                	ja     10305b <page_init+0x2e1>
  103056:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  103059:	76 0d                	jbe    103068 <page_init+0x2ee>
                begin = freemem;
  10305b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10305e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103061:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103068:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10306c:	72 1d                	jb     10308b <page_init+0x311>
  10306e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103072:	77 09                	ja     10307d <page_init+0x303>
  103074:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  10307b:	76 0e                	jbe    10308b <page_init+0x311>
                end = KMEMSIZE;
  10307d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103084:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10308b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10308e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103091:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103094:	0f 87 b4 00 00 00    	ja     10314e <page_init+0x3d4>
  10309a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10309d:	72 09                	jb     1030a8 <page_init+0x32e>
  10309f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1030a2:	0f 83 a6 00 00 00    	jae    10314e <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  1030a8:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1030af:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1030b2:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1030b5:	01 d0                	add    %edx,%eax
  1030b7:	83 e8 01             	sub    $0x1,%eax
  1030ba:	89 45 98             	mov    %eax,-0x68(%ebp)
  1030bd:	8b 45 98             	mov    -0x68(%ebp),%eax
  1030c0:	ba 00 00 00 00       	mov    $0x0,%edx
  1030c5:	f7 75 9c             	divl   -0x64(%ebp)
  1030c8:	89 d0                	mov    %edx,%eax
  1030ca:	8b 55 98             	mov    -0x68(%ebp),%edx
  1030cd:	29 c2                	sub    %eax,%edx
  1030cf:	89 d0                	mov    %edx,%eax
  1030d1:	ba 00 00 00 00       	mov    $0x0,%edx
  1030d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1030dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1030df:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1030e2:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1030e5:	ba 00 00 00 00       	mov    $0x0,%edx
  1030ea:	89 c7                	mov    %eax,%edi
  1030ec:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1030f2:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1030f5:	89 d0                	mov    %edx,%eax
  1030f7:	83 e0 00             	and    $0x0,%eax
  1030fa:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1030fd:	8b 45 80             	mov    -0x80(%ebp),%eax
  103100:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103103:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103106:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  103109:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10310c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10310f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103112:	77 3a                	ja     10314e <page_init+0x3d4>
  103114:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103117:	72 05                	jb     10311e <page_init+0x3a4>
  103119:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10311c:	73 30                	jae    10314e <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10311e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  103121:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  103124:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103127:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10312a:	29 c8                	sub    %ecx,%eax
  10312c:	19 da                	sbb    %ebx,%edx
  10312e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103132:	c1 ea 0c             	shr    $0xc,%edx
  103135:	89 c3                	mov    %eax,%ebx
  103137:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10313a:	89 04 24             	mov    %eax,(%esp)
  10313d:	e8 bd f8 ff ff       	call   1029ff <pa2page>
  103142:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103146:	89 04 24             	mov    %eax,(%esp)
  103149:	e8 78 fb ff ff       	call   102cc6 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  10314e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103152:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103155:	8b 00                	mov    (%eax),%eax
  103157:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10315a:	0f 8f 7e fe ff ff    	jg     102fde <page_init+0x264>
                }
            }
        }
    }
}
  103160:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103166:	5b                   	pop    %ebx
  103167:	5e                   	pop    %esi
  103168:	5f                   	pop    %edi
  103169:	5d                   	pop    %ebp
  10316a:	c3                   	ret    

0010316b <enable_paging>:

static void
enable_paging(void) {
  10316b:	55                   	push   %ebp
  10316c:	89 e5                	mov    %esp,%ebp
  10316e:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  103171:	a1 54 89 11 00       	mov    0x118954,%eax
  103176:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  103179:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10317c:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  10317f:	0f 20 c0             	mov    %cr0,%eax
  103182:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  103185:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  103188:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  10318b:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  103192:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  103196:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103199:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  10319c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10319f:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  1031a2:	c9                   	leave  
  1031a3:	c3                   	ret    

001031a4 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1031a4:	55                   	push   %ebp
  1031a5:	89 e5                	mov    %esp,%ebp
  1031a7:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1031aa:	8b 45 14             	mov    0x14(%ebp),%eax
  1031ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  1031b0:	31 d0                	xor    %edx,%eax
  1031b2:	25 ff 0f 00 00       	and    $0xfff,%eax
  1031b7:	85 c0                	test   %eax,%eax
  1031b9:	74 24                	je     1031df <boot_map_segment+0x3b>
  1031bb:	c7 44 24 0c b6 69 10 	movl   $0x1069b6,0xc(%esp)
  1031c2:	00 
  1031c3:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  1031ca:	00 
  1031cb:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1031d2:	00 
  1031d3:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  1031da:	e8 09 d2 ff ff       	call   1003e8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1031df:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1031e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031e9:	25 ff 0f 00 00       	and    $0xfff,%eax
  1031ee:	89 c2                	mov    %eax,%edx
  1031f0:	8b 45 10             	mov    0x10(%ebp),%eax
  1031f3:	01 c2                	add    %eax,%edx
  1031f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031f8:	01 d0                	add    %edx,%eax
  1031fa:	83 e8 01             	sub    $0x1,%eax
  1031fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103203:	ba 00 00 00 00       	mov    $0x0,%edx
  103208:	f7 75 f0             	divl   -0x10(%ebp)
  10320b:	89 d0                	mov    %edx,%eax
  10320d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103210:	29 c2                	sub    %eax,%edx
  103212:	89 d0                	mov    %edx,%eax
  103214:	c1 e8 0c             	shr    $0xc,%eax
  103217:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10321a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10321d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103223:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103228:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10322b:	8b 45 14             	mov    0x14(%ebp),%eax
  10322e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103231:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103234:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103239:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10323c:	eb 6b                	jmp    1032a9 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10323e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103245:	00 
  103246:	8b 45 0c             	mov    0xc(%ebp),%eax
  103249:	89 44 24 04          	mov    %eax,0x4(%esp)
  10324d:	8b 45 08             	mov    0x8(%ebp),%eax
  103250:	89 04 24             	mov    %eax,(%esp)
  103253:	e8 cc 01 00 00       	call   103424 <get_pte>
  103258:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10325b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10325f:	75 24                	jne    103285 <boot_map_segment+0xe1>
  103261:	c7 44 24 0c e2 69 10 	movl   $0x1069e2,0xc(%esp)
  103268:	00 
  103269:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103270:	00 
  103271:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  103278:	00 
  103279:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103280:	e8 63 d1 ff ff       	call   1003e8 <__panic>
        *ptep = pa | PTE_P | perm;
  103285:	8b 45 18             	mov    0x18(%ebp),%eax
  103288:	8b 55 14             	mov    0x14(%ebp),%edx
  10328b:	09 d0                	or     %edx,%eax
  10328d:	83 c8 01             	or     $0x1,%eax
  103290:	89 c2                	mov    %eax,%edx
  103292:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103295:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103297:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10329b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1032a2:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1032a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1032ad:	75 8f                	jne    10323e <boot_map_segment+0x9a>
    }
}
  1032af:	c9                   	leave  
  1032b0:	c3                   	ret    

001032b1 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1032b1:	55                   	push   %ebp
  1032b2:	89 e5                	mov    %esp,%ebp
  1032b4:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1032b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032be:	e8 22 fa ff ff       	call   102ce5 <alloc_pages>
  1032c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1032c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1032ca:	75 1c                	jne    1032e8 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1032cc:	c7 44 24 08 ef 69 10 	movl   $0x1069ef,0x8(%esp)
  1032d3:	00 
  1032d4:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1032db:	00 
  1032dc:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  1032e3:	e8 00 d1 ff ff       	call   1003e8 <__panic>
    }
    return page2kva(p);
  1032e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032eb:	89 04 24             	mov    %eax,(%esp)
  1032ee:	e8 5b f7 ff ff       	call   102a4e <page2kva>
}
  1032f3:	c9                   	leave  
  1032f4:	c3                   	ret    

001032f5 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1032f5:	55                   	push   %ebp
  1032f6:	89 e5                	mov    %esp,%ebp
  1032f8:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1032fb:	e8 93 f9 ff ff       	call   102c93 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  103300:	e8 75 fa ff ff       	call   102d7a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  103305:	e8 66 04 00 00       	call   103770 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  10330a:	e8 a2 ff ff ff       	call   1032b1 <boot_alloc_page>
  10330f:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  103314:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103319:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103320:	00 
  103321:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103328:	00 
  103329:	89 04 24             	mov    %eax,(%esp)
  10332c:	e8 38 26 00 00       	call   105969 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  103331:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103336:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103339:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103340:	77 23                	ja     103365 <pmm_init+0x70>
  103342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103345:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103349:	c7 44 24 08 84 69 10 	movl   $0x106984,0x8(%esp)
  103350:	00 
  103351:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  103358:	00 
  103359:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103360:	e8 83 d0 ff ff       	call   1003e8 <__panic>
  103365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103368:	05 00 00 00 40       	add    $0x40000000,%eax
  10336d:	a3 54 89 11 00       	mov    %eax,0x118954

    check_pgdir();
  103372:	e8 17 04 00 00       	call   10378e <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103377:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10337c:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  103382:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103387:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10338a:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103391:	77 23                	ja     1033b6 <pmm_init+0xc1>
  103393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103396:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10339a:	c7 44 24 08 84 69 10 	movl   $0x106984,0x8(%esp)
  1033a1:	00 
  1033a2:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1033a9:	00 
  1033aa:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  1033b1:	e8 32 d0 ff ff       	call   1003e8 <__panic>
  1033b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033b9:	05 00 00 00 40       	add    $0x40000000,%eax
  1033be:	83 c8 03             	or     $0x3,%eax
  1033c1:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1033c3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1033c8:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1033cf:	00 
  1033d0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1033d7:	00 
  1033d8:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1033df:	38 
  1033e0:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1033e7:	c0 
  1033e8:	89 04 24             	mov    %eax,(%esp)
  1033eb:	e8 b4 fd ff ff       	call   1031a4 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1033f0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1033f5:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  1033fb:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  103401:	89 10                	mov    %edx,(%eax)

    enable_paging();
  103403:	e8 63 fd ff ff       	call   10316b <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103408:	e8 97 f7 ff ff       	call   102ba4 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  10340d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  103418:	e8 0c 0a 00 00       	call   103e29 <check_boot_pgdir>

    print_pgdir();
  10341d:	e8 99 0e 00 00       	call   1042bb <print_pgdir>

}
  103422:	c9                   	leave  
  103423:	c3                   	ret    

00103424 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  103424:	55                   	push   %ebp
  103425:	89 e5                	mov    %esp,%ebp
  103427:	83 ec 38             	sub    $0x38,%esp
     * typedef uintptr_t pte_t;
     * typedef uintptr_t pde_t;
     */
    //pgdir是一级页表本身,pde_t是一级页表的表项, pte_t表示二级页表的表项
    //pgdir给出页表起始地址。通过查找这个页表，我们可以得到一级页表项(二级页表的入口地址)。
    pde_t *pdep = &pgdir[PDX(la)];//根据虚地址的高十位查询页目录，找到页表项的pdep
  10342a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10342d:	c1 e8 16             	shr    $0x16,%eax
  103430:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103437:	8b 45 08             	mov    0x8(%ebp),%eax
  10343a:	01 d0                	add    %edx,%eax
  10343c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
  10343f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103442:	8b 00                	mov    (%eax),%eax
  103444:	83 e0 01             	and    $0x1,%eax
  103447:	85 c0                	test   %eax,%eax
  103449:	0f 85 af 00 00 00    	jne    1034fe <get_pte+0xda>
        //如果在查找二级页表项时，发现对应的二级页表不存在，则需要根据create参数的值来处理是否创建新的二级页表。
        struct  Page* page = alloc_page();
  10344f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103456:	e8 8a f8 ff ff       	call   102ce5 <alloc_pages>
  10345b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(!create||page==NULL){
  10345e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103462:	74 06                	je     10346a <get_pte+0x46>
  103464:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103468:	75 0a                	jne    103474 <get_pte+0x50>
            return NULL;
  10346a:	b8 00 00 00 00       	mov    $0x0,%eax
  10346f:	e9 e6 00 00 00       	jmp    10355a <get_pte+0x136>
        }                  
        set_page_ref(page,1);//引用次数加一
  103474:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10347b:	00 
  10347c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10347f:	89 04 24             	mov    %eax,(%esp)
  103482:	e8 63 f6 ff ff       	call   102aea <set_page_ref>
        uintptr_t pa = page2pa(page); //获取页的线性地址
  103487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10348a:	89 04 24             	mov    %eax,(%esp)
  10348d:	e8 57 f5 ff ff       	call   1029e9 <page2pa>
  103492:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa),0,PGSIZE);//初始化,新申请的页全设为零，因为这个页所代表的虚拟地址都没有被映射。
  103495:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103498:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10349b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10349e:	c1 e8 0c             	shr    $0xc,%eax
  1034a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034a4:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1034a9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1034ac:	72 23                	jb     1034d1 <get_pte+0xad>
  1034ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1034b5:	c7 44 24 08 e0 68 10 	movl   $0x1068e0,0x8(%esp)
  1034bc:	00 
  1034bd:	c7 44 24 04 7a 01 00 	movl   $0x17a,0x4(%esp)
  1034c4:	00 
  1034c5:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  1034cc:	e8 17 cf ff ff       	call   1003e8 <__panic>
  1034d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034d4:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1034d9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1034e0:	00 
  1034e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1034e8:	00 
  1034e9:	89 04 24             	mov    %eax,(%esp)
  1034ec:	e8 78 24 00 00       	call   105969 <memset>
        *pdep=pa|PTE_U|PTE_W|PTE_P;//设置控制位
  1034f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034f4:	83 c8 07             	or     $0x7,%eax
  1034f7:	89 c2                	mov    %eax,%edx
  1034f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034fc:	89 10                	mov    %edx,(%eax)
    }
    //KADDR(PDE_ADDR(*pdep)):这部分是由页目录项地址得到关联的页表物理地址， 再转成虚拟地址。
    //PTX(la)：返回虚拟地址la的页表项索引
    //最后返回的是虚拟地址la对应的页表项入口地址  
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; 
  1034fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103501:	8b 00                	mov    (%eax),%eax
  103503:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103508:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10350b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10350e:	c1 e8 0c             	shr    $0xc,%eax
  103511:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103514:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103519:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10351c:	72 23                	jb     103541 <get_pte+0x11d>
  10351e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103521:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103525:	c7 44 24 08 e0 68 10 	movl   $0x1068e0,0x8(%esp)
  10352c:	00 
  10352d:	c7 44 24 04 80 01 00 	movl   $0x180,0x4(%esp)
  103534:	00 
  103535:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  10353c:	e8 a7 ce ff ff       	call   1003e8 <__panic>
  103541:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103544:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103549:	8b 55 0c             	mov    0xc(%ebp),%edx
  10354c:	c1 ea 0c             	shr    $0xc,%edx
  10354f:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  103555:	c1 e2 02             	shl    $0x2,%edx
  103558:	01 d0                	add    %edx,%eax
}
  10355a:	c9                   	leave  
  10355b:	c3                   	ret    

0010355c <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10355c:	55                   	push   %ebp
  10355d:	89 e5                	mov    %esp,%ebp
  10355f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103562:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103569:	00 
  10356a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10356d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103571:	8b 45 08             	mov    0x8(%ebp),%eax
  103574:	89 04 24             	mov    %eax,(%esp)
  103577:	e8 a8 fe ff ff       	call   103424 <get_pte>
  10357c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10357f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103583:	74 08                	je     10358d <get_page+0x31>
        *ptep_store = ptep;
  103585:	8b 45 10             	mov    0x10(%ebp),%eax
  103588:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10358b:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10358d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103591:	74 1b                	je     1035ae <get_page+0x52>
  103593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103596:	8b 00                	mov    (%eax),%eax
  103598:	83 e0 01             	and    $0x1,%eax
  10359b:	85 c0                	test   %eax,%eax
  10359d:	74 0f                	je     1035ae <get_page+0x52>
        return pa2page(*ptep);
  10359f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035a2:	8b 00                	mov    (%eax),%eax
  1035a4:	89 04 24             	mov    %eax,(%esp)
  1035a7:	e8 53 f4 ff ff       	call   1029ff <pa2page>
  1035ac:	eb 05                	jmp    1035b3 <get_page+0x57>
    }
    return NULL;
  1035ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1035b3:	c9                   	leave  
  1035b4:	c3                   	ret    

001035b5 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1035b5:	55                   	push   %ebp
  1035b6:	89 e5                	mov    %esp,%ebp
  1035b8:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     *                        当修改的页表是进程正在使用的那些页表，使之无效。
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
    if (*ptep & PTE_P) {// 页表项存在
  1035bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1035be:	8b 00                	mov    (%eax),%eax
  1035c0:	83 e0 01             	and    $0x1,%eax
  1035c3:	85 c0                	test   %eax,%eax
  1035c5:	74 4d                	je     103614 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep); //找到页表项
  1035c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1035ca:	8b 00                	mov    (%eax),%eax
  1035cc:	89 04 24             	mov    %eax,(%esp)
  1035cf:	e8 ce f4 ff ff       	call   102aa2 <pte2page>
  1035d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(page_ref_dec(page)==0)
  1035d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035da:	89 04 24             	mov    %eax,(%esp)
  1035dd:	e8 2c f5 ff ff       	call   102b0e <page_ref_dec>
  1035e2:	85 c0                	test   %eax,%eax
  1035e4:	75 13                	jne    1035f9 <page_remove_pte+0x44>
        {//判断此页被引用的次数，如果仅仅被引用一次，则这个页也可以被释放。否则，只能释放页表入口
            free_page(page);//释放页
  1035e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035ed:	00 
  1035ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035f1:	89 04 24             	mov    %eax,(%esp)
  1035f4:	e8 24 f7 ff ff       	call   102d1d <free_pages>
        }                         
        *ptep=0;//该页目录项清零
  1035f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1035fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir,la);//flush tlb
  103602:	8b 45 0c             	mov    0xc(%ebp),%eax
  103605:	89 44 24 04          	mov    %eax,0x4(%esp)
  103609:	8b 45 08             	mov    0x8(%ebp),%eax
  10360c:	89 04 24             	mov    %eax,(%esp)
  10360f:	e8 ff 00 00 00       	call   103713 <tlb_invalidate>
    }
}
  103614:	c9                   	leave  
  103615:	c3                   	ret    

00103616 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  103616:	55                   	push   %ebp
  103617:	89 e5                	mov    %esp,%ebp
  103619:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10361c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103623:	00 
  103624:	8b 45 0c             	mov    0xc(%ebp),%eax
  103627:	89 44 24 04          	mov    %eax,0x4(%esp)
  10362b:	8b 45 08             	mov    0x8(%ebp),%eax
  10362e:	89 04 24             	mov    %eax,(%esp)
  103631:	e8 ee fd ff ff       	call   103424 <get_pte>
  103636:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10363d:	74 19                	je     103658 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10363f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103642:	89 44 24 08          	mov    %eax,0x8(%esp)
  103646:	8b 45 0c             	mov    0xc(%ebp),%eax
  103649:	89 44 24 04          	mov    %eax,0x4(%esp)
  10364d:	8b 45 08             	mov    0x8(%ebp),%eax
  103650:	89 04 24             	mov    %eax,(%esp)
  103653:	e8 5d ff ff ff       	call   1035b5 <page_remove_pte>
    }
}
  103658:	c9                   	leave  
  103659:	c3                   	ret    

0010365a <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10365a:	55                   	push   %ebp
  10365b:	89 e5                	mov    %esp,%ebp
  10365d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103660:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103667:	00 
  103668:	8b 45 10             	mov    0x10(%ebp),%eax
  10366b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10366f:	8b 45 08             	mov    0x8(%ebp),%eax
  103672:	89 04 24             	mov    %eax,(%esp)
  103675:	e8 aa fd ff ff       	call   103424 <get_pte>
  10367a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10367d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103681:	75 0a                	jne    10368d <page_insert+0x33>
        return -E_NO_MEM;
  103683:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  103688:	e9 84 00 00 00       	jmp    103711 <page_insert+0xb7>
    }
    page_ref_inc(page);
  10368d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103690:	89 04 24             	mov    %eax,(%esp)
  103693:	e8 5f f4 ff ff       	call   102af7 <page_ref_inc>
    if (*ptep & PTE_P) {
  103698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10369b:	8b 00                	mov    (%eax),%eax
  10369d:	83 e0 01             	and    $0x1,%eax
  1036a0:	85 c0                	test   %eax,%eax
  1036a2:	74 3e                	je     1036e2 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1036a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036a7:	8b 00                	mov    (%eax),%eax
  1036a9:	89 04 24             	mov    %eax,(%esp)
  1036ac:	e8 f1 f3 ff ff       	call   102aa2 <pte2page>
  1036b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1036b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1036ba:	75 0d                	jne    1036c9 <page_insert+0x6f>
            page_ref_dec(page);
  1036bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036bf:	89 04 24             	mov    %eax,(%esp)
  1036c2:	e8 47 f4 ff ff       	call   102b0e <page_ref_dec>
  1036c7:	eb 19                	jmp    1036e2 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1036c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  1036d0:	8b 45 10             	mov    0x10(%ebp),%eax
  1036d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1036da:	89 04 24             	mov    %eax,(%esp)
  1036dd:	e8 d3 fe ff ff       	call   1035b5 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1036e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036e5:	89 04 24             	mov    %eax,(%esp)
  1036e8:	e8 fc f2 ff ff       	call   1029e9 <page2pa>
  1036ed:	0b 45 14             	or     0x14(%ebp),%eax
  1036f0:	83 c8 01             	or     $0x1,%eax
  1036f3:	89 c2                	mov    %eax,%edx
  1036f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036f8:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1036fa:	8b 45 10             	mov    0x10(%ebp),%eax
  1036fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  103701:	8b 45 08             	mov    0x8(%ebp),%eax
  103704:	89 04 24             	mov    %eax,(%esp)
  103707:	e8 07 00 00 00       	call   103713 <tlb_invalidate>
    return 0;
  10370c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103711:	c9                   	leave  
  103712:	c3                   	ret    

00103713 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103713:	55                   	push   %ebp
  103714:	89 e5                	mov    %esp,%ebp
  103716:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103719:	0f 20 d8             	mov    %cr3,%eax
  10371c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  10371f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  103722:	89 c2                	mov    %eax,%edx
  103724:	8b 45 08             	mov    0x8(%ebp),%eax
  103727:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10372a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103731:	77 23                	ja     103756 <tlb_invalidate+0x43>
  103733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103736:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10373a:	c7 44 24 08 84 69 10 	movl   $0x106984,0x8(%esp)
  103741:	00 
  103742:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  103749:	00 
  10374a:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103751:	e8 92 cc ff ff       	call   1003e8 <__panic>
  103756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103759:	05 00 00 00 40       	add    $0x40000000,%eax
  10375e:	39 c2                	cmp    %eax,%edx
  103760:	75 0c                	jne    10376e <tlb_invalidate+0x5b>
        invlpg((void *)la);
  103762:	8b 45 0c             	mov    0xc(%ebp),%eax
  103765:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10376b:	0f 01 38             	invlpg (%eax)
    }
}
  10376e:	c9                   	leave  
  10376f:	c3                   	ret    

00103770 <check_alloc_page>:

static void
check_alloc_page(void) {
  103770:	55                   	push   %ebp
  103771:	89 e5                	mov    %esp,%ebp
  103773:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  103776:	a1 50 89 11 00       	mov    0x118950,%eax
  10377b:	8b 40 18             	mov    0x18(%eax),%eax
  10377e:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103780:	c7 04 24 08 6a 10 00 	movl   $0x106a08,(%esp)
  103787:	e8 05 cb ff ff       	call   100291 <cprintf>
}
  10378c:	c9                   	leave  
  10378d:	c3                   	ret    

0010378e <check_pgdir>:

static void
check_pgdir(void) {
  10378e:	55                   	push   %ebp
  10378f:	89 e5                	mov    %esp,%ebp
  103791:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  103794:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103799:	3d 00 80 03 00       	cmp    $0x38000,%eax
  10379e:	76 24                	jbe    1037c4 <check_pgdir+0x36>
  1037a0:	c7 44 24 0c 27 6a 10 	movl   $0x106a27,0xc(%esp)
  1037a7:	00 
  1037a8:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  1037af:	00 
  1037b0:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  1037b7:	00 
  1037b8:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  1037bf:	e8 24 cc ff ff       	call   1003e8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1037c4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1037c9:	85 c0                	test   %eax,%eax
  1037cb:	74 0e                	je     1037db <check_pgdir+0x4d>
  1037cd:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1037d2:	25 ff 0f 00 00       	and    $0xfff,%eax
  1037d7:	85 c0                	test   %eax,%eax
  1037d9:	74 24                	je     1037ff <check_pgdir+0x71>
  1037db:	c7 44 24 0c 44 6a 10 	movl   $0x106a44,0xc(%esp)
  1037e2:	00 
  1037e3:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  1037ea:	00 
  1037eb:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  1037f2:	00 
  1037f3:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  1037fa:	e8 e9 cb ff ff       	call   1003e8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1037ff:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103804:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10380b:	00 
  10380c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103813:	00 
  103814:	89 04 24             	mov    %eax,(%esp)
  103817:	e8 40 fd ff ff       	call   10355c <get_page>
  10381c:	85 c0                	test   %eax,%eax
  10381e:	74 24                	je     103844 <check_pgdir+0xb6>
  103820:	c7 44 24 0c 7c 6a 10 	movl   $0x106a7c,0xc(%esp)
  103827:	00 
  103828:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  10382f:	00 
  103830:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  103837:	00 
  103838:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  10383f:	e8 a4 cb ff ff       	call   1003e8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103844:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10384b:	e8 95 f4 ff ff       	call   102ce5 <alloc_pages>
  103850:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103853:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103858:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10385f:	00 
  103860:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103867:	00 
  103868:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10386b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10386f:	89 04 24             	mov    %eax,(%esp)
  103872:	e8 e3 fd ff ff       	call   10365a <page_insert>
  103877:	85 c0                	test   %eax,%eax
  103879:	74 24                	je     10389f <check_pgdir+0x111>
  10387b:	c7 44 24 0c a4 6a 10 	movl   $0x106aa4,0xc(%esp)
  103882:	00 
  103883:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  10388a:	00 
  10388b:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  103892:	00 
  103893:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  10389a:	e8 49 cb ff ff       	call   1003e8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  10389f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1038a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1038ab:	00 
  1038ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1038b3:	00 
  1038b4:	89 04 24             	mov    %eax,(%esp)
  1038b7:	e8 68 fb ff ff       	call   103424 <get_pte>
  1038bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1038bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1038c3:	75 24                	jne    1038e9 <check_pgdir+0x15b>
  1038c5:	c7 44 24 0c d0 6a 10 	movl   $0x106ad0,0xc(%esp)
  1038cc:	00 
  1038cd:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  1038d4:	00 
  1038d5:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  1038dc:	00 
  1038dd:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  1038e4:	e8 ff ca ff ff       	call   1003e8 <__panic>
    assert(pa2page(*ptep) == p1);
  1038e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038ec:	8b 00                	mov    (%eax),%eax
  1038ee:	89 04 24             	mov    %eax,(%esp)
  1038f1:	e8 09 f1 ff ff       	call   1029ff <pa2page>
  1038f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1038f9:	74 24                	je     10391f <check_pgdir+0x191>
  1038fb:	c7 44 24 0c fd 6a 10 	movl   $0x106afd,0xc(%esp)
  103902:	00 
  103903:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  10390a:	00 
  10390b:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  103912:	00 
  103913:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  10391a:	e8 c9 ca ff ff       	call   1003e8 <__panic>
    assert(page_ref(p1) == 1);
  10391f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103922:	89 04 24             	mov    %eax,(%esp)
  103925:	e8 b6 f1 ff ff       	call   102ae0 <page_ref>
  10392a:	83 f8 01             	cmp    $0x1,%eax
  10392d:	74 24                	je     103953 <check_pgdir+0x1c5>
  10392f:	c7 44 24 0c 12 6b 10 	movl   $0x106b12,0xc(%esp)
  103936:	00 
  103937:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  10393e:	00 
  10393f:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  103946:	00 
  103947:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  10394e:	e8 95 ca ff ff       	call   1003e8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103953:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103958:	8b 00                	mov    (%eax),%eax
  10395a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10395f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103965:	c1 e8 0c             	shr    $0xc,%eax
  103968:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10396b:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103970:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103973:	72 23                	jb     103998 <check_pgdir+0x20a>
  103975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103978:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10397c:	c7 44 24 08 e0 68 10 	movl   $0x1068e0,0x8(%esp)
  103983:	00 
  103984:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  10398b:	00 
  10398c:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103993:	e8 50 ca ff ff       	call   1003e8 <__panic>
  103998:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10399b:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1039a0:	83 c0 04             	add    $0x4,%eax
  1039a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1039a6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1039ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039b2:	00 
  1039b3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1039ba:	00 
  1039bb:	89 04 24             	mov    %eax,(%esp)
  1039be:	e8 61 fa ff ff       	call   103424 <get_pte>
  1039c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1039c6:	74 24                	je     1039ec <check_pgdir+0x25e>
  1039c8:	c7 44 24 0c 24 6b 10 	movl   $0x106b24,0xc(%esp)
  1039cf:	00 
  1039d0:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  1039d7:	00 
  1039d8:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  1039df:	00 
  1039e0:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  1039e7:	e8 fc c9 ff ff       	call   1003e8 <__panic>

    p2 = alloc_page();
  1039ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039f3:	e8 ed f2 ff ff       	call   102ce5 <alloc_pages>
  1039f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1039fb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103a00:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103a07:	00 
  103a08:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103a0f:	00 
  103a10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103a13:	89 54 24 04          	mov    %edx,0x4(%esp)
  103a17:	89 04 24             	mov    %eax,(%esp)
  103a1a:	e8 3b fc ff ff       	call   10365a <page_insert>
  103a1f:	85 c0                	test   %eax,%eax
  103a21:	74 24                	je     103a47 <check_pgdir+0x2b9>
  103a23:	c7 44 24 0c 4c 6b 10 	movl   $0x106b4c,0xc(%esp)
  103a2a:	00 
  103a2b:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103a32:	00 
  103a33:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  103a3a:	00 
  103a3b:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103a42:	e8 a1 c9 ff ff       	call   1003e8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103a47:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103a4c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103a53:	00 
  103a54:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103a5b:	00 
  103a5c:	89 04 24             	mov    %eax,(%esp)
  103a5f:	e8 c0 f9 ff ff       	call   103424 <get_pte>
  103a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a6b:	75 24                	jne    103a91 <check_pgdir+0x303>
  103a6d:	c7 44 24 0c 84 6b 10 	movl   $0x106b84,0xc(%esp)
  103a74:	00 
  103a75:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103a7c:	00 
  103a7d:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  103a84:	00 
  103a85:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103a8c:	e8 57 c9 ff ff       	call   1003e8 <__panic>
    assert(*ptep & PTE_U);
  103a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a94:	8b 00                	mov    (%eax),%eax
  103a96:	83 e0 04             	and    $0x4,%eax
  103a99:	85 c0                	test   %eax,%eax
  103a9b:	75 24                	jne    103ac1 <check_pgdir+0x333>
  103a9d:	c7 44 24 0c b4 6b 10 	movl   $0x106bb4,0xc(%esp)
  103aa4:	00 
  103aa5:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103aac:	00 
  103aad:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  103ab4:	00 
  103ab5:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103abc:	e8 27 c9 ff ff       	call   1003e8 <__panic>
    assert(*ptep & PTE_W);
  103ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ac4:	8b 00                	mov    (%eax),%eax
  103ac6:	83 e0 02             	and    $0x2,%eax
  103ac9:	85 c0                	test   %eax,%eax
  103acb:	75 24                	jne    103af1 <check_pgdir+0x363>
  103acd:	c7 44 24 0c c2 6b 10 	movl   $0x106bc2,0xc(%esp)
  103ad4:	00 
  103ad5:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103adc:	00 
  103add:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  103ae4:	00 
  103ae5:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103aec:	e8 f7 c8 ff ff       	call   1003e8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103af1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103af6:	8b 00                	mov    (%eax),%eax
  103af8:	83 e0 04             	and    $0x4,%eax
  103afb:	85 c0                	test   %eax,%eax
  103afd:	75 24                	jne    103b23 <check_pgdir+0x395>
  103aff:	c7 44 24 0c d0 6b 10 	movl   $0x106bd0,0xc(%esp)
  103b06:	00 
  103b07:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103b0e:	00 
  103b0f:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  103b16:	00 
  103b17:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103b1e:	e8 c5 c8 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p2) == 1);
  103b23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b26:	89 04 24             	mov    %eax,(%esp)
  103b29:	e8 b2 ef ff ff       	call   102ae0 <page_ref>
  103b2e:	83 f8 01             	cmp    $0x1,%eax
  103b31:	74 24                	je     103b57 <check_pgdir+0x3c9>
  103b33:	c7 44 24 0c e6 6b 10 	movl   $0x106be6,0xc(%esp)
  103b3a:	00 
  103b3b:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103b42:	00 
  103b43:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  103b4a:	00 
  103b4b:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103b52:	e8 91 c8 ff ff       	call   1003e8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103b57:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103b5c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103b63:	00 
  103b64:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103b6b:	00 
  103b6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103b6f:	89 54 24 04          	mov    %edx,0x4(%esp)
  103b73:	89 04 24             	mov    %eax,(%esp)
  103b76:	e8 df fa ff ff       	call   10365a <page_insert>
  103b7b:	85 c0                	test   %eax,%eax
  103b7d:	74 24                	je     103ba3 <check_pgdir+0x415>
  103b7f:	c7 44 24 0c f8 6b 10 	movl   $0x106bf8,0xc(%esp)
  103b86:	00 
  103b87:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103b8e:	00 
  103b8f:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  103b96:	00 
  103b97:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103b9e:	e8 45 c8 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p1) == 2);
  103ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ba6:	89 04 24             	mov    %eax,(%esp)
  103ba9:	e8 32 ef ff ff       	call   102ae0 <page_ref>
  103bae:	83 f8 02             	cmp    $0x2,%eax
  103bb1:	74 24                	je     103bd7 <check_pgdir+0x449>
  103bb3:	c7 44 24 0c 24 6c 10 	movl   $0x106c24,0xc(%esp)
  103bba:	00 
  103bbb:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103bc2:	00 
  103bc3:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  103bca:	00 
  103bcb:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103bd2:	e8 11 c8 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p2) == 0);
  103bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103bda:	89 04 24             	mov    %eax,(%esp)
  103bdd:	e8 fe ee ff ff       	call   102ae0 <page_ref>
  103be2:	85 c0                	test   %eax,%eax
  103be4:	74 24                	je     103c0a <check_pgdir+0x47c>
  103be6:	c7 44 24 0c 36 6c 10 	movl   $0x106c36,0xc(%esp)
  103bed:	00 
  103bee:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103bf5:	00 
  103bf6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  103bfd:	00 
  103bfe:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103c05:	e8 de c7 ff ff       	call   1003e8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103c0a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103c16:	00 
  103c17:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103c1e:	00 
  103c1f:	89 04 24             	mov    %eax,(%esp)
  103c22:	e8 fd f7 ff ff       	call   103424 <get_pte>
  103c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c2e:	75 24                	jne    103c54 <check_pgdir+0x4c6>
  103c30:	c7 44 24 0c 84 6b 10 	movl   $0x106b84,0xc(%esp)
  103c37:	00 
  103c38:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103c3f:	00 
  103c40:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103c47:	00 
  103c48:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103c4f:	e8 94 c7 ff ff       	call   1003e8 <__panic>
    assert(pa2page(*ptep) == p1);
  103c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c57:	8b 00                	mov    (%eax),%eax
  103c59:	89 04 24             	mov    %eax,(%esp)
  103c5c:	e8 9e ed ff ff       	call   1029ff <pa2page>
  103c61:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103c64:	74 24                	je     103c8a <check_pgdir+0x4fc>
  103c66:	c7 44 24 0c fd 6a 10 	movl   $0x106afd,0xc(%esp)
  103c6d:	00 
  103c6e:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103c75:	00 
  103c76:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  103c7d:	00 
  103c7e:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103c85:	e8 5e c7 ff ff       	call   1003e8 <__panic>
    assert((*ptep & PTE_U) == 0);
  103c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c8d:	8b 00                	mov    (%eax),%eax
  103c8f:	83 e0 04             	and    $0x4,%eax
  103c92:	85 c0                	test   %eax,%eax
  103c94:	74 24                	je     103cba <check_pgdir+0x52c>
  103c96:	c7 44 24 0c 48 6c 10 	movl   $0x106c48,0xc(%esp)
  103c9d:	00 
  103c9e:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103ca5:	00 
  103ca6:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  103cad:	00 
  103cae:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103cb5:	e8 2e c7 ff ff       	call   1003e8 <__panic>

    page_remove(boot_pgdir, 0x0);
  103cba:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103cbf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103cc6:	00 
  103cc7:	89 04 24             	mov    %eax,(%esp)
  103cca:	e8 47 f9 ff ff       	call   103616 <page_remove>
    assert(page_ref(p1) == 1);
  103ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cd2:	89 04 24             	mov    %eax,(%esp)
  103cd5:	e8 06 ee ff ff       	call   102ae0 <page_ref>
  103cda:	83 f8 01             	cmp    $0x1,%eax
  103cdd:	74 24                	je     103d03 <check_pgdir+0x575>
  103cdf:	c7 44 24 0c 12 6b 10 	movl   $0x106b12,0xc(%esp)
  103ce6:	00 
  103ce7:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103cee:	00 
  103cef:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  103cf6:	00 
  103cf7:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103cfe:	e8 e5 c6 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p2) == 0);
  103d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d06:	89 04 24             	mov    %eax,(%esp)
  103d09:	e8 d2 ed ff ff       	call   102ae0 <page_ref>
  103d0e:	85 c0                	test   %eax,%eax
  103d10:	74 24                	je     103d36 <check_pgdir+0x5a8>
  103d12:	c7 44 24 0c 36 6c 10 	movl   $0x106c36,0xc(%esp)
  103d19:	00 
  103d1a:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103d21:	00 
  103d22:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  103d29:	00 
  103d2a:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103d31:	e8 b2 c6 ff ff       	call   1003e8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103d36:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103d3b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103d42:	00 
  103d43:	89 04 24             	mov    %eax,(%esp)
  103d46:	e8 cb f8 ff ff       	call   103616 <page_remove>
    assert(page_ref(p1) == 0);
  103d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d4e:	89 04 24             	mov    %eax,(%esp)
  103d51:	e8 8a ed ff ff       	call   102ae0 <page_ref>
  103d56:	85 c0                	test   %eax,%eax
  103d58:	74 24                	je     103d7e <check_pgdir+0x5f0>
  103d5a:	c7 44 24 0c 5d 6c 10 	movl   $0x106c5d,0xc(%esp)
  103d61:	00 
  103d62:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103d69:	00 
  103d6a:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  103d71:	00 
  103d72:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103d79:	e8 6a c6 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p2) == 0);
  103d7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d81:	89 04 24             	mov    %eax,(%esp)
  103d84:	e8 57 ed ff ff       	call   102ae0 <page_ref>
  103d89:	85 c0                	test   %eax,%eax
  103d8b:	74 24                	je     103db1 <check_pgdir+0x623>
  103d8d:	c7 44 24 0c 36 6c 10 	movl   $0x106c36,0xc(%esp)
  103d94:	00 
  103d95:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103d9c:	00 
  103d9d:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  103da4:	00 
  103da5:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103dac:	e8 37 c6 ff ff       	call   1003e8 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  103db1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103db6:	8b 00                	mov    (%eax),%eax
  103db8:	89 04 24             	mov    %eax,(%esp)
  103dbb:	e8 3f ec ff ff       	call   1029ff <pa2page>
  103dc0:	89 04 24             	mov    %eax,(%esp)
  103dc3:	e8 18 ed ff ff       	call   102ae0 <page_ref>
  103dc8:	83 f8 01             	cmp    $0x1,%eax
  103dcb:	74 24                	je     103df1 <check_pgdir+0x663>
  103dcd:	c7 44 24 0c 70 6c 10 	movl   $0x106c70,0xc(%esp)
  103dd4:	00 
  103dd5:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103ddc:	00 
  103ddd:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  103de4:	00 
  103de5:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103dec:	e8 f7 c5 ff ff       	call   1003e8 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  103df1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103df6:	8b 00                	mov    (%eax),%eax
  103df8:	89 04 24             	mov    %eax,(%esp)
  103dfb:	e8 ff eb ff ff       	call   1029ff <pa2page>
  103e00:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103e07:	00 
  103e08:	89 04 24             	mov    %eax,(%esp)
  103e0b:	e8 0d ef ff ff       	call   102d1d <free_pages>
    boot_pgdir[0] = 0;
  103e10:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103e15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103e1b:	c7 04 24 96 6c 10 00 	movl   $0x106c96,(%esp)
  103e22:	e8 6a c4 ff ff       	call   100291 <cprintf>
}
  103e27:	c9                   	leave  
  103e28:	c3                   	ret    

00103e29 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103e29:	55                   	push   %ebp
  103e2a:	89 e5                	mov    %esp,%ebp
  103e2c:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103e2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103e36:	e9 ca 00 00 00       	jmp    103f05 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e44:	c1 e8 0c             	shr    $0xc,%eax
  103e47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103e4a:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103e4f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103e52:	72 23                	jb     103e77 <check_boot_pgdir+0x4e>
  103e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e5b:	c7 44 24 08 e0 68 10 	movl   $0x1068e0,0x8(%esp)
  103e62:	00 
  103e63:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  103e6a:	00 
  103e6b:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103e72:	e8 71 c5 ff ff       	call   1003e8 <__panic>
  103e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e7a:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103e7f:	89 c2                	mov    %eax,%edx
  103e81:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103e86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103e8d:	00 
  103e8e:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e92:	89 04 24             	mov    %eax,(%esp)
  103e95:	e8 8a f5 ff ff       	call   103424 <get_pte>
  103e9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103e9d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103ea1:	75 24                	jne    103ec7 <check_boot_pgdir+0x9e>
  103ea3:	c7 44 24 0c b0 6c 10 	movl   $0x106cb0,0xc(%esp)
  103eaa:	00 
  103eab:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103eb2:	00 
  103eb3:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  103eba:	00 
  103ebb:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103ec2:	e8 21 c5 ff ff       	call   1003e8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103eca:	8b 00                	mov    (%eax),%eax
  103ecc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103ed1:	89 c2                	mov    %eax,%edx
  103ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ed6:	39 c2                	cmp    %eax,%edx
  103ed8:	74 24                	je     103efe <check_boot_pgdir+0xd5>
  103eda:	c7 44 24 0c ed 6c 10 	movl   $0x106ced,0xc(%esp)
  103ee1:	00 
  103ee2:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103ee9:	00 
  103eea:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  103ef1:	00 
  103ef2:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103ef9:	e8 ea c4 ff ff       	call   1003e8 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103efe:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103f08:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103f0d:	39 c2                	cmp    %eax,%edx
  103f0f:	0f 82 26 ff ff ff    	jb     103e3b <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103f15:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103f1a:	05 ac 0f 00 00       	add    $0xfac,%eax
  103f1f:	8b 00                	mov    (%eax),%eax
  103f21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103f26:	89 c2                	mov    %eax,%edx
  103f28:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103f2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103f30:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  103f37:	77 23                	ja     103f5c <check_boot_pgdir+0x133>
  103f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f3c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f40:	c7 44 24 08 84 69 10 	movl   $0x106984,0x8(%esp)
  103f47:	00 
  103f48:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  103f4f:	00 
  103f50:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103f57:	e8 8c c4 ff ff       	call   1003e8 <__panic>
  103f5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f5f:	05 00 00 00 40       	add    $0x40000000,%eax
  103f64:	39 c2                	cmp    %eax,%edx
  103f66:	74 24                	je     103f8c <check_boot_pgdir+0x163>
  103f68:	c7 44 24 0c 04 6d 10 	movl   $0x106d04,0xc(%esp)
  103f6f:	00 
  103f70:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103f77:	00 
  103f78:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  103f7f:	00 
  103f80:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103f87:	e8 5c c4 ff ff       	call   1003e8 <__panic>

    assert(boot_pgdir[0] == 0);
  103f8c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103f91:	8b 00                	mov    (%eax),%eax
  103f93:	85 c0                	test   %eax,%eax
  103f95:	74 24                	je     103fbb <check_boot_pgdir+0x192>
  103f97:	c7 44 24 0c 38 6d 10 	movl   $0x106d38,0xc(%esp)
  103f9e:	00 
  103f9f:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  103fa6:	00 
  103fa7:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  103fae:	00 
  103faf:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103fb6:	e8 2d c4 ff ff       	call   1003e8 <__panic>

    struct Page *p;
    p = alloc_page();
  103fbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103fc2:	e8 1e ed ff ff       	call   102ce5 <alloc_pages>
  103fc7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103fca:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103fcf:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103fd6:	00 
  103fd7:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  103fde:	00 
  103fdf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103fe2:	89 54 24 04          	mov    %edx,0x4(%esp)
  103fe6:	89 04 24             	mov    %eax,(%esp)
  103fe9:	e8 6c f6 ff ff       	call   10365a <page_insert>
  103fee:	85 c0                	test   %eax,%eax
  103ff0:	74 24                	je     104016 <check_boot_pgdir+0x1ed>
  103ff2:	c7 44 24 0c 4c 6d 10 	movl   $0x106d4c,0xc(%esp)
  103ff9:	00 
  103ffa:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  104001:	00 
  104002:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  104009:	00 
  10400a:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  104011:	e8 d2 c3 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p) == 1);
  104016:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104019:	89 04 24             	mov    %eax,(%esp)
  10401c:	e8 bf ea ff ff       	call   102ae0 <page_ref>
  104021:	83 f8 01             	cmp    $0x1,%eax
  104024:	74 24                	je     10404a <check_boot_pgdir+0x221>
  104026:	c7 44 24 0c 7a 6d 10 	movl   $0x106d7a,0xc(%esp)
  10402d:	00 
  10402e:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  104035:	00 
  104036:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  10403d:	00 
  10403e:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  104045:	e8 9e c3 ff ff       	call   1003e8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  10404a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10404f:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104056:	00 
  104057:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  10405e:	00 
  10405f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104062:	89 54 24 04          	mov    %edx,0x4(%esp)
  104066:	89 04 24             	mov    %eax,(%esp)
  104069:	e8 ec f5 ff ff       	call   10365a <page_insert>
  10406e:	85 c0                	test   %eax,%eax
  104070:	74 24                	je     104096 <check_boot_pgdir+0x26d>
  104072:	c7 44 24 0c 8c 6d 10 	movl   $0x106d8c,0xc(%esp)
  104079:	00 
  10407a:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  104081:	00 
  104082:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  104089:	00 
  10408a:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  104091:	e8 52 c3 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p) == 2);
  104096:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104099:	89 04 24             	mov    %eax,(%esp)
  10409c:	e8 3f ea ff ff       	call   102ae0 <page_ref>
  1040a1:	83 f8 02             	cmp    $0x2,%eax
  1040a4:	74 24                	je     1040ca <check_boot_pgdir+0x2a1>
  1040a6:	c7 44 24 0c c3 6d 10 	movl   $0x106dc3,0xc(%esp)
  1040ad:	00 
  1040ae:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  1040b5:	00 
  1040b6:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
  1040bd:	00 
  1040be:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  1040c5:	e8 1e c3 ff ff       	call   1003e8 <__panic>

    const char *str = "ucore: Hello world!!";
  1040ca:	c7 45 dc d4 6d 10 00 	movl   $0x106dd4,-0x24(%ebp)
    strcpy((void *)0x100, str);
  1040d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1040d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1040d8:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1040df:	e8 ae 15 00 00       	call   105692 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1040e4:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1040eb:	00 
  1040ec:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1040f3:	e8 13 16 00 00       	call   10570b <strcmp>
  1040f8:	85 c0                	test   %eax,%eax
  1040fa:	74 24                	je     104120 <check_boot_pgdir+0x2f7>
  1040fc:	c7 44 24 0c ec 6d 10 	movl   $0x106dec,0xc(%esp)
  104103:	00 
  104104:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  10410b:	00 
  10410c:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104113:	00 
  104114:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  10411b:	e8 c8 c2 ff ff       	call   1003e8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104120:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104123:	89 04 24             	mov    %eax,(%esp)
  104126:	e8 23 e9 ff ff       	call   102a4e <page2kva>
  10412b:	05 00 01 00 00       	add    $0x100,%eax
  104130:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104133:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10413a:	e8 fb 14 00 00       	call   10563a <strlen>
  10413f:	85 c0                	test   %eax,%eax
  104141:	74 24                	je     104167 <check_boot_pgdir+0x33e>
  104143:	c7 44 24 0c 24 6e 10 	movl   $0x106e24,0xc(%esp)
  10414a:	00 
  10414b:	c7 44 24 08 cd 69 10 	movl   $0x1069cd,0x8(%esp)
  104152:	00 
  104153:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  10415a:	00 
  10415b:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  104162:	e8 81 c2 ff ff       	call   1003e8 <__panic>

    free_page(p);
  104167:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10416e:	00 
  10416f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104172:	89 04 24             	mov    %eax,(%esp)
  104175:	e8 a3 eb ff ff       	call   102d1d <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  10417a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10417f:	8b 00                	mov    (%eax),%eax
  104181:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104186:	89 04 24             	mov    %eax,(%esp)
  104189:	e8 71 e8 ff ff       	call   1029ff <pa2page>
  10418e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104195:	00 
  104196:	89 04 24             	mov    %eax,(%esp)
  104199:	e8 7f eb ff ff       	call   102d1d <free_pages>
    boot_pgdir[0] = 0;
  10419e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1041a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1041a9:	c7 04 24 48 6e 10 00 	movl   $0x106e48,(%esp)
  1041b0:	e8 dc c0 ff ff       	call   100291 <cprintf>
}
  1041b5:	c9                   	leave  
  1041b6:	c3                   	ret    

001041b7 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1041b7:	55                   	push   %ebp
  1041b8:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1041ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1041bd:	83 e0 04             	and    $0x4,%eax
  1041c0:	85 c0                	test   %eax,%eax
  1041c2:	74 07                	je     1041cb <perm2str+0x14>
  1041c4:	b8 75 00 00 00       	mov    $0x75,%eax
  1041c9:	eb 05                	jmp    1041d0 <perm2str+0x19>
  1041cb:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1041d0:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  1041d5:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1041dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1041df:	83 e0 02             	and    $0x2,%eax
  1041e2:	85 c0                	test   %eax,%eax
  1041e4:	74 07                	je     1041ed <perm2str+0x36>
  1041e6:	b8 77 00 00 00       	mov    $0x77,%eax
  1041eb:	eb 05                	jmp    1041f2 <perm2str+0x3b>
  1041ed:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1041f2:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  1041f7:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  1041fe:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  104203:	5d                   	pop    %ebp
  104204:	c3                   	ret    

00104205 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  104205:	55                   	push   %ebp
  104206:	89 e5                	mov    %esp,%ebp
  104208:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10420b:	8b 45 10             	mov    0x10(%ebp),%eax
  10420e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104211:	72 0a                	jb     10421d <get_pgtable_items+0x18>
        return 0;
  104213:	b8 00 00 00 00       	mov    $0x0,%eax
  104218:	e9 9c 00 00 00       	jmp    1042b9 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  10421d:	eb 04                	jmp    104223 <get_pgtable_items+0x1e>
        start ++;
  10421f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  104223:	8b 45 10             	mov    0x10(%ebp),%eax
  104226:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104229:	73 18                	jae    104243 <get_pgtable_items+0x3e>
  10422b:	8b 45 10             	mov    0x10(%ebp),%eax
  10422e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104235:	8b 45 14             	mov    0x14(%ebp),%eax
  104238:	01 d0                	add    %edx,%eax
  10423a:	8b 00                	mov    (%eax),%eax
  10423c:	83 e0 01             	and    $0x1,%eax
  10423f:	85 c0                	test   %eax,%eax
  104241:	74 dc                	je     10421f <get_pgtable_items+0x1a>
    }
    if (start < right) {
  104243:	8b 45 10             	mov    0x10(%ebp),%eax
  104246:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104249:	73 69                	jae    1042b4 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  10424b:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10424f:	74 08                	je     104259 <get_pgtable_items+0x54>
            *left_store = start;
  104251:	8b 45 18             	mov    0x18(%ebp),%eax
  104254:	8b 55 10             	mov    0x10(%ebp),%edx
  104257:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  104259:	8b 45 10             	mov    0x10(%ebp),%eax
  10425c:	8d 50 01             	lea    0x1(%eax),%edx
  10425f:	89 55 10             	mov    %edx,0x10(%ebp)
  104262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104269:	8b 45 14             	mov    0x14(%ebp),%eax
  10426c:	01 d0                	add    %edx,%eax
  10426e:	8b 00                	mov    (%eax),%eax
  104270:	83 e0 07             	and    $0x7,%eax
  104273:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104276:	eb 04                	jmp    10427c <get_pgtable_items+0x77>
            start ++;
  104278:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10427c:	8b 45 10             	mov    0x10(%ebp),%eax
  10427f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104282:	73 1d                	jae    1042a1 <get_pgtable_items+0x9c>
  104284:	8b 45 10             	mov    0x10(%ebp),%eax
  104287:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10428e:	8b 45 14             	mov    0x14(%ebp),%eax
  104291:	01 d0                	add    %edx,%eax
  104293:	8b 00                	mov    (%eax),%eax
  104295:	83 e0 07             	and    $0x7,%eax
  104298:	89 c2                	mov    %eax,%edx
  10429a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10429d:	39 c2                	cmp    %eax,%edx
  10429f:	74 d7                	je     104278 <get_pgtable_items+0x73>
        }
        if (right_store != NULL) {
  1042a1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1042a5:	74 08                	je     1042af <get_pgtable_items+0xaa>
            *right_store = start;
  1042a7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1042aa:	8b 55 10             	mov    0x10(%ebp),%edx
  1042ad:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1042af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1042b2:	eb 05                	jmp    1042b9 <get_pgtable_items+0xb4>
    }
    return 0;
  1042b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1042b9:	c9                   	leave  
  1042ba:	c3                   	ret    

001042bb <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1042bb:	55                   	push   %ebp
  1042bc:	89 e5                	mov    %esp,%ebp
  1042be:	57                   	push   %edi
  1042bf:	56                   	push   %esi
  1042c0:	53                   	push   %ebx
  1042c1:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1042c4:	c7 04 24 68 6e 10 00 	movl   $0x106e68,(%esp)
  1042cb:	e8 c1 bf ff ff       	call   100291 <cprintf>
    size_t left, right = 0, perm;
  1042d0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1042d7:	e9 fa 00 00 00       	jmp    1043d6 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1042dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1042df:	89 04 24             	mov    %eax,(%esp)
  1042e2:	e8 d0 fe ff ff       	call   1041b7 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1042e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1042ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1042ed:	29 d1                	sub    %edx,%ecx
  1042ef:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1042f1:	89 d6                	mov    %edx,%esi
  1042f3:	c1 e6 16             	shl    $0x16,%esi
  1042f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1042f9:	89 d3                	mov    %edx,%ebx
  1042fb:	c1 e3 16             	shl    $0x16,%ebx
  1042fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104301:	89 d1                	mov    %edx,%ecx
  104303:	c1 e1 16             	shl    $0x16,%ecx
  104306:	8b 7d dc             	mov    -0x24(%ebp),%edi
  104309:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10430c:	29 d7                	sub    %edx,%edi
  10430e:	89 fa                	mov    %edi,%edx
  104310:	89 44 24 14          	mov    %eax,0x14(%esp)
  104314:	89 74 24 10          	mov    %esi,0x10(%esp)
  104318:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10431c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104320:	89 54 24 04          	mov    %edx,0x4(%esp)
  104324:	c7 04 24 99 6e 10 00 	movl   $0x106e99,(%esp)
  10432b:	e8 61 bf ff ff       	call   100291 <cprintf>
        size_t l, r = left * NPTEENTRY;
  104330:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104333:	c1 e0 0a             	shl    $0xa,%eax
  104336:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104339:	eb 54                	jmp    10438f <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10433b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10433e:	89 04 24             	mov    %eax,(%esp)
  104341:	e8 71 fe ff ff       	call   1041b7 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104346:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104349:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10434c:	29 d1                	sub    %edx,%ecx
  10434e:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104350:	89 d6                	mov    %edx,%esi
  104352:	c1 e6 0c             	shl    $0xc,%esi
  104355:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104358:	89 d3                	mov    %edx,%ebx
  10435a:	c1 e3 0c             	shl    $0xc,%ebx
  10435d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104360:	c1 e2 0c             	shl    $0xc,%edx
  104363:	89 d1                	mov    %edx,%ecx
  104365:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  104368:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10436b:	29 d7                	sub    %edx,%edi
  10436d:	89 fa                	mov    %edi,%edx
  10436f:	89 44 24 14          	mov    %eax,0x14(%esp)
  104373:	89 74 24 10          	mov    %esi,0x10(%esp)
  104377:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10437b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10437f:	89 54 24 04          	mov    %edx,0x4(%esp)
  104383:	c7 04 24 b8 6e 10 00 	movl   $0x106eb8,(%esp)
  10438a:	e8 02 bf ff ff       	call   100291 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10438f:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  104394:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104397:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10439a:	89 ce                	mov    %ecx,%esi
  10439c:	c1 e6 0a             	shl    $0xa,%esi
  10439f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1043a2:	89 cb                	mov    %ecx,%ebx
  1043a4:	c1 e3 0a             	shl    $0xa,%ebx
  1043a7:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1043aa:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1043ae:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1043b1:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1043b5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1043b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1043bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  1043c1:	89 1c 24             	mov    %ebx,(%esp)
  1043c4:	e8 3c fe ff ff       	call   104205 <get_pgtable_items>
  1043c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1043cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1043d0:	0f 85 65 ff ff ff    	jne    10433b <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1043d6:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  1043db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1043de:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1043e1:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1043e5:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1043e8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1043ec:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1043f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1043f4:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1043fb:	00 
  1043fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104403:	e8 fd fd ff ff       	call   104205 <get_pgtable_items>
  104408:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10440b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10440f:	0f 85 c7 fe ff ff    	jne    1042dc <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  104415:	c7 04 24 dc 6e 10 00 	movl   $0x106edc,(%esp)
  10441c:	e8 70 be ff ff       	call   100291 <cprintf>
}
  104421:	83 c4 4c             	add    $0x4c,%esp
  104424:	5b                   	pop    %ebx
  104425:	5e                   	pop    %esi
  104426:	5f                   	pop    %edi
  104427:	5d                   	pop    %ebp
  104428:	c3                   	ret    

00104429 <page2ppn>:
page2ppn(struct Page *page) {
  104429:	55                   	push   %ebp
  10442a:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10442c:	8b 55 08             	mov    0x8(%ebp),%edx
  10442f:	a1 58 89 11 00       	mov    0x118958,%eax
  104434:	29 c2                	sub    %eax,%edx
  104436:	89 d0                	mov    %edx,%eax
  104438:	c1 f8 02             	sar    $0x2,%eax
  10443b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  104441:	5d                   	pop    %ebp
  104442:	c3                   	ret    

00104443 <page2pa>:
page2pa(struct Page *page) {
  104443:	55                   	push   %ebp
  104444:	89 e5                	mov    %esp,%ebp
  104446:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  104449:	8b 45 08             	mov    0x8(%ebp),%eax
  10444c:	89 04 24             	mov    %eax,(%esp)
  10444f:	e8 d5 ff ff ff       	call   104429 <page2ppn>
  104454:	c1 e0 0c             	shl    $0xc,%eax
}
  104457:	c9                   	leave  
  104458:	c3                   	ret    

00104459 <page_ref>:
page_ref(struct Page *page) {
  104459:	55                   	push   %ebp
  10445a:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10445c:	8b 45 08             	mov    0x8(%ebp),%eax
  10445f:	8b 00                	mov    (%eax),%eax
}
  104461:	5d                   	pop    %ebp
  104462:	c3                   	ret    

00104463 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  104463:	55                   	push   %ebp
  104464:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104466:	8b 45 08             	mov    0x8(%ebp),%eax
  104469:	8b 55 0c             	mov    0xc(%ebp),%edx
  10446c:	89 10                	mov    %edx,(%eax)
}
  10446e:	5d                   	pop    %ebp
  10446f:	c3                   	ret    

00104470 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  104470:	55                   	push   %ebp
  104471:	89 e5                	mov    %esp,%ebp
  104473:	83 ec 10             	sub    $0x10,%esp
  104476:	c7 45 fc 5c 89 11 00 	movl   $0x11895c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10447d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104480:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104483:	89 50 04             	mov    %edx,0x4(%eax)
  104486:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104489:	8b 50 04             	mov    0x4(%eax),%edx
  10448c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10448f:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  104491:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  104498:	00 00 00 
}
  10449b:	c9                   	leave  
  10449c:	c3                   	ret    

0010449d <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  10449d:	55                   	push   %ebp
  10449e:	89 e5                	mov    %esp,%ebp
  1044a0:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  1044a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1044a7:	75 24                	jne    1044cd <default_init_memmap+0x30>
  1044a9:	c7 44 24 0c 10 6f 10 	movl   $0x106f10,0xc(%esp)
  1044b0:	00 
  1044b1:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  1044b8:	00 
  1044b9:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  1044c0:	00 
  1044c1:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  1044c8:	e8 1b bf ff ff       	call   1003e8 <__panic>
    struct Page *p = base;
  1044cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1044d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1044d3:	eb 7d                	jmp    104552 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  1044d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044d8:	83 c0 04             	add    $0x4,%eax
  1044db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1044e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1044e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1044eb:	0f a3 10             	bt     %edx,(%eax)
  1044ee:	19 c0                	sbb    %eax,%eax
  1044f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1044f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1044f7:	0f 95 c0             	setne  %al
  1044fa:	0f b6 c0             	movzbl %al,%eax
  1044fd:	85 c0                	test   %eax,%eax
  1044ff:	75 24                	jne    104525 <default_init_memmap+0x88>
  104501:	c7 44 24 0c 41 6f 10 	movl   $0x106f41,0xc(%esp)
  104508:	00 
  104509:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104510:	00 
  104511:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  104518:	00 
  104519:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104520:	e8 c3 be ff ff       	call   1003e8 <__panic>
        p->flags = p->property = 0;
  104525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104528:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  10452f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104532:	8b 50 08             	mov    0x8(%eax),%edx
  104535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104538:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  10453b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104542:	00 
  104543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104546:	89 04 24             	mov    %eax,(%esp)
  104549:	e8 15 ff ff ff       	call   104463 <set_page_ref>
    for (; p != base + n; p ++) {
  10454e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104552:	8b 55 0c             	mov    0xc(%ebp),%edx
  104555:	89 d0                	mov    %edx,%eax
  104557:	c1 e0 02             	shl    $0x2,%eax
  10455a:	01 d0                	add    %edx,%eax
  10455c:	c1 e0 02             	shl    $0x2,%eax
  10455f:	89 c2                	mov    %eax,%edx
  104561:	8b 45 08             	mov    0x8(%ebp),%eax
  104564:	01 d0                	add    %edx,%eax
  104566:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104569:	0f 85 66 ff ff ff    	jne    1044d5 <default_init_memmap+0x38>
    }
    base->property = n;
  10456f:	8b 45 08             	mov    0x8(%ebp),%eax
  104572:	8b 55 0c             	mov    0xc(%ebp),%edx
  104575:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104578:	8b 45 08             	mov    0x8(%ebp),%eax
  10457b:	83 c0 04             	add    $0x4,%eax
  10457e:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  104585:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104588:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10458b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10458e:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  104591:	8b 15 64 89 11 00    	mov    0x118964,%edx
  104597:	8b 45 0c             	mov    0xc(%ebp),%eax
  10459a:	01 d0                	add    %edx,%eax
  10459c:	a3 64 89 11 00       	mov    %eax,0x118964
    list_add_before(&free_list, &(base->page_link));
  1045a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1045a4:	83 c0 0c             	add    $0xc,%eax
  1045a7:	c7 45 dc 5c 89 11 00 	movl   $0x11895c,-0x24(%ebp)
  1045ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  1045b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1045b4:	8b 00                	mov    (%eax),%eax
  1045b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1045b9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1045bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1045bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1045c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1045c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1045c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1045cb:	89 10                	mov    %edx,(%eax)
  1045cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1045d0:	8b 10                	mov    (%eax),%edx
  1045d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1045d5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1045d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1045db:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1045de:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1045e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1045e4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1045e7:	89 10                	mov    %edx,(%eax)
}
  1045e9:	c9                   	leave  
  1045ea:	c3                   	ret    

001045eb <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1045eb:	55                   	push   %ebp
  1045ec:	89 e5                	mov    %esp,%ebp
  1045ee:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);//判断n是否大于0
  1045f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1045f5:	75 24                	jne    10461b <default_alloc_pages+0x30>
  1045f7:	c7 44 24 0c 10 6f 10 	movl   $0x106f10,0xc(%esp)
  1045fe:	00 
  1045ff:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104606:	00 
  104607:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  10460e:	00 
  10460f:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104616:	e8 cd bd ff ff       	call   1003e8 <__panic>
    if (n > nr_free) {//需要分配页的个数小于空闲页的总数,直接返回
  10461b:	a1 64 89 11 00       	mov    0x118964,%eax
  104620:	3b 45 08             	cmp    0x8(%ebp),%eax
  104623:	73 0a                	jae    10462f <default_alloc_pages+0x44>
        return NULL;
  104625:	b8 00 00 00 00       	mov    $0x0,%eax
  10462a:	e9 3d 01 00 00       	jmp    10476c <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
  10462f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  104636:	c7 45 f0 5c 89 11 00 	movl   $0x11895c,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
  10463d:	eb 1c                	jmp    10465b <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  10463f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104642:	83 e8 0c             	sub    $0xc,%eax
  104645:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  104648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10464b:	8b 40 08             	mov    0x8(%eax),%eax
  10464e:	3b 45 08             	cmp    0x8(%ebp),%eax
  104651:	72 08                	jb     10465b <default_alloc_pages+0x70>
            page = p;
  104653:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104656:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  104659:	eb 18                	jmp    104673 <default_alloc_pages+0x88>
  10465b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10465e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  104661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104664:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104667:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10466a:	81 7d f0 5c 89 11 00 	cmpl   $0x11895c,-0x10(%ebp)
  104671:	75 cc                	jne    10463f <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
  104673:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104677:	0f 84 ec 00 00 00    	je     104769 <default_alloc_pages+0x17e>
        if (page->property > n) {
  10467d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104680:	8b 40 08             	mov    0x8(%eax),%eax
  104683:	3b 45 08             	cmp    0x8(%ebp),%eax
  104686:	0f 86 8c 00 00 00    	jbe    104718 <default_alloc_pages+0x12d>
            struct Page *p = page + n;
  10468c:	8b 55 08             	mov    0x8(%ebp),%edx
  10468f:	89 d0                	mov    %edx,%eax
  104691:	c1 e0 02             	shl    $0x2,%eax
  104694:	01 d0                	add    %edx,%eax
  104696:	c1 e0 02             	shl    $0x2,%eax
  104699:	89 c2                	mov    %eax,%edx
  10469b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10469e:	01 d0                	add    %edx,%eax
  1046a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  1046a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046a6:	8b 40 08             	mov    0x8(%eax),%eax
  1046a9:	2b 45 08             	sub    0x8(%ebp),%eax
  1046ac:	89 c2                	mov    %eax,%edx
  1046ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1046b1:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  1046b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1046b7:	83 c0 04             	add    $0x4,%eax
  1046ba:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1046c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1046c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1046c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1046ca:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
  1046cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1046d0:	83 c0 0c             	add    $0xc,%eax
  1046d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1046d6:	83 c2 0c             	add    $0xc,%edx
  1046d9:	89 55 d8             	mov    %edx,-0x28(%ebp)
  1046dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
  1046df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1046e2:	8b 40 04             	mov    0x4(%eax),%eax
  1046e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1046e8:	89 55 d0             	mov    %edx,-0x30(%ebp)
  1046eb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1046ee:	89 55 cc             	mov    %edx,-0x34(%ebp)
  1046f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
  1046f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1046f7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1046fa:	89 10                	mov    %edx,(%eax)
  1046fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1046ff:	8b 10                	mov    (%eax),%edx
  104701:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104704:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104707:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10470a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10470d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104710:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104713:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104716:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
  104718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10471b:	83 c0 0c             	add    $0xc,%eax
  10471e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104721:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104724:	8b 40 04             	mov    0x4(%eax),%eax
  104727:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10472a:	8b 12                	mov    (%edx),%edx
  10472c:	89 55 c0             	mov    %edx,-0x40(%ebp)
  10472f:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104732:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104735:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104738:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10473b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10473e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104741:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
  104743:	a1 64 89 11 00       	mov    0x118964,%eax
  104748:	2b 45 08             	sub    0x8(%ebp),%eax
  10474b:	a3 64 89 11 00       	mov    %eax,0x118964
        ClearPageProperty(page);
  104750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104753:	83 c0 04             	add    $0x4,%eax
  104756:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  10475d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104760:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104763:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104766:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  104769:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10476c:	c9                   	leave  
  10476d:	c3                   	ret    

0010476e <default_free_pages>:
    

static void
default_free_pages(struct Page *base, size_t n) {
  10476e:	55                   	push   %ebp
  10476f:	89 e5                	mov    %esp,%ebp
  104771:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  104777:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10477b:	75 24                	jne    1047a1 <default_free_pages+0x33>
  10477d:	c7 44 24 0c 10 6f 10 	movl   $0x106f10,0xc(%esp)
  104784:	00 
  104785:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  10478c:	00 
  10478d:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  104794:	00 
  104795:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  10479c:	e8 47 bc ff ff       	call   1003e8 <__panic>
    struct Page *p = base;
  1047a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1047a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1047a7:	e9 9d 00 00 00       	jmp    104849 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  1047ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047af:	83 c0 04             	add    $0x4,%eax
  1047b2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1047b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1047bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1047bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1047c2:	0f a3 10             	bt     %edx,(%eax)
  1047c5:	19 c0                	sbb    %eax,%eax
  1047c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  1047ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1047ce:	0f 95 c0             	setne  %al
  1047d1:	0f b6 c0             	movzbl %al,%eax
  1047d4:	85 c0                	test   %eax,%eax
  1047d6:	75 2c                	jne    104804 <default_free_pages+0x96>
  1047d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047db:	83 c0 04             	add    $0x4,%eax
  1047de:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1047e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1047e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1047eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1047ee:	0f a3 10             	bt     %edx,(%eax)
  1047f1:	19 c0                	sbb    %eax,%eax
  1047f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  1047f6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1047fa:	0f 95 c0             	setne  %al
  1047fd:	0f b6 c0             	movzbl %al,%eax
  104800:	85 c0                	test   %eax,%eax
  104802:	74 24                	je     104828 <default_free_pages+0xba>
  104804:	c7 44 24 0c 54 6f 10 	movl   $0x106f54,0xc(%esp)
  10480b:	00 
  10480c:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104813:	00 
  104814:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
  10481b:	00 
  10481c:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104823:	e8 c0 bb ff ff       	call   1003e8 <__panic>
        p->flags = 0;
  104828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10482b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  104832:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104839:	00 
  10483a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10483d:	89 04 24             	mov    %eax,(%esp)
  104840:	e8 1e fc ff ff       	call   104463 <set_page_ref>
    for (; p != base + n; p ++) {
  104845:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104849:	8b 55 0c             	mov    0xc(%ebp),%edx
  10484c:	89 d0                	mov    %edx,%eax
  10484e:	c1 e0 02             	shl    $0x2,%eax
  104851:	01 d0                	add    %edx,%eax
  104853:	c1 e0 02             	shl    $0x2,%eax
  104856:	89 c2                	mov    %eax,%edx
  104858:	8b 45 08             	mov    0x8(%ebp),%eax
  10485b:	01 d0                	add    %edx,%eax
  10485d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104860:	0f 85 46 ff ff ff    	jne    1047ac <default_free_pages+0x3e>
    }
    base->property = n;
  104866:	8b 45 08             	mov    0x8(%ebp),%eax
  104869:	8b 55 0c             	mov    0xc(%ebp),%edx
  10486c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  10486f:	8b 45 08             	mov    0x8(%ebp),%eax
  104872:	83 c0 04             	add    $0x4,%eax
  104875:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  10487c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10487f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104882:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104885:	0f ab 10             	bts    %edx,(%eax)
  104888:	c7 45 cc 5c 89 11 00 	movl   $0x11895c,-0x34(%ebp)
    return listelm->next;
  10488f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104892:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  104895:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104898:	e9 08 01 00 00       	jmp    1049a5 <default_free_pages+0x237>
        p = le2page(le, page_link);
  10489d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048a0:	83 e8 0c             	sub    $0xc,%eax
  1048a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1048a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048a9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1048ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1048af:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  1048b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
  1048b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1048b8:	8b 50 08             	mov    0x8(%eax),%edx
  1048bb:	89 d0                	mov    %edx,%eax
  1048bd:	c1 e0 02             	shl    $0x2,%eax
  1048c0:	01 d0                	add    %edx,%eax
  1048c2:	c1 e0 02             	shl    $0x2,%eax
  1048c5:	89 c2                	mov    %eax,%edx
  1048c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1048ca:	01 d0                	add    %edx,%eax
  1048cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1048cf:	75 5a                	jne    10492b <default_free_pages+0x1bd>
            base->property += p->property;
  1048d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1048d4:	8b 50 08             	mov    0x8(%eax),%edx
  1048d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048da:	8b 40 08             	mov    0x8(%eax),%eax
  1048dd:	01 c2                	add    %eax,%edx
  1048df:	8b 45 08             	mov    0x8(%ebp),%eax
  1048e2:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  1048e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048e8:	83 c0 04             	add    $0x4,%eax
  1048eb:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  1048f2:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1048f5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1048f8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1048fb:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  1048fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104901:	83 c0 0c             	add    $0xc,%eax
  104904:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  104907:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10490a:	8b 40 04             	mov    0x4(%eax),%eax
  10490d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104910:	8b 12                	mov    (%edx),%edx
  104912:	89 55 b8             	mov    %edx,-0x48(%ebp)
  104915:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next;
  104918:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10491b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10491e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104921:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104924:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104927:	89 10                	mov    %edx,(%eax)
  104929:	eb 7a                	jmp    1049a5 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  10492b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10492e:	8b 50 08             	mov    0x8(%eax),%edx
  104931:	89 d0                	mov    %edx,%eax
  104933:	c1 e0 02             	shl    $0x2,%eax
  104936:	01 d0                	add    %edx,%eax
  104938:	c1 e0 02             	shl    $0x2,%eax
  10493b:	89 c2                	mov    %eax,%edx
  10493d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104940:	01 d0                	add    %edx,%eax
  104942:	3b 45 08             	cmp    0x8(%ebp),%eax
  104945:	75 5e                	jne    1049a5 <default_free_pages+0x237>
            p->property += base->property;
  104947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10494a:	8b 50 08             	mov    0x8(%eax),%edx
  10494d:	8b 45 08             	mov    0x8(%ebp),%eax
  104950:	8b 40 08             	mov    0x8(%eax),%eax
  104953:	01 c2                	add    %eax,%edx
  104955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104958:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  10495b:	8b 45 08             	mov    0x8(%ebp),%eax
  10495e:	83 c0 04             	add    $0x4,%eax
  104961:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  104968:	89 45 ac             	mov    %eax,-0x54(%ebp)
  10496b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10496e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104971:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  104974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104977:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  10497a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10497d:	83 c0 0c             	add    $0xc,%eax
  104980:	89 45 a8             	mov    %eax,-0x58(%ebp)
    __list_del(listelm->prev, listelm->next);
  104983:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104986:	8b 40 04             	mov    0x4(%eax),%eax
  104989:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10498c:	8b 12                	mov    (%edx),%edx
  10498e:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  104991:	89 45 a0             	mov    %eax,-0x60(%ebp)
    prev->next = next;
  104994:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104997:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10499a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10499d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1049a0:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1049a3:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
  1049a5:	81 7d f0 5c 89 11 00 	cmpl   $0x11895c,-0x10(%ebp)
  1049ac:	0f 85 eb fe ff ff    	jne    10489d <default_free_pages+0x12f>
        }
    }
    nr_free += n;
  1049b2:	8b 15 64 89 11 00    	mov    0x118964,%edx
  1049b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1049bb:	01 d0                	add    %edx,%eax
  1049bd:	a3 64 89 11 00       	mov    %eax,0x118964
  1049c2:	c7 45 9c 5c 89 11 00 	movl   $0x11895c,-0x64(%ebp)
    return listelm->next;
  1049c9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1049cc:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
  1049cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  1049d2:	eb 76                	jmp    104a4a <default_free_pages+0x2dc>
        p = le2page(le, page_link);
  1049d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049d7:	83 e8 0c             	sub    $0xc,%eax
  1049da:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
  1049dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1049e0:	8b 50 08             	mov    0x8(%eax),%edx
  1049e3:	89 d0                	mov    %edx,%eax
  1049e5:	c1 e0 02             	shl    $0x2,%eax
  1049e8:	01 d0                	add    %edx,%eax
  1049ea:	c1 e0 02             	shl    $0x2,%eax
  1049ed:	89 c2                	mov    %eax,%edx
  1049ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1049f2:	01 d0                	add    %edx,%eax
  1049f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1049f7:	77 42                	ja     104a3b <default_free_pages+0x2cd>
            assert(base + base->property != p);
  1049f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1049fc:	8b 50 08             	mov    0x8(%eax),%edx
  1049ff:	89 d0                	mov    %edx,%eax
  104a01:	c1 e0 02             	shl    $0x2,%eax
  104a04:	01 d0                	add    %edx,%eax
  104a06:	c1 e0 02             	shl    $0x2,%eax
  104a09:	89 c2                	mov    %eax,%edx
  104a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  104a0e:	01 d0                	add    %edx,%eax
  104a10:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104a13:	75 24                	jne    104a39 <default_free_pages+0x2cb>
  104a15:	c7 44 24 0c 79 6f 10 	movl   $0x106f79,0xc(%esp)
  104a1c:	00 
  104a1d:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104a24:	00 
  104a25:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  104a2c:	00 
  104a2d:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104a34:	e8 af b9 ff ff       	call   1003e8 <__panic>
            break;
  104a39:	eb 18                	jmp    104a53 <default_free_pages+0x2e5>
  104a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a3e:	89 45 98             	mov    %eax,-0x68(%ebp)
  104a41:	8b 45 98             	mov    -0x68(%ebp),%eax
  104a44:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
  104a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104a4a:	81 7d f0 5c 89 11 00 	cmpl   $0x11895c,-0x10(%ebp)
  104a51:	75 81                	jne    1049d4 <default_free_pages+0x266>
    }
    list_add_before(le, &(base->page_link));
  104a53:	8b 45 08             	mov    0x8(%ebp),%eax
  104a56:	8d 50 0c             	lea    0xc(%eax),%edx
  104a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a5c:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104a5f:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  104a62:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104a65:	8b 00                	mov    (%eax),%eax
  104a67:	8b 55 90             	mov    -0x70(%ebp),%edx
  104a6a:	89 55 8c             	mov    %edx,-0x74(%ebp)
  104a6d:	89 45 88             	mov    %eax,-0x78(%ebp)
  104a70:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104a73:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  104a76:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104a79:	8b 55 8c             	mov    -0x74(%ebp),%edx
  104a7c:	89 10                	mov    %edx,(%eax)
  104a7e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104a81:	8b 10                	mov    (%eax),%edx
  104a83:	8b 45 88             	mov    -0x78(%ebp),%eax
  104a86:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104a89:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104a8c:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104a8f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104a92:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104a95:	8b 55 88             	mov    -0x78(%ebp),%edx
  104a98:	89 10                	mov    %edx,(%eax)
}
  104a9a:	c9                   	leave  
  104a9b:	c3                   	ret    

00104a9c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104a9c:	55                   	push   %ebp
  104a9d:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104a9f:	a1 64 89 11 00       	mov    0x118964,%eax
}
  104aa4:	5d                   	pop    %ebp
  104aa5:	c3                   	ret    

00104aa6 <basic_check>:

static void
basic_check(void) {
  104aa6:	55                   	push   %ebp
  104aa7:	89 e5                	mov    %esp,%ebp
  104aa9:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104aac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104abc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104abf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ac6:	e8 1a e2 ff ff       	call   102ce5 <alloc_pages>
  104acb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104ace:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104ad2:	75 24                	jne    104af8 <basic_check+0x52>
  104ad4:	c7 44 24 0c 94 6f 10 	movl   $0x106f94,0xc(%esp)
  104adb:	00 
  104adc:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104ae3:	00 
  104ae4:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  104aeb:	00 
  104aec:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104af3:	e8 f0 b8 ff ff       	call   1003e8 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104af8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104aff:	e8 e1 e1 ff ff       	call   102ce5 <alloc_pages>
  104b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b0b:	75 24                	jne    104b31 <basic_check+0x8b>
  104b0d:	c7 44 24 0c b0 6f 10 	movl   $0x106fb0,0xc(%esp)
  104b14:	00 
  104b15:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104b1c:	00 
  104b1d:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  104b24:	00 
  104b25:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104b2c:	e8 b7 b8 ff ff       	call   1003e8 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104b31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b38:	e8 a8 e1 ff ff       	call   102ce5 <alloc_pages>
  104b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104b40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104b44:	75 24                	jne    104b6a <basic_check+0xc4>
  104b46:	c7 44 24 0c cc 6f 10 	movl   $0x106fcc,0xc(%esp)
  104b4d:	00 
  104b4e:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104b55:	00 
  104b56:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
  104b5d:	00 
  104b5e:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104b65:	e8 7e b8 ff ff       	call   1003e8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b6d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104b70:	74 10                	je     104b82 <basic_check+0xdc>
  104b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b75:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104b78:	74 08                	je     104b82 <basic_check+0xdc>
  104b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b7d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104b80:	75 24                	jne    104ba6 <basic_check+0x100>
  104b82:	c7 44 24 0c e8 6f 10 	movl   $0x106fe8,0xc(%esp)
  104b89:	00 
  104b8a:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104b91:	00 
  104b92:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  104b99:	00 
  104b9a:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104ba1:	e8 42 b8 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ba9:	89 04 24             	mov    %eax,(%esp)
  104bac:	e8 a8 f8 ff ff       	call   104459 <page_ref>
  104bb1:	85 c0                	test   %eax,%eax
  104bb3:	75 1e                	jne    104bd3 <basic_check+0x12d>
  104bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bb8:	89 04 24             	mov    %eax,(%esp)
  104bbb:	e8 99 f8 ff ff       	call   104459 <page_ref>
  104bc0:	85 c0                	test   %eax,%eax
  104bc2:	75 0f                	jne    104bd3 <basic_check+0x12d>
  104bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bc7:	89 04 24             	mov    %eax,(%esp)
  104bca:	e8 8a f8 ff ff       	call   104459 <page_ref>
  104bcf:	85 c0                	test   %eax,%eax
  104bd1:	74 24                	je     104bf7 <basic_check+0x151>
  104bd3:	c7 44 24 0c 0c 70 10 	movl   $0x10700c,0xc(%esp)
  104bda:	00 
  104bdb:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104be2:	00 
  104be3:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  104bea:	00 
  104beb:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104bf2:	e8 f1 b7 ff ff       	call   1003e8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104bf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104bfa:	89 04 24             	mov    %eax,(%esp)
  104bfd:	e8 41 f8 ff ff       	call   104443 <page2pa>
  104c02:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  104c08:	c1 e2 0c             	shl    $0xc,%edx
  104c0b:	39 d0                	cmp    %edx,%eax
  104c0d:	72 24                	jb     104c33 <basic_check+0x18d>
  104c0f:	c7 44 24 0c 48 70 10 	movl   $0x107048,0xc(%esp)
  104c16:	00 
  104c17:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104c1e:	00 
  104c1f:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  104c26:	00 
  104c27:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104c2e:	e8 b5 b7 ff ff       	call   1003e8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c36:	89 04 24             	mov    %eax,(%esp)
  104c39:	e8 05 f8 ff ff       	call   104443 <page2pa>
  104c3e:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  104c44:	c1 e2 0c             	shl    $0xc,%edx
  104c47:	39 d0                	cmp    %edx,%eax
  104c49:	72 24                	jb     104c6f <basic_check+0x1c9>
  104c4b:	c7 44 24 0c 65 70 10 	movl   $0x107065,0xc(%esp)
  104c52:	00 
  104c53:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104c5a:	00 
  104c5b:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  104c62:	00 
  104c63:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104c6a:	e8 79 b7 ff ff       	call   1003e8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c72:	89 04 24             	mov    %eax,(%esp)
  104c75:	e8 c9 f7 ff ff       	call   104443 <page2pa>
  104c7a:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  104c80:	c1 e2 0c             	shl    $0xc,%edx
  104c83:	39 d0                	cmp    %edx,%eax
  104c85:	72 24                	jb     104cab <basic_check+0x205>
  104c87:	c7 44 24 0c 82 70 10 	movl   $0x107082,0xc(%esp)
  104c8e:	00 
  104c8f:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104c96:	00 
  104c97:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  104c9e:	00 
  104c9f:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104ca6:	e8 3d b7 ff ff       	call   1003e8 <__panic>

    list_entry_t free_list_store = free_list;
  104cab:	a1 5c 89 11 00       	mov    0x11895c,%eax
  104cb0:	8b 15 60 89 11 00    	mov    0x118960,%edx
  104cb6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104cb9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104cbc:	c7 45 e0 5c 89 11 00 	movl   $0x11895c,-0x20(%ebp)
    elm->prev = elm->next = elm;
  104cc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104cc6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104cc9:	89 50 04             	mov    %edx,0x4(%eax)
  104ccc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ccf:	8b 50 04             	mov    0x4(%eax),%edx
  104cd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104cd5:	89 10                	mov    %edx,(%eax)
  104cd7:	c7 45 dc 5c 89 11 00 	movl   $0x11895c,-0x24(%ebp)
    return list->next == list;
  104cde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ce1:	8b 40 04             	mov    0x4(%eax),%eax
  104ce4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104ce7:	0f 94 c0             	sete   %al
  104cea:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104ced:	85 c0                	test   %eax,%eax
  104cef:	75 24                	jne    104d15 <basic_check+0x26f>
  104cf1:	c7 44 24 0c 9f 70 10 	movl   $0x10709f,0xc(%esp)
  104cf8:	00 
  104cf9:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104d00:	00 
  104d01:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  104d08:	00 
  104d09:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104d10:	e8 d3 b6 ff ff       	call   1003e8 <__panic>

    unsigned int nr_free_store = nr_free;
  104d15:	a1 64 89 11 00       	mov    0x118964,%eax
  104d1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104d1d:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  104d24:	00 00 00 

    assert(alloc_page() == NULL);
  104d27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d2e:	e8 b2 df ff ff       	call   102ce5 <alloc_pages>
  104d33:	85 c0                	test   %eax,%eax
  104d35:	74 24                	je     104d5b <basic_check+0x2b5>
  104d37:	c7 44 24 0c b6 70 10 	movl   $0x1070b6,0xc(%esp)
  104d3e:	00 
  104d3f:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104d46:	00 
  104d47:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  104d4e:	00 
  104d4f:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104d56:	e8 8d b6 ff ff       	call   1003e8 <__panic>

    free_page(p0);
  104d5b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d62:	00 
  104d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d66:	89 04 24             	mov    %eax,(%esp)
  104d69:	e8 af df ff ff       	call   102d1d <free_pages>
    free_page(p1);
  104d6e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d75:	00 
  104d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d79:	89 04 24             	mov    %eax,(%esp)
  104d7c:	e8 9c df ff ff       	call   102d1d <free_pages>
    free_page(p2);
  104d81:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d88:	00 
  104d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d8c:	89 04 24             	mov    %eax,(%esp)
  104d8f:	e8 89 df ff ff       	call   102d1d <free_pages>
    assert(nr_free == 3);
  104d94:	a1 64 89 11 00       	mov    0x118964,%eax
  104d99:	83 f8 03             	cmp    $0x3,%eax
  104d9c:	74 24                	je     104dc2 <basic_check+0x31c>
  104d9e:	c7 44 24 0c cb 70 10 	movl   $0x1070cb,0xc(%esp)
  104da5:	00 
  104da6:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104dad:	00 
  104dae:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  104db5:	00 
  104db6:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104dbd:	e8 26 b6 ff ff       	call   1003e8 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104dc2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104dc9:	e8 17 df ff ff       	call   102ce5 <alloc_pages>
  104dce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104dd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104dd5:	75 24                	jne    104dfb <basic_check+0x355>
  104dd7:	c7 44 24 0c 94 6f 10 	movl   $0x106f94,0xc(%esp)
  104dde:	00 
  104ddf:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104de6:	00 
  104de7:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
  104dee:	00 
  104def:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104df6:	e8 ed b5 ff ff       	call   1003e8 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104dfb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e02:	e8 de de ff ff       	call   102ce5 <alloc_pages>
  104e07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104e0e:	75 24                	jne    104e34 <basic_check+0x38e>
  104e10:	c7 44 24 0c b0 6f 10 	movl   $0x106fb0,0xc(%esp)
  104e17:	00 
  104e18:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104e1f:	00 
  104e20:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  104e27:	00 
  104e28:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104e2f:	e8 b4 b5 ff ff       	call   1003e8 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104e34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e3b:	e8 a5 de ff ff       	call   102ce5 <alloc_pages>
  104e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104e43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104e47:	75 24                	jne    104e6d <basic_check+0x3c7>
  104e49:	c7 44 24 0c cc 6f 10 	movl   $0x106fcc,0xc(%esp)
  104e50:	00 
  104e51:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104e58:	00 
  104e59:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  104e60:	00 
  104e61:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104e68:	e8 7b b5 ff ff       	call   1003e8 <__panic>

    assert(alloc_page() == NULL);
  104e6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e74:	e8 6c de ff ff       	call   102ce5 <alloc_pages>
  104e79:	85 c0                	test   %eax,%eax
  104e7b:	74 24                	je     104ea1 <basic_check+0x3fb>
  104e7d:	c7 44 24 0c b6 70 10 	movl   $0x1070b6,0xc(%esp)
  104e84:	00 
  104e85:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104e8c:	00 
  104e8d:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
  104e94:	00 
  104e95:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104e9c:	e8 47 b5 ff ff       	call   1003e8 <__panic>

    free_page(p0);
  104ea1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ea8:	00 
  104ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104eac:	89 04 24             	mov    %eax,(%esp)
  104eaf:	e8 69 de ff ff       	call   102d1d <free_pages>
  104eb4:	c7 45 d8 5c 89 11 00 	movl   $0x11895c,-0x28(%ebp)
  104ebb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104ebe:	8b 40 04             	mov    0x4(%eax),%eax
  104ec1:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104ec4:	0f 94 c0             	sete   %al
  104ec7:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104eca:	85 c0                	test   %eax,%eax
  104ecc:	74 24                	je     104ef2 <basic_check+0x44c>
  104ece:	c7 44 24 0c d8 70 10 	movl   $0x1070d8,0xc(%esp)
  104ed5:	00 
  104ed6:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104edd:	00 
  104ede:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
  104ee5:	00 
  104ee6:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104eed:	e8 f6 b4 ff ff       	call   1003e8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104ef2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ef9:	e8 e7 dd ff ff       	call   102ce5 <alloc_pages>
  104efe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104f01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f04:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104f07:	74 24                	je     104f2d <basic_check+0x487>
  104f09:	c7 44 24 0c f0 70 10 	movl   $0x1070f0,0xc(%esp)
  104f10:	00 
  104f11:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104f18:	00 
  104f19:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  104f20:	00 
  104f21:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104f28:	e8 bb b4 ff ff       	call   1003e8 <__panic>
    assert(alloc_page() == NULL);
  104f2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f34:	e8 ac dd ff ff       	call   102ce5 <alloc_pages>
  104f39:	85 c0                	test   %eax,%eax
  104f3b:	74 24                	je     104f61 <basic_check+0x4bb>
  104f3d:	c7 44 24 0c b6 70 10 	movl   $0x1070b6,0xc(%esp)
  104f44:	00 
  104f45:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104f4c:	00 
  104f4d:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  104f54:	00 
  104f55:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104f5c:	e8 87 b4 ff ff       	call   1003e8 <__panic>

    assert(nr_free == 0);
  104f61:	a1 64 89 11 00       	mov    0x118964,%eax
  104f66:	85 c0                	test   %eax,%eax
  104f68:	74 24                	je     104f8e <basic_check+0x4e8>
  104f6a:	c7 44 24 0c 09 71 10 	movl   $0x107109,0xc(%esp)
  104f71:	00 
  104f72:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  104f79:	00 
  104f7a:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  104f81:	00 
  104f82:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  104f89:	e8 5a b4 ff ff       	call   1003e8 <__panic>
    free_list = free_list_store;
  104f8e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104f91:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104f94:	a3 5c 89 11 00       	mov    %eax,0x11895c
  104f99:	89 15 60 89 11 00    	mov    %edx,0x118960
    nr_free = nr_free_store;
  104f9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fa2:	a3 64 89 11 00       	mov    %eax,0x118964

    free_page(p);
  104fa7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104fae:	00 
  104faf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fb2:	89 04 24             	mov    %eax,(%esp)
  104fb5:	e8 63 dd ff ff       	call   102d1d <free_pages>
    free_page(p1);
  104fba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104fc1:	00 
  104fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fc5:	89 04 24             	mov    %eax,(%esp)
  104fc8:	e8 50 dd ff ff       	call   102d1d <free_pages>
    free_page(p2);
  104fcd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104fd4:	00 
  104fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104fd8:	89 04 24             	mov    %eax,(%esp)
  104fdb:	e8 3d dd ff ff       	call   102d1d <free_pages>
}
  104fe0:	c9                   	leave  
  104fe1:	c3                   	ret    

00104fe2 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104fe2:	55                   	push   %ebp
  104fe3:	89 e5                	mov    %esp,%ebp
  104fe5:	53                   	push   %ebx
  104fe6:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  104fec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104ff3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104ffa:	c7 45 ec 5c 89 11 00 	movl   $0x11895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105001:	eb 6b                	jmp    10506e <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  105003:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105006:	83 e8 0c             	sub    $0xc,%eax
  105009:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  10500c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10500f:	83 c0 04             	add    $0x4,%eax
  105012:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  105019:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10501c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10501f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105022:	0f a3 10             	bt     %edx,(%eax)
  105025:	19 c0                	sbb    %eax,%eax
  105027:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  10502a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10502e:	0f 95 c0             	setne  %al
  105031:	0f b6 c0             	movzbl %al,%eax
  105034:	85 c0                	test   %eax,%eax
  105036:	75 24                	jne    10505c <default_check+0x7a>
  105038:	c7 44 24 0c 16 71 10 	movl   $0x107116,0xc(%esp)
  10503f:	00 
  105040:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  105047:	00 
  105048:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  10504f:	00 
  105050:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  105057:	e8 8c b3 ff ff       	call   1003e8 <__panic>
        count ++, total += p->property;
  10505c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  105060:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105063:	8b 50 08             	mov    0x8(%eax),%edx
  105066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105069:	01 d0                	add    %edx,%eax
  10506b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10506e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105071:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  105074:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105077:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  10507a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10507d:	81 7d ec 5c 89 11 00 	cmpl   $0x11895c,-0x14(%ebp)
  105084:	0f 85 79 ff ff ff    	jne    105003 <default_check+0x21>
    }
    assert(total == nr_free_pages());
  10508a:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  10508d:	e8 bd dc ff ff       	call   102d4f <nr_free_pages>
  105092:	39 c3                	cmp    %eax,%ebx
  105094:	74 24                	je     1050ba <default_check+0xd8>
  105096:	c7 44 24 0c 26 71 10 	movl   $0x107126,0xc(%esp)
  10509d:	00 
  10509e:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  1050a5:	00 
  1050a6:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  1050ad:	00 
  1050ae:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  1050b5:	e8 2e b3 ff ff       	call   1003e8 <__panic>

    basic_check();
  1050ba:	e8 e7 f9 ff ff       	call   104aa6 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1050bf:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1050c6:	e8 1a dc ff ff       	call   102ce5 <alloc_pages>
  1050cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1050ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1050d2:	75 24                	jne    1050f8 <default_check+0x116>
  1050d4:	c7 44 24 0c 3f 71 10 	movl   $0x10713f,0xc(%esp)
  1050db:	00 
  1050dc:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  1050e3:	00 
  1050e4:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  1050eb:	00 
  1050ec:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  1050f3:	e8 f0 b2 ff ff       	call   1003e8 <__panic>
    assert(!PageProperty(p0));
  1050f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1050fb:	83 c0 04             	add    $0x4,%eax
  1050fe:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  105105:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105108:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10510b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10510e:	0f a3 10             	bt     %edx,(%eax)
  105111:	19 c0                	sbb    %eax,%eax
  105113:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  105116:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  10511a:	0f 95 c0             	setne  %al
  10511d:	0f b6 c0             	movzbl %al,%eax
  105120:	85 c0                	test   %eax,%eax
  105122:	74 24                	je     105148 <default_check+0x166>
  105124:	c7 44 24 0c 4a 71 10 	movl   $0x10714a,0xc(%esp)
  10512b:	00 
  10512c:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  105133:	00 
  105134:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  10513b:	00 
  10513c:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  105143:	e8 a0 b2 ff ff       	call   1003e8 <__panic>

    list_entry_t free_list_store = free_list;
  105148:	a1 5c 89 11 00       	mov    0x11895c,%eax
  10514d:	8b 15 60 89 11 00    	mov    0x118960,%edx
  105153:	89 45 80             	mov    %eax,-0x80(%ebp)
  105156:	89 55 84             	mov    %edx,-0x7c(%ebp)
  105159:	c7 45 b4 5c 89 11 00 	movl   $0x11895c,-0x4c(%ebp)
    elm->prev = elm->next = elm;
  105160:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105163:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  105166:	89 50 04             	mov    %edx,0x4(%eax)
  105169:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10516c:	8b 50 04             	mov    0x4(%eax),%edx
  10516f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105172:	89 10                	mov    %edx,(%eax)
  105174:	c7 45 b0 5c 89 11 00 	movl   $0x11895c,-0x50(%ebp)
    return list->next == list;
  10517b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10517e:	8b 40 04             	mov    0x4(%eax),%eax
  105181:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  105184:	0f 94 c0             	sete   %al
  105187:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10518a:	85 c0                	test   %eax,%eax
  10518c:	75 24                	jne    1051b2 <default_check+0x1d0>
  10518e:	c7 44 24 0c 9f 70 10 	movl   $0x10709f,0xc(%esp)
  105195:	00 
  105196:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  10519d:	00 
  10519e:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  1051a5:	00 
  1051a6:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  1051ad:	e8 36 b2 ff ff       	call   1003e8 <__panic>
    assert(alloc_page() == NULL);
  1051b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051b9:	e8 27 db ff ff       	call   102ce5 <alloc_pages>
  1051be:	85 c0                	test   %eax,%eax
  1051c0:	74 24                	je     1051e6 <default_check+0x204>
  1051c2:	c7 44 24 0c b6 70 10 	movl   $0x1070b6,0xc(%esp)
  1051c9:	00 
  1051ca:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  1051d1:	00 
  1051d2:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  1051d9:	00 
  1051da:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  1051e1:	e8 02 b2 ff ff       	call   1003e8 <__panic>

    unsigned int nr_free_store = nr_free;
  1051e6:	a1 64 89 11 00       	mov    0x118964,%eax
  1051eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1051ee:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  1051f5:	00 00 00 

    free_pages(p0 + 2, 3);
  1051f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1051fb:	83 c0 28             	add    $0x28,%eax
  1051fe:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105205:	00 
  105206:	89 04 24             	mov    %eax,(%esp)
  105209:	e8 0f db ff ff       	call   102d1d <free_pages>
    assert(alloc_pages(4) == NULL);
  10520e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  105215:	e8 cb da ff ff       	call   102ce5 <alloc_pages>
  10521a:	85 c0                	test   %eax,%eax
  10521c:	74 24                	je     105242 <default_check+0x260>
  10521e:	c7 44 24 0c 5c 71 10 	movl   $0x10715c,0xc(%esp)
  105225:	00 
  105226:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  10522d:	00 
  10522e:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  105235:	00 
  105236:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  10523d:	e8 a6 b1 ff ff       	call   1003e8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  105242:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105245:	83 c0 28             	add    $0x28,%eax
  105248:	83 c0 04             	add    $0x4,%eax
  10524b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  105252:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105255:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105258:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10525b:	0f a3 10             	bt     %edx,(%eax)
  10525e:	19 c0                	sbb    %eax,%eax
  105260:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  105263:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  105267:	0f 95 c0             	setne  %al
  10526a:	0f b6 c0             	movzbl %al,%eax
  10526d:	85 c0                	test   %eax,%eax
  10526f:	74 0e                	je     10527f <default_check+0x29d>
  105271:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105274:	83 c0 28             	add    $0x28,%eax
  105277:	8b 40 08             	mov    0x8(%eax),%eax
  10527a:	83 f8 03             	cmp    $0x3,%eax
  10527d:	74 24                	je     1052a3 <default_check+0x2c1>
  10527f:	c7 44 24 0c 74 71 10 	movl   $0x107174,0xc(%esp)
  105286:	00 
  105287:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  10528e:	00 
  10528f:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  105296:	00 
  105297:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  10529e:	e8 45 b1 ff ff       	call   1003e8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1052a3:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1052aa:	e8 36 da ff ff       	call   102ce5 <alloc_pages>
  1052af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1052b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1052b6:	75 24                	jne    1052dc <default_check+0x2fa>
  1052b8:	c7 44 24 0c a0 71 10 	movl   $0x1071a0,0xc(%esp)
  1052bf:	00 
  1052c0:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  1052c7:	00 
  1052c8:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  1052cf:	00 
  1052d0:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  1052d7:	e8 0c b1 ff ff       	call   1003e8 <__panic>
    assert(alloc_page() == NULL);
  1052dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1052e3:	e8 fd d9 ff ff       	call   102ce5 <alloc_pages>
  1052e8:	85 c0                	test   %eax,%eax
  1052ea:	74 24                	je     105310 <default_check+0x32e>
  1052ec:	c7 44 24 0c b6 70 10 	movl   $0x1070b6,0xc(%esp)
  1052f3:	00 
  1052f4:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  1052fb:	00 
  1052fc:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  105303:	00 
  105304:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  10530b:	e8 d8 b0 ff ff       	call   1003e8 <__panic>
    assert(p0 + 2 == p1);
  105310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105313:	83 c0 28             	add    $0x28,%eax
  105316:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  105319:	74 24                	je     10533f <default_check+0x35d>
  10531b:	c7 44 24 0c be 71 10 	movl   $0x1071be,0xc(%esp)
  105322:	00 
  105323:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  10532a:	00 
  10532b:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  105332:	00 
  105333:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  10533a:	e8 a9 b0 ff ff       	call   1003e8 <__panic>

    p2 = p0 + 1;
  10533f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105342:	83 c0 14             	add    $0x14,%eax
  105345:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  105348:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10534f:	00 
  105350:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105353:	89 04 24             	mov    %eax,(%esp)
  105356:	e8 c2 d9 ff ff       	call   102d1d <free_pages>
    free_pages(p1, 3);
  10535b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105362:	00 
  105363:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105366:	89 04 24             	mov    %eax,(%esp)
  105369:	e8 af d9 ff ff       	call   102d1d <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10536e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105371:	83 c0 04             	add    $0x4,%eax
  105374:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10537b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10537e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105381:	8b 55 a0             	mov    -0x60(%ebp),%edx
  105384:	0f a3 10             	bt     %edx,(%eax)
  105387:	19 c0                	sbb    %eax,%eax
  105389:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10538c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  105390:	0f 95 c0             	setne  %al
  105393:	0f b6 c0             	movzbl %al,%eax
  105396:	85 c0                	test   %eax,%eax
  105398:	74 0b                	je     1053a5 <default_check+0x3c3>
  10539a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10539d:	8b 40 08             	mov    0x8(%eax),%eax
  1053a0:	83 f8 01             	cmp    $0x1,%eax
  1053a3:	74 24                	je     1053c9 <default_check+0x3e7>
  1053a5:	c7 44 24 0c cc 71 10 	movl   $0x1071cc,0xc(%esp)
  1053ac:	00 
  1053ad:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  1053b4:	00 
  1053b5:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1053bc:	00 
  1053bd:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  1053c4:	e8 1f b0 ff ff       	call   1003e8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1053c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053cc:	83 c0 04             	add    $0x4,%eax
  1053cf:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1053d6:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1053d9:	8b 45 90             	mov    -0x70(%ebp),%eax
  1053dc:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1053df:	0f a3 10             	bt     %edx,(%eax)
  1053e2:	19 c0                	sbb    %eax,%eax
  1053e4:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1053e7:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1053eb:	0f 95 c0             	setne  %al
  1053ee:	0f b6 c0             	movzbl %al,%eax
  1053f1:	85 c0                	test   %eax,%eax
  1053f3:	74 0b                	je     105400 <default_check+0x41e>
  1053f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053f8:	8b 40 08             	mov    0x8(%eax),%eax
  1053fb:	83 f8 03             	cmp    $0x3,%eax
  1053fe:	74 24                	je     105424 <default_check+0x442>
  105400:	c7 44 24 0c f4 71 10 	movl   $0x1071f4,0xc(%esp)
  105407:	00 
  105408:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  10540f:	00 
  105410:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  105417:	00 
  105418:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  10541f:	e8 c4 af ff ff       	call   1003e8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  105424:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10542b:	e8 b5 d8 ff ff       	call   102ce5 <alloc_pages>
  105430:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105433:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105436:	83 e8 14             	sub    $0x14,%eax
  105439:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10543c:	74 24                	je     105462 <default_check+0x480>
  10543e:	c7 44 24 0c 1a 72 10 	movl   $0x10721a,0xc(%esp)
  105445:	00 
  105446:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  10544d:	00 
  10544e:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  105455:	00 
  105456:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  10545d:	e8 86 af ff ff       	call   1003e8 <__panic>
    free_page(p0);
  105462:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105469:	00 
  10546a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10546d:	89 04 24             	mov    %eax,(%esp)
  105470:	e8 a8 d8 ff ff       	call   102d1d <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  105475:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10547c:	e8 64 d8 ff ff       	call   102ce5 <alloc_pages>
  105481:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105484:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105487:	83 c0 14             	add    $0x14,%eax
  10548a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10548d:	74 24                	je     1054b3 <default_check+0x4d1>
  10548f:	c7 44 24 0c 38 72 10 	movl   $0x107238,0xc(%esp)
  105496:	00 
  105497:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  10549e:	00 
  10549f:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  1054a6:	00 
  1054a7:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  1054ae:	e8 35 af ff ff       	call   1003e8 <__panic>

    free_pages(p0, 2);
  1054b3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1054ba:	00 
  1054bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054be:	89 04 24             	mov    %eax,(%esp)
  1054c1:	e8 57 d8 ff ff       	call   102d1d <free_pages>
    free_page(p2);
  1054c6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1054cd:	00 
  1054ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1054d1:	89 04 24             	mov    %eax,(%esp)
  1054d4:	e8 44 d8 ff ff       	call   102d1d <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1054d9:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1054e0:	e8 00 d8 ff ff       	call   102ce5 <alloc_pages>
  1054e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1054e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1054ec:	75 24                	jne    105512 <default_check+0x530>
  1054ee:	c7 44 24 0c 58 72 10 	movl   $0x107258,0xc(%esp)
  1054f5:	00 
  1054f6:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  1054fd:	00 
  1054fe:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  105505:	00 
  105506:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  10550d:	e8 d6 ae ff ff       	call   1003e8 <__panic>
    assert(alloc_page() == NULL);
  105512:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105519:	e8 c7 d7 ff ff       	call   102ce5 <alloc_pages>
  10551e:	85 c0                	test   %eax,%eax
  105520:	74 24                	je     105546 <default_check+0x564>
  105522:	c7 44 24 0c b6 70 10 	movl   $0x1070b6,0xc(%esp)
  105529:	00 
  10552a:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  105531:	00 
  105532:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  105539:	00 
  10553a:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  105541:	e8 a2 ae ff ff       	call   1003e8 <__panic>

    assert(nr_free == 0);
  105546:	a1 64 89 11 00       	mov    0x118964,%eax
  10554b:	85 c0                	test   %eax,%eax
  10554d:	74 24                	je     105573 <default_check+0x591>
  10554f:	c7 44 24 0c 09 71 10 	movl   $0x107109,0xc(%esp)
  105556:	00 
  105557:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  10555e:	00 
  10555f:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  105566:	00 
  105567:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  10556e:	e8 75 ae ff ff       	call   1003e8 <__panic>
    nr_free = nr_free_store;
  105573:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105576:	a3 64 89 11 00       	mov    %eax,0x118964

    free_list = free_list_store;
  10557b:	8b 45 80             	mov    -0x80(%ebp),%eax
  10557e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105581:	a3 5c 89 11 00       	mov    %eax,0x11895c
  105586:	89 15 60 89 11 00    	mov    %edx,0x118960
    free_pages(p0, 5);
  10558c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  105593:	00 
  105594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105597:	89 04 24             	mov    %eax,(%esp)
  10559a:	e8 7e d7 ff ff       	call   102d1d <free_pages>

    le = &free_list;
  10559f:	c7 45 ec 5c 89 11 00 	movl   $0x11895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1055a6:	eb 1d                	jmp    1055c5 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  1055a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1055ab:	83 e8 0c             	sub    $0xc,%eax
  1055ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  1055b1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1055b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1055b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1055bb:	8b 40 08             	mov    0x8(%eax),%eax
  1055be:	29 c2                	sub    %eax,%edx
  1055c0:	89 d0                	mov    %edx,%eax
  1055c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1055c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1055c8:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  1055cb:	8b 45 88             	mov    -0x78(%ebp),%eax
  1055ce:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1055d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1055d4:	81 7d ec 5c 89 11 00 	cmpl   $0x11895c,-0x14(%ebp)
  1055db:	75 cb                	jne    1055a8 <default_check+0x5c6>
    }
    assert(count == 0);
  1055dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1055e1:	74 24                	je     105607 <default_check+0x625>
  1055e3:	c7 44 24 0c 76 72 10 	movl   $0x107276,0xc(%esp)
  1055ea:	00 
  1055eb:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  1055f2:	00 
  1055f3:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  1055fa:	00 
  1055fb:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  105602:	e8 e1 ad ff ff       	call   1003e8 <__panic>
    assert(total == 0);
  105607:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10560b:	74 24                	je     105631 <default_check+0x64f>
  10560d:	c7 44 24 0c 81 72 10 	movl   $0x107281,0xc(%esp)
  105614:	00 
  105615:	c7 44 24 08 16 6f 10 	movl   $0x106f16,0x8(%esp)
  10561c:	00 
  10561d:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
  105624:	00 
  105625:	c7 04 24 2b 6f 10 00 	movl   $0x106f2b,(%esp)
  10562c:	e8 b7 ad ff ff       	call   1003e8 <__panic>
}
  105631:	81 c4 94 00 00 00    	add    $0x94,%esp
  105637:	5b                   	pop    %ebx
  105638:	5d                   	pop    %ebp
  105639:	c3                   	ret    

0010563a <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  10563a:	55                   	push   %ebp
  10563b:	89 e5                	mov    %esp,%ebp
  10563d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105640:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105647:	eb 04                	jmp    10564d <strlen+0x13>
        cnt ++;
  105649:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  10564d:	8b 45 08             	mov    0x8(%ebp),%eax
  105650:	8d 50 01             	lea    0x1(%eax),%edx
  105653:	89 55 08             	mov    %edx,0x8(%ebp)
  105656:	0f b6 00             	movzbl (%eax),%eax
  105659:	84 c0                	test   %al,%al
  10565b:	75 ec                	jne    105649 <strlen+0xf>
    }
    return cnt;
  10565d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105660:	c9                   	leave  
  105661:	c3                   	ret    

00105662 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105662:	55                   	push   %ebp
  105663:	89 e5                	mov    %esp,%ebp
  105665:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105668:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10566f:	eb 04                	jmp    105675 <strnlen+0x13>
        cnt ++;
  105671:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105675:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105678:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10567b:	73 10                	jae    10568d <strnlen+0x2b>
  10567d:	8b 45 08             	mov    0x8(%ebp),%eax
  105680:	8d 50 01             	lea    0x1(%eax),%edx
  105683:	89 55 08             	mov    %edx,0x8(%ebp)
  105686:	0f b6 00             	movzbl (%eax),%eax
  105689:	84 c0                	test   %al,%al
  10568b:	75 e4                	jne    105671 <strnlen+0xf>
    }
    return cnt;
  10568d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105690:	c9                   	leave  
  105691:	c3                   	ret    

00105692 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105692:	55                   	push   %ebp
  105693:	89 e5                	mov    %esp,%ebp
  105695:	57                   	push   %edi
  105696:	56                   	push   %esi
  105697:	83 ec 20             	sub    $0x20,%esp
  10569a:	8b 45 08             	mov    0x8(%ebp),%eax
  10569d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1056a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1056a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1056a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056ac:	89 d1                	mov    %edx,%ecx
  1056ae:	89 c2                	mov    %eax,%edx
  1056b0:	89 ce                	mov    %ecx,%esi
  1056b2:	89 d7                	mov    %edx,%edi
  1056b4:	ac                   	lods   %ds:(%esi),%al
  1056b5:	aa                   	stos   %al,%es:(%edi)
  1056b6:	84 c0                	test   %al,%al
  1056b8:	75 fa                	jne    1056b4 <strcpy+0x22>
  1056ba:	89 fa                	mov    %edi,%edx
  1056bc:	89 f1                	mov    %esi,%ecx
  1056be:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1056c1:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1056c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1056c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1056ca:	83 c4 20             	add    $0x20,%esp
  1056cd:	5e                   	pop    %esi
  1056ce:	5f                   	pop    %edi
  1056cf:	5d                   	pop    %ebp
  1056d0:	c3                   	ret    

001056d1 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1056d1:	55                   	push   %ebp
  1056d2:	89 e5                	mov    %esp,%ebp
  1056d4:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1056d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1056da:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1056dd:	eb 21                	jmp    105700 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1056df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056e2:	0f b6 10             	movzbl (%eax),%edx
  1056e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1056e8:	88 10                	mov    %dl,(%eax)
  1056ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1056ed:	0f b6 00             	movzbl (%eax),%eax
  1056f0:	84 c0                	test   %al,%al
  1056f2:	74 04                	je     1056f8 <strncpy+0x27>
            src ++;
  1056f4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1056f8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1056fc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  105700:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105704:	75 d9                	jne    1056df <strncpy+0xe>
    }
    return dst;
  105706:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105709:	c9                   	leave  
  10570a:	c3                   	ret    

0010570b <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10570b:	55                   	push   %ebp
  10570c:	89 e5                	mov    %esp,%ebp
  10570e:	57                   	push   %edi
  10570f:	56                   	push   %esi
  105710:	83 ec 20             	sub    $0x20,%esp
  105713:	8b 45 08             	mov    0x8(%ebp),%eax
  105716:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105719:	8b 45 0c             	mov    0xc(%ebp),%eax
  10571c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  10571f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105725:	89 d1                	mov    %edx,%ecx
  105727:	89 c2                	mov    %eax,%edx
  105729:	89 ce                	mov    %ecx,%esi
  10572b:	89 d7                	mov    %edx,%edi
  10572d:	ac                   	lods   %ds:(%esi),%al
  10572e:	ae                   	scas   %es:(%edi),%al
  10572f:	75 08                	jne    105739 <strcmp+0x2e>
  105731:	84 c0                	test   %al,%al
  105733:	75 f8                	jne    10572d <strcmp+0x22>
  105735:	31 c0                	xor    %eax,%eax
  105737:	eb 04                	jmp    10573d <strcmp+0x32>
  105739:	19 c0                	sbb    %eax,%eax
  10573b:	0c 01                	or     $0x1,%al
  10573d:	89 fa                	mov    %edi,%edx
  10573f:	89 f1                	mov    %esi,%ecx
  105741:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105744:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105747:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  10574a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10574d:	83 c4 20             	add    $0x20,%esp
  105750:	5e                   	pop    %esi
  105751:	5f                   	pop    %edi
  105752:	5d                   	pop    %ebp
  105753:	c3                   	ret    

00105754 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105754:	55                   	push   %ebp
  105755:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105757:	eb 0c                	jmp    105765 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105759:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10575d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105761:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105765:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105769:	74 1a                	je     105785 <strncmp+0x31>
  10576b:	8b 45 08             	mov    0x8(%ebp),%eax
  10576e:	0f b6 00             	movzbl (%eax),%eax
  105771:	84 c0                	test   %al,%al
  105773:	74 10                	je     105785 <strncmp+0x31>
  105775:	8b 45 08             	mov    0x8(%ebp),%eax
  105778:	0f b6 10             	movzbl (%eax),%edx
  10577b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10577e:	0f b6 00             	movzbl (%eax),%eax
  105781:	38 c2                	cmp    %al,%dl
  105783:	74 d4                	je     105759 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105785:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105789:	74 18                	je     1057a3 <strncmp+0x4f>
  10578b:	8b 45 08             	mov    0x8(%ebp),%eax
  10578e:	0f b6 00             	movzbl (%eax),%eax
  105791:	0f b6 d0             	movzbl %al,%edx
  105794:	8b 45 0c             	mov    0xc(%ebp),%eax
  105797:	0f b6 00             	movzbl (%eax),%eax
  10579a:	0f b6 c0             	movzbl %al,%eax
  10579d:	29 c2                	sub    %eax,%edx
  10579f:	89 d0                	mov    %edx,%eax
  1057a1:	eb 05                	jmp    1057a8 <strncmp+0x54>
  1057a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1057a8:	5d                   	pop    %ebp
  1057a9:	c3                   	ret    

001057aa <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1057aa:	55                   	push   %ebp
  1057ab:	89 e5                	mov    %esp,%ebp
  1057ad:	83 ec 04             	sub    $0x4,%esp
  1057b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057b3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1057b6:	eb 14                	jmp    1057cc <strchr+0x22>
        if (*s == c) {
  1057b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1057bb:	0f b6 00             	movzbl (%eax),%eax
  1057be:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1057c1:	75 05                	jne    1057c8 <strchr+0x1e>
            return (char *)s;
  1057c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c6:	eb 13                	jmp    1057db <strchr+0x31>
        }
        s ++;
  1057c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  1057cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1057cf:	0f b6 00             	movzbl (%eax),%eax
  1057d2:	84 c0                	test   %al,%al
  1057d4:	75 e2                	jne    1057b8 <strchr+0xe>
    }
    return NULL;
  1057d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1057db:	c9                   	leave  
  1057dc:	c3                   	ret    

001057dd <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1057dd:	55                   	push   %ebp
  1057de:	89 e5                	mov    %esp,%ebp
  1057e0:	83 ec 04             	sub    $0x4,%esp
  1057e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057e6:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1057e9:	eb 11                	jmp    1057fc <strfind+0x1f>
        if (*s == c) {
  1057eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ee:	0f b6 00             	movzbl (%eax),%eax
  1057f1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1057f4:	75 02                	jne    1057f8 <strfind+0x1b>
            break;
  1057f6:	eb 0e                	jmp    105806 <strfind+0x29>
        }
        s ++;
  1057f8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  1057fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ff:	0f b6 00             	movzbl (%eax),%eax
  105802:	84 c0                	test   %al,%al
  105804:	75 e5                	jne    1057eb <strfind+0xe>
    }
    return (char *)s;
  105806:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105809:	c9                   	leave  
  10580a:	c3                   	ret    

0010580b <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10580b:	55                   	push   %ebp
  10580c:	89 e5                	mov    %esp,%ebp
  10580e:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105811:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105818:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10581f:	eb 04                	jmp    105825 <strtol+0x1a>
        s ++;
  105821:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105825:	8b 45 08             	mov    0x8(%ebp),%eax
  105828:	0f b6 00             	movzbl (%eax),%eax
  10582b:	3c 20                	cmp    $0x20,%al
  10582d:	74 f2                	je     105821 <strtol+0x16>
  10582f:	8b 45 08             	mov    0x8(%ebp),%eax
  105832:	0f b6 00             	movzbl (%eax),%eax
  105835:	3c 09                	cmp    $0x9,%al
  105837:	74 e8                	je     105821 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105839:	8b 45 08             	mov    0x8(%ebp),%eax
  10583c:	0f b6 00             	movzbl (%eax),%eax
  10583f:	3c 2b                	cmp    $0x2b,%al
  105841:	75 06                	jne    105849 <strtol+0x3e>
        s ++;
  105843:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105847:	eb 15                	jmp    10585e <strtol+0x53>
    }
    else if (*s == '-') {
  105849:	8b 45 08             	mov    0x8(%ebp),%eax
  10584c:	0f b6 00             	movzbl (%eax),%eax
  10584f:	3c 2d                	cmp    $0x2d,%al
  105851:	75 0b                	jne    10585e <strtol+0x53>
        s ++, neg = 1;
  105853:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105857:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10585e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105862:	74 06                	je     10586a <strtol+0x5f>
  105864:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105868:	75 24                	jne    10588e <strtol+0x83>
  10586a:	8b 45 08             	mov    0x8(%ebp),%eax
  10586d:	0f b6 00             	movzbl (%eax),%eax
  105870:	3c 30                	cmp    $0x30,%al
  105872:	75 1a                	jne    10588e <strtol+0x83>
  105874:	8b 45 08             	mov    0x8(%ebp),%eax
  105877:	83 c0 01             	add    $0x1,%eax
  10587a:	0f b6 00             	movzbl (%eax),%eax
  10587d:	3c 78                	cmp    $0x78,%al
  10587f:	75 0d                	jne    10588e <strtol+0x83>
        s += 2, base = 16;
  105881:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105885:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10588c:	eb 2a                	jmp    1058b8 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  10588e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105892:	75 17                	jne    1058ab <strtol+0xa0>
  105894:	8b 45 08             	mov    0x8(%ebp),%eax
  105897:	0f b6 00             	movzbl (%eax),%eax
  10589a:	3c 30                	cmp    $0x30,%al
  10589c:	75 0d                	jne    1058ab <strtol+0xa0>
        s ++, base = 8;
  10589e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1058a2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1058a9:	eb 0d                	jmp    1058b8 <strtol+0xad>
    }
    else if (base == 0) {
  1058ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1058af:	75 07                	jne    1058b8 <strtol+0xad>
        base = 10;
  1058b1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1058b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1058bb:	0f b6 00             	movzbl (%eax),%eax
  1058be:	3c 2f                	cmp    $0x2f,%al
  1058c0:	7e 1b                	jle    1058dd <strtol+0xd2>
  1058c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1058c5:	0f b6 00             	movzbl (%eax),%eax
  1058c8:	3c 39                	cmp    $0x39,%al
  1058ca:	7f 11                	jg     1058dd <strtol+0xd2>
            dig = *s - '0';
  1058cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1058cf:	0f b6 00             	movzbl (%eax),%eax
  1058d2:	0f be c0             	movsbl %al,%eax
  1058d5:	83 e8 30             	sub    $0x30,%eax
  1058d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1058db:	eb 48                	jmp    105925 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1058dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e0:	0f b6 00             	movzbl (%eax),%eax
  1058e3:	3c 60                	cmp    $0x60,%al
  1058e5:	7e 1b                	jle    105902 <strtol+0xf7>
  1058e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ea:	0f b6 00             	movzbl (%eax),%eax
  1058ed:	3c 7a                	cmp    $0x7a,%al
  1058ef:	7f 11                	jg     105902 <strtol+0xf7>
            dig = *s - 'a' + 10;
  1058f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f4:	0f b6 00             	movzbl (%eax),%eax
  1058f7:	0f be c0             	movsbl %al,%eax
  1058fa:	83 e8 57             	sub    $0x57,%eax
  1058fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105900:	eb 23                	jmp    105925 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105902:	8b 45 08             	mov    0x8(%ebp),%eax
  105905:	0f b6 00             	movzbl (%eax),%eax
  105908:	3c 40                	cmp    $0x40,%al
  10590a:	7e 3d                	jle    105949 <strtol+0x13e>
  10590c:	8b 45 08             	mov    0x8(%ebp),%eax
  10590f:	0f b6 00             	movzbl (%eax),%eax
  105912:	3c 5a                	cmp    $0x5a,%al
  105914:	7f 33                	jg     105949 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105916:	8b 45 08             	mov    0x8(%ebp),%eax
  105919:	0f b6 00             	movzbl (%eax),%eax
  10591c:	0f be c0             	movsbl %al,%eax
  10591f:	83 e8 37             	sub    $0x37,%eax
  105922:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105928:	3b 45 10             	cmp    0x10(%ebp),%eax
  10592b:	7c 02                	jl     10592f <strtol+0x124>
            break;
  10592d:	eb 1a                	jmp    105949 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  10592f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105933:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105936:	0f af 45 10          	imul   0x10(%ebp),%eax
  10593a:	89 c2                	mov    %eax,%edx
  10593c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10593f:	01 d0                	add    %edx,%eax
  105941:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105944:	e9 6f ff ff ff       	jmp    1058b8 <strtol+0xad>

    if (endptr) {
  105949:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10594d:	74 08                	je     105957 <strtol+0x14c>
        *endptr = (char *) s;
  10594f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105952:	8b 55 08             	mov    0x8(%ebp),%edx
  105955:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105957:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10595b:	74 07                	je     105964 <strtol+0x159>
  10595d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105960:	f7 d8                	neg    %eax
  105962:	eb 03                	jmp    105967 <strtol+0x15c>
  105964:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105967:	c9                   	leave  
  105968:	c3                   	ret    

00105969 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105969:	55                   	push   %ebp
  10596a:	89 e5                	mov    %esp,%ebp
  10596c:	57                   	push   %edi
  10596d:	83 ec 24             	sub    $0x24,%esp
  105970:	8b 45 0c             	mov    0xc(%ebp),%eax
  105973:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105976:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  10597a:	8b 55 08             	mov    0x8(%ebp),%edx
  10597d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105980:	88 45 f7             	mov    %al,-0x9(%ebp)
  105983:	8b 45 10             	mov    0x10(%ebp),%eax
  105986:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105989:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10598c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105990:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105993:	89 d7                	mov    %edx,%edi
  105995:	f3 aa                	rep stos %al,%es:(%edi)
  105997:	89 fa                	mov    %edi,%edx
  105999:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10599c:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  10599f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1059a2:	83 c4 24             	add    $0x24,%esp
  1059a5:	5f                   	pop    %edi
  1059a6:	5d                   	pop    %ebp
  1059a7:	c3                   	ret    

001059a8 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1059a8:	55                   	push   %ebp
  1059a9:	89 e5                	mov    %esp,%ebp
  1059ab:	57                   	push   %edi
  1059ac:	56                   	push   %esi
  1059ad:	53                   	push   %ebx
  1059ae:	83 ec 30             	sub    $0x30,%esp
  1059b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1059bd:	8b 45 10             	mov    0x10(%ebp),%eax
  1059c0:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1059c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059c6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1059c9:	73 42                	jae    105a0d <memmove+0x65>
  1059cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1059d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1059d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1059da:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1059dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1059e0:	c1 e8 02             	shr    $0x2,%eax
  1059e3:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1059e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1059e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059eb:	89 d7                	mov    %edx,%edi
  1059ed:	89 c6                	mov    %eax,%esi
  1059ef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1059f1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1059f4:	83 e1 03             	and    $0x3,%ecx
  1059f7:	74 02                	je     1059fb <memmove+0x53>
  1059f9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1059fb:	89 f0                	mov    %esi,%eax
  1059fd:	89 fa                	mov    %edi,%edx
  1059ff:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105a02:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105a05:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105a08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a0b:	eb 36                	jmp    105a43 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a10:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a16:	01 c2                	add    %eax,%edx
  105a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a1b:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a21:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a27:	89 c1                	mov    %eax,%ecx
  105a29:	89 d8                	mov    %ebx,%eax
  105a2b:	89 d6                	mov    %edx,%esi
  105a2d:	89 c7                	mov    %eax,%edi
  105a2f:	fd                   	std    
  105a30:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105a32:	fc                   	cld    
  105a33:	89 f8                	mov    %edi,%eax
  105a35:	89 f2                	mov    %esi,%edx
  105a37:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105a3a:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105a3d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105a43:	83 c4 30             	add    $0x30,%esp
  105a46:	5b                   	pop    %ebx
  105a47:	5e                   	pop    %esi
  105a48:	5f                   	pop    %edi
  105a49:	5d                   	pop    %ebp
  105a4a:	c3                   	ret    

00105a4b <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105a4b:	55                   	push   %ebp
  105a4c:	89 e5                	mov    %esp,%ebp
  105a4e:	57                   	push   %edi
  105a4f:	56                   	push   %esi
  105a50:	83 ec 20             	sub    $0x20,%esp
  105a53:	8b 45 08             	mov    0x8(%ebp),%eax
  105a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a5f:	8b 45 10             	mov    0x10(%ebp),%eax
  105a62:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a68:	c1 e8 02             	shr    $0x2,%eax
  105a6b:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a73:	89 d7                	mov    %edx,%edi
  105a75:	89 c6                	mov    %eax,%esi
  105a77:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105a79:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105a7c:	83 e1 03             	and    $0x3,%ecx
  105a7f:	74 02                	je     105a83 <memcpy+0x38>
  105a81:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105a83:	89 f0                	mov    %esi,%eax
  105a85:	89 fa                	mov    %edi,%edx
  105a87:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105a8a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105a8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105a93:	83 c4 20             	add    $0x20,%esp
  105a96:	5e                   	pop    %esi
  105a97:	5f                   	pop    %edi
  105a98:	5d                   	pop    %ebp
  105a99:	c3                   	ret    

00105a9a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105a9a:	55                   	push   %ebp
  105a9b:	89 e5                	mov    %esp,%ebp
  105a9d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105aac:	eb 30                	jmp    105ade <memcmp+0x44>
        if (*s1 != *s2) {
  105aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105ab1:	0f b6 10             	movzbl (%eax),%edx
  105ab4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105ab7:	0f b6 00             	movzbl (%eax),%eax
  105aba:	38 c2                	cmp    %al,%dl
  105abc:	74 18                	je     105ad6 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105abe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105ac1:	0f b6 00             	movzbl (%eax),%eax
  105ac4:	0f b6 d0             	movzbl %al,%edx
  105ac7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105aca:	0f b6 00             	movzbl (%eax),%eax
  105acd:	0f b6 c0             	movzbl %al,%eax
  105ad0:	29 c2                	sub    %eax,%edx
  105ad2:	89 d0                	mov    %edx,%eax
  105ad4:	eb 1a                	jmp    105af0 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105ad6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105ada:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  105ade:	8b 45 10             	mov    0x10(%ebp),%eax
  105ae1:	8d 50 ff             	lea    -0x1(%eax),%edx
  105ae4:	89 55 10             	mov    %edx,0x10(%ebp)
  105ae7:	85 c0                	test   %eax,%eax
  105ae9:	75 c3                	jne    105aae <memcmp+0x14>
    }
    return 0;
  105aeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105af0:	c9                   	leave  
  105af1:	c3                   	ret    

00105af2 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105af2:	55                   	push   %ebp
  105af3:	89 e5                	mov    %esp,%ebp
  105af5:	83 ec 58             	sub    $0x58,%esp
  105af8:	8b 45 10             	mov    0x10(%ebp),%eax
  105afb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105afe:	8b 45 14             	mov    0x14(%ebp),%eax
  105b01:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105b04:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105b07:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105b0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105b0d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105b10:	8b 45 18             	mov    0x18(%ebp),%eax
  105b13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105b16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b19:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105b1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105b1f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105b2c:	74 1c                	je     105b4a <printnum+0x58>
  105b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b31:	ba 00 00 00 00       	mov    $0x0,%edx
  105b36:	f7 75 e4             	divl   -0x1c(%ebp)
  105b39:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b3f:	ba 00 00 00 00       	mov    $0x0,%edx
  105b44:	f7 75 e4             	divl   -0x1c(%ebp)
  105b47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b50:	f7 75 e4             	divl   -0x1c(%ebp)
  105b53:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105b56:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105b59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105b62:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105b65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105b68:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105b6b:	8b 45 18             	mov    0x18(%ebp),%eax
  105b6e:	ba 00 00 00 00       	mov    $0x0,%edx
  105b73:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105b76:	77 56                	ja     105bce <printnum+0xdc>
  105b78:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105b7b:	72 05                	jb     105b82 <printnum+0x90>
  105b7d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105b80:	77 4c                	ja     105bce <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  105b82:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105b85:	8d 50 ff             	lea    -0x1(%eax),%edx
  105b88:	8b 45 20             	mov    0x20(%ebp),%eax
  105b8b:	89 44 24 18          	mov    %eax,0x18(%esp)
  105b8f:	89 54 24 14          	mov    %edx,0x14(%esp)
  105b93:	8b 45 18             	mov    0x18(%ebp),%eax
  105b96:	89 44 24 10          	mov    %eax,0x10(%esp)
  105b9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105ba0:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ba4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bab:	89 44 24 04          	mov    %eax,0x4(%esp)
  105baf:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb2:	89 04 24             	mov    %eax,(%esp)
  105bb5:	e8 38 ff ff ff       	call   105af2 <printnum>
  105bba:	eb 1c                	jmp    105bd8 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bc3:	8b 45 20             	mov    0x20(%ebp),%eax
  105bc6:	89 04 24             	mov    %eax,(%esp)
  105bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  105bcc:	ff d0                	call   *%eax
        while (-- width > 0)
  105bce:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105bd2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105bd6:	7f e4                	jg     105bbc <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105bd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105bdb:	05 3c 73 10 00       	add    $0x10733c,%eax
  105be0:	0f b6 00             	movzbl (%eax),%eax
  105be3:	0f be c0             	movsbl %al,%eax
  105be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  105be9:	89 54 24 04          	mov    %edx,0x4(%esp)
  105bed:	89 04 24             	mov    %eax,(%esp)
  105bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf3:	ff d0                	call   *%eax
}
  105bf5:	c9                   	leave  
  105bf6:	c3                   	ret    

00105bf7 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105bf7:	55                   	push   %ebp
  105bf8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105bfa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105bfe:	7e 14                	jle    105c14 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105c00:	8b 45 08             	mov    0x8(%ebp),%eax
  105c03:	8b 00                	mov    (%eax),%eax
  105c05:	8d 48 08             	lea    0x8(%eax),%ecx
  105c08:	8b 55 08             	mov    0x8(%ebp),%edx
  105c0b:	89 0a                	mov    %ecx,(%edx)
  105c0d:	8b 50 04             	mov    0x4(%eax),%edx
  105c10:	8b 00                	mov    (%eax),%eax
  105c12:	eb 30                	jmp    105c44 <getuint+0x4d>
    }
    else if (lflag) {
  105c14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105c18:	74 16                	je     105c30 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  105c1d:	8b 00                	mov    (%eax),%eax
  105c1f:	8d 48 04             	lea    0x4(%eax),%ecx
  105c22:	8b 55 08             	mov    0x8(%ebp),%edx
  105c25:	89 0a                	mov    %ecx,(%edx)
  105c27:	8b 00                	mov    (%eax),%eax
  105c29:	ba 00 00 00 00       	mov    $0x0,%edx
  105c2e:	eb 14                	jmp    105c44 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105c30:	8b 45 08             	mov    0x8(%ebp),%eax
  105c33:	8b 00                	mov    (%eax),%eax
  105c35:	8d 48 04             	lea    0x4(%eax),%ecx
  105c38:	8b 55 08             	mov    0x8(%ebp),%edx
  105c3b:	89 0a                	mov    %ecx,(%edx)
  105c3d:	8b 00                	mov    (%eax),%eax
  105c3f:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105c44:	5d                   	pop    %ebp
  105c45:	c3                   	ret    

00105c46 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105c46:	55                   	push   %ebp
  105c47:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105c49:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105c4d:	7e 14                	jle    105c63 <getint+0x1d>
        return va_arg(*ap, long long);
  105c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c52:	8b 00                	mov    (%eax),%eax
  105c54:	8d 48 08             	lea    0x8(%eax),%ecx
  105c57:	8b 55 08             	mov    0x8(%ebp),%edx
  105c5a:	89 0a                	mov    %ecx,(%edx)
  105c5c:	8b 50 04             	mov    0x4(%eax),%edx
  105c5f:	8b 00                	mov    (%eax),%eax
  105c61:	eb 28                	jmp    105c8b <getint+0x45>
    }
    else if (lflag) {
  105c63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105c67:	74 12                	je     105c7b <getint+0x35>
        return va_arg(*ap, long);
  105c69:	8b 45 08             	mov    0x8(%ebp),%eax
  105c6c:	8b 00                	mov    (%eax),%eax
  105c6e:	8d 48 04             	lea    0x4(%eax),%ecx
  105c71:	8b 55 08             	mov    0x8(%ebp),%edx
  105c74:	89 0a                	mov    %ecx,(%edx)
  105c76:	8b 00                	mov    (%eax),%eax
  105c78:	99                   	cltd   
  105c79:	eb 10                	jmp    105c8b <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  105c7e:	8b 00                	mov    (%eax),%eax
  105c80:	8d 48 04             	lea    0x4(%eax),%ecx
  105c83:	8b 55 08             	mov    0x8(%ebp),%edx
  105c86:	89 0a                	mov    %ecx,(%edx)
  105c88:	8b 00                	mov    (%eax),%eax
  105c8a:	99                   	cltd   
    }
}
  105c8b:	5d                   	pop    %ebp
  105c8c:	c3                   	ret    

00105c8d <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105c8d:	55                   	push   %ebp
  105c8e:	89 e5                	mov    %esp,%ebp
  105c90:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105c93:	8d 45 14             	lea    0x14(%ebp),%eax
  105c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c9c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105ca0:	8b 45 10             	mov    0x10(%ebp),%eax
  105ca3:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105caa:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cae:	8b 45 08             	mov    0x8(%ebp),%eax
  105cb1:	89 04 24             	mov    %eax,(%esp)
  105cb4:	e8 02 00 00 00       	call   105cbb <vprintfmt>
    va_end(ap);
}
  105cb9:	c9                   	leave  
  105cba:	c3                   	ret    

00105cbb <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105cbb:	55                   	push   %ebp
  105cbc:	89 e5                	mov    %esp,%ebp
  105cbe:	56                   	push   %esi
  105cbf:	53                   	push   %ebx
  105cc0:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105cc3:	eb 18                	jmp    105cdd <vprintfmt+0x22>
            if (ch == '\0') {
  105cc5:	85 db                	test   %ebx,%ebx
  105cc7:	75 05                	jne    105cce <vprintfmt+0x13>
                return;
  105cc9:	e9 d1 03 00 00       	jmp    10609f <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cd5:	89 1c 24             	mov    %ebx,(%esp)
  105cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  105cdb:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105cdd:	8b 45 10             	mov    0x10(%ebp),%eax
  105ce0:	8d 50 01             	lea    0x1(%eax),%edx
  105ce3:	89 55 10             	mov    %edx,0x10(%ebp)
  105ce6:	0f b6 00             	movzbl (%eax),%eax
  105ce9:	0f b6 d8             	movzbl %al,%ebx
  105cec:	83 fb 25             	cmp    $0x25,%ebx
  105cef:	75 d4                	jne    105cc5 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105cf1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105cf5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105cfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105cff:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105d02:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105d09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105d0c:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  105d12:	8d 50 01             	lea    0x1(%eax),%edx
  105d15:	89 55 10             	mov    %edx,0x10(%ebp)
  105d18:	0f b6 00             	movzbl (%eax),%eax
  105d1b:	0f b6 d8             	movzbl %al,%ebx
  105d1e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105d21:	83 f8 55             	cmp    $0x55,%eax
  105d24:	0f 87 44 03 00 00    	ja     10606e <vprintfmt+0x3b3>
  105d2a:	8b 04 85 60 73 10 00 	mov    0x107360(,%eax,4),%eax
  105d31:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105d33:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105d37:	eb d6                	jmp    105d0f <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105d39:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105d3d:	eb d0                	jmp    105d0f <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105d3f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105d46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105d49:	89 d0                	mov    %edx,%eax
  105d4b:	c1 e0 02             	shl    $0x2,%eax
  105d4e:	01 d0                	add    %edx,%eax
  105d50:	01 c0                	add    %eax,%eax
  105d52:	01 d8                	add    %ebx,%eax
  105d54:	83 e8 30             	sub    $0x30,%eax
  105d57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105d5a:	8b 45 10             	mov    0x10(%ebp),%eax
  105d5d:	0f b6 00             	movzbl (%eax),%eax
  105d60:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105d63:	83 fb 2f             	cmp    $0x2f,%ebx
  105d66:	7e 0b                	jle    105d73 <vprintfmt+0xb8>
  105d68:	83 fb 39             	cmp    $0x39,%ebx
  105d6b:	7f 06                	jg     105d73 <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
  105d6d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
  105d71:	eb d3                	jmp    105d46 <vprintfmt+0x8b>
            goto process_precision;
  105d73:	eb 33                	jmp    105da8 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  105d75:	8b 45 14             	mov    0x14(%ebp),%eax
  105d78:	8d 50 04             	lea    0x4(%eax),%edx
  105d7b:	89 55 14             	mov    %edx,0x14(%ebp)
  105d7e:	8b 00                	mov    (%eax),%eax
  105d80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105d83:	eb 23                	jmp    105da8 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  105d85:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105d89:	79 0c                	jns    105d97 <vprintfmt+0xdc>
                width = 0;
  105d8b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105d92:	e9 78 ff ff ff       	jmp    105d0f <vprintfmt+0x54>
  105d97:	e9 73 ff ff ff       	jmp    105d0f <vprintfmt+0x54>

        case '#':
            altflag = 1;
  105d9c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105da3:	e9 67 ff ff ff       	jmp    105d0f <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105da8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105dac:	79 12                	jns    105dc0 <vprintfmt+0x105>
                width = precision, precision = -1;
  105dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105db1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105db4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105dbb:	e9 4f ff ff ff       	jmp    105d0f <vprintfmt+0x54>
  105dc0:	e9 4a ff ff ff       	jmp    105d0f <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105dc5:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105dc9:	e9 41 ff ff ff       	jmp    105d0f <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105dce:	8b 45 14             	mov    0x14(%ebp),%eax
  105dd1:	8d 50 04             	lea    0x4(%eax),%edx
  105dd4:	89 55 14             	mov    %edx,0x14(%ebp)
  105dd7:	8b 00                	mov    (%eax),%eax
  105dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  105ddc:	89 54 24 04          	mov    %edx,0x4(%esp)
  105de0:	89 04 24             	mov    %eax,(%esp)
  105de3:	8b 45 08             	mov    0x8(%ebp),%eax
  105de6:	ff d0                	call   *%eax
            break;
  105de8:	e9 ac 02 00 00       	jmp    106099 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105ded:	8b 45 14             	mov    0x14(%ebp),%eax
  105df0:	8d 50 04             	lea    0x4(%eax),%edx
  105df3:	89 55 14             	mov    %edx,0x14(%ebp)
  105df6:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105df8:	85 db                	test   %ebx,%ebx
  105dfa:	79 02                	jns    105dfe <vprintfmt+0x143>
                err = -err;
  105dfc:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105dfe:	83 fb 06             	cmp    $0x6,%ebx
  105e01:	7f 0b                	jg     105e0e <vprintfmt+0x153>
  105e03:	8b 34 9d 20 73 10 00 	mov    0x107320(,%ebx,4),%esi
  105e0a:	85 f6                	test   %esi,%esi
  105e0c:	75 23                	jne    105e31 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105e0e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105e12:	c7 44 24 08 4d 73 10 	movl   $0x10734d,0x8(%esp)
  105e19:	00 
  105e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e21:	8b 45 08             	mov    0x8(%ebp),%eax
  105e24:	89 04 24             	mov    %eax,(%esp)
  105e27:	e8 61 fe ff ff       	call   105c8d <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105e2c:	e9 68 02 00 00       	jmp    106099 <vprintfmt+0x3de>
                printfmt(putch, putdat, "%s", p);
  105e31:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105e35:	c7 44 24 08 56 73 10 	movl   $0x107356,0x8(%esp)
  105e3c:	00 
  105e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e40:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e44:	8b 45 08             	mov    0x8(%ebp),%eax
  105e47:	89 04 24             	mov    %eax,(%esp)
  105e4a:	e8 3e fe ff ff       	call   105c8d <printfmt>
            break;
  105e4f:	e9 45 02 00 00       	jmp    106099 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105e54:	8b 45 14             	mov    0x14(%ebp),%eax
  105e57:	8d 50 04             	lea    0x4(%eax),%edx
  105e5a:	89 55 14             	mov    %edx,0x14(%ebp)
  105e5d:	8b 30                	mov    (%eax),%esi
  105e5f:	85 f6                	test   %esi,%esi
  105e61:	75 05                	jne    105e68 <vprintfmt+0x1ad>
                p = "(null)";
  105e63:	be 59 73 10 00       	mov    $0x107359,%esi
            }
            if (width > 0 && padc != '-') {
  105e68:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105e6c:	7e 3e                	jle    105eac <vprintfmt+0x1f1>
  105e6e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105e72:	74 38                	je     105eac <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105e74:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105e7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e7e:	89 34 24             	mov    %esi,(%esp)
  105e81:	e8 dc f7 ff ff       	call   105662 <strnlen>
  105e86:	29 c3                	sub    %eax,%ebx
  105e88:	89 d8                	mov    %ebx,%eax
  105e8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105e8d:	eb 17                	jmp    105ea6 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  105e8f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105e93:	8b 55 0c             	mov    0xc(%ebp),%edx
  105e96:	89 54 24 04          	mov    %edx,0x4(%esp)
  105e9a:	89 04 24             	mov    %eax,(%esp)
  105e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  105ea0:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105ea2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105ea6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105eaa:	7f e3                	jg     105e8f <vprintfmt+0x1d4>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105eac:	eb 38                	jmp    105ee6 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105eae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105eb2:	74 1f                	je     105ed3 <vprintfmt+0x218>
  105eb4:	83 fb 1f             	cmp    $0x1f,%ebx
  105eb7:	7e 05                	jle    105ebe <vprintfmt+0x203>
  105eb9:	83 fb 7e             	cmp    $0x7e,%ebx
  105ebc:	7e 15                	jle    105ed3 <vprintfmt+0x218>
                    putch('?', putdat);
  105ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ec1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ec5:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  105ecf:	ff d0                	call   *%eax
  105ed1:	eb 0f                	jmp    105ee2 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ed6:	89 44 24 04          	mov    %eax,0x4(%esp)
  105eda:	89 1c 24             	mov    %ebx,(%esp)
  105edd:	8b 45 08             	mov    0x8(%ebp),%eax
  105ee0:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105ee2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105ee6:	89 f0                	mov    %esi,%eax
  105ee8:	8d 70 01             	lea    0x1(%eax),%esi
  105eeb:	0f b6 00             	movzbl (%eax),%eax
  105eee:	0f be d8             	movsbl %al,%ebx
  105ef1:	85 db                	test   %ebx,%ebx
  105ef3:	74 10                	je     105f05 <vprintfmt+0x24a>
  105ef5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105ef9:	78 b3                	js     105eae <vprintfmt+0x1f3>
  105efb:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105eff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105f03:	79 a9                	jns    105eae <vprintfmt+0x1f3>
                }
            }
            for (; width > 0; width --) {
  105f05:	eb 17                	jmp    105f1e <vprintfmt+0x263>
                putch(' ', putdat);
  105f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f0e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105f15:	8b 45 08             	mov    0x8(%ebp),%eax
  105f18:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105f1a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105f1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105f22:	7f e3                	jg     105f07 <vprintfmt+0x24c>
            }
            break;
  105f24:	e9 70 01 00 00       	jmp    106099 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105f29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f30:	8d 45 14             	lea    0x14(%ebp),%eax
  105f33:	89 04 24             	mov    %eax,(%esp)
  105f36:	e8 0b fd ff ff       	call   105c46 <getint>
  105f3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f47:	85 d2                	test   %edx,%edx
  105f49:	79 26                	jns    105f71 <vprintfmt+0x2b6>
                putch('-', putdat);
  105f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f52:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105f59:	8b 45 08             	mov    0x8(%ebp),%eax
  105f5c:	ff d0                	call   *%eax
                num = -(long long)num;
  105f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f64:	f7 d8                	neg    %eax
  105f66:	83 d2 00             	adc    $0x0,%edx
  105f69:	f7 da                	neg    %edx
  105f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f6e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105f71:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105f78:	e9 a8 00 00 00       	jmp    106025 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105f7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f80:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f84:	8d 45 14             	lea    0x14(%ebp),%eax
  105f87:	89 04 24             	mov    %eax,(%esp)
  105f8a:	e8 68 fc ff ff       	call   105bf7 <getuint>
  105f8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f92:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105f95:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105f9c:	e9 84 00 00 00       	jmp    106025 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105fa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105fa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fa8:	8d 45 14             	lea    0x14(%ebp),%eax
  105fab:	89 04 24             	mov    %eax,(%esp)
  105fae:	e8 44 fc ff ff       	call   105bf7 <getuint>
  105fb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105fb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105fb9:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105fc0:	eb 63                	jmp    106025 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fc9:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  105fd3:	ff d0                	call   *%eax
            putch('x', putdat);
  105fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fdc:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  105fe6:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105fe8:	8b 45 14             	mov    0x14(%ebp),%eax
  105feb:	8d 50 04             	lea    0x4(%eax),%edx
  105fee:	89 55 14             	mov    %edx,0x14(%ebp)
  105ff1:	8b 00                	mov    (%eax),%eax
  105ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ff6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105ffd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  106004:	eb 1f                	jmp    106025 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  106006:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106009:	89 44 24 04          	mov    %eax,0x4(%esp)
  10600d:	8d 45 14             	lea    0x14(%ebp),%eax
  106010:	89 04 24             	mov    %eax,(%esp)
  106013:	e8 df fb ff ff       	call   105bf7 <getuint>
  106018:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10601b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10601e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  106025:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  106029:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10602c:	89 54 24 18          	mov    %edx,0x18(%esp)
  106030:	8b 55 e8             	mov    -0x18(%ebp),%edx
  106033:	89 54 24 14          	mov    %edx,0x14(%esp)
  106037:	89 44 24 10          	mov    %eax,0x10(%esp)
  10603b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10603e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106041:	89 44 24 08          	mov    %eax,0x8(%esp)
  106045:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106049:	8b 45 0c             	mov    0xc(%ebp),%eax
  10604c:	89 44 24 04          	mov    %eax,0x4(%esp)
  106050:	8b 45 08             	mov    0x8(%ebp),%eax
  106053:	89 04 24             	mov    %eax,(%esp)
  106056:	e8 97 fa ff ff       	call   105af2 <printnum>
            break;
  10605b:	eb 3c                	jmp    106099 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10605d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106060:	89 44 24 04          	mov    %eax,0x4(%esp)
  106064:	89 1c 24             	mov    %ebx,(%esp)
  106067:	8b 45 08             	mov    0x8(%ebp),%eax
  10606a:	ff d0                	call   *%eax
            break;
  10606c:	eb 2b                	jmp    106099 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10606e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106071:	89 44 24 04          	mov    %eax,0x4(%esp)
  106075:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10607c:	8b 45 08             	mov    0x8(%ebp),%eax
  10607f:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  106081:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  106085:	eb 04                	jmp    10608b <vprintfmt+0x3d0>
  106087:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10608b:	8b 45 10             	mov    0x10(%ebp),%eax
  10608e:	83 e8 01             	sub    $0x1,%eax
  106091:	0f b6 00             	movzbl (%eax),%eax
  106094:	3c 25                	cmp    $0x25,%al
  106096:	75 ef                	jne    106087 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  106098:	90                   	nop
        }
    }
  106099:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10609a:	e9 3e fc ff ff       	jmp    105cdd <vprintfmt+0x22>
}
  10609f:	83 c4 40             	add    $0x40,%esp
  1060a2:	5b                   	pop    %ebx
  1060a3:	5e                   	pop    %esi
  1060a4:	5d                   	pop    %ebp
  1060a5:	c3                   	ret    

001060a6 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1060a6:	55                   	push   %ebp
  1060a7:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1060a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060ac:	8b 40 08             	mov    0x8(%eax),%eax
  1060af:	8d 50 01             	lea    0x1(%eax),%edx
  1060b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060b5:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1060b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060bb:	8b 10                	mov    (%eax),%edx
  1060bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060c0:	8b 40 04             	mov    0x4(%eax),%eax
  1060c3:	39 c2                	cmp    %eax,%edx
  1060c5:	73 12                	jae    1060d9 <sprintputch+0x33>
        *b->buf ++ = ch;
  1060c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060ca:	8b 00                	mov    (%eax),%eax
  1060cc:	8d 48 01             	lea    0x1(%eax),%ecx
  1060cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  1060d2:	89 0a                	mov    %ecx,(%edx)
  1060d4:	8b 55 08             	mov    0x8(%ebp),%edx
  1060d7:	88 10                	mov    %dl,(%eax)
    }
}
  1060d9:	5d                   	pop    %ebp
  1060da:	c3                   	ret    

001060db <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1060db:	55                   	push   %ebp
  1060dc:	89 e5                	mov    %esp,%ebp
  1060de:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1060e1:	8d 45 14             	lea    0x14(%ebp),%eax
  1060e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1060e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1060ee:	8b 45 10             	mov    0x10(%ebp),%eax
  1060f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1060f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1060ff:	89 04 24             	mov    %eax,(%esp)
  106102:	e8 08 00 00 00       	call   10610f <vsnprintf>
  106107:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10610a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10610d:	c9                   	leave  
  10610e:	c3                   	ret    

0010610f <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10610f:	55                   	push   %ebp
  106110:	89 e5                	mov    %esp,%ebp
  106112:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  106115:	8b 45 08             	mov    0x8(%ebp),%eax
  106118:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10611b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10611e:	8d 50 ff             	lea    -0x1(%eax),%edx
  106121:	8b 45 08             	mov    0x8(%ebp),%eax
  106124:	01 d0                	add    %edx,%eax
  106126:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106129:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  106130:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  106134:	74 0a                	je     106140 <vsnprintf+0x31>
  106136:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10613c:	39 c2                	cmp    %eax,%edx
  10613e:	76 07                	jbe    106147 <vsnprintf+0x38>
        return -E_INVAL;
  106140:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  106145:	eb 2a                	jmp    106171 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  106147:	8b 45 14             	mov    0x14(%ebp),%eax
  10614a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10614e:	8b 45 10             	mov    0x10(%ebp),%eax
  106151:	89 44 24 08          	mov    %eax,0x8(%esp)
  106155:	8d 45 ec             	lea    -0x14(%ebp),%eax
  106158:	89 44 24 04          	mov    %eax,0x4(%esp)
  10615c:	c7 04 24 a6 60 10 00 	movl   $0x1060a6,(%esp)
  106163:	e8 53 fb ff ff       	call   105cbb <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  106168:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10616b:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10616e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106171:	c9                   	leave  
  106172:	c3                   	ret    
