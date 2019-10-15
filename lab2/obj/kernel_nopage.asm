
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
  10002d:	53                   	push   %ebx
  10002e:	83 ec 14             	sub    $0x14,%esp
  100031:	e8 74 02 00 00       	call   1002aa <__x86.get_pc_thunk.bx>
  100036:	81 c3 3a 79 01 00    	add    $0x1793a,%ebx
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	c7 c0 28 8a 11 00    	mov    $0x118a28,%eax
  100042:	89 c2                	mov    %eax,%edx
  100044:	c7 c0 70 79 11 00    	mov    $0x117970,%eax
  10004a:	29 c2                	sub    %eax,%edx
  10004c:	89 d0                	mov    %edx,%eax
  10004e:	83 ec 04             	sub    $0x4,%esp
  100051:	50                   	push   %eax
  100052:	6a 00                	push   $0x0
  100054:	c7 c0 70 79 11 00    	mov    $0x117970,%eax
  10005a:	50                   	push   %eax
  10005b:	e8 ba 58 00 00       	call   10591a <memset>
  100060:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100063:	e8 b5 17 00 00       	call   10181d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100068:	8d 83 d8 e7 fe ff    	lea    -0x11828(%ebx),%eax
  10006e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100071:	83 ec 08             	sub    $0x8,%esp
  100074:	ff 75 f4             	pushl  -0xc(%ebp)
  100077:	8d 83 f4 e7 fe ff    	lea    -0x1180c(%ebx),%eax
  10007d:	50                   	push   %eax
  10007e:	e8 9a 02 00 00       	call   10031d <cprintf>
  100083:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100086:	e8 ba 09 00 00       	call   100a45 <print_kerninfo>

    grade_backtrace();
  10008b:	e8 98 00 00 00       	call   100128 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100090:	e8 2b 34 00 00       	call   1034c0 <pmm_init>

    pic_init();                 // init interrupt controller
  100095:	e8 40 19 00 00       	call   1019da <pic_init>
    idt_init();                 // init interrupt descriptor table
  10009a:	e8 d2 1a 00 00       	call   101b71 <idt_init>

    clock_init();               // init clock interrupt
  10009f:	e8 14 0e 00 00       	call   100eb8 <clock_init>
    intr_enable();              // enable irq interrupt
  1000a4:	e8 79 1a 00 00       	call   101b22 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a9:	eb fe                	jmp    1000a9 <kern_init+0x7f>

001000ab <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000ab:	55                   	push   %ebp
  1000ac:	89 e5                	mov    %esp,%ebp
  1000ae:	53                   	push   %ebx
  1000af:	83 ec 04             	sub    $0x4,%esp
  1000b2:	e8 ef 01 00 00       	call   1002a6 <__x86.get_pc_thunk.ax>
  1000b7:	05 b9 78 01 00       	add    $0x178b9,%eax
    mon_backtrace(0, NULL, NULL);
  1000bc:	83 ec 04             	sub    $0x4,%esp
  1000bf:	6a 00                	push   $0x0
  1000c1:	6a 00                	push   $0x0
  1000c3:	6a 00                	push   $0x0
  1000c5:	89 c3                	mov    %eax,%ebx
  1000c7:	e8 c9 0d 00 00       	call   100e95 <mon_backtrace>
  1000cc:	83 c4 10             	add    $0x10,%esp
}
  1000cf:	90                   	nop
  1000d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000d3:	c9                   	leave  
  1000d4:	c3                   	ret    

001000d5 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000d5:	55                   	push   %ebp
  1000d6:	89 e5                	mov    %esp,%ebp
  1000d8:	53                   	push   %ebx
  1000d9:	83 ec 04             	sub    $0x4,%esp
  1000dc:	e8 c5 01 00 00       	call   1002a6 <__x86.get_pc_thunk.ax>
  1000e1:	05 8f 78 01 00       	add    $0x1788f,%eax
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000e6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000ec:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1000f2:	51                   	push   %ecx
  1000f3:	52                   	push   %edx
  1000f4:	53                   	push   %ebx
  1000f5:	50                   	push   %eax
  1000f6:	e8 b0 ff ff ff       	call   1000ab <grade_backtrace2>
  1000fb:	83 c4 10             	add    $0x10,%esp
}
  1000fe:	90                   	nop
  1000ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100102:	c9                   	leave  
  100103:	c3                   	ret    

00100104 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  100104:	55                   	push   %ebp
  100105:	89 e5                	mov    %esp,%ebp
  100107:	83 ec 08             	sub    $0x8,%esp
  10010a:	e8 97 01 00 00       	call   1002a6 <__x86.get_pc_thunk.ax>
  10010f:	05 61 78 01 00       	add    $0x17861,%eax
    grade_backtrace1(arg0, arg2);
  100114:	83 ec 08             	sub    $0x8,%esp
  100117:	ff 75 10             	pushl  0x10(%ebp)
  10011a:	ff 75 08             	pushl  0x8(%ebp)
  10011d:	e8 b3 ff ff ff       	call   1000d5 <grade_backtrace1>
  100122:	83 c4 10             	add    $0x10,%esp
}
  100125:	90                   	nop
  100126:	c9                   	leave  
  100127:	c3                   	ret    

00100128 <grade_backtrace>:

void
grade_backtrace(void) {
  100128:	55                   	push   %ebp
  100129:	89 e5                	mov    %esp,%ebp
  10012b:	83 ec 08             	sub    $0x8,%esp
  10012e:	e8 73 01 00 00       	call   1002a6 <__x86.get_pc_thunk.ax>
  100133:	05 3d 78 01 00       	add    $0x1783d,%eax
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100138:	8d 80 ba 86 fe ff    	lea    -0x17946(%eax),%eax
  10013e:	83 ec 04             	sub    $0x4,%esp
  100141:	68 00 00 ff ff       	push   $0xffff0000
  100146:	50                   	push   %eax
  100147:	6a 00                	push   $0x0
  100149:	e8 b6 ff ff ff       	call   100104 <grade_backtrace0>
  10014e:	83 c4 10             	add    $0x10,%esp
}
  100151:	90                   	nop
  100152:	c9                   	leave  
  100153:	c3                   	ret    

00100154 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100154:	55                   	push   %ebp
  100155:	89 e5                	mov    %esp,%ebp
  100157:	53                   	push   %ebx
  100158:	83 ec 14             	sub    $0x14,%esp
  10015b:	e8 4a 01 00 00       	call   1002aa <__x86.get_pc_thunk.bx>
  100160:	81 c3 10 78 01 00    	add    $0x17810,%ebx
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100166:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100169:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10016c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10016f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100172:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100176:	0f b7 c0             	movzwl %ax,%eax
  100179:	83 e0 03             	and    $0x3,%eax
  10017c:	89 c2                	mov    %eax,%edx
  10017e:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
  100184:	83 ec 04             	sub    $0x4,%esp
  100187:	52                   	push   %edx
  100188:	50                   	push   %eax
  100189:	8d 83 f9 e7 fe ff    	lea    -0x11807(%ebx),%eax
  10018f:	50                   	push   %eax
  100190:	e8 88 01 00 00       	call   10031d <cprintf>
  100195:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100198:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10019c:	0f b7 d0             	movzwl %ax,%edx
  10019f:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
  1001a5:	83 ec 04             	sub    $0x4,%esp
  1001a8:	52                   	push   %edx
  1001a9:	50                   	push   %eax
  1001aa:	8d 83 07 e8 fe ff    	lea    -0x117f9(%ebx),%eax
  1001b0:	50                   	push   %eax
  1001b1:	e8 67 01 00 00       	call   10031d <cprintf>
  1001b6:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  1001b9:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001bd:	0f b7 d0             	movzwl %ax,%edx
  1001c0:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
  1001c6:	83 ec 04             	sub    $0x4,%esp
  1001c9:	52                   	push   %edx
  1001ca:	50                   	push   %eax
  1001cb:	8d 83 15 e8 fe ff    	lea    -0x117eb(%ebx),%eax
  1001d1:	50                   	push   %eax
  1001d2:	e8 46 01 00 00       	call   10031d <cprintf>
  1001d7:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  1001da:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001de:	0f b7 d0             	movzwl %ax,%edx
  1001e1:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
  1001e7:	83 ec 04             	sub    $0x4,%esp
  1001ea:	52                   	push   %edx
  1001eb:	50                   	push   %eax
  1001ec:	8d 83 23 e8 fe ff    	lea    -0x117dd(%ebx),%eax
  1001f2:	50                   	push   %eax
  1001f3:	e8 25 01 00 00       	call   10031d <cprintf>
  1001f8:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  1001fb:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001ff:	0f b7 d0             	movzwl %ax,%edx
  100202:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
  100208:	83 ec 04             	sub    $0x4,%esp
  10020b:	52                   	push   %edx
  10020c:	50                   	push   %eax
  10020d:	8d 83 31 e8 fe ff    	lea    -0x117cf(%ebx),%eax
  100213:	50                   	push   %eax
  100214:	e8 04 01 00 00       	call   10031d <cprintf>
  100219:	83 c4 10             	add    $0x10,%esp
    round ++;
  10021c:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
  100222:	83 c0 01             	add    $0x1,%eax
  100225:	89 83 90 01 00 00    	mov    %eax,0x190(%ebx)
}
  10022b:	90                   	nop
  10022c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10022f:	c9                   	leave  
  100230:	c3                   	ret    

00100231 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  100231:	55                   	push   %ebp
  100232:	89 e5                	mov    %esp,%ebp
  100234:	e8 6d 00 00 00       	call   1002a6 <__x86.get_pc_thunk.ax>
  100239:	05 37 77 01 00       	add    $0x17737,%eax
    //LAB1 CHALLENGE 1 : TODO
}
  10023e:	90                   	nop
  10023f:	5d                   	pop    %ebp
  100240:	c3                   	ret    

00100241 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100241:	55                   	push   %ebp
  100242:	89 e5                	mov    %esp,%ebp
  100244:	e8 5d 00 00 00       	call   1002a6 <__x86.get_pc_thunk.ax>
  100249:	05 27 77 01 00       	add    $0x17727,%eax
    //LAB1 CHALLENGE 1 :  TODO
}
  10024e:	90                   	nop
  10024f:	5d                   	pop    %ebp
  100250:	c3                   	ret    

00100251 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100251:	55                   	push   %ebp
  100252:	89 e5                	mov    %esp,%ebp
  100254:	53                   	push   %ebx
  100255:	83 ec 04             	sub    $0x4,%esp
  100258:	e8 4d 00 00 00       	call   1002aa <__x86.get_pc_thunk.bx>
  10025d:	81 c3 13 77 01 00    	add    $0x17713,%ebx
    lab1_print_cur_status();
  100263:	e8 ec fe ff ff       	call   100154 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100268:	83 ec 0c             	sub    $0xc,%esp
  10026b:	8d 83 40 e8 fe ff    	lea    -0x117c0(%ebx),%eax
  100271:	50                   	push   %eax
  100272:	e8 a6 00 00 00       	call   10031d <cprintf>
  100277:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  10027a:	e8 b2 ff ff ff       	call   100231 <lab1_switch_to_user>
    lab1_print_cur_status();
  10027f:	e8 d0 fe ff ff       	call   100154 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100284:	83 ec 0c             	sub    $0xc,%esp
  100287:	8d 83 60 e8 fe ff    	lea    -0x117a0(%ebx),%eax
  10028d:	50                   	push   %eax
  10028e:	e8 8a 00 00 00       	call   10031d <cprintf>
  100293:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  100296:	e8 a6 ff ff ff       	call   100241 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10029b:	e8 b4 fe ff ff       	call   100154 <lab1_print_cur_status>
}
  1002a0:	90                   	nop
  1002a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1002a4:	c9                   	leave  
  1002a5:	c3                   	ret    

001002a6 <__x86.get_pc_thunk.ax>:
  1002a6:	8b 04 24             	mov    (%esp),%eax
  1002a9:	c3                   	ret    

001002aa <__x86.get_pc_thunk.bx>:
  1002aa:	8b 1c 24             	mov    (%esp),%ebx
  1002ad:	c3                   	ret    

001002ae <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002ae:	55                   	push   %ebp
  1002af:	89 e5                	mov    %esp,%ebp
  1002b1:	53                   	push   %ebx
  1002b2:	83 ec 04             	sub    $0x4,%esp
  1002b5:	e8 ec ff ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1002ba:	05 b6 76 01 00       	add    $0x176b6,%eax
    cons_putc(c);
  1002bf:	83 ec 0c             	sub    $0xc,%esp
  1002c2:	ff 75 08             	pushl  0x8(%ebp)
  1002c5:	89 c3                	mov    %eax,%ebx
  1002c7:	e8 94 15 00 00       	call   101860 <cons_putc>
  1002cc:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  1002cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d2:	8b 00                	mov    (%eax),%eax
  1002d4:	8d 50 01             	lea    0x1(%eax),%edx
  1002d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002da:	89 10                	mov    %edx,(%eax)
}
  1002dc:	90                   	nop
  1002dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1002e0:	c9                   	leave  
  1002e1:	c3                   	ret    

001002e2 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002e2:	55                   	push   %ebp
  1002e3:	89 e5                	mov    %esp,%ebp
  1002e5:	53                   	push   %ebx
  1002e6:	83 ec 14             	sub    $0x14,%esp
  1002e9:	e8 b8 ff ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1002ee:	05 82 76 01 00       	add    $0x17682,%eax
    int cnt = 0;
  1002f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002fa:	ff 75 0c             	pushl  0xc(%ebp)
  1002fd:	ff 75 08             	pushl  0x8(%ebp)
  100300:	8d 55 f4             	lea    -0xc(%ebp),%edx
  100303:	52                   	push   %edx
  100304:	8d 90 3e 89 fe ff    	lea    -0x176c2(%eax),%edx
  10030a:	52                   	push   %edx
  10030b:	89 c3                	mov    %eax,%ebx
  10030d:	e8 96 59 00 00       	call   105ca8 <vprintfmt>
  100312:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100315:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100318:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10031b:	c9                   	leave  
  10031c:	c3                   	ret    

0010031d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10031d:	55                   	push   %ebp
  10031e:	89 e5                	mov    %esp,%ebp
  100320:	83 ec 18             	sub    $0x18,%esp
  100323:	e8 7e ff ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  100328:	05 48 76 01 00       	add    $0x17648,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10032d:	8d 45 0c             	lea    0xc(%ebp),%eax
  100330:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100336:	83 ec 08             	sub    $0x8,%esp
  100339:	50                   	push   %eax
  10033a:	ff 75 08             	pushl  0x8(%ebp)
  10033d:	e8 a0 ff ff ff       	call   1002e2 <vcprintf>
  100342:	83 c4 10             	add    $0x10,%esp
  100345:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100348:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10034b:	c9                   	leave  
  10034c:	c3                   	ret    

0010034d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10034d:	55                   	push   %ebp
  10034e:	89 e5                	mov    %esp,%ebp
  100350:	53                   	push   %ebx
  100351:	83 ec 04             	sub    $0x4,%esp
  100354:	e8 4d ff ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  100359:	05 17 76 01 00       	add    $0x17617,%eax
    cons_putc(c);
  10035e:	83 ec 0c             	sub    $0xc,%esp
  100361:	ff 75 08             	pushl  0x8(%ebp)
  100364:	89 c3                	mov    %eax,%ebx
  100366:	e8 f5 14 00 00       	call   101860 <cons_putc>
  10036b:	83 c4 10             	add    $0x10,%esp
}
  10036e:	90                   	nop
  10036f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100372:	c9                   	leave  
  100373:	c3                   	ret    

00100374 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100374:	55                   	push   %ebp
  100375:	89 e5                	mov    %esp,%ebp
  100377:	83 ec 18             	sub    $0x18,%esp
  10037a:	e8 27 ff ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  10037f:	05 f1 75 01 00       	add    $0x175f1,%eax
    int cnt = 0;
  100384:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10038b:	eb 14                	jmp    1003a1 <cputs+0x2d>
        cputch(c, &cnt);
  10038d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100391:	83 ec 08             	sub    $0x8,%esp
  100394:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100397:	52                   	push   %edx
  100398:	50                   	push   %eax
  100399:	e8 10 ff ff ff       	call   1002ae <cputch>
  10039e:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  1003a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1003a4:	8d 50 01             	lea    0x1(%eax),%edx
  1003a7:	89 55 08             	mov    %edx,0x8(%ebp)
  1003aa:	0f b6 00             	movzbl (%eax),%eax
  1003ad:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003b0:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003b4:	75 d7                	jne    10038d <cputs+0x19>
    }
    cputch('\n', &cnt);
  1003b6:	83 ec 08             	sub    $0x8,%esp
  1003b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003bc:	50                   	push   %eax
  1003bd:	6a 0a                	push   $0xa
  1003bf:	e8 ea fe ff ff       	call   1002ae <cputch>
  1003c4:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1003c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003ca:	c9                   	leave  
  1003cb:	c3                   	ret    

001003cc <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003cc:	55                   	push   %ebp
  1003cd:	89 e5                	mov    %esp,%ebp
  1003cf:	53                   	push   %ebx
  1003d0:	83 ec 14             	sub    $0x14,%esp
  1003d3:	e8 d2 fe ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  1003d8:	81 c3 98 75 01 00    	add    $0x17598,%ebx
    int c;
    while ((c = cons_getc()) == 0)
  1003de:	e8 d0 14 00 00       	call   1018b3 <cons_getc>
  1003e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ea:	74 f2                	je     1003de <getchar+0x12>
        /* do nothing */;
    return c;
  1003ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003ef:	83 c4 14             	add    $0x14,%esp
  1003f2:	5b                   	pop    %ebx
  1003f3:	5d                   	pop    %ebp
  1003f4:	c3                   	ret    

001003f5 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1003f5:	55                   	push   %ebp
  1003f6:	89 e5                	mov    %esp,%ebp
  1003f8:	53                   	push   %ebx
  1003f9:	83 ec 14             	sub    $0x14,%esp
  1003fc:	e8 a9 fe ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  100401:	81 c3 6f 75 01 00    	add    $0x1756f,%ebx
    if (prompt != NULL) {
  100407:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10040b:	74 15                	je     100422 <readline+0x2d>
        cprintf("%s", prompt);
  10040d:	83 ec 08             	sub    $0x8,%esp
  100410:	ff 75 08             	pushl  0x8(%ebp)
  100413:	8d 83 7f e8 fe ff    	lea    -0x11781(%ebx),%eax
  100419:	50                   	push   %eax
  10041a:	e8 fe fe ff ff       	call   10031d <cprintf>
  10041f:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100429:	e8 9e ff ff ff       	call   1003cc <getchar>
  10042e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100431:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100435:	79 0a                	jns    100441 <readline+0x4c>
            return NULL;
  100437:	b8 00 00 00 00       	mov    $0x0,%eax
  10043c:	e9 87 00 00 00       	jmp    1004c8 <readline+0xd3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100441:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100445:	7e 2c                	jle    100473 <readline+0x7e>
  100447:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10044e:	7f 23                	jg     100473 <readline+0x7e>
            cputchar(c);
  100450:	83 ec 0c             	sub    $0xc,%esp
  100453:	ff 75 f0             	pushl  -0x10(%ebp)
  100456:	e8 f2 fe ff ff       	call   10034d <cputchar>
  10045b:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10045e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100461:	8d 50 01             	lea    0x1(%eax),%edx
  100464:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100467:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046a:	88 94 03 b0 01 00 00 	mov    %dl,0x1b0(%ebx,%eax,1)
  100471:	eb 50                	jmp    1004c3 <readline+0xce>
        }
        else if (c == '\b' && i > 0) {
  100473:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100477:	75 1a                	jne    100493 <readline+0x9e>
  100479:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10047d:	7e 14                	jle    100493 <readline+0x9e>
            cputchar(c);
  10047f:	83 ec 0c             	sub    $0xc,%esp
  100482:	ff 75 f0             	pushl  -0x10(%ebp)
  100485:	e8 c3 fe ff ff       	call   10034d <cputchar>
  10048a:	83 c4 10             	add    $0x10,%esp
            i --;
  10048d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100491:	eb 30                	jmp    1004c3 <readline+0xce>
        }
        else if (c == '\n' || c == '\r') {
  100493:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100497:	74 06                	je     10049f <readline+0xaa>
  100499:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10049d:	75 8a                	jne    100429 <readline+0x34>
            cputchar(c);
  10049f:	83 ec 0c             	sub    $0xc,%esp
  1004a2:	ff 75 f0             	pushl  -0x10(%ebp)
  1004a5:	e8 a3 fe ff ff       	call   10034d <cputchar>
  1004aa:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1004ad:	8d 93 b0 01 00 00    	lea    0x1b0(%ebx),%edx
  1004b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004b6:	01 d0                	add    %edx,%eax
  1004b8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1004bb:	8d 83 b0 01 00 00    	lea    0x1b0(%ebx),%eax
  1004c1:	eb 05                	jmp    1004c8 <readline+0xd3>
        c = getchar();
  1004c3:	e9 61 ff ff ff       	jmp    100429 <readline+0x34>
        }
    }
}
  1004c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1004cb:	c9                   	leave  
  1004cc:	c3                   	ret    

001004cd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1004cd:	55                   	push   %ebp
  1004ce:	89 e5                	mov    %esp,%ebp
  1004d0:	53                   	push   %ebx
  1004d1:	83 ec 14             	sub    $0x14,%esp
  1004d4:	e8 d1 fd ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  1004d9:	81 c3 97 74 01 00    	add    $0x17497,%ebx
    if (is_panic) {
  1004df:	8b 83 b0 05 00 00    	mov    0x5b0(%ebx),%eax
  1004e5:	85 c0                	test   %eax,%eax
  1004e7:	75 4e                	jne    100537 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1004e9:	c7 83 b0 05 00 00 01 	movl   $0x1,0x5b0(%ebx)
  1004f0:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1004f3:	8d 45 14             	lea    0x14(%ebp),%eax
  1004f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1004f9:	83 ec 04             	sub    $0x4,%esp
  1004fc:	ff 75 0c             	pushl  0xc(%ebp)
  1004ff:	ff 75 08             	pushl  0x8(%ebp)
  100502:	8d 83 82 e8 fe ff    	lea    -0x1177e(%ebx),%eax
  100508:	50                   	push   %eax
  100509:	e8 0f fe ff ff       	call   10031d <cprintf>
  10050e:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100514:	83 ec 08             	sub    $0x8,%esp
  100517:	50                   	push   %eax
  100518:	ff 75 10             	pushl  0x10(%ebp)
  10051b:	e8 c2 fd ff ff       	call   1002e2 <vcprintf>
  100520:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100523:	83 ec 0c             	sub    $0xc,%esp
  100526:	8d 83 9e e8 fe ff    	lea    -0x11762(%ebx),%eax
  10052c:	50                   	push   %eax
  10052d:	e8 eb fd ff ff       	call   10031d <cprintf>
  100532:	83 c4 10             	add    $0x10,%esp
  100535:	eb 01                	jmp    100538 <__panic+0x6b>
        goto panic_dead;
  100537:	90                   	nop
    va_end(ap);

panic_dead:
    intr_disable();
  100538:	e8 f6 15 00 00       	call   101b33 <intr_disable>
    while (1) {
        kmonitor(NULL);
  10053d:	83 ec 0c             	sub    $0xc,%esp
  100540:	6a 00                	push   $0x0
  100542:	e8 34 08 00 00       	call   100d7b <kmonitor>
  100547:	83 c4 10             	add    $0x10,%esp
  10054a:	eb f1                	jmp    10053d <__panic+0x70>

0010054c <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10054c:	55                   	push   %ebp
  10054d:	89 e5                	mov    %esp,%ebp
  10054f:	53                   	push   %ebx
  100550:	83 ec 14             	sub    $0x14,%esp
  100553:	e8 52 fd ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  100558:	81 c3 18 74 01 00    	add    $0x17418,%ebx
    va_list ap;
    va_start(ap, fmt);
  10055e:	8d 45 14             	lea    0x14(%ebp),%eax
  100561:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100564:	83 ec 04             	sub    $0x4,%esp
  100567:	ff 75 0c             	pushl  0xc(%ebp)
  10056a:	ff 75 08             	pushl  0x8(%ebp)
  10056d:	8d 83 a0 e8 fe ff    	lea    -0x11760(%ebx),%eax
  100573:	50                   	push   %eax
  100574:	e8 a4 fd ff ff       	call   10031d <cprintf>
  100579:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10057c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10057f:	83 ec 08             	sub    $0x8,%esp
  100582:	50                   	push   %eax
  100583:	ff 75 10             	pushl  0x10(%ebp)
  100586:	e8 57 fd ff ff       	call   1002e2 <vcprintf>
  10058b:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10058e:	83 ec 0c             	sub    $0xc,%esp
  100591:	8d 83 9e e8 fe ff    	lea    -0x11762(%ebx),%eax
  100597:	50                   	push   %eax
  100598:	e8 80 fd ff ff       	call   10031d <cprintf>
  10059d:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1005a0:	90                   	nop
  1005a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1005a4:	c9                   	leave  
  1005a5:	c3                   	ret    

001005a6 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1005a6:	55                   	push   %ebp
  1005a7:	89 e5                	mov    %esp,%ebp
  1005a9:	e8 f8 fc ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1005ae:	05 c2 73 01 00       	add    $0x173c2,%eax
    return is_panic;
  1005b3:	8b 80 b0 05 00 00    	mov    0x5b0(%eax),%eax
}
  1005b9:	5d                   	pop    %ebp
  1005ba:	c3                   	ret    

001005bb <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1005bb:	55                   	push   %ebp
  1005bc:	89 e5                	mov    %esp,%ebp
  1005be:	83 ec 20             	sub    $0x20,%esp
  1005c1:	e8 e0 fc ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1005c6:	05 aa 73 01 00       	add    $0x173aa,%eax
    int l = *region_left, r = *region_right, any_matches = 0;
  1005cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ce:	8b 00                	mov    (%eax),%eax
  1005d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005d3:	8b 45 10             	mov    0x10(%ebp),%eax
  1005d6:	8b 00                	mov    (%eax),%eax
  1005d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1005e2:	e9 d2 00 00 00       	jmp    1006b9 <stab_binsearch+0xfe>
        int true_m = (l + r) / 2, m = true_m;
  1005e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1005ed:	01 d0                	add    %edx,%eax
  1005ef:	89 c2                	mov    %eax,%edx
  1005f1:	c1 ea 1f             	shr    $0x1f,%edx
  1005f4:	01 d0                	add    %edx,%eax
  1005f6:	d1 f8                	sar    %eax
  1005f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1005fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1005fe:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100601:	eb 04                	jmp    100607 <stab_binsearch+0x4c>
            m --;
  100603:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10060a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10060d:	7c 1f                	jl     10062e <stab_binsearch+0x73>
  10060f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100612:	89 d0                	mov    %edx,%eax
  100614:	01 c0                	add    %eax,%eax
  100616:	01 d0                	add    %edx,%eax
  100618:	c1 e0 02             	shl    $0x2,%eax
  10061b:	89 c2                	mov    %eax,%edx
  10061d:	8b 45 08             	mov    0x8(%ebp),%eax
  100620:	01 d0                	add    %edx,%eax
  100622:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100626:	0f b6 c0             	movzbl %al,%eax
  100629:	39 45 14             	cmp    %eax,0x14(%ebp)
  10062c:	75 d5                	jne    100603 <stab_binsearch+0x48>
        }
        if (m < l) {    // no match in [l, m]
  10062e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100631:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100634:	7d 0b                	jge    100641 <stab_binsearch+0x86>
            l = true_m + 1;
  100636:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100639:	83 c0 01             	add    $0x1,%eax
  10063c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10063f:	eb 78                	jmp    1006b9 <stab_binsearch+0xfe>
        }

        // actual binary search
        any_matches = 1;
  100641:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100648:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10064b:	89 d0                	mov    %edx,%eax
  10064d:	01 c0                	add    %eax,%eax
  10064f:	01 d0                	add    %edx,%eax
  100651:	c1 e0 02             	shl    $0x2,%eax
  100654:	89 c2                	mov    %eax,%edx
  100656:	8b 45 08             	mov    0x8(%ebp),%eax
  100659:	01 d0                	add    %edx,%eax
  10065b:	8b 40 08             	mov    0x8(%eax),%eax
  10065e:	39 45 18             	cmp    %eax,0x18(%ebp)
  100661:	76 13                	jbe    100676 <stab_binsearch+0xbb>
            *region_left = m;
  100663:	8b 45 0c             	mov    0xc(%ebp),%eax
  100666:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100669:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10066b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066e:	83 c0 01             	add    $0x1,%eax
  100671:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100674:	eb 43                	jmp    1006b9 <stab_binsearch+0xfe>
        } else if (stabs[m].n_value > addr) {
  100676:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100679:	89 d0                	mov    %edx,%eax
  10067b:	01 c0                	add    %eax,%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	c1 e0 02             	shl    $0x2,%eax
  100682:	89 c2                	mov    %eax,%edx
  100684:	8b 45 08             	mov    0x8(%ebp),%eax
  100687:	01 d0                	add    %edx,%eax
  100689:	8b 40 08             	mov    0x8(%eax),%eax
  10068c:	39 45 18             	cmp    %eax,0x18(%ebp)
  10068f:	73 16                	jae    1006a7 <stab_binsearch+0xec>
            *region_right = m - 1;
  100691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100694:	8d 50 ff             	lea    -0x1(%eax),%edx
  100697:	8b 45 10             	mov    0x10(%ebp),%eax
  10069a:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10069c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10069f:	83 e8 01             	sub    $0x1,%eax
  1006a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1006a5:	eb 12                	jmp    1006b9 <stab_binsearch+0xfe>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1006a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1006ad:	89 10                	mov    %edx,(%eax)
            l = m;
  1006af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1006b5:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  1006b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1006bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1006bf:	0f 8e 22 ff ff ff    	jle    1005e7 <stab_binsearch+0x2c>
        }
    }

    if (!any_matches) {
  1006c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1006c9:	75 0f                	jne    1006da <stab_binsearch+0x11f>
        *region_right = *region_left - 1;
  1006cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ce:	8b 00                	mov    (%eax),%eax
  1006d0:	8d 50 ff             	lea    -0x1(%eax),%edx
  1006d3:	8b 45 10             	mov    0x10(%ebp),%eax
  1006d6:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1006d8:	eb 3f                	jmp    100719 <stab_binsearch+0x15e>
        l = *region_right;
  1006da:	8b 45 10             	mov    0x10(%ebp),%eax
  1006dd:	8b 00                	mov    (%eax),%eax
  1006df:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1006e2:	eb 04                	jmp    1006e8 <stab_binsearch+0x12d>
  1006e4:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006eb:	8b 00                	mov    (%eax),%eax
  1006ed:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1006f0:	7e 1f                	jle    100711 <stab_binsearch+0x156>
  1006f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1006f5:	89 d0                	mov    %edx,%eax
  1006f7:	01 c0                	add    %eax,%eax
  1006f9:	01 d0                	add    %edx,%eax
  1006fb:	c1 e0 02             	shl    $0x2,%eax
  1006fe:	89 c2                	mov    %eax,%edx
  100700:	8b 45 08             	mov    0x8(%ebp),%eax
  100703:	01 d0                	add    %edx,%eax
  100705:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100709:	0f b6 c0             	movzbl %al,%eax
  10070c:	39 45 14             	cmp    %eax,0x14(%ebp)
  10070f:	75 d3                	jne    1006e4 <stab_binsearch+0x129>
        *region_left = l;
  100711:	8b 45 0c             	mov    0xc(%ebp),%eax
  100714:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100717:	89 10                	mov    %edx,(%eax)
}
  100719:	90                   	nop
  10071a:	c9                   	leave  
  10071b:	c3                   	ret    

0010071c <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10071c:	55                   	push   %ebp
  10071d:	89 e5                	mov    %esp,%ebp
  10071f:	53                   	push   %ebx
  100720:	83 ec 34             	sub    $0x34,%esp
  100723:	e8 82 fb ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  100728:	81 c3 48 72 01 00    	add    $0x17248,%ebx
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10072e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100731:	8d 93 c0 e8 fe ff    	lea    -0x11740(%ebx),%edx
  100737:	89 10                	mov    %edx,(%eax)
    info->eip_line = 0;
  100739:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100743:	8b 45 0c             	mov    0xc(%ebp),%eax
  100746:	8d 93 c0 e8 fe ff    	lea    -0x11740(%ebx),%edx
  10074c:	89 50 08             	mov    %edx,0x8(%eax)
    info->eip_fn_namelen = 9;
  10074f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100752:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100759:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075c:	8b 55 08             	mov    0x8(%ebp),%edx
  10075f:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100762:	8b 45 0c             	mov    0xc(%ebp),%eax
  100765:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10076c:	c7 c0 74 73 10 00    	mov    $0x107374,%eax
  100772:	89 45 f4             	mov    %eax,-0xc(%ebp)
    stab_end = __STAB_END__;
  100775:	c7 c0 d8 20 11 00    	mov    $0x1120d8,%eax
  10077b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10077e:	c7 c0 d9 20 11 00    	mov    $0x1120d9,%eax
  100784:	89 45 ec             	mov    %eax,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100787:	c7 c0 a9 4b 11 00    	mov    $0x114ba9,%eax
  10078d:	89 45 e8             	mov    %eax,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100790:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100793:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100796:	76 0d                	jbe    1007a5 <debuginfo_eip+0x89>
  100798:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10079b:	83 e8 01             	sub    $0x1,%eax
  10079e:	0f b6 00             	movzbl (%eax),%eax
  1007a1:	84 c0                	test   %al,%al
  1007a3:	74 0a                	je     1007af <debuginfo_eip+0x93>
        return -1;
  1007a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007aa:	e9 91 02 00 00       	jmp    100a40 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1007af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1007b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	29 c2                	sub    %eax,%edx
  1007be:	89 d0                	mov    %edx,%eax
  1007c0:	c1 f8 02             	sar    $0x2,%eax
  1007c3:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1007c9:	83 e8 01             	sub    $0x1,%eax
  1007cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1007cf:	ff 75 08             	pushl  0x8(%ebp)
  1007d2:	6a 64                	push   $0x64
  1007d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1007d7:	50                   	push   %eax
  1007d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1007db:	50                   	push   %eax
  1007dc:	ff 75 f4             	pushl  -0xc(%ebp)
  1007df:	e8 d7 fd ff ff       	call   1005bb <stab_binsearch>
  1007e4:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  1007e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007ea:	85 c0                	test   %eax,%eax
  1007ec:	75 0a                	jne    1007f8 <debuginfo_eip+0xdc>
        return -1;
  1007ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007f3:	e9 48 02 00 00       	jmp    100a40 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1007f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1007fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100801:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100804:	ff 75 08             	pushl  0x8(%ebp)
  100807:	6a 24                	push   $0x24
  100809:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10080c:	50                   	push   %eax
  10080d:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100810:	50                   	push   %eax
  100811:	ff 75 f4             	pushl  -0xc(%ebp)
  100814:	e8 a2 fd ff ff       	call   1005bb <stab_binsearch>
  100819:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  10081c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10081f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100822:	39 c2                	cmp    %eax,%edx
  100824:	7f 7c                	jg     1008a2 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100826:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100829:	89 c2                	mov    %eax,%edx
  10082b:	89 d0                	mov    %edx,%eax
  10082d:	01 c0                	add    %eax,%eax
  10082f:	01 d0                	add    %edx,%eax
  100831:	c1 e0 02             	shl    $0x2,%eax
  100834:	89 c2                	mov    %eax,%edx
  100836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100839:	01 d0                	add    %edx,%eax
  10083b:	8b 00                	mov    (%eax),%eax
  10083d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100840:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100843:	29 d1                	sub    %edx,%ecx
  100845:	89 ca                	mov    %ecx,%edx
  100847:	39 d0                	cmp    %edx,%eax
  100849:	73 22                	jae    10086d <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10084b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10084e:	89 c2                	mov    %eax,%edx
  100850:	89 d0                	mov    %edx,%eax
  100852:	01 c0                	add    %eax,%eax
  100854:	01 d0                	add    %edx,%eax
  100856:	c1 e0 02             	shl    $0x2,%eax
  100859:	89 c2                	mov    %eax,%edx
  10085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085e:	01 d0                	add    %edx,%eax
  100860:	8b 10                	mov    (%eax),%edx
  100862:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100865:	01 c2                	add    %eax,%edx
  100867:	8b 45 0c             	mov    0xc(%ebp),%eax
  10086a:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10086d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100870:	89 c2                	mov    %eax,%edx
  100872:	89 d0                	mov    %edx,%eax
  100874:	01 c0                	add    %eax,%eax
  100876:	01 d0                	add    %edx,%eax
  100878:	c1 e0 02             	shl    $0x2,%eax
  10087b:	89 c2                	mov    %eax,%edx
  10087d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100880:	01 d0                	add    %edx,%eax
  100882:	8b 50 08             	mov    0x8(%eax),%edx
  100885:	8b 45 0c             	mov    0xc(%ebp),%eax
  100888:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10088b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10088e:	8b 40 10             	mov    0x10(%eax),%eax
  100891:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100894:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100897:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10089a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10089d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1008a0:	eb 15                	jmp    1008b7 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1008a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008a5:	8b 55 08             	mov    0x8(%ebp),%edx
  1008a8:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1008b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1008b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1008b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ba:	8b 40 08             	mov    0x8(%eax),%eax
  1008bd:	83 ec 08             	sub    $0x8,%esp
  1008c0:	6a 3a                	push   $0x3a
  1008c2:	50                   	push   %eax
  1008c3:	e8 b2 4e 00 00       	call   10577a <strfind>
  1008c8:	83 c4 10             	add    $0x10,%esp
  1008cb:	89 c2                	mov    %eax,%edx
  1008cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d0:	8b 40 08             	mov    0x8(%eax),%eax
  1008d3:	29 c2                	sub    %eax,%edx
  1008d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d8:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1008db:	83 ec 0c             	sub    $0xc,%esp
  1008de:	ff 75 08             	pushl  0x8(%ebp)
  1008e1:	6a 44                	push   $0x44
  1008e3:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1008e6:	50                   	push   %eax
  1008e7:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1008ea:	50                   	push   %eax
  1008eb:	ff 75 f4             	pushl  -0xc(%ebp)
  1008ee:	e8 c8 fc ff ff       	call   1005bb <stab_binsearch>
  1008f3:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1008f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1008fc:	39 c2                	cmp    %eax,%edx
  1008fe:	7f 24                	jg     100924 <debuginfo_eip+0x208>
        info->eip_line = stabs[rline].n_desc;
  100900:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100903:	89 c2                	mov    %eax,%edx
  100905:	89 d0                	mov    %edx,%eax
  100907:	01 c0                	add    %eax,%eax
  100909:	01 d0                	add    %edx,%eax
  10090b:	c1 e0 02             	shl    $0x2,%eax
  10090e:	89 c2                	mov    %eax,%edx
  100910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100913:	01 d0                	add    %edx,%eax
  100915:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100919:	0f b7 d0             	movzwl %ax,%edx
  10091c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10091f:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100922:	eb 13                	jmp    100937 <debuginfo_eip+0x21b>
        return -1;
  100924:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100929:	e9 12 01 00 00       	jmp    100a40 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10092e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100931:	83 e8 01             	sub    $0x1,%eax
  100934:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100937:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10093a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10093d:	39 c2                	cmp    %eax,%edx
  10093f:	7c 56                	jl     100997 <debuginfo_eip+0x27b>
           && stabs[lline].n_type != N_SOL
  100941:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100944:	89 c2                	mov    %eax,%edx
  100946:	89 d0                	mov    %edx,%eax
  100948:	01 c0                	add    %eax,%eax
  10094a:	01 d0                	add    %edx,%eax
  10094c:	c1 e0 02             	shl    $0x2,%eax
  10094f:	89 c2                	mov    %eax,%edx
  100951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100954:	01 d0                	add    %edx,%eax
  100956:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10095a:	3c 84                	cmp    $0x84,%al
  10095c:	74 39                	je     100997 <debuginfo_eip+0x27b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10095e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100961:	89 c2                	mov    %eax,%edx
  100963:	89 d0                	mov    %edx,%eax
  100965:	01 c0                	add    %eax,%eax
  100967:	01 d0                	add    %edx,%eax
  100969:	c1 e0 02             	shl    $0x2,%eax
  10096c:	89 c2                	mov    %eax,%edx
  10096e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100971:	01 d0                	add    %edx,%eax
  100973:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100977:	3c 64                	cmp    $0x64,%al
  100979:	75 b3                	jne    10092e <debuginfo_eip+0x212>
  10097b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10097e:	89 c2                	mov    %eax,%edx
  100980:	89 d0                	mov    %edx,%eax
  100982:	01 c0                	add    %eax,%eax
  100984:	01 d0                	add    %edx,%eax
  100986:	c1 e0 02             	shl    $0x2,%eax
  100989:	89 c2                	mov    %eax,%edx
  10098b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10098e:	01 d0                	add    %edx,%eax
  100990:	8b 40 08             	mov    0x8(%eax),%eax
  100993:	85 c0                	test   %eax,%eax
  100995:	74 97                	je     10092e <debuginfo_eip+0x212>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100997:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10099a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10099d:	39 c2                	cmp    %eax,%edx
  10099f:	7c 46                	jl     1009e7 <debuginfo_eip+0x2cb>
  1009a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1009a4:	89 c2                	mov    %eax,%edx
  1009a6:	89 d0                	mov    %edx,%eax
  1009a8:	01 c0                	add    %eax,%eax
  1009aa:	01 d0                	add    %edx,%eax
  1009ac:	c1 e0 02             	shl    $0x2,%eax
  1009af:	89 c2                	mov    %eax,%edx
  1009b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009b4:	01 d0                	add    %edx,%eax
  1009b6:	8b 00                	mov    (%eax),%eax
  1009b8:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1009bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1009be:	29 d1                	sub    %edx,%ecx
  1009c0:	89 ca                	mov    %ecx,%edx
  1009c2:	39 d0                	cmp    %edx,%eax
  1009c4:	73 21                	jae    1009e7 <debuginfo_eip+0x2cb>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1009c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1009c9:	89 c2                	mov    %eax,%edx
  1009cb:	89 d0                	mov    %edx,%eax
  1009cd:	01 c0                	add    %eax,%eax
  1009cf:	01 d0                	add    %edx,%eax
  1009d1:	c1 e0 02             	shl    $0x2,%eax
  1009d4:	89 c2                	mov    %eax,%edx
  1009d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d9:	01 d0                	add    %edx,%eax
  1009db:	8b 10                	mov    (%eax),%edx
  1009dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1009e0:	01 c2                	add    %eax,%edx
  1009e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1009e5:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1009e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1009ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1009ed:	39 c2                	cmp    %eax,%edx
  1009ef:	7d 4a                	jge    100a3b <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  1009f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009f4:	83 c0 01             	add    $0x1,%eax
  1009f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1009fa:	eb 18                	jmp    100a14 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1009fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1009ff:	8b 40 14             	mov    0x14(%eax),%eax
  100a02:	8d 50 01             	lea    0x1(%eax),%edx
  100a05:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a08:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100a0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a0e:	83 c0 01             	add    $0x1,%eax
  100a11:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100a14:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100a17:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100a1a:	39 c2                	cmp    %eax,%edx
  100a1c:	7d 1d                	jge    100a3b <debuginfo_eip+0x31f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100a1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a21:	89 c2                	mov    %eax,%edx
  100a23:	89 d0                	mov    %edx,%eax
  100a25:	01 c0                	add    %eax,%eax
  100a27:	01 d0                	add    %edx,%eax
  100a29:	c1 e0 02             	shl    $0x2,%eax
  100a2c:	89 c2                	mov    %eax,%edx
  100a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a31:	01 d0                	add    %edx,%eax
  100a33:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100a37:	3c a0                	cmp    $0xa0,%al
  100a39:	74 c1                	je     1009fc <debuginfo_eip+0x2e0>
        }
    }
    return 0;
  100a3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100a40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100a43:	c9                   	leave  
  100a44:	c3                   	ret    

00100a45 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100a45:	55                   	push   %ebp
  100a46:	89 e5                	mov    %esp,%ebp
  100a48:	53                   	push   %ebx
  100a49:	83 ec 04             	sub    $0x4,%esp
  100a4c:	e8 59 f8 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  100a51:	81 c3 1f 6f 01 00    	add    $0x16f1f,%ebx
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100a57:	83 ec 0c             	sub    $0xc,%esp
  100a5a:	8d 83 ca e8 fe ff    	lea    -0x11736(%ebx),%eax
  100a60:	50                   	push   %eax
  100a61:	e8 b7 f8 ff ff       	call   10031d <cprintf>
  100a66:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100a69:	83 ec 08             	sub    $0x8,%esp
  100a6c:	c7 c0 2a 00 10 00    	mov    $0x10002a,%eax
  100a72:	50                   	push   %eax
  100a73:	8d 83 e3 e8 fe ff    	lea    -0x1171d(%ebx),%eax
  100a79:	50                   	push   %eax
  100a7a:	e8 9e f8 ff ff       	call   10031d <cprintf>
  100a7f:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100a82:	83 ec 08             	sub    $0x8,%esp
  100a85:	c7 c0 46 61 10 00    	mov    $0x106146,%eax
  100a8b:	50                   	push   %eax
  100a8c:	8d 83 fb e8 fe ff    	lea    -0x11705(%ebx),%eax
  100a92:	50                   	push   %eax
  100a93:	e8 85 f8 ff ff       	call   10031d <cprintf>
  100a98:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100a9b:	83 ec 08             	sub    $0x8,%esp
  100a9e:	c7 c0 70 79 11 00    	mov    $0x117970,%eax
  100aa4:	50                   	push   %eax
  100aa5:	8d 83 13 e9 fe ff    	lea    -0x116ed(%ebx),%eax
  100aab:	50                   	push   %eax
  100aac:	e8 6c f8 ff ff       	call   10031d <cprintf>
  100ab1:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100ab4:	83 ec 08             	sub    $0x8,%esp
  100ab7:	c7 c0 28 8a 11 00    	mov    $0x118a28,%eax
  100abd:	50                   	push   %eax
  100abe:	8d 83 2b e9 fe ff    	lea    -0x116d5(%ebx),%eax
  100ac4:	50                   	push   %eax
  100ac5:	e8 53 f8 ff ff       	call   10031d <cprintf>
  100aca:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100acd:	c7 c0 28 8a 11 00    	mov    $0x118a28,%eax
  100ad3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100ad9:	c7 c0 2a 00 10 00    	mov    $0x10002a,%eax
  100adf:	29 c2                	sub    %eax,%edx
  100ae1:	89 d0                	mov    %edx,%eax
  100ae3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100ae9:	85 c0                	test   %eax,%eax
  100aeb:	0f 48 c2             	cmovs  %edx,%eax
  100aee:	c1 f8 0a             	sar    $0xa,%eax
  100af1:	83 ec 08             	sub    $0x8,%esp
  100af4:	50                   	push   %eax
  100af5:	8d 83 44 e9 fe ff    	lea    -0x116bc(%ebx),%eax
  100afb:	50                   	push   %eax
  100afc:	e8 1c f8 ff ff       	call   10031d <cprintf>
  100b01:	83 c4 10             	add    $0x10,%esp
}
  100b04:	90                   	nop
  100b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100b08:	c9                   	leave  
  100b09:	c3                   	ret    

00100b0a <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100b0a:	55                   	push   %ebp
  100b0b:	89 e5                	mov    %esp,%ebp
  100b0d:	53                   	push   %ebx
  100b0e:	81 ec 24 01 00 00    	sub    $0x124,%esp
  100b14:	e8 91 f7 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  100b19:	81 c3 57 6e 01 00    	add    $0x16e57,%ebx
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100b1f:	83 ec 08             	sub    $0x8,%esp
  100b22:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100b25:	50                   	push   %eax
  100b26:	ff 75 08             	pushl  0x8(%ebp)
  100b29:	e8 ee fb ff ff       	call   10071c <debuginfo_eip>
  100b2e:	83 c4 10             	add    $0x10,%esp
  100b31:	85 c0                	test   %eax,%eax
  100b33:	74 17                	je     100b4c <print_debuginfo+0x42>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100b35:	83 ec 08             	sub    $0x8,%esp
  100b38:	ff 75 08             	pushl  0x8(%ebp)
  100b3b:	8d 83 6e e9 fe ff    	lea    -0x11692(%ebx),%eax
  100b41:	50                   	push   %eax
  100b42:	e8 d6 f7 ff ff       	call   10031d <cprintf>
  100b47:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100b4a:	eb 67                	jmp    100bb3 <print_debuginfo+0xa9>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100b4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b53:	eb 1c                	jmp    100b71 <print_debuginfo+0x67>
            fnname[j] = info.eip_fn_name[j];
  100b55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b5b:	01 d0                	add    %edx,%eax
  100b5d:	0f b6 00             	movzbl (%eax),%eax
  100b60:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100b66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b69:	01 ca                	add    %ecx,%edx
  100b6b:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100b6d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b74:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100b77:	7c dc                	jl     100b55 <print_debuginfo+0x4b>
        fnname[j] = '\0';
  100b79:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b82:	01 d0                	add    %edx,%eax
  100b84:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100b87:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100b8a:	8b 55 08             	mov    0x8(%ebp),%edx
  100b8d:	89 d1                	mov    %edx,%ecx
  100b8f:	29 c1                	sub    %eax,%ecx
  100b91:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100b94:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100b97:	83 ec 0c             	sub    $0xc,%esp
  100b9a:	51                   	push   %ecx
  100b9b:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100ba1:	51                   	push   %ecx
  100ba2:	52                   	push   %edx
  100ba3:	50                   	push   %eax
  100ba4:	8d 83 8a e9 fe ff    	lea    -0x11676(%ebx),%eax
  100baa:	50                   	push   %eax
  100bab:	e8 6d f7 ff ff       	call   10031d <cprintf>
  100bb0:	83 c4 20             	add    $0x20,%esp
}
  100bb3:	90                   	nop
  100bb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100bb7:	c9                   	leave  
  100bb8:	c3                   	ret    

00100bb9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100bb9:	55                   	push   %ebp
  100bba:	89 e5                	mov    %esp,%ebp
  100bbc:	83 ec 10             	sub    $0x10,%esp
  100bbf:	e8 e2 f6 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  100bc4:	05 ac 6d 01 00       	add    $0x16dac,%eax
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100bc9:	8b 45 04             	mov    0x4(%ebp),%eax
  100bcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100bcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100bd2:	c9                   	leave  
  100bd3:	c3                   	ret    

00100bd4 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100bd4:	55                   	push   %ebp
  100bd5:	89 e5                	mov    %esp,%ebp
  100bd7:	e8 ca f6 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  100bdc:	05 94 6d 01 00       	add    $0x16d94,%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100be1:	90                   	nop
  100be2:	5d                   	pop    %ebp
  100be3:	c3                   	ret    

00100be4 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100be4:	55                   	push   %ebp
  100be5:	89 e5                	mov    %esp,%ebp
  100be7:	53                   	push   %ebx
  100be8:	83 ec 14             	sub    $0x14,%esp
  100beb:	e8 ba f6 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  100bf0:	81 c3 80 6d 01 00    	add    $0x16d80,%ebx
    int argc = 0;
  100bf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bfd:	eb 0c                	jmp    100c0b <parse+0x27>
            *buf ++ = '\0';
  100bff:	8b 45 08             	mov    0x8(%ebp),%eax
  100c02:	8d 50 01             	lea    0x1(%eax),%edx
  100c05:	89 55 08             	mov    %edx,0x8(%ebp)
  100c08:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0e:	0f b6 00             	movzbl (%eax),%eax
  100c11:	84 c0                	test   %al,%al
  100c13:	74 20                	je     100c35 <parse+0x51>
  100c15:	8b 45 08             	mov    0x8(%ebp),%eax
  100c18:	0f b6 00             	movzbl (%eax),%eax
  100c1b:	0f be c0             	movsbl %al,%eax
  100c1e:	83 ec 08             	sub    $0x8,%esp
  100c21:	50                   	push   %eax
  100c22:	8d 83 1c ea fe ff    	lea    -0x115e4(%ebx),%eax
  100c28:	50                   	push   %eax
  100c29:	e8 0f 4b 00 00       	call   10573d <strchr>
  100c2e:	83 c4 10             	add    $0x10,%esp
  100c31:	85 c0                	test   %eax,%eax
  100c33:	75 ca                	jne    100bff <parse+0x1b>
        }
        if (*buf == '\0') {
  100c35:	8b 45 08             	mov    0x8(%ebp),%eax
  100c38:	0f b6 00             	movzbl (%eax),%eax
  100c3b:	84 c0                	test   %al,%al
  100c3d:	74 69                	je     100ca8 <parse+0xc4>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100c3f:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100c43:	75 14                	jne    100c59 <parse+0x75>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100c45:	83 ec 08             	sub    $0x8,%esp
  100c48:	6a 10                	push   $0x10
  100c4a:	8d 83 21 ea fe ff    	lea    -0x115df(%ebx),%eax
  100c50:	50                   	push   %eax
  100c51:	e8 c7 f6 ff ff       	call   10031d <cprintf>
  100c56:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c5c:	8d 50 01             	lea    0x1(%eax),%edx
  100c5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100c62:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c6c:	01 c2                	add    %eax,%edx
  100c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c71:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c73:	eb 04                	jmp    100c79 <parse+0x95>
            buf ++;
  100c75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c79:	8b 45 08             	mov    0x8(%ebp),%eax
  100c7c:	0f b6 00             	movzbl (%eax),%eax
  100c7f:	84 c0                	test   %al,%al
  100c81:	74 88                	je     100c0b <parse+0x27>
  100c83:	8b 45 08             	mov    0x8(%ebp),%eax
  100c86:	0f b6 00             	movzbl (%eax),%eax
  100c89:	0f be c0             	movsbl %al,%eax
  100c8c:	83 ec 08             	sub    $0x8,%esp
  100c8f:	50                   	push   %eax
  100c90:	8d 83 1c ea fe ff    	lea    -0x115e4(%ebx),%eax
  100c96:	50                   	push   %eax
  100c97:	e8 a1 4a 00 00       	call   10573d <strchr>
  100c9c:	83 c4 10             	add    $0x10,%esp
  100c9f:	85 c0                	test   %eax,%eax
  100ca1:	74 d2                	je     100c75 <parse+0x91>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ca3:	e9 63 ff ff ff       	jmp    100c0b <parse+0x27>
            break;
  100ca8:	90                   	nop
        }
    }
    return argc;
  100ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100cac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100caf:	c9                   	leave  
  100cb0:	c3                   	ret    

00100cb1 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100cb1:	55                   	push   %ebp
  100cb2:	89 e5                	mov    %esp,%ebp
  100cb4:	56                   	push   %esi
  100cb5:	53                   	push   %ebx
  100cb6:	83 ec 50             	sub    $0x50,%esp
  100cb9:	e8 ec f5 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  100cbe:	81 c3 b2 6c 01 00    	add    $0x16cb2,%ebx
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100cc4:	83 ec 08             	sub    $0x8,%esp
  100cc7:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100cca:	50                   	push   %eax
  100ccb:	ff 75 08             	pushl  0x8(%ebp)
  100cce:	e8 11 ff ff ff       	call   100be4 <parse>
  100cd3:	83 c4 10             	add    $0x10,%esp
  100cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100cd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100cdd:	75 0a                	jne    100ce9 <runcmd+0x38>
        return 0;
  100cdf:	b8 00 00 00 00       	mov    $0x0,%eax
  100ce4:	e9 8b 00 00 00       	jmp    100d74 <runcmd+0xc3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ce9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cf0:	eb 5f                	jmp    100d51 <runcmd+0xa0>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100cf2:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cf8:	8d b3 10 00 00 00    	lea    0x10(%ebx),%esi
  100cfe:	89 d0                	mov    %edx,%eax
  100d00:	01 c0                	add    %eax,%eax
  100d02:	01 d0                	add    %edx,%eax
  100d04:	c1 e0 02             	shl    $0x2,%eax
  100d07:	01 f0                	add    %esi,%eax
  100d09:	8b 00                	mov    (%eax),%eax
  100d0b:	83 ec 08             	sub    $0x8,%esp
  100d0e:	51                   	push   %ecx
  100d0f:	50                   	push   %eax
  100d10:	e8 74 49 00 00       	call   105689 <strcmp>
  100d15:	83 c4 10             	add    $0x10,%esp
  100d18:	85 c0                	test   %eax,%eax
  100d1a:	75 31                	jne    100d4d <runcmd+0x9c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100d1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d1f:	8d 8b 18 00 00 00    	lea    0x18(%ebx),%ecx
  100d25:	89 d0                	mov    %edx,%eax
  100d27:	01 c0                	add    %eax,%eax
  100d29:	01 d0                	add    %edx,%eax
  100d2b:	c1 e0 02             	shl    $0x2,%eax
  100d2e:	01 c8                	add    %ecx,%eax
  100d30:	8b 10                	mov    (%eax),%edx
  100d32:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100d35:	83 c0 04             	add    $0x4,%eax
  100d38:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100d3b:	83 e9 01             	sub    $0x1,%ecx
  100d3e:	83 ec 04             	sub    $0x4,%esp
  100d41:	ff 75 0c             	pushl  0xc(%ebp)
  100d44:	50                   	push   %eax
  100d45:	51                   	push   %ecx
  100d46:	ff d2                	call   *%edx
  100d48:	83 c4 10             	add    $0x10,%esp
  100d4b:	eb 27                	jmp    100d74 <runcmd+0xc3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d4d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d54:	83 f8 02             	cmp    $0x2,%eax
  100d57:	76 99                	jbe    100cf2 <runcmd+0x41>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100d59:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100d5c:	83 ec 08             	sub    $0x8,%esp
  100d5f:	50                   	push   %eax
  100d60:	8d 83 3f ea fe ff    	lea    -0x115c1(%ebx),%eax
  100d66:	50                   	push   %eax
  100d67:	e8 b1 f5 ff ff       	call   10031d <cprintf>
  100d6c:	83 c4 10             	add    $0x10,%esp
    return 0;
  100d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  100d77:	5b                   	pop    %ebx
  100d78:	5e                   	pop    %esi
  100d79:	5d                   	pop    %ebp
  100d7a:	c3                   	ret    

00100d7b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100d7b:	55                   	push   %ebp
  100d7c:	89 e5                	mov    %esp,%ebp
  100d7e:	53                   	push   %ebx
  100d7f:	83 ec 14             	sub    $0x14,%esp
  100d82:	e8 23 f5 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  100d87:	81 c3 e9 6b 01 00    	add    $0x16be9,%ebx
    cprintf("Welcome to the kernel debug monitor!!\n");
  100d8d:	83 ec 0c             	sub    $0xc,%esp
  100d90:	8d 83 58 ea fe ff    	lea    -0x115a8(%ebx),%eax
  100d96:	50                   	push   %eax
  100d97:	e8 81 f5 ff ff       	call   10031d <cprintf>
  100d9c:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100d9f:	83 ec 0c             	sub    $0xc,%esp
  100da2:	8d 83 80 ea fe ff    	lea    -0x11580(%ebx),%eax
  100da8:	50                   	push   %eax
  100da9:	e8 6f f5 ff ff       	call   10031d <cprintf>
  100dae:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100db1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100db5:	74 0e                	je     100dc5 <kmonitor+0x4a>
        print_trapframe(tf);
  100db7:	83 ec 0c             	sub    $0xc,%esp
  100dba:	ff 75 08             	pushl  0x8(%ebp)
  100dbd:	e8 1c 0e 00 00       	call   101bde <print_trapframe>
  100dc2:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100dc5:	83 ec 0c             	sub    $0xc,%esp
  100dc8:	8d 83 a5 ea fe ff    	lea    -0x1155b(%ebx),%eax
  100dce:	50                   	push   %eax
  100dcf:	e8 21 f6 ff ff       	call   1003f5 <readline>
  100dd4:	83 c4 10             	add    $0x10,%esp
  100dd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100dda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100dde:	74 e5                	je     100dc5 <kmonitor+0x4a>
            if (runcmd(buf, tf) < 0) {
  100de0:	83 ec 08             	sub    $0x8,%esp
  100de3:	ff 75 08             	pushl  0x8(%ebp)
  100de6:	ff 75 f4             	pushl  -0xc(%ebp)
  100de9:	e8 c3 fe ff ff       	call   100cb1 <runcmd>
  100dee:	83 c4 10             	add    $0x10,%esp
  100df1:	85 c0                	test   %eax,%eax
  100df3:	78 02                	js     100df7 <kmonitor+0x7c>
        if ((buf = readline("K> ")) != NULL) {
  100df5:	eb ce                	jmp    100dc5 <kmonitor+0x4a>
                break;
  100df7:	90                   	nop
            }
        }
    }
}
  100df8:	90                   	nop
  100df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100dfc:	c9                   	leave  
  100dfd:	c3                   	ret    

00100dfe <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100dfe:	55                   	push   %ebp
  100dff:	89 e5                	mov    %esp,%ebp
  100e01:	56                   	push   %esi
  100e02:	53                   	push   %ebx
  100e03:	83 ec 10             	sub    $0x10,%esp
  100e06:	e8 9f f4 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  100e0b:	81 c3 65 6b 01 00    	add    $0x16b65,%ebx
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100e11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100e18:	eb 44                	jmp    100e5e <mon_help+0x60>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100e1d:	8d 8b 14 00 00 00    	lea    0x14(%ebx),%ecx
  100e23:	89 d0                	mov    %edx,%eax
  100e25:	01 c0                	add    %eax,%eax
  100e27:	01 d0                	add    %edx,%eax
  100e29:	c1 e0 02             	shl    $0x2,%eax
  100e2c:	01 c8                	add    %ecx,%eax
  100e2e:	8b 08                	mov    (%eax),%ecx
  100e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100e33:	8d b3 10 00 00 00    	lea    0x10(%ebx),%esi
  100e39:	89 d0                	mov    %edx,%eax
  100e3b:	01 c0                	add    %eax,%eax
  100e3d:	01 d0                	add    %edx,%eax
  100e3f:	c1 e0 02             	shl    $0x2,%eax
  100e42:	01 f0                	add    %esi,%eax
  100e44:	8b 00                	mov    (%eax),%eax
  100e46:	83 ec 04             	sub    $0x4,%esp
  100e49:	51                   	push   %ecx
  100e4a:	50                   	push   %eax
  100e4b:	8d 83 a9 ea fe ff    	lea    -0x11557(%ebx),%eax
  100e51:	50                   	push   %eax
  100e52:	e8 c6 f4 ff ff       	call   10031d <cprintf>
  100e57:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100e5a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e61:	83 f8 02             	cmp    $0x2,%eax
  100e64:	76 b4                	jbe    100e1a <mon_help+0x1c>
    }
    return 0;
  100e66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  100e6e:	5b                   	pop    %ebx
  100e6f:	5e                   	pop    %esi
  100e70:	5d                   	pop    %ebp
  100e71:	c3                   	ret    

00100e72 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100e72:	55                   	push   %ebp
  100e73:	89 e5                	mov    %esp,%ebp
  100e75:	53                   	push   %ebx
  100e76:	83 ec 04             	sub    $0x4,%esp
  100e79:	e8 28 f4 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  100e7e:	05 f2 6a 01 00       	add    $0x16af2,%eax
    print_kerninfo();
  100e83:	89 c3                	mov    %eax,%ebx
  100e85:	e8 bb fb ff ff       	call   100a45 <print_kerninfo>
    return 0;
  100e8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e8f:	83 c4 04             	add    $0x4,%esp
  100e92:	5b                   	pop    %ebx
  100e93:	5d                   	pop    %ebp
  100e94:	c3                   	ret    

00100e95 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100e95:	55                   	push   %ebp
  100e96:	89 e5                	mov    %esp,%ebp
  100e98:	53                   	push   %ebx
  100e99:	83 ec 04             	sub    $0x4,%esp
  100e9c:	e8 05 f4 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  100ea1:	05 cf 6a 01 00       	add    $0x16acf,%eax
    print_stackframe();
  100ea6:	89 c3                	mov    %eax,%ebx
  100ea8:	e8 27 fd ff ff       	call   100bd4 <print_stackframe>
    return 0;
  100ead:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100eb2:	83 c4 04             	add    $0x4,%esp
  100eb5:	5b                   	pop    %ebx
  100eb6:	5d                   	pop    %ebp
  100eb7:	c3                   	ret    

00100eb8 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100eb8:	55                   	push   %ebp
  100eb9:	89 e5                	mov    %esp,%ebp
  100ebb:	53                   	push   %ebx
  100ebc:	83 ec 14             	sub    $0x14,%esp
  100ebf:	e8 e6 f3 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  100ec4:	81 c3 ac 6a 01 00    	add    $0x16aac,%ebx
  100eca:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100ed0:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ed4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ed8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100edc:	ee                   	out    %al,(%dx)
  100edd:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100ee3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100ee7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100eeb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100eef:	ee                   	out    %al,(%dx)
  100ef0:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100ef6:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100efa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100efe:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f02:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100f03:	c7 c0 0c 8a 11 00    	mov    $0x118a0c,%eax
  100f09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("++ setup timer interrupts\n");
  100f0f:	83 ec 0c             	sub    $0xc,%esp
  100f12:	8d 83 b2 ea fe ff    	lea    -0x1154e(%ebx),%eax
  100f18:	50                   	push   %eax
  100f19:	e8 ff f3 ff ff       	call   10031d <cprintf>
  100f1e:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100f21:	83 ec 0c             	sub    $0xc,%esp
  100f24:	6a 00                	push   $0x0
  100f26:	e8 76 0a 00 00       	call   1019a1 <pic_enable>
  100f2b:	83 c4 10             	add    $0x10,%esp
}
  100f2e:	90                   	nop
  100f2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100f32:	c9                   	leave  
  100f33:	c3                   	ret    

00100f34 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100f34:	55                   	push   %ebp
  100f35:	89 e5                	mov    %esp,%ebp
  100f37:	53                   	push   %ebx
  100f38:	83 ec 14             	sub    $0x14,%esp
  100f3b:	e8 66 f3 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  100f40:	05 30 6a 01 00       	add    $0x16a30,%eax
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100f45:	9c                   	pushf  
  100f46:	5a                   	pop    %edx
  100f47:	89 55 f4             	mov    %edx,-0xc(%ebp)
    return eflags;
  100f4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    if (read_eflags() & FL_IF) {
  100f4d:	81 e2 00 02 00 00    	and    $0x200,%edx
  100f53:	85 d2                	test   %edx,%edx
  100f55:	74 0e                	je     100f65 <__intr_save+0x31>
        intr_disable();
  100f57:	89 c3                	mov    %eax,%ebx
  100f59:	e8 d5 0b 00 00       	call   101b33 <intr_disable>
        return 1;
  100f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  100f63:	eb 05                	jmp    100f6a <__intr_save+0x36>
    }
    return 0;
  100f65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100f6a:	83 c4 14             	add    $0x14,%esp
  100f6d:	5b                   	pop    %ebx
  100f6e:	5d                   	pop    %ebp
  100f6f:	c3                   	ret    

00100f70 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100f70:	55                   	push   %ebp
  100f71:	89 e5                	mov    %esp,%ebp
  100f73:	53                   	push   %ebx
  100f74:	83 ec 04             	sub    $0x4,%esp
  100f77:	e8 2a f3 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  100f7c:	05 f4 69 01 00       	add    $0x169f4,%eax
    if (flag) {
  100f81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100f85:	74 07                	je     100f8e <__intr_restore+0x1e>
        intr_enable();
  100f87:	89 c3                	mov    %eax,%ebx
  100f89:	e8 94 0b 00 00       	call   101b22 <intr_enable>
    }
}
  100f8e:	90                   	nop
  100f8f:	83 c4 04             	add    $0x4,%esp
  100f92:	5b                   	pop    %ebx
  100f93:	5d                   	pop    %ebp
  100f94:	c3                   	ret    

00100f95 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100f95:	55                   	push   %ebp
  100f96:	89 e5                	mov    %esp,%ebp
  100f98:	83 ec 10             	sub    $0x10,%esp
  100f9b:	e8 06 f3 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  100fa0:	05 d0 69 01 00       	add    $0x169d0,%eax
  100fa5:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fab:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100faf:	89 c2                	mov    %eax,%edx
  100fb1:	ec                   	in     (%dx),%al
  100fb2:	88 45 f1             	mov    %al,-0xf(%ebp)
  100fb5:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100fbb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100fbf:	89 c2                	mov    %eax,%edx
  100fc1:	ec                   	in     (%dx),%al
  100fc2:	88 45 f5             	mov    %al,-0xb(%ebp)
  100fc5:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100fcb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fcf:	89 c2                	mov    %eax,%edx
  100fd1:	ec                   	in     (%dx),%al
  100fd2:	88 45 f9             	mov    %al,-0x7(%ebp)
  100fd5:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100fdb:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100fdf:	89 c2                	mov    %eax,%edx
  100fe1:	ec                   	in     (%dx),%al
  100fe2:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100fe5:	90                   	nop
  100fe6:	c9                   	leave  
  100fe7:	c3                   	ret    

00100fe8 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100fe8:	55                   	push   %ebp
  100fe9:	89 e5                	mov    %esp,%ebp
  100feb:	83 ec 20             	sub    $0x20,%esp
  100fee:	e8 45 09 00 00       	call   101938 <__x86.get_pc_thunk.cx>
  100ff3:	81 c1 7d 69 01 00    	add    $0x1697d,%ecx
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100ff9:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  101000:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101003:	0f b7 00             	movzwl (%eax),%eax
  101006:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  10100a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10100d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  101012:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101015:	0f b7 00             	movzwl (%eax),%eax
  101018:	66 3d 5a a5          	cmp    $0xa55a,%ax
  10101c:	74 12                	je     101030 <cga_init+0x48>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  10101e:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  101025:	66 c7 81 d6 05 00 00 	movw   $0x3b4,0x5d6(%ecx)
  10102c:	b4 03 
  10102e:	eb 13                	jmp    101043 <cga_init+0x5b>
    } else {
        *cp = was;
  101030:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101033:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101037:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  10103a:	66 c7 81 d6 05 00 00 	movw   $0x3d4,0x5d6(%ecx)
  101041:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  101043:	0f b7 81 d6 05 00 00 	movzwl 0x5d6(%ecx),%eax
  10104a:	0f b7 c0             	movzwl %ax,%eax
  10104d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101051:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101055:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101059:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10105d:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  10105e:	0f b7 81 d6 05 00 00 	movzwl 0x5d6(%ecx),%eax
  101065:	83 c0 01             	add    $0x1,%eax
  101068:	0f b7 c0             	movzwl %ax,%eax
  10106b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10106f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  101073:	89 c2                	mov    %eax,%edx
  101075:	ec                   	in     (%dx),%al
  101076:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  101079:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10107d:	0f b6 c0             	movzbl %al,%eax
  101080:	c1 e0 08             	shl    $0x8,%eax
  101083:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  101086:	0f b7 81 d6 05 00 00 	movzwl 0x5d6(%ecx),%eax
  10108d:	0f b7 c0             	movzwl %ax,%eax
  101090:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101094:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101098:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10109c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010a0:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  1010a1:	0f b7 81 d6 05 00 00 	movzwl 0x5d6(%ecx),%eax
  1010a8:	83 c0 01             	add    $0x1,%eax
  1010ab:	0f b7 c0             	movzwl %ax,%eax
  1010ae:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1010b2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1010b6:	89 c2                	mov    %eax,%edx
  1010b8:	ec                   	in     (%dx),%al
  1010b9:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  1010bc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010c0:	0f b6 c0             	movzbl %al,%eax
  1010c3:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  1010c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1010c9:	89 81 d0 05 00 00    	mov    %eax,0x5d0(%ecx)
    crt_pos = pos;
  1010cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1010d2:	66 89 81 d4 05 00 00 	mov    %ax,0x5d4(%ecx)
}
  1010d9:	90                   	nop
  1010da:	c9                   	leave  
  1010db:	c3                   	ret    

001010dc <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  1010dc:	55                   	push   %ebp
  1010dd:	89 e5                	mov    %esp,%ebp
  1010df:	53                   	push   %ebx
  1010e0:	83 ec 34             	sub    $0x34,%esp
  1010e3:	e8 50 08 00 00       	call   101938 <__x86.get_pc_thunk.cx>
  1010e8:	81 c1 88 68 01 00    	add    $0x16888,%ecx
  1010ee:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  1010f4:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010f8:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1010fc:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101100:	ee                   	out    %al,(%dx)
  101101:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  101107:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  10110b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10110f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101113:	ee                   	out    %al,(%dx)
  101114:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  10111a:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  10111e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101122:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101126:	ee                   	out    %al,(%dx)
  101127:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  10112d:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  101131:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101135:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101139:	ee                   	out    %al,(%dx)
  10113a:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  101140:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  101144:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101148:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10114c:	ee                   	out    %al,(%dx)
  10114d:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101153:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  101157:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10115b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10115f:	ee                   	out    %al,(%dx)
  101160:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101166:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  10116a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10116e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101172:	ee                   	out    %al,(%dx)
  101173:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101179:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10117d:	89 c2                	mov    %eax,%edx
  10117f:	ec                   	in     (%dx),%al
  101180:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101183:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101187:	3c ff                	cmp    $0xff,%al
  101189:	0f 95 c0             	setne  %al
  10118c:	0f b6 c0             	movzbl %al,%eax
  10118f:	89 81 d8 05 00 00    	mov    %eax,0x5d8(%ecx)
  101195:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10119b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10119f:	89 c2                	mov    %eax,%edx
  1011a1:	ec                   	in     (%dx),%al
  1011a2:	88 45 f1             	mov    %al,-0xf(%ebp)
  1011a5:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1011ab:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1011af:	89 c2                	mov    %eax,%edx
  1011b1:	ec                   	in     (%dx),%al
  1011b2:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  1011b5:	8b 81 d8 05 00 00    	mov    0x5d8(%ecx),%eax
  1011bb:	85 c0                	test   %eax,%eax
  1011bd:	74 0f                	je     1011ce <serial_init+0xf2>
        pic_enable(IRQ_COM1);
  1011bf:	83 ec 0c             	sub    $0xc,%esp
  1011c2:	6a 04                	push   $0x4
  1011c4:	89 cb                	mov    %ecx,%ebx
  1011c6:	e8 d6 07 00 00       	call   1019a1 <pic_enable>
  1011cb:	83 c4 10             	add    $0x10,%esp
    }
}
  1011ce:	90                   	nop
  1011cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1011d2:	c9                   	leave  
  1011d3:	c3                   	ret    

001011d4 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1011d4:	55                   	push   %ebp
  1011d5:	89 e5                	mov    %esp,%ebp
  1011d7:	83 ec 20             	sub    $0x20,%esp
  1011da:	e8 c7 f0 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1011df:	05 91 67 01 00       	add    $0x16791,%eax
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1011e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1011eb:	eb 09                	jmp    1011f6 <lpt_putc_sub+0x22>
        delay();
  1011ed:	e8 a3 fd ff ff       	call   100f95 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1011f2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1011f6:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1011fc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101200:	89 c2                	mov    %eax,%edx
  101202:	ec                   	in     (%dx),%al
  101203:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101206:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10120a:	84 c0                	test   %al,%al
  10120c:	78 09                	js     101217 <lpt_putc_sub+0x43>
  10120e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101215:	7e d6                	jle    1011ed <lpt_putc_sub+0x19>
    }
    outb(LPTPORT + 0, c);
  101217:	8b 45 08             	mov    0x8(%ebp),%eax
  10121a:	0f b6 c0             	movzbl %al,%eax
  10121d:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101223:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101226:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10122a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10122e:	ee                   	out    %al,(%dx)
  10122f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101235:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101239:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10123d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101241:	ee                   	out    %al,(%dx)
  101242:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101248:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  10124c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101250:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101254:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101255:	90                   	nop
  101256:	c9                   	leave  
  101257:	c3                   	ret    

00101258 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101258:	55                   	push   %ebp
  101259:	89 e5                	mov    %esp,%ebp
  10125b:	e8 46 f0 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  101260:	05 10 67 01 00       	add    $0x16710,%eax
    if (c != '\b') {
  101265:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101269:	74 0d                	je     101278 <lpt_putc+0x20>
        lpt_putc_sub(c);
  10126b:	ff 75 08             	pushl  0x8(%ebp)
  10126e:	e8 61 ff ff ff       	call   1011d4 <lpt_putc_sub>
  101273:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101276:	eb 1e                	jmp    101296 <lpt_putc+0x3e>
        lpt_putc_sub('\b');
  101278:	6a 08                	push   $0x8
  10127a:	e8 55 ff ff ff       	call   1011d4 <lpt_putc_sub>
  10127f:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  101282:	6a 20                	push   $0x20
  101284:	e8 4b ff ff ff       	call   1011d4 <lpt_putc_sub>
  101289:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  10128c:	6a 08                	push   $0x8
  10128e:	e8 41 ff ff ff       	call   1011d4 <lpt_putc_sub>
  101293:	83 c4 04             	add    $0x4,%esp
}
  101296:	90                   	nop
  101297:	c9                   	leave  
  101298:	c3                   	ret    

00101299 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101299:	55                   	push   %ebp
  10129a:	89 e5                	mov    %esp,%ebp
  10129c:	56                   	push   %esi
  10129d:	53                   	push   %ebx
  10129e:	83 ec 20             	sub    $0x20,%esp
  1012a1:	e8 04 f0 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  1012a6:	81 c3 ca 66 01 00    	add    $0x166ca,%ebx
    // set black on white
    if (!(c & ~0xFF)) {
  1012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1012af:	b0 00                	mov    $0x0,%al
  1012b1:	85 c0                	test   %eax,%eax
  1012b3:	75 07                	jne    1012bc <cga_putc+0x23>
        c |= 0x0700;
  1012b5:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1012bf:	0f b6 c0             	movzbl %al,%eax
  1012c2:	83 f8 0a             	cmp    $0xa,%eax
  1012c5:	74 54                	je     10131b <cga_putc+0x82>
  1012c7:	83 f8 0d             	cmp    $0xd,%eax
  1012ca:	74 60                	je     10132c <cga_putc+0x93>
  1012cc:	83 f8 08             	cmp    $0x8,%eax
  1012cf:	0f 85 92 00 00 00    	jne    101367 <cga_putc+0xce>
    case '\b':
        if (crt_pos > 0) {
  1012d5:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
  1012dc:	66 85 c0             	test   %ax,%ax
  1012df:	0f 84 a8 00 00 00    	je     10138d <cga_putc+0xf4>
            crt_pos --;
  1012e5:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
  1012ec:	83 e8 01             	sub    $0x1,%eax
  1012ef:	66 89 83 d4 05 00 00 	mov    %ax,0x5d4(%ebx)
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1012f9:	b0 00                	mov    $0x0,%al
  1012fb:	83 c8 20             	or     $0x20,%eax
  1012fe:	89 c1                	mov    %eax,%ecx
  101300:	8b 83 d0 05 00 00    	mov    0x5d0(%ebx),%eax
  101306:	0f b7 93 d4 05 00 00 	movzwl 0x5d4(%ebx),%edx
  10130d:	0f b7 d2             	movzwl %dx,%edx
  101310:	01 d2                	add    %edx,%edx
  101312:	01 d0                	add    %edx,%eax
  101314:	89 ca                	mov    %ecx,%edx
  101316:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  101319:	eb 72                	jmp    10138d <cga_putc+0xf4>
    case '\n':
        crt_pos += CRT_COLS;
  10131b:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
  101322:	83 c0 50             	add    $0x50,%eax
  101325:	66 89 83 d4 05 00 00 	mov    %ax,0x5d4(%ebx)
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10132c:	0f b7 b3 d4 05 00 00 	movzwl 0x5d4(%ebx),%esi
  101333:	0f b7 8b d4 05 00 00 	movzwl 0x5d4(%ebx),%ecx
  10133a:	0f b7 c1             	movzwl %cx,%eax
  10133d:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101343:	c1 e8 10             	shr    $0x10,%eax
  101346:	89 c2                	mov    %eax,%edx
  101348:	66 c1 ea 06          	shr    $0x6,%dx
  10134c:	89 d0                	mov    %edx,%eax
  10134e:	c1 e0 02             	shl    $0x2,%eax
  101351:	01 d0                	add    %edx,%eax
  101353:	c1 e0 04             	shl    $0x4,%eax
  101356:	29 c1                	sub    %eax,%ecx
  101358:	89 ca                	mov    %ecx,%edx
  10135a:	89 f0                	mov    %esi,%eax
  10135c:	29 d0                	sub    %edx,%eax
  10135e:	66 89 83 d4 05 00 00 	mov    %ax,0x5d4(%ebx)
        break;
  101365:	eb 27                	jmp    10138e <cga_putc+0xf5>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101367:	8b 8b d0 05 00 00    	mov    0x5d0(%ebx),%ecx
  10136d:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
  101374:	8d 50 01             	lea    0x1(%eax),%edx
  101377:	66 89 93 d4 05 00 00 	mov    %dx,0x5d4(%ebx)
  10137e:	0f b7 c0             	movzwl %ax,%eax
  101381:	01 c0                	add    %eax,%eax
  101383:	01 c8                	add    %ecx,%eax
  101385:	8b 55 08             	mov    0x8(%ebp),%edx
  101388:	66 89 10             	mov    %dx,(%eax)
        break;
  10138b:	eb 01                	jmp    10138e <cga_putc+0xf5>
        break;
  10138d:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10138e:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
  101395:	66 3d cf 07          	cmp    $0x7cf,%ax
  101399:	76 5d                	jbe    1013f8 <cga_putc+0x15f>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10139b:	8b 83 d0 05 00 00    	mov    0x5d0(%ebx),%eax
  1013a1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1013a7:	8b 83 d0 05 00 00    	mov    0x5d0(%ebx),%eax
  1013ad:	83 ec 04             	sub    $0x4,%esp
  1013b0:	68 00 0f 00 00       	push   $0xf00
  1013b5:	52                   	push   %edx
  1013b6:	50                   	push   %eax
  1013b7:	e8 a8 45 00 00       	call   105964 <memmove>
  1013bc:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1013bf:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1013c6:	eb 16                	jmp    1013de <cga_putc+0x145>
            crt_buf[i] = 0x0700 | ' ';
  1013c8:	8b 83 d0 05 00 00    	mov    0x5d0(%ebx),%eax
  1013ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013d1:	01 d2                	add    %edx,%edx
  1013d3:	01 d0                	add    %edx,%eax
  1013d5:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1013da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1013de:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1013e5:	7e e1                	jle    1013c8 <cga_putc+0x12f>
        }
        crt_pos -= CRT_COLS;
  1013e7:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
  1013ee:	83 e8 50             	sub    $0x50,%eax
  1013f1:	66 89 83 d4 05 00 00 	mov    %ax,0x5d4(%ebx)
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1013f8:	0f b7 83 d6 05 00 00 	movzwl 0x5d6(%ebx),%eax
  1013ff:	0f b7 c0             	movzwl %ax,%eax
  101402:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101406:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  10140a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10140e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101412:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101413:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
  10141a:	66 c1 e8 08          	shr    $0x8,%ax
  10141e:	0f b6 c0             	movzbl %al,%eax
  101421:	0f b7 93 d6 05 00 00 	movzwl 0x5d6(%ebx),%edx
  101428:	83 c2 01             	add    $0x1,%edx
  10142b:	0f b7 d2             	movzwl %dx,%edx
  10142e:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101432:	88 45 e9             	mov    %al,-0x17(%ebp)
  101435:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101439:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10143d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10143e:	0f b7 83 d6 05 00 00 	movzwl 0x5d6(%ebx),%eax
  101445:	0f b7 c0             	movzwl %ax,%eax
  101448:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10144c:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  101450:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101454:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101458:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101459:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
  101460:	0f b6 c0             	movzbl %al,%eax
  101463:	0f b7 93 d6 05 00 00 	movzwl 0x5d6(%ebx),%edx
  10146a:	83 c2 01             	add    $0x1,%edx
  10146d:	0f b7 d2             	movzwl %dx,%edx
  101470:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101474:	88 45 f1             	mov    %al,-0xf(%ebp)
  101477:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10147b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10147f:	ee                   	out    %al,(%dx)
}
  101480:	90                   	nop
  101481:	8d 65 f8             	lea    -0x8(%ebp),%esp
  101484:	5b                   	pop    %ebx
  101485:	5e                   	pop    %esi
  101486:	5d                   	pop    %ebp
  101487:	c3                   	ret    

00101488 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101488:	55                   	push   %ebp
  101489:	89 e5                	mov    %esp,%ebp
  10148b:	83 ec 10             	sub    $0x10,%esp
  10148e:	e8 13 ee ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  101493:	05 dd 64 01 00       	add    $0x164dd,%eax
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101498:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10149f:	eb 09                	jmp    1014aa <serial_putc_sub+0x22>
        delay();
  1014a1:	e8 ef fa ff ff       	call   100f95 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1014a6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1014aa:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014b0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1014b4:	89 c2                	mov    %eax,%edx
  1014b6:	ec                   	in     (%dx),%al
  1014b7:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1014ba:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1014be:	0f b6 c0             	movzbl %al,%eax
  1014c1:	83 e0 20             	and    $0x20,%eax
  1014c4:	85 c0                	test   %eax,%eax
  1014c6:	75 09                	jne    1014d1 <serial_putc_sub+0x49>
  1014c8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1014cf:	7e d0                	jle    1014a1 <serial_putc_sub+0x19>
    }
    outb(COM1 + COM_TX, c);
  1014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1014d4:	0f b6 c0             	movzbl %al,%eax
  1014d7:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1014dd:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1014e0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1014e4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1014e8:	ee                   	out    %al,(%dx)
}
  1014e9:	90                   	nop
  1014ea:	c9                   	leave  
  1014eb:	c3                   	ret    

001014ec <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1014ec:	55                   	push   %ebp
  1014ed:	89 e5                	mov    %esp,%ebp
  1014ef:	e8 b2 ed ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1014f4:	05 7c 64 01 00       	add    $0x1647c,%eax
    if (c != '\b') {
  1014f9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1014fd:	74 0d                	je     10150c <serial_putc+0x20>
        serial_putc_sub(c);
  1014ff:	ff 75 08             	pushl  0x8(%ebp)
  101502:	e8 81 ff ff ff       	call   101488 <serial_putc_sub>
  101507:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  10150a:	eb 1e                	jmp    10152a <serial_putc+0x3e>
        serial_putc_sub('\b');
  10150c:	6a 08                	push   $0x8
  10150e:	e8 75 ff ff ff       	call   101488 <serial_putc_sub>
  101513:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101516:	6a 20                	push   $0x20
  101518:	e8 6b ff ff ff       	call   101488 <serial_putc_sub>
  10151d:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  101520:	6a 08                	push   $0x8
  101522:	e8 61 ff ff ff       	call   101488 <serial_putc_sub>
  101527:	83 c4 04             	add    $0x4,%esp
}
  10152a:	90                   	nop
  10152b:	c9                   	leave  
  10152c:	c3                   	ret    

0010152d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10152d:	55                   	push   %ebp
  10152e:	89 e5                	mov    %esp,%ebp
  101530:	53                   	push   %ebx
  101531:	83 ec 14             	sub    $0x14,%esp
  101534:	e8 71 ed ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  101539:	81 c3 37 64 01 00    	add    $0x16437,%ebx
    int c;
    while ((c = (*proc)()) != -1) {
  10153f:	eb 36                	jmp    101577 <cons_intr+0x4a>
        if (c != 0) {
  101541:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101545:	74 30                	je     101577 <cons_intr+0x4a>
            cons.buf[cons.wpos ++] = c;
  101547:	8b 83 f4 07 00 00    	mov    0x7f4(%ebx),%eax
  10154d:	8d 50 01             	lea    0x1(%eax),%edx
  101550:	89 93 f4 07 00 00    	mov    %edx,0x7f4(%ebx)
  101556:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101559:	88 94 03 f0 05 00 00 	mov    %dl,0x5f0(%ebx,%eax,1)
            if (cons.wpos == CONSBUFSIZE) {
  101560:	8b 83 f4 07 00 00    	mov    0x7f4(%ebx),%eax
  101566:	3d 00 02 00 00       	cmp    $0x200,%eax
  10156b:	75 0a                	jne    101577 <cons_intr+0x4a>
                cons.wpos = 0;
  10156d:	c7 83 f4 07 00 00 00 	movl   $0x0,0x7f4(%ebx)
  101574:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101577:	8b 45 08             	mov    0x8(%ebp),%eax
  10157a:	ff d0                	call   *%eax
  10157c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10157f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101583:	75 bc                	jne    101541 <cons_intr+0x14>
            }
        }
    }
}
  101585:	90                   	nop
  101586:	83 c4 14             	add    $0x14,%esp
  101589:	5b                   	pop    %ebx
  10158a:	5d                   	pop    %ebp
  10158b:	c3                   	ret    

0010158c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10158c:	55                   	push   %ebp
  10158d:	89 e5                	mov    %esp,%ebp
  10158f:	83 ec 10             	sub    $0x10,%esp
  101592:	e8 0f ed ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  101597:	05 d9 63 01 00       	add    $0x163d9,%eax
  10159c:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1015a2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1015a6:	89 c2                	mov    %eax,%edx
  1015a8:	ec                   	in     (%dx),%al
  1015a9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1015ac:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1015b0:	0f b6 c0             	movzbl %al,%eax
  1015b3:	83 e0 01             	and    $0x1,%eax
  1015b6:	85 c0                	test   %eax,%eax
  1015b8:	75 07                	jne    1015c1 <serial_proc_data+0x35>
        return -1;
  1015ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1015bf:	eb 2a                	jmp    1015eb <serial_proc_data+0x5f>
  1015c1:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1015c7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1015cb:	89 c2                	mov    %eax,%edx
  1015cd:	ec                   	in     (%dx),%al
  1015ce:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1015d1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1015d5:	0f b6 c0             	movzbl %al,%eax
  1015d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1015db:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1015df:	75 07                	jne    1015e8 <serial_proc_data+0x5c>
        c = '\b';
  1015e1:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1015e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1015eb:	c9                   	leave  
  1015ec:	c3                   	ret    

001015ed <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1015ed:	55                   	push   %ebp
  1015ee:	89 e5                	mov    %esp,%ebp
  1015f0:	83 ec 08             	sub    $0x8,%esp
  1015f3:	e8 ae ec ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1015f8:	05 78 63 01 00       	add    $0x16378,%eax
    if (serial_exists) {
  1015fd:	8b 90 d8 05 00 00    	mov    0x5d8(%eax),%edx
  101603:	85 d2                	test   %edx,%edx
  101605:	74 12                	je     101619 <serial_intr+0x2c>
        cons_intr(serial_proc_data);
  101607:	83 ec 0c             	sub    $0xc,%esp
  10160a:	8d 80 1c 9c fe ff    	lea    -0x163e4(%eax),%eax
  101610:	50                   	push   %eax
  101611:	e8 17 ff ff ff       	call   10152d <cons_intr>
  101616:	83 c4 10             	add    $0x10,%esp
    }
}
  101619:	90                   	nop
  10161a:	c9                   	leave  
  10161b:	c3                   	ret    

0010161c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10161c:	55                   	push   %ebp
  10161d:	89 e5                	mov    %esp,%ebp
  10161f:	53                   	push   %ebx
  101620:	83 ec 24             	sub    $0x24,%esp
  101623:	e8 10 03 00 00       	call   101938 <__x86.get_pc_thunk.cx>
  101628:	81 c1 48 63 01 00    	add    $0x16348,%ecx
  10162e:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101634:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101638:	89 c2                	mov    %eax,%edx
  10163a:	ec                   	in     (%dx),%al
  10163b:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10163e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101642:	0f b6 c0             	movzbl %al,%eax
  101645:	83 e0 01             	and    $0x1,%eax
  101648:	85 c0                	test   %eax,%eax
  10164a:	75 0a                	jne    101656 <kbd_proc_data+0x3a>
        return -1;
  10164c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101651:	e9 73 01 00 00       	jmp    1017c9 <kbd_proc_data+0x1ad>
  101656:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10165c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101660:	89 c2                	mov    %eax,%edx
  101662:	ec                   	in     (%dx),%al
  101663:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101666:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10166a:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10166d:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101671:	75 19                	jne    10168c <kbd_proc_data+0x70>
        // E0 escape character
        shift |= E0ESC;
  101673:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
  101679:	83 c8 40             	or     $0x40,%eax
  10167c:	89 81 f8 07 00 00    	mov    %eax,0x7f8(%ecx)
        return 0;
  101682:	b8 00 00 00 00       	mov    $0x0,%eax
  101687:	e9 3d 01 00 00       	jmp    1017c9 <kbd_proc_data+0x1ad>
    } else if (data & 0x80) {
  10168c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101690:	84 c0                	test   %al,%al
  101692:	79 4b                	jns    1016df <kbd_proc_data+0xc3>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101694:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
  10169a:	83 e0 40             	and    $0x40,%eax
  10169d:	85 c0                	test   %eax,%eax
  10169f:	75 09                	jne    1016aa <kbd_proc_data+0x8e>
  1016a1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1016a5:	83 e0 7f             	and    $0x7f,%eax
  1016a8:	eb 04                	jmp    1016ae <kbd_proc_data+0x92>
  1016aa:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1016ae:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1016b1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1016b5:	0f b6 84 01 b0 f6 ff 	movzbl -0x950(%ecx,%eax,1),%eax
  1016bc:	ff 
  1016bd:	83 c8 40             	or     $0x40,%eax
  1016c0:	0f b6 c0             	movzbl %al,%eax
  1016c3:	f7 d0                	not    %eax
  1016c5:	89 c2                	mov    %eax,%edx
  1016c7:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
  1016cd:	21 d0                	and    %edx,%eax
  1016cf:	89 81 f8 07 00 00    	mov    %eax,0x7f8(%ecx)
        return 0;
  1016d5:	b8 00 00 00 00       	mov    $0x0,%eax
  1016da:	e9 ea 00 00 00       	jmp    1017c9 <kbd_proc_data+0x1ad>
    } else if (shift & E0ESC) {
  1016df:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
  1016e5:	83 e0 40             	and    $0x40,%eax
  1016e8:	85 c0                	test   %eax,%eax
  1016ea:	74 13                	je     1016ff <kbd_proc_data+0xe3>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1016ec:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1016f0:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
  1016f6:	83 e0 bf             	and    $0xffffffbf,%eax
  1016f9:	89 81 f8 07 00 00    	mov    %eax,0x7f8(%ecx)
    }

    shift |= shiftcode[data];
  1016ff:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101703:	0f b6 84 01 b0 f6 ff 	movzbl -0x950(%ecx,%eax,1),%eax
  10170a:	ff 
  10170b:	0f b6 d0             	movzbl %al,%edx
  10170e:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
  101714:	09 d0                	or     %edx,%eax
  101716:	89 81 f8 07 00 00    	mov    %eax,0x7f8(%ecx)
    shift ^= togglecode[data];
  10171c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101720:	0f b6 84 01 b0 f7 ff 	movzbl -0x850(%ecx,%eax,1),%eax
  101727:	ff 
  101728:	0f b6 d0             	movzbl %al,%edx
  10172b:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
  101731:	31 d0                	xor    %edx,%eax
  101733:	89 81 f8 07 00 00    	mov    %eax,0x7f8(%ecx)

    c = charcode[shift & (CTL | SHIFT)][data];
  101739:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
  10173f:	83 e0 03             	and    $0x3,%eax
  101742:	8b 94 81 34 00 00 00 	mov    0x34(%ecx,%eax,4),%edx
  101749:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10174d:	01 d0                	add    %edx,%eax
  10174f:	0f b6 00             	movzbl (%eax),%eax
  101752:	0f b6 c0             	movzbl %al,%eax
  101755:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101758:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
  10175e:	83 e0 08             	and    $0x8,%eax
  101761:	85 c0                	test   %eax,%eax
  101763:	74 22                	je     101787 <kbd_proc_data+0x16b>
        if ('a' <= c && c <= 'z')
  101765:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101769:	7e 0c                	jle    101777 <kbd_proc_data+0x15b>
  10176b:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10176f:	7f 06                	jg     101777 <kbd_proc_data+0x15b>
            c += 'A' - 'a';
  101771:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101775:	eb 10                	jmp    101787 <kbd_proc_data+0x16b>
        else if ('A' <= c && c <= 'Z')
  101777:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10177b:	7e 0a                	jle    101787 <kbd_proc_data+0x16b>
  10177d:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101781:	7f 04                	jg     101787 <kbd_proc_data+0x16b>
            c += 'a' - 'A';
  101783:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101787:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
  10178d:	f7 d0                	not    %eax
  10178f:	83 e0 06             	and    $0x6,%eax
  101792:	85 c0                	test   %eax,%eax
  101794:	75 30                	jne    1017c6 <kbd_proc_data+0x1aa>
  101796:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10179d:	75 27                	jne    1017c6 <kbd_proc_data+0x1aa>
        cprintf("Rebooting!\n");
  10179f:	83 ec 0c             	sub    $0xc,%esp
  1017a2:	8d 81 cd ea fe ff    	lea    -0x11533(%ecx),%eax
  1017a8:	50                   	push   %eax
  1017a9:	89 cb                	mov    %ecx,%ebx
  1017ab:	e8 6d eb ff ff       	call   10031d <cprintf>
  1017b0:	83 c4 10             	add    $0x10,%esp
  1017b3:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1017b9:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017bd:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1017c1:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1017c5:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1017c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1017c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1017cc:	c9                   	leave  
  1017cd:	c3                   	ret    

001017ce <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1017ce:	55                   	push   %ebp
  1017cf:	89 e5                	mov    %esp,%ebp
  1017d1:	83 ec 08             	sub    $0x8,%esp
  1017d4:	e8 cd ea ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1017d9:	05 97 61 01 00       	add    $0x16197,%eax
    cons_intr(kbd_proc_data);
  1017de:	83 ec 0c             	sub    $0xc,%esp
  1017e1:	8d 80 ac 9c fe ff    	lea    -0x16354(%eax),%eax
  1017e7:	50                   	push   %eax
  1017e8:	e8 40 fd ff ff       	call   10152d <cons_intr>
  1017ed:	83 c4 10             	add    $0x10,%esp
}
  1017f0:	90                   	nop
  1017f1:	c9                   	leave  
  1017f2:	c3                   	ret    

001017f3 <kbd_init>:

static void
kbd_init(void) {
  1017f3:	55                   	push   %ebp
  1017f4:	89 e5                	mov    %esp,%ebp
  1017f6:	53                   	push   %ebx
  1017f7:	83 ec 04             	sub    $0x4,%esp
  1017fa:	e8 ab ea ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  1017ff:	81 c3 71 61 01 00    	add    $0x16171,%ebx
    // drain the kbd buffer
    kbd_intr();
  101805:	e8 c4 ff ff ff       	call   1017ce <kbd_intr>
    pic_enable(IRQ_KBD);
  10180a:	83 ec 0c             	sub    $0xc,%esp
  10180d:	6a 01                	push   $0x1
  10180f:	e8 8d 01 00 00       	call   1019a1 <pic_enable>
  101814:	83 c4 10             	add    $0x10,%esp
}
  101817:	90                   	nop
  101818:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10181b:	c9                   	leave  
  10181c:	c3                   	ret    

0010181d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10181d:	55                   	push   %ebp
  10181e:	89 e5                	mov    %esp,%ebp
  101820:	53                   	push   %ebx
  101821:	83 ec 04             	sub    $0x4,%esp
  101824:	e8 81 ea ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  101829:	81 c3 47 61 01 00    	add    $0x16147,%ebx
    cga_init();
  10182f:	e8 b4 f7 ff ff       	call   100fe8 <cga_init>
    serial_init();
  101834:	e8 a3 f8 ff ff       	call   1010dc <serial_init>
    kbd_init();
  101839:	e8 b5 ff ff ff       	call   1017f3 <kbd_init>
    if (!serial_exists) {
  10183e:	8b 83 d8 05 00 00    	mov    0x5d8(%ebx),%eax
  101844:	85 c0                	test   %eax,%eax
  101846:	75 12                	jne    10185a <cons_init+0x3d>
        cprintf("serial port does not exist!!\n");
  101848:	83 ec 0c             	sub    $0xc,%esp
  10184b:	8d 83 d9 ea fe ff    	lea    -0x11527(%ebx),%eax
  101851:	50                   	push   %eax
  101852:	e8 c6 ea ff ff       	call   10031d <cprintf>
  101857:	83 c4 10             	add    $0x10,%esp
    }
}
  10185a:	90                   	nop
  10185b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10185e:	c9                   	leave  
  10185f:	c3                   	ret    

00101860 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101860:	55                   	push   %ebp
  101861:	89 e5                	mov    %esp,%ebp
  101863:	83 ec 18             	sub    $0x18,%esp
  101866:	e8 3b ea ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  10186b:	05 05 61 01 00       	add    $0x16105,%eax
    bool intr_flag;
    local_intr_save(intr_flag);
  101870:	e8 bf f6 ff ff       	call   100f34 <__intr_save>
  101875:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101878:	83 ec 0c             	sub    $0xc,%esp
  10187b:	ff 75 08             	pushl  0x8(%ebp)
  10187e:	e8 d5 f9 ff ff       	call   101258 <lpt_putc>
  101883:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
  101886:	83 ec 0c             	sub    $0xc,%esp
  101889:	ff 75 08             	pushl  0x8(%ebp)
  10188c:	e8 08 fa ff ff       	call   101299 <cga_putc>
  101891:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
  101894:	83 ec 0c             	sub    $0xc,%esp
  101897:	ff 75 08             	pushl  0x8(%ebp)
  10189a:	e8 4d fc ff ff       	call   1014ec <serial_putc>
  10189f:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  1018a2:	83 ec 0c             	sub    $0xc,%esp
  1018a5:	ff 75 f4             	pushl  -0xc(%ebp)
  1018a8:	e8 c3 f6 ff ff       	call   100f70 <__intr_restore>
  1018ad:	83 c4 10             	add    $0x10,%esp
}
  1018b0:	90                   	nop
  1018b1:	c9                   	leave  
  1018b2:	c3                   	ret    

001018b3 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1018b3:	55                   	push   %ebp
  1018b4:	89 e5                	mov    %esp,%ebp
  1018b6:	53                   	push   %ebx
  1018b7:	83 ec 14             	sub    $0x14,%esp
  1018ba:	e8 eb e9 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  1018bf:	81 c3 b1 60 01 00    	add    $0x160b1,%ebx
    int c = 0;
  1018c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1018cc:	e8 63 f6 ff ff       	call   100f34 <__intr_save>
  1018d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  1018d4:	e8 14 fd ff ff       	call   1015ed <serial_intr>
        kbd_intr();
  1018d9:	e8 f0 fe ff ff       	call   1017ce <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  1018de:	8b 93 f0 07 00 00    	mov    0x7f0(%ebx),%edx
  1018e4:	8b 83 f4 07 00 00    	mov    0x7f4(%ebx),%eax
  1018ea:	39 c2                	cmp    %eax,%edx
  1018ec:	74 34                	je     101922 <cons_getc+0x6f>
            c = cons.buf[cons.rpos ++];
  1018ee:	8b 83 f0 07 00 00    	mov    0x7f0(%ebx),%eax
  1018f4:	8d 50 01             	lea    0x1(%eax),%edx
  1018f7:	89 93 f0 07 00 00    	mov    %edx,0x7f0(%ebx)
  1018fd:	0f b6 84 03 f0 05 00 	movzbl 0x5f0(%ebx,%eax,1),%eax
  101904:	00 
  101905:	0f b6 c0             	movzbl %al,%eax
  101908:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10190b:	8b 83 f0 07 00 00    	mov    0x7f0(%ebx),%eax
  101911:	3d 00 02 00 00       	cmp    $0x200,%eax
  101916:	75 0a                	jne    101922 <cons_getc+0x6f>
                cons.rpos = 0;
  101918:	c7 83 f0 07 00 00 00 	movl   $0x0,0x7f0(%ebx)
  10191f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101922:	83 ec 0c             	sub    $0xc,%esp
  101925:	ff 75 f0             	pushl  -0x10(%ebp)
  101928:	e8 43 f6 ff ff       	call   100f70 <__intr_restore>
  10192d:	83 c4 10             	add    $0x10,%esp
    return c;
  101930:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101933:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101936:	c9                   	leave  
  101937:	c3                   	ret    

00101938 <__x86.get_pc_thunk.cx>:
  101938:	8b 0c 24             	mov    (%esp),%ecx
  10193b:	c3                   	ret    

0010193c <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10193c:	55                   	push   %ebp
  10193d:	89 e5                	mov    %esp,%ebp
  10193f:	83 ec 14             	sub    $0x14,%esp
  101942:	e8 5f e9 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  101947:	05 29 60 01 00       	add    $0x16029,%eax
  10194c:	8b 55 08             	mov    0x8(%ebp),%edx
  10194f:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
    irq_mask = mask;
  101953:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101957:	66 89 90 b0 fb ff ff 	mov    %dx,-0x450(%eax)
    if (did_init) {
  10195e:	8b 80 fc 07 00 00    	mov    0x7fc(%eax),%eax
  101964:	85 c0                	test   %eax,%eax
  101966:	74 36                	je     10199e <pic_setmask+0x62>
        outb(IO_PIC1 + 1, mask);
  101968:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10196c:	0f b6 c0             	movzbl %al,%eax
  10196f:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101975:	88 45 f9             	mov    %al,-0x7(%ebp)
  101978:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10197c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101980:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101981:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101985:	66 c1 e8 08          	shr    $0x8,%ax
  101989:	0f b6 c0             	movzbl %al,%eax
  10198c:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101992:	88 45 fd             	mov    %al,-0x3(%ebp)
  101995:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101999:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10199d:	ee                   	out    %al,(%dx)
    }
}
  10199e:	90                   	nop
  10199f:	c9                   	leave  
  1019a0:	c3                   	ret    

001019a1 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1019a1:	55                   	push   %ebp
  1019a2:	89 e5                	mov    %esp,%ebp
  1019a4:	53                   	push   %ebx
  1019a5:	e8 fc e8 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1019aa:	05 c6 5f 01 00       	add    $0x15fc6,%eax
    pic_setmask(irq_mask & ~(1 << irq));
  1019af:	8b 55 08             	mov    0x8(%ebp),%edx
  1019b2:	bb 01 00 00 00       	mov    $0x1,%ebx
  1019b7:	89 d1                	mov    %edx,%ecx
  1019b9:	d3 e3                	shl    %cl,%ebx
  1019bb:	89 da                	mov    %ebx,%edx
  1019bd:	f7 d2                	not    %edx
  1019bf:	0f b7 80 b0 fb ff ff 	movzwl -0x450(%eax),%eax
  1019c6:	21 d0                	and    %edx,%eax
  1019c8:	0f b7 c0             	movzwl %ax,%eax
  1019cb:	50                   	push   %eax
  1019cc:	e8 6b ff ff ff       	call   10193c <pic_setmask>
  1019d1:	83 c4 04             	add    $0x4,%esp
}
  1019d4:	90                   	nop
  1019d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1019d8:	c9                   	leave  
  1019d9:	c3                   	ret    

001019da <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1019da:	55                   	push   %ebp
  1019db:	89 e5                	mov    %esp,%ebp
  1019dd:	83 ec 40             	sub    $0x40,%esp
  1019e0:	e8 53 ff ff ff       	call   101938 <__x86.get_pc_thunk.cx>
  1019e5:	81 c1 8b 5f 01 00    	add    $0x15f8b,%ecx
    did_init = 1;
  1019eb:	c7 81 fc 07 00 00 01 	movl   $0x1,0x7fc(%ecx)
  1019f2:	00 00 00 
  1019f5:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1019fb:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  1019ff:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101a03:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101a07:	ee                   	out    %al,(%dx)
  101a08:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101a0e:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  101a12:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101a16:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101a1a:	ee                   	out    %al,(%dx)
  101a1b:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101a21:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  101a25:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101a29:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101a2d:	ee                   	out    %al,(%dx)
  101a2e:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101a34:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101a38:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101a3c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101a40:	ee                   	out    %al,(%dx)
  101a41:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101a47:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101a4b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101a4f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101a53:	ee                   	out    %al,(%dx)
  101a54:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101a5a:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  101a5e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101a62:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101a66:	ee                   	out    %al,(%dx)
  101a67:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101a6d:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  101a71:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101a75:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101a79:	ee                   	out    %al,(%dx)
  101a7a:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101a80:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  101a84:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101a88:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101a8c:	ee                   	out    %al,(%dx)
  101a8d:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101a93:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101a97:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101a9b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101a9f:	ee                   	out    %al,(%dx)
  101aa0:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101aa6:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101aaa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101aae:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101ab2:	ee                   	out    %al,(%dx)
  101ab3:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101ab9:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  101abd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101ac1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101ac5:	ee                   	out    %al,(%dx)
  101ac6:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101acc:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  101ad0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101ad4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101ad8:	ee                   	out    %al,(%dx)
  101ad9:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101adf:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  101ae3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101ae7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101aeb:	ee                   	out    %al,(%dx)
  101aec:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101af2:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  101af6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101afa:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101afe:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101aff:	0f b7 81 b0 fb ff ff 	movzwl -0x450(%ecx),%eax
  101b06:	66 83 f8 ff          	cmp    $0xffff,%ax
  101b0a:	74 13                	je     101b1f <pic_init+0x145>
        pic_setmask(irq_mask);
  101b0c:	0f b7 81 b0 fb ff ff 	movzwl -0x450(%ecx),%eax
  101b13:	0f b7 c0             	movzwl %ax,%eax
  101b16:	50                   	push   %eax
  101b17:	e8 20 fe ff ff       	call   10193c <pic_setmask>
  101b1c:	83 c4 04             	add    $0x4,%esp
    }
}
  101b1f:	90                   	nop
  101b20:	c9                   	leave  
  101b21:	c3                   	ret    

00101b22 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101b22:	55                   	push   %ebp
  101b23:	89 e5                	mov    %esp,%ebp
  101b25:	e8 7c e7 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  101b2a:	05 46 5e 01 00       	add    $0x15e46,%eax
    asm volatile ("sti");
  101b2f:	fb                   	sti    
    sti();
}
  101b30:	90                   	nop
  101b31:	5d                   	pop    %ebp
  101b32:	c3                   	ret    

00101b33 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101b33:	55                   	push   %ebp
  101b34:	89 e5                	mov    %esp,%ebp
  101b36:	e8 6b e7 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  101b3b:	05 35 5e 01 00       	add    $0x15e35,%eax
    asm volatile ("cli" ::: "memory");
  101b40:	fa                   	cli    
    cli();
}
  101b41:	90                   	nop
  101b42:	5d                   	pop    %ebp
  101b43:	c3                   	ret    

00101b44 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101b44:	55                   	push   %ebp
  101b45:	89 e5                	mov    %esp,%ebp
  101b47:	53                   	push   %ebx
  101b48:	83 ec 04             	sub    $0x4,%esp
  101b4b:	e8 56 e7 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  101b50:	05 20 5e 01 00       	add    $0x15e20,%eax
    cprintf("%d ticks\n",TICK_NUM);
  101b55:	83 ec 08             	sub    $0x8,%esp
  101b58:	6a 64                	push   $0x64
  101b5a:	8d 90 f7 ea fe ff    	lea    -0x11509(%eax),%edx
  101b60:	52                   	push   %edx
  101b61:	89 c3                	mov    %eax,%ebx
  101b63:	e8 b5 e7 ff ff       	call   10031d <cprintf>
  101b68:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101b6b:	90                   	nop
  101b6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101b6f:	c9                   	leave  
  101b70:	c3                   	ret    

00101b71 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101b71:	55                   	push   %ebp
  101b72:	89 e5                	mov    %esp,%ebp
  101b74:	e8 2d e7 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  101b79:	05 f7 5d 01 00       	add    $0x15df7,%eax
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  101b7e:	90                   	nop
  101b7f:	5d                   	pop    %ebp
  101b80:	c3                   	ret    

00101b81 <trapname>:

static const char *
trapname(int trapno) {
  101b81:	55                   	push   %ebp
  101b82:	89 e5                	mov    %esp,%ebp
  101b84:	e8 1d e7 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  101b89:	05 e7 5d 01 00       	add    $0x15de7,%eax
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b8e:	8b 55 08             	mov    0x8(%ebp),%edx
  101b91:	83 fa 13             	cmp    $0x13,%edx
  101b94:	77 0c                	ja     101ba2 <trapname+0x21>
        return excnames[trapno];
  101b96:	8b 55 08             	mov    0x8(%ebp),%edx
  101b99:	8b 84 90 f0 00 00 00 	mov    0xf0(%eax,%edx,4),%eax
  101ba0:	eb 1a                	jmp    101bbc <trapname+0x3b>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101ba2:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101ba6:	7e 0e                	jle    101bb6 <trapname+0x35>
  101ba8:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101bac:	7f 08                	jg     101bb6 <trapname+0x35>
        return "Hardware Interrupt";
  101bae:	8d 80 01 eb fe ff    	lea    -0x114ff(%eax),%eax
  101bb4:	eb 06                	jmp    101bbc <trapname+0x3b>
    }
    return "(unknown trap)";
  101bb6:	8d 80 14 eb fe ff    	lea    -0x114ec(%eax),%eax
}
  101bbc:	5d                   	pop    %ebp
  101bbd:	c3                   	ret    

00101bbe <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101bbe:	55                   	push   %ebp
  101bbf:	89 e5                	mov    %esp,%ebp
  101bc1:	e8 e0 e6 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  101bc6:	05 aa 5d 01 00       	add    $0x15daa,%eax
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bce:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bd2:	66 83 f8 08          	cmp    $0x8,%ax
  101bd6:	0f 94 c0             	sete   %al
  101bd9:	0f b6 c0             	movzbl %al,%eax
}
  101bdc:	5d                   	pop    %ebp
  101bdd:	c3                   	ret    

00101bde <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101bde:	55                   	push   %ebp
  101bdf:	89 e5                	mov    %esp,%ebp
  101be1:	53                   	push   %ebx
  101be2:	83 ec 14             	sub    $0x14,%esp
  101be5:	e8 c0 e6 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  101bea:	81 c3 86 5d 01 00    	add    $0x15d86,%ebx
    cprintf("trapframe at %p\n", tf);
  101bf0:	83 ec 08             	sub    $0x8,%esp
  101bf3:	ff 75 08             	pushl  0x8(%ebp)
  101bf6:	8d 83 55 eb fe ff    	lea    -0x114ab(%ebx),%eax
  101bfc:	50                   	push   %eax
  101bfd:	e8 1b e7 ff ff       	call   10031d <cprintf>
  101c02:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101c05:	8b 45 08             	mov    0x8(%ebp),%eax
  101c08:	83 ec 0c             	sub    $0xc,%esp
  101c0b:	50                   	push   %eax
  101c0c:	e8 d3 01 00 00       	call   101de4 <print_regs>
  101c11:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101c14:	8b 45 08             	mov    0x8(%ebp),%eax
  101c17:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101c1b:	0f b7 c0             	movzwl %ax,%eax
  101c1e:	83 ec 08             	sub    $0x8,%esp
  101c21:	50                   	push   %eax
  101c22:	8d 83 66 eb fe ff    	lea    -0x1149a(%ebx),%eax
  101c28:	50                   	push   %eax
  101c29:	e8 ef e6 ff ff       	call   10031d <cprintf>
  101c2e:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101c31:	8b 45 08             	mov    0x8(%ebp),%eax
  101c34:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101c38:	0f b7 c0             	movzwl %ax,%eax
  101c3b:	83 ec 08             	sub    $0x8,%esp
  101c3e:	50                   	push   %eax
  101c3f:	8d 83 79 eb fe ff    	lea    -0x11487(%ebx),%eax
  101c45:	50                   	push   %eax
  101c46:	e8 d2 e6 ff ff       	call   10031d <cprintf>
  101c4b:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c51:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101c55:	0f b7 c0             	movzwl %ax,%eax
  101c58:	83 ec 08             	sub    $0x8,%esp
  101c5b:	50                   	push   %eax
  101c5c:	8d 83 8c eb fe ff    	lea    -0x11474(%ebx),%eax
  101c62:	50                   	push   %eax
  101c63:	e8 b5 e6 ff ff       	call   10031d <cprintf>
  101c68:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6e:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c72:	0f b7 c0             	movzwl %ax,%eax
  101c75:	83 ec 08             	sub    $0x8,%esp
  101c78:	50                   	push   %eax
  101c79:	8d 83 9f eb fe ff    	lea    -0x11461(%ebx),%eax
  101c7f:	50                   	push   %eax
  101c80:	e8 98 e6 ff ff       	call   10031d <cprintf>
  101c85:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c88:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8b:	8b 40 30             	mov    0x30(%eax),%eax
  101c8e:	83 ec 0c             	sub    $0xc,%esp
  101c91:	50                   	push   %eax
  101c92:	e8 ea fe ff ff       	call   101b81 <trapname>
  101c97:	83 c4 10             	add    $0x10,%esp
  101c9a:	89 c2                	mov    %eax,%edx
  101c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9f:	8b 40 30             	mov    0x30(%eax),%eax
  101ca2:	83 ec 04             	sub    $0x4,%esp
  101ca5:	52                   	push   %edx
  101ca6:	50                   	push   %eax
  101ca7:	8d 83 b2 eb fe ff    	lea    -0x1144e(%ebx),%eax
  101cad:	50                   	push   %eax
  101cae:	e8 6a e6 ff ff       	call   10031d <cprintf>
  101cb3:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb9:	8b 40 34             	mov    0x34(%eax),%eax
  101cbc:	83 ec 08             	sub    $0x8,%esp
  101cbf:	50                   	push   %eax
  101cc0:	8d 83 c4 eb fe ff    	lea    -0x1143c(%ebx),%eax
  101cc6:	50                   	push   %eax
  101cc7:	e8 51 e6 ff ff       	call   10031d <cprintf>
  101ccc:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd2:	8b 40 38             	mov    0x38(%eax),%eax
  101cd5:	83 ec 08             	sub    $0x8,%esp
  101cd8:	50                   	push   %eax
  101cd9:	8d 83 d3 eb fe ff    	lea    -0x1142d(%ebx),%eax
  101cdf:	50                   	push   %eax
  101ce0:	e8 38 e6 ff ff       	call   10031d <cprintf>
  101ce5:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  101ceb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101cef:	0f b7 c0             	movzwl %ax,%eax
  101cf2:	83 ec 08             	sub    $0x8,%esp
  101cf5:	50                   	push   %eax
  101cf6:	8d 83 e2 eb fe ff    	lea    -0x1141e(%ebx),%eax
  101cfc:	50                   	push   %eax
  101cfd:	e8 1b e6 ff ff       	call   10031d <cprintf>
  101d02:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101d05:	8b 45 08             	mov    0x8(%ebp),%eax
  101d08:	8b 40 40             	mov    0x40(%eax),%eax
  101d0b:	83 ec 08             	sub    $0x8,%esp
  101d0e:	50                   	push   %eax
  101d0f:	8d 83 f5 eb fe ff    	lea    -0x1140b(%ebx),%eax
  101d15:	50                   	push   %eax
  101d16:	e8 02 e6 ff ff       	call   10031d <cprintf>
  101d1b:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101d1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101d25:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101d2c:	eb 41                	jmp    101d6f <print_trapframe+0x191>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d31:	8b 50 40             	mov    0x40(%eax),%edx
  101d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101d37:	21 d0                	and    %edx,%eax
  101d39:	85 c0                	test   %eax,%eax
  101d3b:	74 2b                	je     101d68 <print_trapframe+0x18a>
  101d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d40:	8b 84 83 70 00 00 00 	mov    0x70(%ebx,%eax,4),%eax
  101d47:	85 c0                	test   %eax,%eax
  101d49:	74 1d                	je     101d68 <print_trapframe+0x18a>
            cprintf("%s,", IA32flags[i]);
  101d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d4e:	8b 84 83 70 00 00 00 	mov    0x70(%ebx,%eax,4),%eax
  101d55:	83 ec 08             	sub    $0x8,%esp
  101d58:	50                   	push   %eax
  101d59:	8d 83 04 ec fe ff    	lea    -0x113fc(%ebx),%eax
  101d5f:	50                   	push   %eax
  101d60:	e8 b8 e5 ff ff       	call   10031d <cprintf>
  101d65:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101d68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101d6c:	d1 65 f0             	shll   -0x10(%ebp)
  101d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d72:	83 f8 17             	cmp    $0x17,%eax
  101d75:	76 b7                	jbe    101d2e <print_trapframe+0x150>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101d77:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7a:	8b 40 40             	mov    0x40(%eax),%eax
  101d7d:	c1 e8 0c             	shr    $0xc,%eax
  101d80:	83 e0 03             	and    $0x3,%eax
  101d83:	83 ec 08             	sub    $0x8,%esp
  101d86:	50                   	push   %eax
  101d87:	8d 83 08 ec fe ff    	lea    -0x113f8(%ebx),%eax
  101d8d:	50                   	push   %eax
  101d8e:	e8 8a e5 ff ff       	call   10031d <cprintf>
  101d93:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101d96:	83 ec 0c             	sub    $0xc,%esp
  101d99:	ff 75 08             	pushl  0x8(%ebp)
  101d9c:	e8 1d fe ff ff       	call   101bbe <trap_in_kernel>
  101da1:	83 c4 10             	add    $0x10,%esp
  101da4:	85 c0                	test   %eax,%eax
  101da6:	75 36                	jne    101dde <print_trapframe+0x200>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101da8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dab:	8b 40 44             	mov    0x44(%eax),%eax
  101dae:	83 ec 08             	sub    $0x8,%esp
  101db1:	50                   	push   %eax
  101db2:	8d 83 11 ec fe ff    	lea    -0x113ef(%ebx),%eax
  101db8:	50                   	push   %eax
  101db9:	e8 5f e5 ff ff       	call   10031d <cprintf>
  101dbe:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc4:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101dc8:	0f b7 c0             	movzwl %ax,%eax
  101dcb:	83 ec 08             	sub    $0x8,%esp
  101dce:	50                   	push   %eax
  101dcf:	8d 83 20 ec fe ff    	lea    -0x113e0(%ebx),%eax
  101dd5:	50                   	push   %eax
  101dd6:	e8 42 e5 ff ff       	call   10031d <cprintf>
  101ddb:	83 c4 10             	add    $0x10,%esp
    }
}
  101dde:	90                   	nop
  101ddf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101de2:	c9                   	leave  
  101de3:	c3                   	ret    

00101de4 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101de4:	55                   	push   %ebp
  101de5:	89 e5                	mov    %esp,%ebp
  101de7:	53                   	push   %ebx
  101de8:	83 ec 04             	sub    $0x4,%esp
  101deb:	e8 ba e4 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  101df0:	81 c3 80 5b 01 00    	add    $0x15b80,%ebx
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101df6:	8b 45 08             	mov    0x8(%ebp),%eax
  101df9:	8b 00                	mov    (%eax),%eax
  101dfb:	83 ec 08             	sub    $0x8,%esp
  101dfe:	50                   	push   %eax
  101dff:	8d 83 33 ec fe ff    	lea    -0x113cd(%ebx),%eax
  101e05:	50                   	push   %eax
  101e06:	e8 12 e5 ff ff       	call   10031d <cprintf>
  101e0b:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e11:	8b 40 04             	mov    0x4(%eax),%eax
  101e14:	83 ec 08             	sub    $0x8,%esp
  101e17:	50                   	push   %eax
  101e18:	8d 83 42 ec fe ff    	lea    -0x113be(%ebx),%eax
  101e1e:	50                   	push   %eax
  101e1f:	e8 f9 e4 ff ff       	call   10031d <cprintf>
  101e24:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101e27:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2a:	8b 40 08             	mov    0x8(%eax),%eax
  101e2d:	83 ec 08             	sub    $0x8,%esp
  101e30:	50                   	push   %eax
  101e31:	8d 83 51 ec fe ff    	lea    -0x113af(%ebx),%eax
  101e37:	50                   	push   %eax
  101e38:	e8 e0 e4 ff ff       	call   10031d <cprintf>
  101e3d:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101e40:	8b 45 08             	mov    0x8(%ebp),%eax
  101e43:	8b 40 0c             	mov    0xc(%eax),%eax
  101e46:	83 ec 08             	sub    $0x8,%esp
  101e49:	50                   	push   %eax
  101e4a:	8d 83 60 ec fe ff    	lea    -0x113a0(%ebx),%eax
  101e50:	50                   	push   %eax
  101e51:	e8 c7 e4 ff ff       	call   10031d <cprintf>
  101e56:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101e59:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5c:	8b 40 10             	mov    0x10(%eax),%eax
  101e5f:	83 ec 08             	sub    $0x8,%esp
  101e62:	50                   	push   %eax
  101e63:	8d 83 6f ec fe ff    	lea    -0x11391(%ebx),%eax
  101e69:	50                   	push   %eax
  101e6a:	e8 ae e4 ff ff       	call   10031d <cprintf>
  101e6f:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101e72:	8b 45 08             	mov    0x8(%ebp),%eax
  101e75:	8b 40 14             	mov    0x14(%eax),%eax
  101e78:	83 ec 08             	sub    $0x8,%esp
  101e7b:	50                   	push   %eax
  101e7c:	8d 83 7e ec fe ff    	lea    -0x11382(%ebx),%eax
  101e82:	50                   	push   %eax
  101e83:	e8 95 e4 ff ff       	call   10031d <cprintf>
  101e88:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8e:	8b 40 18             	mov    0x18(%eax),%eax
  101e91:	83 ec 08             	sub    $0x8,%esp
  101e94:	50                   	push   %eax
  101e95:	8d 83 8d ec fe ff    	lea    -0x11373(%ebx),%eax
  101e9b:	50                   	push   %eax
  101e9c:	e8 7c e4 ff ff       	call   10031d <cprintf>
  101ea1:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea7:	8b 40 1c             	mov    0x1c(%eax),%eax
  101eaa:	83 ec 08             	sub    $0x8,%esp
  101ead:	50                   	push   %eax
  101eae:	8d 83 9c ec fe ff    	lea    -0x11364(%ebx),%eax
  101eb4:	50                   	push   %eax
  101eb5:	e8 63 e4 ff ff       	call   10031d <cprintf>
  101eba:	83 c4 10             	add    $0x10,%esp
}
  101ebd:	90                   	nop
  101ebe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101ec1:	c9                   	leave  
  101ec2:	c3                   	ret    

00101ec3 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ec3:	55                   	push   %ebp
  101ec4:	89 e5                	mov    %esp,%ebp
  101ec6:	53                   	push   %ebx
  101ec7:	83 ec 14             	sub    $0x14,%esp
  101eca:	e8 db e3 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  101ecf:	81 c3 a1 5a 01 00    	add    $0x15aa1,%ebx
    char c;

    switch (tf->tf_trapno) {
  101ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed8:	8b 40 30             	mov    0x30(%eax),%eax
  101edb:	83 f8 2f             	cmp    $0x2f,%eax
  101ede:	77 1e                	ja     101efe <trap_dispatch+0x3b>
  101ee0:	83 f8 2e             	cmp    $0x2e,%eax
  101ee3:	0f 83 c0 00 00 00    	jae    101fa9 <trap_dispatch+0xe6>
  101ee9:	83 f8 21             	cmp    $0x21,%eax
  101eec:	74 40                	je     101f2e <trap_dispatch+0x6b>
  101eee:	83 f8 24             	cmp    $0x24,%eax
  101ef1:	74 15                	je     101f08 <trap_dispatch+0x45>
  101ef3:	83 f8 20             	cmp    $0x20,%eax
  101ef6:	0f 84 b0 00 00 00    	je     101fac <trap_dispatch+0xe9>
  101efc:	eb 71                	jmp    101f6f <trap_dispatch+0xac>
  101efe:	83 e8 78             	sub    $0x78,%eax
  101f01:	83 f8 01             	cmp    $0x1,%eax
  101f04:	77 69                	ja     101f6f <trap_dispatch+0xac>
  101f06:	eb 4c                	jmp    101f54 <trap_dispatch+0x91>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101f08:	e8 a6 f9 ff ff       	call   1018b3 <cons_getc>
  101f0d:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101f10:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101f14:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101f18:	83 ec 04             	sub    $0x4,%esp
  101f1b:	52                   	push   %edx
  101f1c:	50                   	push   %eax
  101f1d:	8d 83 ab ec fe ff    	lea    -0x11355(%ebx),%eax
  101f23:	50                   	push   %eax
  101f24:	e8 f4 e3 ff ff       	call   10031d <cprintf>
  101f29:	83 c4 10             	add    $0x10,%esp
        break;
  101f2c:	eb 7f                	jmp    101fad <trap_dispatch+0xea>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101f2e:	e8 80 f9 ff ff       	call   1018b3 <cons_getc>
  101f33:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101f36:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101f3a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101f3e:	83 ec 04             	sub    $0x4,%esp
  101f41:	52                   	push   %edx
  101f42:	50                   	push   %eax
  101f43:	8d 83 bd ec fe ff    	lea    -0x11343(%ebx),%eax
  101f49:	50                   	push   %eax
  101f4a:	e8 ce e3 ff ff       	call   10031d <cprintf>
  101f4f:	83 c4 10             	add    $0x10,%esp
        break;
  101f52:	eb 59                	jmp    101fad <trap_dispatch+0xea>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101f54:	83 ec 04             	sub    $0x4,%esp
  101f57:	8d 83 cc ec fe ff    	lea    -0x11334(%ebx),%eax
  101f5d:	50                   	push   %eax
  101f5e:	68 a2 00 00 00       	push   $0xa2
  101f63:	8d 83 dc ec fe ff    	lea    -0x11324(%ebx),%eax
  101f69:	50                   	push   %eax
  101f6a:	e8 5e e5 ff ff       	call   1004cd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f72:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f76:	0f b7 c0             	movzwl %ax,%eax
  101f79:	83 e0 03             	and    $0x3,%eax
  101f7c:	85 c0                	test   %eax,%eax
  101f7e:	75 2d                	jne    101fad <trap_dispatch+0xea>
            print_trapframe(tf);
  101f80:	83 ec 0c             	sub    $0xc,%esp
  101f83:	ff 75 08             	pushl  0x8(%ebp)
  101f86:	e8 53 fc ff ff       	call   101bde <print_trapframe>
  101f8b:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101f8e:	83 ec 04             	sub    $0x4,%esp
  101f91:	8d 83 ed ec fe ff    	lea    -0x11313(%ebx),%eax
  101f97:	50                   	push   %eax
  101f98:	68 ac 00 00 00       	push   $0xac
  101f9d:	8d 83 dc ec fe ff    	lea    -0x11324(%ebx),%eax
  101fa3:	50                   	push   %eax
  101fa4:	e8 24 e5 ff ff       	call   1004cd <__panic>
        break;
  101fa9:	90                   	nop
  101faa:	eb 01                	jmp    101fad <trap_dispatch+0xea>
        break;
  101fac:	90                   	nop
        }
    }
}
  101fad:	90                   	nop
  101fae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101fb1:	c9                   	leave  
  101fb2:	c3                   	ret    

00101fb3 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101fb3:	55                   	push   %ebp
  101fb4:	89 e5                	mov    %esp,%ebp
  101fb6:	83 ec 08             	sub    $0x8,%esp
  101fb9:	e8 e8 e2 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  101fbe:	05 b2 59 01 00       	add    $0x159b2,%eax
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101fc3:	83 ec 0c             	sub    $0xc,%esp
  101fc6:	ff 75 08             	pushl  0x8(%ebp)
  101fc9:	e8 f5 fe ff ff       	call   101ec3 <trap_dispatch>
  101fce:	83 c4 10             	add    $0x10,%esp
}
  101fd1:	90                   	nop
  101fd2:	c9                   	leave  
  101fd3:	c3                   	ret    

00101fd4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101fd4:	6a 00                	push   $0x0
  pushl $0
  101fd6:	6a 00                	push   $0x0
  jmp __alltraps
  101fd8:	e9 67 0a 00 00       	jmp    102a44 <__alltraps>

00101fdd <vector1>:
.globl vector1
vector1:
  pushl $0
  101fdd:	6a 00                	push   $0x0
  pushl $1
  101fdf:	6a 01                	push   $0x1
  jmp __alltraps
  101fe1:	e9 5e 0a 00 00       	jmp    102a44 <__alltraps>

00101fe6 <vector2>:
.globl vector2
vector2:
  pushl $0
  101fe6:	6a 00                	push   $0x0
  pushl $2
  101fe8:	6a 02                	push   $0x2
  jmp __alltraps
  101fea:	e9 55 0a 00 00       	jmp    102a44 <__alltraps>

00101fef <vector3>:
.globl vector3
vector3:
  pushl $0
  101fef:	6a 00                	push   $0x0
  pushl $3
  101ff1:	6a 03                	push   $0x3
  jmp __alltraps
  101ff3:	e9 4c 0a 00 00       	jmp    102a44 <__alltraps>

00101ff8 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ff8:	6a 00                	push   $0x0
  pushl $4
  101ffa:	6a 04                	push   $0x4
  jmp __alltraps
  101ffc:	e9 43 0a 00 00       	jmp    102a44 <__alltraps>

00102001 <vector5>:
.globl vector5
vector5:
  pushl $0
  102001:	6a 00                	push   $0x0
  pushl $5
  102003:	6a 05                	push   $0x5
  jmp __alltraps
  102005:	e9 3a 0a 00 00       	jmp    102a44 <__alltraps>

0010200a <vector6>:
.globl vector6
vector6:
  pushl $0
  10200a:	6a 00                	push   $0x0
  pushl $6
  10200c:	6a 06                	push   $0x6
  jmp __alltraps
  10200e:	e9 31 0a 00 00       	jmp    102a44 <__alltraps>

00102013 <vector7>:
.globl vector7
vector7:
  pushl $0
  102013:	6a 00                	push   $0x0
  pushl $7
  102015:	6a 07                	push   $0x7
  jmp __alltraps
  102017:	e9 28 0a 00 00       	jmp    102a44 <__alltraps>

0010201c <vector8>:
.globl vector8
vector8:
  pushl $8
  10201c:	6a 08                	push   $0x8
  jmp __alltraps
  10201e:	e9 21 0a 00 00       	jmp    102a44 <__alltraps>

00102023 <vector9>:
.globl vector9
vector9:
  pushl $9
  102023:	6a 09                	push   $0x9
  jmp __alltraps
  102025:	e9 1a 0a 00 00       	jmp    102a44 <__alltraps>

0010202a <vector10>:
.globl vector10
vector10:
  pushl $10
  10202a:	6a 0a                	push   $0xa
  jmp __alltraps
  10202c:	e9 13 0a 00 00       	jmp    102a44 <__alltraps>

00102031 <vector11>:
.globl vector11
vector11:
  pushl $11
  102031:	6a 0b                	push   $0xb
  jmp __alltraps
  102033:	e9 0c 0a 00 00       	jmp    102a44 <__alltraps>

00102038 <vector12>:
.globl vector12
vector12:
  pushl $12
  102038:	6a 0c                	push   $0xc
  jmp __alltraps
  10203a:	e9 05 0a 00 00       	jmp    102a44 <__alltraps>

0010203f <vector13>:
.globl vector13
vector13:
  pushl $13
  10203f:	6a 0d                	push   $0xd
  jmp __alltraps
  102041:	e9 fe 09 00 00       	jmp    102a44 <__alltraps>

00102046 <vector14>:
.globl vector14
vector14:
  pushl $14
  102046:	6a 0e                	push   $0xe
  jmp __alltraps
  102048:	e9 f7 09 00 00       	jmp    102a44 <__alltraps>

0010204d <vector15>:
.globl vector15
vector15:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $15
  10204f:	6a 0f                	push   $0xf
  jmp __alltraps
  102051:	e9 ee 09 00 00       	jmp    102a44 <__alltraps>

00102056 <vector16>:
.globl vector16
vector16:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $16
  102058:	6a 10                	push   $0x10
  jmp __alltraps
  10205a:	e9 e5 09 00 00       	jmp    102a44 <__alltraps>

0010205f <vector17>:
.globl vector17
vector17:
  pushl $17
  10205f:	6a 11                	push   $0x11
  jmp __alltraps
  102061:	e9 de 09 00 00       	jmp    102a44 <__alltraps>

00102066 <vector18>:
.globl vector18
vector18:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $18
  102068:	6a 12                	push   $0x12
  jmp __alltraps
  10206a:	e9 d5 09 00 00       	jmp    102a44 <__alltraps>

0010206f <vector19>:
.globl vector19
vector19:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $19
  102071:	6a 13                	push   $0x13
  jmp __alltraps
  102073:	e9 cc 09 00 00       	jmp    102a44 <__alltraps>

00102078 <vector20>:
.globl vector20
vector20:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $20
  10207a:	6a 14                	push   $0x14
  jmp __alltraps
  10207c:	e9 c3 09 00 00       	jmp    102a44 <__alltraps>

00102081 <vector21>:
.globl vector21
vector21:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $21
  102083:	6a 15                	push   $0x15
  jmp __alltraps
  102085:	e9 ba 09 00 00       	jmp    102a44 <__alltraps>

0010208a <vector22>:
.globl vector22
vector22:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $22
  10208c:	6a 16                	push   $0x16
  jmp __alltraps
  10208e:	e9 b1 09 00 00       	jmp    102a44 <__alltraps>

00102093 <vector23>:
.globl vector23
vector23:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $23
  102095:	6a 17                	push   $0x17
  jmp __alltraps
  102097:	e9 a8 09 00 00       	jmp    102a44 <__alltraps>

0010209c <vector24>:
.globl vector24
vector24:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $24
  10209e:	6a 18                	push   $0x18
  jmp __alltraps
  1020a0:	e9 9f 09 00 00       	jmp    102a44 <__alltraps>

001020a5 <vector25>:
.globl vector25
vector25:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $25
  1020a7:	6a 19                	push   $0x19
  jmp __alltraps
  1020a9:	e9 96 09 00 00       	jmp    102a44 <__alltraps>

001020ae <vector26>:
.globl vector26
vector26:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $26
  1020b0:	6a 1a                	push   $0x1a
  jmp __alltraps
  1020b2:	e9 8d 09 00 00       	jmp    102a44 <__alltraps>

001020b7 <vector27>:
.globl vector27
vector27:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $27
  1020b9:	6a 1b                	push   $0x1b
  jmp __alltraps
  1020bb:	e9 84 09 00 00       	jmp    102a44 <__alltraps>

001020c0 <vector28>:
.globl vector28
vector28:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $28
  1020c2:	6a 1c                	push   $0x1c
  jmp __alltraps
  1020c4:	e9 7b 09 00 00       	jmp    102a44 <__alltraps>

001020c9 <vector29>:
.globl vector29
vector29:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $29
  1020cb:	6a 1d                	push   $0x1d
  jmp __alltraps
  1020cd:	e9 72 09 00 00       	jmp    102a44 <__alltraps>

001020d2 <vector30>:
.globl vector30
vector30:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $30
  1020d4:	6a 1e                	push   $0x1e
  jmp __alltraps
  1020d6:	e9 69 09 00 00       	jmp    102a44 <__alltraps>

001020db <vector31>:
.globl vector31
vector31:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $31
  1020dd:	6a 1f                	push   $0x1f
  jmp __alltraps
  1020df:	e9 60 09 00 00       	jmp    102a44 <__alltraps>

001020e4 <vector32>:
.globl vector32
vector32:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $32
  1020e6:	6a 20                	push   $0x20
  jmp __alltraps
  1020e8:	e9 57 09 00 00       	jmp    102a44 <__alltraps>

001020ed <vector33>:
.globl vector33
vector33:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $33
  1020ef:	6a 21                	push   $0x21
  jmp __alltraps
  1020f1:	e9 4e 09 00 00       	jmp    102a44 <__alltraps>

001020f6 <vector34>:
.globl vector34
vector34:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $34
  1020f8:	6a 22                	push   $0x22
  jmp __alltraps
  1020fa:	e9 45 09 00 00       	jmp    102a44 <__alltraps>

001020ff <vector35>:
.globl vector35
vector35:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $35
  102101:	6a 23                	push   $0x23
  jmp __alltraps
  102103:	e9 3c 09 00 00       	jmp    102a44 <__alltraps>

00102108 <vector36>:
.globl vector36
vector36:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $36
  10210a:	6a 24                	push   $0x24
  jmp __alltraps
  10210c:	e9 33 09 00 00       	jmp    102a44 <__alltraps>

00102111 <vector37>:
.globl vector37
vector37:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $37
  102113:	6a 25                	push   $0x25
  jmp __alltraps
  102115:	e9 2a 09 00 00       	jmp    102a44 <__alltraps>

0010211a <vector38>:
.globl vector38
vector38:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $38
  10211c:	6a 26                	push   $0x26
  jmp __alltraps
  10211e:	e9 21 09 00 00       	jmp    102a44 <__alltraps>

00102123 <vector39>:
.globl vector39
vector39:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $39
  102125:	6a 27                	push   $0x27
  jmp __alltraps
  102127:	e9 18 09 00 00       	jmp    102a44 <__alltraps>

0010212c <vector40>:
.globl vector40
vector40:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $40
  10212e:	6a 28                	push   $0x28
  jmp __alltraps
  102130:	e9 0f 09 00 00       	jmp    102a44 <__alltraps>

00102135 <vector41>:
.globl vector41
vector41:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $41
  102137:	6a 29                	push   $0x29
  jmp __alltraps
  102139:	e9 06 09 00 00       	jmp    102a44 <__alltraps>

0010213e <vector42>:
.globl vector42
vector42:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $42
  102140:	6a 2a                	push   $0x2a
  jmp __alltraps
  102142:	e9 fd 08 00 00       	jmp    102a44 <__alltraps>

00102147 <vector43>:
.globl vector43
vector43:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $43
  102149:	6a 2b                	push   $0x2b
  jmp __alltraps
  10214b:	e9 f4 08 00 00       	jmp    102a44 <__alltraps>

00102150 <vector44>:
.globl vector44
vector44:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $44
  102152:	6a 2c                	push   $0x2c
  jmp __alltraps
  102154:	e9 eb 08 00 00       	jmp    102a44 <__alltraps>

00102159 <vector45>:
.globl vector45
vector45:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $45
  10215b:	6a 2d                	push   $0x2d
  jmp __alltraps
  10215d:	e9 e2 08 00 00       	jmp    102a44 <__alltraps>

00102162 <vector46>:
.globl vector46
vector46:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $46
  102164:	6a 2e                	push   $0x2e
  jmp __alltraps
  102166:	e9 d9 08 00 00       	jmp    102a44 <__alltraps>

0010216b <vector47>:
.globl vector47
vector47:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $47
  10216d:	6a 2f                	push   $0x2f
  jmp __alltraps
  10216f:	e9 d0 08 00 00       	jmp    102a44 <__alltraps>

00102174 <vector48>:
.globl vector48
vector48:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $48
  102176:	6a 30                	push   $0x30
  jmp __alltraps
  102178:	e9 c7 08 00 00       	jmp    102a44 <__alltraps>

0010217d <vector49>:
.globl vector49
vector49:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $49
  10217f:	6a 31                	push   $0x31
  jmp __alltraps
  102181:	e9 be 08 00 00       	jmp    102a44 <__alltraps>

00102186 <vector50>:
.globl vector50
vector50:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $50
  102188:	6a 32                	push   $0x32
  jmp __alltraps
  10218a:	e9 b5 08 00 00       	jmp    102a44 <__alltraps>

0010218f <vector51>:
.globl vector51
vector51:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $51
  102191:	6a 33                	push   $0x33
  jmp __alltraps
  102193:	e9 ac 08 00 00       	jmp    102a44 <__alltraps>

00102198 <vector52>:
.globl vector52
vector52:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $52
  10219a:	6a 34                	push   $0x34
  jmp __alltraps
  10219c:	e9 a3 08 00 00       	jmp    102a44 <__alltraps>

001021a1 <vector53>:
.globl vector53
vector53:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $53
  1021a3:	6a 35                	push   $0x35
  jmp __alltraps
  1021a5:	e9 9a 08 00 00       	jmp    102a44 <__alltraps>

001021aa <vector54>:
.globl vector54
vector54:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $54
  1021ac:	6a 36                	push   $0x36
  jmp __alltraps
  1021ae:	e9 91 08 00 00       	jmp    102a44 <__alltraps>

001021b3 <vector55>:
.globl vector55
vector55:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $55
  1021b5:	6a 37                	push   $0x37
  jmp __alltraps
  1021b7:	e9 88 08 00 00       	jmp    102a44 <__alltraps>

001021bc <vector56>:
.globl vector56
vector56:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $56
  1021be:	6a 38                	push   $0x38
  jmp __alltraps
  1021c0:	e9 7f 08 00 00       	jmp    102a44 <__alltraps>

001021c5 <vector57>:
.globl vector57
vector57:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $57
  1021c7:	6a 39                	push   $0x39
  jmp __alltraps
  1021c9:	e9 76 08 00 00       	jmp    102a44 <__alltraps>

001021ce <vector58>:
.globl vector58
vector58:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $58
  1021d0:	6a 3a                	push   $0x3a
  jmp __alltraps
  1021d2:	e9 6d 08 00 00       	jmp    102a44 <__alltraps>

001021d7 <vector59>:
.globl vector59
vector59:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $59
  1021d9:	6a 3b                	push   $0x3b
  jmp __alltraps
  1021db:	e9 64 08 00 00       	jmp    102a44 <__alltraps>

001021e0 <vector60>:
.globl vector60
vector60:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $60
  1021e2:	6a 3c                	push   $0x3c
  jmp __alltraps
  1021e4:	e9 5b 08 00 00       	jmp    102a44 <__alltraps>

001021e9 <vector61>:
.globl vector61
vector61:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $61
  1021eb:	6a 3d                	push   $0x3d
  jmp __alltraps
  1021ed:	e9 52 08 00 00       	jmp    102a44 <__alltraps>

001021f2 <vector62>:
.globl vector62
vector62:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $62
  1021f4:	6a 3e                	push   $0x3e
  jmp __alltraps
  1021f6:	e9 49 08 00 00       	jmp    102a44 <__alltraps>

001021fb <vector63>:
.globl vector63
vector63:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $63
  1021fd:	6a 3f                	push   $0x3f
  jmp __alltraps
  1021ff:	e9 40 08 00 00       	jmp    102a44 <__alltraps>

00102204 <vector64>:
.globl vector64
vector64:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $64
  102206:	6a 40                	push   $0x40
  jmp __alltraps
  102208:	e9 37 08 00 00       	jmp    102a44 <__alltraps>

0010220d <vector65>:
.globl vector65
vector65:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $65
  10220f:	6a 41                	push   $0x41
  jmp __alltraps
  102211:	e9 2e 08 00 00       	jmp    102a44 <__alltraps>

00102216 <vector66>:
.globl vector66
vector66:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $66
  102218:	6a 42                	push   $0x42
  jmp __alltraps
  10221a:	e9 25 08 00 00       	jmp    102a44 <__alltraps>

0010221f <vector67>:
.globl vector67
vector67:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $67
  102221:	6a 43                	push   $0x43
  jmp __alltraps
  102223:	e9 1c 08 00 00       	jmp    102a44 <__alltraps>

00102228 <vector68>:
.globl vector68
vector68:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $68
  10222a:	6a 44                	push   $0x44
  jmp __alltraps
  10222c:	e9 13 08 00 00       	jmp    102a44 <__alltraps>

00102231 <vector69>:
.globl vector69
vector69:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $69
  102233:	6a 45                	push   $0x45
  jmp __alltraps
  102235:	e9 0a 08 00 00       	jmp    102a44 <__alltraps>

0010223a <vector70>:
.globl vector70
vector70:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $70
  10223c:	6a 46                	push   $0x46
  jmp __alltraps
  10223e:	e9 01 08 00 00       	jmp    102a44 <__alltraps>

00102243 <vector71>:
.globl vector71
vector71:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $71
  102245:	6a 47                	push   $0x47
  jmp __alltraps
  102247:	e9 f8 07 00 00       	jmp    102a44 <__alltraps>

0010224c <vector72>:
.globl vector72
vector72:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $72
  10224e:	6a 48                	push   $0x48
  jmp __alltraps
  102250:	e9 ef 07 00 00       	jmp    102a44 <__alltraps>

00102255 <vector73>:
.globl vector73
vector73:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $73
  102257:	6a 49                	push   $0x49
  jmp __alltraps
  102259:	e9 e6 07 00 00       	jmp    102a44 <__alltraps>

0010225e <vector74>:
.globl vector74
vector74:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $74
  102260:	6a 4a                	push   $0x4a
  jmp __alltraps
  102262:	e9 dd 07 00 00       	jmp    102a44 <__alltraps>

00102267 <vector75>:
.globl vector75
vector75:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $75
  102269:	6a 4b                	push   $0x4b
  jmp __alltraps
  10226b:	e9 d4 07 00 00       	jmp    102a44 <__alltraps>

00102270 <vector76>:
.globl vector76
vector76:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $76
  102272:	6a 4c                	push   $0x4c
  jmp __alltraps
  102274:	e9 cb 07 00 00       	jmp    102a44 <__alltraps>

00102279 <vector77>:
.globl vector77
vector77:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $77
  10227b:	6a 4d                	push   $0x4d
  jmp __alltraps
  10227d:	e9 c2 07 00 00       	jmp    102a44 <__alltraps>

00102282 <vector78>:
.globl vector78
vector78:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $78
  102284:	6a 4e                	push   $0x4e
  jmp __alltraps
  102286:	e9 b9 07 00 00       	jmp    102a44 <__alltraps>

0010228b <vector79>:
.globl vector79
vector79:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $79
  10228d:	6a 4f                	push   $0x4f
  jmp __alltraps
  10228f:	e9 b0 07 00 00       	jmp    102a44 <__alltraps>

00102294 <vector80>:
.globl vector80
vector80:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $80
  102296:	6a 50                	push   $0x50
  jmp __alltraps
  102298:	e9 a7 07 00 00       	jmp    102a44 <__alltraps>

0010229d <vector81>:
.globl vector81
vector81:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $81
  10229f:	6a 51                	push   $0x51
  jmp __alltraps
  1022a1:	e9 9e 07 00 00       	jmp    102a44 <__alltraps>

001022a6 <vector82>:
.globl vector82
vector82:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $82
  1022a8:	6a 52                	push   $0x52
  jmp __alltraps
  1022aa:	e9 95 07 00 00       	jmp    102a44 <__alltraps>

001022af <vector83>:
.globl vector83
vector83:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $83
  1022b1:	6a 53                	push   $0x53
  jmp __alltraps
  1022b3:	e9 8c 07 00 00       	jmp    102a44 <__alltraps>

001022b8 <vector84>:
.globl vector84
vector84:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $84
  1022ba:	6a 54                	push   $0x54
  jmp __alltraps
  1022bc:	e9 83 07 00 00       	jmp    102a44 <__alltraps>

001022c1 <vector85>:
.globl vector85
vector85:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $85
  1022c3:	6a 55                	push   $0x55
  jmp __alltraps
  1022c5:	e9 7a 07 00 00       	jmp    102a44 <__alltraps>

001022ca <vector86>:
.globl vector86
vector86:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $86
  1022cc:	6a 56                	push   $0x56
  jmp __alltraps
  1022ce:	e9 71 07 00 00       	jmp    102a44 <__alltraps>

001022d3 <vector87>:
.globl vector87
vector87:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $87
  1022d5:	6a 57                	push   $0x57
  jmp __alltraps
  1022d7:	e9 68 07 00 00       	jmp    102a44 <__alltraps>

001022dc <vector88>:
.globl vector88
vector88:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $88
  1022de:	6a 58                	push   $0x58
  jmp __alltraps
  1022e0:	e9 5f 07 00 00       	jmp    102a44 <__alltraps>

001022e5 <vector89>:
.globl vector89
vector89:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $89
  1022e7:	6a 59                	push   $0x59
  jmp __alltraps
  1022e9:	e9 56 07 00 00       	jmp    102a44 <__alltraps>

001022ee <vector90>:
.globl vector90
vector90:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $90
  1022f0:	6a 5a                	push   $0x5a
  jmp __alltraps
  1022f2:	e9 4d 07 00 00       	jmp    102a44 <__alltraps>

001022f7 <vector91>:
.globl vector91
vector91:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $91
  1022f9:	6a 5b                	push   $0x5b
  jmp __alltraps
  1022fb:	e9 44 07 00 00       	jmp    102a44 <__alltraps>

00102300 <vector92>:
.globl vector92
vector92:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $92
  102302:	6a 5c                	push   $0x5c
  jmp __alltraps
  102304:	e9 3b 07 00 00       	jmp    102a44 <__alltraps>

00102309 <vector93>:
.globl vector93
vector93:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $93
  10230b:	6a 5d                	push   $0x5d
  jmp __alltraps
  10230d:	e9 32 07 00 00       	jmp    102a44 <__alltraps>

00102312 <vector94>:
.globl vector94
vector94:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $94
  102314:	6a 5e                	push   $0x5e
  jmp __alltraps
  102316:	e9 29 07 00 00       	jmp    102a44 <__alltraps>

0010231b <vector95>:
.globl vector95
vector95:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $95
  10231d:	6a 5f                	push   $0x5f
  jmp __alltraps
  10231f:	e9 20 07 00 00       	jmp    102a44 <__alltraps>

00102324 <vector96>:
.globl vector96
vector96:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $96
  102326:	6a 60                	push   $0x60
  jmp __alltraps
  102328:	e9 17 07 00 00       	jmp    102a44 <__alltraps>

0010232d <vector97>:
.globl vector97
vector97:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $97
  10232f:	6a 61                	push   $0x61
  jmp __alltraps
  102331:	e9 0e 07 00 00       	jmp    102a44 <__alltraps>

00102336 <vector98>:
.globl vector98
vector98:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $98
  102338:	6a 62                	push   $0x62
  jmp __alltraps
  10233a:	e9 05 07 00 00       	jmp    102a44 <__alltraps>

0010233f <vector99>:
.globl vector99
vector99:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $99
  102341:	6a 63                	push   $0x63
  jmp __alltraps
  102343:	e9 fc 06 00 00       	jmp    102a44 <__alltraps>

00102348 <vector100>:
.globl vector100
vector100:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $100
  10234a:	6a 64                	push   $0x64
  jmp __alltraps
  10234c:	e9 f3 06 00 00       	jmp    102a44 <__alltraps>

00102351 <vector101>:
.globl vector101
vector101:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $101
  102353:	6a 65                	push   $0x65
  jmp __alltraps
  102355:	e9 ea 06 00 00       	jmp    102a44 <__alltraps>

0010235a <vector102>:
.globl vector102
vector102:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $102
  10235c:	6a 66                	push   $0x66
  jmp __alltraps
  10235e:	e9 e1 06 00 00       	jmp    102a44 <__alltraps>

00102363 <vector103>:
.globl vector103
vector103:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $103
  102365:	6a 67                	push   $0x67
  jmp __alltraps
  102367:	e9 d8 06 00 00       	jmp    102a44 <__alltraps>

0010236c <vector104>:
.globl vector104
vector104:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $104
  10236e:	6a 68                	push   $0x68
  jmp __alltraps
  102370:	e9 cf 06 00 00       	jmp    102a44 <__alltraps>

00102375 <vector105>:
.globl vector105
vector105:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $105
  102377:	6a 69                	push   $0x69
  jmp __alltraps
  102379:	e9 c6 06 00 00       	jmp    102a44 <__alltraps>

0010237e <vector106>:
.globl vector106
vector106:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $106
  102380:	6a 6a                	push   $0x6a
  jmp __alltraps
  102382:	e9 bd 06 00 00       	jmp    102a44 <__alltraps>

00102387 <vector107>:
.globl vector107
vector107:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $107
  102389:	6a 6b                	push   $0x6b
  jmp __alltraps
  10238b:	e9 b4 06 00 00       	jmp    102a44 <__alltraps>

00102390 <vector108>:
.globl vector108
vector108:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $108
  102392:	6a 6c                	push   $0x6c
  jmp __alltraps
  102394:	e9 ab 06 00 00       	jmp    102a44 <__alltraps>

00102399 <vector109>:
.globl vector109
vector109:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $109
  10239b:	6a 6d                	push   $0x6d
  jmp __alltraps
  10239d:	e9 a2 06 00 00       	jmp    102a44 <__alltraps>

001023a2 <vector110>:
.globl vector110
vector110:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $110
  1023a4:	6a 6e                	push   $0x6e
  jmp __alltraps
  1023a6:	e9 99 06 00 00       	jmp    102a44 <__alltraps>

001023ab <vector111>:
.globl vector111
vector111:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $111
  1023ad:	6a 6f                	push   $0x6f
  jmp __alltraps
  1023af:	e9 90 06 00 00       	jmp    102a44 <__alltraps>

001023b4 <vector112>:
.globl vector112
vector112:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $112
  1023b6:	6a 70                	push   $0x70
  jmp __alltraps
  1023b8:	e9 87 06 00 00       	jmp    102a44 <__alltraps>

001023bd <vector113>:
.globl vector113
vector113:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $113
  1023bf:	6a 71                	push   $0x71
  jmp __alltraps
  1023c1:	e9 7e 06 00 00       	jmp    102a44 <__alltraps>

001023c6 <vector114>:
.globl vector114
vector114:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $114
  1023c8:	6a 72                	push   $0x72
  jmp __alltraps
  1023ca:	e9 75 06 00 00       	jmp    102a44 <__alltraps>

001023cf <vector115>:
.globl vector115
vector115:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $115
  1023d1:	6a 73                	push   $0x73
  jmp __alltraps
  1023d3:	e9 6c 06 00 00       	jmp    102a44 <__alltraps>

001023d8 <vector116>:
.globl vector116
vector116:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $116
  1023da:	6a 74                	push   $0x74
  jmp __alltraps
  1023dc:	e9 63 06 00 00       	jmp    102a44 <__alltraps>

001023e1 <vector117>:
.globl vector117
vector117:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $117
  1023e3:	6a 75                	push   $0x75
  jmp __alltraps
  1023e5:	e9 5a 06 00 00       	jmp    102a44 <__alltraps>

001023ea <vector118>:
.globl vector118
vector118:
  pushl $0
  1023ea:	6a 00                	push   $0x0
  pushl $118
  1023ec:	6a 76                	push   $0x76
  jmp __alltraps
  1023ee:	e9 51 06 00 00       	jmp    102a44 <__alltraps>

001023f3 <vector119>:
.globl vector119
vector119:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $119
  1023f5:	6a 77                	push   $0x77
  jmp __alltraps
  1023f7:	e9 48 06 00 00       	jmp    102a44 <__alltraps>

001023fc <vector120>:
.globl vector120
vector120:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $120
  1023fe:	6a 78                	push   $0x78
  jmp __alltraps
  102400:	e9 3f 06 00 00       	jmp    102a44 <__alltraps>

00102405 <vector121>:
.globl vector121
vector121:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $121
  102407:	6a 79                	push   $0x79
  jmp __alltraps
  102409:	e9 36 06 00 00       	jmp    102a44 <__alltraps>

0010240e <vector122>:
.globl vector122
vector122:
  pushl $0
  10240e:	6a 00                	push   $0x0
  pushl $122
  102410:	6a 7a                	push   $0x7a
  jmp __alltraps
  102412:	e9 2d 06 00 00       	jmp    102a44 <__alltraps>

00102417 <vector123>:
.globl vector123
vector123:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $123
  102419:	6a 7b                	push   $0x7b
  jmp __alltraps
  10241b:	e9 24 06 00 00       	jmp    102a44 <__alltraps>

00102420 <vector124>:
.globl vector124
vector124:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $124
  102422:	6a 7c                	push   $0x7c
  jmp __alltraps
  102424:	e9 1b 06 00 00       	jmp    102a44 <__alltraps>

00102429 <vector125>:
.globl vector125
vector125:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $125
  10242b:	6a 7d                	push   $0x7d
  jmp __alltraps
  10242d:	e9 12 06 00 00       	jmp    102a44 <__alltraps>

00102432 <vector126>:
.globl vector126
vector126:
  pushl $0
  102432:	6a 00                	push   $0x0
  pushl $126
  102434:	6a 7e                	push   $0x7e
  jmp __alltraps
  102436:	e9 09 06 00 00       	jmp    102a44 <__alltraps>

0010243b <vector127>:
.globl vector127
vector127:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $127
  10243d:	6a 7f                	push   $0x7f
  jmp __alltraps
  10243f:	e9 00 06 00 00       	jmp    102a44 <__alltraps>

00102444 <vector128>:
.globl vector128
vector128:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $128
  102446:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10244b:	e9 f4 05 00 00       	jmp    102a44 <__alltraps>

00102450 <vector129>:
.globl vector129
vector129:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $129
  102452:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102457:	e9 e8 05 00 00       	jmp    102a44 <__alltraps>

0010245c <vector130>:
.globl vector130
vector130:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $130
  10245e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102463:	e9 dc 05 00 00       	jmp    102a44 <__alltraps>

00102468 <vector131>:
.globl vector131
vector131:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $131
  10246a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10246f:	e9 d0 05 00 00       	jmp    102a44 <__alltraps>

00102474 <vector132>:
.globl vector132
vector132:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $132
  102476:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10247b:	e9 c4 05 00 00       	jmp    102a44 <__alltraps>

00102480 <vector133>:
.globl vector133
vector133:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $133
  102482:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102487:	e9 b8 05 00 00       	jmp    102a44 <__alltraps>

0010248c <vector134>:
.globl vector134
vector134:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $134
  10248e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102493:	e9 ac 05 00 00       	jmp    102a44 <__alltraps>

00102498 <vector135>:
.globl vector135
vector135:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $135
  10249a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10249f:	e9 a0 05 00 00       	jmp    102a44 <__alltraps>

001024a4 <vector136>:
.globl vector136
vector136:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $136
  1024a6:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1024ab:	e9 94 05 00 00       	jmp    102a44 <__alltraps>

001024b0 <vector137>:
.globl vector137
vector137:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $137
  1024b2:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1024b7:	e9 88 05 00 00       	jmp    102a44 <__alltraps>

001024bc <vector138>:
.globl vector138
vector138:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $138
  1024be:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1024c3:	e9 7c 05 00 00       	jmp    102a44 <__alltraps>

001024c8 <vector139>:
.globl vector139
vector139:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $139
  1024ca:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1024cf:	e9 70 05 00 00       	jmp    102a44 <__alltraps>

001024d4 <vector140>:
.globl vector140
vector140:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $140
  1024d6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1024db:	e9 64 05 00 00       	jmp    102a44 <__alltraps>

001024e0 <vector141>:
.globl vector141
vector141:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $141
  1024e2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1024e7:	e9 58 05 00 00       	jmp    102a44 <__alltraps>

001024ec <vector142>:
.globl vector142
vector142:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $142
  1024ee:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1024f3:	e9 4c 05 00 00       	jmp    102a44 <__alltraps>

001024f8 <vector143>:
.globl vector143
vector143:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $143
  1024fa:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1024ff:	e9 40 05 00 00       	jmp    102a44 <__alltraps>

00102504 <vector144>:
.globl vector144
vector144:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $144
  102506:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10250b:	e9 34 05 00 00       	jmp    102a44 <__alltraps>

00102510 <vector145>:
.globl vector145
vector145:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $145
  102512:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102517:	e9 28 05 00 00       	jmp    102a44 <__alltraps>

0010251c <vector146>:
.globl vector146
vector146:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $146
  10251e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102523:	e9 1c 05 00 00       	jmp    102a44 <__alltraps>

00102528 <vector147>:
.globl vector147
vector147:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $147
  10252a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10252f:	e9 10 05 00 00       	jmp    102a44 <__alltraps>

00102534 <vector148>:
.globl vector148
vector148:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $148
  102536:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10253b:	e9 04 05 00 00       	jmp    102a44 <__alltraps>

00102540 <vector149>:
.globl vector149
vector149:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $149
  102542:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102547:	e9 f8 04 00 00       	jmp    102a44 <__alltraps>

0010254c <vector150>:
.globl vector150
vector150:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $150
  10254e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102553:	e9 ec 04 00 00       	jmp    102a44 <__alltraps>

00102558 <vector151>:
.globl vector151
vector151:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $151
  10255a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10255f:	e9 e0 04 00 00       	jmp    102a44 <__alltraps>

00102564 <vector152>:
.globl vector152
vector152:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $152
  102566:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10256b:	e9 d4 04 00 00       	jmp    102a44 <__alltraps>

00102570 <vector153>:
.globl vector153
vector153:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $153
  102572:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102577:	e9 c8 04 00 00       	jmp    102a44 <__alltraps>

0010257c <vector154>:
.globl vector154
vector154:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $154
  10257e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102583:	e9 bc 04 00 00       	jmp    102a44 <__alltraps>

00102588 <vector155>:
.globl vector155
vector155:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $155
  10258a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10258f:	e9 b0 04 00 00       	jmp    102a44 <__alltraps>

00102594 <vector156>:
.globl vector156
vector156:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $156
  102596:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10259b:	e9 a4 04 00 00       	jmp    102a44 <__alltraps>

001025a0 <vector157>:
.globl vector157
vector157:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $157
  1025a2:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1025a7:	e9 98 04 00 00       	jmp    102a44 <__alltraps>

001025ac <vector158>:
.globl vector158
vector158:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $158
  1025ae:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1025b3:	e9 8c 04 00 00       	jmp    102a44 <__alltraps>

001025b8 <vector159>:
.globl vector159
vector159:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $159
  1025ba:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1025bf:	e9 80 04 00 00       	jmp    102a44 <__alltraps>

001025c4 <vector160>:
.globl vector160
vector160:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $160
  1025c6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1025cb:	e9 74 04 00 00       	jmp    102a44 <__alltraps>

001025d0 <vector161>:
.globl vector161
vector161:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $161
  1025d2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1025d7:	e9 68 04 00 00       	jmp    102a44 <__alltraps>

001025dc <vector162>:
.globl vector162
vector162:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $162
  1025de:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1025e3:	e9 5c 04 00 00       	jmp    102a44 <__alltraps>

001025e8 <vector163>:
.globl vector163
vector163:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $163
  1025ea:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1025ef:	e9 50 04 00 00       	jmp    102a44 <__alltraps>

001025f4 <vector164>:
.globl vector164
vector164:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $164
  1025f6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1025fb:	e9 44 04 00 00       	jmp    102a44 <__alltraps>

00102600 <vector165>:
.globl vector165
vector165:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $165
  102602:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102607:	e9 38 04 00 00       	jmp    102a44 <__alltraps>

0010260c <vector166>:
.globl vector166
vector166:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $166
  10260e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102613:	e9 2c 04 00 00       	jmp    102a44 <__alltraps>

00102618 <vector167>:
.globl vector167
vector167:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $167
  10261a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10261f:	e9 20 04 00 00       	jmp    102a44 <__alltraps>

00102624 <vector168>:
.globl vector168
vector168:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $168
  102626:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10262b:	e9 14 04 00 00       	jmp    102a44 <__alltraps>

00102630 <vector169>:
.globl vector169
vector169:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $169
  102632:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102637:	e9 08 04 00 00       	jmp    102a44 <__alltraps>

0010263c <vector170>:
.globl vector170
vector170:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $170
  10263e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102643:	e9 fc 03 00 00       	jmp    102a44 <__alltraps>

00102648 <vector171>:
.globl vector171
vector171:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $171
  10264a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10264f:	e9 f0 03 00 00       	jmp    102a44 <__alltraps>

00102654 <vector172>:
.globl vector172
vector172:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $172
  102656:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10265b:	e9 e4 03 00 00       	jmp    102a44 <__alltraps>

00102660 <vector173>:
.globl vector173
vector173:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $173
  102662:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102667:	e9 d8 03 00 00       	jmp    102a44 <__alltraps>

0010266c <vector174>:
.globl vector174
vector174:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $174
  10266e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102673:	e9 cc 03 00 00       	jmp    102a44 <__alltraps>

00102678 <vector175>:
.globl vector175
vector175:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $175
  10267a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10267f:	e9 c0 03 00 00       	jmp    102a44 <__alltraps>

00102684 <vector176>:
.globl vector176
vector176:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $176
  102686:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10268b:	e9 b4 03 00 00       	jmp    102a44 <__alltraps>

00102690 <vector177>:
.globl vector177
vector177:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $177
  102692:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102697:	e9 a8 03 00 00       	jmp    102a44 <__alltraps>

0010269c <vector178>:
.globl vector178
vector178:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $178
  10269e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1026a3:	e9 9c 03 00 00       	jmp    102a44 <__alltraps>

001026a8 <vector179>:
.globl vector179
vector179:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $179
  1026aa:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1026af:	e9 90 03 00 00       	jmp    102a44 <__alltraps>

001026b4 <vector180>:
.globl vector180
vector180:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $180
  1026b6:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1026bb:	e9 84 03 00 00       	jmp    102a44 <__alltraps>

001026c0 <vector181>:
.globl vector181
vector181:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $181
  1026c2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1026c7:	e9 78 03 00 00       	jmp    102a44 <__alltraps>

001026cc <vector182>:
.globl vector182
vector182:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $182
  1026ce:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1026d3:	e9 6c 03 00 00       	jmp    102a44 <__alltraps>

001026d8 <vector183>:
.globl vector183
vector183:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $183
  1026da:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1026df:	e9 60 03 00 00       	jmp    102a44 <__alltraps>

001026e4 <vector184>:
.globl vector184
vector184:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $184
  1026e6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1026eb:	e9 54 03 00 00       	jmp    102a44 <__alltraps>

001026f0 <vector185>:
.globl vector185
vector185:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $185
  1026f2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1026f7:	e9 48 03 00 00       	jmp    102a44 <__alltraps>

001026fc <vector186>:
.globl vector186
vector186:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $186
  1026fe:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102703:	e9 3c 03 00 00       	jmp    102a44 <__alltraps>

00102708 <vector187>:
.globl vector187
vector187:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $187
  10270a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10270f:	e9 30 03 00 00       	jmp    102a44 <__alltraps>

00102714 <vector188>:
.globl vector188
vector188:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $188
  102716:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10271b:	e9 24 03 00 00       	jmp    102a44 <__alltraps>

00102720 <vector189>:
.globl vector189
vector189:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $189
  102722:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102727:	e9 18 03 00 00       	jmp    102a44 <__alltraps>

0010272c <vector190>:
.globl vector190
vector190:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $190
  10272e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102733:	e9 0c 03 00 00       	jmp    102a44 <__alltraps>

00102738 <vector191>:
.globl vector191
vector191:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $191
  10273a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10273f:	e9 00 03 00 00       	jmp    102a44 <__alltraps>

00102744 <vector192>:
.globl vector192
vector192:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $192
  102746:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10274b:	e9 f4 02 00 00       	jmp    102a44 <__alltraps>

00102750 <vector193>:
.globl vector193
vector193:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $193
  102752:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102757:	e9 e8 02 00 00       	jmp    102a44 <__alltraps>

0010275c <vector194>:
.globl vector194
vector194:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $194
  10275e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102763:	e9 dc 02 00 00       	jmp    102a44 <__alltraps>

00102768 <vector195>:
.globl vector195
vector195:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $195
  10276a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10276f:	e9 d0 02 00 00       	jmp    102a44 <__alltraps>

00102774 <vector196>:
.globl vector196
vector196:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $196
  102776:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10277b:	e9 c4 02 00 00       	jmp    102a44 <__alltraps>

00102780 <vector197>:
.globl vector197
vector197:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $197
  102782:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102787:	e9 b8 02 00 00       	jmp    102a44 <__alltraps>

0010278c <vector198>:
.globl vector198
vector198:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $198
  10278e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102793:	e9 ac 02 00 00       	jmp    102a44 <__alltraps>

00102798 <vector199>:
.globl vector199
vector199:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $199
  10279a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10279f:	e9 a0 02 00 00       	jmp    102a44 <__alltraps>

001027a4 <vector200>:
.globl vector200
vector200:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $200
  1027a6:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1027ab:	e9 94 02 00 00       	jmp    102a44 <__alltraps>

001027b0 <vector201>:
.globl vector201
vector201:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $201
  1027b2:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1027b7:	e9 88 02 00 00       	jmp    102a44 <__alltraps>

001027bc <vector202>:
.globl vector202
vector202:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $202
  1027be:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1027c3:	e9 7c 02 00 00       	jmp    102a44 <__alltraps>

001027c8 <vector203>:
.globl vector203
vector203:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $203
  1027ca:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1027cf:	e9 70 02 00 00       	jmp    102a44 <__alltraps>

001027d4 <vector204>:
.globl vector204
vector204:
  pushl $0
  1027d4:	6a 00                	push   $0x0
  pushl $204
  1027d6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1027db:	e9 64 02 00 00       	jmp    102a44 <__alltraps>

001027e0 <vector205>:
.globl vector205
vector205:
  pushl $0
  1027e0:	6a 00                	push   $0x0
  pushl $205
  1027e2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1027e7:	e9 58 02 00 00       	jmp    102a44 <__alltraps>

001027ec <vector206>:
.globl vector206
vector206:
  pushl $0
  1027ec:	6a 00                	push   $0x0
  pushl $206
  1027ee:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1027f3:	e9 4c 02 00 00       	jmp    102a44 <__alltraps>

001027f8 <vector207>:
.globl vector207
vector207:
  pushl $0
  1027f8:	6a 00                	push   $0x0
  pushl $207
  1027fa:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1027ff:	e9 40 02 00 00       	jmp    102a44 <__alltraps>

00102804 <vector208>:
.globl vector208
vector208:
  pushl $0
  102804:	6a 00                	push   $0x0
  pushl $208
  102806:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10280b:	e9 34 02 00 00       	jmp    102a44 <__alltraps>

00102810 <vector209>:
.globl vector209
vector209:
  pushl $0
  102810:	6a 00                	push   $0x0
  pushl $209
  102812:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102817:	e9 28 02 00 00       	jmp    102a44 <__alltraps>

0010281c <vector210>:
.globl vector210
vector210:
  pushl $0
  10281c:	6a 00                	push   $0x0
  pushl $210
  10281e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102823:	e9 1c 02 00 00       	jmp    102a44 <__alltraps>

00102828 <vector211>:
.globl vector211
vector211:
  pushl $0
  102828:	6a 00                	push   $0x0
  pushl $211
  10282a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10282f:	e9 10 02 00 00       	jmp    102a44 <__alltraps>

00102834 <vector212>:
.globl vector212
vector212:
  pushl $0
  102834:	6a 00                	push   $0x0
  pushl $212
  102836:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10283b:	e9 04 02 00 00       	jmp    102a44 <__alltraps>

00102840 <vector213>:
.globl vector213
vector213:
  pushl $0
  102840:	6a 00                	push   $0x0
  pushl $213
  102842:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102847:	e9 f8 01 00 00       	jmp    102a44 <__alltraps>

0010284c <vector214>:
.globl vector214
vector214:
  pushl $0
  10284c:	6a 00                	push   $0x0
  pushl $214
  10284e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102853:	e9 ec 01 00 00       	jmp    102a44 <__alltraps>

00102858 <vector215>:
.globl vector215
vector215:
  pushl $0
  102858:	6a 00                	push   $0x0
  pushl $215
  10285a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10285f:	e9 e0 01 00 00       	jmp    102a44 <__alltraps>

00102864 <vector216>:
.globl vector216
vector216:
  pushl $0
  102864:	6a 00                	push   $0x0
  pushl $216
  102866:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10286b:	e9 d4 01 00 00       	jmp    102a44 <__alltraps>

00102870 <vector217>:
.globl vector217
vector217:
  pushl $0
  102870:	6a 00                	push   $0x0
  pushl $217
  102872:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102877:	e9 c8 01 00 00       	jmp    102a44 <__alltraps>

0010287c <vector218>:
.globl vector218
vector218:
  pushl $0
  10287c:	6a 00                	push   $0x0
  pushl $218
  10287e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102883:	e9 bc 01 00 00       	jmp    102a44 <__alltraps>

00102888 <vector219>:
.globl vector219
vector219:
  pushl $0
  102888:	6a 00                	push   $0x0
  pushl $219
  10288a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10288f:	e9 b0 01 00 00       	jmp    102a44 <__alltraps>

00102894 <vector220>:
.globl vector220
vector220:
  pushl $0
  102894:	6a 00                	push   $0x0
  pushl $220
  102896:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10289b:	e9 a4 01 00 00       	jmp    102a44 <__alltraps>

001028a0 <vector221>:
.globl vector221
vector221:
  pushl $0
  1028a0:	6a 00                	push   $0x0
  pushl $221
  1028a2:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1028a7:	e9 98 01 00 00       	jmp    102a44 <__alltraps>

001028ac <vector222>:
.globl vector222
vector222:
  pushl $0
  1028ac:	6a 00                	push   $0x0
  pushl $222
  1028ae:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1028b3:	e9 8c 01 00 00       	jmp    102a44 <__alltraps>

001028b8 <vector223>:
.globl vector223
vector223:
  pushl $0
  1028b8:	6a 00                	push   $0x0
  pushl $223
  1028ba:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1028bf:	e9 80 01 00 00       	jmp    102a44 <__alltraps>

001028c4 <vector224>:
.globl vector224
vector224:
  pushl $0
  1028c4:	6a 00                	push   $0x0
  pushl $224
  1028c6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1028cb:	e9 74 01 00 00       	jmp    102a44 <__alltraps>

001028d0 <vector225>:
.globl vector225
vector225:
  pushl $0
  1028d0:	6a 00                	push   $0x0
  pushl $225
  1028d2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1028d7:	e9 68 01 00 00       	jmp    102a44 <__alltraps>

001028dc <vector226>:
.globl vector226
vector226:
  pushl $0
  1028dc:	6a 00                	push   $0x0
  pushl $226
  1028de:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1028e3:	e9 5c 01 00 00       	jmp    102a44 <__alltraps>

001028e8 <vector227>:
.globl vector227
vector227:
  pushl $0
  1028e8:	6a 00                	push   $0x0
  pushl $227
  1028ea:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1028ef:	e9 50 01 00 00       	jmp    102a44 <__alltraps>

001028f4 <vector228>:
.globl vector228
vector228:
  pushl $0
  1028f4:	6a 00                	push   $0x0
  pushl $228
  1028f6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1028fb:	e9 44 01 00 00       	jmp    102a44 <__alltraps>

00102900 <vector229>:
.globl vector229
vector229:
  pushl $0
  102900:	6a 00                	push   $0x0
  pushl $229
  102902:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102907:	e9 38 01 00 00       	jmp    102a44 <__alltraps>

0010290c <vector230>:
.globl vector230
vector230:
  pushl $0
  10290c:	6a 00                	push   $0x0
  pushl $230
  10290e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102913:	e9 2c 01 00 00       	jmp    102a44 <__alltraps>

00102918 <vector231>:
.globl vector231
vector231:
  pushl $0
  102918:	6a 00                	push   $0x0
  pushl $231
  10291a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10291f:	e9 20 01 00 00       	jmp    102a44 <__alltraps>

00102924 <vector232>:
.globl vector232
vector232:
  pushl $0
  102924:	6a 00                	push   $0x0
  pushl $232
  102926:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10292b:	e9 14 01 00 00       	jmp    102a44 <__alltraps>

00102930 <vector233>:
.globl vector233
vector233:
  pushl $0
  102930:	6a 00                	push   $0x0
  pushl $233
  102932:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102937:	e9 08 01 00 00       	jmp    102a44 <__alltraps>

0010293c <vector234>:
.globl vector234
vector234:
  pushl $0
  10293c:	6a 00                	push   $0x0
  pushl $234
  10293e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102943:	e9 fc 00 00 00       	jmp    102a44 <__alltraps>

00102948 <vector235>:
.globl vector235
vector235:
  pushl $0
  102948:	6a 00                	push   $0x0
  pushl $235
  10294a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10294f:	e9 f0 00 00 00       	jmp    102a44 <__alltraps>

00102954 <vector236>:
.globl vector236
vector236:
  pushl $0
  102954:	6a 00                	push   $0x0
  pushl $236
  102956:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10295b:	e9 e4 00 00 00       	jmp    102a44 <__alltraps>

00102960 <vector237>:
.globl vector237
vector237:
  pushl $0
  102960:	6a 00                	push   $0x0
  pushl $237
  102962:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102967:	e9 d8 00 00 00       	jmp    102a44 <__alltraps>

0010296c <vector238>:
.globl vector238
vector238:
  pushl $0
  10296c:	6a 00                	push   $0x0
  pushl $238
  10296e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102973:	e9 cc 00 00 00       	jmp    102a44 <__alltraps>

00102978 <vector239>:
.globl vector239
vector239:
  pushl $0
  102978:	6a 00                	push   $0x0
  pushl $239
  10297a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10297f:	e9 c0 00 00 00       	jmp    102a44 <__alltraps>

00102984 <vector240>:
.globl vector240
vector240:
  pushl $0
  102984:	6a 00                	push   $0x0
  pushl $240
  102986:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10298b:	e9 b4 00 00 00       	jmp    102a44 <__alltraps>

00102990 <vector241>:
.globl vector241
vector241:
  pushl $0
  102990:	6a 00                	push   $0x0
  pushl $241
  102992:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102997:	e9 a8 00 00 00       	jmp    102a44 <__alltraps>

0010299c <vector242>:
.globl vector242
vector242:
  pushl $0
  10299c:	6a 00                	push   $0x0
  pushl $242
  10299e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1029a3:	e9 9c 00 00 00       	jmp    102a44 <__alltraps>

001029a8 <vector243>:
.globl vector243
vector243:
  pushl $0
  1029a8:	6a 00                	push   $0x0
  pushl $243
  1029aa:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1029af:	e9 90 00 00 00       	jmp    102a44 <__alltraps>

001029b4 <vector244>:
.globl vector244
vector244:
  pushl $0
  1029b4:	6a 00                	push   $0x0
  pushl $244
  1029b6:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1029bb:	e9 84 00 00 00       	jmp    102a44 <__alltraps>

001029c0 <vector245>:
.globl vector245
vector245:
  pushl $0
  1029c0:	6a 00                	push   $0x0
  pushl $245
  1029c2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1029c7:	e9 78 00 00 00       	jmp    102a44 <__alltraps>

001029cc <vector246>:
.globl vector246
vector246:
  pushl $0
  1029cc:	6a 00                	push   $0x0
  pushl $246
  1029ce:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1029d3:	e9 6c 00 00 00       	jmp    102a44 <__alltraps>

001029d8 <vector247>:
.globl vector247
vector247:
  pushl $0
  1029d8:	6a 00                	push   $0x0
  pushl $247
  1029da:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1029df:	e9 60 00 00 00       	jmp    102a44 <__alltraps>

001029e4 <vector248>:
.globl vector248
vector248:
  pushl $0
  1029e4:	6a 00                	push   $0x0
  pushl $248
  1029e6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1029eb:	e9 54 00 00 00       	jmp    102a44 <__alltraps>

001029f0 <vector249>:
.globl vector249
vector249:
  pushl $0
  1029f0:	6a 00                	push   $0x0
  pushl $249
  1029f2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1029f7:	e9 48 00 00 00       	jmp    102a44 <__alltraps>

001029fc <vector250>:
.globl vector250
vector250:
  pushl $0
  1029fc:	6a 00                	push   $0x0
  pushl $250
  1029fe:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a03:	e9 3c 00 00 00       	jmp    102a44 <__alltraps>

00102a08 <vector251>:
.globl vector251
vector251:
  pushl $0
  102a08:	6a 00                	push   $0x0
  pushl $251
  102a0a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102a0f:	e9 30 00 00 00       	jmp    102a44 <__alltraps>

00102a14 <vector252>:
.globl vector252
vector252:
  pushl $0
  102a14:	6a 00                	push   $0x0
  pushl $252
  102a16:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a1b:	e9 24 00 00 00       	jmp    102a44 <__alltraps>

00102a20 <vector253>:
.globl vector253
vector253:
  pushl $0
  102a20:	6a 00                	push   $0x0
  pushl $253
  102a22:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102a27:	e9 18 00 00 00       	jmp    102a44 <__alltraps>

00102a2c <vector254>:
.globl vector254
vector254:
  pushl $0
  102a2c:	6a 00                	push   $0x0
  pushl $254
  102a2e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a33:	e9 0c 00 00 00       	jmp    102a44 <__alltraps>

00102a38 <vector255>:
.globl vector255
vector255:
  pushl $0
  102a38:	6a 00                	push   $0x0
  pushl $255
  102a3a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a3f:	e9 00 00 00 00       	jmp    102a44 <__alltraps>

00102a44 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102a44:	1e                   	push   %ds
    pushl %es
  102a45:	06                   	push   %es
    pushl %fs
  102a46:	0f a0                	push   %fs
    pushl %gs
  102a48:	0f a8                	push   %gs
    pushal
  102a4a:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102a4b:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102a50:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102a52:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102a54:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102a55:	e8 59 f5 ff ff       	call   101fb3 <trap>

    # pop the pushed stack pointer
    popl %esp
  102a5a:	5c                   	pop    %esp

00102a5b <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102a5b:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102a5c:	0f a9                	pop    %gs
    popl %fs
  102a5e:	0f a1                	pop    %fs
    popl %es
  102a60:	07                   	pop    %es
    popl %ds
  102a61:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102a62:	83 c4 08             	add    $0x8,%esp
    iret
  102a65:	cf                   	iret   

00102a66 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102a66:	55                   	push   %ebp
  102a67:	89 e5                	mov    %esp,%ebp
  102a69:	e8 38 d8 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  102a6e:	05 02 4f 01 00       	add    $0x14f02,%eax
    return page - pages;
  102a73:	8b 55 08             	mov    0x8(%ebp),%edx
  102a76:	c7 c0 18 8a 11 00    	mov    $0x118a18,%eax
  102a7c:	8b 00                	mov    (%eax),%eax
  102a7e:	29 c2                	sub    %eax,%edx
  102a80:	89 d0                	mov    %edx,%eax
  102a82:	c1 f8 02             	sar    $0x2,%eax
  102a85:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102a8b:	5d                   	pop    %ebp
  102a8c:	c3                   	ret    

00102a8d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102a8d:	55                   	push   %ebp
  102a8e:	89 e5                	mov    %esp,%ebp
  102a90:	e8 11 d8 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  102a95:	05 db 4e 01 00       	add    $0x14edb,%eax
    return page2ppn(page) << PGSHIFT;
  102a9a:	ff 75 08             	pushl  0x8(%ebp)
  102a9d:	e8 c4 ff ff ff       	call   102a66 <page2ppn>
  102aa2:	83 c4 04             	add    $0x4,%esp
  102aa5:	c1 e0 0c             	shl    $0xc,%eax
}
  102aa8:	c9                   	leave  
  102aa9:	c3                   	ret    

00102aaa <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102aaa:	55                   	push   %ebp
  102aab:	89 e5                	mov    %esp,%ebp
  102aad:	53                   	push   %ebx
  102aae:	83 ec 04             	sub    $0x4,%esp
  102ab1:	e8 f0 d7 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  102ab6:	05 ba 4e 01 00       	add    $0x14eba,%eax
    if (PPN(pa) >= npage) {
  102abb:	8b 55 08             	mov    0x8(%ebp),%edx
  102abe:	89 d1                	mov    %edx,%ecx
  102ac0:	c1 e9 0c             	shr    $0xc,%ecx
  102ac3:	8b 90 10 10 00 00    	mov    0x1010(%eax),%edx
  102ac9:	39 d1                	cmp    %edx,%ecx
  102acb:	72 1a                	jb     102ae7 <pa2page+0x3d>
        panic("pa2page called with invalid pa");
  102acd:	83 ec 04             	sub    $0x4,%esp
  102ad0:	8d 90 4c ee fe ff    	lea    -0x111b4(%eax),%edx
  102ad6:	52                   	push   %edx
  102ad7:	6a 5a                	push   $0x5a
  102ad9:	8d 90 6b ee fe ff    	lea    -0x11195(%eax),%edx
  102adf:	52                   	push   %edx
  102ae0:	89 c3                	mov    %eax,%ebx
  102ae2:	e8 e6 d9 ff ff       	call   1004cd <__panic>
    }
    return &pages[PPN(pa)];
  102ae7:	c7 c0 18 8a 11 00    	mov    $0x118a18,%eax
  102aed:	8b 08                	mov    (%eax),%ecx
  102aef:	8b 45 08             	mov    0x8(%ebp),%eax
  102af2:	c1 e8 0c             	shr    $0xc,%eax
  102af5:	89 c2                	mov    %eax,%edx
  102af7:	89 d0                	mov    %edx,%eax
  102af9:	c1 e0 02             	shl    $0x2,%eax
  102afc:	01 d0                	add    %edx,%eax
  102afe:	c1 e0 02             	shl    $0x2,%eax
  102b01:	01 c8                	add    %ecx,%eax
}
  102b03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102b06:	c9                   	leave  
  102b07:	c3                   	ret    

00102b08 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102b08:	55                   	push   %ebp
  102b09:	89 e5                	mov    %esp,%ebp
  102b0b:	53                   	push   %ebx
  102b0c:	83 ec 14             	sub    $0x14,%esp
  102b0f:	e8 96 d7 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  102b14:	81 c3 5c 4e 01 00    	add    $0x14e5c,%ebx
    return KADDR(page2pa(page));
  102b1a:	ff 75 08             	pushl  0x8(%ebp)
  102b1d:	e8 6b ff ff ff       	call   102a8d <page2pa>
  102b22:	83 c4 04             	add    $0x4,%esp
  102b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b2b:	c1 e8 0c             	shr    $0xc,%eax
  102b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b31:	8b 83 10 10 00 00    	mov    0x1010(%ebx),%eax
  102b37:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102b3a:	72 18                	jb     102b54 <page2kva+0x4c>
  102b3c:	ff 75 f4             	pushl  -0xc(%ebp)
  102b3f:	8d 83 7c ee fe ff    	lea    -0x11184(%ebx),%eax
  102b45:	50                   	push   %eax
  102b46:	6a 61                	push   $0x61
  102b48:	8d 83 6b ee fe ff    	lea    -0x11195(%ebx),%eax
  102b4e:	50                   	push   %eax
  102b4f:	e8 79 d9 ff ff       	call   1004cd <__panic>
  102b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b57:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102b5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102b5f:	c9                   	leave  
  102b60:	c3                   	ret    

00102b61 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102b61:	55                   	push   %ebp
  102b62:	89 e5                	mov    %esp,%ebp
  102b64:	53                   	push   %ebx
  102b65:	83 ec 04             	sub    $0x4,%esp
  102b68:	e8 39 d7 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  102b6d:	05 03 4e 01 00       	add    $0x14e03,%eax
    if (!(pte & PTE_P)) {
  102b72:	8b 55 08             	mov    0x8(%ebp),%edx
  102b75:	83 e2 01             	and    $0x1,%edx
  102b78:	85 d2                	test   %edx,%edx
  102b7a:	75 1a                	jne    102b96 <pte2page+0x35>
        panic("pte2page called with invalid pte");
  102b7c:	83 ec 04             	sub    $0x4,%esp
  102b7f:	8d 90 a0 ee fe ff    	lea    -0x11160(%eax),%edx
  102b85:	52                   	push   %edx
  102b86:	6a 6c                	push   $0x6c
  102b88:	8d 90 6b ee fe ff    	lea    -0x11195(%eax),%edx
  102b8e:	52                   	push   %edx
  102b8f:	89 c3                	mov    %eax,%ebx
  102b91:	e8 37 d9 ff ff       	call   1004cd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102b96:	8b 45 08             	mov    0x8(%ebp),%eax
  102b99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102b9e:	83 ec 0c             	sub    $0xc,%esp
  102ba1:	50                   	push   %eax
  102ba2:	e8 03 ff ff ff       	call   102aaa <pa2page>
  102ba7:	83 c4 10             	add    $0x10,%esp
}
  102baa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102bad:	c9                   	leave  
  102bae:	c3                   	ret    

00102baf <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102baf:	55                   	push   %ebp
  102bb0:	89 e5                	mov    %esp,%ebp
  102bb2:	e8 ef d6 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  102bb7:	05 b9 4d 01 00       	add    $0x14db9,%eax
    return page->ref;
  102bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  102bbf:	8b 00                	mov    (%eax),%eax
}
  102bc1:	5d                   	pop    %ebp
  102bc2:	c3                   	ret    

00102bc3 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  102bc3:	55                   	push   %ebp
  102bc4:	89 e5                	mov    %esp,%ebp
  102bc6:	e8 db d6 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  102bcb:	05 a5 4d 01 00       	add    $0x14da5,%eax
    page->ref += 1;
  102bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd3:	8b 00                	mov    (%eax),%eax
  102bd5:	8d 50 01             	lea    0x1(%eax),%edx
  102bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  102bdb:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  102be0:	8b 00                	mov    (%eax),%eax
}
  102be2:	5d                   	pop    %ebp
  102be3:	c3                   	ret    

00102be4 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102be4:	55                   	push   %ebp
  102be5:	89 e5                	mov    %esp,%ebp
  102be7:	e8 ba d6 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  102bec:	05 84 4d 01 00       	add    $0x14d84,%eax
    page->ref -= 1;
  102bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf4:	8b 00                	mov    (%eax),%eax
  102bf6:	8d 50 ff             	lea    -0x1(%eax),%edx
  102bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  102bfc:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  102c01:	8b 00                	mov    (%eax),%eax
}
  102c03:	5d                   	pop    %ebp
  102c04:	c3                   	ret    

00102c05 <__intr_save>:
__intr_save(void) {
  102c05:	55                   	push   %ebp
  102c06:	89 e5                	mov    %esp,%ebp
  102c08:	53                   	push   %ebx
  102c09:	83 ec 14             	sub    $0x14,%esp
  102c0c:	e8 95 d6 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  102c11:	05 5f 4d 01 00       	add    $0x14d5f,%eax
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102c16:	9c                   	pushf  
  102c17:	5a                   	pop    %edx
  102c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
    return eflags;
  102c1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    if (read_eflags() & FL_IF) {
  102c1e:	81 e2 00 02 00 00    	and    $0x200,%edx
  102c24:	85 d2                	test   %edx,%edx
  102c26:	74 0e                	je     102c36 <__intr_save+0x31>
        intr_disable();
  102c28:	89 c3                	mov    %eax,%ebx
  102c2a:	e8 04 ef ff ff       	call   101b33 <intr_disable>
        return 1;
  102c2f:	b8 01 00 00 00       	mov    $0x1,%eax
  102c34:	eb 05                	jmp    102c3b <__intr_save+0x36>
    return 0;
  102c36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c3b:	83 c4 14             	add    $0x14,%esp
  102c3e:	5b                   	pop    %ebx
  102c3f:	5d                   	pop    %ebp
  102c40:	c3                   	ret    

00102c41 <__intr_restore>:
__intr_restore(bool flag) {
  102c41:	55                   	push   %ebp
  102c42:	89 e5                	mov    %esp,%ebp
  102c44:	53                   	push   %ebx
  102c45:	83 ec 04             	sub    $0x4,%esp
  102c48:	e8 59 d6 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  102c4d:	05 23 4d 01 00       	add    $0x14d23,%eax
    if (flag) {
  102c52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102c56:	74 07                	je     102c5f <__intr_restore+0x1e>
        intr_enable();
  102c58:	89 c3                	mov    %eax,%ebx
  102c5a:	e8 c3 ee ff ff       	call   101b22 <intr_enable>
}
  102c5f:	90                   	nop
  102c60:	83 c4 04             	add    $0x4,%esp
  102c63:	5b                   	pop    %ebx
  102c64:	5d                   	pop    %ebp
  102c65:	c3                   	ret    

00102c66 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102c66:	55                   	push   %ebp
  102c67:	89 e5                	mov    %esp,%ebp
  102c69:	e8 38 d6 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  102c6e:	05 02 4d 01 00       	add    $0x14d02,%eax
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102c73:	8b 45 08             	mov    0x8(%ebp),%eax
  102c76:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102c79:	b8 23 00 00 00       	mov    $0x23,%eax
  102c7e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102c80:	b8 23 00 00 00       	mov    $0x23,%eax
  102c85:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102c87:	b8 10 00 00 00       	mov    $0x10,%eax
  102c8c:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102c8e:	b8 10 00 00 00       	mov    $0x10,%eax
  102c93:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102c95:	b8 10 00 00 00       	mov    $0x10,%eax
  102c9a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102c9c:	ea a3 2c 10 00 08 00 	ljmp   $0x8,$0x102ca3
}
  102ca3:	90                   	nop
  102ca4:	5d                   	pop    %ebp
  102ca5:	c3                   	ret    

00102ca6 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102ca6:	55                   	push   %ebp
  102ca7:	89 e5                	mov    %esp,%ebp
  102ca9:	e8 f8 d5 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  102cae:	05 c2 4c 01 00       	add    $0x14cc2,%eax
    ts.ts_esp0 = esp0;
  102cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  102cb6:	89 90 34 10 00 00    	mov    %edx,0x1034(%eax)
}
  102cbc:	90                   	nop
  102cbd:	5d                   	pop    %ebp
  102cbe:	c3                   	ret    

00102cbf <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102cbf:	55                   	push   %ebp
  102cc0:	89 e5                	mov    %esp,%ebp
  102cc2:	53                   	push   %ebx
  102cc3:	83 ec 10             	sub    $0x10,%esp
  102cc6:	e8 df d5 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  102ccb:	81 c3 a5 4c 01 00    	add    $0x14ca5,%ebx
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102cd1:	c7 c0 00 70 11 00    	mov    $0x117000,%eax
  102cd7:	50                   	push   %eax
  102cd8:	e8 c9 ff ff ff       	call   102ca6 <load_esp0>
  102cdd:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
  102ce0:	66 c7 83 38 10 00 00 	movw   $0x10,0x1038(%ebx)
  102ce7:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102ce9:	66 c7 83 f8 ff ff ff 	movw   $0x68,-0x8(%ebx)
  102cf0:	68 00 
  102cf2:	8d 83 30 10 00 00    	lea    0x1030(%ebx),%eax
  102cf8:	66 89 83 fa ff ff ff 	mov    %ax,-0x6(%ebx)
  102cff:	8d 83 30 10 00 00    	lea    0x1030(%ebx),%eax
  102d05:	c1 e8 10             	shr    $0x10,%eax
  102d08:	88 83 fc ff ff ff    	mov    %al,-0x4(%ebx)
  102d0e:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
  102d15:	83 e0 f0             	and    $0xfffffff0,%eax
  102d18:	83 c8 09             	or     $0x9,%eax
  102d1b:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
  102d21:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
  102d28:	83 e0 ef             	and    $0xffffffef,%eax
  102d2b:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
  102d31:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
  102d38:	83 e0 9f             	and    $0xffffff9f,%eax
  102d3b:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
  102d41:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
  102d48:	83 c8 80             	or     $0xffffff80,%eax
  102d4b:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
  102d51:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
  102d58:	83 e0 f0             	and    $0xfffffff0,%eax
  102d5b:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
  102d61:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
  102d68:	83 e0 ef             	and    $0xffffffef,%eax
  102d6b:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
  102d71:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
  102d78:	83 e0 df             	and    $0xffffffdf,%eax
  102d7b:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
  102d81:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
  102d88:	83 c8 40             	or     $0x40,%eax
  102d8b:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
  102d91:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
  102d98:	83 e0 7f             	and    $0x7f,%eax
  102d9b:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
  102da1:	8d 83 30 10 00 00    	lea    0x1030(%ebx),%eax
  102da7:	c1 e8 18             	shr    $0x18,%eax
  102daa:	88 83 ff ff ff ff    	mov    %al,-0x1(%ebx)

    // reload all segment registers
    lgdt(&gdt_pd);
  102db0:	8d 83 d0 00 00 00    	lea    0xd0(%ebx),%eax
  102db6:	50                   	push   %eax
  102db7:	e8 aa fe ff ff       	call   102c66 <lgdt>
  102dbc:	83 c4 04             	add    $0x4,%esp
  102dbf:	66 c7 45 fa 28 00    	movw   $0x28,-0x6(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102dc5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  102dc9:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102dcc:	90                   	nop
  102dcd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102dd0:	c9                   	leave  
  102dd1:	c3                   	ret    

00102dd2 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102dd2:	55                   	push   %ebp
  102dd3:	89 e5                	mov    %esp,%ebp
  102dd5:	53                   	push   %ebx
  102dd6:	83 ec 04             	sub    $0x4,%esp
  102dd9:	e8 cc d4 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  102dde:	81 c3 92 4b 01 00    	add    $0x14b92,%ebx
    pmm_manager = &default_pmm_manager;
  102de4:	c7 c0 10 8a 11 00    	mov    $0x118a10,%eax
  102dea:	c7 c2 b0 7a 11 00    	mov    $0x117ab0,%edx
  102df0:	89 10                	mov    %edx,(%eax)
    cprintf("memory management: %s\n", pmm_manager->name);
  102df2:	c7 c0 10 8a 11 00    	mov    $0x118a10,%eax
  102df8:	8b 00                	mov    (%eax),%eax
  102dfa:	8b 00                	mov    (%eax),%eax
  102dfc:	83 ec 08             	sub    $0x8,%esp
  102dff:	50                   	push   %eax
  102e00:	8d 83 cc ee fe ff    	lea    -0x11134(%ebx),%eax
  102e06:	50                   	push   %eax
  102e07:	e8 11 d5 ff ff       	call   10031d <cprintf>
  102e0c:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
  102e0f:	c7 c0 10 8a 11 00    	mov    $0x118a10,%eax
  102e15:	8b 00                	mov    (%eax),%eax
  102e17:	8b 40 04             	mov    0x4(%eax),%eax
  102e1a:	ff d0                	call   *%eax
}
  102e1c:	90                   	nop
  102e1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102e20:	c9                   	leave  
  102e21:	c3                   	ret    

00102e22 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102e22:	55                   	push   %ebp
  102e23:	89 e5                	mov    %esp,%ebp
  102e25:	83 ec 08             	sub    $0x8,%esp
  102e28:	e8 79 d4 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  102e2d:	05 43 4b 01 00       	add    $0x14b43,%eax
    pmm_manager->init_memmap(base, n);
  102e32:	c7 c0 10 8a 11 00    	mov    $0x118a10,%eax
  102e38:	8b 00                	mov    (%eax),%eax
  102e3a:	8b 40 08             	mov    0x8(%eax),%eax
  102e3d:	83 ec 08             	sub    $0x8,%esp
  102e40:	ff 75 0c             	pushl  0xc(%ebp)
  102e43:	ff 75 08             	pushl  0x8(%ebp)
  102e46:	ff d0                	call   *%eax
  102e48:	83 c4 10             	add    $0x10,%esp
}
  102e4b:	90                   	nop
  102e4c:	c9                   	leave  
  102e4d:	c3                   	ret    

00102e4e <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102e4e:	55                   	push   %ebp
  102e4f:	89 e5                	mov    %esp,%ebp
  102e51:	53                   	push   %ebx
  102e52:	83 ec 14             	sub    $0x14,%esp
  102e55:	e8 50 d4 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  102e5a:	81 c3 16 4b 01 00    	add    $0x14b16,%ebx
    struct Page *page=NULL;
  102e60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102e67:	e8 99 fd ff ff       	call   102c05 <__intr_save>
  102e6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102e6f:	c7 c0 10 8a 11 00    	mov    $0x118a10,%eax
  102e75:	8b 00                	mov    (%eax),%eax
  102e77:	8b 40 0c             	mov    0xc(%eax),%eax
  102e7a:	83 ec 0c             	sub    $0xc,%esp
  102e7d:	ff 75 08             	pushl  0x8(%ebp)
  102e80:	ff d0                	call   *%eax
  102e82:	83 c4 10             	add    $0x10,%esp
  102e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102e88:	83 ec 0c             	sub    $0xc,%esp
  102e8b:	ff 75 f0             	pushl  -0x10(%ebp)
  102e8e:	e8 ae fd ff ff       	call   102c41 <__intr_restore>
  102e93:	83 c4 10             	add    $0x10,%esp
    return page;
  102e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102e99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102e9c:	c9                   	leave  
  102e9d:	c3                   	ret    

00102e9e <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102e9e:	55                   	push   %ebp
  102e9f:	89 e5                	mov    %esp,%ebp
  102ea1:	53                   	push   %ebx
  102ea2:	83 ec 14             	sub    $0x14,%esp
  102ea5:	e8 00 d4 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  102eaa:	81 c3 c6 4a 01 00    	add    $0x14ac6,%ebx
    bool intr_flag;
    local_intr_save(intr_flag);
  102eb0:	e8 50 fd ff ff       	call   102c05 <__intr_save>
  102eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102eb8:	c7 c0 10 8a 11 00    	mov    $0x118a10,%eax
  102ebe:	8b 00                	mov    (%eax),%eax
  102ec0:	8b 40 10             	mov    0x10(%eax),%eax
  102ec3:	83 ec 08             	sub    $0x8,%esp
  102ec6:	ff 75 0c             	pushl  0xc(%ebp)
  102ec9:	ff 75 08             	pushl  0x8(%ebp)
  102ecc:	ff d0                	call   *%eax
  102ece:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  102ed1:	83 ec 0c             	sub    $0xc,%esp
  102ed4:	ff 75 f4             	pushl  -0xc(%ebp)
  102ed7:	e8 65 fd ff ff       	call   102c41 <__intr_restore>
  102edc:	83 c4 10             	add    $0x10,%esp
}
  102edf:	90                   	nop
  102ee0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102ee3:	c9                   	leave  
  102ee4:	c3                   	ret    

00102ee5 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102ee5:	55                   	push   %ebp
  102ee6:	89 e5                	mov    %esp,%ebp
  102ee8:	53                   	push   %ebx
  102ee9:	83 ec 14             	sub    $0x14,%esp
  102eec:	e8 b9 d3 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  102ef1:	81 c3 7f 4a 01 00    	add    $0x14a7f,%ebx
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102ef7:	e8 09 fd ff ff       	call   102c05 <__intr_save>
  102efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102eff:	c7 c0 10 8a 11 00    	mov    $0x118a10,%eax
  102f05:	8b 00                	mov    (%eax),%eax
  102f07:	8b 40 14             	mov    0x14(%eax),%eax
  102f0a:	ff d0                	call   *%eax
  102f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102f0f:	83 ec 0c             	sub    $0xc,%esp
  102f12:	ff 75 f4             	pushl  -0xc(%ebp)
  102f15:	e8 27 fd ff ff       	call   102c41 <__intr_restore>
  102f1a:	83 c4 10             	add    $0x10,%esp
    return ret;
  102f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102f20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102f23:	c9                   	leave  
  102f24:	c3                   	ret    

00102f25 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102f25:	55                   	push   %ebp
  102f26:	89 e5                	mov    %esp,%ebp
  102f28:	57                   	push   %edi
  102f29:	56                   	push   %esi
  102f2a:	53                   	push   %ebx
  102f2b:	83 ec 7c             	sub    $0x7c,%esp
  102f2e:	e8 d0 14 00 00       	call   104403 <__x86.get_pc_thunk.si>
  102f33:	81 c6 3d 4a 01 00    	add    $0x14a3d,%esi
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102f39:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102f40:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102f47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102f4e:	83 ec 0c             	sub    $0xc,%esp
  102f51:	8d 86 e3 ee fe ff    	lea    -0x1111d(%esi),%eax
  102f57:	50                   	push   %eax
  102f58:	89 f3                	mov    %esi,%ebx
  102f5a:	e8 be d3 ff ff       	call   10031d <cprintf>
  102f5f:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102f62:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f69:	e9 02 01 00 00       	jmp    103070 <page_init+0x14b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102f6e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f71:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f74:	89 d0                	mov    %edx,%eax
  102f76:	c1 e0 02             	shl    $0x2,%eax
  102f79:	01 d0                	add    %edx,%eax
  102f7b:	c1 e0 02             	shl    $0x2,%eax
  102f7e:	01 c8                	add    %ecx,%eax
  102f80:	8b 50 08             	mov    0x8(%eax),%edx
  102f83:	8b 40 04             	mov    0x4(%eax),%eax
  102f86:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102f89:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102f8c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f92:	89 d0                	mov    %edx,%eax
  102f94:	c1 e0 02             	shl    $0x2,%eax
  102f97:	01 d0                	add    %edx,%eax
  102f99:	c1 e0 02             	shl    $0x2,%eax
  102f9c:	01 c8                	add    %ecx,%eax
  102f9e:	8b 48 0c             	mov    0xc(%eax),%ecx
  102fa1:	8b 58 10             	mov    0x10(%eax),%ebx
  102fa4:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102fa7:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102faa:	01 c8                	add    %ecx,%eax
  102fac:	11 da                	adc    %ebx,%edx
  102fae:	89 45 98             	mov    %eax,-0x68(%ebp)
  102fb1:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102fb4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fb7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fba:	89 d0                	mov    %edx,%eax
  102fbc:	c1 e0 02             	shl    $0x2,%eax
  102fbf:	01 d0                	add    %edx,%eax
  102fc1:	c1 e0 02             	shl    $0x2,%eax
  102fc4:	01 c8                	add    %ecx,%eax
  102fc6:	83 c0 14             	add    $0x14,%eax
  102fc9:	8b 00                	mov    (%eax),%eax
  102fcb:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  102fd1:	8b 45 98             	mov    -0x68(%ebp),%eax
  102fd4:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102fd7:	83 c0 ff             	add    $0xffffffff,%eax
  102fda:	83 d2 ff             	adc    $0xffffffff,%edx
  102fdd:	89 c1                	mov    %eax,%ecx
  102fdf:	89 d3                	mov    %edx,%ebx
  102fe1:	8b 7d c4             	mov    -0x3c(%ebp),%edi
  102fe4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fe7:	89 d0                	mov    %edx,%eax
  102fe9:	c1 e0 02             	shl    $0x2,%eax
  102fec:	01 d0                	add    %edx,%eax
  102fee:	c1 e0 02             	shl    $0x2,%eax
  102ff1:	01 f8                	add    %edi,%eax
  102ff3:	8b 50 10             	mov    0x10(%eax),%edx
  102ff6:	8b 40 0c             	mov    0xc(%eax),%eax
  102ff9:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  102fff:	53                   	push   %ebx
  103000:	51                   	push   %ecx
  103001:	ff 75 a4             	pushl  -0x5c(%ebp)
  103004:	ff 75 a0             	pushl  -0x60(%ebp)
  103007:	52                   	push   %edx
  103008:	50                   	push   %eax
  103009:	8d 86 f0 ee fe ff    	lea    -0x11110(%esi),%eax
  10300f:	50                   	push   %eax
  103010:	89 f3                	mov    %esi,%ebx
  103012:	e8 06 d3 ff ff       	call   10031d <cprintf>
  103017:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  10301a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10301d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103020:	89 d0                	mov    %edx,%eax
  103022:	c1 e0 02             	shl    $0x2,%eax
  103025:	01 d0                	add    %edx,%eax
  103027:	c1 e0 02             	shl    $0x2,%eax
  10302a:	01 c8                	add    %ecx,%eax
  10302c:	83 c0 14             	add    $0x14,%eax
  10302f:	8b 00                	mov    (%eax),%eax
  103031:	83 f8 01             	cmp    $0x1,%eax
  103034:	75 36                	jne    10306c <page_init+0x147>
            if (maxpa < end && begin < KMEMSIZE) {
  103036:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103039:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10303c:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  10303f:	77 2b                	ja     10306c <page_init+0x147>
  103041:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  103044:	72 05                	jb     10304b <page_init+0x126>
  103046:	3b 45 98             	cmp    -0x68(%ebp),%eax
  103049:	73 21                	jae    10306c <page_init+0x147>
  10304b:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10304f:	77 1b                	ja     10306c <page_init+0x147>
  103051:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103055:	72 09                	jb     103060 <page_init+0x13b>
  103057:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
  10305e:	77 0c                	ja     10306c <page_init+0x147>
                maxpa = end;
  103060:	8b 45 98             	mov    -0x68(%ebp),%eax
  103063:	8b 55 9c             	mov    -0x64(%ebp),%edx
  103066:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103069:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  10306c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103070:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103073:	8b 00                	mov    (%eax),%eax
  103075:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103078:	0f 8c f0 fe ff ff    	jl     102f6e <page_init+0x49>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  10307e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103082:	72 1d                	jb     1030a1 <page_init+0x17c>
  103084:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103088:	77 09                	ja     103093 <page_init+0x16e>
  10308a:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103091:	76 0e                	jbe    1030a1 <page_init+0x17c>
        maxpa = KMEMSIZE;
  103093:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  10309a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  1030a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1030a7:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1030ab:	c1 ea 0c             	shr    $0xc,%edx
  1030ae:	89 c1                	mov    %eax,%ecx
  1030b0:	89 d3                	mov    %edx,%ebx
  1030b2:	89 c8                	mov    %ecx,%eax
  1030b4:	89 86 10 10 00 00    	mov    %eax,0x1010(%esi)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  1030ba:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  1030c1:	c7 c0 28 8a 11 00    	mov    $0x118a28,%eax
  1030c7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030ca:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1030cd:	01 d0                	add    %edx,%eax
  1030cf:	89 45 bc             	mov    %eax,-0x44(%ebp)
  1030d2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1030d5:	ba 00 00 00 00       	mov    $0x0,%edx
  1030da:	f7 75 c0             	divl   -0x40(%ebp)
  1030dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1030e0:	29 d0                	sub    %edx,%eax
  1030e2:	89 c2                	mov    %eax,%edx
  1030e4:	c7 c0 18 8a 11 00    	mov    $0x118a18,%eax
  1030ea:	89 10                	mov    %edx,(%eax)

    for (i = 0; i < npage; i ++) {
  1030ec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1030f3:	eb 31                	jmp    103126 <page_init+0x201>
        SetPageReserved(pages + i);
  1030f5:	c7 c0 18 8a 11 00    	mov    $0x118a18,%eax
  1030fb:	8b 08                	mov    (%eax),%ecx
  1030fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103100:	89 d0                	mov    %edx,%eax
  103102:	c1 e0 02             	shl    $0x2,%eax
  103105:	01 d0                	add    %edx,%eax
  103107:	c1 e0 02             	shl    $0x2,%eax
  10310a:	01 c8                	add    %ecx,%eax
  10310c:	83 c0 04             	add    $0x4,%eax
  10310f:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  103116:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103119:	8b 45 90             	mov    -0x70(%ebp),%eax
  10311c:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10311f:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
  103122:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103126:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103129:	8b 86 10 10 00 00    	mov    0x1010(%esi),%eax
  10312f:	39 c2                	cmp    %eax,%edx
  103131:	72 c2                	jb     1030f5 <page_init+0x1d0>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103133:	8b 96 10 10 00 00    	mov    0x1010(%esi),%edx
  103139:	89 d0                	mov    %edx,%eax
  10313b:	c1 e0 02             	shl    $0x2,%eax
  10313e:	01 d0                	add    %edx,%eax
  103140:	c1 e0 02             	shl    $0x2,%eax
  103143:	89 c2                	mov    %eax,%edx
  103145:	c7 c0 18 8a 11 00    	mov    $0x118a18,%eax
  10314b:	8b 00                	mov    (%eax),%eax
  10314d:	01 d0                	add    %edx,%eax
  10314f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103152:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  103159:	77 1d                	ja     103178 <page_init+0x253>
  10315b:	ff 75 b8             	pushl  -0x48(%ebp)
  10315e:	8d 86 20 ef fe ff    	lea    -0x110e0(%esi),%eax
  103164:	50                   	push   %eax
  103165:	68 db 00 00 00       	push   $0xdb
  10316a:	8d 86 44 ef fe ff    	lea    -0x110bc(%esi),%eax
  103170:	50                   	push   %eax
  103171:	89 f3                	mov    %esi,%ebx
  103173:	e8 55 d3 ff ff       	call   1004cd <__panic>
  103178:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10317b:	05 00 00 00 40       	add    $0x40000000,%eax
  103180:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103183:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10318a:	e9 79 01 00 00       	jmp    103308 <page_init+0x3e3>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10318f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103192:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103195:	89 d0                	mov    %edx,%eax
  103197:	c1 e0 02             	shl    $0x2,%eax
  10319a:	01 d0                	add    %edx,%eax
  10319c:	c1 e0 02             	shl    $0x2,%eax
  10319f:	01 c8                	add    %ecx,%eax
  1031a1:	8b 50 08             	mov    0x8(%eax),%edx
  1031a4:	8b 40 04             	mov    0x4(%eax),%eax
  1031a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1031aa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1031ad:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1031b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031b3:	89 d0                	mov    %edx,%eax
  1031b5:	c1 e0 02             	shl    $0x2,%eax
  1031b8:	01 d0                	add    %edx,%eax
  1031ba:	c1 e0 02             	shl    $0x2,%eax
  1031bd:	01 c8                	add    %ecx,%eax
  1031bf:	8b 48 0c             	mov    0xc(%eax),%ecx
  1031c2:	8b 58 10             	mov    0x10(%eax),%ebx
  1031c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1031c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1031cb:	01 c8                	add    %ecx,%eax
  1031cd:	11 da                	adc    %ebx,%edx
  1031cf:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1031d2:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  1031d5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1031d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031db:	89 d0                	mov    %edx,%eax
  1031dd:	c1 e0 02             	shl    $0x2,%eax
  1031e0:	01 d0                	add    %edx,%eax
  1031e2:	c1 e0 02             	shl    $0x2,%eax
  1031e5:	01 c8                	add    %ecx,%eax
  1031e7:	83 c0 14             	add    $0x14,%eax
  1031ea:	8b 00                	mov    (%eax),%eax
  1031ec:	83 f8 01             	cmp    $0x1,%eax
  1031ef:	0f 85 0f 01 00 00    	jne    103304 <page_init+0x3df>
            if (begin < freemem) {
  1031f5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1031f8:	ba 00 00 00 00       	mov    $0x0,%edx
  1031fd:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  103200:	77 17                	ja     103219 <page_init+0x2f4>
  103202:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  103205:	72 05                	jb     10320c <page_init+0x2e7>
  103207:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10320a:	73 0d                	jae    103219 <page_init+0x2f4>
                begin = freemem;
  10320c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10320f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103212:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103219:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10321d:	72 1d                	jb     10323c <page_init+0x317>
  10321f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103223:	77 09                	ja     10322e <page_init+0x309>
  103225:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  10322c:	76 0e                	jbe    10323c <page_init+0x317>
                end = KMEMSIZE;
  10322e:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103235:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10323c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10323f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103242:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103245:	0f 87 b9 00 00 00    	ja     103304 <page_init+0x3df>
  10324b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10324e:	72 09                	jb     103259 <page_init+0x334>
  103250:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103253:	0f 83 ab 00 00 00    	jae    103304 <page_init+0x3df>
                begin = ROUNDUP(begin, PGSIZE);
  103259:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  103260:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103263:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103266:	01 d0                	add    %edx,%eax
  103268:	83 e8 01             	sub    $0x1,%eax
  10326b:	89 45 ac             	mov    %eax,-0x54(%ebp)
  10326e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103271:	ba 00 00 00 00       	mov    $0x0,%edx
  103276:	f7 75 b0             	divl   -0x50(%ebp)
  103279:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10327c:	29 d0                	sub    %edx,%eax
  10327e:	ba 00 00 00 00       	mov    $0x0,%edx
  103283:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103286:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  103289:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10328c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  10328f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103292:	ba 00 00 00 00       	mov    $0x0,%edx
  103297:	89 c7                	mov    %eax,%edi
  103299:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  10329f:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1032a2:	89 d0                	mov    %edx,%eax
  1032a4:	83 e0 00             	and    $0x0,%eax
  1032a7:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1032aa:	8b 45 80             	mov    -0x80(%ebp),%eax
  1032ad:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1032b0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1032b3:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1032b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1032b9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1032bc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1032bf:	77 43                	ja     103304 <page_init+0x3df>
  1032c1:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1032c4:	72 05                	jb     1032cb <page_init+0x3a6>
  1032c6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1032c9:	73 39                	jae    103304 <page_init+0x3df>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1032cb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1032ce:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1032d1:	2b 45 d0             	sub    -0x30(%ebp),%eax
  1032d4:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  1032d7:	89 c3                	mov    %eax,%ebx
  1032d9:	89 d6                	mov    %edx,%esi
  1032db:	89 d8                	mov    %ebx,%eax
  1032dd:	89 f2                	mov    %esi,%edx
  1032df:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1032e3:	c1 ea 0c             	shr    $0xc,%edx
  1032e6:	89 c3                	mov    %eax,%ebx
  1032e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1032eb:	83 ec 0c             	sub    $0xc,%esp
  1032ee:	50                   	push   %eax
  1032ef:	e8 b6 f7 ff ff       	call   102aaa <pa2page>
  1032f4:	83 c4 10             	add    $0x10,%esp
  1032f7:	83 ec 08             	sub    $0x8,%esp
  1032fa:	53                   	push   %ebx
  1032fb:	50                   	push   %eax
  1032fc:	e8 21 fb ff ff       	call   102e22 <init_memmap>
  103301:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i ++) {
  103304:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103308:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10330b:	8b 00                	mov    (%eax),%eax
  10330d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103310:	0f 8c 79 fe ff ff    	jl     10318f <page_init+0x26a>
                }
            }
        }
    }
}
  103316:	90                   	nop
  103317:	8d 65 f4             	lea    -0xc(%ebp),%esp
  10331a:	5b                   	pop    %ebx
  10331b:	5e                   	pop    %esi
  10331c:	5f                   	pop    %edi
  10331d:	5d                   	pop    %ebp
  10331e:	c3                   	ret    

0010331f <enable_paging>:

static void
enable_paging(void) {
  10331f:	55                   	push   %ebp
  103320:	89 e5                	mov    %esp,%ebp
  103322:	83 ec 10             	sub    $0x10,%esp
  103325:	e8 7c cf ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  10332a:	05 46 46 01 00       	add    $0x14646,%eax
    lcr3(boot_cr3);
  10332f:	c7 c0 14 8a 11 00    	mov    $0x118a14,%eax
  103335:	8b 00                	mov    (%eax),%eax
  103337:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  10333a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10333d:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  103340:	0f 20 c0             	mov    %cr0,%eax
  103343:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  103346:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  103349:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  10334c:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  103353:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  103357:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10335a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  10335d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103360:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  103363:	90                   	nop
  103364:	c9                   	leave  
  103365:	c3                   	ret    

00103366 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103366:	55                   	push   %ebp
  103367:	89 e5                	mov    %esp,%ebp
  103369:	53                   	push   %ebx
  10336a:	83 ec 24             	sub    $0x24,%esp
  10336d:	e8 38 cf ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  103372:	81 c3 fe 45 01 00    	add    $0x145fe,%ebx
    assert(PGOFF(la) == PGOFF(pa));
  103378:	8b 45 0c             	mov    0xc(%ebp),%eax
  10337b:	33 45 14             	xor    0x14(%ebp),%eax
  10337e:	25 ff 0f 00 00       	and    $0xfff,%eax
  103383:	85 c0                	test   %eax,%eax
  103385:	74 1f                	je     1033a6 <boot_map_segment+0x40>
  103387:	8d 83 52 ef fe ff    	lea    -0x110ae(%ebx),%eax
  10338d:	50                   	push   %eax
  10338e:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103394:	50                   	push   %eax
  103395:	68 04 01 00 00       	push   $0x104
  10339a:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  1033a0:	50                   	push   %eax
  1033a1:	e8 27 d1 ff ff       	call   1004cd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1033a6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1033ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033b0:	25 ff 0f 00 00       	and    $0xfff,%eax
  1033b5:	89 c2                	mov    %eax,%edx
  1033b7:	8b 45 10             	mov    0x10(%ebp),%eax
  1033ba:	01 c2                	add    %eax,%edx
  1033bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033bf:	01 d0                	add    %edx,%eax
  1033c1:	83 e8 01             	sub    $0x1,%eax
  1033c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033ca:	ba 00 00 00 00       	mov    $0x0,%edx
  1033cf:	f7 75 f0             	divl   -0x10(%ebp)
  1033d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033d5:	29 d0                	sub    %edx,%eax
  1033d7:	c1 e8 0c             	shr    $0xc,%eax
  1033da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1033dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1033eb:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1033ee:	8b 45 14             	mov    0x14(%ebp),%eax
  1033f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1033f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1033fc:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1033ff:	eb 5d                	jmp    10345e <boot_map_segment+0xf8>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103401:	83 ec 04             	sub    $0x4,%esp
  103404:	6a 01                	push   $0x1
  103406:	ff 75 0c             	pushl  0xc(%ebp)
  103409:	ff 75 08             	pushl  0x8(%ebp)
  10340c:	e8 d7 01 00 00       	call   1035e8 <get_pte>
  103411:	83 c4 10             	add    $0x10,%esp
  103414:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103417:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10341b:	75 1f                	jne    10343c <boot_map_segment+0xd6>
  10341d:	8d 83 7e ef fe ff    	lea    -0x11082(%ebx),%eax
  103423:	50                   	push   %eax
  103424:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  10342a:	50                   	push   %eax
  10342b:	68 0a 01 00 00       	push   $0x10a
  103430:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103436:	50                   	push   %eax
  103437:	e8 91 d0 ff ff       	call   1004cd <__panic>
        *ptep = pa | PTE_P | perm;
  10343c:	8b 45 14             	mov    0x14(%ebp),%eax
  10343f:	0b 45 18             	or     0x18(%ebp),%eax
  103442:	83 c8 01             	or     $0x1,%eax
  103445:	89 c2                	mov    %eax,%edx
  103447:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10344a:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10344c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103450:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  103457:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10345e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103462:	75 9d                	jne    103401 <boot_map_segment+0x9b>
    }
}
  103464:	90                   	nop
  103465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  103468:	c9                   	leave  
  103469:	c3                   	ret    

0010346a <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10346a:	55                   	push   %ebp
  10346b:	89 e5                	mov    %esp,%ebp
  10346d:	53                   	push   %ebx
  10346e:	83 ec 14             	sub    $0x14,%esp
  103471:	e8 34 ce ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  103476:	81 c3 fa 44 01 00    	add    $0x144fa,%ebx
    struct Page *p = alloc_page();
  10347c:	83 ec 0c             	sub    $0xc,%esp
  10347f:	6a 01                	push   $0x1
  103481:	e8 c8 f9 ff ff       	call   102e4e <alloc_pages>
  103486:	83 c4 10             	add    $0x10,%esp
  103489:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10348c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103490:	75 1b                	jne    1034ad <boot_alloc_page+0x43>
        panic("boot_alloc_page failed.\n");
  103492:	83 ec 04             	sub    $0x4,%esp
  103495:	8d 83 8b ef fe ff    	lea    -0x11075(%ebx),%eax
  10349b:	50                   	push   %eax
  10349c:	68 16 01 00 00       	push   $0x116
  1034a1:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  1034a7:	50                   	push   %eax
  1034a8:	e8 20 d0 ff ff       	call   1004cd <__panic>
    }
    return page2kva(p);
  1034ad:	83 ec 0c             	sub    $0xc,%esp
  1034b0:	ff 75 f4             	pushl  -0xc(%ebp)
  1034b3:	e8 50 f6 ff ff       	call   102b08 <page2kva>
  1034b8:	83 c4 10             	add    $0x10,%esp
}
  1034bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1034be:	c9                   	leave  
  1034bf:	c3                   	ret    

001034c0 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1034c0:	55                   	push   %ebp
  1034c1:	89 e5                	mov    %esp,%ebp
  1034c3:	53                   	push   %ebx
  1034c4:	83 ec 14             	sub    $0x14,%esp
  1034c7:	e8 de cd ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  1034cc:	81 c3 a4 44 01 00    	add    $0x144a4,%ebx
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1034d2:	e8 fb f8 ff ff       	call   102dd2 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1034d7:	e8 49 fa ff ff       	call   102f25 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1034dc:	e8 e2 02 00 00       	call   1037c3 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1034e1:	e8 84 ff ff ff       	call   10346a <boot_alloc_page>
  1034e6:	89 83 14 10 00 00    	mov    %eax,0x1014(%ebx)
    memset(boot_pgdir, 0, PGSIZE);
  1034ec:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  1034f2:	83 ec 04             	sub    $0x4,%esp
  1034f5:	68 00 10 00 00       	push   $0x1000
  1034fa:	6a 00                	push   $0x0
  1034fc:	50                   	push   %eax
  1034fd:	e8 18 24 00 00       	call   10591a <memset>
  103502:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
  103505:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  10350b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10350e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103515:	77 1b                	ja     103532 <pmm_init+0x72>
  103517:	ff 75 f4             	pushl  -0xc(%ebp)
  10351a:	8d 83 20 ef fe ff    	lea    -0x110e0(%ebx),%eax
  103520:	50                   	push   %eax
  103521:	68 30 01 00 00       	push   $0x130
  103526:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  10352c:	50                   	push   %eax
  10352d:	e8 9b cf ff ff       	call   1004cd <__panic>
  103532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103535:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  10353b:	c7 c0 14 8a 11 00    	mov    $0x118a14,%eax
  103541:	89 10                	mov    %edx,(%eax)

    check_pgdir();
  103543:	e8 b2 02 00 00       	call   1037fa <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103548:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  10354e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103551:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103558:	77 1b                	ja     103575 <pmm_init+0xb5>
  10355a:	ff 75 f0             	pushl  -0x10(%ebp)
  10355d:	8d 83 20 ef fe ff    	lea    -0x110e0(%ebx),%eax
  103563:	50                   	push   %eax
  103564:	68 38 01 00 00       	push   $0x138
  103569:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  10356f:	50                   	push   %eax
  103570:	e8 58 cf ff ff       	call   1004cd <__panic>
  103575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103578:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  10357e:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103584:	05 ac 0f 00 00       	add    $0xfac,%eax
  103589:	83 ca 03             	or     $0x3,%edx
  10358c:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10358e:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103594:	83 ec 0c             	sub    $0xc,%esp
  103597:	6a 02                	push   $0x2
  103599:	6a 00                	push   $0x0
  10359b:	68 00 00 00 38       	push   $0x38000000
  1035a0:	68 00 00 00 c0       	push   $0xc0000000
  1035a5:	50                   	push   %eax
  1035a6:	e8 bb fd ff ff       	call   103366 <boot_map_segment>
  1035ab:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1035ae:	8b 93 14 10 00 00    	mov    0x1014(%ebx),%edx
  1035b4:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  1035ba:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1035c0:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1035c2:	e8 58 fd ff ff       	call   10331f <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1035c7:	e8 f3 f6 ff ff       	call   102cbf <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1035cc:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  1035d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1035d8:	e8 41 08 00 00       	call   103e1e <check_boot_pgdir>

    print_pgdir();
  1035dd:	e8 b4 0c 00 00       	call   104296 <print_pgdir>

}
  1035e2:	90                   	nop
  1035e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1035e6:	c9                   	leave  
  1035e7:	c3                   	ret    

001035e8 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1035e8:	55                   	push   %ebp
  1035e9:	89 e5                	mov    %esp,%ebp
  1035eb:	e8 b6 cc ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1035f0:	05 80 43 01 00       	add    $0x14380,%eax
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  1035f5:	90                   	nop
  1035f6:	5d                   	pop    %ebp
  1035f7:	c3                   	ret    

001035f8 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1035f8:	55                   	push   %ebp
  1035f9:	89 e5                	mov    %esp,%ebp
  1035fb:	83 ec 18             	sub    $0x18,%esp
  1035fe:	e8 a3 cc ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  103603:	05 6d 43 01 00       	add    $0x1436d,%eax
    pte_t *ptep = get_pte(pgdir, la, 0);
  103608:	6a 00                	push   $0x0
  10360a:	ff 75 0c             	pushl  0xc(%ebp)
  10360d:	ff 75 08             	pushl  0x8(%ebp)
  103610:	e8 d3 ff ff ff       	call   1035e8 <get_pte>
  103615:	83 c4 0c             	add    $0xc,%esp
  103618:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10361b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10361f:	74 08                	je     103629 <get_page+0x31>
        *ptep_store = ptep;
  103621:	8b 45 10             	mov    0x10(%ebp),%eax
  103624:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103627:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103629:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10362d:	74 1f                	je     10364e <get_page+0x56>
  10362f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103632:	8b 00                	mov    (%eax),%eax
  103634:	83 e0 01             	and    $0x1,%eax
  103637:	85 c0                	test   %eax,%eax
  103639:	74 13                	je     10364e <get_page+0x56>
        return pa2page(*ptep);
  10363b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10363e:	8b 00                	mov    (%eax),%eax
  103640:	83 ec 0c             	sub    $0xc,%esp
  103643:	50                   	push   %eax
  103644:	e8 61 f4 ff ff       	call   102aaa <pa2page>
  103649:	83 c4 10             	add    $0x10,%esp
  10364c:	eb 05                	jmp    103653 <get_page+0x5b>
    }
    return NULL;
  10364e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103653:	c9                   	leave  
  103654:	c3                   	ret    

00103655 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  103655:	55                   	push   %ebp
  103656:	89 e5                	mov    %esp,%ebp
  103658:	e8 49 cc ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  10365d:	05 13 43 01 00       	add    $0x14313,%eax
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  103662:	90                   	nop
  103663:	5d                   	pop    %ebp
  103664:	c3                   	ret    

00103665 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  103665:	55                   	push   %ebp
  103666:	89 e5                	mov    %esp,%ebp
  103668:	83 ec 10             	sub    $0x10,%esp
  10366b:	e8 36 cc ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  103670:	05 00 43 01 00       	add    $0x14300,%eax
    pte_t *ptep = get_pte(pgdir, la, 0);
  103675:	6a 00                	push   $0x0
  103677:	ff 75 0c             	pushl  0xc(%ebp)
  10367a:	ff 75 08             	pushl  0x8(%ebp)
  10367d:	e8 66 ff ff ff       	call   1035e8 <get_pte>
  103682:	83 c4 0c             	add    $0xc,%esp
  103685:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  103688:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10368c:	74 11                	je     10369f <page_remove+0x3a>
        page_remove_pte(pgdir, la, ptep);
  10368e:	ff 75 fc             	pushl  -0x4(%ebp)
  103691:	ff 75 0c             	pushl  0xc(%ebp)
  103694:	ff 75 08             	pushl  0x8(%ebp)
  103697:	e8 b9 ff ff ff       	call   103655 <page_remove_pte>
  10369c:	83 c4 0c             	add    $0xc,%esp
    }
}
  10369f:	90                   	nop
  1036a0:	c9                   	leave  
  1036a1:	c3                   	ret    

001036a2 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1036a2:	55                   	push   %ebp
  1036a3:	89 e5                	mov    %esp,%ebp
  1036a5:	83 ec 18             	sub    $0x18,%esp
  1036a8:	e8 f9 cb ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1036ad:	05 c3 42 01 00       	add    $0x142c3,%eax
    pte_t *ptep = get_pte(pgdir, la, 1);
  1036b2:	6a 01                	push   $0x1
  1036b4:	ff 75 10             	pushl  0x10(%ebp)
  1036b7:	ff 75 08             	pushl  0x8(%ebp)
  1036ba:	e8 29 ff ff ff       	call   1035e8 <get_pte>
  1036bf:	83 c4 0c             	add    $0xc,%esp
  1036c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1036c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1036c9:	75 0a                	jne    1036d5 <page_insert+0x33>
        return -E_NO_MEM;
  1036cb:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1036d0:	e9 88 00 00 00       	jmp    10375d <page_insert+0xbb>
    }
    page_ref_inc(page);
  1036d5:	ff 75 0c             	pushl  0xc(%ebp)
  1036d8:	e8 e6 f4 ff ff       	call   102bc3 <page_ref_inc>
  1036dd:	83 c4 04             	add    $0x4,%esp
    if (*ptep & PTE_P) {
  1036e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036e3:	8b 00                	mov    (%eax),%eax
  1036e5:	83 e0 01             	and    $0x1,%eax
  1036e8:	85 c0                	test   %eax,%eax
  1036ea:	74 40                	je     10372c <page_insert+0x8a>
        struct Page *p = pte2page(*ptep);
  1036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036ef:	8b 00                	mov    (%eax),%eax
  1036f1:	83 ec 0c             	sub    $0xc,%esp
  1036f4:	50                   	push   %eax
  1036f5:	e8 67 f4 ff ff       	call   102b61 <pte2page>
  1036fa:	83 c4 10             	add    $0x10,%esp
  1036fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  103700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103703:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103706:	75 10                	jne    103718 <page_insert+0x76>
            page_ref_dec(page);
  103708:	83 ec 0c             	sub    $0xc,%esp
  10370b:	ff 75 0c             	pushl  0xc(%ebp)
  10370e:	e8 d1 f4 ff ff       	call   102be4 <page_ref_dec>
  103713:	83 c4 10             	add    $0x10,%esp
  103716:	eb 14                	jmp    10372c <page_insert+0x8a>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103718:	83 ec 04             	sub    $0x4,%esp
  10371b:	ff 75 f4             	pushl  -0xc(%ebp)
  10371e:	ff 75 10             	pushl  0x10(%ebp)
  103721:	ff 75 08             	pushl  0x8(%ebp)
  103724:	e8 2c ff ff ff       	call   103655 <page_remove_pte>
  103729:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10372c:	83 ec 0c             	sub    $0xc,%esp
  10372f:	ff 75 0c             	pushl  0xc(%ebp)
  103732:	e8 56 f3 ff ff       	call   102a8d <page2pa>
  103737:	83 c4 10             	add    $0x10,%esp
  10373a:	0b 45 14             	or     0x14(%ebp),%eax
  10373d:	83 c8 01             	or     $0x1,%eax
  103740:	89 c2                	mov    %eax,%edx
  103742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103745:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103747:	83 ec 08             	sub    $0x8,%esp
  10374a:	ff 75 10             	pushl  0x10(%ebp)
  10374d:	ff 75 08             	pushl  0x8(%ebp)
  103750:	e8 0a 00 00 00       	call   10375f <tlb_invalidate>
  103755:	83 c4 10             	add    $0x10,%esp
    return 0;
  103758:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10375d:	c9                   	leave  
  10375e:	c3                   	ret    

0010375f <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10375f:	55                   	push   %ebp
  103760:	89 e5                	mov    %esp,%ebp
  103762:	53                   	push   %ebx
  103763:	83 ec 14             	sub    $0x14,%esp
  103766:	e8 3b cb ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  10376b:	05 05 42 01 00       	add    $0x14205,%eax
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103770:	0f 20 da             	mov    %cr3,%edx
  103773:	89 55 f0             	mov    %edx,-0x10(%ebp)
    return cr3;
  103776:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    if (rcr3() == PADDR(pgdir)) {
  103779:	8b 55 08             	mov    0x8(%ebp),%edx
  10377c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10377f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103786:	77 1d                	ja     1037a5 <tlb_invalidate+0x46>
  103788:	ff 75 f4             	pushl  -0xc(%ebp)
  10378b:	8d 90 20 ef fe ff    	lea    -0x110e0(%eax),%edx
  103791:	52                   	push   %edx
  103792:	68 d8 01 00 00       	push   $0x1d8
  103797:	8d 90 44 ef fe ff    	lea    -0x110bc(%eax),%edx
  10379d:	52                   	push   %edx
  10379e:	89 c3                	mov    %eax,%ebx
  1037a0:	e8 28 cd ff ff       	call   1004cd <__panic>
  1037a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037a8:	05 00 00 00 40       	add    $0x40000000,%eax
  1037ad:	39 c8                	cmp    %ecx,%eax
  1037af:	75 0c                	jne    1037bd <tlb_invalidate+0x5e>
        invlpg((void *)la);
  1037b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1037b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037ba:	0f 01 38             	invlpg (%eax)
    }
}
  1037bd:	90                   	nop
  1037be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1037c1:	c9                   	leave  
  1037c2:	c3                   	ret    

001037c3 <check_alloc_page>:

static void
check_alloc_page(void) {
  1037c3:	55                   	push   %ebp
  1037c4:	89 e5                	mov    %esp,%ebp
  1037c6:	53                   	push   %ebx
  1037c7:	83 ec 04             	sub    $0x4,%esp
  1037ca:	e8 db ca ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  1037cf:	81 c3 a1 41 01 00    	add    $0x141a1,%ebx
    pmm_manager->check();
  1037d5:	c7 c0 10 8a 11 00    	mov    $0x118a10,%eax
  1037db:	8b 00                	mov    (%eax),%eax
  1037dd:	8b 40 18             	mov    0x18(%eax),%eax
  1037e0:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1037e2:	83 ec 0c             	sub    $0xc,%esp
  1037e5:	8d 83 a4 ef fe ff    	lea    -0x1105c(%ebx),%eax
  1037eb:	50                   	push   %eax
  1037ec:	e8 2c cb ff ff       	call   10031d <cprintf>
  1037f1:	83 c4 10             	add    $0x10,%esp
}
  1037f4:	90                   	nop
  1037f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1037f8:	c9                   	leave  
  1037f9:	c3                   	ret    

001037fa <check_pgdir>:

static void
check_pgdir(void) {
  1037fa:	55                   	push   %ebp
  1037fb:	89 e5                	mov    %esp,%ebp
  1037fd:	53                   	push   %ebx
  1037fe:	83 ec 24             	sub    $0x24,%esp
  103801:	e8 a4 ca ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  103806:	81 c3 6a 41 01 00    	add    $0x1416a,%ebx
    assert(npage <= KMEMSIZE / PGSIZE);
  10380c:	8b 83 10 10 00 00    	mov    0x1010(%ebx),%eax
  103812:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103817:	76 1f                	jbe    103838 <check_pgdir+0x3e>
  103819:	8d 83 c3 ef fe ff    	lea    -0x1103d(%ebx),%eax
  10381f:	50                   	push   %eax
  103820:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103826:	50                   	push   %eax
  103827:	68 e5 01 00 00       	push   $0x1e5
  10382c:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103832:	50                   	push   %eax
  103833:	e8 95 cc ff ff       	call   1004cd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103838:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  10383e:	85 c0                	test   %eax,%eax
  103840:	74 0f                	je     103851 <check_pgdir+0x57>
  103842:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103848:	25 ff 0f 00 00       	and    $0xfff,%eax
  10384d:	85 c0                	test   %eax,%eax
  10384f:	74 1f                	je     103870 <check_pgdir+0x76>
  103851:	8d 83 e0 ef fe ff    	lea    -0x11020(%ebx),%eax
  103857:	50                   	push   %eax
  103858:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  10385e:	50                   	push   %eax
  10385f:	68 e6 01 00 00       	push   $0x1e6
  103864:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  10386a:	50                   	push   %eax
  10386b:	e8 5d cc ff ff       	call   1004cd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103870:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103876:	83 ec 04             	sub    $0x4,%esp
  103879:	6a 00                	push   $0x0
  10387b:	6a 00                	push   $0x0
  10387d:	50                   	push   %eax
  10387e:	e8 75 fd ff ff       	call   1035f8 <get_page>
  103883:	83 c4 10             	add    $0x10,%esp
  103886:	85 c0                	test   %eax,%eax
  103888:	74 1f                	je     1038a9 <check_pgdir+0xaf>
  10388a:	8d 83 18 f0 fe ff    	lea    -0x10fe8(%ebx),%eax
  103890:	50                   	push   %eax
  103891:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103897:	50                   	push   %eax
  103898:	68 e7 01 00 00       	push   $0x1e7
  10389d:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  1038a3:	50                   	push   %eax
  1038a4:	e8 24 cc ff ff       	call   1004cd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1038a9:	83 ec 0c             	sub    $0xc,%esp
  1038ac:	6a 01                	push   $0x1
  1038ae:	e8 9b f5 ff ff       	call   102e4e <alloc_pages>
  1038b3:	83 c4 10             	add    $0x10,%esp
  1038b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1038b9:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  1038bf:	6a 00                	push   $0x0
  1038c1:	6a 00                	push   $0x0
  1038c3:	ff 75 f4             	pushl  -0xc(%ebp)
  1038c6:	50                   	push   %eax
  1038c7:	e8 d6 fd ff ff       	call   1036a2 <page_insert>
  1038cc:	83 c4 10             	add    $0x10,%esp
  1038cf:	85 c0                	test   %eax,%eax
  1038d1:	74 1f                	je     1038f2 <check_pgdir+0xf8>
  1038d3:	8d 83 40 f0 fe ff    	lea    -0x10fc0(%ebx),%eax
  1038d9:	50                   	push   %eax
  1038da:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  1038e0:	50                   	push   %eax
  1038e1:	68 eb 01 00 00       	push   $0x1eb
  1038e6:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  1038ec:	50                   	push   %eax
  1038ed:	e8 db cb ff ff       	call   1004cd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1038f2:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  1038f8:	83 ec 04             	sub    $0x4,%esp
  1038fb:	6a 00                	push   $0x0
  1038fd:	6a 00                	push   $0x0
  1038ff:	50                   	push   %eax
  103900:	e8 e3 fc ff ff       	call   1035e8 <get_pte>
  103905:	83 c4 10             	add    $0x10,%esp
  103908:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10390b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10390f:	75 1f                	jne    103930 <check_pgdir+0x136>
  103911:	8d 83 6c f0 fe ff    	lea    -0x10f94(%ebx),%eax
  103917:	50                   	push   %eax
  103918:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  10391e:	50                   	push   %eax
  10391f:	68 ee 01 00 00       	push   $0x1ee
  103924:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  10392a:	50                   	push   %eax
  10392b:	e8 9d cb ff ff       	call   1004cd <__panic>
    assert(pa2page(*ptep) == p1);
  103930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103933:	8b 00                	mov    (%eax),%eax
  103935:	83 ec 0c             	sub    $0xc,%esp
  103938:	50                   	push   %eax
  103939:	e8 6c f1 ff ff       	call   102aaa <pa2page>
  10393e:	83 c4 10             	add    $0x10,%esp
  103941:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103944:	74 1f                	je     103965 <check_pgdir+0x16b>
  103946:	8d 83 99 f0 fe ff    	lea    -0x10f67(%ebx),%eax
  10394c:	50                   	push   %eax
  10394d:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103953:	50                   	push   %eax
  103954:	68 ef 01 00 00       	push   $0x1ef
  103959:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  10395f:	50                   	push   %eax
  103960:	e8 68 cb ff ff       	call   1004cd <__panic>
    assert(page_ref(p1) == 1);
  103965:	83 ec 0c             	sub    $0xc,%esp
  103968:	ff 75 f4             	pushl  -0xc(%ebp)
  10396b:	e8 3f f2 ff ff       	call   102baf <page_ref>
  103970:	83 c4 10             	add    $0x10,%esp
  103973:	83 f8 01             	cmp    $0x1,%eax
  103976:	74 1f                	je     103997 <check_pgdir+0x19d>
  103978:	8d 83 ae f0 fe ff    	lea    -0x10f52(%ebx),%eax
  10397e:	50                   	push   %eax
  10397f:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103985:	50                   	push   %eax
  103986:	68 f0 01 00 00       	push   $0x1f0
  10398b:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103991:	50                   	push   %eax
  103992:	e8 36 cb ff ff       	call   1004cd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103997:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  10399d:	8b 00                	mov    (%eax),%eax
  10399f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1039a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1039a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039aa:	c1 e8 0c             	shr    $0xc,%eax
  1039ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1039b0:	8b 83 10 10 00 00    	mov    0x1010(%ebx),%eax
  1039b6:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1039b9:	72 1b                	jb     1039d6 <check_pgdir+0x1dc>
  1039bb:	ff 75 ec             	pushl  -0x14(%ebp)
  1039be:	8d 83 7c ee fe ff    	lea    -0x11184(%ebx),%eax
  1039c4:	50                   	push   %eax
  1039c5:	68 f2 01 00 00       	push   $0x1f2
  1039ca:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  1039d0:	50                   	push   %eax
  1039d1:	e8 f7 ca ff ff       	call   1004cd <__panic>
  1039d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039d9:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1039de:	83 c0 04             	add    $0x4,%eax
  1039e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1039e4:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  1039ea:	83 ec 04             	sub    $0x4,%esp
  1039ed:	6a 00                	push   $0x0
  1039ef:	68 00 10 00 00       	push   $0x1000
  1039f4:	50                   	push   %eax
  1039f5:	e8 ee fb ff ff       	call   1035e8 <get_pte>
  1039fa:	83 c4 10             	add    $0x10,%esp
  1039fd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103a00:	74 1f                	je     103a21 <check_pgdir+0x227>
  103a02:	8d 83 c0 f0 fe ff    	lea    -0x10f40(%ebx),%eax
  103a08:	50                   	push   %eax
  103a09:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103a0f:	50                   	push   %eax
  103a10:	68 f3 01 00 00       	push   $0x1f3
  103a15:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103a1b:	50                   	push   %eax
  103a1c:	e8 ac ca ff ff       	call   1004cd <__panic>

    p2 = alloc_page();
  103a21:	83 ec 0c             	sub    $0xc,%esp
  103a24:	6a 01                	push   $0x1
  103a26:	e8 23 f4 ff ff       	call   102e4e <alloc_pages>
  103a2b:	83 c4 10             	add    $0x10,%esp
  103a2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103a31:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103a37:	6a 06                	push   $0x6
  103a39:	68 00 10 00 00       	push   $0x1000
  103a3e:	ff 75 e4             	pushl  -0x1c(%ebp)
  103a41:	50                   	push   %eax
  103a42:	e8 5b fc ff ff       	call   1036a2 <page_insert>
  103a47:	83 c4 10             	add    $0x10,%esp
  103a4a:	85 c0                	test   %eax,%eax
  103a4c:	74 1f                	je     103a6d <check_pgdir+0x273>
  103a4e:	8d 83 e8 f0 fe ff    	lea    -0x10f18(%ebx),%eax
  103a54:	50                   	push   %eax
  103a55:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103a5b:	50                   	push   %eax
  103a5c:	68 f6 01 00 00       	push   $0x1f6
  103a61:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103a67:	50                   	push   %eax
  103a68:	e8 60 ca ff ff       	call   1004cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103a6d:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103a73:	83 ec 04             	sub    $0x4,%esp
  103a76:	6a 00                	push   $0x0
  103a78:	68 00 10 00 00       	push   $0x1000
  103a7d:	50                   	push   %eax
  103a7e:	e8 65 fb ff ff       	call   1035e8 <get_pte>
  103a83:	83 c4 10             	add    $0x10,%esp
  103a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a8d:	75 1f                	jne    103aae <check_pgdir+0x2b4>
  103a8f:	8d 83 20 f1 fe ff    	lea    -0x10ee0(%ebx),%eax
  103a95:	50                   	push   %eax
  103a96:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103a9c:	50                   	push   %eax
  103a9d:	68 f7 01 00 00       	push   $0x1f7
  103aa2:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103aa8:	50                   	push   %eax
  103aa9:	e8 1f ca ff ff       	call   1004cd <__panic>
    assert(*ptep & PTE_U);
  103aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ab1:	8b 00                	mov    (%eax),%eax
  103ab3:	83 e0 04             	and    $0x4,%eax
  103ab6:	85 c0                	test   %eax,%eax
  103ab8:	75 1f                	jne    103ad9 <check_pgdir+0x2df>
  103aba:	8d 83 50 f1 fe ff    	lea    -0x10eb0(%ebx),%eax
  103ac0:	50                   	push   %eax
  103ac1:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103ac7:	50                   	push   %eax
  103ac8:	68 f8 01 00 00       	push   $0x1f8
  103acd:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103ad3:	50                   	push   %eax
  103ad4:	e8 f4 c9 ff ff       	call   1004cd <__panic>
    assert(*ptep & PTE_W);
  103ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103adc:	8b 00                	mov    (%eax),%eax
  103ade:	83 e0 02             	and    $0x2,%eax
  103ae1:	85 c0                	test   %eax,%eax
  103ae3:	75 1f                	jne    103b04 <check_pgdir+0x30a>
  103ae5:	8d 83 5e f1 fe ff    	lea    -0x10ea2(%ebx),%eax
  103aeb:	50                   	push   %eax
  103aec:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103af2:	50                   	push   %eax
  103af3:	68 f9 01 00 00       	push   $0x1f9
  103af8:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103afe:	50                   	push   %eax
  103aff:	e8 c9 c9 ff ff       	call   1004cd <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103b04:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103b0a:	8b 00                	mov    (%eax),%eax
  103b0c:	83 e0 04             	and    $0x4,%eax
  103b0f:	85 c0                	test   %eax,%eax
  103b11:	75 1f                	jne    103b32 <check_pgdir+0x338>
  103b13:	8d 83 6c f1 fe ff    	lea    -0x10e94(%ebx),%eax
  103b19:	50                   	push   %eax
  103b1a:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103b20:	50                   	push   %eax
  103b21:	68 fa 01 00 00       	push   $0x1fa
  103b26:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103b2c:	50                   	push   %eax
  103b2d:	e8 9b c9 ff ff       	call   1004cd <__panic>
    assert(page_ref(p2) == 1);
  103b32:	83 ec 0c             	sub    $0xc,%esp
  103b35:	ff 75 e4             	pushl  -0x1c(%ebp)
  103b38:	e8 72 f0 ff ff       	call   102baf <page_ref>
  103b3d:	83 c4 10             	add    $0x10,%esp
  103b40:	83 f8 01             	cmp    $0x1,%eax
  103b43:	74 1f                	je     103b64 <check_pgdir+0x36a>
  103b45:	8d 83 82 f1 fe ff    	lea    -0x10e7e(%ebx),%eax
  103b4b:	50                   	push   %eax
  103b4c:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103b52:	50                   	push   %eax
  103b53:	68 fb 01 00 00       	push   $0x1fb
  103b58:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103b5e:	50                   	push   %eax
  103b5f:	e8 69 c9 ff ff       	call   1004cd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103b64:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103b6a:	6a 00                	push   $0x0
  103b6c:	68 00 10 00 00       	push   $0x1000
  103b71:	ff 75 f4             	pushl  -0xc(%ebp)
  103b74:	50                   	push   %eax
  103b75:	e8 28 fb ff ff       	call   1036a2 <page_insert>
  103b7a:	83 c4 10             	add    $0x10,%esp
  103b7d:	85 c0                	test   %eax,%eax
  103b7f:	74 1f                	je     103ba0 <check_pgdir+0x3a6>
  103b81:	8d 83 94 f1 fe ff    	lea    -0x10e6c(%ebx),%eax
  103b87:	50                   	push   %eax
  103b88:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103b8e:	50                   	push   %eax
  103b8f:	68 fd 01 00 00       	push   $0x1fd
  103b94:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103b9a:	50                   	push   %eax
  103b9b:	e8 2d c9 ff ff       	call   1004cd <__panic>
    assert(page_ref(p1) == 2);
  103ba0:	83 ec 0c             	sub    $0xc,%esp
  103ba3:	ff 75 f4             	pushl  -0xc(%ebp)
  103ba6:	e8 04 f0 ff ff       	call   102baf <page_ref>
  103bab:	83 c4 10             	add    $0x10,%esp
  103bae:	83 f8 02             	cmp    $0x2,%eax
  103bb1:	74 1f                	je     103bd2 <check_pgdir+0x3d8>
  103bb3:	8d 83 c0 f1 fe ff    	lea    -0x10e40(%ebx),%eax
  103bb9:	50                   	push   %eax
  103bba:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103bc0:	50                   	push   %eax
  103bc1:	68 fe 01 00 00       	push   $0x1fe
  103bc6:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103bcc:	50                   	push   %eax
  103bcd:	e8 fb c8 ff ff       	call   1004cd <__panic>
    assert(page_ref(p2) == 0);
  103bd2:	83 ec 0c             	sub    $0xc,%esp
  103bd5:	ff 75 e4             	pushl  -0x1c(%ebp)
  103bd8:	e8 d2 ef ff ff       	call   102baf <page_ref>
  103bdd:	83 c4 10             	add    $0x10,%esp
  103be0:	85 c0                	test   %eax,%eax
  103be2:	74 1f                	je     103c03 <check_pgdir+0x409>
  103be4:	8d 83 d2 f1 fe ff    	lea    -0x10e2e(%ebx),%eax
  103bea:	50                   	push   %eax
  103beb:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103bf1:	50                   	push   %eax
  103bf2:	68 ff 01 00 00       	push   $0x1ff
  103bf7:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103bfd:	50                   	push   %eax
  103bfe:	e8 ca c8 ff ff       	call   1004cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103c03:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103c09:	83 ec 04             	sub    $0x4,%esp
  103c0c:	6a 00                	push   $0x0
  103c0e:	68 00 10 00 00       	push   $0x1000
  103c13:	50                   	push   %eax
  103c14:	e8 cf f9 ff ff       	call   1035e8 <get_pte>
  103c19:	83 c4 10             	add    $0x10,%esp
  103c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c23:	75 1f                	jne    103c44 <check_pgdir+0x44a>
  103c25:	8d 83 20 f1 fe ff    	lea    -0x10ee0(%ebx),%eax
  103c2b:	50                   	push   %eax
  103c2c:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103c32:	50                   	push   %eax
  103c33:	68 00 02 00 00       	push   $0x200
  103c38:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103c3e:	50                   	push   %eax
  103c3f:	e8 89 c8 ff ff       	call   1004cd <__panic>
    assert(pa2page(*ptep) == p1);
  103c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c47:	8b 00                	mov    (%eax),%eax
  103c49:	83 ec 0c             	sub    $0xc,%esp
  103c4c:	50                   	push   %eax
  103c4d:	e8 58 ee ff ff       	call   102aaa <pa2page>
  103c52:	83 c4 10             	add    $0x10,%esp
  103c55:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103c58:	74 1f                	je     103c79 <check_pgdir+0x47f>
  103c5a:	8d 83 99 f0 fe ff    	lea    -0x10f67(%ebx),%eax
  103c60:	50                   	push   %eax
  103c61:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103c67:	50                   	push   %eax
  103c68:	68 01 02 00 00       	push   $0x201
  103c6d:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103c73:	50                   	push   %eax
  103c74:	e8 54 c8 ff ff       	call   1004cd <__panic>
    assert((*ptep & PTE_U) == 0);
  103c79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c7c:	8b 00                	mov    (%eax),%eax
  103c7e:	83 e0 04             	and    $0x4,%eax
  103c81:	85 c0                	test   %eax,%eax
  103c83:	74 1f                	je     103ca4 <check_pgdir+0x4aa>
  103c85:	8d 83 e4 f1 fe ff    	lea    -0x10e1c(%ebx),%eax
  103c8b:	50                   	push   %eax
  103c8c:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103c92:	50                   	push   %eax
  103c93:	68 02 02 00 00       	push   $0x202
  103c98:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103c9e:	50                   	push   %eax
  103c9f:	e8 29 c8 ff ff       	call   1004cd <__panic>

    page_remove(boot_pgdir, 0x0);
  103ca4:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103caa:	83 ec 08             	sub    $0x8,%esp
  103cad:	6a 00                	push   $0x0
  103caf:	50                   	push   %eax
  103cb0:	e8 b0 f9 ff ff       	call   103665 <page_remove>
  103cb5:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
  103cb8:	83 ec 0c             	sub    $0xc,%esp
  103cbb:	ff 75 f4             	pushl  -0xc(%ebp)
  103cbe:	e8 ec ee ff ff       	call   102baf <page_ref>
  103cc3:	83 c4 10             	add    $0x10,%esp
  103cc6:	83 f8 01             	cmp    $0x1,%eax
  103cc9:	74 1f                	je     103cea <check_pgdir+0x4f0>
  103ccb:	8d 83 ae f0 fe ff    	lea    -0x10f52(%ebx),%eax
  103cd1:	50                   	push   %eax
  103cd2:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103cd8:	50                   	push   %eax
  103cd9:	68 05 02 00 00       	push   $0x205
  103cde:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103ce4:	50                   	push   %eax
  103ce5:	e8 e3 c7 ff ff       	call   1004cd <__panic>
    assert(page_ref(p2) == 0);
  103cea:	83 ec 0c             	sub    $0xc,%esp
  103ced:	ff 75 e4             	pushl  -0x1c(%ebp)
  103cf0:	e8 ba ee ff ff       	call   102baf <page_ref>
  103cf5:	83 c4 10             	add    $0x10,%esp
  103cf8:	85 c0                	test   %eax,%eax
  103cfa:	74 1f                	je     103d1b <check_pgdir+0x521>
  103cfc:	8d 83 d2 f1 fe ff    	lea    -0x10e2e(%ebx),%eax
  103d02:	50                   	push   %eax
  103d03:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103d09:	50                   	push   %eax
  103d0a:	68 06 02 00 00       	push   $0x206
  103d0f:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103d15:	50                   	push   %eax
  103d16:	e8 b2 c7 ff ff       	call   1004cd <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103d1b:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103d21:	83 ec 08             	sub    $0x8,%esp
  103d24:	68 00 10 00 00       	push   $0x1000
  103d29:	50                   	push   %eax
  103d2a:	e8 36 f9 ff ff       	call   103665 <page_remove>
  103d2f:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
  103d32:	83 ec 0c             	sub    $0xc,%esp
  103d35:	ff 75 f4             	pushl  -0xc(%ebp)
  103d38:	e8 72 ee ff ff       	call   102baf <page_ref>
  103d3d:	83 c4 10             	add    $0x10,%esp
  103d40:	85 c0                	test   %eax,%eax
  103d42:	74 1f                	je     103d63 <check_pgdir+0x569>
  103d44:	8d 83 f9 f1 fe ff    	lea    -0x10e07(%ebx),%eax
  103d4a:	50                   	push   %eax
  103d4b:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103d51:	50                   	push   %eax
  103d52:	68 09 02 00 00       	push   $0x209
  103d57:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103d5d:	50                   	push   %eax
  103d5e:	e8 6a c7 ff ff       	call   1004cd <__panic>
    assert(page_ref(p2) == 0);
  103d63:	83 ec 0c             	sub    $0xc,%esp
  103d66:	ff 75 e4             	pushl  -0x1c(%ebp)
  103d69:	e8 41 ee ff ff       	call   102baf <page_ref>
  103d6e:	83 c4 10             	add    $0x10,%esp
  103d71:	85 c0                	test   %eax,%eax
  103d73:	74 1f                	je     103d94 <check_pgdir+0x59a>
  103d75:	8d 83 d2 f1 fe ff    	lea    -0x10e2e(%ebx),%eax
  103d7b:	50                   	push   %eax
  103d7c:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103d82:	50                   	push   %eax
  103d83:	68 0a 02 00 00       	push   $0x20a
  103d88:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103d8e:	50                   	push   %eax
  103d8f:	e8 39 c7 ff ff       	call   1004cd <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  103d94:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103d9a:	8b 00                	mov    (%eax),%eax
  103d9c:	83 ec 0c             	sub    $0xc,%esp
  103d9f:	50                   	push   %eax
  103da0:	e8 05 ed ff ff       	call   102aaa <pa2page>
  103da5:	83 c4 10             	add    $0x10,%esp
  103da8:	83 ec 0c             	sub    $0xc,%esp
  103dab:	50                   	push   %eax
  103dac:	e8 fe ed ff ff       	call   102baf <page_ref>
  103db1:	83 c4 10             	add    $0x10,%esp
  103db4:	83 f8 01             	cmp    $0x1,%eax
  103db7:	74 1f                	je     103dd8 <check_pgdir+0x5de>
  103db9:	8d 83 0c f2 fe ff    	lea    -0x10df4(%ebx),%eax
  103dbf:	50                   	push   %eax
  103dc0:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103dc6:	50                   	push   %eax
  103dc7:	68 0c 02 00 00       	push   $0x20c
  103dcc:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103dd2:	50                   	push   %eax
  103dd3:	e8 f5 c6 ff ff       	call   1004cd <__panic>
    free_page(pa2page(boot_pgdir[0]));
  103dd8:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103dde:	8b 00                	mov    (%eax),%eax
  103de0:	83 ec 0c             	sub    $0xc,%esp
  103de3:	50                   	push   %eax
  103de4:	e8 c1 ec ff ff       	call   102aaa <pa2page>
  103de9:	83 c4 10             	add    $0x10,%esp
  103dec:	83 ec 08             	sub    $0x8,%esp
  103def:	6a 01                	push   $0x1
  103df1:	50                   	push   %eax
  103df2:	e8 a7 f0 ff ff       	call   102e9e <free_pages>
  103df7:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103dfa:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103e00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103e06:	83 ec 0c             	sub    $0xc,%esp
  103e09:	8d 83 32 f2 fe ff    	lea    -0x10dce(%ebx),%eax
  103e0f:	50                   	push   %eax
  103e10:	e8 08 c5 ff ff       	call   10031d <cprintf>
  103e15:	83 c4 10             	add    $0x10,%esp
}
  103e18:	90                   	nop
  103e19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  103e1c:	c9                   	leave  
  103e1d:	c3                   	ret    

00103e1e <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103e1e:	55                   	push   %ebp
  103e1f:	89 e5                	mov    %esp,%ebp
  103e21:	53                   	push   %ebx
  103e22:	83 ec 24             	sub    $0x24,%esp
  103e25:	e8 80 c4 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  103e2a:	81 c3 46 3b 01 00    	add    $0x13b46,%ebx
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103e30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103e37:	e9 b5 00 00 00       	jmp    103ef1 <check_boot_pgdir+0xd3>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103e42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103e45:	c1 e8 0c             	shr    $0xc,%eax
  103e48:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103e4b:	8b 83 10 10 00 00    	mov    0x1010(%ebx),%eax
  103e51:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103e54:	72 1b                	jb     103e71 <check_boot_pgdir+0x53>
  103e56:	ff 75 e4             	pushl  -0x1c(%ebp)
  103e59:	8d 83 7c ee fe ff    	lea    -0x11184(%ebx),%eax
  103e5f:	50                   	push   %eax
  103e60:	68 18 02 00 00       	push   $0x218
  103e65:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103e6b:	50                   	push   %eax
  103e6c:	e8 5c c6 ff ff       	call   1004cd <__panic>
  103e71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103e74:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103e79:	89 c2                	mov    %eax,%edx
  103e7b:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103e81:	83 ec 04             	sub    $0x4,%esp
  103e84:	6a 00                	push   $0x0
  103e86:	52                   	push   %edx
  103e87:	50                   	push   %eax
  103e88:	e8 5b f7 ff ff       	call   1035e8 <get_pte>
  103e8d:	83 c4 10             	add    $0x10,%esp
  103e90:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103e93:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103e97:	75 1f                	jne    103eb8 <check_boot_pgdir+0x9a>
  103e99:	8d 83 4c f2 fe ff    	lea    -0x10db4(%ebx),%eax
  103e9f:	50                   	push   %eax
  103ea0:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103ea6:	50                   	push   %eax
  103ea7:	68 18 02 00 00       	push   $0x218
  103eac:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103eb2:	50                   	push   %eax
  103eb3:	e8 15 c6 ff ff       	call   1004cd <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103eb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103ebb:	8b 00                	mov    (%eax),%eax
  103ebd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103ec2:	89 c2                	mov    %eax,%edx
  103ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ec7:	39 c2                	cmp    %eax,%edx
  103ec9:	74 1f                	je     103eea <check_boot_pgdir+0xcc>
  103ecb:	8d 83 89 f2 fe ff    	lea    -0x10d77(%ebx),%eax
  103ed1:	50                   	push   %eax
  103ed2:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103ed8:	50                   	push   %eax
  103ed9:	68 19 02 00 00       	push   $0x219
  103ede:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103ee4:	50                   	push   %eax
  103ee5:	e8 e3 c5 ff ff       	call   1004cd <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103eea:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103ef1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103ef4:	8b 83 10 10 00 00    	mov    0x1010(%ebx),%eax
  103efa:	39 c2                	cmp    %eax,%edx
  103efc:	0f 82 3a ff ff ff    	jb     103e3c <check_boot_pgdir+0x1e>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103f02:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103f08:	05 ac 0f 00 00       	add    $0xfac,%eax
  103f0d:	8b 00                	mov    (%eax),%eax
  103f0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103f14:	89 c2                	mov    %eax,%edx
  103f16:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103f1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103f1f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103f26:	77 1b                	ja     103f43 <check_boot_pgdir+0x125>
  103f28:	ff 75 f0             	pushl  -0x10(%ebp)
  103f2b:	8d 83 20 ef fe ff    	lea    -0x110e0(%ebx),%eax
  103f31:	50                   	push   %eax
  103f32:	68 1c 02 00 00       	push   $0x21c
  103f37:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103f3d:	50                   	push   %eax
  103f3e:	e8 8a c5 ff ff       	call   1004cd <__panic>
  103f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f46:	05 00 00 00 40       	add    $0x40000000,%eax
  103f4b:	39 d0                	cmp    %edx,%eax
  103f4d:	74 1f                	je     103f6e <check_boot_pgdir+0x150>
  103f4f:	8d 83 a0 f2 fe ff    	lea    -0x10d60(%ebx),%eax
  103f55:	50                   	push   %eax
  103f56:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103f5c:	50                   	push   %eax
  103f5d:	68 1c 02 00 00       	push   $0x21c
  103f62:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103f68:	50                   	push   %eax
  103f69:	e8 5f c5 ff ff       	call   1004cd <__panic>

    assert(boot_pgdir[0] == 0);
  103f6e:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103f74:	8b 00                	mov    (%eax),%eax
  103f76:	85 c0                	test   %eax,%eax
  103f78:	74 1f                	je     103f99 <check_boot_pgdir+0x17b>
  103f7a:	8d 83 d4 f2 fe ff    	lea    -0x10d2c(%ebx),%eax
  103f80:	50                   	push   %eax
  103f81:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103f87:	50                   	push   %eax
  103f88:	68 1e 02 00 00       	push   $0x21e
  103f8d:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103f93:	50                   	push   %eax
  103f94:	e8 34 c5 ff ff       	call   1004cd <__panic>

    struct Page *p;
    p = alloc_page();
  103f99:	83 ec 0c             	sub    $0xc,%esp
  103f9c:	6a 01                	push   $0x1
  103f9e:	e8 ab ee ff ff       	call   102e4e <alloc_pages>
  103fa3:	83 c4 10             	add    $0x10,%esp
  103fa6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103fa9:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  103faf:	6a 02                	push   $0x2
  103fb1:	68 00 01 00 00       	push   $0x100
  103fb6:	ff 75 ec             	pushl  -0x14(%ebp)
  103fb9:	50                   	push   %eax
  103fba:	e8 e3 f6 ff ff       	call   1036a2 <page_insert>
  103fbf:	83 c4 10             	add    $0x10,%esp
  103fc2:	85 c0                	test   %eax,%eax
  103fc4:	74 1f                	je     103fe5 <check_boot_pgdir+0x1c7>
  103fc6:	8d 83 e8 f2 fe ff    	lea    -0x10d18(%ebx),%eax
  103fcc:	50                   	push   %eax
  103fcd:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  103fd3:	50                   	push   %eax
  103fd4:	68 22 02 00 00       	push   $0x222
  103fd9:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  103fdf:	50                   	push   %eax
  103fe0:	e8 e8 c4 ff ff       	call   1004cd <__panic>
    assert(page_ref(p) == 1);
  103fe5:	83 ec 0c             	sub    $0xc,%esp
  103fe8:	ff 75 ec             	pushl  -0x14(%ebp)
  103feb:	e8 bf eb ff ff       	call   102baf <page_ref>
  103ff0:	83 c4 10             	add    $0x10,%esp
  103ff3:	83 f8 01             	cmp    $0x1,%eax
  103ff6:	74 1f                	je     104017 <check_boot_pgdir+0x1f9>
  103ff8:	8d 83 16 f3 fe ff    	lea    -0x10cea(%ebx),%eax
  103ffe:	50                   	push   %eax
  103fff:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  104005:	50                   	push   %eax
  104006:	68 23 02 00 00       	push   $0x223
  10400b:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  104011:	50                   	push   %eax
  104012:	e8 b6 c4 ff ff       	call   1004cd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104017:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  10401d:	6a 02                	push   $0x2
  10401f:	68 00 11 00 00       	push   $0x1100
  104024:	ff 75 ec             	pushl  -0x14(%ebp)
  104027:	50                   	push   %eax
  104028:	e8 75 f6 ff ff       	call   1036a2 <page_insert>
  10402d:	83 c4 10             	add    $0x10,%esp
  104030:	85 c0                	test   %eax,%eax
  104032:	74 1f                	je     104053 <check_boot_pgdir+0x235>
  104034:	8d 83 28 f3 fe ff    	lea    -0x10cd8(%ebx),%eax
  10403a:	50                   	push   %eax
  10403b:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  104041:	50                   	push   %eax
  104042:	68 24 02 00 00       	push   $0x224
  104047:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  10404d:	50                   	push   %eax
  10404e:	e8 7a c4 ff ff       	call   1004cd <__panic>
    assert(page_ref(p) == 2);
  104053:	83 ec 0c             	sub    $0xc,%esp
  104056:	ff 75 ec             	pushl  -0x14(%ebp)
  104059:	e8 51 eb ff ff       	call   102baf <page_ref>
  10405e:	83 c4 10             	add    $0x10,%esp
  104061:	83 f8 02             	cmp    $0x2,%eax
  104064:	74 1f                	je     104085 <check_boot_pgdir+0x267>
  104066:	8d 83 5f f3 fe ff    	lea    -0x10ca1(%ebx),%eax
  10406c:	50                   	push   %eax
  10406d:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  104073:	50                   	push   %eax
  104074:	68 25 02 00 00       	push   $0x225
  104079:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  10407f:	50                   	push   %eax
  104080:	e8 48 c4 ff ff       	call   1004cd <__panic>

    const char *str = "ucore: Hello world!!";
  104085:	8d 83 70 f3 fe ff    	lea    -0x10c90(%ebx),%eax
  10408b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    strcpy((void *)0x100, str);
  10408e:	83 ec 08             	sub    $0x8,%esp
  104091:	ff 75 e8             	pushl  -0x18(%ebp)
  104094:	68 00 01 00 00       	push   $0x100
  104099:	e8 5d 15 00 00       	call   1055fb <strcpy>
  10409e:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1040a1:	83 ec 08             	sub    $0x8,%esp
  1040a4:	68 00 11 00 00       	push   $0x1100
  1040a9:	68 00 01 00 00       	push   $0x100
  1040ae:	e8 d6 15 00 00       	call   105689 <strcmp>
  1040b3:	83 c4 10             	add    $0x10,%esp
  1040b6:	85 c0                	test   %eax,%eax
  1040b8:	74 1f                	je     1040d9 <check_boot_pgdir+0x2bb>
  1040ba:	8d 83 88 f3 fe ff    	lea    -0x10c78(%ebx),%eax
  1040c0:	50                   	push   %eax
  1040c1:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  1040c7:	50                   	push   %eax
  1040c8:	68 29 02 00 00       	push   $0x229
  1040cd:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  1040d3:	50                   	push   %eax
  1040d4:	e8 f4 c3 ff ff       	call   1004cd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1040d9:	83 ec 0c             	sub    $0xc,%esp
  1040dc:	ff 75 ec             	pushl  -0x14(%ebp)
  1040df:	e8 24 ea ff ff       	call   102b08 <page2kva>
  1040e4:	83 c4 10             	add    $0x10,%esp
  1040e7:	05 00 01 00 00       	add    $0x100,%eax
  1040ec:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1040ef:	83 ec 0c             	sub    $0xc,%esp
  1040f2:	68 00 01 00 00       	push   $0x100
  1040f7:	e8 93 14 00 00       	call   10558f <strlen>
  1040fc:	83 c4 10             	add    $0x10,%esp
  1040ff:	85 c0                	test   %eax,%eax
  104101:	74 1f                	je     104122 <check_boot_pgdir+0x304>
  104103:	8d 83 c0 f3 fe ff    	lea    -0x10c40(%ebx),%eax
  104109:	50                   	push   %eax
  10410a:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
  104110:	50                   	push   %eax
  104111:	68 2c 02 00 00       	push   $0x22c
  104116:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
  10411c:	50                   	push   %eax
  10411d:	e8 ab c3 ff ff       	call   1004cd <__panic>

    free_page(p);
  104122:	83 ec 08             	sub    $0x8,%esp
  104125:	6a 01                	push   $0x1
  104127:	ff 75 ec             	pushl  -0x14(%ebp)
  10412a:	e8 6f ed ff ff       	call   102e9e <free_pages>
  10412f:	83 c4 10             	add    $0x10,%esp
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  104132:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  104138:	8b 00                	mov    (%eax),%eax
  10413a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10413f:	83 ec 0c             	sub    $0xc,%esp
  104142:	50                   	push   %eax
  104143:	e8 62 e9 ff ff       	call   102aaa <pa2page>
  104148:	83 c4 10             	add    $0x10,%esp
  10414b:	83 ec 08             	sub    $0x8,%esp
  10414e:	6a 01                	push   $0x1
  104150:	50                   	push   %eax
  104151:	e8 48 ed ff ff       	call   102e9e <free_pages>
  104156:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  104159:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
  10415f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104165:	83 ec 0c             	sub    $0xc,%esp
  104168:	8d 83 e4 f3 fe ff    	lea    -0x10c1c(%ebx),%eax
  10416e:	50                   	push   %eax
  10416f:	e8 a9 c1 ff ff       	call   10031d <cprintf>
  104174:	83 c4 10             	add    $0x10,%esp
}
  104177:	90                   	nop
  104178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10417b:	c9                   	leave  
  10417c:	c3                   	ret    

0010417d <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  10417d:	55                   	push   %ebp
  10417e:	89 e5                	mov    %esp,%ebp
  104180:	e8 21 c1 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  104185:	05 eb 37 01 00       	add    $0x137eb,%eax
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  10418a:	8b 55 08             	mov    0x8(%ebp),%edx
  10418d:	83 e2 04             	and    $0x4,%edx
  104190:	85 d2                	test   %edx,%edx
  104192:	74 07                	je     10419b <perm2str+0x1e>
  104194:	ba 75 00 00 00       	mov    $0x75,%edx
  104199:	eb 05                	jmp    1041a0 <perm2str+0x23>
  10419b:	ba 2d 00 00 00       	mov    $0x2d,%edx
  1041a0:	88 90 98 10 00 00    	mov    %dl,0x1098(%eax)
    str[1] = 'r';
  1041a6:	c6 80 99 10 00 00 72 	movb   $0x72,0x1099(%eax)
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1041ad:	8b 55 08             	mov    0x8(%ebp),%edx
  1041b0:	83 e2 02             	and    $0x2,%edx
  1041b3:	85 d2                	test   %edx,%edx
  1041b5:	74 07                	je     1041be <perm2str+0x41>
  1041b7:	ba 77 00 00 00       	mov    $0x77,%edx
  1041bc:	eb 05                	jmp    1041c3 <perm2str+0x46>
  1041be:	ba 2d 00 00 00       	mov    $0x2d,%edx
  1041c3:	88 90 9a 10 00 00    	mov    %dl,0x109a(%eax)
    str[3] = '\0';
  1041c9:	c6 80 9b 10 00 00 00 	movb   $0x0,0x109b(%eax)
    return str;
  1041d0:	8d 80 98 10 00 00    	lea    0x1098(%eax),%eax
}
  1041d6:	5d                   	pop    %ebp
  1041d7:	c3                   	ret    

001041d8 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1041d8:	55                   	push   %ebp
  1041d9:	89 e5                	mov    %esp,%ebp
  1041db:	83 ec 10             	sub    $0x10,%esp
  1041de:	e8 c3 c0 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1041e3:	05 8d 37 01 00       	add    $0x1378d,%eax
    if (start >= right) {
  1041e8:	8b 45 10             	mov    0x10(%ebp),%eax
  1041eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1041ee:	72 0e                	jb     1041fe <get_pgtable_items+0x26>
        return 0;
  1041f0:	b8 00 00 00 00       	mov    $0x0,%eax
  1041f5:	e9 9a 00 00 00       	jmp    104294 <get_pgtable_items+0xbc>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  1041fa:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  1041fe:	8b 45 10             	mov    0x10(%ebp),%eax
  104201:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104204:	73 18                	jae    10421e <get_pgtable_items+0x46>
  104206:	8b 45 10             	mov    0x10(%ebp),%eax
  104209:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104210:	8b 45 14             	mov    0x14(%ebp),%eax
  104213:	01 d0                	add    %edx,%eax
  104215:	8b 00                	mov    (%eax),%eax
  104217:	83 e0 01             	and    $0x1,%eax
  10421a:	85 c0                	test   %eax,%eax
  10421c:	74 dc                	je     1041fa <get_pgtable_items+0x22>
    }
    if (start < right) {
  10421e:	8b 45 10             	mov    0x10(%ebp),%eax
  104221:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104224:	73 69                	jae    10428f <get_pgtable_items+0xb7>
        if (left_store != NULL) {
  104226:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10422a:	74 08                	je     104234 <get_pgtable_items+0x5c>
            *left_store = start;
  10422c:	8b 45 18             	mov    0x18(%ebp),%eax
  10422f:	8b 55 10             	mov    0x10(%ebp),%edx
  104232:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  104234:	8b 45 10             	mov    0x10(%ebp),%eax
  104237:	8d 50 01             	lea    0x1(%eax),%edx
  10423a:	89 55 10             	mov    %edx,0x10(%ebp)
  10423d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104244:	8b 45 14             	mov    0x14(%ebp),%eax
  104247:	01 d0                	add    %edx,%eax
  104249:	8b 00                	mov    (%eax),%eax
  10424b:	83 e0 07             	and    $0x7,%eax
  10424e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104251:	eb 04                	jmp    104257 <get_pgtable_items+0x7f>
            start ++;
  104253:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104257:	8b 45 10             	mov    0x10(%ebp),%eax
  10425a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10425d:	73 1d                	jae    10427c <get_pgtable_items+0xa4>
  10425f:	8b 45 10             	mov    0x10(%ebp),%eax
  104262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104269:	8b 45 14             	mov    0x14(%ebp),%eax
  10426c:	01 d0                	add    %edx,%eax
  10426e:	8b 00                	mov    (%eax),%eax
  104270:	83 e0 07             	and    $0x7,%eax
  104273:	89 c2                	mov    %eax,%edx
  104275:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104278:	39 c2                	cmp    %eax,%edx
  10427a:	74 d7                	je     104253 <get_pgtable_items+0x7b>
        }
        if (right_store != NULL) {
  10427c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  104280:	74 08                	je     10428a <get_pgtable_items+0xb2>
            *right_store = start;
  104282:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104285:	8b 55 10             	mov    0x10(%ebp),%edx
  104288:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  10428a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10428d:	eb 05                	jmp    104294 <get_pgtable_items+0xbc>
    }
    return 0;
  10428f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104294:	c9                   	leave  
  104295:	c3                   	ret    

00104296 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104296:	55                   	push   %ebp
  104297:	89 e5                	mov    %esp,%ebp
  104299:	57                   	push   %edi
  10429a:	56                   	push   %esi
  10429b:	53                   	push   %ebx
  10429c:	83 ec 3c             	sub    $0x3c,%esp
  10429f:	e8 06 c0 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  1042a4:	81 c3 cc 36 01 00    	add    $0x136cc,%ebx
    cprintf("-------------------- BEGIN --------------------\n");
  1042aa:	83 ec 0c             	sub    $0xc,%esp
  1042ad:	8d 83 04 f4 fe ff    	lea    -0x10bfc(%ebx),%eax
  1042b3:	50                   	push   %eax
  1042b4:	e8 64 c0 ff ff       	call   10031d <cprintf>
  1042b9:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
  1042bc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1042c3:	e9 ef 00 00 00       	jmp    1043b7 <print_pgdir+0x121>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1042c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1042cb:	83 ec 0c             	sub    $0xc,%esp
  1042ce:	50                   	push   %eax
  1042cf:	e8 a9 fe ff ff       	call   10417d <perm2str>
  1042d4:	83 c4 10             	add    $0x10,%esp
  1042d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1042da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1042dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1042e0:	29 c2                	sub    %eax,%edx
  1042e2:	89 d0                	mov    %edx,%eax
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1042e4:	89 c6                	mov    %eax,%esi
  1042e6:	c1 e6 16             	shl    $0x16,%esi
  1042e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1042ec:	89 c1                	mov    %eax,%ecx
  1042ee:	c1 e1 16             	shl    $0x16,%ecx
  1042f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1042f4:	89 c2                	mov    %eax,%edx
  1042f6:	c1 e2 16             	shl    $0x16,%edx
  1042f9:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1042fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1042ff:	29 c7                	sub    %eax,%edi
  104301:	89 f8                	mov    %edi,%eax
  104303:	83 ec 08             	sub    $0x8,%esp
  104306:	ff 75 c4             	pushl  -0x3c(%ebp)
  104309:	56                   	push   %esi
  10430a:	51                   	push   %ecx
  10430b:	52                   	push   %edx
  10430c:	50                   	push   %eax
  10430d:	8d 83 35 f4 fe ff    	lea    -0x10bcb(%ebx),%eax
  104313:	50                   	push   %eax
  104314:	e8 04 c0 ff ff       	call   10031d <cprintf>
  104319:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
  10431c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10431f:	c1 e0 0a             	shl    $0xa,%eax
  104322:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104325:	eb 54                	jmp    10437b <print_pgdir+0xe5>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104327:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10432a:	83 ec 0c             	sub    $0xc,%esp
  10432d:	50                   	push   %eax
  10432e:	e8 4a fe ff ff       	call   10417d <perm2str>
  104333:	83 c4 10             	add    $0x10,%esp
  104336:	89 45 c4             	mov    %eax,-0x3c(%ebp)
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104339:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10433c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10433f:	29 c2                	sub    %eax,%edx
  104341:	89 d0                	mov    %edx,%eax
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104343:	89 c6                	mov    %eax,%esi
  104345:	c1 e6 0c             	shl    $0xc,%esi
  104348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10434b:	89 c1                	mov    %eax,%ecx
  10434d:	c1 e1 0c             	shl    $0xc,%ecx
  104350:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104353:	89 c2                	mov    %eax,%edx
  104355:	c1 e2 0c             	shl    $0xc,%edx
  104358:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10435b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10435e:	29 c7                	sub    %eax,%edi
  104360:	89 f8                	mov    %edi,%eax
  104362:	83 ec 08             	sub    $0x8,%esp
  104365:	ff 75 c4             	pushl  -0x3c(%ebp)
  104368:	56                   	push   %esi
  104369:	51                   	push   %ecx
  10436a:	52                   	push   %edx
  10436b:	50                   	push   %eax
  10436c:	8d 83 54 f4 fe ff    	lea    -0x10bac(%ebx),%eax
  104372:	50                   	push   %eax
  104373:	e8 a5 bf ff ff       	call   10031d <cprintf>
  104378:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10437b:	bf 00 00 c0 fa       	mov    $0xfac00000,%edi
  104380:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104383:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104386:	89 d6                	mov    %edx,%esi
  104388:	c1 e6 0a             	shl    $0xa,%esi
  10438b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10438e:	89 d1                	mov    %edx,%ecx
  104390:	c1 e1 0a             	shl    $0xa,%ecx
  104393:	83 ec 08             	sub    $0x8,%esp
  104396:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  104399:	52                   	push   %edx
  10439a:	8d 55 d8             	lea    -0x28(%ebp),%edx
  10439d:	52                   	push   %edx
  10439e:	57                   	push   %edi
  10439f:	50                   	push   %eax
  1043a0:	56                   	push   %esi
  1043a1:	51                   	push   %ecx
  1043a2:	e8 31 fe ff ff       	call   1041d8 <get_pgtable_items>
  1043a7:	83 c4 20             	add    $0x20,%esp
  1043aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1043ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1043b1:	0f 85 70 ff ff ff    	jne    104327 <print_pgdir+0x91>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1043b7:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  1043bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1043bf:	83 ec 08             	sub    $0x8,%esp
  1043c2:	8d 55 dc             	lea    -0x24(%ebp),%edx
  1043c5:	52                   	push   %edx
  1043c6:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1043c9:	52                   	push   %edx
  1043ca:	51                   	push   %ecx
  1043cb:	50                   	push   %eax
  1043cc:	68 00 04 00 00       	push   $0x400
  1043d1:	6a 00                	push   $0x0
  1043d3:	e8 00 fe ff ff       	call   1041d8 <get_pgtable_items>
  1043d8:	83 c4 20             	add    $0x20,%esp
  1043db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1043de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1043e2:	0f 85 e0 fe ff ff    	jne    1042c8 <print_pgdir+0x32>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1043e8:	83 ec 0c             	sub    $0xc,%esp
  1043eb:	8d 83 78 f4 fe ff    	lea    -0x10b88(%ebx),%eax
  1043f1:	50                   	push   %eax
  1043f2:	e8 26 bf ff ff       	call   10031d <cprintf>
  1043f7:	83 c4 10             	add    $0x10,%esp
}
  1043fa:	90                   	nop
  1043fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1043fe:	5b                   	pop    %ebx
  1043ff:	5e                   	pop    %esi
  104400:	5f                   	pop    %edi
  104401:	5d                   	pop    %ebp
  104402:	c3                   	ret    

00104403 <__x86.get_pc_thunk.si>:
  104403:	8b 34 24             	mov    (%esp),%esi
  104406:	c3                   	ret    

00104407 <page2ppn>:
page2ppn(struct Page *page) {
  104407:	55                   	push   %ebp
  104408:	89 e5                	mov    %esp,%ebp
  10440a:	e8 97 be ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  10440f:	05 61 35 01 00       	add    $0x13561,%eax
    return page - pages;
  104414:	8b 55 08             	mov    0x8(%ebp),%edx
  104417:	c7 c0 18 8a 11 00    	mov    $0x118a18,%eax
  10441d:	8b 00                	mov    (%eax),%eax
  10441f:	29 c2                	sub    %eax,%edx
  104421:	89 d0                	mov    %edx,%eax
  104423:	c1 f8 02             	sar    $0x2,%eax
  104426:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10442c:	5d                   	pop    %ebp
  10442d:	c3                   	ret    

0010442e <page2pa>:
page2pa(struct Page *page) {
  10442e:	55                   	push   %ebp
  10442f:	89 e5                	mov    %esp,%ebp
  104431:	e8 70 be ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  104436:	05 3a 35 01 00       	add    $0x1353a,%eax
    return page2ppn(page) << PGSHIFT;
  10443b:	ff 75 08             	pushl  0x8(%ebp)
  10443e:	e8 c4 ff ff ff       	call   104407 <page2ppn>
  104443:	83 c4 04             	add    $0x4,%esp
  104446:	c1 e0 0c             	shl    $0xc,%eax
}
  104449:	c9                   	leave  
  10444a:	c3                   	ret    

0010444b <page_ref>:
page_ref(struct Page *page) {
  10444b:	55                   	push   %ebp
  10444c:	89 e5                	mov    %esp,%ebp
  10444e:	e8 53 be ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  104453:	05 1d 35 01 00       	add    $0x1351d,%eax
    return page->ref;
  104458:	8b 45 08             	mov    0x8(%ebp),%eax
  10445b:	8b 00                	mov    (%eax),%eax
}
  10445d:	5d                   	pop    %ebp
  10445e:	c3                   	ret    

0010445f <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  10445f:	55                   	push   %ebp
  104460:	89 e5                	mov    %esp,%ebp
  104462:	e8 3f be ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  104467:	05 09 35 01 00       	add    $0x13509,%eax
    page->ref = val;
  10446c:	8b 45 08             	mov    0x8(%ebp),%eax
  10446f:	8b 55 0c             	mov    0xc(%ebp),%edx
  104472:	89 10                	mov    %edx,(%eax)
}
  104474:	90                   	nop
  104475:	5d                   	pop    %ebp
  104476:	c3                   	ret    

00104477 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  104477:	55                   	push   %ebp
  104478:	89 e5                	mov    %esp,%ebp
  10447a:	83 ec 10             	sub    $0x10,%esp
  10447d:	e8 24 be ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  104482:	05 ee 34 01 00       	add    $0x134ee,%eax
  104487:	c7 c2 1c 8a 11 00    	mov    $0x118a1c,%edx
  10448d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104490:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104493:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  104496:	89 4a 04             	mov    %ecx,0x4(%edx)
  104499:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10449c:	8b 4a 04             	mov    0x4(%edx),%ecx
  10449f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1044a2:	89 0a                	mov    %ecx,(%edx)
    list_init(&free_list);
    nr_free = 0;
  1044a4:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  1044aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
  1044b1:	90                   	nop
  1044b2:	c9                   	leave  
  1044b3:	c3                   	ret    

001044b4 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1044b4:	55                   	push   %ebp
  1044b5:	89 e5                	mov    %esp,%ebp
  1044b7:	53                   	push   %ebx
  1044b8:	83 ec 44             	sub    $0x44,%esp
  1044bb:	e8 ea bd ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  1044c0:	81 c3 b0 34 01 00    	add    $0x134b0,%ebx
    assert(n > 0);
  1044c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1044ca:	75 1c                	jne    1044e8 <default_init_memmap+0x34>
  1044cc:	8d 83 ac f4 fe ff    	lea    -0x10b54(%ebx),%eax
  1044d2:	50                   	push   %eax
  1044d3:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  1044d9:	50                   	push   %eax
  1044da:	6a 46                	push   $0x46
  1044dc:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  1044e2:	50                   	push   %eax
  1044e3:	e8 e5 bf ff ff       	call   1004cd <__panic>
    struct Page *p = base;
  1044e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1044eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1044ee:	eb 72                	jmp    104562 <default_init_memmap+0xae>
        assert(PageReserved(p));
  1044f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044f3:	83 c0 04             	add    $0x4,%eax
  1044f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1044fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104503:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104506:	0f a3 10             	bt     %edx,(%eax)
  104509:	19 c0                	sbb    %eax,%eax
  10450b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10450e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104512:	0f 95 c0             	setne  %al
  104515:	0f b6 c0             	movzbl %al,%eax
  104518:	85 c0                	test   %eax,%eax
  10451a:	75 1c                	jne    104538 <default_init_memmap+0x84>
  10451c:	8d 83 dd f4 fe ff    	lea    -0x10b23(%ebx),%eax
  104522:	50                   	push   %eax
  104523:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104529:	50                   	push   %eax
  10452a:	6a 49                	push   $0x49
  10452c:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104532:	50                   	push   %eax
  104533:	e8 95 bf ff ff       	call   1004cd <__panic>
        p->flags = p->property = 0;
  104538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10453b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  104542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104545:	8b 50 08             	mov    0x8(%eax),%edx
  104548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10454b:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  10454e:	83 ec 08             	sub    $0x8,%esp
  104551:	6a 00                	push   $0x0
  104553:	ff 75 f4             	pushl  -0xc(%ebp)
  104556:	e8 04 ff ff ff       	call   10445f <set_page_ref>
  10455b:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
  10455e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104562:	8b 55 0c             	mov    0xc(%ebp),%edx
  104565:	89 d0                	mov    %edx,%eax
  104567:	c1 e0 02             	shl    $0x2,%eax
  10456a:	01 d0                	add    %edx,%eax
  10456c:	c1 e0 02             	shl    $0x2,%eax
  10456f:	89 c2                	mov    %eax,%edx
  104571:	8b 45 08             	mov    0x8(%ebp),%eax
  104574:	01 d0                	add    %edx,%eax
  104576:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104579:	0f 85 71 ff ff ff    	jne    1044f0 <default_init_memmap+0x3c>
    }
    base->property = n;
  10457f:	8b 45 08             	mov    0x8(%ebp),%eax
  104582:	8b 55 0c             	mov    0xc(%ebp),%edx
  104585:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104588:	8b 45 08             	mov    0x8(%ebp),%eax
  10458b:	83 c0 04             	add    $0x4,%eax
  10458e:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  104595:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104598:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10459b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10459e:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  1045a1:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  1045a7:	8b 50 08             	mov    0x8(%eax),%edx
  1045aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045ad:	01 c2                	add    %eax,%edx
  1045af:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  1045b5:	89 50 08             	mov    %edx,0x8(%eax)
    list_add(&free_list, &(base->page_link));
  1045b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1045bb:	83 c0 0c             	add    $0xc,%eax
  1045be:	c7 c2 1c 8a 11 00    	mov    $0x118a1c,%edx
  1045c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1045c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1045ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1045cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1045d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1045d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1045d9:	8b 40 04             	mov    0x4(%eax),%eax
  1045dc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1045df:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1045e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1045e5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  1045e8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1045eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1045ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1045f1:	89 10                	mov    %edx,(%eax)
  1045f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1045f6:	8b 10                	mov    (%eax),%edx
  1045f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1045fb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1045fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104601:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104604:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104607:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10460a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10460d:	89 10                	mov    %edx,(%eax)
}
  10460f:	90                   	nop
  104610:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  104613:	c9                   	leave  
  104614:	c3                   	ret    

00104615 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  104615:	55                   	push   %ebp
  104616:	89 e5                	mov    %esp,%ebp
  104618:	53                   	push   %ebx
  104619:	83 ec 54             	sub    $0x54,%esp
  10461c:	e8 85 bc ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  104621:	05 4f 33 01 00       	add    $0x1334f,%eax
    assert(n > 0);
  104626:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10462a:	75 1e                	jne    10464a <default_alloc_pages+0x35>
  10462c:	8d 90 ac f4 fe ff    	lea    -0x10b54(%eax),%edx
  104632:	52                   	push   %edx
  104633:	8d 90 b2 f4 fe ff    	lea    -0x10b4e(%eax),%edx
  104639:	52                   	push   %edx
  10463a:	6a 55                	push   $0x55
  10463c:	8d 90 c7 f4 fe ff    	lea    -0x10b39(%eax),%edx
  104642:	52                   	push   %edx
  104643:	89 c3                	mov    %eax,%ebx
  104645:	e8 83 be ff ff       	call   1004cd <__panic>
    if (n > nr_free) {
  10464a:	c7 c2 1c 8a 11 00    	mov    $0x118a1c,%edx
  104650:	8b 52 08             	mov    0x8(%edx),%edx
  104653:	39 55 08             	cmp    %edx,0x8(%ebp)
  104656:	76 0a                	jbe    104662 <default_alloc_pages+0x4d>
        return NULL;
  104658:	b8 00 00 00 00       	mov    $0x0,%eax
  10465d:	e9 38 01 00 00       	jmp    10479a <default_alloc_pages+0x185>
    }
    struct Page *page = NULL;
  104662:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  104669:	c7 c2 1c 8a 11 00    	mov    $0x118a1c,%edx
  10466f:	89 55 f0             	mov    %edx,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104672:	eb 1c                	jmp    104690 <default_alloc_pages+0x7b>
        struct Page *p = le2page(le, page_link);
  104674:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104677:	83 ea 0c             	sub    $0xc,%edx
  10467a:	89 55 ec             	mov    %edx,-0x14(%ebp)
        if (p->property >= n) {
  10467d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104680:	8b 52 08             	mov    0x8(%edx),%edx
  104683:	39 55 08             	cmp    %edx,0x8(%ebp)
  104686:	77 08                	ja     104690 <default_alloc_pages+0x7b>
            page = p;
  104688:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10468b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            break;
  10468e:	eb 1a                	jmp    1046aa <default_alloc_pages+0x95>
  104690:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104693:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return listelm->next;
  104696:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104699:	8b 52 04             	mov    0x4(%edx),%edx
    while ((le = list_next(le)) != &free_list) {
  10469c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10469f:	c7 c2 1c 8a 11 00    	mov    $0x118a1c,%edx
  1046a5:	39 55 f0             	cmp    %edx,-0x10(%ebp)
  1046a8:	75 ca                	jne    104674 <default_alloc_pages+0x5f>
        }
    }
    if (page != NULL) {
  1046aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046ae:	0f 84 e3 00 00 00    	je     104797 <default_alloc_pages+0x182>
        list_del(&(page->page_link));
  1046b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1046b7:	83 c2 0c             	add    $0xc,%edx
  1046ba:	89 55 e0             	mov    %edx,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
  1046bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1046c0:	8b 52 04             	mov    0x4(%edx),%edx
  1046c3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1046c6:	8b 09                	mov    (%ecx),%ecx
  1046c8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  1046cb:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1046ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1046d1:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  1046d4:	89 4a 04             	mov    %ecx,0x4(%edx)
    next->prev = prev;
  1046d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1046da:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1046dd:	89 0a                	mov    %ecx,(%edx)
        if (page->property > n) {
  1046df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1046e2:	8b 52 08             	mov    0x8(%edx),%edx
  1046e5:	39 55 08             	cmp    %edx,0x8(%ebp)
  1046e8:	73 7f                	jae    104769 <default_alloc_pages+0x154>
            struct Page *p = page + n;
  1046ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1046ed:	89 ca                	mov    %ecx,%edx
  1046ef:	c1 e2 02             	shl    $0x2,%edx
  1046f2:	01 ca                	add    %ecx,%edx
  1046f4:	c1 e2 02             	shl    $0x2,%edx
  1046f7:	89 d1                	mov    %edx,%ecx
  1046f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1046fc:	01 ca                	add    %ecx,%edx
  1046fe:	89 55 e8             	mov    %edx,-0x18(%ebp)
            p->property = page->property - n;
  104701:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104704:	8b 52 08             	mov    0x8(%edx),%edx
  104707:	89 d1                	mov    %edx,%ecx
  104709:	2b 4d 08             	sub    0x8(%ebp),%ecx
  10470c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10470f:	89 4a 08             	mov    %ecx,0x8(%edx)
            list_add(&free_list, &(p->page_link));
  104712:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104715:	83 c2 0c             	add    $0xc,%edx
  104718:	c7 c1 1c 8a 11 00    	mov    $0x118a1c,%ecx
  10471e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  104721:	89 55 d0             	mov    %edx,-0x30(%ebp)
  104724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104727:	89 55 cc             	mov    %edx,-0x34(%ebp)
  10472a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10472d:	89 55 c8             	mov    %edx,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
  104730:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104733:	8b 52 04             	mov    0x4(%edx),%edx
  104736:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  104739:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  10473c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  10473f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  104742:	89 55 bc             	mov    %edx,-0x44(%ebp)
    prev->next = next->prev = elm;
  104745:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104748:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10474b:	89 0a                	mov    %ecx,(%edx)
  10474d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104750:	8b 0a                	mov    (%edx),%ecx
  104752:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104755:	89 4a 04             	mov    %ecx,0x4(%edx)
    elm->next = next;
  104758:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10475b:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  10475e:	89 4a 04             	mov    %ecx,0x4(%edx)
    elm->prev = prev;
  104761:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104764:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  104767:	89 0a                	mov    %ecx,(%edx)
    }
        nr_free -= n;
  104769:	c7 c2 1c 8a 11 00    	mov    $0x118a1c,%edx
  10476f:	8b 52 08             	mov    0x8(%edx),%edx
  104772:	2b 55 08             	sub    0x8(%ebp),%edx
  104775:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  10477b:	89 50 08             	mov    %edx,0x8(%eax)
        ClearPageProperty(page);
  10477e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104781:	83 c0 04             	add    $0x4,%eax
  104784:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  10478b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10478e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104791:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104794:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  104797:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10479a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10479d:	c9                   	leave  
  10479e:	c3                   	ret    

0010479f <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  10479f:	55                   	push   %ebp
  1047a0:	89 e5                	mov    %esp,%ebp
  1047a2:	53                   	push   %ebx
  1047a3:	81 ec 84 00 00 00    	sub    $0x84,%esp
  1047a9:	e8 fc ba ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  1047ae:	81 c3 c2 31 01 00    	add    $0x131c2,%ebx
    assert(n > 0);
  1047b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1047b8:	75 1c                	jne    1047d6 <default_free_pages+0x37>
  1047ba:	8d 83 ac f4 fe ff    	lea    -0x10b54(%ebx),%eax
  1047c0:	50                   	push   %eax
  1047c1:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  1047c7:	50                   	push   %eax
  1047c8:	6a 71                	push   $0x71
  1047ca:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  1047d0:	50                   	push   %eax
  1047d1:	e8 f7 bc ff ff       	call   1004cd <__panic>
    struct Page *p = base;
  1047d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1047d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1047dc:	e9 92 00 00 00       	jmp    104873 <default_free_pages+0xd4>
        assert(!PageReserved(p) && !PageProperty(p));
  1047e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047e4:	83 c0 04             	add    $0x4,%eax
  1047e7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1047ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1047f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1047f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1047f7:	0f a3 10             	bt     %edx,(%eax)
  1047fa:	19 c0                	sbb    %eax,%eax
  1047fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  1047ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104803:	0f 95 c0             	setne  %al
  104806:	0f b6 c0             	movzbl %al,%eax
  104809:	85 c0                	test   %eax,%eax
  10480b:	75 2c                	jne    104839 <default_free_pages+0x9a>
  10480d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104810:	83 c0 04             	add    $0x4,%eax
  104813:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10481a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10481d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104820:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104823:	0f a3 10             	bt     %edx,(%eax)
  104826:	19 c0                	sbb    %eax,%eax
  104828:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  10482b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  10482f:	0f 95 c0             	setne  %al
  104832:	0f b6 c0             	movzbl %al,%eax
  104835:	85 c0                	test   %eax,%eax
  104837:	74 1c                	je     104855 <default_free_pages+0xb6>
  104839:	8d 83 f0 f4 fe ff    	lea    -0x10b10(%ebx),%eax
  10483f:	50                   	push   %eax
  104840:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104846:	50                   	push   %eax
  104847:	6a 74                	push   $0x74
  104849:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  10484f:	50                   	push   %eax
  104850:	e8 78 bc ff ff       	call   1004cd <__panic>
        p->flags = 0;
  104855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104858:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  10485f:	83 ec 08             	sub    $0x8,%esp
  104862:	6a 00                	push   $0x0
  104864:	ff 75 f4             	pushl  -0xc(%ebp)
  104867:	e8 f3 fb ff ff       	call   10445f <set_page_ref>
  10486c:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
  10486f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104873:	8b 55 0c             	mov    0xc(%ebp),%edx
  104876:	89 d0                	mov    %edx,%eax
  104878:	c1 e0 02             	shl    $0x2,%eax
  10487b:	01 d0                	add    %edx,%eax
  10487d:	c1 e0 02             	shl    $0x2,%eax
  104880:	89 c2                	mov    %eax,%edx
  104882:	8b 45 08             	mov    0x8(%ebp),%eax
  104885:	01 d0                	add    %edx,%eax
  104887:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10488a:	0f 85 51 ff ff ff    	jne    1047e1 <default_free_pages+0x42>
    }
    base->property = n;
  104890:	8b 45 08             	mov    0x8(%ebp),%eax
  104893:	8b 55 0c             	mov    0xc(%ebp),%edx
  104896:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104899:	8b 45 08             	mov    0x8(%ebp),%eax
  10489c:	83 c0 04             	add    $0x4,%eax
  10489f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1048a6:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1048a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1048ac:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1048af:	0f ab 10             	bts    %edx,(%eax)
  1048b2:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  1048b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return listelm->next;
  1048bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1048be:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  1048c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  1048c4:	e9 08 01 00 00       	jmp    1049d1 <default_free_pages+0x232>
        p = le2page(le, page_link);
  1048c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048cc:	83 e8 0c             	sub    $0xc,%eax
  1048cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1048d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048d5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1048d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1048db:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  1048de:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  1048e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1048e4:	8b 50 08             	mov    0x8(%eax),%edx
  1048e7:	89 d0                	mov    %edx,%eax
  1048e9:	c1 e0 02             	shl    $0x2,%eax
  1048ec:	01 d0                	add    %edx,%eax
  1048ee:	c1 e0 02             	shl    $0x2,%eax
  1048f1:	89 c2                	mov    %eax,%edx
  1048f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1048f6:	01 d0                	add    %edx,%eax
  1048f8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1048fb:	75 5a                	jne    104957 <default_free_pages+0x1b8>
            base->property += p->property;
  1048fd:	8b 45 08             	mov    0x8(%ebp),%eax
  104900:	8b 50 08             	mov    0x8(%eax),%edx
  104903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104906:	8b 40 08             	mov    0x8(%eax),%eax
  104909:	01 c2                	add    %eax,%edx
  10490b:	8b 45 08             	mov    0x8(%ebp),%eax
  10490e:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  104911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104914:	83 c0 04             	add    $0x4,%eax
  104917:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  10491e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104921:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104924:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104927:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  10492a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10492d:	83 c0 0c             	add    $0xc,%eax
  104930:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104933:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104936:	8b 40 04             	mov    0x4(%eax),%eax
  104939:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10493c:	8b 12                	mov    (%edx),%edx
  10493e:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104941:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  104944:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104947:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10494a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10494d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104950:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104953:	89 10                	mov    %edx,(%eax)
  104955:	eb 7a                	jmp    1049d1 <default_free_pages+0x232>
        }
        else if (p + p->property == base) {
  104957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10495a:	8b 50 08             	mov    0x8(%eax),%edx
  10495d:	89 d0                	mov    %edx,%eax
  10495f:	c1 e0 02             	shl    $0x2,%eax
  104962:	01 d0                	add    %edx,%eax
  104964:	c1 e0 02             	shl    $0x2,%eax
  104967:	89 c2                	mov    %eax,%edx
  104969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10496c:	01 d0                	add    %edx,%eax
  10496e:	39 45 08             	cmp    %eax,0x8(%ebp)
  104971:	75 5e                	jne    1049d1 <default_free_pages+0x232>
            p->property += base->property;
  104973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104976:	8b 50 08             	mov    0x8(%eax),%edx
  104979:	8b 45 08             	mov    0x8(%ebp),%eax
  10497c:	8b 40 08             	mov    0x8(%eax),%eax
  10497f:	01 c2                	add    %eax,%edx
  104981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104984:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  104987:	8b 45 08             	mov    0x8(%ebp),%eax
  10498a:	83 c0 04             	add    $0x4,%eax
  10498d:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  104994:	89 45 a0             	mov    %eax,-0x60(%ebp)
  104997:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10499a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10499d:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  1049a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049a3:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  1049a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049a9:	83 c0 0c             	add    $0xc,%eax
  1049ac:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  1049af:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1049b2:	8b 40 04             	mov    0x4(%eax),%eax
  1049b5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1049b8:	8b 12                	mov    (%edx),%edx
  1049ba:	89 55 ac             	mov    %edx,-0x54(%ebp)
  1049bd:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  1049c0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1049c3:	8b 55 a8             	mov    -0x58(%ebp),%edx
  1049c6:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1049c9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1049cc:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1049cf:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
  1049d1:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  1049d7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1049da:	0f 85 e9 fe ff ff    	jne    1048c9 <default_free_pages+0x12a>
        }
    }
    nr_free += n;
  1049e0:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  1049e6:	8b 50 08             	mov    0x8(%eax),%edx
  1049e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1049ec:	01 c2                	add    %eax,%edx
  1049ee:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  1049f4:	89 50 08             	mov    %edx,0x8(%eax)
    list_add(&free_list, &(base->page_link));
  1049f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1049fa:	83 c0 0c             	add    $0xc,%eax
  1049fd:	c7 c2 1c 8a 11 00    	mov    $0x118a1c,%edx
  104a03:	89 55 9c             	mov    %edx,-0x64(%ebp)
  104a06:	89 45 98             	mov    %eax,-0x68(%ebp)
  104a09:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104a0c:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104a0f:	8b 45 98             	mov    -0x68(%ebp),%eax
  104a12:	89 45 90             	mov    %eax,-0x70(%ebp)
    __list_add(elm, listelm, listelm->next);
  104a15:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104a18:	8b 40 04             	mov    0x4(%eax),%eax
  104a1b:	8b 55 90             	mov    -0x70(%ebp),%edx
  104a1e:	89 55 8c             	mov    %edx,-0x74(%ebp)
  104a21:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104a24:	89 55 88             	mov    %edx,-0x78(%ebp)
  104a27:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  104a2a:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104a2d:	8b 55 8c             	mov    -0x74(%ebp),%edx
  104a30:	89 10                	mov    %edx,(%eax)
  104a32:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104a35:	8b 10                	mov    (%eax),%edx
  104a37:	8b 45 88             	mov    -0x78(%ebp),%eax
  104a3a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104a3d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104a40:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104a43:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104a46:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104a49:	8b 55 88             	mov    -0x78(%ebp),%edx
  104a4c:	89 10                	mov    %edx,(%eax)
}
  104a4e:	90                   	nop
  104a4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  104a52:	c9                   	leave  
  104a53:	c3                   	ret    

00104a54 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104a54:	55                   	push   %ebp
  104a55:	89 e5                	mov    %esp,%ebp
  104a57:	e8 4a b8 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  104a5c:	05 14 2f 01 00       	add    $0x12f14,%eax
    return nr_free;
  104a61:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  104a67:	8b 40 08             	mov    0x8(%eax),%eax
}
  104a6a:	5d                   	pop    %ebp
  104a6b:	c3                   	ret    

00104a6c <basic_check>:

static void
basic_check(void) {
  104a6c:	55                   	push   %ebp
  104a6d:	89 e5                	mov    %esp,%ebp
  104a6f:	53                   	push   %ebx
  104a70:	83 ec 34             	sub    $0x34,%esp
  104a73:	e8 32 b8 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  104a78:	81 c3 f8 2e 01 00    	add    $0x12ef8,%ebx
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104a7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104a91:	83 ec 0c             	sub    $0xc,%esp
  104a94:	6a 01                	push   $0x1
  104a96:	e8 b3 e3 ff ff       	call   102e4e <alloc_pages>
  104a9b:	83 c4 10             	add    $0x10,%esp
  104a9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104aa1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104aa5:	75 1f                	jne    104ac6 <basic_check+0x5a>
  104aa7:	8d 83 15 f5 fe ff    	lea    -0x10aeb(%ebx),%eax
  104aad:	50                   	push   %eax
  104aae:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104ab4:	50                   	push   %eax
  104ab5:	68 97 00 00 00       	push   $0x97
  104aba:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104ac0:	50                   	push   %eax
  104ac1:	e8 07 ba ff ff       	call   1004cd <__panic>
    assert((p1 = alloc_page()) != NULL);
  104ac6:	83 ec 0c             	sub    $0xc,%esp
  104ac9:	6a 01                	push   $0x1
  104acb:	e8 7e e3 ff ff       	call   102e4e <alloc_pages>
  104ad0:	83 c4 10             	add    $0x10,%esp
  104ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ad6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ada:	75 1f                	jne    104afb <basic_check+0x8f>
  104adc:	8d 83 31 f5 fe ff    	lea    -0x10acf(%ebx),%eax
  104ae2:	50                   	push   %eax
  104ae3:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104ae9:	50                   	push   %eax
  104aea:	68 98 00 00 00       	push   $0x98
  104aef:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104af5:	50                   	push   %eax
  104af6:	e8 d2 b9 ff ff       	call   1004cd <__panic>
    assert((p2 = alloc_page()) != NULL);
  104afb:	83 ec 0c             	sub    $0xc,%esp
  104afe:	6a 01                	push   $0x1
  104b00:	e8 49 e3 ff ff       	call   102e4e <alloc_pages>
  104b05:	83 c4 10             	add    $0x10,%esp
  104b08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104b0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104b0f:	75 1f                	jne    104b30 <basic_check+0xc4>
  104b11:	8d 83 4d f5 fe ff    	lea    -0x10ab3(%ebx),%eax
  104b17:	50                   	push   %eax
  104b18:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104b1e:	50                   	push   %eax
  104b1f:	68 99 00 00 00       	push   $0x99
  104b24:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104b2a:	50                   	push   %eax
  104b2b:	e8 9d b9 ff ff       	call   1004cd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b33:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104b36:	74 10                	je     104b48 <basic_check+0xdc>
  104b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104b3e:	74 08                	je     104b48 <basic_check+0xdc>
  104b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b43:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104b46:	75 1f                	jne    104b67 <basic_check+0xfb>
  104b48:	8d 83 6c f5 fe ff    	lea    -0x10a94(%ebx),%eax
  104b4e:	50                   	push   %eax
  104b4f:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104b55:	50                   	push   %eax
  104b56:	68 9b 00 00 00       	push   $0x9b
  104b5b:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104b61:	50                   	push   %eax
  104b62:	e8 66 b9 ff ff       	call   1004cd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104b67:	83 ec 0c             	sub    $0xc,%esp
  104b6a:	ff 75 ec             	pushl  -0x14(%ebp)
  104b6d:	e8 d9 f8 ff ff       	call   10444b <page_ref>
  104b72:	83 c4 10             	add    $0x10,%esp
  104b75:	85 c0                	test   %eax,%eax
  104b77:	75 24                	jne    104b9d <basic_check+0x131>
  104b79:	83 ec 0c             	sub    $0xc,%esp
  104b7c:	ff 75 f0             	pushl  -0x10(%ebp)
  104b7f:	e8 c7 f8 ff ff       	call   10444b <page_ref>
  104b84:	83 c4 10             	add    $0x10,%esp
  104b87:	85 c0                	test   %eax,%eax
  104b89:	75 12                	jne    104b9d <basic_check+0x131>
  104b8b:	83 ec 0c             	sub    $0xc,%esp
  104b8e:	ff 75 f4             	pushl  -0xc(%ebp)
  104b91:	e8 b5 f8 ff ff       	call   10444b <page_ref>
  104b96:	83 c4 10             	add    $0x10,%esp
  104b99:	85 c0                	test   %eax,%eax
  104b9b:	74 1f                	je     104bbc <basic_check+0x150>
  104b9d:	8d 83 90 f5 fe ff    	lea    -0x10a70(%ebx),%eax
  104ba3:	50                   	push   %eax
  104ba4:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104baa:	50                   	push   %eax
  104bab:	68 9c 00 00 00       	push   $0x9c
  104bb0:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104bb6:	50                   	push   %eax
  104bb7:	e8 11 b9 ff ff       	call   1004cd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104bbc:	83 ec 0c             	sub    $0xc,%esp
  104bbf:	ff 75 ec             	pushl  -0x14(%ebp)
  104bc2:	e8 67 f8 ff ff       	call   10442e <page2pa>
  104bc7:	83 c4 10             	add    $0x10,%esp
  104bca:	89 c2                	mov    %eax,%edx
  104bcc:	c7 c0 80 89 11 00    	mov    $0x118980,%eax
  104bd2:	8b 00                	mov    (%eax),%eax
  104bd4:	c1 e0 0c             	shl    $0xc,%eax
  104bd7:	39 c2                	cmp    %eax,%edx
  104bd9:	72 1f                	jb     104bfa <basic_check+0x18e>
  104bdb:	8d 83 cc f5 fe ff    	lea    -0x10a34(%ebx),%eax
  104be1:	50                   	push   %eax
  104be2:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104be8:	50                   	push   %eax
  104be9:	68 9e 00 00 00       	push   $0x9e
  104bee:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104bf4:	50                   	push   %eax
  104bf5:	e8 d3 b8 ff ff       	call   1004cd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104bfa:	83 ec 0c             	sub    $0xc,%esp
  104bfd:	ff 75 f0             	pushl  -0x10(%ebp)
  104c00:	e8 29 f8 ff ff       	call   10442e <page2pa>
  104c05:	83 c4 10             	add    $0x10,%esp
  104c08:	89 c2                	mov    %eax,%edx
  104c0a:	c7 c0 80 89 11 00    	mov    $0x118980,%eax
  104c10:	8b 00                	mov    (%eax),%eax
  104c12:	c1 e0 0c             	shl    $0xc,%eax
  104c15:	39 c2                	cmp    %eax,%edx
  104c17:	72 1f                	jb     104c38 <basic_check+0x1cc>
  104c19:	8d 83 e9 f5 fe ff    	lea    -0x10a17(%ebx),%eax
  104c1f:	50                   	push   %eax
  104c20:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104c26:	50                   	push   %eax
  104c27:	68 9f 00 00 00       	push   $0x9f
  104c2c:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104c32:	50                   	push   %eax
  104c33:	e8 95 b8 ff ff       	call   1004cd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104c38:	83 ec 0c             	sub    $0xc,%esp
  104c3b:	ff 75 f4             	pushl  -0xc(%ebp)
  104c3e:	e8 eb f7 ff ff       	call   10442e <page2pa>
  104c43:	83 c4 10             	add    $0x10,%esp
  104c46:	89 c2                	mov    %eax,%edx
  104c48:	c7 c0 80 89 11 00    	mov    $0x118980,%eax
  104c4e:	8b 00                	mov    (%eax),%eax
  104c50:	c1 e0 0c             	shl    $0xc,%eax
  104c53:	39 c2                	cmp    %eax,%edx
  104c55:	72 1f                	jb     104c76 <basic_check+0x20a>
  104c57:	8d 83 06 f6 fe ff    	lea    -0x109fa(%ebx),%eax
  104c5d:	50                   	push   %eax
  104c5e:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104c64:	50                   	push   %eax
  104c65:	68 a0 00 00 00       	push   $0xa0
  104c6a:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104c70:	50                   	push   %eax
  104c71:	e8 57 b8 ff ff       	call   1004cd <__panic>

    list_entry_t free_list_store = free_list;
  104c76:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  104c7c:	8b 50 04             	mov    0x4(%eax),%edx
  104c7f:	8b 00                	mov    (%eax),%eax
  104c81:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104c84:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104c87:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  104c8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    elm->prev = elm->next = elm;
  104c90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c93:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104c96:	89 50 04             	mov    %edx,0x4(%eax)
  104c99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c9c:	8b 50 04             	mov    0x4(%eax),%edx
  104c9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ca2:	89 10                	mov    %edx,(%eax)
  104ca4:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  104caa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return list->next == list;
  104cad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104cb0:	8b 40 04             	mov    0x4(%eax),%eax
  104cb3:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104cb6:	0f 94 c0             	sete   %al
  104cb9:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104cbc:	85 c0                	test   %eax,%eax
  104cbe:	75 1f                	jne    104cdf <basic_check+0x273>
  104cc0:	8d 83 23 f6 fe ff    	lea    -0x109dd(%ebx),%eax
  104cc6:	50                   	push   %eax
  104cc7:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104ccd:	50                   	push   %eax
  104cce:	68 a4 00 00 00       	push   $0xa4
  104cd3:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104cd9:	50                   	push   %eax
  104cda:	e8 ee b7 ff ff       	call   1004cd <__panic>

    unsigned int nr_free_store = nr_free;
  104cdf:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  104ce5:	8b 40 08             	mov    0x8(%eax),%eax
  104ce8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104ceb:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  104cf1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

    assert(alloc_page() == NULL);
  104cf8:	83 ec 0c             	sub    $0xc,%esp
  104cfb:	6a 01                	push   $0x1
  104cfd:	e8 4c e1 ff ff       	call   102e4e <alloc_pages>
  104d02:	83 c4 10             	add    $0x10,%esp
  104d05:	85 c0                	test   %eax,%eax
  104d07:	74 1f                	je     104d28 <basic_check+0x2bc>
  104d09:	8d 83 3a f6 fe ff    	lea    -0x109c6(%ebx),%eax
  104d0f:	50                   	push   %eax
  104d10:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104d16:	50                   	push   %eax
  104d17:	68 a9 00 00 00       	push   $0xa9
  104d1c:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104d22:	50                   	push   %eax
  104d23:	e8 a5 b7 ff ff       	call   1004cd <__panic>

    free_page(p0);
  104d28:	83 ec 08             	sub    $0x8,%esp
  104d2b:	6a 01                	push   $0x1
  104d2d:	ff 75 ec             	pushl  -0x14(%ebp)
  104d30:	e8 69 e1 ff ff       	call   102e9e <free_pages>
  104d35:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  104d38:	83 ec 08             	sub    $0x8,%esp
  104d3b:	6a 01                	push   $0x1
  104d3d:	ff 75 f0             	pushl  -0x10(%ebp)
  104d40:	e8 59 e1 ff ff       	call   102e9e <free_pages>
  104d45:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104d48:	83 ec 08             	sub    $0x8,%esp
  104d4b:	6a 01                	push   $0x1
  104d4d:	ff 75 f4             	pushl  -0xc(%ebp)
  104d50:	e8 49 e1 ff ff       	call   102e9e <free_pages>
  104d55:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
  104d58:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  104d5e:	8b 40 08             	mov    0x8(%eax),%eax
  104d61:	83 f8 03             	cmp    $0x3,%eax
  104d64:	74 1f                	je     104d85 <basic_check+0x319>
  104d66:	8d 83 4f f6 fe ff    	lea    -0x109b1(%ebx),%eax
  104d6c:	50                   	push   %eax
  104d6d:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104d73:	50                   	push   %eax
  104d74:	68 ae 00 00 00       	push   $0xae
  104d79:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104d7f:	50                   	push   %eax
  104d80:	e8 48 b7 ff ff       	call   1004cd <__panic>

    assert((p0 = alloc_page()) != NULL);
  104d85:	83 ec 0c             	sub    $0xc,%esp
  104d88:	6a 01                	push   $0x1
  104d8a:	e8 bf e0 ff ff       	call   102e4e <alloc_pages>
  104d8f:	83 c4 10             	add    $0x10,%esp
  104d92:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104d95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104d99:	75 1f                	jne    104dba <basic_check+0x34e>
  104d9b:	8d 83 15 f5 fe ff    	lea    -0x10aeb(%ebx),%eax
  104da1:	50                   	push   %eax
  104da2:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104da8:	50                   	push   %eax
  104da9:	68 b0 00 00 00       	push   $0xb0
  104dae:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104db4:	50                   	push   %eax
  104db5:	e8 13 b7 ff ff       	call   1004cd <__panic>
    assert((p1 = alloc_page()) != NULL);
  104dba:	83 ec 0c             	sub    $0xc,%esp
  104dbd:	6a 01                	push   $0x1
  104dbf:	e8 8a e0 ff ff       	call   102e4e <alloc_pages>
  104dc4:	83 c4 10             	add    $0x10,%esp
  104dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104dca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104dce:	75 1f                	jne    104def <basic_check+0x383>
  104dd0:	8d 83 31 f5 fe ff    	lea    -0x10acf(%ebx),%eax
  104dd6:	50                   	push   %eax
  104dd7:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104ddd:	50                   	push   %eax
  104dde:	68 b1 00 00 00       	push   $0xb1
  104de3:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104de9:	50                   	push   %eax
  104dea:	e8 de b6 ff ff       	call   1004cd <__panic>
    assert((p2 = alloc_page()) != NULL);
  104def:	83 ec 0c             	sub    $0xc,%esp
  104df2:	6a 01                	push   $0x1
  104df4:	e8 55 e0 ff ff       	call   102e4e <alloc_pages>
  104df9:	83 c4 10             	add    $0x10,%esp
  104dfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104dff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104e03:	75 1f                	jne    104e24 <basic_check+0x3b8>
  104e05:	8d 83 4d f5 fe ff    	lea    -0x10ab3(%ebx),%eax
  104e0b:	50                   	push   %eax
  104e0c:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104e12:	50                   	push   %eax
  104e13:	68 b2 00 00 00       	push   $0xb2
  104e18:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104e1e:	50                   	push   %eax
  104e1f:	e8 a9 b6 ff ff       	call   1004cd <__panic>

    assert(alloc_page() == NULL);
  104e24:	83 ec 0c             	sub    $0xc,%esp
  104e27:	6a 01                	push   $0x1
  104e29:	e8 20 e0 ff ff       	call   102e4e <alloc_pages>
  104e2e:	83 c4 10             	add    $0x10,%esp
  104e31:	85 c0                	test   %eax,%eax
  104e33:	74 1f                	je     104e54 <basic_check+0x3e8>
  104e35:	8d 83 3a f6 fe ff    	lea    -0x109c6(%ebx),%eax
  104e3b:	50                   	push   %eax
  104e3c:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104e42:	50                   	push   %eax
  104e43:	68 b4 00 00 00       	push   $0xb4
  104e48:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104e4e:	50                   	push   %eax
  104e4f:	e8 79 b6 ff ff       	call   1004cd <__panic>

    free_page(p0);
  104e54:	83 ec 08             	sub    $0x8,%esp
  104e57:	6a 01                	push   $0x1
  104e59:	ff 75 ec             	pushl  -0x14(%ebp)
  104e5c:	e8 3d e0 ff ff       	call   102e9e <free_pages>
  104e61:	83 c4 10             	add    $0x10,%esp
  104e64:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  104e6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104e6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104e70:	8b 40 04             	mov    0x4(%eax),%eax
  104e73:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104e76:	0f 94 c0             	sete   %al
  104e79:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104e7c:	85 c0                	test   %eax,%eax
  104e7e:	74 1f                	je     104e9f <basic_check+0x433>
  104e80:	8d 83 5c f6 fe ff    	lea    -0x109a4(%ebx),%eax
  104e86:	50                   	push   %eax
  104e87:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104e8d:	50                   	push   %eax
  104e8e:	68 b7 00 00 00       	push   $0xb7
  104e93:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104e99:	50                   	push   %eax
  104e9a:	e8 2e b6 ff ff       	call   1004cd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104e9f:	83 ec 0c             	sub    $0xc,%esp
  104ea2:	6a 01                	push   $0x1
  104ea4:	e8 a5 df ff ff       	call   102e4e <alloc_pages>
  104ea9:	83 c4 10             	add    $0x10,%esp
  104eac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104eaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104eb2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104eb5:	74 1f                	je     104ed6 <basic_check+0x46a>
  104eb7:	8d 83 74 f6 fe ff    	lea    -0x1098c(%ebx),%eax
  104ebd:	50                   	push   %eax
  104ebe:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104ec4:	50                   	push   %eax
  104ec5:	68 ba 00 00 00       	push   $0xba
  104eca:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104ed0:	50                   	push   %eax
  104ed1:	e8 f7 b5 ff ff       	call   1004cd <__panic>
    assert(alloc_page() == NULL);
  104ed6:	83 ec 0c             	sub    $0xc,%esp
  104ed9:	6a 01                	push   $0x1
  104edb:	e8 6e df ff ff       	call   102e4e <alloc_pages>
  104ee0:	83 c4 10             	add    $0x10,%esp
  104ee3:	85 c0                	test   %eax,%eax
  104ee5:	74 1f                	je     104f06 <basic_check+0x49a>
  104ee7:	8d 83 3a f6 fe ff    	lea    -0x109c6(%ebx),%eax
  104eed:	50                   	push   %eax
  104eee:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104ef4:	50                   	push   %eax
  104ef5:	68 bb 00 00 00       	push   $0xbb
  104efa:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104f00:	50                   	push   %eax
  104f01:	e8 c7 b5 ff ff       	call   1004cd <__panic>

    assert(nr_free == 0);
  104f06:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  104f0c:	8b 40 08             	mov    0x8(%eax),%eax
  104f0f:	85 c0                	test   %eax,%eax
  104f11:	74 1f                	je     104f32 <basic_check+0x4c6>
  104f13:	8d 83 8d f6 fe ff    	lea    -0x10973(%ebx),%eax
  104f19:	50                   	push   %eax
  104f1a:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104f20:	50                   	push   %eax
  104f21:	68 bd 00 00 00       	push   $0xbd
  104f26:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  104f2c:	50                   	push   %eax
  104f2d:	e8 9b b5 ff ff       	call   1004cd <__panic>
    free_list = free_list_store;
  104f32:	c7 c1 1c 8a 11 00    	mov    $0x118a1c,%ecx
  104f38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104f3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104f3e:	89 01                	mov    %eax,(%ecx)
  104f40:	89 51 04             	mov    %edx,0x4(%ecx)
    nr_free = nr_free_store;
  104f43:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  104f49:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104f4c:	89 50 08             	mov    %edx,0x8(%eax)

    free_page(p);
  104f4f:	83 ec 08             	sub    $0x8,%esp
  104f52:	6a 01                	push   $0x1
  104f54:	ff 75 e4             	pushl  -0x1c(%ebp)
  104f57:	e8 42 df ff ff       	call   102e9e <free_pages>
  104f5c:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  104f5f:	83 ec 08             	sub    $0x8,%esp
  104f62:	6a 01                	push   $0x1
  104f64:	ff 75 f0             	pushl  -0x10(%ebp)
  104f67:	e8 32 df ff ff       	call   102e9e <free_pages>
  104f6c:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104f6f:	83 ec 08             	sub    $0x8,%esp
  104f72:	6a 01                	push   $0x1
  104f74:	ff 75 f4             	pushl  -0xc(%ebp)
  104f77:	e8 22 df ff ff       	call   102e9e <free_pages>
  104f7c:	83 c4 10             	add    $0x10,%esp
}
  104f7f:	90                   	nop
  104f80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  104f83:	c9                   	leave  
  104f84:	c3                   	ret    

00104f85 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104f85:	55                   	push   %ebp
  104f86:	89 e5                	mov    %esp,%ebp
  104f88:	53                   	push   %ebx
  104f89:	81 ec 84 00 00 00    	sub    $0x84,%esp
  104f8f:	e8 16 b3 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  104f94:	81 c3 dc 29 01 00    	add    $0x129dc,%ebx
    int count = 0, total = 0;
  104f9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104fa1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104fa8:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  104fae:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104fb1:	eb 66                	jmp    105019 <default_check+0x94>
        struct Page *p = le2page(le, page_link);
  104fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104fb6:	83 e8 0c             	sub    $0xc,%eax
  104fb9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  104fbc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104fbf:	83 c0 04             	add    $0x4,%eax
  104fc2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104fc9:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104fcc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104fcf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104fd2:	0f a3 10             	bt     %edx,(%eax)
  104fd5:	19 c0                	sbb    %eax,%eax
  104fd7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  104fda:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104fde:	0f 95 c0             	setne  %al
  104fe1:	0f b6 c0             	movzbl %al,%eax
  104fe4:	85 c0                	test   %eax,%eax
  104fe6:	75 1f                	jne    105007 <default_check+0x82>
  104fe8:	8d 83 9a f6 fe ff    	lea    -0x10966(%ebx),%eax
  104fee:	50                   	push   %eax
  104fef:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  104ff5:	50                   	push   %eax
  104ff6:	68 ce 00 00 00       	push   $0xce
  104ffb:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  105001:	50                   	push   %eax
  105002:	e8 c6 b4 ff ff       	call   1004cd <__panic>
        count ++, total += p->property;
  105007:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10500b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10500e:	8b 50 08             	mov    0x8(%eax),%edx
  105011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105014:	01 d0                	add    %edx,%eax
  105016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105019:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10501c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  10501f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105022:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105025:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105028:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  10502e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105031:	75 80                	jne    104fb3 <default_check+0x2e>
    }
    assert(total == nr_free_pages());
  105033:	e8 ad de ff ff       	call   102ee5 <nr_free_pages>
  105038:	89 c2                	mov    %eax,%edx
  10503a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10503d:	39 c2                	cmp    %eax,%edx
  10503f:	74 1f                	je     105060 <default_check+0xdb>
  105041:	8d 83 aa f6 fe ff    	lea    -0x10956(%ebx),%eax
  105047:	50                   	push   %eax
  105048:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  10504e:	50                   	push   %eax
  10504f:	68 d1 00 00 00       	push   $0xd1
  105054:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  10505a:	50                   	push   %eax
  10505b:	e8 6d b4 ff ff       	call   1004cd <__panic>

    basic_check();
  105060:	e8 07 fa ff ff       	call   104a6c <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  105065:	83 ec 0c             	sub    $0xc,%esp
  105068:	6a 05                	push   $0x5
  10506a:	e8 df dd ff ff       	call   102e4e <alloc_pages>
  10506f:	83 c4 10             	add    $0x10,%esp
  105072:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  105075:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105079:	75 1f                	jne    10509a <default_check+0x115>
  10507b:	8d 83 c3 f6 fe ff    	lea    -0x1093d(%ebx),%eax
  105081:	50                   	push   %eax
  105082:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  105088:	50                   	push   %eax
  105089:	68 d6 00 00 00       	push   $0xd6
  10508e:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  105094:	50                   	push   %eax
  105095:	e8 33 b4 ff ff       	call   1004cd <__panic>
    assert(!PageProperty(p0));
  10509a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10509d:	83 c0 04             	add    $0x4,%eax
  1050a0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1050a7:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1050aa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1050ad:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1050b0:	0f a3 10             	bt     %edx,(%eax)
  1050b3:	19 c0                	sbb    %eax,%eax
  1050b5:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1050b8:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1050bc:	0f 95 c0             	setne  %al
  1050bf:	0f b6 c0             	movzbl %al,%eax
  1050c2:	85 c0                	test   %eax,%eax
  1050c4:	74 1f                	je     1050e5 <default_check+0x160>
  1050c6:	8d 83 ce f6 fe ff    	lea    -0x10932(%ebx),%eax
  1050cc:	50                   	push   %eax
  1050cd:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  1050d3:	50                   	push   %eax
  1050d4:	68 d7 00 00 00       	push   $0xd7
  1050d9:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  1050df:	50                   	push   %eax
  1050e0:	e8 e8 b3 ff ff       	call   1004cd <__panic>

    list_entry_t free_list_store = free_list;
  1050e5:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  1050eb:	8b 50 04             	mov    0x4(%eax),%edx
  1050ee:	8b 00                	mov    (%eax),%eax
  1050f0:	89 45 80             	mov    %eax,-0x80(%ebp)
  1050f3:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1050f6:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  1050fc:	89 45 b0             	mov    %eax,-0x50(%ebp)
    elm->prev = elm->next = elm;
  1050ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105102:	8b 55 b0             	mov    -0x50(%ebp),%edx
  105105:	89 50 04             	mov    %edx,0x4(%eax)
  105108:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10510b:	8b 50 04             	mov    0x4(%eax),%edx
  10510e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105111:	89 10                	mov    %edx,(%eax)
  105113:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  105119:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return list->next == list;
  10511c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10511f:	8b 40 04             	mov    0x4(%eax),%eax
  105122:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  105125:	0f 94 c0             	sete   %al
  105128:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10512b:	85 c0                	test   %eax,%eax
  10512d:	75 1f                	jne    10514e <default_check+0x1c9>
  10512f:	8d 83 23 f6 fe ff    	lea    -0x109dd(%ebx),%eax
  105135:	50                   	push   %eax
  105136:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  10513c:	50                   	push   %eax
  10513d:	68 db 00 00 00       	push   $0xdb
  105142:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  105148:	50                   	push   %eax
  105149:	e8 7f b3 ff ff       	call   1004cd <__panic>
    assert(alloc_page() == NULL);
  10514e:	83 ec 0c             	sub    $0xc,%esp
  105151:	6a 01                	push   $0x1
  105153:	e8 f6 dc ff ff       	call   102e4e <alloc_pages>
  105158:	83 c4 10             	add    $0x10,%esp
  10515b:	85 c0                	test   %eax,%eax
  10515d:	74 1f                	je     10517e <default_check+0x1f9>
  10515f:	8d 83 3a f6 fe ff    	lea    -0x109c6(%ebx),%eax
  105165:	50                   	push   %eax
  105166:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  10516c:	50                   	push   %eax
  10516d:	68 dc 00 00 00       	push   $0xdc
  105172:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  105178:	50                   	push   %eax
  105179:	e8 4f b3 ff ff       	call   1004cd <__panic>

    unsigned int nr_free_store = nr_free;
  10517e:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  105184:	8b 40 08             	mov    0x8(%eax),%eax
  105187:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  10518a:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  105190:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

    free_pages(p0 + 2, 3);
  105197:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10519a:	83 c0 28             	add    $0x28,%eax
  10519d:	83 ec 08             	sub    $0x8,%esp
  1051a0:	6a 03                	push   $0x3
  1051a2:	50                   	push   %eax
  1051a3:	e8 f6 dc ff ff       	call   102e9e <free_pages>
  1051a8:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
  1051ab:	83 ec 0c             	sub    $0xc,%esp
  1051ae:	6a 04                	push   $0x4
  1051b0:	e8 99 dc ff ff       	call   102e4e <alloc_pages>
  1051b5:	83 c4 10             	add    $0x10,%esp
  1051b8:	85 c0                	test   %eax,%eax
  1051ba:	74 1f                	je     1051db <default_check+0x256>
  1051bc:	8d 83 e0 f6 fe ff    	lea    -0x10920(%ebx),%eax
  1051c2:	50                   	push   %eax
  1051c3:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  1051c9:	50                   	push   %eax
  1051ca:	68 e2 00 00 00       	push   $0xe2
  1051cf:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  1051d5:	50                   	push   %eax
  1051d6:	e8 f2 b2 ff ff       	call   1004cd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1051db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051de:	83 c0 28             	add    $0x28,%eax
  1051e1:	83 c0 04             	add    $0x4,%eax
  1051e4:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1051eb:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1051ee:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1051f1:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1051f4:	0f a3 10             	bt     %edx,(%eax)
  1051f7:	19 c0                	sbb    %eax,%eax
  1051f9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1051fc:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  105200:	0f 95 c0             	setne  %al
  105203:	0f b6 c0             	movzbl %al,%eax
  105206:	85 c0                	test   %eax,%eax
  105208:	74 0e                	je     105218 <default_check+0x293>
  10520a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10520d:	83 c0 28             	add    $0x28,%eax
  105210:	8b 40 08             	mov    0x8(%eax),%eax
  105213:	83 f8 03             	cmp    $0x3,%eax
  105216:	74 1f                	je     105237 <default_check+0x2b2>
  105218:	8d 83 f8 f6 fe ff    	lea    -0x10908(%ebx),%eax
  10521e:	50                   	push   %eax
  10521f:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  105225:	50                   	push   %eax
  105226:	68 e3 00 00 00       	push   $0xe3
  10522b:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  105231:	50                   	push   %eax
  105232:	e8 96 b2 ff ff       	call   1004cd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  105237:	83 ec 0c             	sub    $0xc,%esp
  10523a:	6a 03                	push   $0x3
  10523c:	e8 0d dc ff ff       	call   102e4e <alloc_pages>
  105241:	83 c4 10             	add    $0x10,%esp
  105244:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105247:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10524b:	75 1f                	jne    10526c <default_check+0x2e7>
  10524d:	8d 83 24 f7 fe ff    	lea    -0x108dc(%ebx),%eax
  105253:	50                   	push   %eax
  105254:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  10525a:	50                   	push   %eax
  10525b:	68 e4 00 00 00       	push   $0xe4
  105260:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  105266:	50                   	push   %eax
  105267:	e8 61 b2 ff ff       	call   1004cd <__panic>
    assert(alloc_page() == NULL);
  10526c:	83 ec 0c             	sub    $0xc,%esp
  10526f:	6a 01                	push   $0x1
  105271:	e8 d8 db ff ff       	call   102e4e <alloc_pages>
  105276:	83 c4 10             	add    $0x10,%esp
  105279:	85 c0                	test   %eax,%eax
  10527b:	74 1f                	je     10529c <default_check+0x317>
  10527d:	8d 83 3a f6 fe ff    	lea    -0x109c6(%ebx),%eax
  105283:	50                   	push   %eax
  105284:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  10528a:	50                   	push   %eax
  10528b:	68 e5 00 00 00       	push   $0xe5
  105290:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  105296:	50                   	push   %eax
  105297:	e8 31 b2 ff ff       	call   1004cd <__panic>
    assert(p0 + 2 == p1);
  10529c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10529f:	83 c0 28             	add    $0x28,%eax
  1052a2:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1052a5:	74 1f                	je     1052c6 <default_check+0x341>
  1052a7:	8d 83 42 f7 fe ff    	lea    -0x108be(%ebx),%eax
  1052ad:	50                   	push   %eax
  1052ae:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  1052b4:	50                   	push   %eax
  1052b5:	68 e6 00 00 00       	push   $0xe6
  1052ba:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  1052c0:	50                   	push   %eax
  1052c1:	e8 07 b2 ff ff       	call   1004cd <__panic>

    p2 = p0 + 1;
  1052c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052c9:	83 c0 14             	add    $0x14,%eax
  1052cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1052cf:	83 ec 08             	sub    $0x8,%esp
  1052d2:	6a 01                	push   $0x1
  1052d4:	ff 75 e8             	pushl  -0x18(%ebp)
  1052d7:	e8 c2 db ff ff       	call   102e9e <free_pages>
  1052dc:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
  1052df:	83 ec 08             	sub    $0x8,%esp
  1052e2:	6a 03                	push   $0x3
  1052e4:	ff 75 e0             	pushl  -0x20(%ebp)
  1052e7:	e8 b2 db ff ff       	call   102e9e <free_pages>
  1052ec:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
  1052ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052f2:	83 c0 04             	add    $0x4,%eax
  1052f5:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1052fc:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1052ff:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105302:	8b 55 a0             	mov    -0x60(%ebp),%edx
  105305:	0f a3 10             	bt     %edx,(%eax)
  105308:	19 c0                	sbb    %eax,%eax
  10530a:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10530d:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  105311:	0f 95 c0             	setne  %al
  105314:	0f b6 c0             	movzbl %al,%eax
  105317:	85 c0                	test   %eax,%eax
  105319:	74 0b                	je     105326 <default_check+0x3a1>
  10531b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10531e:	8b 40 08             	mov    0x8(%eax),%eax
  105321:	83 f8 01             	cmp    $0x1,%eax
  105324:	74 1f                	je     105345 <default_check+0x3c0>
  105326:	8d 83 50 f7 fe ff    	lea    -0x108b0(%ebx),%eax
  10532c:	50                   	push   %eax
  10532d:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  105333:	50                   	push   %eax
  105334:	68 eb 00 00 00       	push   $0xeb
  105339:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  10533f:	50                   	push   %eax
  105340:	e8 88 b1 ff ff       	call   1004cd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  105345:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105348:	83 c0 04             	add    $0x4,%eax
  10534b:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  105352:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105355:	8b 45 90             	mov    -0x70(%ebp),%eax
  105358:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10535b:	0f a3 10             	bt     %edx,(%eax)
  10535e:	19 c0                	sbb    %eax,%eax
  105360:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  105363:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  105367:	0f 95 c0             	setne  %al
  10536a:	0f b6 c0             	movzbl %al,%eax
  10536d:	85 c0                	test   %eax,%eax
  10536f:	74 0b                	je     10537c <default_check+0x3f7>
  105371:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105374:	8b 40 08             	mov    0x8(%eax),%eax
  105377:	83 f8 03             	cmp    $0x3,%eax
  10537a:	74 1f                	je     10539b <default_check+0x416>
  10537c:	8d 83 78 f7 fe ff    	lea    -0x10888(%ebx),%eax
  105382:	50                   	push   %eax
  105383:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  105389:	50                   	push   %eax
  10538a:	68 ec 00 00 00       	push   $0xec
  10538f:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  105395:	50                   	push   %eax
  105396:	e8 32 b1 ff ff       	call   1004cd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  10539b:	83 ec 0c             	sub    $0xc,%esp
  10539e:	6a 01                	push   $0x1
  1053a0:	e8 a9 da ff ff       	call   102e4e <alloc_pages>
  1053a5:	83 c4 10             	add    $0x10,%esp
  1053a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1053ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053ae:	83 e8 14             	sub    $0x14,%eax
  1053b1:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1053b4:	74 1f                	je     1053d5 <default_check+0x450>
  1053b6:	8d 83 9e f7 fe ff    	lea    -0x10862(%ebx),%eax
  1053bc:	50                   	push   %eax
  1053bd:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  1053c3:	50                   	push   %eax
  1053c4:	68 ee 00 00 00       	push   $0xee
  1053c9:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  1053cf:	50                   	push   %eax
  1053d0:	e8 f8 b0 ff ff       	call   1004cd <__panic>
    free_page(p0);
  1053d5:	83 ec 08             	sub    $0x8,%esp
  1053d8:	6a 01                	push   $0x1
  1053da:	ff 75 e8             	pushl  -0x18(%ebp)
  1053dd:	e8 bc da ff ff       	call   102e9e <free_pages>
  1053e2:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1053e5:	83 ec 0c             	sub    $0xc,%esp
  1053e8:	6a 02                	push   $0x2
  1053ea:	e8 5f da ff ff       	call   102e4e <alloc_pages>
  1053ef:	83 c4 10             	add    $0x10,%esp
  1053f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1053f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053f8:	83 c0 14             	add    $0x14,%eax
  1053fb:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1053fe:	74 1f                	je     10541f <default_check+0x49a>
  105400:	8d 83 bc f7 fe ff    	lea    -0x10844(%ebx),%eax
  105406:	50                   	push   %eax
  105407:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  10540d:	50                   	push   %eax
  10540e:	68 f0 00 00 00       	push   $0xf0
  105413:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  105419:	50                   	push   %eax
  10541a:	e8 ae b0 ff ff       	call   1004cd <__panic>

    free_pages(p0, 2);
  10541f:	83 ec 08             	sub    $0x8,%esp
  105422:	6a 02                	push   $0x2
  105424:	ff 75 e8             	pushl  -0x18(%ebp)
  105427:	e8 72 da ff ff       	call   102e9e <free_pages>
  10542c:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  10542f:	83 ec 08             	sub    $0x8,%esp
  105432:	6a 01                	push   $0x1
  105434:	ff 75 dc             	pushl  -0x24(%ebp)
  105437:	e8 62 da ff ff       	call   102e9e <free_pages>
  10543c:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
  10543f:	83 ec 0c             	sub    $0xc,%esp
  105442:	6a 05                	push   $0x5
  105444:	e8 05 da ff ff       	call   102e4e <alloc_pages>
  105449:	83 c4 10             	add    $0x10,%esp
  10544c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10544f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105453:	75 1f                	jne    105474 <default_check+0x4ef>
  105455:	8d 83 dc f7 fe ff    	lea    -0x10824(%ebx),%eax
  10545b:	50                   	push   %eax
  10545c:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  105462:	50                   	push   %eax
  105463:	68 f5 00 00 00       	push   $0xf5
  105468:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  10546e:	50                   	push   %eax
  10546f:	e8 59 b0 ff ff       	call   1004cd <__panic>
    assert(alloc_page() == NULL);
  105474:	83 ec 0c             	sub    $0xc,%esp
  105477:	6a 01                	push   $0x1
  105479:	e8 d0 d9 ff ff       	call   102e4e <alloc_pages>
  10547e:	83 c4 10             	add    $0x10,%esp
  105481:	85 c0                	test   %eax,%eax
  105483:	74 1f                	je     1054a4 <default_check+0x51f>
  105485:	8d 83 3a f6 fe ff    	lea    -0x109c6(%ebx),%eax
  10548b:	50                   	push   %eax
  10548c:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  105492:	50                   	push   %eax
  105493:	68 f6 00 00 00       	push   $0xf6
  105498:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  10549e:	50                   	push   %eax
  10549f:	e8 29 b0 ff ff       	call   1004cd <__panic>

    assert(nr_free == 0);
  1054a4:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  1054aa:	8b 40 08             	mov    0x8(%eax),%eax
  1054ad:	85 c0                	test   %eax,%eax
  1054af:	74 1f                	je     1054d0 <default_check+0x54b>
  1054b1:	8d 83 8d f6 fe ff    	lea    -0x10973(%ebx),%eax
  1054b7:	50                   	push   %eax
  1054b8:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  1054be:	50                   	push   %eax
  1054bf:	68 f8 00 00 00       	push   $0xf8
  1054c4:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  1054ca:	50                   	push   %eax
  1054cb:	e8 fd af ff ff       	call   1004cd <__panic>
    nr_free = nr_free_store;
  1054d0:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  1054d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1054d9:	89 50 08             	mov    %edx,0x8(%eax)

    free_list = free_list_store;
  1054dc:	c7 c1 1c 8a 11 00    	mov    $0x118a1c,%ecx
  1054e2:	8b 45 80             	mov    -0x80(%ebp),%eax
  1054e5:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1054e8:	89 01                	mov    %eax,(%ecx)
  1054ea:	89 51 04             	mov    %edx,0x4(%ecx)
    free_pages(p0, 5);
  1054ed:	83 ec 08             	sub    $0x8,%esp
  1054f0:	6a 05                	push   $0x5
  1054f2:	ff 75 e8             	pushl  -0x18(%ebp)
  1054f5:	e8 a4 d9 ff ff       	call   102e9e <free_pages>
  1054fa:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
  1054fd:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  105503:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105506:	eb 1d                	jmp    105525 <default_check+0x5a0>
        struct Page *p = le2page(le, page_link);
  105508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10550b:	83 e8 0c             	sub    $0xc,%eax
  10550e:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  105511:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  105515:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105518:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10551b:	8b 40 08             	mov    0x8(%eax),%eax
  10551e:	29 c2                	sub    %eax,%edx
  105520:	89 d0                	mov    %edx,%eax
  105522:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105525:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105528:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  10552b:	8b 45 88             	mov    -0x78(%ebp),%eax
  10552e:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105531:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105534:	c7 c0 1c 8a 11 00    	mov    $0x118a1c,%eax
  10553a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10553d:	75 c9                	jne    105508 <default_check+0x583>
    }
    assert(count == 0);
  10553f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105543:	74 1f                	je     105564 <default_check+0x5df>
  105545:	8d 83 fa f7 fe ff    	lea    -0x10806(%ebx),%eax
  10554b:	50                   	push   %eax
  10554c:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  105552:	50                   	push   %eax
  105553:	68 03 01 00 00       	push   $0x103
  105558:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  10555e:	50                   	push   %eax
  10555f:	e8 69 af ff ff       	call   1004cd <__panic>
    assert(total == 0);
  105564:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105568:	74 1f                	je     105589 <default_check+0x604>
  10556a:	8d 83 05 f8 fe ff    	lea    -0x107fb(%ebx),%eax
  105570:	50                   	push   %eax
  105571:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
  105577:	50                   	push   %eax
  105578:	68 04 01 00 00       	push   $0x104
  10557d:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
  105583:	50                   	push   %eax
  105584:	e8 44 af ff ff       	call   1004cd <__panic>
}
  105589:	90                   	nop
  10558a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10558d:	c9                   	leave  
  10558e:	c3                   	ret    

0010558f <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  10558f:	55                   	push   %ebp
  105590:	89 e5                	mov    %esp,%ebp
  105592:	83 ec 10             	sub    $0x10,%esp
  105595:	e8 0c ad ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  10559a:	05 d6 23 01 00       	add    $0x123d6,%eax
    size_t cnt = 0;
  10559f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1055a6:	eb 04                	jmp    1055ac <strlen+0x1d>
        cnt ++;
  1055a8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  1055ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1055af:	8d 50 01             	lea    0x1(%eax),%edx
  1055b2:	89 55 08             	mov    %edx,0x8(%ebp)
  1055b5:	0f b6 00             	movzbl (%eax),%eax
  1055b8:	84 c0                	test   %al,%al
  1055ba:	75 ec                	jne    1055a8 <strlen+0x19>
    }
    return cnt;
  1055bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1055bf:	c9                   	leave  
  1055c0:	c3                   	ret    

001055c1 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1055c1:	55                   	push   %ebp
  1055c2:	89 e5                	mov    %esp,%ebp
  1055c4:	83 ec 10             	sub    $0x10,%esp
  1055c7:	e8 da ac ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1055cc:	05 a4 23 01 00       	add    $0x123a4,%eax
    size_t cnt = 0;
  1055d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1055d8:	eb 04                	jmp    1055de <strnlen+0x1d>
        cnt ++;
  1055da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1055de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1055e4:	73 10                	jae    1055f6 <strnlen+0x35>
  1055e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1055e9:	8d 50 01             	lea    0x1(%eax),%edx
  1055ec:	89 55 08             	mov    %edx,0x8(%ebp)
  1055ef:	0f b6 00             	movzbl (%eax),%eax
  1055f2:	84 c0                	test   %al,%al
  1055f4:	75 e4                	jne    1055da <strnlen+0x19>
    }
    return cnt;
  1055f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1055f9:	c9                   	leave  
  1055fa:	c3                   	ret    

001055fb <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1055fb:	55                   	push   %ebp
  1055fc:	89 e5                	mov    %esp,%ebp
  1055fe:	57                   	push   %edi
  1055ff:	56                   	push   %esi
  105600:	83 ec 20             	sub    $0x20,%esp
  105603:	e8 9e ac ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  105608:	05 68 23 01 00       	add    $0x12368,%eax
  10560d:	8b 45 08             	mov    0x8(%ebp),%eax
  105610:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105613:	8b 45 0c             	mov    0xc(%ebp),%eax
  105616:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105619:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10561c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10561f:	89 d1                	mov    %edx,%ecx
  105621:	89 c2                	mov    %eax,%edx
  105623:	89 ce                	mov    %ecx,%esi
  105625:	89 d7                	mov    %edx,%edi
  105627:	ac                   	lods   %ds:(%esi),%al
  105628:	aa                   	stos   %al,%es:(%edi)
  105629:	84 c0                	test   %al,%al
  10562b:	75 fa                	jne    105627 <strcpy+0x2c>
  10562d:	89 fa                	mov    %edi,%edx
  10562f:	89 f1                	mov    %esi,%ecx
  105631:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105634:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105637:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  10563a:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  10563d:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10563e:	83 c4 20             	add    $0x20,%esp
  105641:	5e                   	pop    %esi
  105642:	5f                   	pop    %edi
  105643:	5d                   	pop    %ebp
  105644:	c3                   	ret    

00105645 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105645:	55                   	push   %ebp
  105646:	89 e5                	mov    %esp,%ebp
  105648:	83 ec 10             	sub    $0x10,%esp
  10564b:	e8 56 ac ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  105650:	05 20 23 01 00       	add    $0x12320,%eax
    char *p = dst;
  105655:	8b 45 08             	mov    0x8(%ebp),%eax
  105658:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10565b:	eb 21                	jmp    10567e <strncpy+0x39>
        if ((*p = *src) != '\0') {
  10565d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105660:	0f b6 10             	movzbl (%eax),%edx
  105663:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105666:	88 10                	mov    %dl,(%eax)
  105668:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10566b:	0f b6 00             	movzbl (%eax),%eax
  10566e:	84 c0                	test   %al,%al
  105670:	74 04                	je     105676 <strncpy+0x31>
            src ++;
  105672:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105676:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10567a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  10567e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105682:	75 d9                	jne    10565d <strncpy+0x18>
    }
    return dst;
  105684:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105687:	c9                   	leave  
  105688:	c3                   	ret    

00105689 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105689:	55                   	push   %ebp
  10568a:	89 e5                	mov    %esp,%ebp
  10568c:	57                   	push   %edi
  10568d:	56                   	push   %esi
  10568e:	83 ec 20             	sub    $0x20,%esp
  105691:	e8 10 ac ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  105696:	05 da 22 01 00       	add    $0x122da,%eax
  10569b:	8b 45 08             	mov    0x8(%ebp),%eax
  10569e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1056a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1056a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1056aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056ad:	89 d1                	mov    %edx,%ecx
  1056af:	89 c2                	mov    %eax,%edx
  1056b1:	89 ce                	mov    %ecx,%esi
  1056b3:	89 d7                	mov    %edx,%edi
  1056b5:	ac                   	lods   %ds:(%esi),%al
  1056b6:	ae                   	scas   %es:(%edi),%al
  1056b7:	75 08                	jne    1056c1 <strcmp+0x38>
  1056b9:	84 c0                	test   %al,%al
  1056bb:	75 f8                	jne    1056b5 <strcmp+0x2c>
  1056bd:	31 c0                	xor    %eax,%eax
  1056bf:	eb 04                	jmp    1056c5 <strcmp+0x3c>
  1056c1:	19 c0                	sbb    %eax,%eax
  1056c3:	0c 01                	or     $0x1,%al
  1056c5:	89 fa                	mov    %edi,%edx
  1056c7:	89 f1                	mov    %esi,%ecx
  1056c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1056cc:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1056cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1056d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  1056d5:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1056d6:	83 c4 20             	add    $0x20,%esp
  1056d9:	5e                   	pop    %esi
  1056da:	5f                   	pop    %edi
  1056db:	5d                   	pop    %ebp
  1056dc:	c3                   	ret    

001056dd <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1056dd:	55                   	push   %ebp
  1056de:	89 e5                	mov    %esp,%ebp
  1056e0:	e8 c1 ab ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1056e5:	05 8b 22 01 00       	add    $0x1228b,%eax
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1056ea:	eb 0c                	jmp    1056f8 <strncmp+0x1b>
        n --, s1 ++, s2 ++;
  1056ec:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1056f0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1056f4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1056f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1056fc:	74 1a                	je     105718 <strncmp+0x3b>
  1056fe:	8b 45 08             	mov    0x8(%ebp),%eax
  105701:	0f b6 00             	movzbl (%eax),%eax
  105704:	84 c0                	test   %al,%al
  105706:	74 10                	je     105718 <strncmp+0x3b>
  105708:	8b 45 08             	mov    0x8(%ebp),%eax
  10570b:	0f b6 10             	movzbl (%eax),%edx
  10570e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105711:	0f b6 00             	movzbl (%eax),%eax
  105714:	38 c2                	cmp    %al,%dl
  105716:	74 d4                	je     1056ec <strncmp+0xf>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105718:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10571c:	74 18                	je     105736 <strncmp+0x59>
  10571e:	8b 45 08             	mov    0x8(%ebp),%eax
  105721:	0f b6 00             	movzbl (%eax),%eax
  105724:	0f b6 d0             	movzbl %al,%edx
  105727:	8b 45 0c             	mov    0xc(%ebp),%eax
  10572a:	0f b6 00             	movzbl (%eax),%eax
  10572d:	0f b6 c0             	movzbl %al,%eax
  105730:	29 c2                	sub    %eax,%edx
  105732:	89 d0                	mov    %edx,%eax
  105734:	eb 05                	jmp    10573b <strncmp+0x5e>
  105736:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10573b:	5d                   	pop    %ebp
  10573c:	c3                   	ret    

0010573d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10573d:	55                   	push   %ebp
  10573e:	89 e5                	mov    %esp,%ebp
  105740:	83 ec 04             	sub    $0x4,%esp
  105743:	e8 5e ab ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  105748:	05 28 22 01 00       	add    $0x12228,%eax
  10574d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105750:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105753:	eb 14                	jmp    105769 <strchr+0x2c>
        if (*s == c) {
  105755:	8b 45 08             	mov    0x8(%ebp),%eax
  105758:	0f b6 00             	movzbl (%eax),%eax
  10575b:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10575e:	75 05                	jne    105765 <strchr+0x28>
            return (char *)s;
  105760:	8b 45 08             	mov    0x8(%ebp),%eax
  105763:	eb 13                	jmp    105778 <strchr+0x3b>
        }
        s ++;
  105765:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  105769:	8b 45 08             	mov    0x8(%ebp),%eax
  10576c:	0f b6 00             	movzbl (%eax),%eax
  10576f:	84 c0                	test   %al,%al
  105771:	75 e2                	jne    105755 <strchr+0x18>
    }
    return NULL;
  105773:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105778:	c9                   	leave  
  105779:	c3                   	ret    

0010577a <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10577a:	55                   	push   %ebp
  10577b:	89 e5                	mov    %esp,%ebp
  10577d:	83 ec 04             	sub    $0x4,%esp
  105780:	e8 21 ab ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  105785:	05 eb 21 01 00       	add    $0x121eb,%eax
  10578a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10578d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105790:	eb 0f                	jmp    1057a1 <strfind+0x27>
        if (*s == c) {
  105792:	8b 45 08             	mov    0x8(%ebp),%eax
  105795:	0f b6 00             	movzbl (%eax),%eax
  105798:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10579b:	74 10                	je     1057ad <strfind+0x33>
            break;
        }
        s ++;
  10579d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  1057a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057a4:	0f b6 00             	movzbl (%eax),%eax
  1057a7:	84 c0                	test   %al,%al
  1057a9:	75 e7                	jne    105792 <strfind+0x18>
  1057ab:	eb 01                	jmp    1057ae <strfind+0x34>
            break;
  1057ad:	90                   	nop
    }
    return (char *)s;
  1057ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1057b1:	c9                   	leave  
  1057b2:	c3                   	ret    

001057b3 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1057b3:	55                   	push   %ebp
  1057b4:	89 e5                	mov    %esp,%ebp
  1057b6:	83 ec 10             	sub    $0x10,%esp
  1057b9:	e8 e8 aa ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1057be:	05 b2 21 01 00       	add    $0x121b2,%eax
    int neg = 0;
  1057c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1057ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1057d1:	eb 04                	jmp    1057d7 <strtol+0x24>
        s ++;
  1057d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1057d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1057da:	0f b6 00             	movzbl (%eax),%eax
  1057dd:	3c 20                	cmp    $0x20,%al
  1057df:	74 f2                	je     1057d3 <strtol+0x20>
  1057e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e4:	0f b6 00             	movzbl (%eax),%eax
  1057e7:	3c 09                	cmp    $0x9,%al
  1057e9:	74 e8                	je     1057d3 <strtol+0x20>
    }

    // plus/minus sign
    if (*s == '+') {
  1057eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ee:	0f b6 00             	movzbl (%eax),%eax
  1057f1:	3c 2b                	cmp    $0x2b,%al
  1057f3:	75 06                	jne    1057fb <strtol+0x48>
        s ++;
  1057f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1057f9:	eb 15                	jmp    105810 <strtol+0x5d>
    }
    else if (*s == '-') {
  1057fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1057fe:	0f b6 00             	movzbl (%eax),%eax
  105801:	3c 2d                	cmp    $0x2d,%al
  105803:	75 0b                	jne    105810 <strtol+0x5d>
        s ++, neg = 1;
  105805:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105809:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105810:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105814:	74 06                	je     10581c <strtol+0x69>
  105816:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10581a:	75 24                	jne    105840 <strtol+0x8d>
  10581c:	8b 45 08             	mov    0x8(%ebp),%eax
  10581f:	0f b6 00             	movzbl (%eax),%eax
  105822:	3c 30                	cmp    $0x30,%al
  105824:	75 1a                	jne    105840 <strtol+0x8d>
  105826:	8b 45 08             	mov    0x8(%ebp),%eax
  105829:	83 c0 01             	add    $0x1,%eax
  10582c:	0f b6 00             	movzbl (%eax),%eax
  10582f:	3c 78                	cmp    $0x78,%al
  105831:	75 0d                	jne    105840 <strtol+0x8d>
        s += 2, base = 16;
  105833:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105837:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10583e:	eb 2a                	jmp    10586a <strtol+0xb7>
    }
    else if (base == 0 && s[0] == '0') {
  105840:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105844:	75 17                	jne    10585d <strtol+0xaa>
  105846:	8b 45 08             	mov    0x8(%ebp),%eax
  105849:	0f b6 00             	movzbl (%eax),%eax
  10584c:	3c 30                	cmp    $0x30,%al
  10584e:	75 0d                	jne    10585d <strtol+0xaa>
        s ++, base = 8;
  105850:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105854:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10585b:	eb 0d                	jmp    10586a <strtol+0xb7>
    }
    else if (base == 0) {
  10585d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105861:	75 07                	jne    10586a <strtol+0xb7>
        base = 10;
  105863:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10586a:	8b 45 08             	mov    0x8(%ebp),%eax
  10586d:	0f b6 00             	movzbl (%eax),%eax
  105870:	3c 2f                	cmp    $0x2f,%al
  105872:	7e 1b                	jle    10588f <strtol+0xdc>
  105874:	8b 45 08             	mov    0x8(%ebp),%eax
  105877:	0f b6 00             	movzbl (%eax),%eax
  10587a:	3c 39                	cmp    $0x39,%al
  10587c:	7f 11                	jg     10588f <strtol+0xdc>
            dig = *s - '0';
  10587e:	8b 45 08             	mov    0x8(%ebp),%eax
  105881:	0f b6 00             	movzbl (%eax),%eax
  105884:	0f be c0             	movsbl %al,%eax
  105887:	83 e8 30             	sub    $0x30,%eax
  10588a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10588d:	eb 48                	jmp    1058d7 <strtol+0x124>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10588f:	8b 45 08             	mov    0x8(%ebp),%eax
  105892:	0f b6 00             	movzbl (%eax),%eax
  105895:	3c 60                	cmp    $0x60,%al
  105897:	7e 1b                	jle    1058b4 <strtol+0x101>
  105899:	8b 45 08             	mov    0x8(%ebp),%eax
  10589c:	0f b6 00             	movzbl (%eax),%eax
  10589f:	3c 7a                	cmp    $0x7a,%al
  1058a1:	7f 11                	jg     1058b4 <strtol+0x101>
            dig = *s - 'a' + 10;
  1058a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1058a6:	0f b6 00             	movzbl (%eax),%eax
  1058a9:	0f be c0             	movsbl %al,%eax
  1058ac:	83 e8 57             	sub    $0x57,%eax
  1058af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1058b2:	eb 23                	jmp    1058d7 <strtol+0x124>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1058b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1058b7:	0f b6 00             	movzbl (%eax),%eax
  1058ba:	3c 40                	cmp    $0x40,%al
  1058bc:	7e 3c                	jle    1058fa <strtol+0x147>
  1058be:	8b 45 08             	mov    0x8(%ebp),%eax
  1058c1:	0f b6 00             	movzbl (%eax),%eax
  1058c4:	3c 5a                	cmp    $0x5a,%al
  1058c6:	7f 32                	jg     1058fa <strtol+0x147>
            dig = *s - 'A' + 10;
  1058c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1058cb:	0f b6 00             	movzbl (%eax),%eax
  1058ce:	0f be c0             	movsbl %al,%eax
  1058d1:	83 e8 37             	sub    $0x37,%eax
  1058d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1058d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1058da:	3b 45 10             	cmp    0x10(%ebp),%eax
  1058dd:	7d 1a                	jge    1058f9 <strtol+0x146>
            break;
        }
        s ++, val = (val * base) + dig;
  1058df:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1058e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1058e6:	0f af 45 10          	imul   0x10(%ebp),%eax
  1058ea:	89 c2                	mov    %eax,%edx
  1058ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1058ef:	01 d0                	add    %edx,%eax
  1058f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1058f4:	e9 71 ff ff ff       	jmp    10586a <strtol+0xb7>
            break;
  1058f9:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1058fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1058fe:	74 08                	je     105908 <strtol+0x155>
        *endptr = (char *) s;
  105900:	8b 45 0c             	mov    0xc(%ebp),%eax
  105903:	8b 55 08             	mov    0x8(%ebp),%edx
  105906:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105908:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10590c:	74 07                	je     105915 <strtol+0x162>
  10590e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105911:	f7 d8                	neg    %eax
  105913:	eb 03                	jmp    105918 <strtol+0x165>
  105915:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105918:	c9                   	leave  
  105919:	c3                   	ret    

0010591a <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10591a:	55                   	push   %ebp
  10591b:	89 e5                	mov    %esp,%ebp
  10591d:	57                   	push   %edi
  10591e:	83 ec 24             	sub    $0x24,%esp
  105921:	e8 80 a9 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  105926:	05 4a 20 01 00       	add    $0x1204a,%eax
  10592b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10592e:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105931:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105935:	8b 55 08             	mov    0x8(%ebp),%edx
  105938:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10593b:	88 45 f7             	mov    %al,-0x9(%ebp)
  10593e:	8b 45 10             	mov    0x10(%ebp),%eax
  105941:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105944:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105947:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10594b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10594e:	89 d7                	mov    %edx,%edi
  105950:	f3 aa                	rep stos %al,%es:(%edi)
  105952:	89 fa                	mov    %edi,%edx
  105954:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105957:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  10595a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10595d:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10595e:	83 c4 24             	add    $0x24,%esp
  105961:	5f                   	pop    %edi
  105962:	5d                   	pop    %ebp
  105963:	c3                   	ret    

00105964 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105964:	55                   	push   %ebp
  105965:	89 e5                	mov    %esp,%ebp
  105967:	57                   	push   %edi
  105968:	56                   	push   %esi
  105969:	53                   	push   %ebx
  10596a:	83 ec 30             	sub    $0x30,%esp
  10596d:	e8 34 a9 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  105972:	05 fe 1f 01 00       	add    $0x11ffe,%eax
  105977:	8b 45 08             	mov    0x8(%ebp),%eax
  10597a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10597d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105980:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105983:	8b 45 10             	mov    0x10(%ebp),%eax
  105986:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10598c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10598f:	73 42                	jae    1059d3 <memmove+0x6f>
  105991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105994:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105997:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10599a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10599d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1059a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1059a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1059a6:	c1 e8 02             	shr    $0x2,%eax
  1059a9:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1059ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1059ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059b1:	89 d7                	mov    %edx,%edi
  1059b3:	89 c6                	mov    %eax,%esi
  1059b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1059b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1059ba:	83 e1 03             	and    $0x3,%ecx
  1059bd:	74 02                	je     1059c1 <memmove+0x5d>
  1059bf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1059c1:	89 f0                	mov    %esi,%eax
  1059c3:	89 fa                	mov    %edi,%edx
  1059c5:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1059c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1059cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  1059ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  1059d1:	eb 36                	jmp    105a09 <memmove+0xa5>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1059d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1059d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1059d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059dc:	01 c2                	add    %eax,%edx
  1059de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1059e1:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1059e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059e7:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1059ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1059ed:	89 c1                	mov    %eax,%ecx
  1059ef:	89 d8                	mov    %ebx,%eax
  1059f1:	89 d6                	mov    %edx,%esi
  1059f3:	89 c7                	mov    %eax,%edi
  1059f5:	fd                   	std    
  1059f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1059f8:	fc                   	cld    
  1059f9:	89 f8                	mov    %edi,%eax
  1059fb:	89 f2                	mov    %esi,%edx
  1059fd:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105a00:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105a03:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105a09:	83 c4 30             	add    $0x30,%esp
  105a0c:	5b                   	pop    %ebx
  105a0d:	5e                   	pop    %esi
  105a0e:	5f                   	pop    %edi
  105a0f:	5d                   	pop    %ebp
  105a10:	c3                   	ret    

00105a11 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105a11:	55                   	push   %ebp
  105a12:	89 e5                	mov    %esp,%ebp
  105a14:	57                   	push   %edi
  105a15:	56                   	push   %esi
  105a16:	83 ec 20             	sub    $0x20,%esp
  105a19:	e8 88 a8 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  105a1e:	05 52 1f 01 00       	add    $0x11f52,%eax
  105a23:	8b 45 08             	mov    0x8(%ebp),%eax
  105a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a2f:	8b 45 10             	mov    0x10(%ebp),%eax
  105a32:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a38:	c1 e8 02             	shr    $0x2,%eax
  105a3b:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a43:	89 d7                	mov    %edx,%edi
  105a45:	89 c6                	mov    %eax,%esi
  105a47:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105a49:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105a4c:	83 e1 03             	and    $0x3,%ecx
  105a4f:	74 02                	je     105a53 <memcpy+0x42>
  105a51:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105a53:	89 f0                	mov    %esi,%eax
  105a55:	89 fa                	mov    %edi,%edx
  105a57:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105a5a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105a5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  105a63:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105a64:	83 c4 20             	add    $0x20,%esp
  105a67:	5e                   	pop    %esi
  105a68:	5f                   	pop    %edi
  105a69:	5d                   	pop    %ebp
  105a6a:	c3                   	ret    

00105a6b <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105a6b:	55                   	push   %ebp
  105a6c:	89 e5                	mov    %esp,%ebp
  105a6e:	83 ec 10             	sub    $0x10,%esp
  105a71:	e8 30 a8 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  105a76:	05 fa 1e 01 00       	add    $0x11efa,%eax
    const char *s1 = (const char *)v1;
  105a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  105a7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a84:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105a87:	eb 30                	jmp    105ab9 <memcmp+0x4e>
        if (*s1 != *s2) {
  105a89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a8c:	0f b6 10             	movzbl (%eax),%edx
  105a8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105a92:	0f b6 00             	movzbl (%eax),%eax
  105a95:	38 c2                	cmp    %al,%dl
  105a97:	74 18                	je     105ab1 <memcmp+0x46>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105a99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a9c:	0f b6 00             	movzbl (%eax),%eax
  105a9f:	0f b6 d0             	movzbl %al,%edx
  105aa2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105aa5:	0f b6 00             	movzbl (%eax),%eax
  105aa8:	0f b6 c0             	movzbl %al,%eax
  105aab:	29 c2                	sub    %eax,%edx
  105aad:	89 d0                	mov    %edx,%eax
  105aaf:	eb 1a                	jmp    105acb <memcmp+0x60>
        }
        s1 ++, s2 ++;
  105ab1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105ab5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  105ab9:	8b 45 10             	mov    0x10(%ebp),%eax
  105abc:	8d 50 ff             	lea    -0x1(%eax),%edx
  105abf:	89 55 10             	mov    %edx,0x10(%ebp)
  105ac2:	85 c0                	test   %eax,%eax
  105ac4:	75 c3                	jne    105a89 <memcmp+0x1e>
    }
    return 0;
  105ac6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105acb:	c9                   	leave  
  105acc:	c3                   	ret    

00105acd <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105acd:	55                   	push   %ebp
  105ace:	89 e5                	mov    %esp,%ebp
  105ad0:	53                   	push   %ebx
  105ad1:	83 ec 34             	sub    $0x34,%esp
  105ad4:	e8 d1 a7 ff ff       	call   1002aa <__x86.get_pc_thunk.bx>
  105ad9:	81 c3 97 1e 01 00    	add    $0x11e97,%ebx
  105adf:	8b 45 10             	mov    0x10(%ebp),%eax
  105ae2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105ae5:	8b 45 14             	mov    0x14(%ebp),%eax
  105ae8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105aeb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105aee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105af1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105af4:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105af7:	8b 45 18             	mov    0x18(%ebp),%eax
  105afa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105afd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b00:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105b03:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105b06:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105b13:	74 1c                	je     105b31 <printnum+0x64>
  105b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b18:	ba 00 00 00 00       	mov    $0x0,%edx
  105b1d:	f7 75 e4             	divl   -0x1c(%ebp)
  105b20:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b26:	ba 00 00 00 00       	mov    $0x0,%edx
  105b2b:	f7 75 e4             	divl   -0x1c(%ebp)
  105b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b37:	f7 75 e4             	divl   -0x1c(%ebp)
  105b3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105b3d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105b40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b46:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105b49:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105b4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105b4f:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105b52:	8b 45 18             	mov    0x18(%ebp),%eax
  105b55:	ba 00 00 00 00       	mov    $0x0,%edx
  105b5a:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  105b5d:	72 41                	jb     105ba0 <printnum+0xd3>
  105b5f:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  105b62:	77 05                	ja     105b69 <printnum+0x9c>
  105b64:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105b67:	72 37                	jb     105ba0 <printnum+0xd3>
        printnum(putch, putdat, result, base, width - 1, padc);
  105b69:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105b6c:	83 e8 01             	sub    $0x1,%eax
  105b6f:	83 ec 04             	sub    $0x4,%esp
  105b72:	ff 75 20             	pushl  0x20(%ebp)
  105b75:	50                   	push   %eax
  105b76:	ff 75 18             	pushl  0x18(%ebp)
  105b79:	ff 75 ec             	pushl  -0x14(%ebp)
  105b7c:	ff 75 e8             	pushl  -0x18(%ebp)
  105b7f:	ff 75 0c             	pushl  0xc(%ebp)
  105b82:	ff 75 08             	pushl  0x8(%ebp)
  105b85:	e8 43 ff ff ff       	call   105acd <printnum>
  105b8a:	83 c4 20             	add    $0x20,%esp
  105b8d:	eb 1b                	jmp    105baa <printnum+0xdd>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105b8f:	83 ec 08             	sub    $0x8,%esp
  105b92:	ff 75 0c             	pushl  0xc(%ebp)
  105b95:	ff 75 20             	pushl  0x20(%ebp)
  105b98:	8b 45 08             	mov    0x8(%ebp),%eax
  105b9b:	ff d0                	call   *%eax
  105b9d:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  105ba0:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105ba4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105ba8:	7f e5                	jg     105b8f <printnum+0xc2>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105baa:	8d 93 86 f8 fe ff    	lea    -0x1077a(%ebx),%edx
  105bb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105bb3:	01 d0                	add    %edx,%eax
  105bb5:	0f b6 00             	movzbl (%eax),%eax
  105bb8:	0f be c0             	movsbl %al,%eax
  105bbb:	83 ec 08             	sub    $0x8,%esp
  105bbe:	ff 75 0c             	pushl  0xc(%ebp)
  105bc1:	50                   	push   %eax
  105bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  105bc5:	ff d0                	call   *%eax
  105bc7:	83 c4 10             	add    $0x10,%esp
}
  105bca:	90                   	nop
  105bcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  105bce:	c9                   	leave  
  105bcf:	c3                   	ret    

00105bd0 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105bd0:	55                   	push   %ebp
  105bd1:	89 e5                	mov    %esp,%ebp
  105bd3:	e8 ce a6 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  105bd8:	05 98 1d 01 00       	add    $0x11d98,%eax
    if (lflag >= 2) {
  105bdd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105be1:	7e 14                	jle    105bf7 <getuint+0x27>
        return va_arg(*ap, unsigned long long);
  105be3:	8b 45 08             	mov    0x8(%ebp),%eax
  105be6:	8b 00                	mov    (%eax),%eax
  105be8:	8d 48 08             	lea    0x8(%eax),%ecx
  105beb:	8b 55 08             	mov    0x8(%ebp),%edx
  105bee:	89 0a                	mov    %ecx,(%edx)
  105bf0:	8b 50 04             	mov    0x4(%eax),%edx
  105bf3:	8b 00                	mov    (%eax),%eax
  105bf5:	eb 30                	jmp    105c27 <getuint+0x57>
    }
    else if (lflag) {
  105bf7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105bfb:	74 16                	je     105c13 <getuint+0x43>
        return va_arg(*ap, unsigned long);
  105bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  105c00:	8b 00                	mov    (%eax),%eax
  105c02:	8d 48 04             	lea    0x4(%eax),%ecx
  105c05:	8b 55 08             	mov    0x8(%ebp),%edx
  105c08:	89 0a                	mov    %ecx,(%edx)
  105c0a:	8b 00                	mov    (%eax),%eax
  105c0c:	ba 00 00 00 00       	mov    $0x0,%edx
  105c11:	eb 14                	jmp    105c27 <getuint+0x57>
    }
    else {
        return va_arg(*ap, unsigned int);
  105c13:	8b 45 08             	mov    0x8(%ebp),%eax
  105c16:	8b 00                	mov    (%eax),%eax
  105c18:	8d 48 04             	lea    0x4(%eax),%ecx
  105c1b:	8b 55 08             	mov    0x8(%ebp),%edx
  105c1e:	89 0a                	mov    %ecx,(%edx)
  105c20:	8b 00                	mov    (%eax),%eax
  105c22:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105c27:	5d                   	pop    %ebp
  105c28:	c3                   	ret    

00105c29 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105c29:	55                   	push   %ebp
  105c2a:	89 e5                	mov    %esp,%ebp
  105c2c:	e8 75 a6 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  105c31:	05 3f 1d 01 00       	add    $0x11d3f,%eax
    if (lflag >= 2) {
  105c36:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105c3a:	7e 14                	jle    105c50 <getint+0x27>
        return va_arg(*ap, long long);
  105c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c3f:	8b 00                	mov    (%eax),%eax
  105c41:	8d 48 08             	lea    0x8(%eax),%ecx
  105c44:	8b 55 08             	mov    0x8(%ebp),%edx
  105c47:	89 0a                	mov    %ecx,(%edx)
  105c49:	8b 50 04             	mov    0x4(%eax),%edx
  105c4c:	8b 00                	mov    (%eax),%eax
  105c4e:	eb 28                	jmp    105c78 <getint+0x4f>
    }
    else if (lflag) {
  105c50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105c54:	74 12                	je     105c68 <getint+0x3f>
        return va_arg(*ap, long);
  105c56:	8b 45 08             	mov    0x8(%ebp),%eax
  105c59:	8b 00                	mov    (%eax),%eax
  105c5b:	8d 48 04             	lea    0x4(%eax),%ecx
  105c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  105c61:	89 0a                	mov    %ecx,(%edx)
  105c63:	8b 00                	mov    (%eax),%eax
  105c65:	99                   	cltd   
  105c66:	eb 10                	jmp    105c78 <getint+0x4f>
    }
    else {
        return va_arg(*ap, int);
  105c68:	8b 45 08             	mov    0x8(%ebp),%eax
  105c6b:	8b 00                	mov    (%eax),%eax
  105c6d:	8d 48 04             	lea    0x4(%eax),%ecx
  105c70:	8b 55 08             	mov    0x8(%ebp),%edx
  105c73:	89 0a                	mov    %ecx,(%edx)
  105c75:	8b 00                	mov    (%eax),%eax
  105c77:	99                   	cltd   
    }
}
  105c78:	5d                   	pop    %ebp
  105c79:	c3                   	ret    

00105c7a <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105c7a:	55                   	push   %ebp
  105c7b:	89 e5                	mov    %esp,%ebp
  105c7d:	83 ec 18             	sub    $0x18,%esp
  105c80:	e8 21 a6 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  105c85:	05 eb 1c 01 00       	add    $0x11ceb,%eax
    va_list ap;

    va_start(ap, fmt);
  105c8a:	8d 45 14             	lea    0x14(%ebp),%eax
  105c8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c93:	50                   	push   %eax
  105c94:	ff 75 10             	pushl  0x10(%ebp)
  105c97:	ff 75 0c             	pushl  0xc(%ebp)
  105c9a:	ff 75 08             	pushl  0x8(%ebp)
  105c9d:	e8 06 00 00 00       	call   105ca8 <vprintfmt>
  105ca2:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  105ca5:	90                   	nop
  105ca6:	c9                   	leave  
  105ca7:	c3                   	ret    

00105ca8 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105ca8:	55                   	push   %ebp
  105ca9:	89 e5                	mov    %esp,%ebp
  105cab:	57                   	push   %edi
  105cac:	56                   	push   %esi
  105cad:	53                   	push   %ebx
  105cae:	83 ec 2c             	sub    $0x2c,%esp
  105cb1:	e8 8c 04 00 00       	call   106142 <__x86.get_pc_thunk.di>
  105cb6:	81 c7 ba 1c 01 00    	add    $0x11cba,%edi
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105cbc:	eb 17                	jmp    105cd5 <vprintfmt+0x2d>
            if (ch == '\0') {
  105cbe:	85 db                	test   %ebx,%ebx
  105cc0:	0f 84 9a 03 00 00    	je     106060 <.L24+0x2d>
                return;
            }
            putch(ch, putdat);
  105cc6:	83 ec 08             	sub    $0x8,%esp
  105cc9:	ff 75 0c             	pushl  0xc(%ebp)
  105ccc:	53                   	push   %ebx
  105ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd0:	ff d0                	call   *%eax
  105cd2:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105cd5:	8b 45 10             	mov    0x10(%ebp),%eax
  105cd8:	8d 50 01             	lea    0x1(%eax),%edx
  105cdb:	89 55 10             	mov    %edx,0x10(%ebp)
  105cde:	0f b6 00             	movzbl (%eax),%eax
  105ce1:	0f b6 d8             	movzbl %al,%ebx
  105ce4:	83 fb 25             	cmp    $0x25,%ebx
  105ce7:	75 d5                	jne    105cbe <vprintfmt+0x16>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105ce9:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
        width = precision = -1;
  105ced:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  105cf4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105cf7:	89 45 d8             	mov    %eax,-0x28(%ebp)
        lflag = altflag = 0;
  105cfa:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  105d01:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105d04:	89 45 d0             	mov    %eax,-0x30(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105d07:	8b 45 10             	mov    0x10(%ebp),%eax
  105d0a:	8d 50 01             	lea    0x1(%eax),%edx
  105d0d:	89 55 10             	mov    %edx,0x10(%ebp)
  105d10:	0f b6 00             	movzbl (%eax),%eax
  105d13:	0f b6 d8             	movzbl %al,%ebx
  105d16:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105d19:	83 f8 55             	cmp    $0x55,%eax
  105d1c:	0f 87 11 03 00 00    	ja     106033 <.L24>
  105d22:	c1 e0 02             	shl    $0x2,%eax
  105d25:	8b 84 38 ac f8 fe ff 	mov    -0x10754(%eax,%edi,1),%eax
  105d2c:	01 f8                	add    %edi,%eax
  105d2e:	ff e0                	jmp    *%eax

00105d30 <.L29>:

        // flag to pad on the right
        case '-':
            padc = '-';
  105d30:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
            goto reswitch;
  105d34:	eb d1                	jmp    105d07 <vprintfmt+0x5f>

00105d36 <.L31>:

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105d36:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
            goto reswitch;
  105d3a:	eb cb                	jmp    105d07 <vprintfmt+0x5f>

00105d3c <.L32>:

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105d3c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
                precision = precision * 10 + ch - '0';
  105d43:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105d46:	89 d0                	mov    %edx,%eax
  105d48:	c1 e0 02             	shl    $0x2,%eax
  105d4b:	01 d0                	add    %edx,%eax
  105d4d:	01 c0                	add    %eax,%eax
  105d4f:	01 d8                	add    %ebx,%eax
  105d51:	83 e8 30             	sub    $0x30,%eax
  105d54:	89 45 d4             	mov    %eax,-0x2c(%ebp)
                ch = *fmt;
  105d57:	8b 45 10             	mov    0x10(%ebp),%eax
  105d5a:	0f b6 00             	movzbl (%eax),%eax
  105d5d:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105d60:	83 fb 2f             	cmp    $0x2f,%ebx
  105d63:	7e 39                	jle    105d9e <.L25+0xc>
  105d65:	83 fb 39             	cmp    $0x39,%ebx
  105d68:	7f 34                	jg     105d9e <.L25+0xc>
            for (precision = 0; ; ++ fmt) {
  105d6a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105d6e:	eb d3                	jmp    105d43 <.L32+0x7>

00105d70 <.L28>:
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105d70:	8b 45 14             	mov    0x14(%ebp),%eax
  105d73:	8d 50 04             	lea    0x4(%eax),%edx
  105d76:	89 55 14             	mov    %edx,0x14(%ebp)
  105d79:	8b 00                	mov    (%eax),%eax
  105d7b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            goto process_precision;
  105d7e:	eb 1f                	jmp    105d9f <.L25+0xd>

00105d80 <.L30>:

        case '.':
            if (width < 0)
  105d80:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  105d84:	79 81                	jns    105d07 <vprintfmt+0x5f>
                width = 0;
  105d86:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
            goto reswitch;
  105d8d:	e9 75 ff ff ff       	jmp    105d07 <vprintfmt+0x5f>

00105d92 <.L25>:

        case '#':
            altflag = 1;
  105d92:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
            goto reswitch;
  105d99:	e9 69 ff ff ff       	jmp    105d07 <vprintfmt+0x5f>
            goto process_precision;
  105d9e:	90                   	nop

        process_precision:
            if (width < 0)
  105d9f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  105da3:	0f 89 5e ff ff ff    	jns    105d07 <vprintfmt+0x5f>
                width = precision, precision = -1;
  105da9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105dac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  105daf:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
            goto reswitch;
  105db6:	e9 4c ff ff ff       	jmp    105d07 <vprintfmt+0x5f>

00105dbb <.L36>:

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105dbb:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
            goto reswitch;
  105dbf:	e9 43 ff ff ff       	jmp    105d07 <vprintfmt+0x5f>

00105dc4 <.L33>:

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105dc4:	8b 45 14             	mov    0x14(%ebp),%eax
  105dc7:	8d 50 04             	lea    0x4(%eax),%edx
  105dca:	89 55 14             	mov    %edx,0x14(%ebp)
  105dcd:	8b 00                	mov    (%eax),%eax
  105dcf:	83 ec 08             	sub    $0x8,%esp
  105dd2:	ff 75 0c             	pushl  0xc(%ebp)
  105dd5:	50                   	push   %eax
  105dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd9:	ff d0                	call   *%eax
  105ddb:	83 c4 10             	add    $0x10,%esp
            break;
  105dde:	e9 78 02 00 00       	jmp    10605b <.L24+0x28>

00105de3 <.L35>:

        // error message
        case 'e':
            err = va_arg(ap, int);
  105de3:	8b 45 14             	mov    0x14(%ebp),%eax
  105de6:	8d 50 04             	lea    0x4(%eax),%edx
  105de9:	89 55 14             	mov    %edx,0x14(%ebp)
  105dec:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105dee:	85 db                	test   %ebx,%ebx
  105df0:	79 02                	jns    105df4 <.L35+0x11>
                err = -err;
  105df2:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105df4:	83 fb 06             	cmp    $0x6,%ebx
  105df7:	7f 0b                	jg     105e04 <.L35+0x21>
  105df9:	8b b4 9f 5c 01 00 00 	mov    0x15c(%edi,%ebx,4),%esi
  105e00:	85 f6                	test   %esi,%esi
  105e02:	75 1b                	jne    105e1f <.L35+0x3c>
                printfmt(putch, putdat, "error %d", err);
  105e04:	53                   	push   %ebx
  105e05:	8d 87 97 f8 fe ff    	lea    -0x10769(%edi),%eax
  105e0b:	50                   	push   %eax
  105e0c:	ff 75 0c             	pushl  0xc(%ebp)
  105e0f:	ff 75 08             	pushl  0x8(%ebp)
  105e12:	e8 63 fe ff ff       	call   105c7a <printfmt>
  105e17:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105e1a:	e9 3c 02 00 00       	jmp    10605b <.L24+0x28>
                printfmt(putch, putdat, "%s", p);
  105e1f:	56                   	push   %esi
  105e20:	8d 87 a0 f8 fe ff    	lea    -0x10760(%edi),%eax
  105e26:	50                   	push   %eax
  105e27:	ff 75 0c             	pushl  0xc(%ebp)
  105e2a:	ff 75 08             	pushl  0x8(%ebp)
  105e2d:	e8 48 fe ff ff       	call   105c7a <printfmt>
  105e32:	83 c4 10             	add    $0x10,%esp
            break;
  105e35:	e9 21 02 00 00       	jmp    10605b <.L24+0x28>

00105e3a <.L39>:

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105e3a:	8b 45 14             	mov    0x14(%ebp),%eax
  105e3d:	8d 50 04             	lea    0x4(%eax),%edx
  105e40:	89 55 14             	mov    %edx,0x14(%ebp)
  105e43:	8b 30                	mov    (%eax),%esi
  105e45:	85 f6                	test   %esi,%esi
  105e47:	75 06                	jne    105e4f <.L39+0x15>
                p = "(null)";
  105e49:	8d b7 a3 f8 fe ff    	lea    -0x1075d(%edi),%esi
            }
            if (width > 0 && padc != '-') {
  105e4f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  105e53:	7e 78                	jle    105ecd <.L39+0x93>
  105e55:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  105e59:	74 72                	je     105ecd <.L39+0x93>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105e5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105e5e:	83 ec 08             	sub    $0x8,%esp
  105e61:	50                   	push   %eax
  105e62:	56                   	push   %esi
  105e63:	89 fb                	mov    %edi,%ebx
  105e65:	e8 57 f7 ff ff       	call   1055c1 <strnlen>
  105e6a:	83 c4 10             	add    $0x10,%esp
  105e6d:	89 c2                	mov    %eax,%edx
  105e6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105e72:	29 d0                	sub    %edx,%eax
  105e74:	89 45 d8             	mov    %eax,-0x28(%ebp)
  105e77:	eb 17                	jmp    105e90 <.L39+0x56>
                    putch(padc, putdat);
  105e79:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  105e7d:	83 ec 08             	sub    $0x8,%esp
  105e80:	ff 75 0c             	pushl  0xc(%ebp)
  105e83:	50                   	push   %eax
  105e84:	8b 45 08             	mov    0x8(%ebp),%eax
  105e87:	ff d0                	call   *%eax
  105e89:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  105e8c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  105e90:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  105e94:	7f e3                	jg     105e79 <.L39+0x3f>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105e96:	eb 35                	jmp    105ecd <.L39+0x93>
                if (altflag && (ch < ' ' || ch > '~')) {
  105e98:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  105e9c:	74 1c                	je     105eba <.L39+0x80>
  105e9e:	83 fb 1f             	cmp    $0x1f,%ebx
  105ea1:	7e 05                	jle    105ea8 <.L39+0x6e>
  105ea3:	83 fb 7e             	cmp    $0x7e,%ebx
  105ea6:	7e 12                	jle    105eba <.L39+0x80>
                    putch('?', putdat);
  105ea8:	83 ec 08             	sub    $0x8,%esp
  105eab:	ff 75 0c             	pushl  0xc(%ebp)
  105eae:	6a 3f                	push   $0x3f
  105eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  105eb3:	ff d0                	call   *%eax
  105eb5:	83 c4 10             	add    $0x10,%esp
  105eb8:	eb 0f                	jmp    105ec9 <.L39+0x8f>
                }
                else {
                    putch(ch, putdat);
  105eba:	83 ec 08             	sub    $0x8,%esp
  105ebd:	ff 75 0c             	pushl  0xc(%ebp)
  105ec0:	53                   	push   %ebx
  105ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ec4:	ff d0                	call   *%eax
  105ec6:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105ec9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  105ecd:	89 f0                	mov    %esi,%eax
  105ecf:	8d 70 01             	lea    0x1(%eax),%esi
  105ed2:	0f b6 00             	movzbl (%eax),%eax
  105ed5:	0f be d8             	movsbl %al,%ebx
  105ed8:	85 db                	test   %ebx,%ebx
  105eda:	74 26                	je     105f02 <.L39+0xc8>
  105edc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  105ee0:	78 b6                	js     105e98 <.L39+0x5e>
  105ee2:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  105ee6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  105eea:	79 ac                	jns    105e98 <.L39+0x5e>
                }
            }
            for (; width > 0; width --) {
  105eec:	eb 14                	jmp    105f02 <.L39+0xc8>
                putch(' ', putdat);
  105eee:	83 ec 08             	sub    $0x8,%esp
  105ef1:	ff 75 0c             	pushl  0xc(%ebp)
  105ef4:	6a 20                	push   $0x20
  105ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ef9:	ff d0                	call   *%eax
  105efb:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  105efe:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  105f02:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  105f06:	7f e6                	jg     105eee <.L39+0xb4>
            }
            break;
  105f08:	e9 4e 01 00 00       	jmp    10605b <.L24+0x28>

00105f0d <.L34>:

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105f0d:	83 ec 08             	sub    $0x8,%esp
  105f10:	ff 75 d0             	pushl  -0x30(%ebp)
  105f13:	8d 45 14             	lea    0x14(%ebp),%eax
  105f16:	50                   	push   %eax
  105f17:	e8 0d fd ff ff       	call   105c29 <getint>
  105f1c:	83 c4 10             	add    $0x10,%esp
  105f1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105f22:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            if ((long long)num < 0) {
  105f25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f2b:	85 d2                	test   %edx,%edx
  105f2d:	79 23                	jns    105f52 <.L34+0x45>
                putch('-', putdat);
  105f2f:	83 ec 08             	sub    $0x8,%esp
  105f32:	ff 75 0c             	pushl  0xc(%ebp)
  105f35:	6a 2d                	push   $0x2d
  105f37:	8b 45 08             	mov    0x8(%ebp),%eax
  105f3a:	ff d0                	call   *%eax
  105f3c:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  105f3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f45:	f7 d8                	neg    %eax
  105f47:	83 d2 00             	adc    $0x0,%edx
  105f4a:	f7 da                	neg    %edx
  105f4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105f4f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            }
            base = 10;
  105f52:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
  105f59:	e9 9f 00 00 00       	jmp    105ffd <.L41+0x1f>

00105f5e <.L40>:

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105f5e:	83 ec 08             	sub    $0x8,%esp
  105f61:	ff 75 d0             	pushl  -0x30(%ebp)
  105f64:	8d 45 14             	lea    0x14(%ebp),%eax
  105f67:	50                   	push   %eax
  105f68:	e8 63 fc ff ff       	call   105bd0 <getuint>
  105f6d:	83 c4 10             	add    $0x10,%esp
  105f70:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105f73:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 10;
  105f76:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
  105f7d:	eb 7e                	jmp    105ffd <.L41+0x1f>

00105f7f <.L37>:

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105f7f:	83 ec 08             	sub    $0x8,%esp
  105f82:	ff 75 d0             	pushl  -0x30(%ebp)
  105f85:	8d 45 14             	lea    0x14(%ebp),%eax
  105f88:	50                   	push   %eax
  105f89:	e8 42 fc ff ff       	call   105bd0 <getuint>
  105f8e:	83 c4 10             	add    $0x10,%esp
  105f91:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105f94:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 8;
  105f97:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
            goto number;
  105f9e:	eb 5d                	jmp    105ffd <.L41+0x1f>

00105fa0 <.L38>:

        // pointer
        case 'p':
            putch('0', putdat);
  105fa0:	83 ec 08             	sub    $0x8,%esp
  105fa3:	ff 75 0c             	pushl  0xc(%ebp)
  105fa6:	6a 30                	push   $0x30
  105fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  105fab:	ff d0                	call   *%eax
  105fad:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  105fb0:	83 ec 08             	sub    $0x8,%esp
  105fb3:	ff 75 0c             	pushl  0xc(%ebp)
  105fb6:	6a 78                	push   $0x78
  105fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  105fbb:	ff d0                	call   *%eax
  105fbd:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105fc0:	8b 45 14             	mov    0x14(%ebp),%eax
  105fc3:	8d 50 04             	lea    0x4(%eax),%edx
  105fc6:	89 55 14             	mov    %edx,0x14(%ebp)
  105fc9:	8b 00                	mov    (%eax),%eax
  105fcb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105fce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            base = 16;
  105fd5:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
            goto number;
  105fdc:	eb 1f                	jmp    105ffd <.L41+0x1f>

00105fde <.L41>:

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105fde:	83 ec 08             	sub    $0x8,%esp
  105fe1:	ff 75 d0             	pushl  -0x30(%ebp)
  105fe4:	8d 45 14             	lea    0x14(%ebp),%eax
  105fe7:	50                   	push   %eax
  105fe8:	e8 e3 fb ff ff       	call   105bd0 <getuint>
  105fed:	83 c4 10             	add    $0x10,%esp
  105ff0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105ff3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 16;
  105ff6:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105ffd:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  106001:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106004:	83 ec 04             	sub    $0x4,%esp
  106007:	52                   	push   %edx
  106008:	ff 75 d8             	pushl  -0x28(%ebp)
  10600b:	50                   	push   %eax
  10600c:	ff 75 e4             	pushl  -0x1c(%ebp)
  10600f:	ff 75 e0             	pushl  -0x20(%ebp)
  106012:	ff 75 0c             	pushl  0xc(%ebp)
  106015:	ff 75 08             	pushl  0x8(%ebp)
  106018:	e8 b0 fa ff ff       	call   105acd <printnum>
  10601d:	83 c4 20             	add    $0x20,%esp
            break;
  106020:	eb 39                	jmp    10605b <.L24+0x28>

00106022 <.L27>:

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  106022:	83 ec 08             	sub    $0x8,%esp
  106025:	ff 75 0c             	pushl  0xc(%ebp)
  106028:	53                   	push   %ebx
  106029:	8b 45 08             	mov    0x8(%ebp),%eax
  10602c:	ff d0                	call   *%eax
  10602e:	83 c4 10             	add    $0x10,%esp
            break;
  106031:	eb 28                	jmp    10605b <.L24+0x28>

00106033 <.L24>:

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  106033:	83 ec 08             	sub    $0x8,%esp
  106036:	ff 75 0c             	pushl  0xc(%ebp)
  106039:	6a 25                	push   $0x25
  10603b:	8b 45 08             	mov    0x8(%ebp),%eax
  10603e:	ff d0                	call   *%eax
  106040:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  106043:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  106047:	eb 04                	jmp    10604d <.L24+0x1a>
  106049:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10604d:	8b 45 10             	mov    0x10(%ebp),%eax
  106050:	83 e8 01             	sub    $0x1,%eax
  106053:	0f b6 00             	movzbl (%eax),%eax
  106056:	3c 25                	cmp    $0x25,%al
  106058:	75 ef                	jne    106049 <.L24+0x16>
                /* do nothing */;
            break;
  10605a:	90                   	nop
    while (1) {
  10605b:	e9 5c fc ff ff       	jmp    105cbc <vprintfmt+0x14>
                return;
  106060:	90                   	nop
        }
    }
}
  106061:	8d 65 f4             	lea    -0xc(%ebp),%esp
  106064:	5b                   	pop    %ebx
  106065:	5e                   	pop    %esi
  106066:	5f                   	pop    %edi
  106067:	5d                   	pop    %ebp
  106068:	c3                   	ret    

00106069 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  106069:	55                   	push   %ebp
  10606a:	89 e5                	mov    %esp,%ebp
  10606c:	e8 35 a2 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  106071:	05 ff 18 01 00       	add    $0x118ff,%eax
    b->cnt ++;
  106076:	8b 45 0c             	mov    0xc(%ebp),%eax
  106079:	8b 40 08             	mov    0x8(%eax),%eax
  10607c:	8d 50 01             	lea    0x1(%eax),%edx
  10607f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106082:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  106085:	8b 45 0c             	mov    0xc(%ebp),%eax
  106088:	8b 10                	mov    (%eax),%edx
  10608a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10608d:	8b 40 04             	mov    0x4(%eax),%eax
  106090:	39 c2                	cmp    %eax,%edx
  106092:	73 12                	jae    1060a6 <sprintputch+0x3d>
        *b->buf ++ = ch;
  106094:	8b 45 0c             	mov    0xc(%ebp),%eax
  106097:	8b 00                	mov    (%eax),%eax
  106099:	8d 48 01             	lea    0x1(%eax),%ecx
  10609c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10609f:	89 0a                	mov    %ecx,(%edx)
  1060a1:	8b 55 08             	mov    0x8(%ebp),%edx
  1060a4:	88 10                	mov    %dl,(%eax)
    }
}
  1060a6:	90                   	nop
  1060a7:	5d                   	pop    %ebp
  1060a8:	c3                   	ret    

001060a9 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1060a9:	55                   	push   %ebp
  1060aa:	89 e5                	mov    %esp,%ebp
  1060ac:	83 ec 18             	sub    $0x18,%esp
  1060af:	e8 f2 a1 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1060b4:	05 bc 18 01 00       	add    $0x118bc,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1060b9:	8d 45 14             	lea    0x14(%ebp),%eax
  1060bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1060bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060c2:	50                   	push   %eax
  1060c3:	ff 75 10             	pushl  0x10(%ebp)
  1060c6:	ff 75 0c             	pushl  0xc(%ebp)
  1060c9:	ff 75 08             	pushl  0x8(%ebp)
  1060cc:	e8 0b 00 00 00       	call   1060dc <vsnprintf>
  1060d1:	83 c4 10             	add    $0x10,%esp
  1060d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1060d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1060da:	c9                   	leave  
  1060db:	c3                   	ret    

001060dc <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1060dc:	55                   	push   %ebp
  1060dd:	89 e5                	mov    %esp,%ebp
  1060df:	83 ec 18             	sub    $0x18,%esp
  1060e2:	e8 bf a1 ff ff       	call   1002a6 <__x86.get_pc_thunk.ax>
  1060e7:	05 89 18 01 00       	add    $0x11889,%eax
    struct sprintbuf b = {str, str + size - 1, 0};
  1060ec:	8b 55 08             	mov    0x8(%ebp),%edx
  1060ef:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1060f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1060f5:	8d 4a ff             	lea    -0x1(%edx),%ecx
  1060f8:	8b 55 08             	mov    0x8(%ebp),%edx
  1060fb:	01 ca                	add    %ecx,%edx
  1060fd:	89 55 f0             	mov    %edx,-0x10(%ebp)
  106100:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  106107:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10610b:	74 0a                	je     106117 <vsnprintf+0x3b>
  10610d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  106110:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106113:	39 d1                	cmp    %edx,%ecx
  106115:	76 07                	jbe    10611e <vsnprintf+0x42>
        return -E_INVAL;
  106117:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10611c:	eb 22                	jmp    106140 <vsnprintf+0x64>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10611e:	ff 75 14             	pushl  0x14(%ebp)
  106121:	ff 75 10             	pushl  0x10(%ebp)
  106124:	8d 55 ec             	lea    -0x14(%ebp),%edx
  106127:	52                   	push   %edx
  106128:	8d 80 f9 e6 fe ff    	lea    -0x11907(%eax),%eax
  10612e:	50                   	push   %eax
  10612f:	e8 74 fb ff ff       	call   105ca8 <vprintfmt>
  106134:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  106137:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10613a:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10613d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106140:	c9                   	leave  
  106141:	c3                   	ret    

00106142 <__x86.get_pc_thunk.di>:
  106142:	8b 3c 24             	mov    (%esp),%edi
  106145:	c3                   	ret    
