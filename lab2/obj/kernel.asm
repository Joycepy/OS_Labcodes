
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
c010002d:	53                   	push   %ebx
c010002e:	83 ec 14             	sub    $0x14,%esp
c0100031:	e8 74 02 00 00       	call   c01002aa <__x86.get_pc_thunk.bx>
c0100036:	81 c3 3a 79 01 00    	add    $0x1793a,%ebx
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	c7 c0 28 8a 11 c0    	mov    $0xc0118a28,%eax
c0100042:	89 c2                	mov    %eax,%edx
c0100044:	c7 c0 70 79 11 c0    	mov    $0xc0117970,%eax
c010004a:	29 c2                	sub    %eax,%edx
c010004c:	89 d0                	mov    %edx,%eax
c010004e:	83 ec 04             	sub    $0x4,%esp
c0100051:	50                   	push   %eax
c0100052:	6a 00                	push   $0x0
c0100054:	c7 c0 70 79 11 c0    	mov    $0xc0117970,%eax
c010005a:	50                   	push   %eax
c010005b:	e8 ba 58 00 00       	call   c010591a <memset>
c0100060:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100063:	e8 b5 17 00 00       	call   c010181d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100068:	8d 83 d8 e7 fe ff    	lea    -0x11828(%ebx),%eax
c010006e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100071:	83 ec 08             	sub    $0x8,%esp
c0100074:	ff 75 f4             	pushl  -0xc(%ebp)
c0100077:	8d 83 f4 e7 fe ff    	lea    -0x1180c(%ebx),%eax
c010007d:	50                   	push   %eax
c010007e:	e8 9a 02 00 00       	call   c010031d <cprintf>
c0100083:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100086:	e8 ba 09 00 00       	call   c0100a45 <print_kerninfo>

    grade_backtrace();
c010008b:	e8 98 00 00 00       	call   c0100128 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100090:	e8 2b 34 00 00       	call   c01034c0 <pmm_init>

    pic_init();                 // init interrupt controller
c0100095:	e8 40 19 00 00       	call   c01019da <pic_init>
    idt_init();                 // init interrupt descriptor table
c010009a:	e8 d2 1a 00 00       	call   c0101b71 <idt_init>

    clock_init();               // init clock interrupt
c010009f:	e8 14 0e 00 00       	call   c0100eb8 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a4:	e8 79 1a 00 00       	call   c0101b22 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a9:	eb fe                	jmp    c01000a9 <kern_init+0x7f>

c01000ab <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000ab:	55                   	push   %ebp
c01000ac:	89 e5                	mov    %esp,%ebp
c01000ae:	53                   	push   %ebx
c01000af:	83 ec 04             	sub    $0x4,%esp
c01000b2:	e8 ef 01 00 00       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01000b7:	05 b9 78 01 00       	add    $0x178b9,%eax
    mon_backtrace(0, NULL, NULL);
c01000bc:	83 ec 04             	sub    $0x4,%esp
c01000bf:	6a 00                	push   $0x0
c01000c1:	6a 00                	push   $0x0
c01000c3:	6a 00                	push   $0x0
c01000c5:	89 c3                	mov    %eax,%ebx
c01000c7:	e8 c9 0d 00 00       	call   c0100e95 <mon_backtrace>
c01000cc:	83 c4 10             	add    $0x10,%esp
}
c01000cf:	90                   	nop
c01000d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000d3:	c9                   	leave  
c01000d4:	c3                   	ret    

c01000d5 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d5:	55                   	push   %ebp
c01000d6:	89 e5                	mov    %esp,%ebp
c01000d8:	53                   	push   %ebx
c01000d9:	83 ec 04             	sub    $0x4,%esp
c01000dc:	e8 c5 01 00 00       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01000e1:	05 8f 78 01 00       	add    $0x1788f,%eax
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000e6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000e9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000ec:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01000f2:	51                   	push   %ecx
c01000f3:	52                   	push   %edx
c01000f4:	53                   	push   %ebx
c01000f5:	50                   	push   %eax
c01000f6:	e8 b0 ff ff ff       	call   c01000ab <grade_backtrace2>
c01000fb:	83 c4 10             	add    $0x10,%esp
}
c01000fe:	90                   	nop
c01000ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100102:	c9                   	leave  
c0100103:	c3                   	ret    

c0100104 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100104:	55                   	push   %ebp
c0100105:	89 e5                	mov    %esp,%ebp
c0100107:	83 ec 08             	sub    $0x8,%esp
c010010a:	e8 97 01 00 00       	call   c01002a6 <__x86.get_pc_thunk.ax>
c010010f:	05 61 78 01 00       	add    $0x17861,%eax
    grade_backtrace1(arg0, arg2);
c0100114:	83 ec 08             	sub    $0x8,%esp
c0100117:	ff 75 10             	pushl  0x10(%ebp)
c010011a:	ff 75 08             	pushl  0x8(%ebp)
c010011d:	e8 b3 ff ff ff       	call   c01000d5 <grade_backtrace1>
c0100122:	83 c4 10             	add    $0x10,%esp
}
c0100125:	90                   	nop
c0100126:	c9                   	leave  
c0100127:	c3                   	ret    

c0100128 <grade_backtrace>:

void
grade_backtrace(void) {
c0100128:	55                   	push   %ebp
c0100129:	89 e5                	mov    %esp,%ebp
c010012b:	83 ec 08             	sub    $0x8,%esp
c010012e:	e8 73 01 00 00       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0100133:	05 3d 78 01 00       	add    $0x1783d,%eax
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100138:	8d 80 ba 86 fe ff    	lea    -0x17946(%eax),%eax
c010013e:	83 ec 04             	sub    $0x4,%esp
c0100141:	68 00 00 ff ff       	push   $0xffff0000
c0100146:	50                   	push   %eax
c0100147:	6a 00                	push   $0x0
c0100149:	e8 b6 ff ff ff       	call   c0100104 <grade_backtrace0>
c010014e:	83 c4 10             	add    $0x10,%esp
}
c0100151:	90                   	nop
c0100152:	c9                   	leave  
c0100153:	c3                   	ret    

c0100154 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100154:	55                   	push   %ebp
c0100155:	89 e5                	mov    %esp,%ebp
c0100157:	53                   	push   %ebx
c0100158:	83 ec 14             	sub    $0x14,%esp
c010015b:	e8 4a 01 00 00       	call   c01002aa <__x86.get_pc_thunk.bx>
c0100160:	81 c3 10 78 01 00    	add    $0x17810,%ebx
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100166:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100169:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010016c:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010016f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100172:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100176:	0f b7 c0             	movzwl %ax,%eax
c0100179:	83 e0 03             	and    $0x3,%eax
c010017c:	89 c2                	mov    %eax,%edx
c010017e:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
c0100184:	83 ec 04             	sub    $0x4,%esp
c0100187:	52                   	push   %edx
c0100188:	50                   	push   %eax
c0100189:	8d 83 f9 e7 fe ff    	lea    -0x11807(%ebx),%eax
c010018f:	50                   	push   %eax
c0100190:	e8 88 01 00 00       	call   c010031d <cprintf>
c0100195:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100198:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010019c:	0f b7 d0             	movzwl %ax,%edx
c010019f:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
c01001a5:	83 ec 04             	sub    $0x4,%esp
c01001a8:	52                   	push   %edx
c01001a9:	50                   	push   %eax
c01001aa:	8d 83 07 e8 fe ff    	lea    -0x117f9(%ebx),%eax
c01001b0:	50                   	push   %eax
c01001b1:	e8 67 01 00 00       	call   c010031d <cprintf>
c01001b6:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c01001b9:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001bd:	0f b7 d0             	movzwl %ax,%edx
c01001c0:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
c01001c6:	83 ec 04             	sub    $0x4,%esp
c01001c9:	52                   	push   %edx
c01001ca:	50                   	push   %eax
c01001cb:	8d 83 15 e8 fe ff    	lea    -0x117eb(%ebx),%eax
c01001d1:	50                   	push   %eax
c01001d2:	e8 46 01 00 00       	call   c010031d <cprintf>
c01001d7:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c01001da:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001de:	0f b7 d0             	movzwl %ax,%edx
c01001e1:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
c01001e7:	83 ec 04             	sub    $0x4,%esp
c01001ea:	52                   	push   %edx
c01001eb:	50                   	push   %eax
c01001ec:	8d 83 23 e8 fe ff    	lea    -0x117dd(%ebx),%eax
c01001f2:	50                   	push   %eax
c01001f3:	e8 25 01 00 00       	call   c010031d <cprintf>
c01001f8:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001fb:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001ff:	0f b7 d0             	movzwl %ax,%edx
c0100202:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
c0100208:	83 ec 04             	sub    $0x4,%esp
c010020b:	52                   	push   %edx
c010020c:	50                   	push   %eax
c010020d:	8d 83 31 e8 fe ff    	lea    -0x117cf(%ebx),%eax
c0100213:	50                   	push   %eax
c0100214:	e8 04 01 00 00       	call   c010031d <cprintf>
c0100219:	83 c4 10             	add    $0x10,%esp
    round ++;
c010021c:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
c0100222:	83 c0 01             	add    $0x1,%eax
c0100225:	89 83 90 01 00 00    	mov    %eax,0x190(%ebx)
}
c010022b:	90                   	nop
c010022c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010022f:	c9                   	leave  
c0100230:	c3                   	ret    

c0100231 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c0100231:	55                   	push   %ebp
c0100232:	89 e5                	mov    %esp,%ebp
c0100234:	e8 6d 00 00 00       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0100239:	05 37 77 01 00       	add    $0x17737,%eax
    //LAB1 CHALLENGE 1 : TODO
}
c010023e:	90                   	nop
c010023f:	5d                   	pop    %ebp
c0100240:	c3                   	ret    

c0100241 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100241:	55                   	push   %ebp
c0100242:	89 e5                	mov    %esp,%ebp
c0100244:	e8 5d 00 00 00       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0100249:	05 27 77 01 00       	add    $0x17727,%eax
    //LAB1 CHALLENGE 1 :  TODO
}
c010024e:	90                   	nop
c010024f:	5d                   	pop    %ebp
c0100250:	c3                   	ret    

c0100251 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100251:	55                   	push   %ebp
c0100252:	89 e5                	mov    %esp,%ebp
c0100254:	53                   	push   %ebx
c0100255:	83 ec 04             	sub    $0x4,%esp
c0100258:	e8 4d 00 00 00       	call   c01002aa <__x86.get_pc_thunk.bx>
c010025d:	81 c3 13 77 01 00    	add    $0x17713,%ebx
    lab1_print_cur_status();
c0100263:	e8 ec fe ff ff       	call   c0100154 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100268:	83 ec 0c             	sub    $0xc,%esp
c010026b:	8d 83 40 e8 fe ff    	lea    -0x117c0(%ebx),%eax
c0100271:	50                   	push   %eax
c0100272:	e8 a6 00 00 00       	call   c010031d <cprintf>
c0100277:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c010027a:	e8 b2 ff ff ff       	call   c0100231 <lab1_switch_to_user>
    lab1_print_cur_status();
c010027f:	e8 d0 fe ff ff       	call   c0100154 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100284:	83 ec 0c             	sub    $0xc,%esp
c0100287:	8d 83 60 e8 fe ff    	lea    -0x117a0(%ebx),%eax
c010028d:	50                   	push   %eax
c010028e:	e8 8a 00 00 00       	call   c010031d <cprintf>
c0100293:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c0100296:	e8 a6 ff ff ff       	call   c0100241 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010029b:	e8 b4 fe ff ff       	call   c0100154 <lab1_print_cur_status>
}
c01002a0:	90                   	nop
c01002a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01002a4:	c9                   	leave  
c01002a5:	c3                   	ret    

c01002a6 <__x86.get_pc_thunk.ax>:
c01002a6:	8b 04 24             	mov    (%esp),%eax
c01002a9:	c3                   	ret    

c01002aa <__x86.get_pc_thunk.bx>:
c01002aa:	8b 1c 24             	mov    (%esp),%ebx
c01002ad:	c3                   	ret    

c01002ae <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002ae:	55                   	push   %ebp
c01002af:	89 e5                	mov    %esp,%ebp
c01002b1:	53                   	push   %ebx
c01002b2:	83 ec 04             	sub    $0x4,%esp
c01002b5:	e8 ec ff ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01002ba:	05 b6 76 01 00       	add    $0x176b6,%eax
    cons_putc(c);
c01002bf:	83 ec 0c             	sub    $0xc,%esp
c01002c2:	ff 75 08             	pushl  0x8(%ebp)
c01002c5:	89 c3                	mov    %eax,%ebx
c01002c7:	e8 94 15 00 00       	call   c0101860 <cons_putc>
c01002cc:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c01002cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002d2:	8b 00                	mov    (%eax),%eax
c01002d4:	8d 50 01             	lea    0x1(%eax),%edx
c01002d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002da:	89 10                	mov    %edx,(%eax)
}
c01002dc:	90                   	nop
c01002dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01002e0:	c9                   	leave  
c01002e1:	c3                   	ret    

c01002e2 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c01002e2:	55                   	push   %ebp
c01002e3:	89 e5                	mov    %esp,%ebp
c01002e5:	53                   	push   %ebx
c01002e6:	83 ec 14             	sub    $0x14,%esp
c01002e9:	e8 b8 ff ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01002ee:	05 82 76 01 00       	add    $0x17682,%eax
    int cnt = 0;
c01002f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c01002fa:	ff 75 0c             	pushl  0xc(%ebp)
c01002fd:	ff 75 08             	pushl  0x8(%ebp)
c0100300:	8d 55 f4             	lea    -0xc(%ebp),%edx
c0100303:	52                   	push   %edx
c0100304:	8d 90 3e 89 fe ff    	lea    -0x176c2(%eax),%edx
c010030a:	52                   	push   %edx
c010030b:	89 c3                	mov    %eax,%ebx
c010030d:	e8 96 59 00 00       	call   c0105ca8 <vprintfmt>
c0100312:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100315:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100318:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010031b:	c9                   	leave  
c010031c:	c3                   	ret    

c010031d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010031d:	55                   	push   %ebp
c010031e:	89 e5                	mov    %esp,%ebp
c0100320:	83 ec 18             	sub    $0x18,%esp
c0100323:	e8 7e ff ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0100328:	05 48 76 01 00       	add    $0x17648,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010032d:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100330:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100333:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100336:	83 ec 08             	sub    $0x8,%esp
c0100339:	50                   	push   %eax
c010033a:	ff 75 08             	pushl  0x8(%ebp)
c010033d:	e8 a0 ff ff ff       	call   c01002e2 <vcprintf>
c0100342:	83 c4 10             	add    $0x10,%esp
c0100345:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100348:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010034b:	c9                   	leave  
c010034c:	c3                   	ret    

c010034d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010034d:	55                   	push   %ebp
c010034e:	89 e5                	mov    %esp,%ebp
c0100350:	53                   	push   %ebx
c0100351:	83 ec 04             	sub    $0x4,%esp
c0100354:	e8 4d ff ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0100359:	05 17 76 01 00       	add    $0x17617,%eax
    cons_putc(c);
c010035e:	83 ec 0c             	sub    $0xc,%esp
c0100361:	ff 75 08             	pushl  0x8(%ebp)
c0100364:	89 c3                	mov    %eax,%ebx
c0100366:	e8 f5 14 00 00       	call   c0101860 <cons_putc>
c010036b:	83 c4 10             	add    $0x10,%esp
}
c010036e:	90                   	nop
c010036f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100372:	c9                   	leave  
c0100373:	c3                   	ret    

c0100374 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100374:	55                   	push   %ebp
c0100375:	89 e5                	mov    %esp,%ebp
c0100377:	83 ec 18             	sub    $0x18,%esp
c010037a:	e8 27 ff ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c010037f:	05 f1 75 01 00       	add    $0x175f1,%eax
    int cnt = 0;
c0100384:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010038b:	eb 14                	jmp    c01003a1 <cputs+0x2d>
        cputch(c, &cnt);
c010038d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100391:	83 ec 08             	sub    $0x8,%esp
c0100394:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100397:	52                   	push   %edx
c0100398:	50                   	push   %eax
c0100399:	e8 10 ff ff ff       	call   c01002ae <cputch>
c010039e:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
c01003a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a4:	8d 50 01             	lea    0x1(%eax),%edx
c01003a7:	89 55 08             	mov    %edx,0x8(%ebp)
c01003aa:	0f b6 00             	movzbl (%eax),%eax
c01003ad:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b0:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b4:	75 d7                	jne    c010038d <cputs+0x19>
    }
    cputch('\n', &cnt);
c01003b6:	83 ec 08             	sub    $0x8,%esp
c01003b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003bc:	50                   	push   %eax
c01003bd:	6a 0a                	push   $0xa
c01003bf:	e8 ea fe ff ff       	call   c01002ae <cputch>
c01003c4:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01003c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003ca:	c9                   	leave  
c01003cb:	c3                   	ret    

c01003cc <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003cc:	55                   	push   %ebp
c01003cd:	89 e5                	mov    %esp,%ebp
c01003cf:	53                   	push   %ebx
c01003d0:	83 ec 14             	sub    $0x14,%esp
c01003d3:	e8 d2 fe ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c01003d8:	81 c3 98 75 01 00    	add    $0x17598,%ebx
    int c;
    while ((c = cons_getc()) == 0)
c01003de:	e8 d0 14 00 00       	call   c01018b3 <cons_getc>
c01003e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003ea:	74 f2                	je     c01003de <getchar+0x12>
        /* do nothing */;
    return c;
c01003ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003ef:	83 c4 14             	add    $0x14,%esp
c01003f2:	5b                   	pop    %ebx
c01003f3:	5d                   	pop    %ebp
c01003f4:	c3                   	ret    

c01003f5 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c01003f5:	55                   	push   %ebp
c01003f6:	89 e5                	mov    %esp,%ebp
c01003f8:	53                   	push   %ebx
c01003f9:	83 ec 14             	sub    $0x14,%esp
c01003fc:	e8 a9 fe ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0100401:	81 c3 6f 75 01 00    	add    $0x1756f,%ebx
    if (prompt != NULL) {
c0100407:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010040b:	74 15                	je     c0100422 <readline+0x2d>
        cprintf("%s", prompt);
c010040d:	83 ec 08             	sub    $0x8,%esp
c0100410:	ff 75 08             	pushl  0x8(%ebp)
c0100413:	8d 83 7f e8 fe ff    	lea    -0x11781(%ebx),%eax
c0100419:	50                   	push   %eax
c010041a:	e8 fe fe ff ff       	call   c010031d <cprintf>
c010041f:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c0100422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100429:	e8 9e ff ff ff       	call   c01003cc <getchar>
c010042e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100431:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100435:	79 0a                	jns    c0100441 <readline+0x4c>
            return NULL;
c0100437:	b8 00 00 00 00       	mov    $0x0,%eax
c010043c:	e9 87 00 00 00       	jmp    c01004c8 <readline+0xd3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100441:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100445:	7e 2c                	jle    c0100473 <readline+0x7e>
c0100447:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010044e:	7f 23                	jg     c0100473 <readline+0x7e>
            cputchar(c);
c0100450:	83 ec 0c             	sub    $0xc,%esp
c0100453:	ff 75 f0             	pushl  -0x10(%ebp)
c0100456:	e8 f2 fe ff ff       	call   c010034d <cputchar>
c010045b:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c010045e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100461:	8d 50 01             	lea    0x1(%eax),%edx
c0100464:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100467:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010046a:	88 94 03 b0 01 00 00 	mov    %dl,0x1b0(%ebx,%eax,1)
c0100471:	eb 50                	jmp    c01004c3 <readline+0xce>
        }
        else if (c == '\b' && i > 0) {
c0100473:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c0100477:	75 1a                	jne    c0100493 <readline+0x9e>
c0100479:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010047d:	7e 14                	jle    c0100493 <readline+0x9e>
            cputchar(c);
c010047f:	83 ec 0c             	sub    $0xc,%esp
c0100482:	ff 75 f0             	pushl  -0x10(%ebp)
c0100485:	e8 c3 fe ff ff       	call   c010034d <cputchar>
c010048a:	83 c4 10             	add    $0x10,%esp
            i --;
c010048d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0100491:	eb 30                	jmp    c01004c3 <readline+0xce>
        }
        else if (c == '\n' || c == '\r') {
c0100493:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c0100497:	74 06                	je     c010049f <readline+0xaa>
c0100499:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c010049d:	75 8a                	jne    c0100429 <readline+0x34>
            cputchar(c);
c010049f:	83 ec 0c             	sub    $0xc,%esp
c01004a2:	ff 75 f0             	pushl  -0x10(%ebp)
c01004a5:	e8 a3 fe ff ff       	call   c010034d <cputchar>
c01004aa:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01004ad:	8d 93 b0 01 00 00    	lea    0x1b0(%ebx),%edx
c01004b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004b6:	01 d0                	add    %edx,%eax
c01004b8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01004bb:	8d 83 b0 01 00 00    	lea    0x1b0(%ebx),%eax
c01004c1:	eb 05                	jmp    c01004c8 <readline+0xd3>
        c = getchar();
c01004c3:	e9 61 ff ff ff       	jmp    c0100429 <readline+0x34>
        }
    }
}
c01004c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01004cb:	c9                   	leave  
c01004cc:	c3                   	ret    

c01004cd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01004cd:	55                   	push   %ebp
c01004ce:	89 e5                	mov    %esp,%ebp
c01004d0:	53                   	push   %ebx
c01004d1:	83 ec 14             	sub    $0x14,%esp
c01004d4:	e8 d1 fd ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c01004d9:	81 c3 97 74 01 00    	add    $0x17497,%ebx
    if (is_panic) {
c01004df:	8b 83 b0 05 00 00    	mov    0x5b0(%ebx),%eax
c01004e5:	85 c0                	test   %eax,%eax
c01004e7:	75 4e                	jne    c0100537 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c01004e9:	c7 83 b0 05 00 00 01 	movl   $0x1,0x5b0(%ebx)
c01004f0:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01004f3:	8d 45 14             	lea    0x14(%ebp),%eax
c01004f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c01004f9:	83 ec 04             	sub    $0x4,%esp
c01004fc:	ff 75 0c             	pushl  0xc(%ebp)
c01004ff:	ff 75 08             	pushl  0x8(%ebp)
c0100502:	8d 83 82 e8 fe ff    	lea    -0x1177e(%ebx),%eax
c0100508:	50                   	push   %eax
c0100509:	e8 0f fe ff ff       	call   c010031d <cprintf>
c010050e:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100511:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100514:	83 ec 08             	sub    $0x8,%esp
c0100517:	50                   	push   %eax
c0100518:	ff 75 10             	pushl  0x10(%ebp)
c010051b:	e8 c2 fd ff ff       	call   c01002e2 <vcprintf>
c0100520:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100523:	83 ec 0c             	sub    $0xc,%esp
c0100526:	8d 83 9e e8 fe ff    	lea    -0x11762(%ebx),%eax
c010052c:	50                   	push   %eax
c010052d:	e8 eb fd ff ff       	call   c010031d <cprintf>
c0100532:	83 c4 10             	add    $0x10,%esp
c0100535:	eb 01                	jmp    c0100538 <__panic+0x6b>
        goto panic_dead;
c0100537:	90                   	nop
    va_end(ap);

panic_dead:
    intr_disable();
c0100538:	e8 f6 15 00 00       	call   c0101b33 <intr_disable>
    while (1) {
        kmonitor(NULL);
c010053d:	83 ec 0c             	sub    $0xc,%esp
c0100540:	6a 00                	push   $0x0
c0100542:	e8 34 08 00 00       	call   c0100d7b <kmonitor>
c0100547:	83 c4 10             	add    $0x10,%esp
c010054a:	eb f1                	jmp    c010053d <__panic+0x70>

c010054c <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010054c:	55                   	push   %ebp
c010054d:	89 e5                	mov    %esp,%ebp
c010054f:	53                   	push   %ebx
c0100550:	83 ec 14             	sub    $0x14,%esp
c0100553:	e8 52 fd ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0100558:	81 c3 18 74 01 00    	add    $0x17418,%ebx
    va_list ap;
    va_start(ap, fmt);
c010055e:	8d 45 14             	lea    0x14(%ebp),%eax
c0100561:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100564:	83 ec 04             	sub    $0x4,%esp
c0100567:	ff 75 0c             	pushl  0xc(%ebp)
c010056a:	ff 75 08             	pushl  0x8(%ebp)
c010056d:	8d 83 a0 e8 fe ff    	lea    -0x11760(%ebx),%eax
c0100573:	50                   	push   %eax
c0100574:	e8 a4 fd ff ff       	call   c010031d <cprintf>
c0100579:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010057c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010057f:	83 ec 08             	sub    $0x8,%esp
c0100582:	50                   	push   %eax
c0100583:	ff 75 10             	pushl  0x10(%ebp)
c0100586:	e8 57 fd ff ff       	call   c01002e2 <vcprintf>
c010058b:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c010058e:	83 ec 0c             	sub    $0xc,%esp
c0100591:	8d 83 9e e8 fe ff    	lea    -0x11762(%ebx),%eax
c0100597:	50                   	push   %eax
c0100598:	e8 80 fd ff ff       	call   c010031d <cprintf>
c010059d:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01005a0:	90                   	nop
c01005a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01005a4:	c9                   	leave  
c01005a5:	c3                   	ret    

c01005a6 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01005a6:	55                   	push   %ebp
c01005a7:	89 e5                	mov    %esp,%ebp
c01005a9:	e8 f8 fc ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01005ae:	05 c2 73 01 00       	add    $0x173c2,%eax
    return is_panic;
c01005b3:	8b 80 b0 05 00 00    	mov    0x5b0(%eax),%eax
}
c01005b9:	5d                   	pop    %ebp
c01005ba:	c3                   	ret    

c01005bb <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01005bb:	55                   	push   %ebp
c01005bc:	89 e5                	mov    %esp,%ebp
c01005be:	83 ec 20             	sub    $0x20,%esp
c01005c1:	e8 e0 fc ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01005c6:	05 aa 73 01 00       	add    $0x173aa,%eax
    int l = *region_left, r = *region_right, any_matches = 0;
c01005cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ce:	8b 00                	mov    (%eax),%eax
c01005d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01005d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d6:	8b 00                	mov    (%eax),%eax
c01005d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01005e2:	e9 d2 00 00 00       	jmp    c01006b9 <stab_binsearch+0xfe>
        int true_m = (l + r) / 2, m = true_m;
c01005e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01005ed:	01 d0                	add    %edx,%eax
c01005ef:	89 c2                	mov    %eax,%edx
c01005f1:	c1 ea 1f             	shr    $0x1f,%edx
c01005f4:	01 d0                	add    %edx,%eax
c01005f6:	d1 f8                	sar    %eax
c01005f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01005fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01005fe:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100601:	eb 04                	jmp    c0100607 <stab_binsearch+0x4c>
            m --;
c0100603:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100607:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010060a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010060d:	7c 1f                	jl     c010062e <stab_binsearch+0x73>
c010060f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100612:	89 d0                	mov    %edx,%eax
c0100614:	01 c0                	add    %eax,%eax
c0100616:	01 d0                	add    %edx,%eax
c0100618:	c1 e0 02             	shl    $0x2,%eax
c010061b:	89 c2                	mov    %eax,%edx
c010061d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100620:	01 d0                	add    %edx,%eax
c0100622:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100626:	0f b6 c0             	movzbl %al,%eax
c0100629:	39 45 14             	cmp    %eax,0x14(%ebp)
c010062c:	75 d5                	jne    c0100603 <stab_binsearch+0x48>
        }
        if (m < l) {    // no match in [l, m]
c010062e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100631:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100634:	7d 0b                	jge    c0100641 <stab_binsearch+0x86>
            l = true_m + 1;
c0100636:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100639:	83 c0 01             	add    $0x1,%eax
c010063c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010063f:	eb 78                	jmp    c01006b9 <stab_binsearch+0xfe>
        }

        // actual binary search
        any_matches = 1;
c0100641:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100648:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010064b:	89 d0                	mov    %edx,%eax
c010064d:	01 c0                	add    %eax,%eax
c010064f:	01 d0                	add    %edx,%eax
c0100651:	c1 e0 02             	shl    $0x2,%eax
c0100654:	89 c2                	mov    %eax,%edx
c0100656:	8b 45 08             	mov    0x8(%ebp),%eax
c0100659:	01 d0                	add    %edx,%eax
c010065b:	8b 40 08             	mov    0x8(%eax),%eax
c010065e:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100661:	76 13                	jbe    c0100676 <stab_binsearch+0xbb>
            *region_left = m;
c0100663:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100666:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100669:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010066b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066e:	83 c0 01             	add    $0x1,%eax
c0100671:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100674:	eb 43                	jmp    c01006b9 <stab_binsearch+0xfe>
        } else if (stabs[m].n_value > addr) {
c0100676:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100679:	89 d0                	mov    %edx,%eax
c010067b:	01 c0                	add    %eax,%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	c1 e0 02             	shl    $0x2,%eax
c0100682:	89 c2                	mov    %eax,%edx
c0100684:	8b 45 08             	mov    0x8(%ebp),%eax
c0100687:	01 d0                	add    %edx,%eax
c0100689:	8b 40 08             	mov    0x8(%eax),%eax
c010068c:	39 45 18             	cmp    %eax,0x18(%ebp)
c010068f:	73 16                	jae    c01006a7 <stab_binsearch+0xec>
            *region_right = m - 1;
c0100691:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100694:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100697:	8b 45 10             	mov    0x10(%ebp),%eax
c010069a:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c010069c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010069f:	83 e8 01             	sub    $0x1,%eax
c01006a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01006a5:	eb 12                	jmp    c01006b9 <stab_binsearch+0xfe>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01006a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006ad:	89 10                	mov    %edx,(%eax)
            l = m;
c01006af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01006b5:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c01006b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01006bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01006bf:	0f 8e 22 ff ff ff    	jle    c01005e7 <stab_binsearch+0x2c>
        }
    }

    if (!any_matches) {
c01006c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01006c9:	75 0f                	jne    c01006da <stab_binsearch+0x11f>
        *region_right = *region_left - 1;
c01006cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ce:	8b 00                	mov    (%eax),%eax
c01006d0:	8d 50 ff             	lea    -0x1(%eax),%edx
c01006d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01006d6:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01006d8:	eb 3f                	jmp    c0100719 <stab_binsearch+0x15e>
        l = *region_right;
c01006da:	8b 45 10             	mov    0x10(%ebp),%eax
c01006dd:	8b 00                	mov    (%eax),%eax
c01006df:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01006e2:	eb 04                	jmp    c01006e8 <stab_binsearch+0x12d>
c01006e4:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006eb:	8b 00                	mov    (%eax),%eax
c01006ed:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c01006f0:	7e 1f                	jle    c0100711 <stab_binsearch+0x156>
c01006f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01006f5:	89 d0                	mov    %edx,%eax
c01006f7:	01 c0                	add    %eax,%eax
c01006f9:	01 d0                	add    %edx,%eax
c01006fb:	c1 e0 02             	shl    $0x2,%eax
c01006fe:	89 c2                	mov    %eax,%edx
c0100700:	8b 45 08             	mov    0x8(%ebp),%eax
c0100703:	01 d0                	add    %edx,%eax
c0100705:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100709:	0f b6 c0             	movzbl %al,%eax
c010070c:	39 45 14             	cmp    %eax,0x14(%ebp)
c010070f:	75 d3                	jne    c01006e4 <stab_binsearch+0x129>
        *region_left = l;
c0100711:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100714:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100717:	89 10                	mov    %edx,(%eax)
}
c0100719:	90                   	nop
c010071a:	c9                   	leave  
c010071b:	c3                   	ret    

c010071c <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010071c:	55                   	push   %ebp
c010071d:	89 e5                	mov    %esp,%ebp
c010071f:	53                   	push   %ebx
c0100720:	83 ec 34             	sub    $0x34,%esp
c0100723:	e8 82 fb ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0100728:	81 c3 48 72 01 00    	add    $0x17248,%ebx
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010072e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100731:	8d 93 c0 e8 fe ff    	lea    -0x11740(%ebx),%edx
c0100737:	89 10                	mov    %edx,(%eax)
    info->eip_line = 0;
c0100739:	8b 45 0c             	mov    0xc(%ebp),%eax
c010073c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100743:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100746:	8d 93 c0 e8 fe ff    	lea    -0x11740(%ebx),%edx
c010074c:	89 50 08             	mov    %edx,0x8(%eax)
    info->eip_fn_namelen = 9;
c010074f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100752:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100759:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075c:	8b 55 08             	mov    0x8(%ebp),%edx
c010075f:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100762:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100765:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010076c:	c7 c0 74 73 10 c0    	mov    $0xc0107374,%eax
c0100772:	89 45 f4             	mov    %eax,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100775:	c7 c0 d8 20 11 c0    	mov    $0xc01120d8,%eax
c010077b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010077e:	c7 c0 d9 20 11 c0    	mov    $0xc01120d9,%eax
c0100784:	89 45 ec             	mov    %eax,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100787:	c7 c0 a9 4b 11 c0    	mov    $0xc0114ba9,%eax
c010078d:	89 45 e8             	mov    %eax,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100790:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100793:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100796:	76 0d                	jbe    c01007a5 <debuginfo_eip+0x89>
c0100798:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010079b:	83 e8 01             	sub    $0x1,%eax
c010079e:	0f b6 00             	movzbl (%eax),%eax
c01007a1:	84 c0                	test   %al,%al
c01007a3:	74 0a                	je     c01007af <debuginfo_eip+0x93>
        return -1;
c01007a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007aa:	e9 91 02 00 00       	jmp    c0100a40 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01007af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01007b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	29 c2                	sub    %eax,%edx
c01007be:	89 d0                	mov    %edx,%eax
c01007c0:	c1 f8 02             	sar    $0x2,%eax
c01007c3:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01007c9:	83 e8 01             	sub    $0x1,%eax
c01007cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01007cf:	ff 75 08             	pushl  0x8(%ebp)
c01007d2:	6a 64                	push   $0x64
c01007d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01007d7:	50                   	push   %eax
c01007d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01007db:	50                   	push   %eax
c01007dc:	ff 75 f4             	pushl  -0xc(%ebp)
c01007df:	e8 d7 fd ff ff       	call   c01005bb <stab_binsearch>
c01007e4:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c01007e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007ea:	85 c0                	test   %eax,%eax
c01007ec:	75 0a                	jne    c01007f8 <debuginfo_eip+0xdc>
        return -1;
c01007ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007f3:	e9 48 02 00 00       	jmp    c0100a40 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01007f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01007fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100801:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100804:	ff 75 08             	pushl  0x8(%ebp)
c0100807:	6a 24                	push   $0x24
c0100809:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010080c:	50                   	push   %eax
c010080d:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100810:	50                   	push   %eax
c0100811:	ff 75 f4             	pushl  -0xc(%ebp)
c0100814:	e8 a2 fd ff ff       	call   c01005bb <stab_binsearch>
c0100819:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c010081c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010081f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100822:	39 c2                	cmp    %eax,%edx
c0100824:	7f 7c                	jg     c01008a2 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100826:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100829:	89 c2                	mov    %eax,%edx
c010082b:	89 d0                	mov    %edx,%eax
c010082d:	01 c0                	add    %eax,%eax
c010082f:	01 d0                	add    %edx,%eax
c0100831:	c1 e0 02             	shl    $0x2,%eax
c0100834:	89 c2                	mov    %eax,%edx
c0100836:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100839:	01 d0                	add    %edx,%eax
c010083b:	8b 00                	mov    (%eax),%eax
c010083d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100840:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100843:	29 d1                	sub    %edx,%ecx
c0100845:	89 ca                	mov    %ecx,%edx
c0100847:	39 d0                	cmp    %edx,%eax
c0100849:	73 22                	jae    c010086d <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010084b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010084e:	89 c2                	mov    %eax,%edx
c0100850:	89 d0                	mov    %edx,%eax
c0100852:	01 c0                	add    %eax,%eax
c0100854:	01 d0                	add    %edx,%eax
c0100856:	c1 e0 02             	shl    $0x2,%eax
c0100859:	89 c2                	mov    %eax,%edx
c010085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085e:	01 d0                	add    %edx,%eax
c0100860:	8b 10                	mov    (%eax),%edx
c0100862:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100865:	01 c2                	add    %eax,%edx
c0100867:	8b 45 0c             	mov    0xc(%ebp),%eax
c010086a:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010086d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100870:	89 c2                	mov    %eax,%edx
c0100872:	89 d0                	mov    %edx,%eax
c0100874:	01 c0                	add    %eax,%eax
c0100876:	01 d0                	add    %edx,%eax
c0100878:	c1 e0 02             	shl    $0x2,%eax
c010087b:	89 c2                	mov    %eax,%edx
c010087d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100880:	01 d0                	add    %edx,%eax
c0100882:	8b 50 08             	mov    0x8(%eax),%edx
c0100885:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100888:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010088b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010088e:	8b 40 10             	mov    0x10(%eax),%eax
c0100891:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100894:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100897:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c010089a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010089d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01008a0:	eb 15                	jmp    c01008b7 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01008a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008a5:	8b 55 08             	mov    0x8(%ebp),%edx
c01008a8:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01008b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01008b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01008b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008ba:	8b 40 08             	mov    0x8(%eax),%eax
c01008bd:	83 ec 08             	sub    $0x8,%esp
c01008c0:	6a 3a                	push   $0x3a
c01008c2:	50                   	push   %eax
c01008c3:	e8 b2 4e 00 00       	call   c010577a <strfind>
c01008c8:	83 c4 10             	add    $0x10,%esp
c01008cb:	89 c2                	mov    %eax,%edx
c01008cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008d0:	8b 40 08             	mov    0x8(%eax),%eax
c01008d3:	29 c2                	sub    %eax,%edx
c01008d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008d8:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01008db:	83 ec 0c             	sub    $0xc,%esp
c01008de:	ff 75 08             	pushl  0x8(%ebp)
c01008e1:	6a 44                	push   $0x44
c01008e3:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01008e6:	50                   	push   %eax
c01008e7:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01008ea:	50                   	push   %eax
c01008eb:	ff 75 f4             	pushl  -0xc(%ebp)
c01008ee:	e8 c8 fc ff ff       	call   c01005bb <stab_binsearch>
c01008f3:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01008f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01008fc:	39 c2                	cmp    %eax,%edx
c01008fe:	7f 24                	jg     c0100924 <debuginfo_eip+0x208>
        info->eip_line = stabs[rline].n_desc;
c0100900:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100903:	89 c2                	mov    %eax,%edx
c0100905:	89 d0                	mov    %edx,%eax
c0100907:	01 c0                	add    %eax,%eax
c0100909:	01 d0                	add    %edx,%eax
c010090b:	c1 e0 02             	shl    $0x2,%eax
c010090e:	89 c2                	mov    %eax,%edx
c0100910:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100913:	01 d0                	add    %edx,%eax
c0100915:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100919:	0f b7 d0             	movzwl %ax,%edx
c010091c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010091f:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100922:	eb 13                	jmp    c0100937 <debuginfo_eip+0x21b>
        return -1;
c0100924:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100929:	e9 12 01 00 00       	jmp    c0100a40 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010092e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100931:	83 e8 01             	sub    $0x1,%eax
c0100934:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100937:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010093a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010093d:	39 c2                	cmp    %eax,%edx
c010093f:	7c 56                	jl     c0100997 <debuginfo_eip+0x27b>
           && stabs[lline].n_type != N_SOL
c0100941:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100944:	89 c2                	mov    %eax,%edx
c0100946:	89 d0                	mov    %edx,%eax
c0100948:	01 c0                	add    %eax,%eax
c010094a:	01 d0                	add    %edx,%eax
c010094c:	c1 e0 02             	shl    $0x2,%eax
c010094f:	89 c2                	mov    %eax,%edx
c0100951:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100954:	01 d0                	add    %edx,%eax
c0100956:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010095a:	3c 84                	cmp    $0x84,%al
c010095c:	74 39                	je     c0100997 <debuginfo_eip+0x27b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010095e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100961:	89 c2                	mov    %eax,%edx
c0100963:	89 d0                	mov    %edx,%eax
c0100965:	01 c0                	add    %eax,%eax
c0100967:	01 d0                	add    %edx,%eax
c0100969:	c1 e0 02             	shl    $0x2,%eax
c010096c:	89 c2                	mov    %eax,%edx
c010096e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100971:	01 d0                	add    %edx,%eax
c0100973:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100977:	3c 64                	cmp    $0x64,%al
c0100979:	75 b3                	jne    c010092e <debuginfo_eip+0x212>
c010097b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010097e:	89 c2                	mov    %eax,%edx
c0100980:	89 d0                	mov    %edx,%eax
c0100982:	01 c0                	add    %eax,%eax
c0100984:	01 d0                	add    %edx,%eax
c0100986:	c1 e0 02             	shl    $0x2,%eax
c0100989:	89 c2                	mov    %eax,%edx
c010098b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010098e:	01 d0                	add    %edx,%eax
c0100990:	8b 40 08             	mov    0x8(%eax),%eax
c0100993:	85 c0                	test   %eax,%eax
c0100995:	74 97                	je     c010092e <debuginfo_eip+0x212>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100997:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010099a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010099d:	39 c2                	cmp    %eax,%edx
c010099f:	7c 46                	jl     c01009e7 <debuginfo_eip+0x2cb>
c01009a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01009a4:	89 c2                	mov    %eax,%edx
c01009a6:	89 d0                	mov    %edx,%eax
c01009a8:	01 c0                	add    %eax,%eax
c01009aa:	01 d0                	add    %edx,%eax
c01009ac:	c1 e0 02             	shl    $0x2,%eax
c01009af:	89 c2                	mov    %eax,%edx
c01009b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009b4:	01 d0                	add    %edx,%eax
c01009b6:	8b 00                	mov    (%eax),%eax
c01009b8:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01009bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01009be:	29 d1                	sub    %edx,%ecx
c01009c0:	89 ca                	mov    %ecx,%edx
c01009c2:	39 d0                	cmp    %edx,%eax
c01009c4:	73 21                	jae    c01009e7 <debuginfo_eip+0x2cb>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01009c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01009c9:	89 c2                	mov    %eax,%edx
c01009cb:	89 d0                	mov    %edx,%eax
c01009cd:	01 c0                	add    %eax,%eax
c01009cf:	01 d0                	add    %edx,%eax
c01009d1:	c1 e0 02             	shl    $0x2,%eax
c01009d4:	89 c2                	mov    %eax,%edx
c01009d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009d9:	01 d0                	add    %edx,%eax
c01009db:	8b 10                	mov    (%eax),%edx
c01009dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01009e0:	01 c2                	add    %eax,%edx
c01009e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01009e5:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01009e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01009ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01009ed:	39 c2                	cmp    %eax,%edx
c01009ef:	7d 4a                	jge    c0100a3b <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
c01009f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01009f4:	83 c0 01             	add    $0x1,%eax
c01009f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01009fa:	eb 18                	jmp    c0100a14 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01009fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01009ff:	8b 40 14             	mov    0x14(%eax),%eax
c0100a02:	8d 50 01             	lea    0x1(%eax),%edx
c0100a05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a08:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100a0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100a0e:	83 c0 01             	add    $0x1,%eax
c0100a11:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100a14:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100a17:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100a1a:	39 c2                	cmp    %eax,%edx
c0100a1c:	7d 1d                	jge    c0100a3b <debuginfo_eip+0x31f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100a1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100a21:	89 c2                	mov    %eax,%edx
c0100a23:	89 d0                	mov    %edx,%eax
c0100a25:	01 c0                	add    %eax,%eax
c0100a27:	01 d0                	add    %edx,%eax
c0100a29:	c1 e0 02             	shl    $0x2,%eax
c0100a2c:	89 c2                	mov    %eax,%edx
c0100a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a31:	01 d0                	add    %edx,%eax
c0100a33:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100a37:	3c a0                	cmp    $0xa0,%al
c0100a39:	74 c1                	je     c01009fc <debuginfo_eip+0x2e0>
        }
    }
    return 0;
c0100a3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100a40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100a43:	c9                   	leave  
c0100a44:	c3                   	ret    

c0100a45 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100a45:	55                   	push   %ebp
c0100a46:	89 e5                	mov    %esp,%ebp
c0100a48:	53                   	push   %ebx
c0100a49:	83 ec 04             	sub    $0x4,%esp
c0100a4c:	e8 59 f8 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0100a51:	81 c3 1f 6f 01 00    	add    $0x16f1f,%ebx
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100a57:	83 ec 0c             	sub    $0xc,%esp
c0100a5a:	8d 83 ca e8 fe ff    	lea    -0x11736(%ebx),%eax
c0100a60:	50                   	push   %eax
c0100a61:	e8 b7 f8 ff ff       	call   c010031d <cprintf>
c0100a66:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100a69:	83 ec 08             	sub    $0x8,%esp
c0100a6c:	c7 c0 2a 00 10 c0    	mov    $0xc010002a,%eax
c0100a72:	50                   	push   %eax
c0100a73:	8d 83 e3 e8 fe ff    	lea    -0x1171d(%ebx),%eax
c0100a79:	50                   	push   %eax
c0100a7a:	e8 9e f8 ff ff       	call   c010031d <cprintf>
c0100a7f:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100a82:	83 ec 08             	sub    $0x8,%esp
c0100a85:	c7 c0 46 61 10 c0    	mov    $0xc0106146,%eax
c0100a8b:	50                   	push   %eax
c0100a8c:	8d 83 fb e8 fe ff    	lea    -0x11705(%ebx),%eax
c0100a92:	50                   	push   %eax
c0100a93:	e8 85 f8 ff ff       	call   c010031d <cprintf>
c0100a98:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100a9b:	83 ec 08             	sub    $0x8,%esp
c0100a9e:	c7 c0 70 79 11 c0    	mov    $0xc0117970,%eax
c0100aa4:	50                   	push   %eax
c0100aa5:	8d 83 13 e9 fe ff    	lea    -0x116ed(%ebx),%eax
c0100aab:	50                   	push   %eax
c0100aac:	e8 6c f8 ff ff       	call   c010031d <cprintf>
c0100ab1:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100ab4:	83 ec 08             	sub    $0x8,%esp
c0100ab7:	c7 c0 28 8a 11 c0    	mov    $0xc0118a28,%eax
c0100abd:	50                   	push   %eax
c0100abe:	8d 83 2b e9 fe ff    	lea    -0x116d5(%ebx),%eax
c0100ac4:	50                   	push   %eax
c0100ac5:	e8 53 f8 ff ff       	call   c010031d <cprintf>
c0100aca:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c0100acd:	c7 c0 28 8a 11 c0    	mov    $0xc0118a28,%eax
c0100ad3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100ad9:	c7 c0 2a 00 10 c0    	mov    $0xc010002a,%eax
c0100adf:	29 c2                	sub    %eax,%edx
c0100ae1:	89 d0                	mov    %edx,%eax
c0100ae3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100ae9:	85 c0                	test   %eax,%eax
c0100aeb:	0f 48 c2             	cmovs  %edx,%eax
c0100aee:	c1 f8 0a             	sar    $0xa,%eax
c0100af1:	83 ec 08             	sub    $0x8,%esp
c0100af4:	50                   	push   %eax
c0100af5:	8d 83 44 e9 fe ff    	lea    -0x116bc(%ebx),%eax
c0100afb:	50                   	push   %eax
c0100afc:	e8 1c f8 ff ff       	call   c010031d <cprintf>
c0100b01:	83 c4 10             	add    $0x10,%esp
}
c0100b04:	90                   	nop
c0100b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100b08:	c9                   	leave  
c0100b09:	c3                   	ret    

c0100b0a <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100b0a:	55                   	push   %ebp
c0100b0b:	89 e5                	mov    %esp,%ebp
c0100b0d:	53                   	push   %ebx
c0100b0e:	81 ec 24 01 00 00    	sub    $0x124,%esp
c0100b14:	e8 91 f7 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0100b19:	81 c3 57 6e 01 00    	add    $0x16e57,%ebx
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100b1f:	83 ec 08             	sub    $0x8,%esp
c0100b22:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100b25:	50                   	push   %eax
c0100b26:	ff 75 08             	pushl  0x8(%ebp)
c0100b29:	e8 ee fb ff ff       	call   c010071c <debuginfo_eip>
c0100b2e:	83 c4 10             	add    $0x10,%esp
c0100b31:	85 c0                	test   %eax,%eax
c0100b33:	74 17                	je     c0100b4c <print_debuginfo+0x42>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100b35:	83 ec 08             	sub    $0x8,%esp
c0100b38:	ff 75 08             	pushl  0x8(%ebp)
c0100b3b:	8d 83 6e e9 fe ff    	lea    -0x11692(%ebx),%eax
c0100b41:	50                   	push   %eax
c0100b42:	e8 d6 f7 ff ff       	call   c010031d <cprintf>
c0100b47:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100b4a:	eb 67                	jmp    c0100bb3 <print_debuginfo+0xa9>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100b4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b53:	eb 1c                	jmp    c0100b71 <print_debuginfo+0x67>
            fnname[j] = info.eip_fn_name[j];
c0100b55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b5b:	01 d0                	add    %edx,%eax
c0100b5d:	0f b6 00             	movzbl (%eax),%eax
c0100b60:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100b66:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b69:	01 ca                	add    %ecx,%edx
c0100b6b:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100b6d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100b71:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b74:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100b77:	7c dc                	jl     c0100b55 <print_debuginfo+0x4b>
        fnname[j] = '\0';
c0100b79:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b82:	01 d0                	add    %edx,%eax
c0100b84:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100b87:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100b8a:	8b 55 08             	mov    0x8(%ebp),%edx
c0100b8d:	89 d1                	mov    %edx,%ecx
c0100b8f:	29 c1                	sub    %eax,%ecx
c0100b91:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100b94:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100b97:	83 ec 0c             	sub    $0xc,%esp
c0100b9a:	51                   	push   %ecx
c0100b9b:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100ba1:	51                   	push   %ecx
c0100ba2:	52                   	push   %edx
c0100ba3:	50                   	push   %eax
c0100ba4:	8d 83 8a e9 fe ff    	lea    -0x11676(%ebx),%eax
c0100baa:	50                   	push   %eax
c0100bab:	e8 6d f7 ff ff       	call   c010031d <cprintf>
c0100bb0:	83 c4 20             	add    $0x20,%esp
}
c0100bb3:	90                   	nop
c0100bb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100bb7:	c9                   	leave  
c0100bb8:	c3                   	ret    

c0100bb9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100bb9:	55                   	push   %ebp
c0100bba:	89 e5                	mov    %esp,%ebp
c0100bbc:	83 ec 10             	sub    $0x10,%esp
c0100bbf:	e8 e2 f6 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0100bc4:	05 ac 6d 01 00       	add    $0x16dac,%eax
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100bc9:	8b 45 04             	mov    0x4(%ebp),%eax
c0100bcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100bcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100bd2:	c9                   	leave  
c0100bd3:	c3                   	ret    

c0100bd4 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100bd4:	55                   	push   %ebp
c0100bd5:	89 e5                	mov    %esp,%ebp
c0100bd7:	e8 ca f6 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0100bdc:	05 94 6d 01 00       	add    $0x16d94,%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c0100be1:	90                   	nop
c0100be2:	5d                   	pop    %ebp
c0100be3:	c3                   	ret    

c0100be4 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100be4:	55                   	push   %ebp
c0100be5:	89 e5                	mov    %esp,%ebp
c0100be7:	53                   	push   %ebx
c0100be8:	83 ec 14             	sub    $0x14,%esp
c0100beb:	e8 ba f6 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0100bf0:	81 c3 80 6d 01 00    	add    $0x16d80,%ebx
    int argc = 0;
c0100bf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bfd:	eb 0c                	jmp    c0100c0b <parse+0x27>
            *buf ++ = '\0';
c0100bff:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c02:	8d 50 01             	lea    0x1(%eax),%edx
c0100c05:	89 55 08             	mov    %edx,0x8(%ebp)
c0100c08:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0e:	0f b6 00             	movzbl (%eax),%eax
c0100c11:	84 c0                	test   %al,%al
c0100c13:	74 20                	je     c0100c35 <parse+0x51>
c0100c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c18:	0f b6 00             	movzbl (%eax),%eax
c0100c1b:	0f be c0             	movsbl %al,%eax
c0100c1e:	83 ec 08             	sub    $0x8,%esp
c0100c21:	50                   	push   %eax
c0100c22:	8d 83 1c ea fe ff    	lea    -0x115e4(%ebx),%eax
c0100c28:	50                   	push   %eax
c0100c29:	e8 0f 4b 00 00       	call   c010573d <strchr>
c0100c2e:	83 c4 10             	add    $0x10,%esp
c0100c31:	85 c0                	test   %eax,%eax
c0100c33:	75 ca                	jne    c0100bff <parse+0x1b>
        }
        if (*buf == '\0') {
c0100c35:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c38:	0f b6 00             	movzbl (%eax),%eax
c0100c3b:	84 c0                	test   %al,%al
c0100c3d:	74 69                	je     c0100ca8 <parse+0xc4>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100c3f:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100c43:	75 14                	jne    c0100c59 <parse+0x75>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100c45:	83 ec 08             	sub    $0x8,%esp
c0100c48:	6a 10                	push   $0x10
c0100c4a:	8d 83 21 ea fe ff    	lea    -0x115df(%ebx),%eax
c0100c50:	50                   	push   %eax
c0100c51:	e8 c7 f6 ff ff       	call   c010031d <cprintf>
c0100c56:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c5c:	8d 50 01             	lea    0x1(%eax),%edx
c0100c5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100c62:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c6c:	01 c2                	add    %eax,%edx
c0100c6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c71:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c73:	eb 04                	jmp    c0100c79 <parse+0x95>
            buf ++;
c0100c75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c79:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c7c:	0f b6 00             	movzbl (%eax),%eax
c0100c7f:	84 c0                	test   %al,%al
c0100c81:	74 88                	je     c0100c0b <parse+0x27>
c0100c83:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c86:	0f b6 00             	movzbl (%eax),%eax
c0100c89:	0f be c0             	movsbl %al,%eax
c0100c8c:	83 ec 08             	sub    $0x8,%esp
c0100c8f:	50                   	push   %eax
c0100c90:	8d 83 1c ea fe ff    	lea    -0x115e4(%ebx),%eax
c0100c96:	50                   	push   %eax
c0100c97:	e8 a1 4a 00 00       	call   c010573d <strchr>
c0100c9c:	83 c4 10             	add    $0x10,%esp
c0100c9f:	85 c0                	test   %eax,%eax
c0100ca1:	74 d2                	je     c0100c75 <parse+0x91>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ca3:	e9 63 ff ff ff       	jmp    c0100c0b <parse+0x27>
            break;
c0100ca8:	90                   	nop
        }
    }
    return argc;
c0100ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100cac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100caf:	c9                   	leave  
c0100cb0:	c3                   	ret    

c0100cb1 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100cb1:	55                   	push   %ebp
c0100cb2:	89 e5                	mov    %esp,%ebp
c0100cb4:	56                   	push   %esi
c0100cb5:	53                   	push   %ebx
c0100cb6:	83 ec 50             	sub    $0x50,%esp
c0100cb9:	e8 ec f5 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0100cbe:	81 c3 b2 6c 01 00    	add    $0x16cb2,%ebx
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100cc4:	83 ec 08             	sub    $0x8,%esp
c0100cc7:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100cca:	50                   	push   %eax
c0100ccb:	ff 75 08             	pushl  0x8(%ebp)
c0100cce:	e8 11 ff ff ff       	call   c0100be4 <parse>
c0100cd3:	83 c4 10             	add    $0x10,%esp
c0100cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100cd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100cdd:	75 0a                	jne    c0100ce9 <runcmd+0x38>
        return 0;
c0100cdf:	b8 00 00 00 00       	mov    $0x0,%eax
c0100ce4:	e9 8b 00 00 00       	jmp    c0100d74 <runcmd+0xc3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ce9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100cf0:	eb 5f                	jmp    c0100d51 <runcmd+0xa0>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100cf2:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cf8:	8d b3 10 00 00 00    	lea    0x10(%ebx),%esi
c0100cfe:	89 d0                	mov    %edx,%eax
c0100d00:	01 c0                	add    %eax,%eax
c0100d02:	01 d0                	add    %edx,%eax
c0100d04:	c1 e0 02             	shl    $0x2,%eax
c0100d07:	01 f0                	add    %esi,%eax
c0100d09:	8b 00                	mov    (%eax),%eax
c0100d0b:	83 ec 08             	sub    $0x8,%esp
c0100d0e:	51                   	push   %ecx
c0100d0f:	50                   	push   %eax
c0100d10:	e8 74 49 00 00       	call   c0105689 <strcmp>
c0100d15:	83 c4 10             	add    $0x10,%esp
c0100d18:	85 c0                	test   %eax,%eax
c0100d1a:	75 31                	jne    c0100d4d <runcmd+0x9c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100d1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d1f:	8d 8b 18 00 00 00    	lea    0x18(%ebx),%ecx
c0100d25:	89 d0                	mov    %edx,%eax
c0100d27:	01 c0                	add    %eax,%eax
c0100d29:	01 d0                	add    %edx,%eax
c0100d2b:	c1 e0 02             	shl    $0x2,%eax
c0100d2e:	01 c8                	add    %ecx,%eax
c0100d30:	8b 10                	mov    (%eax),%edx
c0100d32:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100d35:	83 c0 04             	add    $0x4,%eax
c0100d38:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100d3b:	83 e9 01             	sub    $0x1,%ecx
c0100d3e:	83 ec 04             	sub    $0x4,%esp
c0100d41:	ff 75 0c             	pushl  0xc(%ebp)
c0100d44:	50                   	push   %eax
c0100d45:	51                   	push   %ecx
c0100d46:	ff d2                	call   *%edx
c0100d48:	83 c4 10             	add    $0x10,%esp
c0100d4b:	eb 27                	jmp    c0100d74 <runcmd+0xc3>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d4d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d54:	83 f8 02             	cmp    $0x2,%eax
c0100d57:	76 99                	jbe    c0100cf2 <runcmd+0x41>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100d59:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100d5c:	83 ec 08             	sub    $0x8,%esp
c0100d5f:	50                   	push   %eax
c0100d60:	8d 83 3f ea fe ff    	lea    -0x115c1(%ebx),%eax
c0100d66:	50                   	push   %eax
c0100d67:	e8 b1 f5 ff ff       	call   c010031d <cprintf>
c0100d6c:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d74:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0100d77:	5b                   	pop    %ebx
c0100d78:	5e                   	pop    %esi
c0100d79:	5d                   	pop    %ebp
c0100d7a:	c3                   	ret    

c0100d7b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100d7b:	55                   	push   %ebp
c0100d7c:	89 e5                	mov    %esp,%ebp
c0100d7e:	53                   	push   %ebx
c0100d7f:	83 ec 14             	sub    $0x14,%esp
c0100d82:	e8 23 f5 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0100d87:	81 c3 e9 6b 01 00    	add    $0x16be9,%ebx
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100d8d:	83 ec 0c             	sub    $0xc,%esp
c0100d90:	8d 83 58 ea fe ff    	lea    -0x115a8(%ebx),%eax
c0100d96:	50                   	push   %eax
c0100d97:	e8 81 f5 ff ff       	call   c010031d <cprintf>
c0100d9c:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100d9f:	83 ec 0c             	sub    $0xc,%esp
c0100da2:	8d 83 80 ea fe ff    	lea    -0x11580(%ebx),%eax
c0100da8:	50                   	push   %eax
c0100da9:	e8 6f f5 ff ff       	call   c010031d <cprintf>
c0100dae:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100db1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100db5:	74 0e                	je     c0100dc5 <kmonitor+0x4a>
        print_trapframe(tf);
c0100db7:	83 ec 0c             	sub    $0xc,%esp
c0100dba:	ff 75 08             	pushl  0x8(%ebp)
c0100dbd:	e8 1c 0e 00 00       	call   c0101bde <print_trapframe>
c0100dc2:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100dc5:	83 ec 0c             	sub    $0xc,%esp
c0100dc8:	8d 83 a5 ea fe ff    	lea    -0x1155b(%ebx),%eax
c0100dce:	50                   	push   %eax
c0100dcf:	e8 21 f6 ff ff       	call   c01003f5 <readline>
c0100dd4:	83 c4 10             	add    $0x10,%esp
c0100dd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100dda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100dde:	74 e5                	je     c0100dc5 <kmonitor+0x4a>
            if (runcmd(buf, tf) < 0) {
c0100de0:	83 ec 08             	sub    $0x8,%esp
c0100de3:	ff 75 08             	pushl  0x8(%ebp)
c0100de6:	ff 75 f4             	pushl  -0xc(%ebp)
c0100de9:	e8 c3 fe ff ff       	call   c0100cb1 <runcmd>
c0100dee:	83 c4 10             	add    $0x10,%esp
c0100df1:	85 c0                	test   %eax,%eax
c0100df3:	78 02                	js     c0100df7 <kmonitor+0x7c>
        if ((buf = readline("K> ")) != NULL) {
c0100df5:	eb ce                	jmp    c0100dc5 <kmonitor+0x4a>
                break;
c0100df7:	90                   	nop
            }
        }
    }
}
c0100df8:	90                   	nop
c0100df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100dfc:	c9                   	leave  
c0100dfd:	c3                   	ret    

c0100dfe <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100dfe:	55                   	push   %ebp
c0100dff:	89 e5                	mov    %esp,%ebp
c0100e01:	56                   	push   %esi
c0100e02:	53                   	push   %ebx
c0100e03:	83 ec 10             	sub    $0x10,%esp
c0100e06:	e8 9f f4 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0100e0b:	81 c3 65 6b 01 00    	add    $0x16b65,%ebx
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100e11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100e18:	eb 44                	jmp    c0100e5e <mon_help+0x60>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100e1d:	8d 8b 14 00 00 00    	lea    0x14(%ebx),%ecx
c0100e23:	89 d0                	mov    %edx,%eax
c0100e25:	01 c0                	add    %eax,%eax
c0100e27:	01 d0                	add    %edx,%eax
c0100e29:	c1 e0 02             	shl    $0x2,%eax
c0100e2c:	01 c8                	add    %ecx,%eax
c0100e2e:	8b 08                	mov    (%eax),%ecx
c0100e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100e33:	8d b3 10 00 00 00    	lea    0x10(%ebx),%esi
c0100e39:	89 d0                	mov    %edx,%eax
c0100e3b:	01 c0                	add    %eax,%eax
c0100e3d:	01 d0                	add    %edx,%eax
c0100e3f:	c1 e0 02             	shl    $0x2,%eax
c0100e42:	01 f0                	add    %esi,%eax
c0100e44:	8b 00                	mov    (%eax),%eax
c0100e46:	83 ec 04             	sub    $0x4,%esp
c0100e49:	51                   	push   %ecx
c0100e4a:	50                   	push   %eax
c0100e4b:	8d 83 a9 ea fe ff    	lea    -0x11557(%ebx),%eax
c0100e51:	50                   	push   %eax
c0100e52:	e8 c6 f4 ff ff       	call   c010031d <cprintf>
c0100e57:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
c0100e5a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e61:	83 f8 02             	cmp    $0x2,%eax
c0100e64:	76 b4                	jbe    c0100e1a <mon_help+0x1c>
    }
    return 0;
c0100e66:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0100e6e:	5b                   	pop    %ebx
c0100e6f:	5e                   	pop    %esi
c0100e70:	5d                   	pop    %ebp
c0100e71:	c3                   	ret    

c0100e72 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100e72:	55                   	push   %ebp
c0100e73:	89 e5                	mov    %esp,%ebp
c0100e75:	53                   	push   %ebx
c0100e76:	83 ec 04             	sub    $0x4,%esp
c0100e79:	e8 28 f4 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0100e7e:	05 f2 6a 01 00       	add    $0x16af2,%eax
    print_kerninfo();
c0100e83:	89 c3                	mov    %eax,%ebx
c0100e85:	e8 bb fb ff ff       	call   c0100a45 <print_kerninfo>
    return 0;
c0100e8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e8f:	83 c4 04             	add    $0x4,%esp
c0100e92:	5b                   	pop    %ebx
c0100e93:	5d                   	pop    %ebp
c0100e94:	c3                   	ret    

c0100e95 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100e95:	55                   	push   %ebp
c0100e96:	89 e5                	mov    %esp,%ebp
c0100e98:	53                   	push   %ebx
c0100e99:	83 ec 04             	sub    $0x4,%esp
c0100e9c:	e8 05 f4 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0100ea1:	05 cf 6a 01 00       	add    $0x16acf,%eax
    print_stackframe();
c0100ea6:	89 c3                	mov    %eax,%ebx
c0100ea8:	e8 27 fd ff ff       	call   c0100bd4 <print_stackframe>
    return 0;
c0100ead:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100eb2:	83 c4 04             	add    $0x4,%esp
c0100eb5:	5b                   	pop    %ebx
c0100eb6:	5d                   	pop    %ebp
c0100eb7:	c3                   	ret    

c0100eb8 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100eb8:	55                   	push   %ebp
c0100eb9:	89 e5                	mov    %esp,%ebp
c0100ebb:	53                   	push   %ebx
c0100ebc:	83 ec 14             	sub    $0x14,%esp
c0100ebf:	e8 e6 f3 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0100ec4:	81 c3 ac 6a 01 00    	add    $0x16aac,%ebx
c0100eca:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100ed0:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ed4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ed8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100edc:	ee                   	out    %al,(%dx)
c0100edd:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100ee3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100ee7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100eeb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eef:	ee                   	out    %al,(%dx)
c0100ef0:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100ef6:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
c0100efa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100efe:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f02:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100f03:	c7 c0 0c 8a 11 c0    	mov    $0xc0118a0c,%eax
c0100f09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("++ setup timer interrupts\n");
c0100f0f:	83 ec 0c             	sub    $0xc,%esp
c0100f12:	8d 83 b2 ea fe ff    	lea    -0x1154e(%ebx),%eax
c0100f18:	50                   	push   %eax
c0100f19:	e8 ff f3 ff ff       	call   c010031d <cprintf>
c0100f1e:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100f21:	83 ec 0c             	sub    $0xc,%esp
c0100f24:	6a 00                	push   $0x0
c0100f26:	e8 76 0a 00 00       	call   c01019a1 <pic_enable>
c0100f2b:	83 c4 10             	add    $0x10,%esp
}
c0100f2e:	90                   	nop
c0100f2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100f32:	c9                   	leave  
c0100f33:	c3                   	ret    

c0100f34 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100f34:	55                   	push   %ebp
c0100f35:	89 e5                	mov    %esp,%ebp
c0100f37:	53                   	push   %ebx
c0100f38:	83 ec 14             	sub    $0x14,%esp
c0100f3b:	e8 66 f3 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0100f40:	05 30 6a 01 00       	add    $0x16a30,%eax
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100f45:	9c                   	pushf  
c0100f46:	5a                   	pop    %edx
c0100f47:	89 55 f4             	mov    %edx,-0xc(%ebp)
    return eflags;
c0100f4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    if (read_eflags() & FL_IF) {
c0100f4d:	81 e2 00 02 00 00    	and    $0x200,%edx
c0100f53:	85 d2                	test   %edx,%edx
c0100f55:	74 0e                	je     c0100f65 <__intr_save+0x31>
        intr_disable();
c0100f57:	89 c3                	mov    %eax,%ebx
c0100f59:	e8 d5 0b 00 00       	call   c0101b33 <intr_disable>
        return 1;
c0100f5e:	b8 01 00 00 00       	mov    $0x1,%eax
c0100f63:	eb 05                	jmp    c0100f6a <__intr_save+0x36>
    }
    return 0;
c0100f65:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100f6a:	83 c4 14             	add    $0x14,%esp
c0100f6d:	5b                   	pop    %ebx
c0100f6e:	5d                   	pop    %ebp
c0100f6f:	c3                   	ret    

c0100f70 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100f70:	55                   	push   %ebp
c0100f71:	89 e5                	mov    %esp,%ebp
c0100f73:	53                   	push   %ebx
c0100f74:	83 ec 04             	sub    $0x4,%esp
c0100f77:	e8 2a f3 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0100f7c:	05 f4 69 01 00       	add    $0x169f4,%eax
    if (flag) {
c0100f81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100f85:	74 07                	je     c0100f8e <__intr_restore+0x1e>
        intr_enable();
c0100f87:	89 c3                	mov    %eax,%ebx
c0100f89:	e8 94 0b 00 00       	call   c0101b22 <intr_enable>
    }
}
c0100f8e:	90                   	nop
c0100f8f:	83 c4 04             	add    $0x4,%esp
c0100f92:	5b                   	pop    %ebx
c0100f93:	5d                   	pop    %ebp
c0100f94:	c3                   	ret    

c0100f95 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100f95:	55                   	push   %ebp
c0100f96:	89 e5                	mov    %esp,%ebp
c0100f98:	83 ec 10             	sub    $0x10,%esp
c0100f9b:	e8 06 f3 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0100fa0:	05 d0 69 01 00       	add    $0x169d0,%eax
c0100fa5:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fab:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100faf:	89 c2                	mov    %eax,%edx
c0100fb1:	ec                   	in     (%dx),%al
c0100fb2:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100fb5:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100fbb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100fbf:	89 c2                	mov    %eax,%edx
c0100fc1:	ec                   	in     (%dx),%al
c0100fc2:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100fc5:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100fcb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100fcf:	89 c2                	mov    %eax,%edx
c0100fd1:	ec                   	in     (%dx),%al
c0100fd2:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100fd5:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100fdb:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100fdf:	89 c2                	mov    %eax,%edx
c0100fe1:	ec                   	in     (%dx),%al
c0100fe2:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100fe5:	90                   	nop
c0100fe6:	c9                   	leave  
c0100fe7:	c3                   	ret    

c0100fe8 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100fe8:	55                   	push   %ebp
c0100fe9:	89 e5                	mov    %esp,%ebp
c0100feb:	83 ec 20             	sub    $0x20,%esp
c0100fee:	e8 45 09 00 00       	call   c0101938 <__x86.get_pc_thunk.cx>
c0100ff3:	81 c1 7d 69 01 00    	add    $0x1697d,%ecx
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ff9:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0101000:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101003:	0f b7 00             	movzwl (%eax),%eax
c0101006:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c010100a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010100d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0101012:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101015:	0f b7 00             	movzwl (%eax),%eax
c0101018:	66 3d 5a a5          	cmp    $0xa55a,%ax
c010101c:	74 12                	je     c0101030 <cga_init+0x48>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c010101e:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0101025:	66 c7 81 d6 05 00 00 	movw   $0x3b4,0x5d6(%ecx)
c010102c:	b4 03 
c010102e:	eb 13                	jmp    c0101043 <cga_init+0x5b>
    } else {
        *cp = was;
c0101030:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101033:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101037:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c010103a:	66 c7 81 d6 05 00 00 	movw   $0x3d4,0x5d6(%ecx)
c0101041:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0101043:	0f b7 81 d6 05 00 00 	movzwl 0x5d6(%ecx),%eax
c010104a:	0f b7 c0             	movzwl %ax,%eax
c010104d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101051:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101055:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101059:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010105d:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c010105e:	0f b7 81 d6 05 00 00 	movzwl 0x5d6(%ecx),%eax
c0101065:	83 c0 01             	add    $0x1,%eax
c0101068:	0f b7 c0             	movzwl %ax,%eax
c010106b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010106f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101073:	89 c2                	mov    %eax,%edx
c0101075:	ec                   	in     (%dx),%al
c0101076:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0101079:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010107d:	0f b6 c0             	movzbl %al,%eax
c0101080:	c1 e0 08             	shl    $0x8,%eax
c0101083:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0101086:	0f b7 81 d6 05 00 00 	movzwl 0x5d6(%ecx),%eax
c010108d:	0f b7 c0             	movzwl %ax,%eax
c0101090:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101094:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101098:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010109c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010a0:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c01010a1:	0f b7 81 d6 05 00 00 	movzwl 0x5d6(%ecx),%eax
c01010a8:	83 c0 01             	add    $0x1,%eax
c01010ab:	0f b7 c0             	movzwl %ax,%eax
c01010ae:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01010b2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01010b6:	89 c2                	mov    %eax,%edx
c01010b8:	ec                   	in     (%dx),%al
c01010b9:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c01010bc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010c0:	0f b6 c0             	movzbl %al,%eax
c01010c3:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c01010c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01010c9:	89 81 d0 05 00 00    	mov    %eax,0x5d0(%ecx)
    crt_pos = pos;
c01010cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01010d2:	66 89 81 d4 05 00 00 	mov    %ax,0x5d4(%ecx)
}
c01010d9:	90                   	nop
c01010da:	c9                   	leave  
c01010db:	c3                   	ret    

c01010dc <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c01010dc:	55                   	push   %ebp
c01010dd:	89 e5                	mov    %esp,%ebp
c01010df:	53                   	push   %ebx
c01010e0:	83 ec 34             	sub    $0x34,%esp
c01010e3:	e8 50 08 00 00       	call   c0101938 <__x86.get_pc_thunk.cx>
c01010e8:	81 c1 88 68 01 00    	add    $0x16888,%ecx
c01010ee:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c01010f4:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010f8:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01010fc:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101100:	ee                   	out    %al,(%dx)
c0101101:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0101107:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
c010110b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010110f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101113:	ee                   	out    %al,(%dx)
c0101114:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c010111a:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
c010111e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101122:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101126:	ee                   	out    %al,(%dx)
c0101127:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c010112d:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0101131:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101135:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101139:	ee                   	out    %al,(%dx)
c010113a:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0101140:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
c0101144:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101148:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010114c:	ee                   	out    %al,(%dx)
c010114d:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0101153:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
c0101157:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010115b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010115f:	ee                   	out    %al,(%dx)
c0101160:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101166:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
c010116a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010116e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101172:	ee                   	out    %al,(%dx)
c0101173:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101179:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c010117d:	89 c2                	mov    %eax,%edx
c010117f:	ec                   	in     (%dx),%al
c0101180:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101183:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101187:	3c ff                	cmp    $0xff,%al
c0101189:	0f 95 c0             	setne  %al
c010118c:	0f b6 c0             	movzbl %al,%eax
c010118f:	89 81 d8 05 00 00    	mov    %eax,0x5d8(%ecx)
c0101195:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010119b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010119f:	89 c2                	mov    %eax,%edx
c01011a1:	ec                   	in     (%dx),%al
c01011a2:	88 45 f1             	mov    %al,-0xf(%ebp)
c01011a5:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01011ab:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01011af:	89 c2                	mov    %eax,%edx
c01011b1:	ec                   	in     (%dx),%al
c01011b2:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c01011b5:	8b 81 d8 05 00 00    	mov    0x5d8(%ecx),%eax
c01011bb:	85 c0                	test   %eax,%eax
c01011bd:	74 0f                	je     c01011ce <serial_init+0xf2>
        pic_enable(IRQ_COM1);
c01011bf:	83 ec 0c             	sub    $0xc,%esp
c01011c2:	6a 04                	push   $0x4
c01011c4:	89 cb                	mov    %ecx,%ebx
c01011c6:	e8 d6 07 00 00       	call   c01019a1 <pic_enable>
c01011cb:	83 c4 10             	add    $0x10,%esp
    }
}
c01011ce:	90                   	nop
c01011cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01011d2:	c9                   	leave  
c01011d3:	c3                   	ret    

c01011d4 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01011d4:	55                   	push   %ebp
c01011d5:	89 e5                	mov    %esp,%ebp
c01011d7:	83 ec 20             	sub    $0x20,%esp
c01011da:	e8 c7 f0 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01011df:	05 91 67 01 00       	add    $0x16791,%eax
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01011e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01011eb:	eb 09                	jmp    c01011f6 <lpt_putc_sub+0x22>
        delay();
c01011ed:	e8 a3 fd ff ff       	call   c0100f95 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01011f2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01011f6:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01011fc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101200:	89 c2                	mov    %eax,%edx
c0101202:	ec                   	in     (%dx),%al
c0101203:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101206:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010120a:	84 c0                	test   %al,%al
c010120c:	78 09                	js     c0101217 <lpt_putc_sub+0x43>
c010120e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101215:	7e d6                	jle    c01011ed <lpt_putc_sub+0x19>
    }
    outb(LPTPORT + 0, c);
c0101217:	8b 45 08             	mov    0x8(%ebp),%eax
c010121a:	0f b6 c0             	movzbl %al,%eax
c010121d:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101223:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101226:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010122a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010122e:	ee                   	out    %al,(%dx)
c010122f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101235:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101239:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010123d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101241:	ee                   	out    %al,(%dx)
c0101242:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101248:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
c010124c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101250:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101254:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101255:	90                   	nop
c0101256:	c9                   	leave  
c0101257:	c3                   	ret    

c0101258 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101258:	55                   	push   %ebp
c0101259:	89 e5                	mov    %esp,%ebp
c010125b:	e8 46 f0 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0101260:	05 10 67 01 00       	add    $0x16710,%eax
    if (c != '\b') {
c0101265:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101269:	74 0d                	je     c0101278 <lpt_putc+0x20>
        lpt_putc_sub(c);
c010126b:	ff 75 08             	pushl  0x8(%ebp)
c010126e:	e8 61 ff ff ff       	call   c01011d4 <lpt_putc_sub>
c0101273:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101276:	eb 1e                	jmp    c0101296 <lpt_putc+0x3e>
        lpt_putc_sub('\b');
c0101278:	6a 08                	push   $0x8
c010127a:	e8 55 ff ff ff       	call   c01011d4 <lpt_putc_sub>
c010127f:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c0101282:	6a 20                	push   $0x20
c0101284:	e8 4b ff ff ff       	call   c01011d4 <lpt_putc_sub>
c0101289:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c010128c:	6a 08                	push   $0x8
c010128e:	e8 41 ff ff ff       	call   c01011d4 <lpt_putc_sub>
c0101293:	83 c4 04             	add    $0x4,%esp
}
c0101296:	90                   	nop
c0101297:	c9                   	leave  
c0101298:	c3                   	ret    

c0101299 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101299:	55                   	push   %ebp
c010129a:	89 e5                	mov    %esp,%ebp
c010129c:	56                   	push   %esi
c010129d:	53                   	push   %ebx
c010129e:	83 ec 20             	sub    $0x20,%esp
c01012a1:	e8 04 f0 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c01012a6:	81 c3 ca 66 01 00    	add    $0x166ca,%ebx
    // set black on white
    if (!(c & ~0xFF)) {
c01012ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01012af:	b0 00                	mov    $0x0,%al
c01012b1:	85 c0                	test   %eax,%eax
c01012b3:	75 07                	jne    c01012bc <cga_putc+0x23>
        c |= 0x0700;
c01012b5:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01012bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01012bf:	0f b6 c0             	movzbl %al,%eax
c01012c2:	83 f8 0a             	cmp    $0xa,%eax
c01012c5:	74 54                	je     c010131b <cga_putc+0x82>
c01012c7:	83 f8 0d             	cmp    $0xd,%eax
c01012ca:	74 60                	je     c010132c <cga_putc+0x93>
c01012cc:	83 f8 08             	cmp    $0x8,%eax
c01012cf:	0f 85 92 00 00 00    	jne    c0101367 <cga_putc+0xce>
    case '\b':
        if (crt_pos > 0) {
c01012d5:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
c01012dc:	66 85 c0             	test   %ax,%ax
c01012df:	0f 84 a8 00 00 00    	je     c010138d <cga_putc+0xf4>
            crt_pos --;
c01012e5:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
c01012ec:	83 e8 01             	sub    $0x1,%eax
c01012ef:	66 89 83 d4 05 00 00 	mov    %ax,0x5d4(%ebx)
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01012f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01012f9:	b0 00                	mov    $0x0,%al
c01012fb:	83 c8 20             	or     $0x20,%eax
c01012fe:	89 c1                	mov    %eax,%ecx
c0101300:	8b 83 d0 05 00 00    	mov    0x5d0(%ebx),%eax
c0101306:	0f b7 93 d4 05 00 00 	movzwl 0x5d4(%ebx),%edx
c010130d:	0f b7 d2             	movzwl %dx,%edx
c0101310:	01 d2                	add    %edx,%edx
c0101312:	01 d0                	add    %edx,%eax
c0101314:	89 ca                	mov    %ecx,%edx
c0101316:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c0101319:	eb 72                	jmp    c010138d <cga_putc+0xf4>
    case '\n':
        crt_pos += CRT_COLS;
c010131b:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
c0101322:	83 c0 50             	add    $0x50,%eax
c0101325:	66 89 83 d4 05 00 00 	mov    %ax,0x5d4(%ebx)
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010132c:	0f b7 b3 d4 05 00 00 	movzwl 0x5d4(%ebx),%esi
c0101333:	0f b7 8b d4 05 00 00 	movzwl 0x5d4(%ebx),%ecx
c010133a:	0f b7 c1             	movzwl %cx,%eax
c010133d:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101343:	c1 e8 10             	shr    $0x10,%eax
c0101346:	89 c2                	mov    %eax,%edx
c0101348:	66 c1 ea 06          	shr    $0x6,%dx
c010134c:	89 d0                	mov    %edx,%eax
c010134e:	c1 e0 02             	shl    $0x2,%eax
c0101351:	01 d0                	add    %edx,%eax
c0101353:	c1 e0 04             	shl    $0x4,%eax
c0101356:	29 c1                	sub    %eax,%ecx
c0101358:	89 ca                	mov    %ecx,%edx
c010135a:	89 f0                	mov    %esi,%eax
c010135c:	29 d0                	sub    %edx,%eax
c010135e:	66 89 83 d4 05 00 00 	mov    %ax,0x5d4(%ebx)
        break;
c0101365:	eb 27                	jmp    c010138e <cga_putc+0xf5>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101367:	8b 8b d0 05 00 00    	mov    0x5d0(%ebx),%ecx
c010136d:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
c0101374:	8d 50 01             	lea    0x1(%eax),%edx
c0101377:	66 89 93 d4 05 00 00 	mov    %dx,0x5d4(%ebx)
c010137e:	0f b7 c0             	movzwl %ax,%eax
c0101381:	01 c0                	add    %eax,%eax
c0101383:	01 c8                	add    %ecx,%eax
c0101385:	8b 55 08             	mov    0x8(%ebp),%edx
c0101388:	66 89 10             	mov    %dx,(%eax)
        break;
c010138b:	eb 01                	jmp    c010138e <cga_putc+0xf5>
        break;
c010138d:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010138e:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
c0101395:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101399:	76 5d                	jbe    c01013f8 <cga_putc+0x15f>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c010139b:	8b 83 d0 05 00 00    	mov    0x5d0(%ebx),%eax
c01013a1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01013a7:	8b 83 d0 05 00 00    	mov    0x5d0(%ebx),%eax
c01013ad:	83 ec 04             	sub    $0x4,%esp
c01013b0:	68 00 0f 00 00       	push   $0xf00
c01013b5:	52                   	push   %edx
c01013b6:	50                   	push   %eax
c01013b7:	e8 a8 45 00 00       	call   c0105964 <memmove>
c01013bc:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01013bf:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01013c6:	eb 16                	jmp    c01013de <cga_putc+0x145>
            crt_buf[i] = 0x0700 | ' ';
c01013c8:	8b 83 d0 05 00 00    	mov    0x5d0(%ebx),%eax
c01013ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013d1:	01 d2                	add    %edx,%edx
c01013d3:	01 d0                	add    %edx,%eax
c01013d5:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01013da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01013de:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01013e5:	7e e1                	jle    c01013c8 <cga_putc+0x12f>
        }
        crt_pos -= CRT_COLS;
c01013e7:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
c01013ee:	83 e8 50             	sub    $0x50,%eax
c01013f1:	66 89 83 d4 05 00 00 	mov    %ax,0x5d4(%ebx)
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01013f8:	0f b7 83 d6 05 00 00 	movzwl 0x5d6(%ebx),%eax
c01013ff:	0f b7 c0             	movzwl %ax,%eax
c0101402:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101406:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c010140a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010140e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101412:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101413:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
c010141a:	66 c1 e8 08          	shr    $0x8,%ax
c010141e:	0f b6 c0             	movzbl %al,%eax
c0101421:	0f b7 93 d6 05 00 00 	movzwl 0x5d6(%ebx),%edx
c0101428:	83 c2 01             	add    $0x1,%edx
c010142b:	0f b7 d2             	movzwl %dx,%edx
c010142e:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101432:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101435:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101439:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010143d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010143e:	0f b7 83 d6 05 00 00 	movzwl 0x5d6(%ebx),%eax
c0101445:	0f b7 c0             	movzwl %ax,%eax
c0101448:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c010144c:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c0101450:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101454:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101458:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101459:	0f b7 83 d4 05 00 00 	movzwl 0x5d4(%ebx),%eax
c0101460:	0f b6 c0             	movzbl %al,%eax
c0101463:	0f b7 93 d6 05 00 00 	movzwl 0x5d6(%ebx),%edx
c010146a:	83 c2 01             	add    $0x1,%edx
c010146d:	0f b7 d2             	movzwl %dx,%edx
c0101470:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101474:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101477:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010147b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010147f:	ee                   	out    %al,(%dx)
}
c0101480:	90                   	nop
c0101481:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0101484:	5b                   	pop    %ebx
c0101485:	5e                   	pop    %esi
c0101486:	5d                   	pop    %ebp
c0101487:	c3                   	ret    

c0101488 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101488:	55                   	push   %ebp
c0101489:	89 e5                	mov    %esp,%ebp
c010148b:	83 ec 10             	sub    $0x10,%esp
c010148e:	e8 13 ee ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0101493:	05 dd 64 01 00       	add    $0x164dd,%eax
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101498:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010149f:	eb 09                	jmp    c01014aa <serial_putc_sub+0x22>
        delay();
c01014a1:	e8 ef fa ff ff       	call   c0100f95 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01014a6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01014aa:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014b0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01014b4:	89 c2                	mov    %eax,%edx
c01014b6:	ec                   	in     (%dx),%al
c01014b7:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01014ba:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01014be:	0f b6 c0             	movzbl %al,%eax
c01014c1:	83 e0 20             	and    $0x20,%eax
c01014c4:	85 c0                	test   %eax,%eax
c01014c6:	75 09                	jne    c01014d1 <serial_putc_sub+0x49>
c01014c8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01014cf:	7e d0                	jle    c01014a1 <serial_putc_sub+0x19>
    }
    outb(COM1 + COM_TX, c);
c01014d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01014d4:	0f b6 c0             	movzbl %al,%eax
c01014d7:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01014dd:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01014e0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01014e4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01014e8:	ee                   	out    %al,(%dx)
}
c01014e9:	90                   	nop
c01014ea:	c9                   	leave  
c01014eb:	c3                   	ret    

c01014ec <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01014ec:	55                   	push   %ebp
c01014ed:	89 e5                	mov    %esp,%ebp
c01014ef:	e8 b2 ed ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01014f4:	05 7c 64 01 00       	add    $0x1647c,%eax
    if (c != '\b') {
c01014f9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01014fd:	74 0d                	je     c010150c <serial_putc+0x20>
        serial_putc_sub(c);
c01014ff:	ff 75 08             	pushl  0x8(%ebp)
c0101502:	e8 81 ff ff ff       	call   c0101488 <serial_putc_sub>
c0101507:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c010150a:	eb 1e                	jmp    c010152a <serial_putc+0x3e>
        serial_putc_sub('\b');
c010150c:	6a 08                	push   $0x8
c010150e:	e8 75 ff ff ff       	call   c0101488 <serial_putc_sub>
c0101513:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101516:	6a 20                	push   $0x20
c0101518:	e8 6b ff ff ff       	call   c0101488 <serial_putc_sub>
c010151d:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c0101520:	6a 08                	push   $0x8
c0101522:	e8 61 ff ff ff       	call   c0101488 <serial_putc_sub>
c0101527:	83 c4 04             	add    $0x4,%esp
}
c010152a:	90                   	nop
c010152b:	c9                   	leave  
c010152c:	c3                   	ret    

c010152d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010152d:	55                   	push   %ebp
c010152e:	89 e5                	mov    %esp,%ebp
c0101530:	53                   	push   %ebx
c0101531:	83 ec 14             	sub    $0x14,%esp
c0101534:	e8 71 ed ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0101539:	81 c3 37 64 01 00    	add    $0x16437,%ebx
    int c;
    while ((c = (*proc)()) != -1) {
c010153f:	eb 36                	jmp    c0101577 <cons_intr+0x4a>
        if (c != 0) {
c0101541:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101545:	74 30                	je     c0101577 <cons_intr+0x4a>
            cons.buf[cons.wpos ++] = c;
c0101547:	8b 83 f4 07 00 00    	mov    0x7f4(%ebx),%eax
c010154d:	8d 50 01             	lea    0x1(%eax),%edx
c0101550:	89 93 f4 07 00 00    	mov    %edx,0x7f4(%ebx)
c0101556:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101559:	88 94 03 f0 05 00 00 	mov    %dl,0x5f0(%ebx,%eax,1)
            if (cons.wpos == CONSBUFSIZE) {
c0101560:	8b 83 f4 07 00 00    	mov    0x7f4(%ebx),%eax
c0101566:	3d 00 02 00 00       	cmp    $0x200,%eax
c010156b:	75 0a                	jne    c0101577 <cons_intr+0x4a>
                cons.wpos = 0;
c010156d:	c7 83 f4 07 00 00 00 	movl   $0x0,0x7f4(%ebx)
c0101574:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101577:	8b 45 08             	mov    0x8(%ebp),%eax
c010157a:	ff d0                	call   *%eax
c010157c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010157f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101583:	75 bc                	jne    c0101541 <cons_intr+0x14>
            }
        }
    }
}
c0101585:	90                   	nop
c0101586:	83 c4 14             	add    $0x14,%esp
c0101589:	5b                   	pop    %ebx
c010158a:	5d                   	pop    %ebp
c010158b:	c3                   	ret    

c010158c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010158c:	55                   	push   %ebp
c010158d:	89 e5                	mov    %esp,%ebp
c010158f:	83 ec 10             	sub    $0x10,%esp
c0101592:	e8 0f ed ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0101597:	05 d9 63 01 00       	add    $0x163d9,%eax
c010159c:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01015a2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01015a6:	89 c2                	mov    %eax,%edx
c01015a8:	ec                   	in     (%dx),%al
c01015a9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01015ac:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01015b0:	0f b6 c0             	movzbl %al,%eax
c01015b3:	83 e0 01             	and    $0x1,%eax
c01015b6:	85 c0                	test   %eax,%eax
c01015b8:	75 07                	jne    c01015c1 <serial_proc_data+0x35>
        return -1;
c01015ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01015bf:	eb 2a                	jmp    c01015eb <serial_proc_data+0x5f>
c01015c1:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01015c7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01015cb:	89 c2                	mov    %eax,%edx
c01015cd:	ec                   	in     (%dx),%al
c01015ce:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01015d1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01015d5:	0f b6 c0             	movzbl %al,%eax
c01015d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01015db:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01015df:	75 07                	jne    c01015e8 <serial_proc_data+0x5c>
        c = '\b';
c01015e1:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01015e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01015eb:	c9                   	leave  
c01015ec:	c3                   	ret    

c01015ed <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01015ed:	55                   	push   %ebp
c01015ee:	89 e5                	mov    %esp,%ebp
c01015f0:	83 ec 08             	sub    $0x8,%esp
c01015f3:	e8 ae ec ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01015f8:	05 78 63 01 00       	add    $0x16378,%eax
    if (serial_exists) {
c01015fd:	8b 90 d8 05 00 00    	mov    0x5d8(%eax),%edx
c0101603:	85 d2                	test   %edx,%edx
c0101605:	74 12                	je     c0101619 <serial_intr+0x2c>
        cons_intr(serial_proc_data);
c0101607:	83 ec 0c             	sub    $0xc,%esp
c010160a:	8d 80 1c 9c fe ff    	lea    -0x163e4(%eax),%eax
c0101610:	50                   	push   %eax
c0101611:	e8 17 ff ff ff       	call   c010152d <cons_intr>
c0101616:	83 c4 10             	add    $0x10,%esp
    }
}
c0101619:	90                   	nop
c010161a:	c9                   	leave  
c010161b:	c3                   	ret    

c010161c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010161c:	55                   	push   %ebp
c010161d:	89 e5                	mov    %esp,%ebp
c010161f:	53                   	push   %ebx
c0101620:	83 ec 24             	sub    $0x24,%esp
c0101623:	e8 10 03 00 00       	call   c0101938 <__x86.get_pc_thunk.cx>
c0101628:	81 c1 48 63 01 00    	add    $0x16348,%ecx
c010162e:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101634:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101638:	89 c2                	mov    %eax,%edx
c010163a:	ec                   	in     (%dx),%al
c010163b:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010163e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101642:	0f b6 c0             	movzbl %al,%eax
c0101645:	83 e0 01             	and    $0x1,%eax
c0101648:	85 c0                	test   %eax,%eax
c010164a:	75 0a                	jne    c0101656 <kbd_proc_data+0x3a>
        return -1;
c010164c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101651:	e9 73 01 00 00       	jmp    c01017c9 <kbd_proc_data+0x1ad>
c0101656:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010165c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101660:	89 c2                	mov    %eax,%edx
c0101662:	ec                   	in     (%dx),%al
c0101663:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101666:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010166a:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010166d:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101671:	75 19                	jne    c010168c <kbd_proc_data+0x70>
        // E0 escape character
        shift |= E0ESC;
c0101673:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
c0101679:	83 c8 40             	or     $0x40,%eax
c010167c:	89 81 f8 07 00 00    	mov    %eax,0x7f8(%ecx)
        return 0;
c0101682:	b8 00 00 00 00       	mov    $0x0,%eax
c0101687:	e9 3d 01 00 00       	jmp    c01017c9 <kbd_proc_data+0x1ad>
    } else if (data & 0x80) {
c010168c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101690:	84 c0                	test   %al,%al
c0101692:	79 4b                	jns    c01016df <kbd_proc_data+0xc3>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101694:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
c010169a:	83 e0 40             	and    $0x40,%eax
c010169d:	85 c0                	test   %eax,%eax
c010169f:	75 09                	jne    c01016aa <kbd_proc_data+0x8e>
c01016a1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01016a5:	83 e0 7f             	and    $0x7f,%eax
c01016a8:	eb 04                	jmp    c01016ae <kbd_proc_data+0x92>
c01016aa:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01016ae:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01016b1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01016b5:	0f b6 84 01 b0 f6 ff 	movzbl -0x950(%ecx,%eax,1),%eax
c01016bc:	ff 
c01016bd:	83 c8 40             	or     $0x40,%eax
c01016c0:	0f b6 c0             	movzbl %al,%eax
c01016c3:	f7 d0                	not    %eax
c01016c5:	89 c2                	mov    %eax,%edx
c01016c7:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
c01016cd:	21 d0                	and    %edx,%eax
c01016cf:	89 81 f8 07 00 00    	mov    %eax,0x7f8(%ecx)
        return 0;
c01016d5:	b8 00 00 00 00       	mov    $0x0,%eax
c01016da:	e9 ea 00 00 00       	jmp    c01017c9 <kbd_proc_data+0x1ad>
    } else if (shift & E0ESC) {
c01016df:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
c01016e5:	83 e0 40             	and    $0x40,%eax
c01016e8:	85 c0                	test   %eax,%eax
c01016ea:	74 13                	je     c01016ff <kbd_proc_data+0xe3>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01016ec:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01016f0:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
c01016f6:	83 e0 bf             	and    $0xffffffbf,%eax
c01016f9:	89 81 f8 07 00 00    	mov    %eax,0x7f8(%ecx)
    }

    shift |= shiftcode[data];
c01016ff:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101703:	0f b6 84 01 b0 f6 ff 	movzbl -0x950(%ecx,%eax,1),%eax
c010170a:	ff 
c010170b:	0f b6 d0             	movzbl %al,%edx
c010170e:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
c0101714:	09 d0                	or     %edx,%eax
c0101716:	89 81 f8 07 00 00    	mov    %eax,0x7f8(%ecx)
    shift ^= togglecode[data];
c010171c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101720:	0f b6 84 01 b0 f7 ff 	movzbl -0x850(%ecx,%eax,1),%eax
c0101727:	ff 
c0101728:	0f b6 d0             	movzbl %al,%edx
c010172b:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
c0101731:	31 d0                	xor    %edx,%eax
c0101733:	89 81 f8 07 00 00    	mov    %eax,0x7f8(%ecx)

    c = charcode[shift & (CTL | SHIFT)][data];
c0101739:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
c010173f:	83 e0 03             	and    $0x3,%eax
c0101742:	8b 94 81 34 00 00 00 	mov    0x34(%ecx,%eax,4),%edx
c0101749:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010174d:	01 d0                	add    %edx,%eax
c010174f:	0f b6 00             	movzbl (%eax),%eax
c0101752:	0f b6 c0             	movzbl %al,%eax
c0101755:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101758:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
c010175e:	83 e0 08             	and    $0x8,%eax
c0101761:	85 c0                	test   %eax,%eax
c0101763:	74 22                	je     c0101787 <kbd_proc_data+0x16b>
        if ('a' <= c && c <= 'z')
c0101765:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101769:	7e 0c                	jle    c0101777 <kbd_proc_data+0x15b>
c010176b:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010176f:	7f 06                	jg     c0101777 <kbd_proc_data+0x15b>
            c += 'A' - 'a';
c0101771:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101775:	eb 10                	jmp    c0101787 <kbd_proc_data+0x16b>
        else if ('A' <= c && c <= 'Z')
c0101777:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010177b:	7e 0a                	jle    c0101787 <kbd_proc_data+0x16b>
c010177d:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101781:	7f 04                	jg     c0101787 <kbd_proc_data+0x16b>
            c += 'a' - 'A';
c0101783:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101787:	8b 81 f8 07 00 00    	mov    0x7f8(%ecx),%eax
c010178d:	f7 d0                	not    %eax
c010178f:	83 e0 06             	and    $0x6,%eax
c0101792:	85 c0                	test   %eax,%eax
c0101794:	75 30                	jne    c01017c6 <kbd_proc_data+0x1aa>
c0101796:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010179d:	75 27                	jne    c01017c6 <kbd_proc_data+0x1aa>
        cprintf("Rebooting!\n");
c010179f:	83 ec 0c             	sub    $0xc,%esp
c01017a2:	8d 81 cd ea fe ff    	lea    -0x11533(%ecx),%eax
c01017a8:	50                   	push   %eax
c01017a9:	89 cb                	mov    %ecx,%ebx
c01017ab:	e8 6d eb ff ff       	call   c010031d <cprintf>
c01017b0:	83 c4 10             	add    $0x10,%esp
c01017b3:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01017b9:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017bd:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01017c1:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01017c5:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01017c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01017c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01017cc:	c9                   	leave  
c01017cd:	c3                   	ret    

c01017ce <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01017ce:	55                   	push   %ebp
c01017cf:	89 e5                	mov    %esp,%ebp
c01017d1:	83 ec 08             	sub    $0x8,%esp
c01017d4:	e8 cd ea ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01017d9:	05 97 61 01 00       	add    $0x16197,%eax
    cons_intr(kbd_proc_data);
c01017de:	83 ec 0c             	sub    $0xc,%esp
c01017e1:	8d 80 ac 9c fe ff    	lea    -0x16354(%eax),%eax
c01017e7:	50                   	push   %eax
c01017e8:	e8 40 fd ff ff       	call   c010152d <cons_intr>
c01017ed:	83 c4 10             	add    $0x10,%esp
}
c01017f0:	90                   	nop
c01017f1:	c9                   	leave  
c01017f2:	c3                   	ret    

c01017f3 <kbd_init>:

static void
kbd_init(void) {
c01017f3:	55                   	push   %ebp
c01017f4:	89 e5                	mov    %esp,%ebp
c01017f6:	53                   	push   %ebx
c01017f7:	83 ec 04             	sub    $0x4,%esp
c01017fa:	e8 ab ea ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c01017ff:	81 c3 71 61 01 00    	add    $0x16171,%ebx
    // drain the kbd buffer
    kbd_intr();
c0101805:	e8 c4 ff ff ff       	call   c01017ce <kbd_intr>
    pic_enable(IRQ_KBD);
c010180a:	83 ec 0c             	sub    $0xc,%esp
c010180d:	6a 01                	push   $0x1
c010180f:	e8 8d 01 00 00       	call   c01019a1 <pic_enable>
c0101814:	83 c4 10             	add    $0x10,%esp
}
c0101817:	90                   	nop
c0101818:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010181b:	c9                   	leave  
c010181c:	c3                   	ret    

c010181d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c010181d:	55                   	push   %ebp
c010181e:	89 e5                	mov    %esp,%ebp
c0101820:	53                   	push   %ebx
c0101821:	83 ec 04             	sub    $0x4,%esp
c0101824:	e8 81 ea ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0101829:	81 c3 47 61 01 00    	add    $0x16147,%ebx
    cga_init();
c010182f:	e8 b4 f7 ff ff       	call   c0100fe8 <cga_init>
    serial_init();
c0101834:	e8 a3 f8 ff ff       	call   c01010dc <serial_init>
    kbd_init();
c0101839:	e8 b5 ff ff ff       	call   c01017f3 <kbd_init>
    if (!serial_exists) {
c010183e:	8b 83 d8 05 00 00    	mov    0x5d8(%ebx),%eax
c0101844:	85 c0                	test   %eax,%eax
c0101846:	75 12                	jne    c010185a <cons_init+0x3d>
        cprintf("serial port does not exist!!\n");
c0101848:	83 ec 0c             	sub    $0xc,%esp
c010184b:	8d 83 d9 ea fe ff    	lea    -0x11527(%ebx),%eax
c0101851:	50                   	push   %eax
c0101852:	e8 c6 ea ff ff       	call   c010031d <cprintf>
c0101857:	83 c4 10             	add    $0x10,%esp
    }
}
c010185a:	90                   	nop
c010185b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010185e:	c9                   	leave  
c010185f:	c3                   	ret    

c0101860 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101860:	55                   	push   %ebp
c0101861:	89 e5                	mov    %esp,%ebp
c0101863:	83 ec 18             	sub    $0x18,%esp
c0101866:	e8 3b ea ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c010186b:	05 05 61 01 00       	add    $0x16105,%eax
    bool intr_flag;
    local_intr_save(intr_flag);
c0101870:	e8 bf f6 ff ff       	call   c0100f34 <__intr_save>
c0101875:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101878:	83 ec 0c             	sub    $0xc,%esp
c010187b:	ff 75 08             	pushl  0x8(%ebp)
c010187e:	e8 d5 f9 ff ff       	call   c0101258 <lpt_putc>
c0101883:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c0101886:	83 ec 0c             	sub    $0xc,%esp
c0101889:	ff 75 08             	pushl  0x8(%ebp)
c010188c:	e8 08 fa ff ff       	call   c0101299 <cga_putc>
c0101891:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c0101894:	83 ec 0c             	sub    $0xc,%esp
c0101897:	ff 75 08             	pushl  0x8(%ebp)
c010189a:	e8 4d fc ff ff       	call   c01014ec <serial_putc>
c010189f:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c01018a2:	83 ec 0c             	sub    $0xc,%esp
c01018a5:	ff 75 f4             	pushl  -0xc(%ebp)
c01018a8:	e8 c3 f6 ff ff       	call   c0100f70 <__intr_restore>
c01018ad:	83 c4 10             	add    $0x10,%esp
}
c01018b0:	90                   	nop
c01018b1:	c9                   	leave  
c01018b2:	c3                   	ret    

c01018b3 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01018b3:	55                   	push   %ebp
c01018b4:	89 e5                	mov    %esp,%ebp
c01018b6:	53                   	push   %ebx
c01018b7:	83 ec 14             	sub    $0x14,%esp
c01018ba:	e8 eb e9 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c01018bf:	81 c3 b1 60 01 00    	add    $0x160b1,%ebx
    int c = 0;
c01018c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01018cc:	e8 63 f6 ff ff       	call   c0100f34 <__intr_save>
c01018d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01018d4:	e8 14 fd ff ff       	call   c01015ed <serial_intr>
        kbd_intr();
c01018d9:	e8 f0 fe ff ff       	call   c01017ce <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01018de:	8b 93 f0 07 00 00    	mov    0x7f0(%ebx),%edx
c01018e4:	8b 83 f4 07 00 00    	mov    0x7f4(%ebx),%eax
c01018ea:	39 c2                	cmp    %eax,%edx
c01018ec:	74 34                	je     c0101922 <cons_getc+0x6f>
            c = cons.buf[cons.rpos ++];
c01018ee:	8b 83 f0 07 00 00    	mov    0x7f0(%ebx),%eax
c01018f4:	8d 50 01             	lea    0x1(%eax),%edx
c01018f7:	89 93 f0 07 00 00    	mov    %edx,0x7f0(%ebx)
c01018fd:	0f b6 84 03 f0 05 00 	movzbl 0x5f0(%ebx,%eax,1),%eax
c0101904:	00 
c0101905:	0f b6 c0             	movzbl %al,%eax
c0101908:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010190b:	8b 83 f0 07 00 00    	mov    0x7f0(%ebx),%eax
c0101911:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101916:	75 0a                	jne    c0101922 <cons_getc+0x6f>
                cons.rpos = 0;
c0101918:	c7 83 f0 07 00 00 00 	movl   $0x0,0x7f0(%ebx)
c010191f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101922:	83 ec 0c             	sub    $0xc,%esp
c0101925:	ff 75 f0             	pushl  -0x10(%ebp)
c0101928:	e8 43 f6 ff ff       	call   c0100f70 <__intr_restore>
c010192d:	83 c4 10             	add    $0x10,%esp
    return c;
c0101930:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101933:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101936:	c9                   	leave  
c0101937:	c3                   	ret    

c0101938 <__x86.get_pc_thunk.cx>:
c0101938:	8b 0c 24             	mov    (%esp),%ecx
c010193b:	c3                   	ret    

c010193c <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c010193c:	55                   	push   %ebp
c010193d:	89 e5                	mov    %esp,%ebp
c010193f:	83 ec 14             	sub    $0x14,%esp
c0101942:	e8 5f e9 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0101947:	05 29 60 01 00       	add    $0x16029,%eax
c010194c:	8b 55 08             	mov    0x8(%ebp),%edx
c010194f:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
    irq_mask = mask;
c0101953:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0101957:	66 89 90 b0 fb ff ff 	mov    %dx,-0x450(%eax)
    if (did_init) {
c010195e:	8b 80 fc 07 00 00    	mov    0x7fc(%eax),%eax
c0101964:	85 c0                	test   %eax,%eax
c0101966:	74 36                	je     c010199e <pic_setmask+0x62>
        outb(IO_PIC1 + 1, mask);
c0101968:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010196c:	0f b6 c0             	movzbl %al,%eax
c010196f:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101975:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101978:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010197c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101980:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101981:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101985:	66 c1 e8 08          	shr    $0x8,%ax
c0101989:	0f b6 c0             	movzbl %al,%eax
c010198c:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101992:	88 45 fd             	mov    %al,-0x3(%ebp)
c0101995:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101999:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010199d:	ee                   	out    %al,(%dx)
    }
}
c010199e:	90                   	nop
c010199f:	c9                   	leave  
c01019a0:	c3                   	ret    

c01019a1 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01019a1:	55                   	push   %ebp
c01019a2:	89 e5                	mov    %esp,%ebp
c01019a4:	53                   	push   %ebx
c01019a5:	e8 fc e8 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01019aa:	05 c6 5f 01 00       	add    $0x15fc6,%eax
    pic_setmask(irq_mask & ~(1 << irq));
c01019af:	8b 55 08             	mov    0x8(%ebp),%edx
c01019b2:	bb 01 00 00 00       	mov    $0x1,%ebx
c01019b7:	89 d1                	mov    %edx,%ecx
c01019b9:	d3 e3                	shl    %cl,%ebx
c01019bb:	89 da                	mov    %ebx,%edx
c01019bd:	f7 d2                	not    %edx
c01019bf:	0f b7 80 b0 fb ff ff 	movzwl -0x450(%eax),%eax
c01019c6:	21 d0                	and    %edx,%eax
c01019c8:	0f b7 c0             	movzwl %ax,%eax
c01019cb:	50                   	push   %eax
c01019cc:	e8 6b ff ff ff       	call   c010193c <pic_setmask>
c01019d1:	83 c4 04             	add    $0x4,%esp
}
c01019d4:	90                   	nop
c01019d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01019d8:	c9                   	leave  
c01019d9:	c3                   	ret    

c01019da <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01019da:	55                   	push   %ebp
c01019db:	89 e5                	mov    %esp,%ebp
c01019dd:	83 ec 40             	sub    $0x40,%esp
c01019e0:	e8 53 ff ff ff       	call   c0101938 <__x86.get_pc_thunk.cx>
c01019e5:	81 c1 8b 5f 01 00    	add    $0x15f8b,%ecx
    did_init = 1;
c01019eb:	c7 81 fc 07 00 00 01 	movl   $0x1,0x7fc(%ecx)
c01019f2:	00 00 00 
c01019f5:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c01019fb:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
c01019ff:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101a03:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101a07:	ee                   	out    %al,(%dx)
c0101a08:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101a0e:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
c0101a12:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101a16:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101a1a:	ee                   	out    %al,(%dx)
c0101a1b:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101a21:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
c0101a25:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101a29:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101a2d:	ee                   	out    %al,(%dx)
c0101a2e:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101a34:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101a38:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101a3c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101a40:	ee                   	out    %al,(%dx)
c0101a41:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101a47:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
c0101a4b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101a4f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101a53:	ee                   	out    %al,(%dx)
c0101a54:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c0101a5a:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
c0101a5e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101a62:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101a66:	ee                   	out    %al,(%dx)
c0101a67:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c0101a6d:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
c0101a71:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101a75:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101a79:	ee                   	out    %al,(%dx)
c0101a7a:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c0101a80:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
c0101a84:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101a88:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101a8c:	ee                   	out    %al,(%dx)
c0101a8d:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c0101a93:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
c0101a97:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101a9b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101a9f:	ee                   	out    %al,(%dx)
c0101aa0:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0101aa6:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
c0101aaa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101aae:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ab2:	ee                   	out    %al,(%dx)
c0101ab3:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101ab9:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
c0101abd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101ac1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ac5:	ee                   	out    %al,(%dx)
c0101ac6:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101acc:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
c0101ad0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101ad4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101ad8:	ee                   	out    %al,(%dx)
c0101ad9:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0101adf:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
c0101ae3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101ae7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101aeb:	ee                   	out    %al,(%dx)
c0101aec:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101af2:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
c0101af6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101afa:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101afe:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101aff:	0f b7 81 b0 fb ff ff 	movzwl -0x450(%ecx),%eax
c0101b06:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101b0a:	74 13                	je     c0101b1f <pic_init+0x145>
        pic_setmask(irq_mask);
c0101b0c:	0f b7 81 b0 fb ff ff 	movzwl -0x450(%ecx),%eax
c0101b13:	0f b7 c0             	movzwl %ax,%eax
c0101b16:	50                   	push   %eax
c0101b17:	e8 20 fe ff ff       	call   c010193c <pic_setmask>
c0101b1c:	83 c4 04             	add    $0x4,%esp
    }
}
c0101b1f:	90                   	nop
c0101b20:	c9                   	leave  
c0101b21:	c3                   	ret    

c0101b22 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101b22:	55                   	push   %ebp
c0101b23:	89 e5                	mov    %esp,%ebp
c0101b25:	e8 7c e7 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0101b2a:	05 46 5e 01 00       	add    $0x15e46,%eax
    asm volatile ("sti");
c0101b2f:	fb                   	sti    
    sti();
}
c0101b30:	90                   	nop
c0101b31:	5d                   	pop    %ebp
c0101b32:	c3                   	ret    

c0101b33 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101b33:	55                   	push   %ebp
c0101b34:	89 e5                	mov    %esp,%ebp
c0101b36:	e8 6b e7 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0101b3b:	05 35 5e 01 00       	add    $0x15e35,%eax
    asm volatile ("cli" ::: "memory");
c0101b40:	fa                   	cli    
    cli();
}
c0101b41:	90                   	nop
c0101b42:	5d                   	pop    %ebp
c0101b43:	c3                   	ret    

c0101b44 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101b44:	55                   	push   %ebp
c0101b45:	89 e5                	mov    %esp,%ebp
c0101b47:	53                   	push   %ebx
c0101b48:	83 ec 04             	sub    $0x4,%esp
c0101b4b:	e8 56 e7 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0101b50:	05 20 5e 01 00       	add    $0x15e20,%eax
    cprintf("%d ticks\n",TICK_NUM);
c0101b55:	83 ec 08             	sub    $0x8,%esp
c0101b58:	6a 64                	push   $0x64
c0101b5a:	8d 90 f7 ea fe ff    	lea    -0x11509(%eax),%edx
c0101b60:	52                   	push   %edx
c0101b61:	89 c3                	mov    %eax,%ebx
c0101b63:	e8 b5 e7 ff ff       	call   c010031d <cprintf>
c0101b68:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101b6b:	90                   	nop
c0101b6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101b6f:	c9                   	leave  
c0101b70:	c3                   	ret    

c0101b71 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101b71:	55                   	push   %ebp
c0101b72:	89 e5                	mov    %esp,%ebp
c0101b74:	e8 2d e7 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0101b79:	05 f7 5d 01 00       	add    $0x15df7,%eax
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
c0101b7e:	90                   	nop
c0101b7f:	5d                   	pop    %ebp
c0101b80:	c3                   	ret    

c0101b81 <trapname>:

static const char *
trapname(int trapno) {
c0101b81:	55                   	push   %ebp
c0101b82:	89 e5                	mov    %esp,%ebp
c0101b84:	e8 1d e7 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0101b89:	05 e7 5d 01 00       	add    $0x15de7,%eax
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101b8e:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b91:	83 fa 13             	cmp    $0x13,%edx
c0101b94:	77 0c                	ja     c0101ba2 <trapname+0x21>
        return excnames[trapno];
c0101b96:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b99:	8b 84 90 f0 00 00 00 	mov    0xf0(%eax,%edx,4),%eax
c0101ba0:	eb 1a                	jmp    c0101bbc <trapname+0x3b>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101ba2:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101ba6:	7e 0e                	jle    c0101bb6 <trapname+0x35>
c0101ba8:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101bac:	7f 08                	jg     c0101bb6 <trapname+0x35>
        return "Hardware Interrupt";
c0101bae:	8d 80 01 eb fe ff    	lea    -0x114ff(%eax),%eax
c0101bb4:	eb 06                	jmp    c0101bbc <trapname+0x3b>
    }
    return "(unknown trap)";
c0101bb6:	8d 80 14 eb fe ff    	lea    -0x114ec(%eax),%eax
}
c0101bbc:	5d                   	pop    %ebp
c0101bbd:	c3                   	ret    

c0101bbe <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101bbe:	55                   	push   %ebp
c0101bbf:	89 e5                	mov    %esp,%ebp
c0101bc1:	e8 e0 e6 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0101bc6:	05 aa 5d 01 00       	add    $0x15daa,%eax
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bce:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bd2:	66 83 f8 08          	cmp    $0x8,%ax
c0101bd6:	0f 94 c0             	sete   %al
c0101bd9:	0f b6 c0             	movzbl %al,%eax
}
c0101bdc:	5d                   	pop    %ebp
c0101bdd:	c3                   	ret    

c0101bde <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101bde:	55                   	push   %ebp
c0101bdf:	89 e5                	mov    %esp,%ebp
c0101be1:	53                   	push   %ebx
c0101be2:	83 ec 14             	sub    $0x14,%esp
c0101be5:	e8 c0 e6 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0101bea:	81 c3 86 5d 01 00    	add    $0x15d86,%ebx
    cprintf("trapframe at %p\n", tf);
c0101bf0:	83 ec 08             	sub    $0x8,%esp
c0101bf3:	ff 75 08             	pushl  0x8(%ebp)
c0101bf6:	8d 83 55 eb fe ff    	lea    -0x114ab(%ebx),%eax
c0101bfc:	50                   	push   %eax
c0101bfd:	e8 1b e7 ff ff       	call   c010031d <cprintf>
c0101c02:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c08:	83 ec 0c             	sub    $0xc,%esp
c0101c0b:	50                   	push   %eax
c0101c0c:	e8 d3 01 00 00       	call   c0101de4 <print_regs>
c0101c11:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101c14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c17:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101c1b:	0f b7 c0             	movzwl %ax,%eax
c0101c1e:	83 ec 08             	sub    $0x8,%esp
c0101c21:	50                   	push   %eax
c0101c22:	8d 83 66 eb fe ff    	lea    -0x1149a(%ebx),%eax
c0101c28:	50                   	push   %eax
c0101c29:	e8 ef e6 ff ff       	call   c010031d <cprintf>
c0101c2e:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101c31:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c34:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101c38:	0f b7 c0             	movzwl %ax,%eax
c0101c3b:	83 ec 08             	sub    $0x8,%esp
c0101c3e:	50                   	push   %eax
c0101c3f:	8d 83 79 eb fe ff    	lea    -0x11487(%ebx),%eax
c0101c45:	50                   	push   %eax
c0101c46:	e8 d2 e6 ff ff       	call   c010031d <cprintf>
c0101c4b:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101c4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c51:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101c55:	0f b7 c0             	movzwl %ax,%eax
c0101c58:	83 ec 08             	sub    $0x8,%esp
c0101c5b:	50                   	push   %eax
c0101c5c:	8d 83 8c eb fe ff    	lea    -0x11474(%ebx),%eax
c0101c62:	50                   	push   %eax
c0101c63:	e8 b5 e6 ff ff       	call   c010031d <cprintf>
c0101c68:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6e:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101c72:	0f b7 c0             	movzwl %ax,%eax
c0101c75:	83 ec 08             	sub    $0x8,%esp
c0101c78:	50                   	push   %eax
c0101c79:	8d 83 9f eb fe ff    	lea    -0x11461(%ebx),%eax
c0101c7f:	50                   	push   %eax
c0101c80:	e8 98 e6 ff ff       	call   c010031d <cprintf>
c0101c85:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101c88:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8b:	8b 40 30             	mov    0x30(%eax),%eax
c0101c8e:	83 ec 0c             	sub    $0xc,%esp
c0101c91:	50                   	push   %eax
c0101c92:	e8 ea fe ff ff       	call   c0101b81 <trapname>
c0101c97:	83 c4 10             	add    $0x10,%esp
c0101c9a:	89 c2                	mov    %eax,%edx
c0101c9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c9f:	8b 40 30             	mov    0x30(%eax),%eax
c0101ca2:	83 ec 04             	sub    $0x4,%esp
c0101ca5:	52                   	push   %edx
c0101ca6:	50                   	push   %eax
c0101ca7:	8d 83 b2 eb fe ff    	lea    -0x1144e(%ebx),%eax
c0101cad:	50                   	push   %eax
c0101cae:	e8 6a e6 ff ff       	call   c010031d <cprintf>
c0101cb3:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb9:	8b 40 34             	mov    0x34(%eax),%eax
c0101cbc:	83 ec 08             	sub    $0x8,%esp
c0101cbf:	50                   	push   %eax
c0101cc0:	8d 83 c4 eb fe ff    	lea    -0x1143c(%ebx),%eax
c0101cc6:	50                   	push   %eax
c0101cc7:	e8 51 e6 ff ff       	call   c010031d <cprintf>
c0101ccc:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101ccf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd2:	8b 40 38             	mov    0x38(%eax),%eax
c0101cd5:	83 ec 08             	sub    $0x8,%esp
c0101cd8:	50                   	push   %eax
c0101cd9:	8d 83 d3 eb fe ff    	lea    -0x1142d(%ebx),%eax
c0101cdf:	50                   	push   %eax
c0101ce0:	e8 38 e6 ff ff       	call   c010031d <cprintf>
c0101ce5:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101ce8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ceb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101cef:	0f b7 c0             	movzwl %ax,%eax
c0101cf2:	83 ec 08             	sub    $0x8,%esp
c0101cf5:	50                   	push   %eax
c0101cf6:	8d 83 e2 eb fe ff    	lea    -0x1141e(%ebx),%eax
c0101cfc:	50                   	push   %eax
c0101cfd:	e8 1b e6 ff ff       	call   c010031d <cprintf>
c0101d02:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101d05:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d08:	8b 40 40             	mov    0x40(%eax),%eax
c0101d0b:	83 ec 08             	sub    $0x8,%esp
c0101d0e:	50                   	push   %eax
c0101d0f:	8d 83 f5 eb fe ff    	lea    -0x1140b(%ebx),%eax
c0101d15:	50                   	push   %eax
c0101d16:	e8 02 e6 ff ff       	call   c010031d <cprintf>
c0101d1b:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101d1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101d25:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101d2c:	eb 41                	jmp    c0101d6f <print_trapframe+0x191>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101d2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d31:	8b 50 40             	mov    0x40(%eax),%edx
c0101d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d37:	21 d0                	and    %edx,%eax
c0101d39:	85 c0                	test   %eax,%eax
c0101d3b:	74 2b                	je     c0101d68 <print_trapframe+0x18a>
c0101d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d40:	8b 84 83 70 00 00 00 	mov    0x70(%ebx,%eax,4),%eax
c0101d47:	85 c0                	test   %eax,%eax
c0101d49:	74 1d                	je     c0101d68 <print_trapframe+0x18a>
            cprintf("%s,", IA32flags[i]);
c0101d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d4e:	8b 84 83 70 00 00 00 	mov    0x70(%ebx,%eax,4),%eax
c0101d55:	83 ec 08             	sub    $0x8,%esp
c0101d58:	50                   	push   %eax
c0101d59:	8d 83 04 ec fe ff    	lea    -0x113fc(%ebx),%eax
c0101d5f:	50                   	push   %eax
c0101d60:	e8 b8 e5 ff ff       	call   c010031d <cprintf>
c0101d65:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101d68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101d6c:	d1 65 f0             	shll   -0x10(%ebp)
c0101d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d72:	83 f8 17             	cmp    $0x17,%eax
c0101d75:	76 b7                	jbe    c0101d2e <print_trapframe+0x150>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101d77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d7a:	8b 40 40             	mov    0x40(%eax),%eax
c0101d7d:	c1 e8 0c             	shr    $0xc,%eax
c0101d80:	83 e0 03             	and    $0x3,%eax
c0101d83:	83 ec 08             	sub    $0x8,%esp
c0101d86:	50                   	push   %eax
c0101d87:	8d 83 08 ec fe ff    	lea    -0x113f8(%ebx),%eax
c0101d8d:	50                   	push   %eax
c0101d8e:	e8 8a e5 ff ff       	call   c010031d <cprintf>
c0101d93:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101d96:	83 ec 0c             	sub    $0xc,%esp
c0101d99:	ff 75 08             	pushl  0x8(%ebp)
c0101d9c:	e8 1d fe ff ff       	call   c0101bbe <trap_in_kernel>
c0101da1:	83 c4 10             	add    $0x10,%esp
c0101da4:	85 c0                	test   %eax,%eax
c0101da6:	75 36                	jne    c0101dde <print_trapframe+0x200>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101da8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dab:	8b 40 44             	mov    0x44(%eax),%eax
c0101dae:	83 ec 08             	sub    $0x8,%esp
c0101db1:	50                   	push   %eax
c0101db2:	8d 83 11 ec fe ff    	lea    -0x113ef(%ebx),%eax
c0101db8:	50                   	push   %eax
c0101db9:	e8 5f e5 ff ff       	call   c010031d <cprintf>
c0101dbe:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101dc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dc4:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101dc8:	0f b7 c0             	movzwl %ax,%eax
c0101dcb:	83 ec 08             	sub    $0x8,%esp
c0101dce:	50                   	push   %eax
c0101dcf:	8d 83 20 ec fe ff    	lea    -0x113e0(%ebx),%eax
c0101dd5:	50                   	push   %eax
c0101dd6:	e8 42 e5 ff ff       	call   c010031d <cprintf>
c0101ddb:	83 c4 10             	add    $0x10,%esp
    }
}
c0101dde:	90                   	nop
c0101ddf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101de2:	c9                   	leave  
c0101de3:	c3                   	ret    

c0101de4 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101de4:	55                   	push   %ebp
c0101de5:	89 e5                	mov    %esp,%ebp
c0101de7:	53                   	push   %ebx
c0101de8:	83 ec 04             	sub    $0x4,%esp
c0101deb:	e8 ba e4 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0101df0:	81 c3 80 5b 01 00    	add    $0x15b80,%ebx
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101df6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df9:	8b 00                	mov    (%eax),%eax
c0101dfb:	83 ec 08             	sub    $0x8,%esp
c0101dfe:	50                   	push   %eax
c0101dff:	8d 83 33 ec fe ff    	lea    -0x113cd(%ebx),%eax
c0101e05:	50                   	push   %eax
c0101e06:	e8 12 e5 ff ff       	call   c010031d <cprintf>
c0101e0b:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101e0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e11:	8b 40 04             	mov    0x4(%eax),%eax
c0101e14:	83 ec 08             	sub    $0x8,%esp
c0101e17:	50                   	push   %eax
c0101e18:	8d 83 42 ec fe ff    	lea    -0x113be(%ebx),%eax
c0101e1e:	50                   	push   %eax
c0101e1f:	e8 f9 e4 ff ff       	call   c010031d <cprintf>
c0101e24:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101e27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e2a:	8b 40 08             	mov    0x8(%eax),%eax
c0101e2d:	83 ec 08             	sub    $0x8,%esp
c0101e30:	50                   	push   %eax
c0101e31:	8d 83 51 ec fe ff    	lea    -0x113af(%ebx),%eax
c0101e37:	50                   	push   %eax
c0101e38:	e8 e0 e4 ff ff       	call   c010031d <cprintf>
c0101e3d:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e43:	8b 40 0c             	mov    0xc(%eax),%eax
c0101e46:	83 ec 08             	sub    $0x8,%esp
c0101e49:	50                   	push   %eax
c0101e4a:	8d 83 60 ec fe ff    	lea    -0x113a0(%ebx),%eax
c0101e50:	50                   	push   %eax
c0101e51:	e8 c7 e4 ff ff       	call   c010031d <cprintf>
c0101e56:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101e59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e5c:	8b 40 10             	mov    0x10(%eax),%eax
c0101e5f:	83 ec 08             	sub    $0x8,%esp
c0101e62:	50                   	push   %eax
c0101e63:	8d 83 6f ec fe ff    	lea    -0x11391(%ebx),%eax
c0101e69:	50                   	push   %eax
c0101e6a:	e8 ae e4 ff ff       	call   c010031d <cprintf>
c0101e6f:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101e72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e75:	8b 40 14             	mov    0x14(%eax),%eax
c0101e78:	83 ec 08             	sub    $0x8,%esp
c0101e7b:	50                   	push   %eax
c0101e7c:	8d 83 7e ec fe ff    	lea    -0x11382(%ebx),%eax
c0101e82:	50                   	push   %eax
c0101e83:	e8 95 e4 ff ff       	call   c010031d <cprintf>
c0101e88:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8e:	8b 40 18             	mov    0x18(%eax),%eax
c0101e91:	83 ec 08             	sub    $0x8,%esp
c0101e94:	50                   	push   %eax
c0101e95:	8d 83 8d ec fe ff    	lea    -0x11373(%ebx),%eax
c0101e9b:	50                   	push   %eax
c0101e9c:	e8 7c e4 ff ff       	call   c010031d <cprintf>
c0101ea1:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ea4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea7:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101eaa:	83 ec 08             	sub    $0x8,%esp
c0101ead:	50                   	push   %eax
c0101eae:	8d 83 9c ec fe ff    	lea    -0x11364(%ebx),%eax
c0101eb4:	50                   	push   %eax
c0101eb5:	e8 63 e4 ff ff       	call   c010031d <cprintf>
c0101eba:	83 c4 10             	add    $0x10,%esp
}
c0101ebd:	90                   	nop
c0101ebe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101ec1:	c9                   	leave  
c0101ec2:	c3                   	ret    

c0101ec3 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101ec3:	55                   	push   %ebp
c0101ec4:	89 e5                	mov    %esp,%ebp
c0101ec6:	53                   	push   %ebx
c0101ec7:	83 ec 14             	sub    $0x14,%esp
c0101eca:	e8 db e3 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0101ecf:	81 c3 a1 5a 01 00    	add    $0x15aa1,%ebx
    char c;

    switch (tf->tf_trapno) {
c0101ed5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed8:	8b 40 30             	mov    0x30(%eax),%eax
c0101edb:	83 f8 2f             	cmp    $0x2f,%eax
c0101ede:	77 1e                	ja     c0101efe <trap_dispatch+0x3b>
c0101ee0:	83 f8 2e             	cmp    $0x2e,%eax
c0101ee3:	0f 83 c0 00 00 00    	jae    c0101fa9 <trap_dispatch+0xe6>
c0101ee9:	83 f8 21             	cmp    $0x21,%eax
c0101eec:	74 40                	je     c0101f2e <trap_dispatch+0x6b>
c0101eee:	83 f8 24             	cmp    $0x24,%eax
c0101ef1:	74 15                	je     c0101f08 <trap_dispatch+0x45>
c0101ef3:	83 f8 20             	cmp    $0x20,%eax
c0101ef6:	0f 84 b0 00 00 00    	je     c0101fac <trap_dispatch+0xe9>
c0101efc:	eb 71                	jmp    c0101f6f <trap_dispatch+0xac>
c0101efe:	83 e8 78             	sub    $0x78,%eax
c0101f01:	83 f8 01             	cmp    $0x1,%eax
c0101f04:	77 69                	ja     c0101f6f <trap_dispatch+0xac>
c0101f06:	eb 4c                	jmp    c0101f54 <trap_dispatch+0x91>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101f08:	e8 a6 f9 ff ff       	call   c01018b3 <cons_getc>
c0101f0d:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101f10:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101f14:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101f18:	83 ec 04             	sub    $0x4,%esp
c0101f1b:	52                   	push   %edx
c0101f1c:	50                   	push   %eax
c0101f1d:	8d 83 ab ec fe ff    	lea    -0x11355(%ebx),%eax
c0101f23:	50                   	push   %eax
c0101f24:	e8 f4 e3 ff ff       	call   c010031d <cprintf>
c0101f29:	83 c4 10             	add    $0x10,%esp
        break;
c0101f2c:	eb 7f                	jmp    c0101fad <trap_dispatch+0xea>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101f2e:	e8 80 f9 ff ff       	call   c01018b3 <cons_getc>
c0101f33:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101f36:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101f3a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101f3e:	83 ec 04             	sub    $0x4,%esp
c0101f41:	52                   	push   %edx
c0101f42:	50                   	push   %eax
c0101f43:	8d 83 bd ec fe ff    	lea    -0x11343(%ebx),%eax
c0101f49:	50                   	push   %eax
c0101f4a:	e8 ce e3 ff ff       	call   c010031d <cprintf>
c0101f4f:	83 c4 10             	add    $0x10,%esp
        break;
c0101f52:	eb 59                	jmp    c0101fad <trap_dispatch+0xea>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101f54:	83 ec 04             	sub    $0x4,%esp
c0101f57:	8d 83 cc ec fe ff    	lea    -0x11334(%ebx),%eax
c0101f5d:	50                   	push   %eax
c0101f5e:	68 a2 00 00 00       	push   $0xa2
c0101f63:	8d 83 dc ec fe ff    	lea    -0x11324(%ebx),%eax
c0101f69:	50                   	push   %eax
c0101f6a:	e8 5e e5 ff ff       	call   c01004cd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101f6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f72:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f76:	0f b7 c0             	movzwl %ax,%eax
c0101f79:	83 e0 03             	and    $0x3,%eax
c0101f7c:	85 c0                	test   %eax,%eax
c0101f7e:	75 2d                	jne    c0101fad <trap_dispatch+0xea>
            print_trapframe(tf);
c0101f80:	83 ec 0c             	sub    $0xc,%esp
c0101f83:	ff 75 08             	pushl  0x8(%ebp)
c0101f86:	e8 53 fc ff ff       	call   c0101bde <print_trapframe>
c0101f8b:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101f8e:	83 ec 04             	sub    $0x4,%esp
c0101f91:	8d 83 ed ec fe ff    	lea    -0x11313(%ebx),%eax
c0101f97:	50                   	push   %eax
c0101f98:	68 ac 00 00 00       	push   $0xac
c0101f9d:	8d 83 dc ec fe ff    	lea    -0x11324(%ebx),%eax
c0101fa3:	50                   	push   %eax
c0101fa4:	e8 24 e5 ff ff       	call   c01004cd <__panic>
        break;
c0101fa9:	90                   	nop
c0101faa:	eb 01                	jmp    c0101fad <trap_dispatch+0xea>
        break;
c0101fac:	90                   	nop
        }
    }
}
c0101fad:	90                   	nop
c0101fae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101fb1:	c9                   	leave  
c0101fb2:	c3                   	ret    

c0101fb3 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101fb3:	55                   	push   %ebp
c0101fb4:	89 e5                	mov    %esp,%ebp
c0101fb6:	83 ec 08             	sub    $0x8,%esp
c0101fb9:	e8 e8 e2 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0101fbe:	05 b2 59 01 00       	add    $0x159b2,%eax
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101fc3:	83 ec 0c             	sub    $0xc,%esp
c0101fc6:	ff 75 08             	pushl  0x8(%ebp)
c0101fc9:	e8 f5 fe ff ff       	call   c0101ec3 <trap_dispatch>
c0101fce:	83 c4 10             	add    $0x10,%esp
}
c0101fd1:	90                   	nop
c0101fd2:	c9                   	leave  
c0101fd3:	c3                   	ret    

c0101fd4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101fd4:	6a 00                	push   $0x0
  pushl $0
c0101fd6:	6a 00                	push   $0x0
  jmp __alltraps
c0101fd8:	e9 67 0a 00 00       	jmp    c0102a44 <__alltraps>

c0101fdd <vector1>:
.globl vector1
vector1:
  pushl $0
c0101fdd:	6a 00                	push   $0x0
  pushl $1
c0101fdf:	6a 01                	push   $0x1
  jmp __alltraps
c0101fe1:	e9 5e 0a 00 00       	jmp    c0102a44 <__alltraps>

c0101fe6 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101fe6:	6a 00                	push   $0x0
  pushl $2
c0101fe8:	6a 02                	push   $0x2
  jmp __alltraps
c0101fea:	e9 55 0a 00 00       	jmp    c0102a44 <__alltraps>

c0101fef <vector3>:
.globl vector3
vector3:
  pushl $0
c0101fef:	6a 00                	push   $0x0
  pushl $3
c0101ff1:	6a 03                	push   $0x3
  jmp __alltraps
c0101ff3:	e9 4c 0a 00 00       	jmp    c0102a44 <__alltraps>

c0101ff8 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101ff8:	6a 00                	push   $0x0
  pushl $4
c0101ffa:	6a 04                	push   $0x4
  jmp __alltraps
c0101ffc:	e9 43 0a 00 00       	jmp    c0102a44 <__alltraps>

c0102001 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102001:	6a 00                	push   $0x0
  pushl $5
c0102003:	6a 05                	push   $0x5
  jmp __alltraps
c0102005:	e9 3a 0a 00 00       	jmp    c0102a44 <__alltraps>

c010200a <vector6>:
.globl vector6
vector6:
  pushl $0
c010200a:	6a 00                	push   $0x0
  pushl $6
c010200c:	6a 06                	push   $0x6
  jmp __alltraps
c010200e:	e9 31 0a 00 00       	jmp    c0102a44 <__alltraps>

c0102013 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102013:	6a 00                	push   $0x0
  pushl $7
c0102015:	6a 07                	push   $0x7
  jmp __alltraps
c0102017:	e9 28 0a 00 00       	jmp    c0102a44 <__alltraps>

c010201c <vector8>:
.globl vector8
vector8:
  pushl $8
c010201c:	6a 08                	push   $0x8
  jmp __alltraps
c010201e:	e9 21 0a 00 00       	jmp    c0102a44 <__alltraps>

c0102023 <vector9>:
.globl vector9
vector9:
  pushl $9
c0102023:	6a 09                	push   $0x9
  jmp __alltraps
c0102025:	e9 1a 0a 00 00       	jmp    c0102a44 <__alltraps>

c010202a <vector10>:
.globl vector10
vector10:
  pushl $10
c010202a:	6a 0a                	push   $0xa
  jmp __alltraps
c010202c:	e9 13 0a 00 00       	jmp    c0102a44 <__alltraps>

c0102031 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102031:	6a 0b                	push   $0xb
  jmp __alltraps
c0102033:	e9 0c 0a 00 00       	jmp    c0102a44 <__alltraps>

c0102038 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102038:	6a 0c                	push   $0xc
  jmp __alltraps
c010203a:	e9 05 0a 00 00       	jmp    c0102a44 <__alltraps>

c010203f <vector13>:
.globl vector13
vector13:
  pushl $13
c010203f:	6a 0d                	push   $0xd
  jmp __alltraps
c0102041:	e9 fe 09 00 00       	jmp    c0102a44 <__alltraps>

c0102046 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102046:	6a 0e                	push   $0xe
  jmp __alltraps
c0102048:	e9 f7 09 00 00       	jmp    c0102a44 <__alltraps>

c010204d <vector15>:
.globl vector15
vector15:
  pushl $0
c010204d:	6a 00                	push   $0x0
  pushl $15
c010204f:	6a 0f                	push   $0xf
  jmp __alltraps
c0102051:	e9 ee 09 00 00       	jmp    c0102a44 <__alltraps>

c0102056 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102056:	6a 00                	push   $0x0
  pushl $16
c0102058:	6a 10                	push   $0x10
  jmp __alltraps
c010205a:	e9 e5 09 00 00       	jmp    c0102a44 <__alltraps>

c010205f <vector17>:
.globl vector17
vector17:
  pushl $17
c010205f:	6a 11                	push   $0x11
  jmp __alltraps
c0102061:	e9 de 09 00 00       	jmp    c0102a44 <__alltraps>

c0102066 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102066:	6a 00                	push   $0x0
  pushl $18
c0102068:	6a 12                	push   $0x12
  jmp __alltraps
c010206a:	e9 d5 09 00 00       	jmp    c0102a44 <__alltraps>

c010206f <vector19>:
.globl vector19
vector19:
  pushl $0
c010206f:	6a 00                	push   $0x0
  pushl $19
c0102071:	6a 13                	push   $0x13
  jmp __alltraps
c0102073:	e9 cc 09 00 00       	jmp    c0102a44 <__alltraps>

c0102078 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102078:	6a 00                	push   $0x0
  pushl $20
c010207a:	6a 14                	push   $0x14
  jmp __alltraps
c010207c:	e9 c3 09 00 00       	jmp    c0102a44 <__alltraps>

c0102081 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102081:	6a 00                	push   $0x0
  pushl $21
c0102083:	6a 15                	push   $0x15
  jmp __alltraps
c0102085:	e9 ba 09 00 00       	jmp    c0102a44 <__alltraps>

c010208a <vector22>:
.globl vector22
vector22:
  pushl $0
c010208a:	6a 00                	push   $0x0
  pushl $22
c010208c:	6a 16                	push   $0x16
  jmp __alltraps
c010208e:	e9 b1 09 00 00       	jmp    c0102a44 <__alltraps>

c0102093 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102093:	6a 00                	push   $0x0
  pushl $23
c0102095:	6a 17                	push   $0x17
  jmp __alltraps
c0102097:	e9 a8 09 00 00       	jmp    c0102a44 <__alltraps>

c010209c <vector24>:
.globl vector24
vector24:
  pushl $0
c010209c:	6a 00                	push   $0x0
  pushl $24
c010209e:	6a 18                	push   $0x18
  jmp __alltraps
c01020a0:	e9 9f 09 00 00       	jmp    c0102a44 <__alltraps>

c01020a5 <vector25>:
.globl vector25
vector25:
  pushl $0
c01020a5:	6a 00                	push   $0x0
  pushl $25
c01020a7:	6a 19                	push   $0x19
  jmp __alltraps
c01020a9:	e9 96 09 00 00       	jmp    c0102a44 <__alltraps>

c01020ae <vector26>:
.globl vector26
vector26:
  pushl $0
c01020ae:	6a 00                	push   $0x0
  pushl $26
c01020b0:	6a 1a                	push   $0x1a
  jmp __alltraps
c01020b2:	e9 8d 09 00 00       	jmp    c0102a44 <__alltraps>

c01020b7 <vector27>:
.globl vector27
vector27:
  pushl $0
c01020b7:	6a 00                	push   $0x0
  pushl $27
c01020b9:	6a 1b                	push   $0x1b
  jmp __alltraps
c01020bb:	e9 84 09 00 00       	jmp    c0102a44 <__alltraps>

c01020c0 <vector28>:
.globl vector28
vector28:
  pushl $0
c01020c0:	6a 00                	push   $0x0
  pushl $28
c01020c2:	6a 1c                	push   $0x1c
  jmp __alltraps
c01020c4:	e9 7b 09 00 00       	jmp    c0102a44 <__alltraps>

c01020c9 <vector29>:
.globl vector29
vector29:
  pushl $0
c01020c9:	6a 00                	push   $0x0
  pushl $29
c01020cb:	6a 1d                	push   $0x1d
  jmp __alltraps
c01020cd:	e9 72 09 00 00       	jmp    c0102a44 <__alltraps>

c01020d2 <vector30>:
.globl vector30
vector30:
  pushl $0
c01020d2:	6a 00                	push   $0x0
  pushl $30
c01020d4:	6a 1e                	push   $0x1e
  jmp __alltraps
c01020d6:	e9 69 09 00 00       	jmp    c0102a44 <__alltraps>

c01020db <vector31>:
.globl vector31
vector31:
  pushl $0
c01020db:	6a 00                	push   $0x0
  pushl $31
c01020dd:	6a 1f                	push   $0x1f
  jmp __alltraps
c01020df:	e9 60 09 00 00       	jmp    c0102a44 <__alltraps>

c01020e4 <vector32>:
.globl vector32
vector32:
  pushl $0
c01020e4:	6a 00                	push   $0x0
  pushl $32
c01020e6:	6a 20                	push   $0x20
  jmp __alltraps
c01020e8:	e9 57 09 00 00       	jmp    c0102a44 <__alltraps>

c01020ed <vector33>:
.globl vector33
vector33:
  pushl $0
c01020ed:	6a 00                	push   $0x0
  pushl $33
c01020ef:	6a 21                	push   $0x21
  jmp __alltraps
c01020f1:	e9 4e 09 00 00       	jmp    c0102a44 <__alltraps>

c01020f6 <vector34>:
.globl vector34
vector34:
  pushl $0
c01020f6:	6a 00                	push   $0x0
  pushl $34
c01020f8:	6a 22                	push   $0x22
  jmp __alltraps
c01020fa:	e9 45 09 00 00       	jmp    c0102a44 <__alltraps>

c01020ff <vector35>:
.globl vector35
vector35:
  pushl $0
c01020ff:	6a 00                	push   $0x0
  pushl $35
c0102101:	6a 23                	push   $0x23
  jmp __alltraps
c0102103:	e9 3c 09 00 00       	jmp    c0102a44 <__alltraps>

c0102108 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102108:	6a 00                	push   $0x0
  pushl $36
c010210a:	6a 24                	push   $0x24
  jmp __alltraps
c010210c:	e9 33 09 00 00       	jmp    c0102a44 <__alltraps>

c0102111 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102111:	6a 00                	push   $0x0
  pushl $37
c0102113:	6a 25                	push   $0x25
  jmp __alltraps
c0102115:	e9 2a 09 00 00       	jmp    c0102a44 <__alltraps>

c010211a <vector38>:
.globl vector38
vector38:
  pushl $0
c010211a:	6a 00                	push   $0x0
  pushl $38
c010211c:	6a 26                	push   $0x26
  jmp __alltraps
c010211e:	e9 21 09 00 00       	jmp    c0102a44 <__alltraps>

c0102123 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102123:	6a 00                	push   $0x0
  pushl $39
c0102125:	6a 27                	push   $0x27
  jmp __alltraps
c0102127:	e9 18 09 00 00       	jmp    c0102a44 <__alltraps>

c010212c <vector40>:
.globl vector40
vector40:
  pushl $0
c010212c:	6a 00                	push   $0x0
  pushl $40
c010212e:	6a 28                	push   $0x28
  jmp __alltraps
c0102130:	e9 0f 09 00 00       	jmp    c0102a44 <__alltraps>

c0102135 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102135:	6a 00                	push   $0x0
  pushl $41
c0102137:	6a 29                	push   $0x29
  jmp __alltraps
c0102139:	e9 06 09 00 00       	jmp    c0102a44 <__alltraps>

c010213e <vector42>:
.globl vector42
vector42:
  pushl $0
c010213e:	6a 00                	push   $0x0
  pushl $42
c0102140:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102142:	e9 fd 08 00 00       	jmp    c0102a44 <__alltraps>

c0102147 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102147:	6a 00                	push   $0x0
  pushl $43
c0102149:	6a 2b                	push   $0x2b
  jmp __alltraps
c010214b:	e9 f4 08 00 00       	jmp    c0102a44 <__alltraps>

c0102150 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102150:	6a 00                	push   $0x0
  pushl $44
c0102152:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102154:	e9 eb 08 00 00       	jmp    c0102a44 <__alltraps>

c0102159 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102159:	6a 00                	push   $0x0
  pushl $45
c010215b:	6a 2d                	push   $0x2d
  jmp __alltraps
c010215d:	e9 e2 08 00 00       	jmp    c0102a44 <__alltraps>

c0102162 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102162:	6a 00                	push   $0x0
  pushl $46
c0102164:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102166:	e9 d9 08 00 00       	jmp    c0102a44 <__alltraps>

c010216b <vector47>:
.globl vector47
vector47:
  pushl $0
c010216b:	6a 00                	push   $0x0
  pushl $47
c010216d:	6a 2f                	push   $0x2f
  jmp __alltraps
c010216f:	e9 d0 08 00 00       	jmp    c0102a44 <__alltraps>

c0102174 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102174:	6a 00                	push   $0x0
  pushl $48
c0102176:	6a 30                	push   $0x30
  jmp __alltraps
c0102178:	e9 c7 08 00 00       	jmp    c0102a44 <__alltraps>

c010217d <vector49>:
.globl vector49
vector49:
  pushl $0
c010217d:	6a 00                	push   $0x0
  pushl $49
c010217f:	6a 31                	push   $0x31
  jmp __alltraps
c0102181:	e9 be 08 00 00       	jmp    c0102a44 <__alltraps>

c0102186 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102186:	6a 00                	push   $0x0
  pushl $50
c0102188:	6a 32                	push   $0x32
  jmp __alltraps
c010218a:	e9 b5 08 00 00       	jmp    c0102a44 <__alltraps>

c010218f <vector51>:
.globl vector51
vector51:
  pushl $0
c010218f:	6a 00                	push   $0x0
  pushl $51
c0102191:	6a 33                	push   $0x33
  jmp __alltraps
c0102193:	e9 ac 08 00 00       	jmp    c0102a44 <__alltraps>

c0102198 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102198:	6a 00                	push   $0x0
  pushl $52
c010219a:	6a 34                	push   $0x34
  jmp __alltraps
c010219c:	e9 a3 08 00 00       	jmp    c0102a44 <__alltraps>

c01021a1 <vector53>:
.globl vector53
vector53:
  pushl $0
c01021a1:	6a 00                	push   $0x0
  pushl $53
c01021a3:	6a 35                	push   $0x35
  jmp __alltraps
c01021a5:	e9 9a 08 00 00       	jmp    c0102a44 <__alltraps>

c01021aa <vector54>:
.globl vector54
vector54:
  pushl $0
c01021aa:	6a 00                	push   $0x0
  pushl $54
c01021ac:	6a 36                	push   $0x36
  jmp __alltraps
c01021ae:	e9 91 08 00 00       	jmp    c0102a44 <__alltraps>

c01021b3 <vector55>:
.globl vector55
vector55:
  pushl $0
c01021b3:	6a 00                	push   $0x0
  pushl $55
c01021b5:	6a 37                	push   $0x37
  jmp __alltraps
c01021b7:	e9 88 08 00 00       	jmp    c0102a44 <__alltraps>

c01021bc <vector56>:
.globl vector56
vector56:
  pushl $0
c01021bc:	6a 00                	push   $0x0
  pushl $56
c01021be:	6a 38                	push   $0x38
  jmp __alltraps
c01021c0:	e9 7f 08 00 00       	jmp    c0102a44 <__alltraps>

c01021c5 <vector57>:
.globl vector57
vector57:
  pushl $0
c01021c5:	6a 00                	push   $0x0
  pushl $57
c01021c7:	6a 39                	push   $0x39
  jmp __alltraps
c01021c9:	e9 76 08 00 00       	jmp    c0102a44 <__alltraps>

c01021ce <vector58>:
.globl vector58
vector58:
  pushl $0
c01021ce:	6a 00                	push   $0x0
  pushl $58
c01021d0:	6a 3a                	push   $0x3a
  jmp __alltraps
c01021d2:	e9 6d 08 00 00       	jmp    c0102a44 <__alltraps>

c01021d7 <vector59>:
.globl vector59
vector59:
  pushl $0
c01021d7:	6a 00                	push   $0x0
  pushl $59
c01021d9:	6a 3b                	push   $0x3b
  jmp __alltraps
c01021db:	e9 64 08 00 00       	jmp    c0102a44 <__alltraps>

c01021e0 <vector60>:
.globl vector60
vector60:
  pushl $0
c01021e0:	6a 00                	push   $0x0
  pushl $60
c01021e2:	6a 3c                	push   $0x3c
  jmp __alltraps
c01021e4:	e9 5b 08 00 00       	jmp    c0102a44 <__alltraps>

c01021e9 <vector61>:
.globl vector61
vector61:
  pushl $0
c01021e9:	6a 00                	push   $0x0
  pushl $61
c01021eb:	6a 3d                	push   $0x3d
  jmp __alltraps
c01021ed:	e9 52 08 00 00       	jmp    c0102a44 <__alltraps>

c01021f2 <vector62>:
.globl vector62
vector62:
  pushl $0
c01021f2:	6a 00                	push   $0x0
  pushl $62
c01021f4:	6a 3e                	push   $0x3e
  jmp __alltraps
c01021f6:	e9 49 08 00 00       	jmp    c0102a44 <__alltraps>

c01021fb <vector63>:
.globl vector63
vector63:
  pushl $0
c01021fb:	6a 00                	push   $0x0
  pushl $63
c01021fd:	6a 3f                	push   $0x3f
  jmp __alltraps
c01021ff:	e9 40 08 00 00       	jmp    c0102a44 <__alltraps>

c0102204 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102204:	6a 00                	push   $0x0
  pushl $64
c0102206:	6a 40                	push   $0x40
  jmp __alltraps
c0102208:	e9 37 08 00 00       	jmp    c0102a44 <__alltraps>

c010220d <vector65>:
.globl vector65
vector65:
  pushl $0
c010220d:	6a 00                	push   $0x0
  pushl $65
c010220f:	6a 41                	push   $0x41
  jmp __alltraps
c0102211:	e9 2e 08 00 00       	jmp    c0102a44 <__alltraps>

c0102216 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102216:	6a 00                	push   $0x0
  pushl $66
c0102218:	6a 42                	push   $0x42
  jmp __alltraps
c010221a:	e9 25 08 00 00       	jmp    c0102a44 <__alltraps>

c010221f <vector67>:
.globl vector67
vector67:
  pushl $0
c010221f:	6a 00                	push   $0x0
  pushl $67
c0102221:	6a 43                	push   $0x43
  jmp __alltraps
c0102223:	e9 1c 08 00 00       	jmp    c0102a44 <__alltraps>

c0102228 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102228:	6a 00                	push   $0x0
  pushl $68
c010222a:	6a 44                	push   $0x44
  jmp __alltraps
c010222c:	e9 13 08 00 00       	jmp    c0102a44 <__alltraps>

c0102231 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102231:	6a 00                	push   $0x0
  pushl $69
c0102233:	6a 45                	push   $0x45
  jmp __alltraps
c0102235:	e9 0a 08 00 00       	jmp    c0102a44 <__alltraps>

c010223a <vector70>:
.globl vector70
vector70:
  pushl $0
c010223a:	6a 00                	push   $0x0
  pushl $70
c010223c:	6a 46                	push   $0x46
  jmp __alltraps
c010223e:	e9 01 08 00 00       	jmp    c0102a44 <__alltraps>

c0102243 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102243:	6a 00                	push   $0x0
  pushl $71
c0102245:	6a 47                	push   $0x47
  jmp __alltraps
c0102247:	e9 f8 07 00 00       	jmp    c0102a44 <__alltraps>

c010224c <vector72>:
.globl vector72
vector72:
  pushl $0
c010224c:	6a 00                	push   $0x0
  pushl $72
c010224e:	6a 48                	push   $0x48
  jmp __alltraps
c0102250:	e9 ef 07 00 00       	jmp    c0102a44 <__alltraps>

c0102255 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102255:	6a 00                	push   $0x0
  pushl $73
c0102257:	6a 49                	push   $0x49
  jmp __alltraps
c0102259:	e9 e6 07 00 00       	jmp    c0102a44 <__alltraps>

c010225e <vector74>:
.globl vector74
vector74:
  pushl $0
c010225e:	6a 00                	push   $0x0
  pushl $74
c0102260:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102262:	e9 dd 07 00 00       	jmp    c0102a44 <__alltraps>

c0102267 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102267:	6a 00                	push   $0x0
  pushl $75
c0102269:	6a 4b                	push   $0x4b
  jmp __alltraps
c010226b:	e9 d4 07 00 00       	jmp    c0102a44 <__alltraps>

c0102270 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102270:	6a 00                	push   $0x0
  pushl $76
c0102272:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102274:	e9 cb 07 00 00       	jmp    c0102a44 <__alltraps>

c0102279 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102279:	6a 00                	push   $0x0
  pushl $77
c010227b:	6a 4d                	push   $0x4d
  jmp __alltraps
c010227d:	e9 c2 07 00 00       	jmp    c0102a44 <__alltraps>

c0102282 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102282:	6a 00                	push   $0x0
  pushl $78
c0102284:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102286:	e9 b9 07 00 00       	jmp    c0102a44 <__alltraps>

c010228b <vector79>:
.globl vector79
vector79:
  pushl $0
c010228b:	6a 00                	push   $0x0
  pushl $79
c010228d:	6a 4f                	push   $0x4f
  jmp __alltraps
c010228f:	e9 b0 07 00 00       	jmp    c0102a44 <__alltraps>

c0102294 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102294:	6a 00                	push   $0x0
  pushl $80
c0102296:	6a 50                	push   $0x50
  jmp __alltraps
c0102298:	e9 a7 07 00 00       	jmp    c0102a44 <__alltraps>

c010229d <vector81>:
.globl vector81
vector81:
  pushl $0
c010229d:	6a 00                	push   $0x0
  pushl $81
c010229f:	6a 51                	push   $0x51
  jmp __alltraps
c01022a1:	e9 9e 07 00 00       	jmp    c0102a44 <__alltraps>

c01022a6 <vector82>:
.globl vector82
vector82:
  pushl $0
c01022a6:	6a 00                	push   $0x0
  pushl $82
c01022a8:	6a 52                	push   $0x52
  jmp __alltraps
c01022aa:	e9 95 07 00 00       	jmp    c0102a44 <__alltraps>

c01022af <vector83>:
.globl vector83
vector83:
  pushl $0
c01022af:	6a 00                	push   $0x0
  pushl $83
c01022b1:	6a 53                	push   $0x53
  jmp __alltraps
c01022b3:	e9 8c 07 00 00       	jmp    c0102a44 <__alltraps>

c01022b8 <vector84>:
.globl vector84
vector84:
  pushl $0
c01022b8:	6a 00                	push   $0x0
  pushl $84
c01022ba:	6a 54                	push   $0x54
  jmp __alltraps
c01022bc:	e9 83 07 00 00       	jmp    c0102a44 <__alltraps>

c01022c1 <vector85>:
.globl vector85
vector85:
  pushl $0
c01022c1:	6a 00                	push   $0x0
  pushl $85
c01022c3:	6a 55                	push   $0x55
  jmp __alltraps
c01022c5:	e9 7a 07 00 00       	jmp    c0102a44 <__alltraps>

c01022ca <vector86>:
.globl vector86
vector86:
  pushl $0
c01022ca:	6a 00                	push   $0x0
  pushl $86
c01022cc:	6a 56                	push   $0x56
  jmp __alltraps
c01022ce:	e9 71 07 00 00       	jmp    c0102a44 <__alltraps>

c01022d3 <vector87>:
.globl vector87
vector87:
  pushl $0
c01022d3:	6a 00                	push   $0x0
  pushl $87
c01022d5:	6a 57                	push   $0x57
  jmp __alltraps
c01022d7:	e9 68 07 00 00       	jmp    c0102a44 <__alltraps>

c01022dc <vector88>:
.globl vector88
vector88:
  pushl $0
c01022dc:	6a 00                	push   $0x0
  pushl $88
c01022de:	6a 58                	push   $0x58
  jmp __alltraps
c01022e0:	e9 5f 07 00 00       	jmp    c0102a44 <__alltraps>

c01022e5 <vector89>:
.globl vector89
vector89:
  pushl $0
c01022e5:	6a 00                	push   $0x0
  pushl $89
c01022e7:	6a 59                	push   $0x59
  jmp __alltraps
c01022e9:	e9 56 07 00 00       	jmp    c0102a44 <__alltraps>

c01022ee <vector90>:
.globl vector90
vector90:
  pushl $0
c01022ee:	6a 00                	push   $0x0
  pushl $90
c01022f0:	6a 5a                	push   $0x5a
  jmp __alltraps
c01022f2:	e9 4d 07 00 00       	jmp    c0102a44 <__alltraps>

c01022f7 <vector91>:
.globl vector91
vector91:
  pushl $0
c01022f7:	6a 00                	push   $0x0
  pushl $91
c01022f9:	6a 5b                	push   $0x5b
  jmp __alltraps
c01022fb:	e9 44 07 00 00       	jmp    c0102a44 <__alltraps>

c0102300 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102300:	6a 00                	push   $0x0
  pushl $92
c0102302:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102304:	e9 3b 07 00 00       	jmp    c0102a44 <__alltraps>

c0102309 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102309:	6a 00                	push   $0x0
  pushl $93
c010230b:	6a 5d                	push   $0x5d
  jmp __alltraps
c010230d:	e9 32 07 00 00       	jmp    c0102a44 <__alltraps>

c0102312 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102312:	6a 00                	push   $0x0
  pushl $94
c0102314:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102316:	e9 29 07 00 00       	jmp    c0102a44 <__alltraps>

c010231b <vector95>:
.globl vector95
vector95:
  pushl $0
c010231b:	6a 00                	push   $0x0
  pushl $95
c010231d:	6a 5f                	push   $0x5f
  jmp __alltraps
c010231f:	e9 20 07 00 00       	jmp    c0102a44 <__alltraps>

c0102324 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102324:	6a 00                	push   $0x0
  pushl $96
c0102326:	6a 60                	push   $0x60
  jmp __alltraps
c0102328:	e9 17 07 00 00       	jmp    c0102a44 <__alltraps>

c010232d <vector97>:
.globl vector97
vector97:
  pushl $0
c010232d:	6a 00                	push   $0x0
  pushl $97
c010232f:	6a 61                	push   $0x61
  jmp __alltraps
c0102331:	e9 0e 07 00 00       	jmp    c0102a44 <__alltraps>

c0102336 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102336:	6a 00                	push   $0x0
  pushl $98
c0102338:	6a 62                	push   $0x62
  jmp __alltraps
c010233a:	e9 05 07 00 00       	jmp    c0102a44 <__alltraps>

c010233f <vector99>:
.globl vector99
vector99:
  pushl $0
c010233f:	6a 00                	push   $0x0
  pushl $99
c0102341:	6a 63                	push   $0x63
  jmp __alltraps
c0102343:	e9 fc 06 00 00       	jmp    c0102a44 <__alltraps>

c0102348 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102348:	6a 00                	push   $0x0
  pushl $100
c010234a:	6a 64                	push   $0x64
  jmp __alltraps
c010234c:	e9 f3 06 00 00       	jmp    c0102a44 <__alltraps>

c0102351 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102351:	6a 00                	push   $0x0
  pushl $101
c0102353:	6a 65                	push   $0x65
  jmp __alltraps
c0102355:	e9 ea 06 00 00       	jmp    c0102a44 <__alltraps>

c010235a <vector102>:
.globl vector102
vector102:
  pushl $0
c010235a:	6a 00                	push   $0x0
  pushl $102
c010235c:	6a 66                	push   $0x66
  jmp __alltraps
c010235e:	e9 e1 06 00 00       	jmp    c0102a44 <__alltraps>

c0102363 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102363:	6a 00                	push   $0x0
  pushl $103
c0102365:	6a 67                	push   $0x67
  jmp __alltraps
c0102367:	e9 d8 06 00 00       	jmp    c0102a44 <__alltraps>

c010236c <vector104>:
.globl vector104
vector104:
  pushl $0
c010236c:	6a 00                	push   $0x0
  pushl $104
c010236e:	6a 68                	push   $0x68
  jmp __alltraps
c0102370:	e9 cf 06 00 00       	jmp    c0102a44 <__alltraps>

c0102375 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102375:	6a 00                	push   $0x0
  pushl $105
c0102377:	6a 69                	push   $0x69
  jmp __alltraps
c0102379:	e9 c6 06 00 00       	jmp    c0102a44 <__alltraps>

c010237e <vector106>:
.globl vector106
vector106:
  pushl $0
c010237e:	6a 00                	push   $0x0
  pushl $106
c0102380:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102382:	e9 bd 06 00 00       	jmp    c0102a44 <__alltraps>

c0102387 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102387:	6a 00                	push   $0x0
  pushl $107
c0102389:	6a 6b                	push   $0x6b
  jmp __alltraps
c010238b:	e9 b4 06 00 00       	jmp    c0102a44 <__alltraps>

c0102390 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102390:	6a 00                	push   $0x0
  pushl $108
c0102392:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102394:	e9 ab 06 00 00       	jmp    c0102a44 <__alltraps>

c0102399 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102399:	6a 00                	push   $0x0
  pushl $109
c010239b:	6a 6d                	push   $0x6d
  jmp __alltraps
c010239d:	e9 a2 06 00 00       	jmp    c0102a44 <__alltraps>

c01023a2 <vector110>:
.globl vector110
vector110:
  pushl $0
c01023a2:	6a 00                	push   $0x0
  pushl $110
c01023a4:	6a 6e                	push   $0x6e
  jmp __alltraps
c01023a6:	e9 99 06 00 00       	jmp    c0102a44 <__alltraps>

c01023ab <vector111>:
.globl vector111
vector111:
  pushl $0
c01023ab:	6a 00                	push   $0x0
  pushl $111
c01023ad:	6a 6f                	push   $0x6f
  jmp __alltraps
c01023af:	e9 90 06 00 00       	jmp    c0102a44 <__alltraps>

c01023b4 <vector112>:
.globl vector112
vector112:
  pushl $0
c01023b4:	6a 00                	push   $0x0
  pushl $112
c01023b6:	6a 70                	push   $0x70
  jmp __alltraps
c01023b8:	e9 87 06 00 00       	jmp    c0102a44 <__alltraps>

c01023bd <vector113>:
.globl vector113
vector113:
  pushl $0
c01023bd:	6a 00                	push   $0x0
  pushl $113
c01023bf:	6a 71                	push   $0x71
  jmp __alltraps
c01023c1:	e9 7e 06 00 00       	jmp    c0102a44 <__alltraps>

c01023c6 <vector114>:
.globl vector114
vector114:
  pushl $0
c01023c6:	6a 00                	push   $0x0
  pushl $114
c01023c8:	6a 72                	push   $0x72
  jmp __alltraps
c01023ca:	e9 75 06 00 00       	jmp    c0102a44 <__alltraps>

c01023cf <vector115>:
.globl vector115
vector115:
  pushl $0
c01023cf:	6a 00                	push   $0x0
  pushl $115
c01023d1:	6a 73                	push   $0x73
  jmp __alltraps
c01023d3:	e9 6c 06 00 00       	jmp    c0102a44 <__alltraps>

c01023d8 <vector116>:
.globl vector116
vector116:
  pushl $0
c01023d8:	6a 00                	push   $0x0
  pushl $116
c01023da:	6a 74                	push   $0x74
  jmp __alltraps
c01023dc:	e9 63 06 00 00       	jmp    c0102a44 <__alltraps>

c01023e1 <vector117>:
.globl vector117
vector117:
  pushl $0
c01023e1:	6a 00                	push   $0x0
  pushl $117
c01023e3:	6a 75                	push   $0x75
  jmp __alltraps
c01023e5:	e9 5a 06 00 00       	jmp    c0102a44 <__alltraps>

c01023ea <vector118>:
.globl vector118
vector118:
  pushl $0
c01023ea:	6a 00                	push   $0x0
  pushl $118
c01023ec:	6a 76                	push   $0x76
  jmp __alltraps
c01023ee:	e9 51 06 00 00       	jmp    c0102a44 <__alltraps>

c01023f3 <vector119>:
.globl vector119
vector119:
  pushl $0
c01023f3:	6a 00                	push   $0x0
  pushl $119
c01023f5:	6a 77                	push   $0x77
  jmp __alltraps
c01023f7:	e9 48 06 00 00       	jmp    c0102a44 <__alltraps>

c01023fc <vector120>:
.globl vector120
vector120:
  pushl $0
c01023fc:	6a 00                	push   $0x0
  pushl $120
c01023fe:	6a 78                	push   $0x78
  jmp __alltraps
c0102400:	e9 3f 06 00 00       	jmp    c0102a44 <__alltraps>

c0102405 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102405:	6a 00                	push   $0x0
  pushl $121
c0102407:	6a 79                	push   $0x79
  jmp __alltraps
c0102409:	e9 36 06 00 00       	jmp    c0102a44 <__alltraps>

c010240e <vector122>:
.globl vector122
vector122:
  pushl $0
c010240e:	6a 00                	push   $0x0
  pushl $122
c0102410:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102412:	e9 2d 06 00 00       	jmp    c0102a44 <__alltraps>

c0102417 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102417:	6a 00                	push   $0x0
  pushl $123
c0102419:	6a 7b                	push   $0x7b
  jmp __alltraps
c010241b:	e9 24 06 00 00       	jmp    c0102a44 <__alltraps>

c0102420 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102420:	6a 00                	push   $0x0
  pushl $124
c0102422:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102424:	e9 1b 06 00 00       	jmp    c0102a44 <__alltraps>

c0102429 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102429:	6a 00                	push   $0x0
  pushl $125
c010242b:	6a 7d                	push   $0x7d
  jmp __alltraps
c010242d:	e9 12 06 00 00       	jmp    c0102a44 <__alltraps>

c0102432 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102432:	6a 00                	push   $0x0
  pushl $126
c0102434:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102436:	e9 09 06 00 00       	jmp    c0102a44 <__alltraps>

c010243b <vector127>:
.globl vector127
vector127:
  pushl $0
c010243b:	6a 00                	push   $0x0
  pushl $127
c010243d:	6a 7f                	push   $0x7f
  jmp __alltraps
c010243f:	e9 00 06 00 00       	jmp    c0102a44 <__alltraps>

c0102444 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102444:	6a 00                	push   $0x0
  pushl $128
c0102446:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010244b:	e9 f4 05 00 00       	jmp    c0102a44 <__alltraps>

c0102450 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102450:	6a 00                	push   $0x0
  pushl $129
c0102452:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102457:	e9 e8 05 00 00       	jmp    c0102a44 <__alltraps>

c010245c <vector130>:
.globl vector130
vector130:
  pushl $0
c010245c:	6a 00                	push   $0x0
  pushl $130
c010245e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102463:	e9 dc 05 00 00       	jmp    c0102a44 <__alltraps>

c0102468 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102468:	6a 00                	push   $0x0
  pushl $131
c010246a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010246f:	e9 d0 05 00 00       	jmp    c0102a44 <__alltraps>

c0102474 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102474:	6a 00                	push   $0x0
  pushl $132
c0102476:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010247b:	e9 c4 05 00 00       	jmp    c0102a44 <__alltraps>

c0102480 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102480:	6a 00                	push   $0x0
  pushl $133
c0102482:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102487:	e9 b8 05 00 00       	jmp    c0102a44 <__alltraps>

c010248c <vector134>:
.globl vector134
vector134:
  pushl $0
c010248c:	6a 00                	push   $0x0
  pushl $134
c010248e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102493:	e9 ac 05 00 00       	jmp    c0102a44 <__alltraps>

c0102498 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102498:	6a 00                	push   $0x0
  pushl $135
c010249a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010249f:	e9 a0 05 00 00       	jmp    c0102a44 <__alltraps>

c01024a4 <vector136>:
.globl vector136
vector136:
  pushl $0
c01024a4:	6a 00                	push   $0x0
  pushl $136
c01024a6:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01024ab:	e9 94 05 00 00       	jmp    c0102a44 <__alltraps>

c01024b0 <vector137>:
.globl vector137
vector137:
  pushl $0
c01024b0:	6a 00                	push   $0x0
  pushl $137
c01024b2:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01024b7:	e9 88 05 00 00       	jmp    c0102a44 <__alltraps>

c01024bc <vector138>:
.globl vector138
vector138:
  pushl $0
c01024bc:	6a 00                	push   $0x0
  pushl $138
c01024be:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01024c3:	e9 7c 05 00 00       	jmp    c0102a44 <__alltraps>

c01024c8 <vector139>:
.globl vector139
vector139:
  pushl $0
c01024c8:	6a 00                	push   $0x0
  pushl $139
c01024ca:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01024cf:	e9 70 05 00 00       	jmp    c0102a44 <__alltraps>

c01024d4 <vector140>:
.globl vector140
vector140:
  pushl $0
c01024d4:	6a 00                	push   $0x0
  pushl $140
c01024d6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01024db:	e9 64 05 00 00       	jmp    c0102a44 <__alltraps>

c01024e0 <vector141>:
.globl vector141
vector141:
  pushl $0
c01024e0:	6a 00                	push   $0x0
  pushl $141
c01024e2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01024e7:	e9 58 05 00 00       	jmp    c0102a44 <__alltraps>

c01024ec <vector142>:
.globl vector142
vector142:
  pushl $0
c01024ec:	6a 00                	push   $0x0
  pushl $142
c01024ee:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01024f3:	e9 4c 05 00 00       	jmp    c0102a44 <__alltraps>

c01024f8 <vector143>:
.globl vector143
vector143:
  pushl $0
c01024f8:	6a 00                	push   $0x0
  pushl $143
c01024fa:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01024ff:	e9 40 05 00 00       	jmp    c0102a44 <__alltraps>

c0102504 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102504:	6a 00                	push   $0x0
  pushl $144
c0102506:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010250b:	e9 34 05 00 00       	jmp    c0102a44 <__alltraps>

c0102510 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102510:	6a 00                	push   $0x0
  pushl $145
c0102512:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102517:	e9 28 05 00 00       	jmp    c0102a44 <__alltraps>

c010251c <vector146>:
.globl vector146
vector146:
  pushl $0
c010251c:	6a 00                	push   $0x0
  pushl $146
c010251e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102523:	e9 1c 05 00 00       	jmp    c0102a44 <__alltraps>

c0102528 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102528:	6a 00                	push   $0x0
  pushl $147
c010252a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010252f:	e9 10 05 00 00       	jmp    c0102a44 <__alltraps>

c0102534 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102534:	6a 00                	push   $0x0
  pushl $148
c0102536:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010253b:	e9 04 05 00 00       	jmp    c0102a44 <__alltraps>

c0102540 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102540:	6a 00                	push   $0x0
  pushl $149
c0102542:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102547:	e9 f8 04 00 00       	jmp    c0102a44 <__alltraps>

c010254c <vector150>:
.globl vector150
vector150:
  pushl $0
c010254c:	6a 00                	push   $0x0
  pushl $150
c010254e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102553:	e9 ec 04 00 00       	jmp    c0102a44 <__alltraps>

c0102558 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102558:	6a 00                	push   $0x0
  pushl $151
c010255a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010255f:	e9 e0 04 00 00       	jmp    c0102a44 <__alltraps>

c0102564 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102564:	6a 00                	push   $0x0
  pushl $152
c0102566:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010256b:	e9 d4 04 00 00       	jmp    c0102a44 <__alltraps>

c0102570 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102570:	6a 00                	push   $0x0
  pushl $153
c0102572:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102577:	e9 c8 04 00 00       	jmp    c0102a44 <__alltraps>

c010257c <vector154>:
.globl vector154
vector154:
  pushl $0
c010257c:	6a 00                	push   $0x0
  pushl $154
c010257e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102583:	e9 bc 04 00 00       	jmp    c0102a44 <__alltraps>

c0102588 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102588:	6a 00                	push   $0x0
  pushl $155
c010258a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010258f:	e9 b0 04 00 00       	jmp    c0102a44 <__alltraps>

c0102594 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102594:	6a 00                	push   $0x0
  pushl $156
c0102596:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010259b:	e9 a4 04 00 00       	jmp    c0102a44 <__alltraps>

c01025a0 <vector157>:
.globl vector157
vector157:
  pushl $0
c01025a0:	6a 00                	push   $0x0
  pushl $157
c01025a2:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01025a7:	e9 98 04 00 00       	jmp    c0102a44 <__alltraps>

c01025ac <vector158>:
.globl vector158
vector158:
  pushl $0
c01025ac:	6a 00                	push   $0x0
  pushl $158
c01025ae:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01025b3:	e9 8c 04 00 00       	jmp    c0102a44 <__alltraps>

c01025b8 <vector159>:
.globl vector159
vector159:
  pushl $0
c01025b8:	6a 00                	push   $0x0
  pushl $159
c01025ba:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01025bf:	e9 80 04 00 00       	jmp    c0102a44 <__alltraps>

c01025c4 <vector160>:
.globl vector160
vector160:
  pushl $0
c01025c4:	6a 00                	push   $0x0
  pushl $160
c01025c6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01025cb:	e9 74 04 00 00       	jmp    c0102a44 <__alltraps>

c01025d0 <vector161>:
.globl vector161
vector161:
  pushl $0
c01025d0:	6a 00                	push   $0x0
  pushl $161
c01025d2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01025d7:	e9 68 04 00 00       	jmp    c0102a44 <__alltraps>

c01025dc <vector162>:
.globl vector162
vector162:
  pushl $0
c01025dc:	6a 00                	push   $0x0
  pushl $162
c01025de:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01025e3:	e9 5c 04 00 00       	jmp    c0102a44 <__alltraps>

c01025e8 <vector163>:
.globl vector163
vector163:
  pushl $0
c01025e8:	6a 00                	push   $0x0
  pushl $163
c01025ea:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01025ef:	e9 50 04 00 00       	jmp    c0102a44 <__alltraps>

c01025f4 <vector164>:
.globl vector164
vector164:
  pushl $0
c01025f4:	6a 00                	push   $0x0
  pushl $164
c01025f6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01025fb:	e9 44 04 00 00       	jmp    c0102a44 <__alltraps>

c0102600 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102600:	6a 00                	push   $0x0
  pushl $165
c0102602:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102607:	e9 38 04 00 00       	jmp    c0102a44 <__alltraps>

c010260c <vector166>:
.globl vector166
vector166:
  pushl $0
c010260c:	6a 00                	push   $0x0
  pushl $166
c010260e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102613:	e9 2c 04 00 00       	jmp    c0102a44 <__alltraps>

c0102618 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102618:	6a 00                	push   $0x0
  pushl $167
c010261a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010261f:	e9 20 04 00 00       	jmp    c0102a44 <__alltraps>

c0102624 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102624:	6a 00                	push   $0x0
  pushl $168
c0102626:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010262b:	e9 14 04 00 00       	jmp    c0102a44 <__alltraps>

c0102630 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102630:	6a 00                	push   $0x0
  pushl $169
c0102632:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102637:	e9 08 04 00 00       	jmp    c0102a44 <__alltraps>

c010263c <vector170>:
.globl vector170
vector170:
  pushl $0
c010263c:	6a 00                	push   $0x0
  pushl $170
c010263e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102643:	e9 fc 03 00 00       	jmp    c0102a44 <__alltraps>

c0102648 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102648:	6a 00                	push   $0x0
  pushl $171
c010264a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010264f:	e9 f0 03 00 00       	jmp    c0102a44 <__alltraps>

c0102654 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102654:	6a 00                	push   $0x0
  pushl $172
c0102656:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010265b:	e9 e4 03 00 00       	jmp    c0102a44 <__alltraps>

c0102660 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102660:	6a 00                	push   $0x0
  pushl $173
c0102662:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102667:	e9 d8 03 00 00       	jmp    c0102a44 <__alltraps>

c010266c <vector174>:
.globl vector174
vector174:
  pushl $0
c010266c:	6a 00                	push   $0x0
  pushl $174
c010266e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102673:	e9 cc 03 00 00       	jmp    c0102a44 <__alltraps>

c0102678 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102678:	6a 00                	push   $0x0
  pushl $175
c010267a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010267f:	e9 c0 03 00 00       	jmp    c0102a44 <__alltraps>

c0102684 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102684:	6a 00                	push   $0x0
  pushl $176
c0102686:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010268b:	e9 b4 03 00 00       	jmp    c0102a44 <__alltraps>

c0102690 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102690:	6a 00                	push   $0x0
  pushl $177
c0102692:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102697:	e9 a8 03 00 00       	jmp    c0102a44 <__alltraps>

c010269c <vector178>:
.globl vector178
vector178:
  pushl $0
c010269c:	6a 00                	push   $0x0
  pushl $178
c010269e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01026a3:	e9 9c 03 00 00       	jmp    c0102a44 <__alltraps>

c01026a8 <vector179>:
.globl vector179
vector179:
  pushl $0
c01026a8:	6a 00                	push   $0x0
  pushl $179
c01026aa:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01026af:	e9 90 03 00 00       	jmp    c0102a44 <__alltraps>

c01026b4 <vector180>:
.globl vector180
vector180:
  pushl $0
c01026b4:	6a 00                	push   $0x0
  pushl $180
c01026b6:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01026bb:	e9 84 03 00 00       	jmp    c0102a44 <__alltraps>

c01026c0 <vector181>:
.globl vector181
vector181:
  pushl $0
c01026c0:	6a 00                	push   $0x0
  pushl $181
c01026c2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01026c7:	e9 78 03 00 00       	jmp    c0102a44 <__alltraps>

c01026cc <vector182>:
.globl vector182
vector182:
  pushl $0
c01026cc:	6a 00                	push   $0x0
  pushl $182
c01026ce:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01026d3:	e9 6c 03 00 00       	jmp    c0102a44 <__alltraps>

c01026d8 <vector183>:
.globl vector183
vector183:
  pushl $0
c01026d8:	6a 00                	push   $0x0
  pushl $183
c01026da:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01026df:	e9 60 03 00 00       	jmp    c0102a44 <__alltraps>

c01026e4 <vector184>:
.globl vector184
vector184:
  pushl $0
c01026e4:	6a 00                	push   $0x0
  pushl $184
c01026e6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01026eb:	e9 54 03 00 00       	jmp    c0102a44 <__alltraps>

c01026f0 <vector185>:
.globl vector185
vector185:
  pushl $0
c01026f0:	6a 00                	push   $0x0
  pushl $185
c01026f2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01026f7:	e9 48 03 00 00       	jmp    c0102a44 <__alltraps>

c01026fc <vector186>:
.globl vector186
vector186:
  pushl $0
c01026fc:	6a 00                	push   $0x0
  pushl $186
c01026fe:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102703:	e9 3c 03 00 00       	jmp    c0102a44 <__alltraps>

c0102708 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102708:	6a 00                	push   $0x0
  pushl $187
c010270a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010270f:	e9 30 03 00 00       	jmp    c0102a44 <__alltraps>

c0102714 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102714:	6a 00                	push   $0x0
  pushl $188
c0102716:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010271b:	e9 24 03 00 00       	jmp    c0102a44 <__alltraps>

c0102720 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102720:	6a 00                	push   $0x0
  pushl $189
c0102722:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102727:	e9 18 03 00 00       	jmp    c0102a44 <__alltraps>

c010272c <vector190>:
.globl vector190
vector190:
  pushl $0
c010272c:	6a 00                	push   $0x0
  pushl $190
c010272e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102733:	e9 0c 03 00 00       	jmp    c0102a44 <__alltraps>

c0102738 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102738:	6a 00                	push   $0x0
  pushl $191
c010273a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010273f:	e9 00 03 00 00       	jmp    c0102a44 <__alltraps>

c0102744 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102744:	6a 00                	push   $0x0
  pushl $192
c0102746:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010274b:	e9 f4 02 00 00       	jmp    c0102a44 <__alltraps>

c0102750 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102750:	6a 00                	push   $0x0
  pushl $193
c0102752:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102757:	e9 e8 02 00 00       	jmp    c0102a44 <__alltraps>

c010275c <vector194>:
.globl vector194
vector194:
  pushl $0
c010275c:	6a 00                	push   $0x0
  pushl $194
c010275e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102763:	e9 dc 02 00 00       	jmp    c0102a44 <__alltraps>

c0102768 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102768:	6a 00                	push   $0x0
  pushl $195
c010276a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010276f:	e9 d0 02 00 00       	jmp    c0102a44 <__alltraps>

c0102774 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102774:	6a 00                	push   $0x0
  pushl $196
c0102776:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010277b:	e9 c4 02 00 00       	jmp    c0102a44 <__alltraps>

c0102780 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102780:	6a 00                	push   $0x0
  pushl $197
c0102782:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102787:	e9 b8 02 00 00       	jmp    c0102a44 <__alltraps>

c010278c <vector198>:
.globl vector198
vector198:
  pushl $0
c010278c:	6a 00                	push   $0x0
  pushl $198
c010278e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102793:	e9 ac 02 00 00       	jmp    c0102a44 <__alltraps>

c0102798 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102798:	6a 00                	push   $0x0
  pushl $199
c010279a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010279f:	e9 a0 02 00 00       	jmp    c0102a44 <__alltraps>

c01027a4 <vector200>:
.globl vector200
vector200:
  pushl $0
c01027a4:	6a 00                	push   $0x0
  pushl $200
c01027a6:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01027ab:	e9 94 02 00 00       	jmp    c0102a44 <__alltraps>

c01027b0 <vector201>:
.globl vector201
vector201:
  pushl $0
c01027b0:	6a 00                	push   $0x0
  pushl $201
c01027b2:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01027b7:	e9 88 02 00 00       	jmp    c0102a44 <__alltraps>

c01027bc <vector202>:
.globl vector202
vector202:
  pushl $0
c01027bc:	6a 00                	push   $0x0
  pushl $202
c01027be:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01027c3:	e9 7c 02 00 00       	jmp    c0102a44 <__alltraps>

c01027c8 <vector203>:
.globl vector203
vector203:
  pushl $0
c01027c8:	6a 00                	push   $0x0
  pushl $203
c01027ca:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01027cf:	e9 70 02 00 00       	jmp    c0102a44 <__alltraps>

c01027d4 <vector204>:
.globl vector204
vector204:
  pushl $0
c01027d4:	6a 00                	push   $0x0
  pushl $204
c01027d6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01027db:	e9 64 02 00 00       	jmp    c0102a44 <__alltraps>

c01027e0 <vector205>:
.globl vector205
vector205:
  pushl $0
c01027e0:	6a 00                	push   $0x0
  pushl $205
c01027e2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01027e7:	e9 58 02 00 00       	jmp    c0102a44 <__alltraps>

c01027ec <vector206>:
.globl vector206
vector206:
  pushl $0
c01027ec:	6a 00                	push   $0x0
  pushl $206
c01027ee:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01027f3:	e9 4c 02 00 00       	jmp    c0102a44 <__alltraps>

c01027f8 <vector207>:
.globl vector207
vector207:
  pushl $0
c01027f8:	6a 00                	push   $0x0
  pushl $207
c01027fa:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01027ff:	e9 40 02 00 00       	jmp    c0102a44 <__alltraps>

c0102804 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102804:	6a 00                	push   $0x0
  pushl $208
c0102806:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010280b:	e9 34 02 00 00       	jmp    c0102a44 <__alltraps>

c0102810 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102810:	6a 00                	push   $0x0
  pushl $209
c0102812:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102817:	e9 28 02 00 00       	jmp    c0102a44 <__alltraps>

c010281c <vector210>:
.globl vector210
vector210:
  pushl $0
c010281c:	6a 00                	push   $0x0
  pushl $210
c010281e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102823:	e9 1c 02 00 00       	jmp    c0102a44 <__alltraps>

c0102828 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102828:	6a 00                	push   $0x0
  pushl $211
c010282a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010282f:	e9 10 02 00 00       	jmp    c0102a44 <__alltraps>

c0102834 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102834:	6a 00                	push   $0x0
  pushl $212
c0102836:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010283b:	e9 04 02 00 00       	jmp    c0102a44 <__alltraps>

c0102840 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102840:	6a 00                	push   $0x0
  pushl $213
c0102842:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102847:	e9 f8 01 00 00       	jmp    c0102a44 <__alltraps>

c010284c <vector214>:
.globl vector214
vector214:
  pushl $0
c010284c:	6a 00                	push   $0x0
  pushl $214
c010284e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102853:	e9 ec 01 00 00       	jmp    c0102a44 <__alltraps>

c0102858 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102858:	6a 00                	push   $0x0
  pushl $215
c010285a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010285f:	e9 e0 01 00 00       	jmp    c0102a44 <__alltraps>

c0102864 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102864:	6a 00                	push   $0x0
  pushl $216
c0102866:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010286b:	e9 d4 01 00 00       	jmp    c0102a44 <__alltraps>

c0102870 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102870:	6a 00                	push   $0x0
  pushl $217
c0102872:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102877:	e9 c8 01 00 00       	jmp    c0102a44 <__alltraps>

c010287c <vector218>:
.globl vector218
vector218:
  pushl $0
c010287c:	6a 00                	push   $0x0
  pushl $218
c010287e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102883:	e9 bc 01 00 00       	jmp    c0102a44 <__alltraps>

c0102888 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102888:	6a 00                	push   $0x0
  pushl $219
c010288a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010288f:	e9 b0 01 00 00       	jmp    c0102a44 <__alltraps>

c0102894 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102894:	6a 00                	push   $0x0
  pushl $220
c0102896:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010289b:	e9 a4 01 00 00       	jmp    c0102a44 <__alltraps>

c01028a0 <vector221>:
.globl vector221
vector221:
  pushl $0
c01028a0:	6a 00                	push   $0x0
  pushl $221
c01028a2:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01028a7:	e9 98 01 00 00       	jmp    c0102a44 <__alltraps>

c01028ac <vector222>:
.globl vector222
vector222:
  pushl $0
c01028ac:	6a 00                	push   $0x0
  pushl $222
c01028ae:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01028b3:	e9 8c 01 00 00       	jmp    c0102a44 <__alltraps>

c01028b8 <vector223>:
.globl vector223
vector223:
  pushl $0
c01028b8:	6a 00                	push   $0x0
  pushl $223
c01028ba:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01028bf:	e9 80 01 00 00       	jmp    c0102a44 <__alltraps>

c01028c4 <vector224>:
.globl vector224
vector224:
  pushl $0
c01028c4:	6a 00                	push   $0x0
  pushl $224
c01028c6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01028cb:	e9 74 01 00 00       	jmp    c0102a44 <__alltraps>

c01028d0 <vector225>:
.globl vector225
vector225:
  pushl $0
c01028d0:	6a 00                	push   $0x0
  pushl $225
c01028d2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01028d7:	e9 68 01 00 00       	jmp    c0102a44 <__alltraps>

c01028dc <vector226>:
.globl vector226
vector226:
  pushl $0
c01028dc:	6a 00                	push   $0x0
  pushl $226
c01028de:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01028e3:	e9 5c 01 00 00       	jmp    c0102a44 <__alltraps>

c01028e8 <vector227>:
.globl vector227
vector227:
  pushl $0
c01028e8:	6a 00                	push   $0x0
  pushl $227
c01028ea:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01028ef:	e9 50 01 00 00       	jmp    c0102a44 <__alltraps>

c01028f4 <vector228>:
.globl vector228
vector228:
  pushl $0
c01028f4:	6a 00                	push   $0x0
  pushl $228
c01028f6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01028fb:	e9 44 01 00 00       	jmp    c0102a44 <__alltraps>

c0102900 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102900:	6a 00                	push   $0x0
  pushl $229
c0102902:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102907:	e9 38 01 00 00       	jmp    c0102a44 <__alltraps>

c010290c <vector230>:
.globl vector230
vector230:
  pushl $0
c010290c:	6a 00                	push   $0x0
  pushl $230
c010290e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102913:	e9 2c 01 00 00       	jmp    c0102a44 <__alltraps>

c0102918 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102918:	6a 00                	push   $0x0
  pushl $231
c010291a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010291f:	e9 20 01 00 00       	jmp    c0102a44 <__alltraps>

c0102924 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102924:	6a 00                	push   $0x0
  pushl $232
c0102926:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010292b:	e9 14 01 00 00       	jmp    c0102a44 <__alltraps>

c0102930 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102930:	6a 00                	push   $0x0
  pushl $233
c0102932:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102937:	e9 08 01 00 00       	jmp    c0102a44 <__alltraps>

c010293c <vector234>:
.globl vector234
vector234:
  pushl $0
c010293c:	6a 00                	push   $0x0
  pushl $234
c010293e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102943:	e9 fc 00 00 00       	jmp    c0102a44 <__alltraps>

c0102948 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102948:	6a 00                	push   $0x0
  pushl $235
c010294a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010294f:	e9 f0 00 00 00       	jmp    c0102a44 <__alltraps>

c0102954 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102954:	6a 00                	push   $0x0
  pushl $236
c0102956:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010295b:	e9 e4 00 00 00       	jmp    c0102a44 <__alltraps>

c0102960 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102960:	6a 00                	push   $0x0
  pushl $237
c0102962:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102967:	e9 d8 00 00 00       	jmp    c0102a44 <__alltraps>

c010296c <vector238>:
.globl vector238
vector238:
  pushl $0
c010296c:	6a 00                	push   $0x0
  pushl $238
c010296e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102973:	e9 cc 00 00 00       	jmp    c0102a44 <__alltraps>

c0102978 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102978:	6a 00                	push   $0x0
  pushl $239
c010297a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010297f:	e9 c0 00 00 00       	jmp    c0102a44 <__alltraps>

c0102984 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102984:	6a 00                	push   $0x0
  pushl $240
c0102986:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010298b:	e9 b4 00 00 00       	jmp    c0102a44 <__alltraps>

c0102990 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102990:	6a 00                	push   $0x0
  pushl $241
c0102992:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102997:	e9 a8 00 00 00       	jmp    c0102a44 <__alltraps>

c010299c <vector242>:
.globl vector242
vector242:
  pushl $0
c010299c:	6a 00                	push   $0x0
  pushl $242
c010299e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01029a3:	e9 9c 00 00 00       	jmp    c0102a44 <__alltraps>

c01029a8 <vector243>:
.globl vector243
vector243:
  pushl $0
c01029a8:	6a 00                	push   $0x0
  pushl $243
c01029aa:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01029af:	e9 90 00 00 00       	jmp    c0102a44 <__alltraps>

c01029b4 <vector244>:
.globl vector244
vector244:
  pushl $0
c01029b4:	6a 00                	push   $0x0
  pushl $244
c01029b6:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01029bb:	e9 84 00 00 00       	jmp    c0102a44 <__alltraps>

c01029c0 <vector245>:
.globl vector245
vector245:
  pushl $0
c01029c0:	6a 00                	push   $0x0
  pushl $245
c01029c2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01029c7:	e9 78 00 00 00       	jmp    c0102a44 <__alltraps>

c01029cc <vector246>:
.globl vector246
vector246:
  pushl $0
c01029cc:	6a 00                	push   $0x0
  pushl $246
c01029ce:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01029d3:	e9 6c 00 00 00       	jmp    c0102a44 <__alltraps>

c01029d8 <vector247>:
.globl vector247
vector247:
  pushl $0
c01029d8:	6a 00                	push   $0x0
  pushl $247
c01029da:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01029df:	e9 60 00 00 00       	jmp    c0102a44 <__alltraps>

c01029e4 <vector248>:
.globl vector248
vector248:
  pushl $0
c01029e4:	6a 00                	push   $0x0
  pushl $248
c01029e6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01029eb:	e9 54 00 00 00       	jmp    c0102a44 <__alltraps>

c01029f0 <vector249>:
.globl vector249
vector249:
  pushl $0
c01029f0:	6a 00                	push   $0x0
  pushl $249
c01029f2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01029f7:	e9 48 00 00 00       	jmp    c0102a44 <__alltraps>

c01029fc <vector250>:
.globl vector250
vector250:
  pushl $0
c01029fc:	6a 00                	push   $0x0
  pushl $250
c01029fe:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102a03:	e9 3c 00 00 00       	jmp    c0102a44 <__alltraps>

c0102a08 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102a08:	6a 00                	push   $0x0
  pushl $251
c0102a0a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102a0f:	e9 30 00 00 00       	jmp    c0102a44 <__alltraps>

c0102a14 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102a14:	6a 00                	push   $0x0
  pushl $252
c0102a16:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102a1b:	e9 24 00 00 00       	jmp    c0102a44 <__alltraps>

c0102a20 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102a20:	6a 00                	push   $0x0
  pushl $253
c0102a22:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102a27:	e9 18 00 00 00       	jmp    c0102a44 <__alltraps>

c0102a2c <vector254>:
.globl vector254
vector254:
  pushl $0
c0102a2c:	6a 00                	push   $0x0
  pushl $254
c0102a2e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102a33:	e9 0c 00 00 00       	jmp    c0102a44 <__alltraps>

c0102a38 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102a38:	6a 00                	push   $0x0
  pushl $255
c0102a3a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102a3f:	e9 00 00 00 00       	jmp    c0102a44 <__alltraps>

c0102a44 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102a44:	1e                   	push   %ds
    pushl %es
c0102a45:	06                   	push   %es
    pushl %fs
c0102a46:	0f a0                	push   %fs
    pushl %gs
c0102a48:	0f a8                	push   %gs
    pushal
c0102a4a:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102a4b:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102a50:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102a52:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102a54:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102a55:	e8 59 f5 ff ff       	call   c0101fb3 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102a5a:	5c                   	pop    %esp

c0102a5b <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102a5b:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102a5c:	0f a9                	pop    %gs
    popl %fs
c0102a5e:	0f a1                	pop    %fs
    popl %es
c0102a60:	07                   	pop    %es
    popl %ds
c0102a61:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102a62:	83 c4 08             	add    $0x8,%esp
    iret
c0102a65:	cf                   	iret   

c0102a66 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102a66:	55                   	push   %ebp
c0102a67:	89 e5                	mov    %esp,%ebp
c0102a69:	e8 38 d8 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0102a6e:	05 02 4f 01 00       	add    $0x14f02,%eax
    return page - pages;
c0102a73:	8b 55 08             	mov    0x8(%ebp),%edx
c0102a76:	c7 c0 18 8a 11 c0    	mov    $0xc0118a18,%eax
c0102a7c:	8b 00                	mov    (%eax),%eax
c0102a7e:	29 c2                	sub    %eax,%edx
c0102a80:	89 d0                	mov    %edx,%eax
c0102a82:	c1 f8 02             	sar    $0x2,%eax
c0102a85:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102a8b:	5d                   	pop    %ebp
c0102a8c:	c3                   	ret    

c0102a8d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102a8d:	55                   	push   %ebp
c0102a8e:	89 e5                	mov    %esp,%ebp
c0102a90:	e8 11 d8 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0102a95:	05 db 4e 01 00       	add    $0x14edb,%eax
    return page2ppn(page) << PGSHIFT;
c0102a9a:	ff 75 08             	pushl  0x8(%ebp)
c0102a9d:	e8 c4 ff ff ff       	call   c0102a66 <page2ppn>
c0102aa2:	83 c4 04             	add    $0x4,%esp
c0102aa5:	c1 e0 0c             	shl    $0xc,%eax
}
c0102aa8:	c9                   	leave  
c0102aa9:	c3                   	ret    

c0102aaa <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102aaa:	55                   	push   %ebp
c0102aab:	89 e5                	mov    %esp,%ebp
c0102aad:	53                   	push   %ebx
c0102aae:	83 ec 04             	sub    $0x4,%esp
c0102ab1:	e8 f0 d7 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0102ab6:	05 ba 4e 01 00       	add    $0x14eba,%eax
    if (PPN(pa) >= npage) {
c0102abb:	8b 55 08             	mov    0x8(%ebp),%edx
c0102abe:	89 d1                	mov    %edx,%ecx
c0102ac0:	c1 e9 0c             	shr    $0xc,%ecx
c0102ac3:	8b 90 10 10 00 00    	mov    0x1010(%eax),%edx
c0102ac9:	39 d1                	cmp    %edx,%ecx
c0102acb:	72 1a                	jb     c0102ae7 <pa2page+0x3d>
        panic("pa2page called with invalid pa");
c0102acd:	83 ec 04             	sub    $0x4,%esp
c0102ad0:	8d 90 4c ee fe ff    	lea    -0x111b4(%eax),%edx
c0102ad6:	52                   	push   %edx
c0102ad7:	6a 5a                	push   $0x5a
c0102ad9:	8d 90 6b ee fe ff    	lea    -0x11195(%eax),%edx
c0102adf:	52                   	push   %edx
c0102ae0:	89 c3                	mov    %eax,%ebx
c0102ae2:	e8 e6 d9 ff ff       	call   c01004cd <__panic>
    }
    return &pages[PPN(pa)];
c0102ae7:	c7 c0 18 8a 11 c0    	mov    $0xc0118a18,%eax
c0102aed:	8b 08                	mov    (%eax),%ecx
c0102aef:	8b 45 08             	mov    0x8(%ebp),%eax
c0102af2:	c1 e8 0c             	shr    $0xc,%eax
c0102af5:	89 c2                	mov    %eax,%edx
c0102af7:	89 d0                	mov    %edx,%eax
c0102af9:	c1 e0 02             	shl    $0x2,%eax
c0102afc:	01 d0                	add    %edx,%eax
c0102afe:	c1 e0 02             	shl    $0x2,%eax
c0102b01:	01 c8                	add    %ecx,%eax
}
c0102b03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102b06:	c9                   	leave  
c0102b07:	c3                   	ret    

c0102b08 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102b08:	55                   	push   %ebp
c0102b09:	89 e5                	mov    %esp,%ebp
c0102b0b:	53                   	push   %ebx
c0102b0c:	83 ec 14             	sub    $0x14,%esp
c0102b0f:	e8 96 d7 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0102b14:	81 c3 5c 4e 01 00    	add    $0x14e5c,%ebx
    return KADDR(page2pa(page));
c0102b1a:	ff 75 08             	pushl  0x8(%ebp)
c0102b1d:	e8 6b ff ff ff       	call   c0102a8d <page2pa>
c0102b22:	83 c4 04             	add    $0x4,%esp
c0102b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b2b:	c1 e8 0c             	shr    $0xc,%eax
c0102b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102b31:	8b 83 10 10 00 00    	mov    0x1010(%ebx),%eax
c0102b37:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102b3a:	72 18                	jb     c0102b54 <page2kva+0x4c>
c0102b3c:	ff 75 f4             	pushl  -0xc(%ebp)
c0102b3f:	8d 83 7c ee fe ff    	lea    -0x11184(%ebx),%eax
c0102b45:	50                   	push   %eax
c0102b46:	6a 61                	push   $0x61
c0102b48:	8d 83 6b ee fe ff    	lea    -0x11195(%ebx),%eax
c0102b4e:	50                   	push   %eax
c0102b4f:	e8 79 d9 ff ff       	call   c01004cd <__panic>
c0102b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b57:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102b5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102b5f:	c9                   	leave  
c0102b60:	c3                   	ret    

c0102b61 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102b61:	55                   	push   %ebp
c0102b62:	89 e5                	mov    %esp,%ebp
c0102b64:	53                   	push   %ebx
c0102b65:	83 ec 04             	sub    $0x4,%esp
c0102b68:	e8 39 d7 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0102b6d:	05 03 4e 01 00       	add    $0x14e03,%eax
    if (!(pte & PTE_P)) {
c0102b72:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b75:	83 e2 01             	and    $0x1,%edx
c0102b78:	85 d2                	test   %edx,%edx
c0102b7a:	75 1a                	jne    c0102b96 <pte2page+0x35>
        panic("pte2page called with invalid pte");
c0102b7c:	83 ec 04             	sub    $0x4,%esp
c0102b7f:	8d 90 a0 ee fe ff    	lea    -0x11160(%eax),%edx
c0102b85:	52                   	push   %edx
c0102b86:	6a 6c                	push   $0x6c
c0102b88:	8d 90 6b ee fe ff    	lea    -0x11195(%eax),%edx
c0102b8e:	52                   	push   %edx
c0102b8f:	89 c3                	mov    %eax,%ebx
c0102b91:	e8 37 d9 ff ff       	call   c01004cd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102b96:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102b9e:	83 ec 0c             	sub    $0xc,%esp
c0102ba1:	50                   	push   %eax
c0102ba2:	e8 03 ff ff ff       	call   c0102aaa <pa2page>
c0102ba7:	83 c4 10             	add    $0x10,%esp
}
c0102baa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102bad:	c9                   	leave  
c0102bae:	c3                   	ret    

c0102baf <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102baf:	55                   	push   %ebp
c0102bb0:	89 e5                	mov    %esp,%ebp
c0102bb2:	e8 ef d6 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0102bb7:	05 b9 4d 01 00       	add    $0x14db9,%eax
    return page->ref;
c0102bbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bbf:	8b 00                	mov    (%eax),%eax
}
c0102bc1:	5d                   	pop    %ebp
c0102bc2:	c3                   	ret    

c0102bc3 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0102bc3:	55                   	push   %ebp
c0102bc4:	89 e5                	mov    %esp,%ebp
c0102bc6:	e8 db d6 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0102bcb:	05 a5 4d 01 00       	add    $0x14da5,%eax
    page->ref += 1;
c0102bd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bd3:	8b 00                	mov    (%eax),%eax
c0102bd5:	8d 50 01             	lea    0x1(%eax),%edx
c0102bd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bdb:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102bdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102be0:	8b 00                	mov    (%eax),%eax
}
c0102be2:	5d                   	pop    %ebp
c0102be3:	c3                   	ret    

c0102be4 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102be4:	55                   	push   %ebp
c0102be5:	89 e5                	mov    %esp,%ebp
c0102be7:	e8 ba d6 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0102bec:	05 84 4d 01 00       	add    $0x14d84,%eax
    page->ref -= 1;
c0102bf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bf4:	8b 00                	mov    (%eax),%eax
c0102bf6:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102bf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bfc:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c01:	8b 00                	mov    (%eax),%eax
}
c0102c03:	5d                   	pop    %ebp
c0102c04:	c3                   	ret    

c0102c05 <__intr_save>:
__intr_save(void) {
c0102c05:	55                   	push   %ebp
c0102c06:	89 e5                	mov    %esp,%ebp
c0102c08:	53                   	push   %ebx
c0102c09:	83 ec 14             	sub    $0x14,%esp
c0102c0c:	e8 95 d6 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0102c11:	05 5f 4d 01 00       	add    $0x14d5f,%eax
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102c16:	9c                   	pushf  
c0102c17:	5a                   	pop    %edx
c0102c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
    return eflags;
c0102c1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    if (read_eflags() & FL_IF) {
c0102c1e:	81 e2 00 02 00 00    	and    $0x200,%edx
c0102c24:	85 d2                	test   %edx,%edx
c0102c26:	74 0e                	je     c0102c36 <__intr_save+0x31>
        intr_disable();
c0102c28:	89 c3                	mov    %eax,%ebx
c0102c2a:	e8 04 ef ff ff       	call   c0101b33 <intr_disable>
        return 1;
c0102c2f:	b8 01 00 00 00       	mov    $0x1,%eax
c0102c34:	eb 05                	jmp    c0102c3b <__intr_save+0x36>
    return 0;
c0102c36:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102c3b:	83 c4 14             	add    $0x14,%esp
c0102c3e:	5b                   	pop    %ebx
c0102c3f:	5d                   	pop    %ebp
c0102c40:	c3                   	ret    

c0102c41 <__intr_restore>:
__intr_restore(bool flag) {
c0102c41:	55                   	push   %ebp
c0102c42:	89 e5                	mov    %esp,%ebp
c0102c44:	53                   	push   %ebx
c0102c45:	83 ec 04             	sub    $0x4,%esp
c0102c48:	e8 59 d6 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0102c4d:	05 23 4d 01 00       	add    $0x14d23,%eax
    if (flag) {
c0102c52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102c56:	74 07                	je     c0102c5f <__intr_restore+0x1e>
        intr_enable();
c0102c58:	89 c3                	mov    %eax,%ebx
c0102c5a:	e8 c3 ee ff ff       	call   c0101b22 <intr_enable>
}
c0102c5f:	90                   	nop
c0102c60:	83 c4 04             	add    $0x4,%esp
c0102c63:	5b                   	pop    %ebx
c0102c64:	5d                   	pop    %ebp
c0102c65:	c3                   	ret    

c0102c66 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102c66:	55                   	push   %ebp
c0102c67:	89 e5                	mov    %esp,%ebp
c0102c69:	e8 38 d6 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0102c6e:	05 02 4d 01 00       	add    $0x14d02,%eax
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102c73:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c76:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102c79:	b8 23 00 00 00       	mov    $0x23,%eax
c0102c7e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102c80:	b8 23 00 00 00       	mov    $0x23,%eax
c0102c85:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102c87:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c8c:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102c8e:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c93:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102c95:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c9a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102c9c:	ea a3 2c 10 c0 08 00 	ljmp   $0x8,$0xc0102ca3
}
c0102ca3:	90                   	nop
c0102ca4:	5d                   	pop    %ebp
c0102ca5:	c3                   	ret    

c0102ca6 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102ca6:	55                   	push   %ebp
c0102ca7:	89 e5                	mov    %esp,%ebp
c0102ca9:	e8 f8 d5 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0102cae:	05 c2 4c 01 00       	add    $0x14cc2,%eax
    ts.ts_esp0 = esp0;
c0102cb3:	8b 55 08             	mov    0x8(%ebp),%edx
c0102cb6:	89 90 34 10 00 00    	mov    %edx,0x1034(%eax)
}
c0102cbc:	90                   	nop
c0102cbd:	5d                   	pop    %ebp
c0102cbe:	c3                   	ret    

c0102cbf <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102cbf:	55                   	push   %ebp
c0102cc0:	89 e5                	mov    %esp,%ebp
c0102cc2:	53                   	push   %ebx
c0102cc3:	83 ec 10             	sub    $0x10,%esp
c0102cc6:	e8 df d5 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0102ccb:	81 c3 a5 4c 01 00    	add    $0x14ca5,%ebx
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102cd1:	c7 c0 00 70 11 c0    	mov    $0xc0117000,%eax
c0102cd7:	50                   	push   %eax
c0102cd8:	e8 c9 ff ff ff       	call   c0102ca6 <load_esp0>
c0102cdd:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102ce0:	66 c7 83 38 10 00 00 	movw   $0x10,0x1038(%ebx)
c0102ce7:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102ce9:	66 c7 83 f8 ff ff ff 	movw   $0x68,-0x8(%ebx)
c0102cf0:	68 00 
c0102cf2:	8d 83 30 10 00 00    	lea    0x1030(%ebx),%eax
c0102cf8:	66 89 83 fa ff ff ff 	mov    %ax,-0x6(%ebx)
c0102cff:	8d 83 30 10 00 00    	lea    0x1030(%ebx),%eax
c0102d05:	c1 e8 10             	shr    $0x10,%eax
c0102d08:	88 83 fc ff ff ff    	mov    %al,-0x4(%ebx)
c0102d0e:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
c0102d15:	83 e0 f0             	and    $0xfffffff0,%eax
c0102d18:	83 c8 09             	or     $0x9,%eax
c0102d1b:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
c0102d21:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
c0102d28:	83 e0 ef             	and    $0xffffffef,%eax
c0102d2b:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
c0102d31:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
c0102d38:	83 e0 9f             	and    $0xffffff9f,%eax
c0102d3b:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
c0102d41:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
c0102d48:	83 c8 80             	or     $0xffffff80,%eax
c0102d4b:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
c0102d51:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c0102d58:	83 e0 f0             	and    $0xfffffff0,%eax
c0102d5b:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c0102d61:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c0102d68:	83 e0 ef             	and    $0xffffffef,%eax
c0102d6b:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c0102d71:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c0102d78:	83 e0 df             	and    $0xffffffdf,%eax
c0102d7b:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c0102d81:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c0102d88:	83 c8 40             	or     $0x40,%eax
c0102d8b:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c0102d91:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c0102d98:	83 e0 7f             	and    $0x7f,%eax
c0102d9b:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c0102da1:	8d 83 30 10 00 00    	lea    0x1030(%ebx),%eax
c0102da7:	c1 e8 18             	shr    $0x18,%eax
c0102daa:	88 83 ff ff ff ff    	mov    %al,-0x1(%ebx)

    // reload all segment registers
    lgdt(&gdt_pd);
c0102db0:	8d 83 d0 00 00 00    	lea    0xd0(%ebx),%eax
c0102db6:	50                   	push   %eax
c0102db7:	e8 aa fe ff ff       	call   c0102c66 <lgdt>
c0102dbc:	83 c4 04             	add    $0x4,%esp
c0102dbf:	66 c7 45 fa 28 00    	movw   $0x28,-0x6(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102dc5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0102dc9:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102dcc:	90                   	nop
c0102dcd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102dd0:	c9                   	leave  
c0102dd1:	c3                   	ret    

c0102dd2 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102dd2:	55                   	push   %ebp
c0102dd3:	89 e5                	mov    %esp,%ebp
c0102dd5:	53                   	push   %ebx
c0102dd6:	83 ec 04             	sub    $0x4,%esp
c0102dd9:	e8 cc d4 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0102dde:	81 c3 92 4b 01 00    	add    $0x14b92,%ebx
    pmm_manager = &default_pmm_manager;
c0102de4:	c7 c0 10 8a 11 c0    	mov    $0xc0118a10,%eax
c0102dea:	c7 c2 b0 7a 11 c0    	mov    $0xc0117ab0,%edx
c0102df0:	89 10                	mov    %edx,(%eax)
    cprintf("memory management: %s\n", pmm_manager->name);
c0102df2:	c7 c0 10 8a 11 c0    	mov    $0xc0118a10,%eax
c0102df8:	8b 00                	mov    (%eax),%eax
c0102dfa:	8b 00                	mov    (%eax),%eax
c0102dfc:	83 ec 08             	sub    $0x8,%esp
c0102dff:	50                   	push   %eax
c0102e00:	8d 83 cc ee fe ff    	lea    -0x11134(%ebx),%eax
c0102e06:	50                   	push   %eax
c0102e07:	e8 11 d5 ff ff       	call   c010031d <cprintf>
c0102e0c:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102e0f:	c7 c0 10 8a 11 c0    	mov    $0xc0118a10,%eax
c0102e15:	8b 00                	mov    (%eax),%eax
c0102e17:	8b 40 04             	mov    0x4(%eax),%eax
c0102e1a:	ff d0                	call   *%eax
}
c0102e1c:	90                   	nop
c0102e1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102e20:	c9                   	leave  
c0102e21:	c3                   	ret    

c0102e22 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102e22:	55                   	push   %ebp
c0102e23:	89 e5                	mov    %esp,%ebp
c0102e25:	83 ec 08             	sub    $0x8,%esp
c0102e28:	e8 79 d4 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0102e2d:	05 43 4b 01 00       	add    $0x14b43,%eax
    pmm_manager->init_memmap(base, n);
c0102e32:	c7 c0 10 8a 11 c0    	mov    $0xc0118a10,%eax
c0102e38:	8b 00                	mov    (%eax),%eax
c0102e3a:	8b 40 08             	mov    0x8(%eax),%eax
c0102e3d:	83 ec 08             	sub    $0x8,%esp
c0102e40:	ff 75 0c             	pushl  0xc(%ebp)
c0102e43:	ff 75 08             	pushl  0x8(%ebp)
c0102e46:	ff d0                	call   *%eax
c0102e48:	83 c4 10             	add    $0x10,%esp
}
c0102e4b:	90                   	nop
c0102e4c:	c9                   	leave  
c0102e4d:	c3                   	ret    

c0102e4e <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102e4e:	55                   	push   %ebp
c0102e4f:	89 e5                	mov    %esp,%ebp
c0102e51:	53                   	push   %ebx
c0102e52:	83 ec 14             	sub    $0x14,%esp
c0102e55:	e8 50 d4 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0102e5a:	81 c3 16 4b 01 00    	add    $0x14b16,%ebx
    struct Page *page=NULL;
c0102e60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102e67:	e8 99 fd ff ff       	call   c0102c05 <__intr_save>
c0102e6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102e6f:	c7 c0 10 8a 11 c0    	mov    $0xc0118a10,%eax
c0102e75:	8b 00                	mov    (%eax),%eax
c0102e77:	8b 40 0c             	mov    0xc(%eax),%eax
c0102e7a:	83 ec 0c             	sub    $0xc,%esp
c0102e7d:	ff 75 08             	pushl  0x8(%ebp)
c0102e80:	ff d0                	call   *%eax
c0102e82:	83 c4 10             	add    $0x10,%esp
c0102e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102e88:	83 ec 0c             	sub    $0xc,%esp
c0102e8b:	ff 75 f0             	pushl  -0x10(%ebp)
c0102e8e:	e8 ae fd ff ff       	call   c0102c41 <__intr_restore>
c0102e93:	83 c4 10             	add    $0x10,%esp
    return page;
c0102e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102e99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102e9c:	c9                   	leave  
c0102e9d:	c3                   	ret    

c0102e9e <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102e9e:	55                   	push   %ebp
c0102e9f:	89 e5                	mov    %esp,%ebp
c0102ea1:	53                   	push   %ebx
c0102ea2:	83 ec 14             	sub    $0x14,%esp
c0102ea5:	e8 00 d4 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0102eaa:	81 c3 c6 4a 01 00    	add    $0x14ac6,%ebx
    bool intr_flag;
    local_intr_save(intr_flag);
c0102eb0:	e8 50 fd ff ff       	call   c0102c05 <__intr_save>
c0102eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102eb8:	c7 c0 10 8a 11 c0    	mov    $0xc0118a10,%eax
c0102ebe:	8b 00                	mov    (%eax),%eax
c0102ec0:	8b 40 10             	mov    0x10(%eax),%eax
c0102ec3:	83 ec 08             	sub    $0x8,%esp
c0102ec6:	ff 75 0c             	pushl  0xc(%ebp)
c0102ec9:	ff 75 08             	pushl  0x8(%ebp)
c0102ecc:	ff d0                	call   *%eax
c0102ece:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102ed1:	83 ec 0c             	sub    $0xc,%esp
c0102ed4:	ff 75 f4             	pushl  -0xc(%ebp)
c0102ed7:	e8 65 fd ff ff       	call   c0102c41 <__intr_restore>
c0102edc:	83 c4 10             	add    $0x10,%esp
}
c0102edf:	90                   	nop
c0102ee0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102ee3:	c9                   	leave  
c0102ee4:	c3                   	ret    

c0102ee5 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102ee5:	55                   	push   %ebp
c0102ee6:	89 e5                	mov    %esp,%ebp
c0102ee8:	53                   	push   %ebx
c0102ee9:	83 ec 14             	sub    $0x14,%esp
c0102eec:	e8 b9 d3 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0102ef1:	81 c3 7f 4a 01 00    	add    $0x14a7f,%ebx
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102ef7:	e8 09 fd ff ff       	call   c0102c05 <__intr_save>
c0102efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102eff:	c7 c0 10 8a 11 c0    	mov    $0xc0118a10,%eax
c0102f05:	8b 00                	mov    (%eax),%eax
c0102f07:	8b 40 14             	mov    0x14(%eax),%eax
c0102f0a:	ff d0                	call   *%eax
c0102f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102f0f:	83 ec 0c             	sub    $0xc,%esp
c0102f12:	ff 75 f4             	pushl  -0xc(%ebp)
c0102f15:	e8 27 fd ff ff       	call   c0102c41 <__intr_restore>
c0102f1a:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102f20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102f23:	c9                   	leave  
c0102f24:	c3                   	ret    

c0102f25 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102f25:	55                   	push   %ebp
c0102f26:	89 e5                	mov    %esp,%ebp
c0102f28:	57                   	push   %edi
c0102f29:	56                   	push   %esi
c0102f2a:	53                   	push   %ebx
c0102f2b:	83 ec 7c             	sub    $0x7c,%esp
c0102f2e:	e8 d0 14 00 00       	call   c0104403 <__x86.get_pc_thunk.si>
c0102f33:	81 c6 3d 4a 01 00    	add    $0x14a3d,%esi
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102f39:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102f40:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102f47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102f4e:	83 ec 0c             	sub    $0xc,%esp
c0102f51:	8d 86 e3 ee fe ff    	lea    -0x1111d(%esi),%eax
c0102f57:	50                   	push   %eax
c0102f58:	89 f3                	mov    %esi,%ebx
c0102f5a:	e8 be d3 ff ff       	call   c010031d <cprintf>
c0102f5f:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102f62:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f69:	e9 02 01 00 00       	jmp    c0103070 <page_init+0x14b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102f6e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f71:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f74:	89 d0                	mov    %edx,%eax
c0102f76:	c1 e0 02             	shl    $0x2,%eax
c0102f79:	01 d0                	add    %edx,%eax
c0102f7b:	c1 e0 02             	shl    $0x2,%eax
c0102f7e:	01 c8                	add    %ecx,%eax
c0102f80:	8b 50 08             	mov    0x8(%eax),%edx
c0102f83:	8b 40 04             	mov    0x4(%eax),%eax
c0102f86:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102f89:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102f8c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f92:	89 d0                	mov    %edx,%eax
c0102f94:	c1 e0 02             	shl    $0x2,%eax
c0102f97:	01 d0                	add    %edx,%eax
c0102f99:	c1 e0 02             	shl    $0x2,%eax
c0102f9c:	01 c8                	add    %ecx,%eax
c0102f9e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102fa1:	8b 58 10             	mov    0x10(%eax),%ebx
c0102fa4:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102fa7:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102faa:	01 c8                	add    %ecx,%eax
c0102fac:	11 da                	adc    %ebx,%edx
c0102fae:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102fb1:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102fb4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fb7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fba:	89 d0                	mov    %edx,%eax
c0102fbc:	c1 e0 02             	shl    $0x2,%eax
c0102fbf:	01 d0                	add    %edx,%eax
c0102fc1:	c1 e0 02             	shl    $0x2,%eax
c0102fc4:	01 c8                	add    %ecx,%eax
c0102fc6:	83 c0 14             	add    $0x14,%eax
c0102fc9:	8b 00                	mov    (%eax),%eax
c0102fcb:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0102fd1:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102fd4:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102fd7:	83 c0 ff             	add    $0xffffffff,%eax
c0102fda:	83 d2 ff             	adc    $0xffffffff,%edx
c0102fdd:	89 c1                	mov    %eax,%ecx
c0102fdf:	89 d3                	mov    %edx,%ebx
c0102fe1:	8b 7d c4             	mov    -0x3c(%ebp),%edi
c0102fe4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fe7:	89 d0                	mov    %edx,%eax
c0102fe9:	c1 e0 02             	shl    $0x2,%eax
c0102fec:	01 d0                	add    %edx,%eax
c0102fee:	c1 e0 02             	shl    $0x2,%eax
c0102ff1:	01 f8                	add    %edi,%eax
c0102ff3:	8b 50 10             	mov    0x10(%eax),%edx
c0102ff6:	8b 40 0c             	mov    0xc(%eax),%eax
c0102ff9:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
c0102fff:	53                   	push   %ebx
c0103000:	51                   	push   %ecx
c0103001:	ff 75 a4             	pushl  -0x5c(%ebp)
c0103004:	ff 75 a0             	pushl  -0x60(%ebp)
c0103007:	52                   	push   %edx
c0103008:	50                   	push   %eax
c0103009:	8d 86 f0 ee fe ff    	lea    -0x11110(%esi),%eax
c010300f:	50                   	push   %eax
c0103010:	89 f3                	mov    %esi,%ebx
c0103012:	e8 06 d3 ff ff       	call   c010031d <cprintf>
c0103017:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c010301a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010301d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103020:	89 d0                	mov    %edx,%eax
c0103022:	c1 e0 02             	shl    $0x2,%eax
c0103025:	01 d0                	add    %edx,%eax
c0103027:	c1 e0 02             	shl    $0x2,%eax
c010302a:	01 c8                	add    %ecx,%eax
c010302c:	83 c0 14             	add    $0x14,%eax
c010302f:	8b 00                	mov    (%eax),%eax
c0103031:	83 f8 01             	cmp    $0x1,%eax
c0103034:	75 36                	jne    c010306c <page_init+0x147>
            if (maxpa < end && begin < KMEMSIZE) {
c0103036:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103039:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010303c:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c010303f:	77 2b                	ja     c010306c <page_init+0x147>
c0103041:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0103044:	72 05                	jb     c010304b <page_init+0x126>
c0103046:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0103049:	73 21                	jae    c010306c <page_init+0x147>
c010304b:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010304f:	77 1b                	ja     c010306c <page_init+0x147>
c0103051:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103055:	72 09                	jb     c0103060 <page_init+0x13b>
c0103057:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
c010305e:	77 0c                	ja     c010306c <page_init+0x147>
                maxpa = end;
c0103060:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103063:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103066:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103069:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c010306c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103070:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103073:	8b 00                	mov    (%eax),%eax
c0103075:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103078:	0f 8c f0 fe ff ff    	jl     c0102f6e <page_init+0x49>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c010307e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103082:	72 1d                	jb     c01030a1 <page_init+0x17c>
c0103084:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103088:	77 09                	ja     c0103093 <page_init+0x16e>
c010308a:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103091:	76 0e                	jbe    c01030a1 <page_init+0x17c>
        maxpa = KMEMSIZE;
c0103093:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010309a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01030a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01030a7:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01030ab:	c1 ea 0c             	shr    $0xc,%edx
c01030ae:	89 c1                	mov    %eax,%ecx
c01030b0:	89 d3                	mov    %edx,%ebx
c01030b2:	89 c8                	mov    %ecx,%eax
c01030b4:	89 86 10 10 00 00    	mov    %eax,0x1010(%esi)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01030ba:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c01030c1:	c7 c0 28 8a 11 c0    	mov    $0xc0118a28,%eax
c01030c7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01030ca:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01030cd:	01 d0                	add    %edx,%eax
c01030cf:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01030d2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01030d5:	ba 00 00 00 00       	mov    $0x0,%edx
c01030da:	f7 75 c0             	divl   -0x40(%ebp)
c01030dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01030e0:	29 d0                	sub    %edx,%eax
c01030e2:	89 c2                	mov    %eax,%edx
c01030e4:	c7 c0 18 8a 11 c0    	mov    $0xc0118a18,%eax
c01030ea:	89 10                	mov    %edx,(%eax)

    for (i = 0; i < npage; i ++) {
c01030ec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01030f3:	eb 31                	jmp    c0103126 <page_init+0x201>
        SetPageReserved(pages + i);
c01030f5:	c7 c0 18 8a 11 c0    	mov    $0xc0118a18,%eax
c01030fb:	8b 08                	mov    (%eax),%ecx
c01030fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103100:	89 d0                	mov    %edx,%eax
c0103102:	c1 e0 02             	shl    $0x2,%eax
c0103105:	01 d0                	add    %edx,%eax
c0103107:	c1 e0 02             	shl    $0x2,%eax
c010310a:	01 c8                	add    %ecx,%eax
c010310c:	83 c0 04             	add    $0x4,%eax
c010310f:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0103116:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103119:	8b 45 90             	mov    -0x70(%ebp),%eax
c010311c:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010311f:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0103122:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103126:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103129:	8b 86 10 10 00 00    	mov    0x1010(%esi),%eax
c010312f:	39 c2                	cmp    %eax,%edx
c0103131:	72 c2                	jb     c01030f5 <page_init+0x1d0>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103133:	8b 96 10 10 00 00    	mov    0x1010(%esi),%edx
c0103139:	89 d0                	mov    %edx,%eax
c010313b:	c1 e0 02             	shl    $0x2,%eax
c010313e:	01 d0                	add    %edx,%eax
c0103140:	c1 e0 02             	shl    $0x2,%eax
c0103143:	89 c2                	mov    %eax,%edx
c0103145:	c7 c0 18 8a 11 c0    	mov    $0xc0118a18,%eax
c010314b:	8b 00                	mov    (%eax),%eax
c010314d:	01 d0                	add    %edx,%eax
c010314f:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103152:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0103159:	77 1d                	ja     c0103178 <page_init+0x253>
c010315b:	ff 75 b8             	pushl  -0x48(%ebp)
c010315e:	8d 86 20 ef fe ff    	lea    -0x110e0(%esi),%eax
c0103164:	50                   	push   %eax
c0103165:	68 db 00 00 00       	push   $0xdb
c010316a:	8d 86 44 ef fe ff    	lea    -0x110bc(%esi),%eax
c0103170:	50                   	push   %eax
c0103171:	89 f3                	mov    %esi,%ebx
c0103173:	e8 55 d3 ff ff       	call   c01004cd <__panic>
c0103178:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010317b:	05 00 00 00 40       	add    $0x40000000,%eax
c0103180:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103183:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010318a:	e9 79 01 00 00       	jmp    c0103308 <page_init+0x3e3>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010318f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103192:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103195:	89 d0                	mov    %edx,%eax
c0103197:	c1 e0 02             	shl    $0x2,%eax
c010319a:	01 d0                	add    %edx,%eax
c010319c:	c1 e0 02             	shl    $0x2,%eax
c010319f:	01 c8                	add    %ecx,%eax
c01031a1:	8b 50 08             	mov    0x8(%eax),%edx
c01031a4:	8b 40 04             	mov    0x4(%eax),%eax
c01031a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01031aa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01031ad:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01031b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031b3:	89 d0                	mov    %edx,%eax
c01031b5:	c1 e0 02             	shl    $0x2,%eax
c01031b8:	01 d0                	add    %edx,%eax
c01031ba:	c1 e0 02             	shl    $0x2,%eax
c01031bd:	01 c8                	add    %ecx,%eax
c01031bf:	8b 48 0c             	mov    0xc(%eax),%ecx
c01031c2:	8b 58 10             	mov    0x10(%eax),%ebx
c01031c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01031c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01031cb:	01 c8                	add    %ecx,%eax
c01031cd:	11 da                	adc    %ebx,%edx
c01031cf:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01031d2:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01031d5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01031d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031db:	89 d0                	mov    %edx,%eax
c01031dd:	c1 e0 02             	shl    $0x2,%eax
c01031e0:	01 d0                	add    %edx,%eax
c01031e2:	c1 e0 02             	shl    $0x2,%eax
c01031e5:	01 c8                	add    %ecx,%eax
c01031e7:	83 c0 14             	add    $0x14,%eax
c01031ea:	8b 00                	mov    (%eax),%eax
c01031ec:	83 f8 01             	cmp    $0x1,%eax
c01031ef:	0f 85 0f 01 00 00    	jne    c0103304 <page_init+0x3df>
            if (begin < freemem) {
c01031f5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01031f8:	ba 00 00 00 00       	mov    $0x0,%edx
c01031fd:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0103200:	77 17                	ja     c0103219 <page_init+0x2f4>
c0103202:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0103205:	72 05                	jb     c010320c <page_init+0x2e7>
c0103207:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010320a:	73 0d                	jae    c0103219 <page_init+0x2f4>
                begin = freemem;
c010320c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010320f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103212:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103219:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010321d:	72 1d                	jb     c010323c <page_init+0x317>
c010321f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103223:	77 09                	ja     c010322e <page_init+0x309>
c0103225:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010322c:	76 0e                	jbe    c010323c <page_init+0x317>
                end = KMEMSIZE;
c010322e:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103235:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010323c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010323f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103242:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103245:	0f 87 b9 00 00 00    	ja     c0103304 <page_init+0x3df>
c010324b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010324e:	72 09                	jb     c0103259 <page_init+0x334>
c0103250:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103253:	0f 83 ab 00 00 00    	jae    c0103304 <page_init+0x3df>
                begin = ROUNDUP(begin, PGSIZE);
c0103259:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0103260:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103263:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103266:	01 d0                	add    %edx,%eax
c0103268:	83 e8 01             	sub    $0x1,%eax
c010326b:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010326e:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103271:	ba 00 00 00 00       	mov    $0x0,%edx
c0103276:	f7 75 b0             	divl   -0x50(%ebp)
c0103279:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010327c:	29 d0                	sub    %edx,%eax
c010327e:	ba 00 00 00 00       	mov    $0x0,%edx
c0103283:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103286:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103289:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010328c:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010328f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103292:	ba 00 00 00 00       	mov    $0x0,%edx
c0103297:	89 c7                	mov    %eax,%edi
c0103299:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010329f:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01032a2:	89 d0                	mov    %edx,%eax
c01032a4:	83 e0 00             	and    $0x0,%eax
c01032a7:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01032aa:	8b 45 80             	mov    -0x80(%ebp),%eax
c01032ad:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01032b0:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01032b3:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01032b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032b9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01032bc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01032bf:	77 43                	ja     c0103304 <page_init+0x3df>
c01032c1:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01032c4:	72 05                	jb     c01032cb <page_init+0x3a6>
c01032c6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01032c9:	73 39                	jae    c0103304 <page_init+0x3df>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01032cb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01032ce:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01032d1:	2b 45 d0             	sub    -0x30(%ebp),%eax
c01032d4:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c01032d7:	89 c3                	mov    %eax,%ebx
c01032d9:	89 d6                	mov    %edx,%esi
c01032db:	89 d8                	mov    %ebx,%eax
c01032dd:	89 f2                	mov    %esi,%edx
c01032df:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01032e3:	c1 ea 0c             	shr    $0xc,%edx
c01032e6:	89 c3                	mov    %eax,%ebx
c01032e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032eb:	83 ec 0c             	sub    $0xc,%esp
c01032ee:	50                   	push   %eax
c01032ef:	e8 b6 f7 ff ff       	call   c0102aaa <pa2page>
c01032f4:	83 c4 10             	add    $0x10,%esp
c01032f7:	83 ec 08             	sub    $0x8,%esp
c01032fa:	53                   	push   %ebx
c01032fb:	50                   	push   %eax
c01032fc:	e8 21 fb ff ff       	call   c0102e22 <init_memmap>
c0103301:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i ++) {
c0103304:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103308:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010330b:	8b 00                	mov    (%eax),%eax
c010330d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103310:	0f 8c 79 fe ff ff    	jl     c010318f <page_init+0x26a>
                }
            }
        }
    }
}
c0103316:	90                   	nop
c0103317:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010331a:	5b                   	pop    %ebx
c010331b:	5e                   	pop    %esi
c010331c:	5f                   	pop    %edi
c010331d:	5d                   	pop    %ebp
c010331e:	c3                   	ret    

c010331f <enable_paging>:

static void
enable_paging(void) {
c010331f:	55                   	push   %ebp
c0103320:	89 e5                	mov    %esp,%ebp
c0103322:	83 ec 10             	sub    $0x10,%esp
c0103325:	e8 7c cf ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c010332a:	05 46 46 01 00       	add    $0x14646,%eax
    lcr3(boot_cr3);
c010332f:	c7 c0 14 8a 11 c0    	mov    $0xc0118a14,%eax
c0103335:	8b 00                	mov    (%eax),%eax
c0103337:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010333a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010333d:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0103340:	0f 20 c0             	mov    %cr0,%eax
c0103343:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0103346:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0103349:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010334c:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0103353:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0103357:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010335a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010335d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103360:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0103363:	90                   	nop
c0103364:	c9                   	leave  
c0103365:	c3                   	ret    

c0103366 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103366:	55                   	push   %ebp
c0103367:	89 e5                	mov    %esp,%ebp
c0103369:	53                   	push   %ebx
c010336a:	83 ec 24             	sub    $0x24,%esp
c010336d:	e8 38 cf ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0103372:	81 c3 fe 45 01 00    	add    $0x145fe,%ebx
    assert(PGOFF(la) == PGOFF(pa));
c0103378:	8b 45 0c             	mov    0xc(%ebp),%eax
c010337b:	33 45 14             	xor    0x14(%ebp),%eax
c010337e:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103383:	85 c0                	test   %eax,%eax
c0103385:	74 1f                	je     c01033a6 <boot_map_segment+0x40>
c0103387:	8d 83 52 ef fe ff    	lea    -0x110ae(%ebx),%eax
c010338d:	50                   	push   %eax
c010338e:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103394:	50                   	push   %eax
c0103395:	68 04 01 00 00       	push   $0x104
c010339a:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c01033a0:	50                   	push   %eax
c01033a1:	e8 27 d1 ff ff       	call   c01004cd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01033a6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01033ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033b0:	25 ff 0f 00 00       	and    $0xfff,%eax
c01033b5:	89 c2                	mov    %eax,%edx
c01033b7:	8b 45 10             	mov    0x10(%ebp),%eax
c01033ba:	01 c2                	add    %eax,%edx
c01033bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033bf:	01 d0                	add    %edx,%eax
c01033c1:	83 e8 01             	sub    $0x1,%eax
c01033c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01033c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033ca:	ba 00 00 00 00       	mov    $0x0,%edx
c01033cf:	f7 75 f0             	divl   -0x10(%ebp)
c01033d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033d5:	29 d0                	sub    %edx,%eax
c01033d7:	c1 e8 0c             	shr    $0xc,%eax
c01033da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01033dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01033e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01033eb:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01033ee:	8b 45 14             	mov    0x14(%ebp),%eax
c01033f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01033f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01033fc:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01033ff:	eb 5d                	jmp    c010345e <boot_map_segment+0xf8>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103401:	83 ec 04             	sub    $0x4,%esp
c0103404:	6a 01                	push   $0x1
c0103406:	ff 75 0c             	pushl  0xc(%ebp)
c0103409:	ff 75 08             	pushl  0x8(%ebp)
c010340c:	e8 d7 01 00 00       	call   c01035e8 <get_pte>
c0103411:	83 c4 10             	add    $0x10,%esp
c0103414:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103417:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010341b:	75 1f                	jne    c010343c <boot_map_segment+0xd6>
c010341d:	8d 83 7e ef fe ff    	lea    -0x11082(%ebx),%eax
c0103423:	50                   	push   %eax
c0103424:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c010342a:	50                   	push   %eax
c010342b:	68 0a 01 00 00       	push   $0x10a
c0103430:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103436:	50                   	push   %eax
c0103437:	e8 91 d0 ff ff       	call   c01004cd <__panic>
        *ptep = pa | PTE_P | perm;
c010343c:	8b 45 14             	mov    0x14(%ebp),%eax
c010343f:	0b 45 18             	or     0x18(%ebp),%eax
c0103442:	83 c8 01             	or     $0x1,%eax
c0103445:	89 c2                	mov    %eax,%edx
c0103447:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010344a:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010344c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103450:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0103457:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010345e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103462:	75 9d                	jne    c0103401 <boot_map_segment+0x9b>
    }
}
c0103464:	90                   	nop
c0103465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103468:	c9                   	leave  
c0103469:	c3                   	ret    

c010346a <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010346a:	55                   	push   %ebp
c010346b:	89 e5                	mov    %esp,%ebp
c010346d:	53                   	push   %ebx
c010346e:	83 ec 14             	sub    $0x14,%esp
c0103471:	e8 34 ce ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0103476:	81 c3 fa 44 01 00    	add    $0x144fa,%ebx
    struct Page *p = alloc_page();
c010347c:	83 ec 0c             	sub    $0xc,%esp
c010347f:	6a 01                	push   $0x1
c0103481:	e8 c8 f9 ff ff       	call   c0102e4e <alloc_pages>
c0103486:	83 c4 10             	add    $0x10,%esp
c0103489:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010348c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103490:	75 1b                	jne    c01034ad <boot_alloc_page+0x43>
        panic("boot_alloc_page failed.\n");
c0103492:	83 ec 04             	sub    $0x4,%esp
c0103495:	8d 83 8b ef fe ff    	lea    -0x11075(%ebx),%eax
c010349b:	50                   	push   %eax
c010349c:	68 16 01 00 00       	push   $0x116
c01034a1:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c01034a7:	50                   	push   %eax
c01034a8:	e8 20 d0 ff ff       	call   c01004cd <__panic>
    }
    return page2kva(p);
c01034ad:	83 ec 0c             	sub    $0xc,%esp
c01034b0:	ff 75 f4             	pushl  -0xc(%ebp)
c01034b3:	e8 50 f6 ff ff       	call   c0102b08 <page2kva>
c01034b8:	83 c4 10             	add    $0x10,%esp
}
c01034bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01034be:	c9                   	leave  
c01034bf:	c3                   	ret    

c01034c0 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01034c0:	55                   	push   %ebp
c01034c1:	89 e5                	mov    %esp,%ebp
c01034c3:	53                   	push   %ebx
c01034c4:	83 ec 14             	sub    $0x14,%esp
c01034c7:	e8 de cd ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c01034cc:	81 c3 a4 44 01 00    	add    $0x144a4,%ebx
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01034d2:	e8 fb f8 ff ff       	call   c0102dd2 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01034d7:	e8 49 fa ff ff       	call   c0102f25 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01034dc:	e8 e2 02 00 00       	call   c01037c3 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01034e1:	e8 84 ff ff ff       	call   c010346a <boot_alloc_page>
c01034e6:	89 83 14 10 00 00    	mov    %eax,0x1014(%ebx)
    memset(boot_pgdir, 0, PGSIZE);
c01034ec:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c01034f2:	83 ec 04             	sub    $0x4,%esp
c01034f5:	68 00 10 00 00       	push   $0x1000
c01034fa:	6a 00                	push   $0x0
c01034fc:	50                   	push   %eax
c01034fd:	e8 18 24 00 00       	call   c010591a <memset>
c0103502:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
c0103505:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c010350b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010350e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103515:	77 1b                	ja     c0103532 <pmm_init+0x72>
c0103517:	ff 75 f4             	pushl  -0xc(%ebp)
c010351a:	8d 83 20 ef fe ff    	lea    -0x110e0(%ebx),%eax
c0103520:	50                   	push   %eax
c0103521:	68 30 01 00 00       	push   $0x130
c0103526:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c010352c:	50                   	push   %eax
c010352d:	e8 9b cf ff ff       	call   c01004cd <__panic>
c0103532:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103535:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010353b:	c7 c0 14 8a 11 c0    	mov    $0xc0118a14,%eax
c0103541:	89 10                	mov    %edx,(%eax)

    check_pgdir();
c0103543:	e8 b2 02 00 00       	call   c01037fa <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103548:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c010354e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103551:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103558:	77 1b                	ja     c0103575 <pmm_init+0xb5>
c010355a:	ff 75 f0             	pushl  -0x10(%ebp)
c010355d:	8d 83 20 ef fe ff    	lea    -0x110e0(%ebx),%eax
c0103563:	50                   	push   %eax
c0103564:	68 38 01 00 00       	push   $0x138
c0103569:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c010356f:	50                   	push   %eax
c0103570:	e8 58 cf ff ff       	call   c01004cd <__panic>
c0103575:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103578:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010357e:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103584:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103589:	83 ca 03             	or     $0x3,%edx
c010358c:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010358e:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103594:	83 ec 0c             	sub    $0xc,%esp
c0103597:	6a 02                	push   $0x2
c0103599:	6a 00                	push   $0x0
c010359b:	68 00 00 00 38       	push   $0x38000000
c01035a0:	68 00 00 00 c0       	push   $0xc0000000
c01035a5:	50                   	push   %eax
c01035a6:	e8 bb fd ff ff       	call   c0103366 <boot_map_segment>
c01035ab:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01035ae:	8b 93 14 10 00 00    	mov    0x1014(%ebx),%edx
c01035b4:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c01035ba:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01035c0:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01035c2:	e8 58 fd ff ff       	call   c010331f <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01035c7:	e8 f3 f6 ff ff       	call   c0102cbf <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01035cc:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c01035d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01035d8:	e8 41 08 00 00       	call   c0103e1e <check_boot_pgdir>

    print_pgdir();
c01035dd:	e8 b4 0c 00 00       	call   c0104296 <print_pgdir>

}
c01035e2:	90                   	nop
c01035e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01035e6:	c9                   	leave  
c01035e7:	c3                   	ret    

c01035e8 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01035e8:	55                   	push   %ebp
c01035e9:	89 e5                	mov    %esp,%ebp
c01035eb:	e8 b6 cc ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01035f0:	05 80 43 01 00       	add    $0x14380,%eax
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c01035f5:	90                   	nop
c01035f6:	5d                   	pop    %ebp
c01035f7:	c3                   	ret    

c01035f8 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01035f8:	55                   	push   %ebp
c01035f9:	89 e5                	mov    %esp,%ebp
c01035fb:	83 ec 18             	sub    $0x18,%esp
c01035fe:	e8 a3 cc ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0103603:	05 6d 43 01 00       	add    $0x1436d,%eax
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103608:	6a 00                	push   $0x0
c010360a:	ff 75 0c             	pushl  0xc(%ebp)
c010360d:	ff 75 08             	pushl  0x8(%ebp)
c0103610:	e8 d3 ff ff ff       	call   c01035e8 <get_pte>
c0103615:	83 c4 0c             	add    $0xc,%esp
c0103618:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010361b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010361f:	74 08                	je     c0103629 <get_page+0x31>
        *ptep_store = ptep;
c0103621:	8b 45 10             	mov    0x10(%ebp),%eax
c0103624:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103627:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103629:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010362d:	74 1f                	je     c010364e <get_page+0x56>
c010362f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103632:	8b 00                	mov    (%eax),%eax
c0103634:	83 e0 01             	and    $0x1,%eax
c0103637:	85 c0                	test   %eax,%eax
c0103639:	74 13                	je     c010364e <get_page+0x56>
        return pa2page(*ptep);
c010363b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010363e:	8b 00                	mov    (%eax),%eax
c0103640:	83 ec 0c             	sub    $0xc,%esp
c0103643:	50                   	push   %eax
c0103644:	e8 61 f4 ff ff       	call   c0102aaa <pa2page>
c0103649:	83 c4 10             	add    $0x10,%esp
c010364c:	eb 05                	jmp    c0103653 <get_page+0x5b>
    }
    return NULL;
c010364e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103653:	c9                   	leave  
c0103654:	c3                   	ret    

c0103655 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103655:	55                   	push   %ebp
c0103656:	89 e5                	mov    %esp,%ebp
c0103658:	e8 49 cc ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c010365d:	05 13 43 01 00       	add    $0x14313,%eax
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0103662:	90                   	nop
c0103663:	5d                   	pop    %ebp
c0103664:	c3                   	ret    

c0103665 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103665:	55                   	push   %ebp
c0103666:	89 e5                	mov    %esp,%ebp
c0103668:	83 ec 10             	sub    $0x10,%esp
c010366b:	e8 36 cc ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0103670:	05 00 43 01 00       	add    $0x14300,%eax
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103675:	6a 00                	push   $0x0
c0103677:	ff 75 0c             	pushl  0xc(%ebp)
c010367a:	ff 75 08             	pushl  0x8(%ebp)
c010367d:	e8 66 ff ff ff       	call   c01035e8 <get_pte>
c0103682:	83 c4 0c             	add    $0xc,%esp
c0103685:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c0103688:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010368c:	74 11                	je     c010369f <page_remove+0x3a>
        page_remove_pte(pgdir, la, ptep);
c010368e:	ff 75 fc             	pushl  -0x4(%ebp)
c0103691:	ff 75 0c             	pushl  0xc(%ebp)
c0103694:	ff 75 08             	pushl  0x8(%ebp)
c0103697:	e8 b9 ff ff ff       	call   c0103655 <page_remove_pte>
c010369c:	83 c4 0c             	add    $0xc,%esp
    }
}
c010369f:	90                   	nop
c01036a0:	c9                   	leave  
c01036a1:	c3                   	ret    

c01036a2 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01036a2:	55                   	push   %ebp
c01036a3:	89 e5                	mov    %esp,%ebp
c01036a5:	83 ec 18             	sub    $0x18,%esp
c01036a8:	e8 f9 cb ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01036ad:	05 c3 42 01 00       	add    $0x142c3,%eax
    pte_t *ptep = get_pte(pgdir, la, 1);
c01036b2:	6a 01                	push   $0x1
c01036b4:	ff 75 10             	pushl  0x10(%ebp)
c01036b7:	ff 75 08             	pushl  0x8(%ebp)
c01036ba:	e8 29 ff ff ff       	call   c01035e8 <get_pte>
c01036bf:	83 c4 0c             	add    $0xc,%esp
c01036c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01036c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01036c9:	75 0a                	jne    c01036d5 <page_insert+0x33>
        return -E_NO_MEM;
c01036cb:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01036d0:	e9 88 00 00 00       	jmp    c010375d <page_insert+0xbb>
    }
    page_ref_inc(page);
c01036d5:	ff 75 0c             	pushl  0xc(%ebp)
c01036d8:	e8 e6 f4 ff ff       	call   c0102bc3 <page_ref_inc>
c01036dd:	83 c4 04             	add    $0x4,%esp
    if (*ptep & PTE_P) {
c01036e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036e3:	8b 00                	mov    (%eax),%eax
c01036e5:	83 e0 01             	and    $0x1,%eax
c01036e8:	85 c0                	test   %eax,%eax
c01036ea:	74 40                	je     c010372c <page_insert+0x8a>
        struct Page *p = pte2page(*ptep);
c01036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ef:	8b 00                	mov    (%eax),%eax
c01036f1:	83 ec 0c             	sub    $0xc,%esp
c01036f4:	50                   	push   %eax
c01036f5:	e8 67 f4 ff ff       	call   c0102b61 <pte2page>
c01036fa:	83 c4 10             	add    $0x10,%esp
c01036fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0103700:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103703:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103706:	75 10                	jne    c0103718 <page_insert+0x76>
            page_ref_dec(page);
c0103708:	83 ec 0c             	sub    $0xc,%esp
c010370b:	ff 75 0c             	pushl  0xc(%ebp)
c010370e:	e8 d1 f4 ff ff       	call   c0102be4 <page_ref_dec>
c0103713:	83 c4 10             	add    $0x10,%esp
c0103716:	eb 14                	jmp    c010372c <page_insert+0x8a>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103718:	83 ec 04             	sub    $0x4,%esp
c010371b:	ff 75 f4             	pushl  -0xc(%ebp)
c010371e:	ff 75 10             	pushl  0x10(%ebp)
c0103721:	ff 75 08             	pushl  0x8(%ebp)
c0103724:	e8 2c ff ff ff       	call   c0103655 <page_remove_pte>
c0103729:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010372c:	83 ec 0c             	sub    $0xc,%esp
c010372f:	ff 75 0c             	pushl  0xc(%ebp)
c0103732:	e8 56 f3 ff ff       	call   c0102a8d <page2pa>
c0103737:	83 c4 10             	add    $0x10,%esp
c010373a:	0b 45 14             	or     0x14(%ebp),%eax
c010373d:	83 c8 01             	or     $0x1,%eax
c0103740:	89 c2                	mov    %eax,%edx
c0103742:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103745:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103747:	83 ec 08             	sub    $0x8,%esp
c010374a:	ff 75 10             	pushl  0x10(%ebp)
c010374d:	ff 75 08             	pushl  0x8(%ebp)
c0103750:	e8 0a 00 00 00       	call   c010375f <tlb_invalidate>
c0103755:	83 c4 10             	add    $0x10,%esp
    return 0;
c0103758:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010375d:	c9                   	leave  
c010375e:	c3                   	ret    

c010375f <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010375f:	55                   	push   %ebp
c0103760:	89 e5                	mov    %esp,%ebp
c0103762:	53                   	push   %ebx
c0103763:	83 ec 14             	sub    $0x14,%esp
c0103766:	e8 3b cb ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c010376b:	05 05 42 01 00       	add    $0x14205,%eax
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103770:	0f 20 da             	mov    %cr3,%edx
c0103773:	89 55 f0             	mov    %edx,-0x10(%ebp)
    return cr3;
c0103776:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    if (rcr3() == PADDR(pgdir)) {
c0103779:	8b 55 08             	mov    0x8(%ebp),%edx
c010377c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010377f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103786:	77 1d                	ja     c01037a5 <tlb_invalidate+0x46>
c0103788:	ff 75 f4             	pushl  -0xc(%ebp)
c010378b:	8d 90 20 ef fe ff    	lea    -0x110e0(%eax),%edx
c0103791:	52                   	push   %edx
c0103792:	68 d8 01 00 00       	push   $0x1d8
c0103797:	8d 90 44 ef fe ff    	lea    -0x110bc(%eax),%edx
c010379d:	52                   	push   %edx
c010379e:	89 c3                	mov    %eax,%ebx
c01037a0:	e8 28 cd ff ff       	call   c01004cd <__panic>
c01037a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037a8:	05 00 00 00 40       	add    $0x40000000,%eax
c01037ad:	39 c8                	cmp    %ecx,%eax
c01037af:	75 0c                	jne    c01037bd <tlb_invalidate+0x5e>
        invlpg((void *)la);
c01037b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01037b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037ba:	0f 01 38             	invlpg (%eax)
    }
}
c01037bd:	90                   	nop
c01037be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01037c1:	c9                   	leave  
c01037c2:	c3                   	ret    

c01037c3 <check_alloc_page>:

static void
check_alloc_page(void) {
c01037c3:	55                   	push   %ebp
c01037c4:	89 e5                	mov    %esp,%ebp
c01037c6:	53                   	push   %ebx
c01037c7:	83 ec 04             	sub    $0x4,%esp
c01037ca:	e8 db ca ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c01037cf:	81 c3 a1 41 01 00    	add    $0x141a1,%ebx
    pmm_manager->check();
c01037d5:	c7 c0 10 8a 11 c0    	mov    $0xc0118a10,%eax
c01037db:	8b 00                	mov    (%eax),%eax
c01037dd:	8b 40 18             	mov    0x18(%eax),%eax
c01037e0:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01037e2:	83 ec 0c             	sub    $0xc,%esp
c01037e5:	8d 83 a4 ef fe ff    	lea    -0x1105c(%ebx),%eax
c01037eb:	50                   	push   %eax
c01037ec:	e8 2c cb ff ff       	call   c010031d <cprintf>
c01037f1:	83 c4 10             	add    $0x10,%esp
}
c01037f4:	90                   	nop
c01037f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01037f8:	c9                   	leave  
c01037f9:	c3                   	ret    

c01037fa <check_pgdir>:

static void
check_pgdir(void) {
c01037fa:	55                   	push   %ebp
c01037fb:	89 e5                	mov    %esp,%ebp
c01037fd:	53                   	push   %ebx
c01037fe:	83 ec 24             	sub    $0x24,%esp
c0103801:	e8 a4 ca ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0103806:	81 c3 6a 41 01 00    	add    $0x1416a,%ebx
    assert(npage <= KMEMSIZE / PGSIZE);
c010380c:	8b 83 10 10 00 00    	mov    0x1010(%ebx),%eax
c0103812:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103817:	76 1f                	jbe    c0103838 <check_pgdir+0x3e>
c0103819:	8d 83 c3 ef fe ff    	lea    -0x1103d(%ebx),%eax
c010381f:	50                   	push   %eax
c0103820:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103826:	50                   	push   %eax
c0103827:	68 e5 01 00 00       	push   $0x1e5
c010382c:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103832:	50                   	push   %eax
c0103833:	e8 95 cc ff ff       	call   c01004cd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103838:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c010383e:	85 c0                	test   %eax,%eax
c0103840:	74 0f                	je     c0103851 <check_pgdir+0x57>
c0103842:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103848:	25 ff 0f 00 00       	and    $0xfff,%eax
c010384d:	85 c0                	test   %eax,%eax
c010384f:	74 1f                	je     c0103870 <check_pgdir+0x76>
c0103851:	8d 83 e0 ef fe ff    	lea    -0x11020(%ebx),%eax
c0103857:	50                   	push   %eax
c0103858:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c010385e:	50                   	push   %eax
c010385f:	68 e6 01 00 00       	push   $0x1e6
c0103864:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c010386a:	50                   	push   %eax
c010386b:	e8 5d cc ff ff       	call   c01004cd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103870:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103876:	83 ec 04             	sub    $0x4,%esp
c0103879:	6a 00                	push   $0x0
c010387b:	6a 00                	push   $0x0
c010387d:	50                   	push   %eax
c010387e:	e8 75 fd ff ff       	call   c01035f8 <get_page>
c0103883:	83 c4 10             	add    $0x10,%esp
c0103886:	85 c0                	test   %eax,%eax
c0103888:	74 1f                	je     c01038a9 <check_pgdir+0xaf>
c010388a:	8d 83 18 f0 fe ff    	lea    -0x10fe8(%ebx),%eax
c0103890:	50                   	push   %eax
c0103891:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103897:	50                   	push   %eax
c0103898:	68 e7 01 00 00       	push   $0x1e7
c010389d:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c01038a3:	50                   	push   %eax
c01038a4:	e8 24 cc ff ff       	call   c01004cd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01038a9:	83 ec 0c             	sub    $0xc,%esp
c01038ac:	6a 01                	push   $0x1
c01038ae:	e8 9b f5 ff ff       	call   c0102e4e <alloc_pages>
c01038b3:	83 c4 10             	add    $0x10,%esp
c01038b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01038b9:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c01038bf:	6a 00                	push   $0x0
c01038c1:	6a 00                	push   $0x0
c01038c3:	ff 75 f4             	pushl  -0xc(%ebp)
c01038c6:	50                   	push   %eax
c01038c7:	e8 d6 fd ff ff       	call   c01036a2 <page_insert>
c01038cc:	83 c4 10             	add    $0x10,%esp
c01038cf:	85 c0                	test   %eax,%eax
c01038d1:	74 1f                	je     c01038f2 <check_pgdir+0xf8>
c01038d3:	8d 83 40 f0 fe ff    	lea    -0x10fc0(%ebx),%eax
c01038d9:	50                   	push   %eax
c01038da:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c01038e0:	50                   	push   %eax
c01038e1:	68 eb 01 00 00       	push   $0x1eb
c01038e6:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c01038ec:	50                   	push   %eax
c01038ed:	e8 db cb ff ff       	call   c01004cd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01038f2:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c01038f8:	83 ec 04             	sub    $0x4,%esp
c01038fb:	6a 00                	push   $0x0
c01038fd:	6a 00                	push   $0x0
c01038ff:	50                   	push   %eax
c0103900:	e8 e3 fc ff ff       	call   c01035e8 <get_pte>
c0103905:	83 c4 10             	add    $0x10,%esp
c0103908:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010390b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010390f:	75 1f                	jne    c0103930 <check_pgdir+0x136>
c0103911:	8d 83 6c f0 fe ff    	lea    -0x10f94(%ebx),%eax
c0103917:	50                   	push   %eax
c0103918:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c010391e:	50                   	push   %eax
c010391f:	68 ee 01 00 00       	push   $0x1ee
c0103924:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c010392a:	50                   	push   %eax
c010392b:	e8 9d cb ff ff       	call   c01004cd <__panic>
    assert(pa2page(*ptep) == p1);
c0103930:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103933:	8b 00                	mov    (%eax),%eax
c0103935:	83 ec 0c             	sub    $0xc,%esp
c0103938:	50                   	push   %eax
c0103939:	e8 6c f1 ff ff       	call   c0102aaa <pa2page>
c010393e:	83 c4 10             	add    $0x10,%esp
c0103941:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103944:	74 1f                	je     c0103965 <check_pgdir+0x16b>
c0103946:	8d 83 99 f0 fe ff    	lea    -0x10f67(%ebx),%eax
c010394c:	50                   	push   %eax
c010394d:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103953:	50                   	push   %eax
c0103954:	68 ef 01 00 00       	push   $0x1ef
c0103959:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c010395f:	50                   	push   %eax
c0103960:	e8 68 cb ff ff       	call   c01004cd <__panic>
    assert(page_ref(p1) == 1);
c0103965:	83 ec 0c             	sub    $0xc,%esp
c0103968:	ff 75 f4             	pushl  -0xc(%ebp)
c010396b:	e8 3f f2 ff ff       	call   c0102baf <page_ref>
c0103970:	83 c4 10             	add    $0x10,%esp
c0103973:	83 f8 01             	cmp    $0x1,%eax
c0103976:	74 1f                	je     c0103997 <check_pgdir+0x19d>
c0103978:	8d 83 ae f0 fe ff    	lea    -0x10f52(%ebx),%eax
c010397e:	50                   	push   %eax
c010397f:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103985:	50                   	push   %eax
c0103986:	68 f0 01 00 00       	push   $0x1f0
c010398b:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103991:	50                   	push   %eax
c0103992:	e8 36 cb ff ff       	call   c01004cd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103997:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c010399d:	8b 00                	mov    (%eax),%eax
c010399f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01039a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01039a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039aa:	c1 e8 0c             	shr    $0xc,%eax
c01039ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01039b0:	8b 83 10 10 00 00    	mov    0x1010(%ebx),%eax
c01039b6:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01039b9:	72 1b                	jb     c01039d6 <check_pgdir+0x1dc>
c01039bb:	ff 75 ec             	pushl  -0x14(%ebp)
c01039be:	8d 83 7c ee fe ff    	lea    -0x11184(%ebx),%eax
c01039c4:	50                   	push   %eax
c01039c5:	68 f2 01 00 00       	push   $0x1f2
c01039ca:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c01039d0:	50                   	push   %eax
c01039d1:	e8 f7 ca ff ff       	call   c01004cd <__panic>
c01039d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039d9:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01039de:	83 c0 04             	add    $0x4,%eax
c01039e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01039e4:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c01039ea:	83 ec 04             	sub    $0x4,%esp
c01039ed:	6a 00                	push   $0x0
c01039ef:	68 00 10 00 00       	push   $0x1000
c01039f4:	50                   	push   %eax
c01039f5:	e8 ee fb ff ff       	call   c01035e8 <get_pte>
c01039fa:	83 c4 10             	add    $0x10,%esp
c01039fd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103a00:	74 1f                	je     c0103a21 <check_pgdir+0x227>
c0103a02:	8d 83 c0 f0 fe ff    	lea    -0x10f40(%ebx),%eax
c0103a08:	50                   	push   %eax
c0103a09:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103a0f:	50                   	push   %eax
c0103a10:	68 f3 01 00 00       	push   $0x1f3
c0103a15:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103a1b:	50                   	push   %eax
c0103a1c:	e8 ac ca ff ff       	call   c01004cd <__panic>

    p2 = alloc_page();
c0103a21:	83 ec 0c             	sub    $0xc,%esp
c0103a24:	6a 01                	push   $0x1
c0103a26:	e8 23 f4 ff ff       	call   c0102e4e <alloc_pages>
c0103a2b:	83 c4 10             	add    $0x10,%esp
c0103a2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103a31:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103a37:	6a 06                	push   $0x6
c0103a39:	68 00 10 00 00       	push   $0x1000
c0103a3e:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103a41:	50                   	push   %eax
c0103a42:	e8 5b fc ff ff       	call   c01036a2 <page_insert>
c0103a47:	83 c4 10             	add    $0x10,%esp
c0103a4a:	85 c0                	test   %eax,%eax
c0103a4c:	74 1f                	je     c0103a6d <check_pgdir+0x273>
c0103a4e:	8d 83 e8 f0 fe ff    	lea    -0x10f18(%ebx),%eax
c0103a54:	50                   	push   %eax
c0103a55:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103a5b:	50                   	push   %eax
c0103a5c:	68 f6 01 00 00       	push   $0x1f6
c0103a61:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103a67:	50                   	push   %eax
c0103a68:	e8 60 ca ff ff       	call   c01004cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103a6d:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103a73:	83 ec 04             	sub    $0x4,%esp
c0103a76:	6a 00                	push   $0x0
c0103a78:	68 00 10 00 00       	push   $0x1000
c0103a7d:	50                   	push   %eax
c0103a7e:	e8 65 fb ff ff       	call   c01035e8 <get_pte>
c0103a83:	83 c4 10             	add    $0x10,%esp
c0103a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a8d:	75 1f                	jne    c0103aae <check_pgdir+0x2b4>
c0103a8f:	8d 83 20 f1 fe ff    	lea    -0x10ee0(%ebx),%eax
c0103a95:	50                   	push   %eax
c0103a96:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103a9c:	50                   	push   %eax
c0103a9d:	68 f7 01 00 00       	push   $0x1f7
c0103aa2:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103aa8:	50                   	push   %eax
c0103aa9:	e8 1f ca ff ff       	call   c01004cd <__panic>
    assert(*ptep & PTE_U);
c0103aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ab1:	8b 00                	mov    (%eax),%eax
c0103ab3:	83 e0 04             	and    $0x4,%eax
c0103ab6:	85 c0                	test   %eax,%eax
c0103ab8:	75 1f                	jne    c0103ad9 <check_pgdir+0x2df>
c0103aba:	8d 83 50 f1 fe ff    	lea    -0x10eb0(%ebx),%eax
c0103ac0:	50                   	push   %eax
c0103ac1:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103ac7:	50                   	push   %eax
c0103ac8:	68 f8 01 00 00       	push   $0x1f8
c0103acd:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103ad3:	50                   	push   %eax
c0103ad4:	e8 f4 c9 ff ff       	call   c01004cd <__panic>
    assert(*ptep & PTE_W);
c0103ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103adc:	8b 00                	mov    (%eax),%eax
c0103ade:	83 e0 02             	and    $0x2,%eax
c0103ae1:	85 c0                	test   %eax,%eax
c0103ae3:	75 1f                	jne    c0103b04 <check_pgdir+0x30a>
c0103ae5:	8d 83 5e f1 fe ff    	lea    -0x10ea2(%ebx),%eax
c0103aeb:	50                   	push   %eax
c0103aec:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103af2:	50                   	push   %eax
c0103af3:	68 f9 01 00 00       	push   $0x1f9
c0103af8:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103afe:	50                   	push   %eax
c0103aff:	e8 c9 c9 ff ff       	call   c01004cd <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103b04:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103b0a:	8b 00                	mov    (%eax),%eax
c0103b0c:	83 e0 04             	and    $0x4,%eax
c0103b0f:	85 c0                	test   %eax,%eax
c0103b11:	75 1f                	jne    c0103b32 <check_pgdir+0x338>
c0103b13:	8d 83 6c f1 fe ff    	lea    -0x10e94(%ebx),%eax
c0103b19:	50                   	push   %eax
c0103b1a:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103b20:	50                   	push   %eax
c0103b21:	68 fa 01 00 00       	push   $0x1fa
c0103b26:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103b2c:	50                   	push   %eax
c0103b2d:	e8 9b c9 ff ff       	call   c01004cd <__panic>
    assert(page_ref(p2) == 1);
c0103b32:	83 ec 0c             	sub    $0xc,%esp
c0103b35:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103b38:	e8 72 f0 ff ff       	call   c0102baf <page_ref>
c0103b3d:	83 c4 10             	add    $0x10,%esp
c0103b40:	83 f8 01             	cmp    $0x1,%eax
c0103b43:	74 1f                	je     c0103b64 <check_pgdir+0x36a>
c0103b45:	8d 83 82 f1 fe ff    	lea    -0x10e7e(%ebx),%eax
c0103b4b:	50                   	push   %eax
c0103b4c:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103b52:	50                   	push   %eax
c0103b53:	68 fb 01 00 00       	push   $0x1fb
c0103b58:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103b5e:	50                   	push   %eax
c0103b5f:	e8 69 c9 ff ff       	call   c01004cd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103b64:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103b6a:	6a 00                	push   $0x0
c0103b6c:	68 00 10 00 00       	push   $0x1000
c0103b71:	ff 75 f4             	pushl  -0xc(%ebp)
c0103b74:	50                   	push   %eax
c0103b75:	e8 28 fb ff ff       	call   c01036a2 <page_insert>
c0103b7a:	83 c4 10             	add    $0x10,%esp
c0103b7d:	85 c0                	test   %eax,%eax
c0103b7f:	74 1f                	je     c0103ba0 <check_pgdir+0x3a6>
c0103b81:	8d 83 94 f1 fe ff    	lea    -0x10e6c(%ebx),%eax
c0103b87:	50                   	push   %eax
c0103b88:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103b8e:	50                   	push   %eax
c0103b8f:	68 fd 01 00 00       	push   $0x1fd
c0103b94:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103b9a:	50                   	push   %eax
c0103b9b:	e8 2d c9 ff ff       	call   c01004cd <__panic>
    assert(page_ref(p1) == 2);
c0103ba0:	83 ec 0c             	sub    $0xc,%esp
c0103ba3:	ff 75 f4             	pushl  -0xc(%ebp)
c0103ba6:	e8 04 f0 ff ff       	call   c0102baf <page_ref>
c0103bab:	83 c4 10             	add    $0x10,%esp
c0103bae:	83 f8 02             	cmp    $0x2,%eax
c0103bb1:	74 1f                	je     c0103bd2 <check_pgdir+0x3d8>
c0103bb3:	8d 83 c0 f1 fe ff    	lea    -0x10e40(%ebx),%eax
c0103bb9:	50                   	push   %eax
c0103bba:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103bc0:	50                   	push   %eax
c0103bc1:	68 fe 01 00 00       	push   $0x1fe
c0103bc6:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103bcc:	50                   	push   %eax
c0103bcd:	e8 fb c8 ff ff       	call   c01004cd <__panic>
    assert(page_ref(p2) == 0);
c0103bd2:	83 ec 0c             	sub    $0xc,%esp
c0103bd5:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103bd8:	e8 d2 ef ff ff       	call   c0102baf <page_ref>
c0103bdd:	83 c4 10             	add    $0x10,%esp
c0103be0:	85 c0                	test   %eax,%eax
c0103be2:	74 1f                	je     c0103c03 <check_pgdir+0x409>
c0103be4:	8d 83 d2 f1 fe ff    	lea    -0x10e2e(%ebx),%eax
c0103bea:	50                   	push   %eax
c0103beb:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103bf1:	50                   	push   %eax
c0103bf2:	68 ff 01 00 00       	push   $0x1ff
c0103bf7:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103bfd:	50                   	push   %eax
c0103bfe:	e8 ca c8 ff ff       	call   c01004cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103c03:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103c09:	83 ec 04             	sub    $0x4,%esp
c0103c0c:	6a 00                	push   $0x0
c0103c0e:	68 00 10 00 00       	push   $0x1000
c0103c13:	50                   	push   %eax
c0103c14:	e8 cf f9 ff ff       	call   c01035e8 <get_pte>
c0103c19:	83 c4 10             	add    $0x10,%esp
c0103c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c23:	75 1f                	jne    c0103c44 <check_pgdir+0x44a>
c0103c25:	8d 83 20 f1 fe ff    	lea    -0x10ee0(%ebx),%eax
c0103c2b:	50                   	push   %eax
c0103c2c:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103c32:	50                   	push   %eax
c0103c33:	68 00 02 00 00       	push   $0x200
c0103c38:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103c3e:	50                   	push   %eax
c0103c3f:	e8 89 c8 ff ff       	call   c01004cd <__panic>
    assert(pa2page(*ptep) == p1);
c0103c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c47:	8b 00                	mov    (%eax),%eax
c0103c49:	83 ec 0c             	sub    $0xc,%esp
c0103c4c:	50                   	push   %eax
c0103c4d:	e8 58 ee ff ff       	call   c0102aaa <pa2page>
c0103c52:	83 c4 10             	add    $0x10,%esp
c0103c55:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103c58:	74 1f                	je     c0103c79 <check_pgdir+0x47f>
c0103c5a:	8d 83 99 f0 fe ff    	lea    -0x10f67(%ebx),%eax
c0103c60:	50                   	push   %eax
c0103c61:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103c67:	50                   	push   %eax
c0103c68:	68 01 02 00 00       	push   $0x201
c0103c6d:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103c73:	50                   	push   %eax
c0103c74:	e8 54 c8 ff ff       	call   c01004cd <__panic>
    assert((*ptep & PTE_U) == 0);
c0103c79:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c7c:	8b 00                	mov    (%eax),%eax
c0103c7e:	83 e0 04             	and    $0x4,%eax
c0103c81:	85 c0                	test   %eax,%eax
c0103c83:	74 1f                	je     c0103ca4 <check_pgdir+0x4aa>
c0103c85:	8d 83 e4 f1 fe ff    	lea    -0x10e1c(%ebx),%eax
c0103c8b:	50                   	push   %eax
c0103c8c:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103c92:	50                   	push   %eax
c0103c93:	68 02 02 00 00       	push   $0x202
c0103c98:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103c9e:	50                   	push   %eax
c0103c9f:	e8 29 c8 ff ff       	call   c01004cd <__panic>

    page_remove(boot_pgdir, 0x0);
c0103ca4:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103caa:	83 ec 08             	sub    $0x8,%esp
c0103cad:	6a 00                	push   $0x0
c0103caf:	50                   	push   %eax
c0103cb0:	e8 b0 f9 ff ff       	call   c0103665 <page_remove>
c0103cb5:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0103cb8:	83 ec 0c             	sub    $0xc,%esp
c0103cbb:	ff 75 f4             	pushl  -0xc(%ebp)
c0103cbe:	e8 ec ee ff ff       	call   c0102baf <page_ref>
c0103cc3:	83 c4 10             	add    $0x10,%esp
c0103cc6:	83 f8 01             	cmp    $0x1,%eax
c0103cc9:	74 1f                	je     c0103cea <check_pgdir+0x4f0>
c0103ccb:	8d 83 ae f0 fe ff    	lea    -0x10f52(%ebx),%eax
c0103cd1:	50                   	push   %eax
c0103cd2:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103cd8:	50                   	push   %eax
c0103cd9:	68 05 02 00 00       	push   $0x205
c0103cde:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103ce4:	50                   	push   %eax
c0103ce5:	e8 e3 c7 ff ff       	call   c01004cd <__panic>
    assert(page_ref(p2) == 0);
c0103cea:	83 ec 0c             	sub    $0xc,%esp
c0103ced:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103cf0:	e8 ba ee ff ff       	call   c0102baf <page_ref>
c0103cf5:	83 c4 10             	add    $0x10,%esp
c0103cf8:	85 c0                	test   %eax,%eax
c0103cfa:	74 1f                	je     c0103d1b <check_pgdir+0x521>
c0103cfc:	8d 83 d2 f1 fe ff    	lea    -0x10e2e(%ebx),%eax
c0103d02:	50                   	push   %eax
c0103d03:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103d09:	50                   	push   %eax
c0103d0a:	68 06 02 00 00       	push   $0x206
c0103d0f:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103d15:	50                   	push   %eax
c0103d16:	e8 b2 c7 ff ff       	call   c01004cd <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103d1b:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103d21:	83 ec 08             	sub    $0x8,%esp
c0103d24:	68 00 10 00 00       	push   $0x1000
c0103d29:	50                   	push   %eax
c0103d2a:	e8 36 f9 ff ff       	call   c0103665 <page_remove>
c0103d2f:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0103d32:	83 ec 0c             	sub    $0xc,%esp
c0103d35:	ff 75 f4             	pushl  -0xc(%ebp)
c0103d38:	e8 72 ee ff ff       	call   c0102baf <page_ref>
c0103d3d:	83 c4 10             	add    $0x10,%esp
c0103d40:	85 c0                	test   %eax,%eax
c0103d42:	74 1f                	je     c0103d63 <check_pgdir+0x569>
c0103d44:	8d 83 f9 f1 fe ff    	lea    -0x10e07(%ebx),%eax
c0103d4a:	50                   	push   %eax
c0103d4b:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103d51:	50                   	push   %eax
c0103d52:	68 09 02 00 00       	push   $0x209
c0103d57:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103d5d:	50                   	push   %eax
c0103d5e:	e8 6a c7 ff ff       	call   c01004cd <__panic>
    assert(page_ref(p2) == 0);
c0103d63:	83 ec 0c             	sub    $0xc,%esp
c0103d66:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103d69:	e8 41 ee ff ff       	call   c0102baf <page_ref>
c0103d6e:	83 c4 10             	add    $0x10,%esp
c0103d71:	85 c0                	test   %eax,%eax
c0103d73:	74 1f                	je     c0103d94 <check_pgdir+0x59a>
c0103d75:	8d 83 d2 f1 fe ff    	lea    -0x10e2e(%ebx),%eax
c0103d7b:	50                   	push   %eax
c0103d7c:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103d82:	50                   	push   %eax
c0103d83:	68 0a 02 00 00       	push   $0x20a
c0103d88:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103d8e:	50                   	push   %eax
c0103d8f:	e8 39 c7 ff ff       	call   c01004cd <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0103d94:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103d9a:	8b 00                	mov    (%eax),%eax
c0103d9c:	83 ec 0c             	sub    $0xc,%esp
c0103d9f:	50                   	push   %eax
c0103da0:	e8 05 ed ff ff       	call   c0102aaa <pa2page>
c0103da5:	83 c4 10             	add    $0x10,%esp
c0103da8:	83 ec 0c             	sub    $0xc,%esp
c0103dab:	50                   	push   %eax
c0103dac:	e8 fe ed ff ff       	call   c0102baf <page_ref>
c0103db1:	83 c4 10             	add    $0x10,%esp
c0103db4:	83 f8 01             	cmp    $0x1,%eax
c0103db7:	74 1f                	je     c0103dd8 <check_pgdir+0x5de>
c0103db9:	8d 83 0c f2 fe ff    	lea    -0x10df4(%ebx),%eax
c0103dbf:	50                   	push   %eax
c0103dc0:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103dc6:	50                   	push   %eax
c0103dc7:	68 0c 02 00 00       	push   $0x20c
c0103dcc:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103dd2:	50                   	push   %eax
c0103dd3:	e8 f5 c6 ff ff       	call   c01004cd <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0103dd8:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103dde:	8b 00                	mov    (%eax),%eax
c0103de0:	83 ec 0c             	sub    $0xc,%esp
c0103de3:	50                   	push   %eax
c0103de4:	e8 c1 ec ff ff       	call   c0102aaa <pa2page>
c0103de9:	83 c4 10             	add    $0x10,%esp
c0103dec:	83 ec 08             	sub    $0x8,%esp
c0103def:	6a 01                	push   $0x1
c0103df1:	50                   	push   %eax
c0103df2:	e8 a7 f0 ff ff       	call   c0102e9e <free_pages>
c0103df7:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103dfa:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103e00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103e06:	83 ec 0c             	sub    $0xc,%esp
c0103e09:	8d 83 32 f2 fe ff    	lea    -0x10dce(%ebx),%eax
c0103e0f:	50                   	push   %eax
c0103e10:	e8 08 c5 ff ff       	call   c010031d <cprintf>
c0103e15:	83 c4 10             	add    $0x10,%esp
}
c0103e18:	90                   	nop
c0103e19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103e1c:	c9                   	leave  
c0103e1d:	c3                   	ret    

c0103e1e <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103e1e:	55                   	push   %ebp
c0103e1f:	89 e5                	mov    %esp,%ebp
c0103e21:	53                   	push   %ebx
c0103e22:	83 ec 24             	sub    $0x24,%esp
c0103e25:	e8 80 c4 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0103e2a:	81 c3 46 3b 01 00    	add    $0x13b46,%ebx
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103e30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103e37:	e9 b5 00 00 00       	jmp    c0103ef1 <check_boot_pgdir+0xd3>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103e42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e45:	c1 e8 0c             	shr    $0xc,%eax
c0103e48:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103e4b:	8b 83 10 10 00 00    	mov    0x1010(%ebx),%eax
c0103e51:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103e54:	72 1b                	jb     c0103e71 <check_boot_pgdir+0x53>
c0103e56:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103e59:	8d 83 7c ee fe ff    	lea    -0x11184(%ebx),%eax
c0103e5f:	50                   	push   %eax
c0103e60:	68 18 02 00 00       	push   $0x218
c0103e65:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103e6b:	50                   	push   %eax
c0103e6c:	e8 5c c6 ff ff       	call   c01004cd <__panic>
c0103e71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e74:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103e79:	89 c2                	mov    %eax,%edx
c0103e7b:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103e81:	83 ec 04             	sub    $0x4,%esp
c0103e84:	6a 00                	push   $0x0
c0103e86:	52                   	push   %edx
c0103e87:	50                   	push   %eax
c0103e88:	e8 5b f7 ff ff       	call   c01035e8 <get_pte>
c0103e8d:	83 c4 10             	add    $0x10,%esp
c0103e90:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103e93:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103e97:	75 1f                	jne    c0103eb8 <check_boot_pgdir+0x9a>
c0103e99:	8d 83 4c f2 fe ff    	lea    -0x10db4(%ebx),%eax
c0103e9f:	50                   	push   %eax
c0103ea0:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103ea6:	50                   	push   %eax
c0103ea7:	68 18 02 00 00       	push   $0x218
c0103eac:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103eb2:	50                   	push   %eax
c0103eb3:	e8 15 c6 ff ff       	call   c01004cd <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103eb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ebb:	8b 00                	mov    (%eax),%eax
c0103ebd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ec2:	89 c2                	mov    %eax,%edx
c0103ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ec7:	39 c2                	cmp    %eax,%edx
c0103ec9:	74 1f                	je     c0103eea <check_boot_pgdir+0xcc>
c0103ecb:	8d 83 89 f2 fe ff    	lea    -0x10d77(%ebx),%eax
c0103ed1:	50                   	push   %eax
c0103ed2:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103ed8:	50                   	push   %eax
c0103ed9:	68 19 02 00 00       	push   $0x219
c0103ede:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103ee4:	50                   	push   %eax
c0103ee5:	e8 e3 c5 ff ff       	call   c01004cd <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103eea:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103ef1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103ef4:	8b 83 10 10 00 00    	mov    0x1010(%ebx),%eax
c0103efa:	39 c2                	cmp    %eax,%edx
c0103efc:	0f 82 3a ff ff ff    	jb     c0103e3c <check_boot_pgdir+0x1e>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103f02:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103f08:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103f0d:	8b 00                	mov    (%eax),%eax
c0103f0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103f14:	89 c2                	mov    %eax,%edx
c0103f16:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103f1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103f1f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103f26:	77 1b                	ja     c0103f43 <check_boot_pgdir+0x125>
c0103f28:	ff 75 f0             	pushl  -0x10(%ebp)
c0103f2b:	8d 83 20 ef fe ff    	lea    -0x110e0(%ebx),%eax
c0103f31:	50                   	push   %eax
c0103f32:	68 1c 02 00 00       	push   $0x21c
c0103f37:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103f3d:	50                   	push   %eax
c0103f3e:	e8 8a c5 ff ff       	call   c01004cd <__panic>
c0103f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f46:	05 00 00 00 40       	add    $0x40000000,%eax
c0103f4b:	39 d0                	cmp    %edx,%eax
c0103f4d:	74 1f                	je     c0103f6e <check_boot_pgdir+0x150>
c0103f4f:	8d 83 a0 f2 fe ff    	lea    -0x10d60(%ebx),%eax
c0103f55:	50                   	push   %eax
c0103f56:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103f5c:	50                   	push   %eax
c0103f5d:	68 1c 02 00 00       	push   $0x21c
c0103f62:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103f68:	50                   	push   %eax
c0103f69:	e8 5f c5 ff ff       	call   c01004cd <__panic>

    assert(boot_pgdir[0] == 0);
c0103f6e:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103f74:	8b 00                	mov    (%eax),%eax
c0103f76:	85 c0                	test   %eax,%eax
c0103f78:	74 1f                	je     c0103f99 <check_boot_pgdir+0x17b>
c0103f7a:	8d 83 d4 f2 fe ff    	lea    -0x10d2c(%ebx),%eax
c0103f80:	50                   	push   %eax
c0103f81:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103f87:	50                   	push   %eax
c0103f88:	68 1e 02 00 00       	push   $0x21e
c0103f8d:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103f93:	50                   	push   %eax
c0103f94:	e8 34 c5 ff ff       	call   c01004cd <__panic>

    struct Page *p;
    p = alloc_page();
c0103f99:	83 ec 0c             	sub    $0xc,%esp
c0103f9c:	6a 01                	push   $0x1
c0103f9e:	e8 ab ee ff ff       	call   c0102e4e <alloc_pages>
c0103fa3:	83 c4 10             	add    $0x10,%esp
c0103fa6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103fa9:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0103faf:	6a 02                	push   $0x2
c0103fb1:	68 00 01 00 00       	push   $0x100
c0103fb6:	ff 75 ec             	pushl  -0x14(%ebp)
c0103fb9:	50                   	push   %eax
c0103fba:	e8 e3 f6 ff ff       	call   c01036a2 <page_insert>
c0103fbf:	83 c4 10             	add    $0x10,%esp
c0103fc2:	85 c0                	test   %eax,%eax
c0103fc4:	74 1f                	je     c0103fe5 <check_boot_pgdir+0x1c7>
c0103fc6:	8d 83 e8 f2 fe ff    	lea    -0x10d18(%ebx),%eax
c0103fcc:	50                   	push   %eax
c0103fcd:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0103fd3:	50                   	push   %eax
c0103fd4:	68 22 02 00 00       	push   $0x222
c0103fd9:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0103fdf:	50                   	push   %eax
c0103fe0:	e8 e8 c4 ff ff       	call   c01004cd <__panic>
    assert(page_ref(p) == 1);
c0103fe5:	83 ec 0c             	sub    $0xc,%esp
c0103fe8:	ff 75 ec             	pushl  -0x14(%ebp)
c0103feb:	e8 bf eb ff ff       	call   c0102baf <page_ref>
c0103ff0:	83 c4 10             	add    $0x10,%esp
c0103ff3:	83 f8 01             	cmp    $0x1,%eax
c0103ff6:	74 1f                	je     c0104017 <check_boot_pgdir+0x1f9>
c0103ff8:	8d 83 16 f3 fe ff    	lea    -0x10cea(%ebx),%eax
c0103ffe:	50                   	push   %eax
c0103fff:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0104005:	50                   	push   %eax
c0104006:	68 23 02 00 00       	push   $0x223
c010400b:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c0104011:	50                   	push   %eax
c0104012:	e8 b6 c4 ff ff       	call   c01004cd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104017:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c010401d:	6a 02                	push   $0x2
c010401f:	68 00 11 00 00       	push   $0x1100
c0104024:	ff 75 ec             	pushl  -0x14(%ebp)
c0104027:	50                   	push   %eax
c0104028:	e8 75 f6 ff ff       	call   c01036a2 <page_insert>
c010402d:	83 c4 10             	add    $0x10,%esp
c0104030:	85 c0                	test   %eax,%eax
c0104032:	74 1f                	je     c0104053 <check_boot_pgdir+0x235>
c0104034:	8d 83 28 f3 fe ff    	lea    -0x10cd8(%ebx),%eax
c010403a:	50                   	push   %eax
c010403b:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0104041:	50                   	push   %eax
c0104042:	68 24 02 00 00       	push   $0x224
c0104047:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c010404d:	50                   	push   %eax
c010404e:	e8 7a c4 ff ff       	call   c01004cd <__panic>
    assert(page_ref(p) == 2);
c0104053:	83 ec 0c             	sub    $0xc,%esp
c0104056:	ff 75 ec             	pushl  -0x14(%ebp)
c0104059:	e8 51 eb ff ff       	call   c0102baf <page_ref>
c010405e:	83 c4 10             	add    $0x10,%esp
c0104061:	83 f8 02             	cmp    $0x2,%eax
c0104064:	74 1f                	je     c0104085 <check_boot_pgdir+0x267>
c0104066:	8d 83 5f f3 fe ff    	lea    -0x10ca1(%ebx),%eax
c010406c:	50                   	push   %eax
c010406d:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0104073:	50                   	push   %eax
c0104074:	68 25 02 00 00       	push   $0x225
c0104079:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c010407f:	50                   	push   %eax
c0104080:	e8 48 c4 ff ff       	call   c01004cd <__panic>

    const char *str = "ucore: Hello world!!";
c0104085:	8d 83 70 f3 fe ff    	lea    -0x10c90(%ebx),%eax
c010408b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    strcpy((void *)0x100, str);
c010408e:	83 ec 08             	sub    $0x8,%esp
c0104091:	ff 75 e8             	pushl  -0x18(%ebp)
c0104094:	68 00 01 00 00       	push   $0x100
c0104099:	e8 5d 15 00 00       	call   c01055fb <strcpy>
c010409e:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01040a1:	83 ec 08             	sub    $0x8,%esp
c01040a4:	68 00 11 00 00       	push   $0x1100
c01040a9:	68 00 01 00 00       	push   $0x100
c01040ae:	e8 d6 15 00 00       	call   c0105689 <strcmp>
c01040b3:	83 c4 10             	add    $0x10,%esp
c01040b6:	85 c0                	test   %eax,%eax
c01040b8:	74 1f                	je     c01040d9 <check_boot_pgdir+0x2bb>
c01040ba:	8d 83 88 f3 fe ff    	lea    -0x10c78(%ebx),%eax
c01040c0:	50                   	push   %eax
c01040c1:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c01040c7:	50                   	push   %eax
c01040c8:	68 29 02 00 00       	push   $0x229
c01040cd:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c01040d3:	50                   	push   %eax
c01040d4:	e8 f4 c3 ff ff       	call   c01004cd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01040d9:	83 ec 0c             	sub    $0xc,%esp
c01040dc:	ff 75 ec             	pushl  -0x14(%ebp)
c01040df:	e8 24 ea ff ff       	call   c0102b08 <page2kva>
c01040e4:	83 c4 10             	add    $0x10,%esp
c01040e7:	05 00 01 00 00       	add    $0x100,%eax
c01040ec:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01040ef:	83 ec 0c             	sub    $0xc,%esp
c01040f2:	68 00 01 00 00       	push   $0x100
c01040f7:	e8 93 14 00 00       	call   c010558f <strlen>
c01040fc:	83 c4 10             	add    $0x10,%esp
c01040ff:	85 c0                	test   %eax,%eax
c0104101:	74 1f                	je     c0104122 <check_boot_pgdir+0x304>
c0104103:	8d 83 c0 f3 fe ff    	lea    -0x10c40(%ebx),%eax
c0104109:	50                   	push   %eax
c010410a:	8d 83 69 ef fe ff    	lea    -0x11097(%ebx),%eax
c0104110:	50                   	push   %eax
c0104111:	68 2c 02 00 00       	push   $0x22c
c0104116:	8d 83 44 ef fe ff    	lea    -0x110bc(%ebx),%eax
c010411c:	50                   	push   %eax
c010411d:	e8 ab c3 ff ff       	call   c01004cd <__panic>

    free_page(p);
c0104122:	83 ec 08             	sub    $0x8,%esp
c0104125:	6a 01                	push   $0x1
c0104127:	ff 75 ec             	pushl  -0x14(%ebp)
c010412a:	e8 6f ed ff ff       	call   c0102e9e <free_pages>
c010412f:	83 c4 10             	add    $0x10,%esp
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0104132:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c0104138:	8b 00                	mov    (%eax),%eax
c010413a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010413f:	83 ec 0c             	sub    $0xc,%esp
c0104142:	50                   	push   %eax
c0104143:	e8 62 e9 ff ff       	call   c0102aaa <pa2page>
c0104148:	83 c4 10             	add    $0x10,%esp
c010414b:	83 ec 08             	sub    $0x8,%esp
c010414e:	6a 01                	push   $0x1
c0104150:	50                   	push   %eax
c0104151:	e8 48 ed ff ff       	call   c0102e9e <free_pages>
c0104156:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0104159:	8b 83 14 10 00 00    	mov    0x1014(%ebx),%eax
c010415f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104165:	83 ec 0c             	sub    $0xc,%esp
c0104168:	8d 83 e4 f3 fe ff    	lea    -0x10c1c(%ebx),%eax
c010416e:	50                   	push   %eax
c010416f:	e8 a9 c1 ff ff       	call   c010031d <cprintf>
c0104174:	83 c4 10             	add    $0x10,%esp
}
c0104177:	90                   	nop
c0104178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010417b:	c9                   	leave  
c010417c:	c3                   	ret    

c010417d <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010417d:	55                   	push   %ebp
c010417e:	89 e5                	mov    %esp,%ebp
c0104180:	e8 21 c1 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0104185:	05 eb 37 01 00       	add    $0x137eb,%eax
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010418a:	8b 55 08             	mov    0x8(%ebp),%edx
c010418d:	83 e2 04             	and    $0x4,%edx
c0104190:	85 d2                	test   %edx,%edx
c0104192:	74 07                	je     c010419b <perm2str+0x1e>
c0104194:	ba 75 00 00 00       	mov    $0x75,%edx
c0104199:	eb 05                	jmp    c01041a0 <perm2str+0x23>
c010419b:	ba 2d 00 00 00       	mov    $0x2d,%edx
c01041a0:	88 90 98 10 00 00    	mov    %dl,0x1098(%eax)
    str[1] = 'r';
c01041a6:	c6 80 99 10 00 00 72 	movb   $0x72,0x1099(%eax)
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01041ad:	8b 55 08             	mov    0x8(%ebp),%edx
c01041b0:	83 e2 02             	and    $0x2,%edx
c01041b3:	85 d2                	test   %edx,%edx
c01041b5:	74 07                	je     c01041be <perm2str+0x41>
c01041b7:	ba 77 00 00 00       	mov    $0x77,%edx
c01041bc:	eb 05                	jmp    c01041c3 <perm2str+0x46>
c01041be:	ba 2d 00 00 00       	mov    $0x2d,%edx
c01041c3:	88 90 9a 10 00 00    	mov    %dl,0x109a(%eax)
    str[3] = '\0';
c01041c9:	c6 80 9b 10 00 00 00 	movb   $0x0,0x109b(%eax)
    return str;
c01041d0:	8d 80 98 10 00 00    	lea    0x1098(%eax),%eax
}
c01041d6:	5d                   	pop    %ebp
c01041d7:	c3                   	ret    

c01041d8 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01041d8:	55                   	push   %ebp
c01041d9:	89 e5                	mov    %esp,%ebp
c01041db:	83 ec 10             	sub    $0x10,%esp
c01041de:	e8 c3 c0 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01041e3:	05 8d 37 01 00       	add    $0x1378d,%eax
    if (start >= right) {
c01041e8:	8b 45 10             	mov    0x10(%ebp),%eax
c01041eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01041ee:	72 0e                	jb     c01041fe <get_pgtable_items+0x26>
        return 0;
c01041f0:	b8 00 00 00 00       	mov    $0x0,%eax
c01041f5:	e9 9a 00 00 00       	jmp    c0104294 <get_pgtable_items+0xbc>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c01041fa:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c01041fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0104201:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104204:	73 18                	jae    c010421e <get_pgtable_items+0x46>
c0104206:	8b 45 10             	mov    0x10(%ebp),%eax
c0104209:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104210:	8b 45 14             	mov    0x14(%ebp),%eax
c0104213:	01 d0                	add    %edx,%eax
c0104215:	8b 00                	mov    (%eax),%eax
c0104217:	83 e0 01             	and    $0x1,%eax
c010421a:	85 c0                	test   %eax,%eax
c010421c:	74 dc                	je     c01041fa <get_pgtable_items+0x22>
    }
    if (start < right) {
c010421e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104221:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104224:	73 69                	jae    c010428f <get_pgtable_items+0xb7>
        if (left_store != NULL) {
c0104226:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010422a:	74 08                	je     c0104234 <get_pgtable_items+0x5c>
            *left_store = start;
c010422c:	8b 45 18             	mov    0x18(%ebp),%eax
c010422f:	8b 55 10             	mov    0x10(%ebp),%edx
c0104232:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104234:	8b 45 10             	mov    0x10(%ebp),%eax
c0104237:	8d 50 01             	lea    0x1(%eax),%edx
c010423a:	89 55 10             	mov    %edx,0x10(%ebp)
c010423d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104244:	8b 45 14             	mov    0x14(%ebp),%eax
c0104247:	01 d0                	add    %edx,%eax
c0104249:	8b 00                	mov    (%eax),%eax
c010424b:	83 e0 07             	and    $0x7,%eax
c010424e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104251:	eb 04                	jmp    c0104257 <get_pgtable_items+0x7f>
            start ++;
c0104253:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104257:	8b 45 10             	mov    0x10(%ebp),%eax
c010425a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010425d:	73 1d                	jae    c010427c <get_pgtable_items+0xa4>
c010425f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104269:	8b 45 14             	mov    0x14(%ebp),%eax
c010426c:	01 d0                	add    %edx,%eax
c010426e:	8b 00                	mov    (%eax),%eax
c0104270:	83 e0 07             	and    $0x7,%eax
c0104273:	89 c2                	mov    %eax,%edx
c0104275:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104278:	39 c2                	cmp    %eax,%edx
c010427a:	74 d7                	je     c0104253 <get_pgtable_items+0x7b>
        }
        if (right_store != NULL) {
c010427c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104280:	74 08                	je     c010428a <get_pgtable_items+0xb2>
            *right_store = start;
c0104282:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104285:	8b 55 10             	mov    0x10(%ebp),%edx
c0104288:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010428a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010428d:	eb 05                	jmp    c0104294 <get_pgtable_items+0xbc>
    }
    return 0;
c010428f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104294:	c9                   	leave  
c0104295:	c3                   	ret    

c0104296 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104296:	55                   	push   %ebp
c0104297:	89 e5                	mov    %esp,%ebp
c0104299:	57                   	push   %edi
c010429a:	56                   	push   %esi
c010429b:	53                   	push   %ebx
c010429c:	83 ec 3c             	sub    $0x3c,%esp
c010429f:	e8 06 c0 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c01042a4:	81 c3 cc 36 01 00    	add    $0x136cc,%ebx
    cprintf("-------------------- BEGIN --------------------\n");
c01042aa:	83 ec 0c             	sub    $0xc,%esp
c01042ad:	8d 83 04 f4 fe ff    	lea    -0x10bfc(%ebx),%eax
c01042b3:	50                   	push   %eax
c01042b4:	e8 64 c0 ff ff       	call   c010031d <cprintf>
c01042b9:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c01042bc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01042c3:	e9 ef 00 00 00       	jmp    c01043b7 <print_pgdir+0x121>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01042c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042cb:	83 ec 0c             	sub    $0xc,%esp
c01042ce:	50                   	push   %eax
c01042cf:	e8 a9 fe ff ff       	call   c010417d <perm2str>
c01042d4:	83 c4 10             	add    $0x10,%esp
c01042d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01042da:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01042dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042e0:	29 c2                	sub    %eax,%edx
c01042e2:	89 d0                	mov    %edx,%eax
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01042e4:	89 c6                	mov    %eax,%esi
c01042e6:	c1 e6 16             	shl    $0x16,%esi
c01042e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042ec:	89 c1                	mov    %eax,%ecx
c01042ee:	c1 e1 16             	shl    $0x16,%ecx
c01042f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042f4:	89 c2                	mov    %eax,%edx
c01042f6:	c1 e2 16             	shl    $0x16,%edx
c01042f9:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01042fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042ff:	29 c7                	sub    %eax,%edi
c0104301:	89 f8                	mov    %edi,%eax
c0104303:	83 ec 08             	sub    $0x8,%esp
c0104306:	ff 75 c4             	pushl  -0x3c(%ebp)
c0104309:	56                   	push   %esi
c010430a:	51                   	push   %ecx
c010430b:	52                   	push   %edx
c010430c:	50                   	push   %eax
c010430d:	8d 83 35 f4 fe ff    	lea    -0x10bcb(%ebx),%eax
c0104313:	50                   	push   %eax
c0104314:	e8 04 c0 ff ff       	call   c010031d <cprintf>
c0104319:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
c010431c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010431f:	c1 e0 0a             	shl    $0xa,%eax
c0104322:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104325:	eb 54                	jmp    c010437b <print_pgdir+0xe5>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104327:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010432a:	83 ec 0c             	sub    $0xc,%esp
c010432d:	50                   	push   %eax
c010432e:	e8 4a fe ff ff       	call   c010417d <perm2str>
c0104333:	83 c4 10             	add    $0x10,%esp
c0104336:	89 45 c4             	mov    %eax,-0x3c(%ebp)
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104339:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010433c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010433f:	29 c2                	sub    %eax,%edx
c0104341:	89 d0                	mov    %edx,%eax
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104343:	89 c6                	mov    %eax,%esi
c0104345:	c1 e6 0c             	shl    $0xc,%esi
c0104348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010434b:	89 c1                	mov    %eax,%ecx
c010434d:	c1 e1 0c             	shl    $0xc,%ecx
c0104350:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104353:	89 c2                	mov    %eax,%edx
c0104355:	c1 e2 0c             	shl    $0xc,%edx
c0104358:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010435b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010435e:	29 c7                	sub    %eax,%edi
c0104360:	89 f8                	mov    %edi,%eax
c0104362:	83 ec 08             	sub    $0x8,%esp
c0104365:	ff 75 c4             	pushl  -0x3c(%ebp)
c0104368:	56                   	push   %esi
c0104369:	51                   	push   %ecx
c010436a:	52                   	push   %edx
c010436b:	50                   	push   %eax
c010436c:	8d 83 54 f4 fe ff    	lea    -0x10bac(%ebx),%eax
c0104372:	50                   	push   %eax
c0104373:	e8 a5 bf ff ff       	call   c010031d <cprintf>
c0104378:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010437b:	bf 00 00 c0 fa       	mov    $0xfac00000,%edi
c0104380:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104383:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104386:	89 d6                	mov    %edx,%esi
c0104388:	c1 e6 0a             	shl    $0xa,%esi
c010438b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010438e:	89 d1                	mov    %edx,%ecx
c0104390:	c1 e1 0a             	shl    $0xa,%ecx
c0104393:	83 ec 08             	sub    $0x8,%esp
c0104396:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104399:	52                   	push   %edx
c010439a:	8d 55 d8             	lea    -0x28(%ebp),%edx
c010439d:	52                   	push   %edx
c010439e:	57                   	push   %edi
c010439f:	50                   	push   %eax
c01043a0:	56                   	push   %esi
c01043a1:	51                   	push   %ecx
c01043a2:	e8 31 fe ff ff       	call   c01041d8 <get_pgtable_items>
c01043a7:	83 c4 20             	add    $0x20,%esp
c01043aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01043b1:	0f 85 70 ff ff ff    	jne    c0104327 <print_pgdir+0x91>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01043b7:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01043bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043bf:	83 ec 08             	sub    $0x8,%esp
c01043c2:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01043c5:	52                   	push   %edx
c01043c6:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01043c9:	52                   	push   %edx
c01043ca:	51                   	push   %ecx
c01043cb:	50                   	push   %eax
c01043cc:	68 00 04 00 00       	push   $0x400
c01043d1:	6a 00                	push   $0x0
c01043d3:	e8 00 fe ff ff       	call   c01041d8 <get_pgtable_items>
c01043d8:	83 c4 20             	add    $0x20,%esp
c01043db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01043e2:	0f 85 e0 fe ff ff    	jne    c01042c8 <print_pgdir+0x32>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01043e8:	83 ec 0c             	sub    $0xc,%esp
c01043eb:	8d 83 78 f4 fe ff    	lea    -0x10b88(%ebx),%eax
c01043f1:	50                   	push   %eax
c01043f2:	e8 26 bf ff ff       	call   c010031d <cprintf>
c01043f7:	83 c4 10             	add    $0x10,%esp
}
c01043fa:	90                   	nop
c01043fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01043fe:	5b                   	pop    %ebx
c01043ff:	5e                   	pop    %esi
c0104400:	5f                   	pop    %edi
c0104401:	5d                   	pop    %ebp
c0104402:	c3                   	ret    

c0104403 <__x86.get_pc_thunk.si>:
c0104403:	8b 34 24             	mov    (%esp),%esi
c0104406:	c3                   	ret    

c0104407 <page2ppn>:
page2ppn(struct Page *page) {
c0104407:	55                   	push   %ebp
c0104408:	89 e5                	mov    %esp,%ebp
c010440a:	e8 97 be ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c010440f:	05 61 35 01 00       	add    $0x13561,%eax
    return page - pages;
c0104414:	8b 55 08             	mov    0x8(%ebp),%edx
c0104417:	c7 c0 18 8a 11 c0    	mov    $0xc0118a18,%eax
c010441d:	8b 00                	mov    (%eax),%eax
c010441f:	29 c2                	sub    %eax,%edx
c0104421:	89 d0                	mov    %edx,%eax
c0104423:	c1 f8 02             	sar    $0x2,%eax
c0104426:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010442c:	5d                   	pop    %ebp
c010442d:	c3                   	ret    

c010442e <page2pa>:
page2pa(struct Page *page) {
c010442e:	55                   	push   %ebp
c010442f:	89 e5                	mov    %esp,%ebp
c0104431:	e8 70 be ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0104436:	05 3a 35 01 00       	add    $0x1353a,%eax
    return page2ppn(page) << PGSHIFT;
c010443b:	ff 75 08             	pushl  0x8(%ebp)
c010443e:	e8 c4 ff ff ff       	call   c0104407 <page2ppn>
c0104443:	83 c4 04             	add    $0x4,%esp
c0104446:	c1 e0 0c             	shl    $0xc,%eax
}
c0104449:	c9                   	leave  
c010444a:	c3                   	ret    

c010444b <page_ref>:
page_ref(struct Page *page) {
c010444b:	55                   	push   %ebp
c010444c:	89 e5                	mov    %esp,%ebp
c010444e:	e8 53 be ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0104453:	05 1d 35 01 00       	add    $0x1351d,%eax
    return page->ref;
c0104458:	8b 45 08             	mov    0x8(%ebp),%eax
c010445b:	8b 00                	mov    (%eax),%eax
}
c010445d:	5d                   	pop    %ebp
c010445e:	c3                   	ret    

c010445f <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c010445f:	55                   	push   %ebp
c0104460:	89 e5                	mov    %esp,%ebp
c0104462:	e8 3f be ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0104467:	05 09 35 01 00       	add    $0x13509,%eax
    page->ref = val;
c010446c:	8b 45 08             	mov    0x8(%ebp),%eax
c010446f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104472:	89 10                	mov    %edx,(%eax)
}
c0104474:	90                   	nop
c0104475:	5d                   	pop    %ebp
c0104476:	c3                   	ret    

c0104477 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0104477:	55                   	push   %ebp
c0104478:	89 e5                	mov    %esp,%ebp
c010447a:	83 ec 10             	sub    $0x10,%esp
c010447d:	e8 24 be ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0104482:	05 ee 34 01 00       	add    $0x134ee,%eax
c0104487:	c7 c2 1c 8a 11 c0    	mov    $0xc0118a1c,%edx
c010448d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104490:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104493:	8b 4d fc             	mov    -0x4(%ebp),%ecx
c0104496:	89 4a 04             	mov    %ecx,0x4(%edx)
c0104499:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010449c:	8b 4a 04             	mov    0x4(%edx),%ecx
c010449f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01044a2:	89 0a                	mov    %ecx,(%edx)
    list_init(&free_list);
    nr_free = 0;
c01044a4:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c01044aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
c01044b1:	90                   	nop
c01044b2:	c9                   	leave  
c01044b3:	c3                   	ret    

c01044b4 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01044b4:	55                   	push   %ebp
c01044b5:	89 e5                	mov    %esp,%ebp
c01044b7:	53                   	push   %ebx
c01044b8:	83 ec 44             	sub    $0x44,%esp
c01044bb:	e8 ea bd ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c01044c0:	81 c3 b0 34 01 00    	add    $0x134b0,%ebx
    assert(n > 0);
c01044c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01044ca:	75 1c                	jne    c01044e8 <default_init_memmap+0x34>
c01044cc:	8d 83 ac f4 fe ff    	lea    -0x10b54(%ebx),%eax
c01044d2:	50                   	push   %eax
c01044d3:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c01044d9:	50                   	push   %eax
c01044da:	6a 46                	push   $0x46
c01044dc:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c01044e2:	50                   	push   %eax
c01044e3:	e8 e5 bf ff ff       	call   c01004cd <__panic>
    struct Page *p = base;
c01044e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01044eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01044ee:	eb 72                	jmp    c0104562 <default_init_memmap+0xae>
        assert(PageReserved(p));
c01044f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044f3:	83 c0 04             	add    $0x4,%eax
c01044f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01044fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104500:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104503:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104506:	0f a3 10             	bt     %edx,(%eax)
c0104509:	19 c0                	sbb    %eax,%eax
c010450b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010450e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104512:	0f 95 c0             	setne  %al
c0104515:	0f b6 c0             	movzbl %al,%eax
c0104518:	85 c0                	test   %eax,%eax
c010451a:	75 1c                	jne    c0104538 <default_init_memmap+0x84>
c010451c:	8d 83 dd f4 fe ff    	lea    -0x10b23(%ebx),%eax
c0104522:	50                   	push   %eax
c0104523:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104529:	50                   	push   %eax
c010452a:	6a 49                	push   $0x49
c010452c:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104532:	50                   	push   %eax
c0104533:	e8 95 bf ff ff       	call   c01004cd <__panic>
        p->flags = p->property = 0;
c0104538:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010453b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104542:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104545:	8b 50 08             	mov    0x8(%eax),%edx
c0104548:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010454b:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010454e:	83 ec 08             	sub    $0x8,%esp
c0104551:	6a 00                	push   $0x0
c0104553:	ff 75 f4             	pushl  -0xc(%ebp)
c0104556:	e8 04 ff ff ff       	call   c010445f <set_page_ref>
c010455b:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c010455e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104562:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104565:	89 d0                	mov    %edx,%eax
c0104567:	c1 e0 02             	shl    $0x2,%eax
c010456a:	01 d0                	add    %edx,%eax
c010456c:	c1 e0 02             	shl    $0x2,%eax
c010456f:	89 c2                	mov    %eax,%edx
c0104571:	8b 45 08             	mov    0x8(%ebp),%eax
c0104574:	01 d0                	add    %edx,%eax
c0104576:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104579:	0f 85 71 ff ff ff    	jne    c01044f0 <default_init_memmap+0x3c>
    }
    base->property = n;
c010457f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104582:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104585:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104588:	8b 45 08             	mov    0x8(%ebp),%eax
c010458b:	83 c0 04             	add    $0x4,%eax
c010458e:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0104595:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104598:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010459b:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010459e:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c01045a1:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c01045a7:	8b 50 08             	mov    0x8(%eax),%edx
c01045aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045ad:	01 c2                	add    %eax,%edx
c01045af:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c01045b5:	89 50 08             	mov    %edx,0x8(%eax)
    list_add(&free_list, &(base->page_link));
c01045b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01045bb:	83 c0 0c             	add    $0xc,%eax
c01045be:	c7 c2 1c 8a 11 c0    	mov    $0xc0118a1c,%edx
c01045c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01045c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01045ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01045d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01045d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01045d9:	8b 40 04             	mov    0x4(%eax),%eax
c01045dc:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01045df:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01045e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01045e5:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01045e8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01045eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01045ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01045f1:	89 10                	mov    %edx,(%eax)
c01045f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01045f6:	8b 10                	mov    (%eax),%edx
c01045f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01045fb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01045fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104601:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104604:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104607:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010460a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010460d:	89 10                	mov    %edx,(%eax)
}
c010460f:	90                   	nop
c0104610:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104613:	c9                   	leave  
c0104614:	c3                   	ret    

c0104615 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0104615:	55                   	push   %ebp
c0104616:	89 e5                	mov    %esp,%ebp
c0104618:	53                   	push   %ebx
c0104619:	83 ec 54             	sub    $0x54,%esp
c010461c:	e8 85 bc ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0104621:	05 4f 33 01 00       	add    $0x1334f,%eax
    assert(n > 0);
c0104626:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010462a:	75 1e                	jne    c010464a <default_alloc_pages+0x35>
c010462c:	8d 90 ac f4 fe ff    	lea    -0x10b54(%eax),%edx
c0104632:	52                   	push   %edx
c0104633:	8d 90 b2 f4 fe ff    	lea    -0x10b4e(%eax),%edx
c0104639:	52                   	push   %edx
c010463a:	6a 55                	push   $0x55
c010463c:	8d 90 c7 f4 fe ff    	lea    -0x10b39(%eax),%edx
c0104642:	52                   	push   %edx
c0104643:	89 c3                	mov    %eax,%ebx
c0104645:	e8 83 be ff ff       	call   c01004cd <__panic>
    if (n > nr_free) {
c010464a:	c7 c2 1c 8a 11 c0    	mov    $0xc0118a1c,%edx
c0104650:	8b 52 08             	mov    0x8(%edx),%edx
c0104653:	39 55 08             	cmp    %edx,0x8(%ebp)
c0104656:	76 0a                	jbe    c0104662 <default_alloc_pages+0x4d>
        return NULL;
c0104658:	b8 00 00 00 00       	mov    $0x0,%eax
c010465d:	e9 38 01 00 00       	jmp    c010479a <default_alloc_pages+0x185>
    }
    struct Page *page = NULL;
c0104662:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104669:	c7 c2 1c 8a 11 c0    	mov    $0xc0118a1c,%edx
c010466f:	89 55 f0             	mov    %edx,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104672:	eb 1c                	jmp    c0104690 <default_alloc_pages+0x7b>
        struct Page *p = le2page(le, page_link);
c0104674:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104677:	83 ea 0c             	sub    $0xc,%edx
c010467a:	89 55 ec             	mov    %edx,-0x14(%ebp)
        if (p->property >= n) {
c010467d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104680:	8b 52 08             	mov    0x8(%edx),%edx
c0104683:	39 55 08             	cmp    %edx,0x8(%ebp)
c0104686:	77 08                	ja     c0104690 <default_alloc_pages+0x7b>
            page = p;
c0104688:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010468b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            break;
c010468e:	eb 1a                	jmp    c01046aa <default_alloc_pages+0x95>
c0104690:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104693:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return listelm->next;
c0104696:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104699:	8b 52 04             	mov    0x4(%edx),%edx
    while ((le = list_next(le)) != &free_list) {
c010469c:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010469f:	c7 c2 1c 8a 11 c0    	mov    $0xc0118a1c,%edx
c01046a5:	39 55 f0             	cmp    %edx,-0x10(%ebp)
c01046a8:	75 ca                	jne    c0104674 <default_alloc_pages+0x5f>
        }
    }
    if (page != NULL) {
c01046aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046ae:	0f 84 e3 00 00 00    	je     c0104797 <default_alloc_pages+0x182>
        list_del(&(page->page_link));
c01046b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01046b7:	83 c2 0c             	add    $0xc,%edx
c01046ba:	89 55 e0             	mov    %edx,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
c01046bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01046c0:	8b 52 04             	mov    0x4(%edx),%edx
c01046c3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01046c6:	8b 09                	mov    (%ecx),%ecx
c01046c8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
c01046cb:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01046ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01046d1:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c01046d4:	89 4a 04             	mov    %ecx,0x4(%edx)
    next->prev = prev;
c01046d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01046da:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01046dd:	89 0a                	mov    %ecx,(%edx)
        if (page->property > n) {
c01046df:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01046e2:	8b 52 08             	mov    0x8(%edx),%edx
c01046e5:	39 55 08             	cmp    %edx,0x8(%ebp)
c01046e8:	73 7f                	jae    c0104769 <default_alloc_pages+0x154>
            struct Page *p = page + n;
c01046ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
c01046ed:	89 ca                	mov    %ecx,%edx
c01046ef:	c1 e2 02             	shl    $0x2,%edx
c01046f2:	01 ca                	add    %ecx,%edx
c01046f4:	c1 e2 02             	shl    $0x2,%edx
c01046f7:	89 d1                	mov    %edx,%ecx
c01046f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01046fc:	01 ca                	add    %ecx,%edx
c01046fe:	89 55 e8             	mov    %edx,-0x18(%ebp)
            p->property = page->property - n;
c0104701:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104704:	8b 52 08             	mov    0x8(%edx),%edx
c0104707:	89 d1                	mov    %edx,%ecx
c0104709:	2b 4d 08             	sub    0x8(%ebp),%ecx
c010470c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010470f:	89 4a 08             	mov    %ecx,0x8(%edx)
            list_add(&free_list, &(p->page_link));
c0104712:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104715:	83 c2 0c             	add    $0xc,%edx
c0104718:	c7 c1 1c 8a 11 c0    	mov    $0xc0118a1c,%ecx
c010471e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
c0104721:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0104724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104727:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010472a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010472d:	89 55 c8             	mov    %edx,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104730:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104733:	8b 52 04             	mov    0x4(%edx),%edx
c0104736:	8b 4d c8             	mov    -0x38(%ebp),%ecx
c0104739:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
c010473c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c010473f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
c0104742:	89 55 bc             	mov    %edx,-0x44(%ebp)
    prev->next = next->prev = elm;
c0104745:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104748:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010474b:	89 0a                	mov    %ecx,(%edx)
c010474d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104750:	8b 0a                	mov    (%edx),%ecx
c0104752:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104755:	89 4a 04             	mov    %ecx,0x4(%edx)
    elm->next = next;
c0104758:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010475b:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c010475e:	89 4a 04             	mov    %ecx,0x4(%edx)
    elm->prev = prev;
c0104761:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104764:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0104767:	89 0a                	mov    %ecx,(%edx)
    }
        nr_free -= n;
c0104769:	c7 c2 1c 8a 11 c0    	mov    $0xc0118a1c,%edx
c010476f:	8b 52 08             	mov    0x8(%edx),%edx
c0104772:	2b 55 08             	sub    0x8(%ebp),%edx
c0104775:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c010477b:	89 50 08             	mov    %edx,0x8(%eax)
        ClearPageProperty(page);
c010477e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104781:	83 c0 04             	add    $0x4,%eax
c0104784:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c010478b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010478e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104791:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104794:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0104797:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010479a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010479d:	c9                   	leave  
c010479e:	c3                   	ret    

c010479f <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c010479f:	55                   	push   %ebp
c01047a0:	89 e5                	mov    %esp,%ebp
c01047a2:	53                   	push   %ebx
c01047a3:	81 ec 84 00 00 00    	sub    $0x84,%esp
c01047a9:	e8 fc ba ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c01047ae:	81 c3 c2 31 01 00    	add    $0x131c2,%ebx
    assert(n > 0);
c01047b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01047b8:	75 1c                	jne    c01047d6 <default_free_pages+0x37>
c01047ba:	8d 83 ac f4 fe ff    	lea    -0x10b54(%ebx),%eax
c01047c0:	50                   	push   %eax
c01047c1:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c01047c7:	50                   	push   %eax
c01047c8:	6a 71                	push   $0x71
c01047ca:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c01047d0:	50                   	push   %eax
c01047d1:	e8 f7 bc ff ff       	call   c01004cd <__panic>
    struct Page *p = base;
c01047d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01047d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01047dc:	e9 92 00 00 00       	jmp    c0104873 <default_free_pages+0xd4>
        assert(!PageReserved(p) && !PageProperty(p));
c01047e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e4:	83 c0 04             	add    $0x4,%eax
c01047e7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01047ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01047f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01047f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01047f7:	0f a3 10             	bt     %edx,(%eax)
c01047fa:	19 c0                	sbb    %eax,%eax
c01047fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c01047ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104803:	0f 95 c0             	setne  %al
c0104806:	0f b6 c0             	movzbl %al,%eax
c0104809:	85 c0                	test   %eax,%eax
c010480b:	75 2c                	jne    c0104839 <default_free_pages+0x9a>
c010480d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104810:	83 c0 04             	add    $0x4,%eax
c0104813:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010481a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010481d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104820:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104823:	0f a3 10             	bt     %edx,(%eax)
c0104826:	19 c0                	sbb    %eax,%eax
c0104828:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c010482b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010482f:	0f 95 c0             	setne  %al
c0104832:	0f b6 c0             	movzbl %al,%eax
c0104835:	85 c0                	test   %eax,%eax
c0104837:	74 1c                	je     c0104855 <default_free_pages+0xb6>
c0104839:	8d 83 f0 f4 fe ff    	lea    -0x10b10(%ebx),%eax
c010483f:	50                   	push   %eax
c0104840:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104846:	50                   	push   %eax
c0104847:	6a 74                	push   $0x74
c0104849:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c010484f:	50                   	push   %eax
c0104850:	e8 78 bc ff ff       	call   c01004cd <__panic>
        p->flags = 0;
c0104855:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104858:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c010485f:	83 ec 08             	sub    $0x8,%esp
c0104862:	6a 00                	push   $0x0
c0104864:	ff 75 f4             	pushl  -0xc(%ebp)
c0104867:	e8 f3 fb ff ff       	call   c010445f <set_page_ref>
c010486c:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c010486f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104873:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104876:	89 d0                	mov    %edx,%eax
c0104878:	c1 e0 02             	shl    $0x2,%eax
c010487b:	01 d0                	add    %edx,%eax
c010487d:	c1 e0 02             	shl    $0x2,%eax
c0104880:	89 c2                	mov    %eax,%edx
c0104882:	8b 45 08             	mov    0x8(%ebp),%eax
c0104885:	01 d0                	add    %edx,%eax
c0104887:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010488a:	0f 85 51 ff ff ff    	jne    c01047e1 <default_free_pages+0x42>
    }
    base->property = n;
c0104890:	8b 45 08             	mov    0x8(%ebp),%eax
c0104893:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104896:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104899:	8b 45 08             	mov    0x8(%ebp),%eax
c010489c:	83 c0 04             	add    $0x4,%eax
c010489f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01048a6:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01048a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01048ac:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01048af:	0f ab 10             	bts    %edx,(%eax)
c01048b2:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c01048b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return listelm->next;
c01048bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01048be:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c01048c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01048c4:	e9 08 01 00 00       	jmp    c01049d1 <default_free_pages+0x232>
        p = le2page(le, page_link);
c01048c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048cc:	83 e8 0c             	sub    $0xc,%eax
c01048cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048d5:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01048d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01048db:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01048de:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c01048e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01048e4:	8b 50 08             	mov    0x8(%eax),%edx
c01048e7:	89 d0                	mov    %edx,%eax
c01048e9:	c1 e0 02             	shl    $0x2,%eax
c01048ec:	01 d0                	add    %edx,%eax
c01048ee:	c1 e0 02             	shl    $0x2,%eax
c01048f1:	89 c2                	mov    %eax,%edx
c01048f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01048f6:	01 d0                	add    %edx,%eax
c01048f8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01048fb:	75 5a                	jne    c0104957 <default_free_pages+0x1b8>
            base->property += p->property;
c01048fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104900:	8b 50 08             	mov    0x8(%eax),%edx
c0104903:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104906:	8b 40 08             	mov    0x8(%eax),%eax
c0104909:	01 c2                	add    %eax,%edx
c010490b:	8b 45 08             	mov    0x8(%ebp),%eax
c010490e:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0104911:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104914:	83 c0 04             	add    $0x4,%eax
c0104917:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c010491e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104921:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104924:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104927:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c010492a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010492d:	83 c0 0c             	add    $0xc,%eax
c0104930:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104933:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104936:	8b 40 04             	mov    0x4(%eax),%eax
c0104939:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010493c:	8b 12                	mov    (%edx),%edx
c010493e:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104941:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0104944:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104947:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010494a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010494d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104950:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104953:	89 10                	mov    %edx,(%eax)
c0104955:	eb 7a                	jmp    c01049d1 <default_free_pages+0x232>
        }
        else if (p + p->property == base) {
c0104957:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010495a:	8b 50 08             	mov    0x8(%eax),%edx
c010495d:	89 d0                	mov    %edx,%eax
c010495f:	c1 e0 02             	shl    $0x2,%eax
c0104962:	01 d0                	add    %edx,%eax
c0104964:	c1 e0 02             	shl    $0x2,%eax
c0104967:	89 c2                	mov    %eax,%edx
c0104969:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010496c:	01 d0                	add    %edx,%eax
c010496e:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104971:	75 5e                	jne    c01049d1 <default_free_pages+0x232>
            p->property += base->property;
c0104973:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104976:	8b 50 08             	mov    0x8(%eax),%edx
c0104979:	8b 45 08             	mov    0x8(%ebp),%eax
c010497c:	8b 40 08             	mov    0x8(%eax),%eax
c010497f:	01 c2                	add    %eax,%edx
c0104981:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104984:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0104987:	8b 45 08             	mov    0x8(%ebp),%eax
c010498a:	83 c0 04             	add    $0x4,%eax
c010498d:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0104994:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104997:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010499a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010499d:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c01049a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049a3:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c01049a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049a9:	83 c0 0c             	add    $0xc,%eax
c01049ac:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c01049af:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01049b2:	8b 40 04             	mov    0x4(%eax),%eax
c01049b5:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01049b8:	8b 12                	mov    (%edx),%edx
c01049ba:	89 55 ac             	mov    %edx,-0x54(%ebp)
c01049bd:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c01049c0:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01049c3:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01049c6:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01049c9:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01049cc:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01049cf:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
c01049d1:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c01049d7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01049da:	0f 85 e9 fe ff ff    	jne    c01048c9 <default_free_pages+0x12a>
        }
    }
    nr_free += n;
c01049e0:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c01049e6:	8b 50 08             	mov    0x8(%eax),%edx
c01049e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049ec:	01 c2                	add    %eax,%edx
c01049ee:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c01049f4:	89 50 08             	mov    %edx,0x8(%eax)
    list_add(&free_list, &(base->page_link));
c01049f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01049fa:	83 c0 0c             	add    $0xc,%eax
c01049fd:	c7 c2 1c 8a 11 c0    	mov    $0xc0118a1c,%edx
c0104a03:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0104a06:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104a09:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104a0c:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104a0f:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104a12:	89 45 90             	mov    %eax,-0x70(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104a15:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104a18:	8b 40 04             	mov    0x4(%eax),%eax
c0104a1b:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104a1e:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104a21:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104a24:	89 55 88             	mov    %edx,-0x78(%ebp)
c0104a27:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0104a2a:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104a2d:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104a30:	89 10                	mov    %edx,(%eax)
c0104a32:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104a35:	8b 10                	mov    (%eax),%edx
c0104a37:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104a3a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104a3d:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104a40:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104a43:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104a46:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104a49:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104a4c:	89 10                	mov    %edx,(%eax)
}
c0104a4e:	90                   	nop
c0104a4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104a52:	c9                   	leave  
c0104a53:	c3                   	ret    

c0104a54 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104a54:	55                   	push   %ebp
c0104a55:	89 e5                	mov    %esp,%ebp
c0104a57:	e8 4a b8 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0104a5c:	05 14 2f 01 00       	add    $0x12f14,%eax
    return nr_free;
c0104a61:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0104a67:	8b 40 08             	mov    0x8(%eax),%eax
}
c0104a6a:	5d                   	pop    %ebp
c0104a6b:	c3                   	ret    

c0104a6c <basic_check>:

static void
basic_check(void) {
c0104a6c:	55                   	push   %ebp
c0104a6d:	89 e5                	mov    %esp,%ebp
c0104a6f:	53                   	push   %ebx
c0104a70:	83 ec 34             	sub    $0x34,%esp
c0104a73:	e8 32 b8 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0104a78:	81 c3 f8 2e 01 00    	add    $0x12ef8,%ebx
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104a7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104a91:	83 ec 0c             	sub    $0xc,%esp
c0104a94:	6a 01                	push   $0x1
c0104a96:	e8 b3 e3 ff ff       	call   c0102e4e <alloc_pages>
c0104a9b:	83 c4 10             	add    $0x10,%esp
c0104a9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104aa1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104aa5:	75 1f                	jne    c0104ac6 <basic_check+0x5a>
c0104aa7:	8d 83 15 f5 fe ff    	lea    -0x10aeb(%ebx),%eax
c0104aad:	50                   	push   %eax
c0104aae:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104ab4:	50                   	push   %eax
c0104ab5:	68 97 00 00 00       	push   $0x97
c0104aba:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104ac0:	50                   	push   %eax
c0104ac1:	e8 07 ba ff ff       	call   c01004cd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104ac6:	83 ec 0c             	sub    $0xc,%esp
c0104ac9:	6a 01                	push   $0x1
c0104acb:	e8 7e e3 ff ff       	call   c0102e4e <alloc_pages>
c0104ad0:	83 c4 10             	add    $0x10,%esp
c0104ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ad6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ada:	75 1f                	jne    c0104afb <basic_check+0x8f>
c0104adc:	8d 83 31 f5 fe ff    	lea    -0x10acf(%ebx),%eax
c0104ae2:	50                   	push   %eax
c0104ae3:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104ae9:	50                   	push   %eax
c0104aea:	68 98 00 00 00       	push   $0x98
c0104aef:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104af5:	50                   	push   %eax
c0104af6:	e8 d2 b9 ff ff       	call   c01004cd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104afb:	83 ec 0c             	sub    $0xc,%esp
c0104afe:	6a 01                	push   $0x1
c0104b00:	e8 49 e3 ff ff       	call   c0102e4e <alloc_pages>
c0104b05:	83 c4 10             	add    $0x10,%esp
c0104b08:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104b0f:	75 1f                	jne    c0104b30 <basic_check+0xc4>
c0104b11:	8d 83 4d f5 fe ff    	lea    -0x10ab3(%ebx),%eax
c0104b17:	50                   	push   %eax
c0104b18:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104b1e:	50                   	push   %eax
c0104b1f:	68 99 00 00 00       	push   $0x99
c0104b24:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104b2a:	50                   	push   %eax
c0104b2b:	e8 9d b9 ff ff       	call   c01004cd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b33:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104b36:	74 10                	je     c0104b48 <basic_check+0xdc>
c0104b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104b3e:	74 08                	je     c0104b48 <basic_check+0xdc>
c0104b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b43:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104b46:	75 1f                	jne    c0104b67 <basic_check+0xfb>
c0104b48:	8d 83 6c f5 fe ff    	lea    -0x10a94(%ebx),%eax
c0104b4e:	50                   	push   %eax
c0104b4f:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104b55:	50                   	push   %eax
c0104b56:	68 9b 00 00 00       	push   $0x9b
c0104b5b:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104b61:	50                   	push   %eax
c0104b62:	e8 66 b9 ff ff       	call   c01004cd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104b67:	83 ec 0c             	sub    $0xc,%esp
c0104b6a:	ff 75 ec             	pushl  -0x14(%ebp)
c0104b6d:	e8 d9 f8 ff ff       	call   c010444b <page_ref>
c0104b72:	83 c4 10             	add    $0x10,%esp
c0104b75:	85 c0                	test   %eax,%eax
c0104b77:	75 24                	jne    c0104b9d <basic_check+0x131>
c0104b79:	83 ec 0c             	sub    $0xc,%esp
c0104b7c:	ff 75 f0             	pushl  -0x10(%ebp)
c0104b7f:	e8 c7 f8 ff ff       	call   c010444b <page_ref>
c0104b84:	83 c4 10             	add    $0x10,%esp
c0104b87:	85 c0                	test   %eax,%eax
c0104b89:	75 12                	jne    c0104b9d <basic_check+0x131>
c0104b8b:	83 ec 0c             	sub    $0xc,%esp
c0104b8e:	ff 75 f4             	pushl  -0xc(%ebp)
c0104b91:	e8 b5 f8 ff ff       	call   c010444b <page_ref>
c0104b96:	83 c4 10             	add    $0x10,%esp
c0104b99:	85 c0                	test   %eax,%eax
c0104b9b:	74 1f                	je     c0104bbc <basic_check+0x150>
c0104b9d:	8d 83 90 f5 fe ff    	lea    -0x10a70(%ebx),%eax
c0104ba3:	50                   	push   %eax
c0104ba4:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104baa:	50                   	push   %eax
c0104bab:	68 9c 00 00 00       	push   $0x9c
c0104bb0:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104bb6:	50                   	push   %eax
c0104bb7:	e8 11 b9 ff ff       	call   c01004cd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104bbc:	83 ec 0c             	sub    $0xc,%esp
c0104bbf:	ff 75 ec             	pushl  -0x14(%ebp)
c0104bc2:	e8 67 f8 ff ff       	call   c010442e <page2pa>
c0104bc7:	83 c4 10             	add    $0x10,%esp
c0104bca:	89 c2                	mov    %eax,%edx
c0104bcc:	c7 c0 80 89 11 c0    	mov    $0xc0118980,%eax
c0104bd2:	8b 00                	mov    (%eax),%eax
c0104bd4:	c1 e0 0c             	shl    $0xc,%eax
c0104bd7:	39 c2                	cmp    %eax,%edx
c0104bd9:	72 1f                	jb     c0104bfa <basic_check+0x18e>
c0104bdb:	8d 83 cc f5 fe ff    	lea    -0x10a34(%ebx),%eax
c0104be1:	50                   	push   %eax
c0104be2:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104be8:	50                   	push   %eax
c0104be9:	68 9e 00 00 00       	push   $0x9e
c0104bee:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104bf4:	50                   	push   %eax
c0104bf5:	e8 d3 b8 ff ff       	call   c01004cd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104bfa:	83 ec 0c             	sub    $0xc,%esp
c0104bfd:	ff 75 f0             	pushl  -0x10(%ebp)
c0104c00:	e8 29 f8 ff ff       	call   c010442e <page2pa>
c0104c05:	83 c4 10             	add    $0x10,%esp
c0104c08:	89 c2                	mov    %eax,%edx
c0104c0a:	c7 c0 80 89 11 c0    	mov    $0xc0118980,%eax
c0104c10:	8b 00                	mov    (%eax),%eax
c0104c12:	c1 e0 0c             	shl    $0xc,%eax
c0104c15:	39 c2                	cmp    %eax,%edx
c0104c17:	72 1f                	jb     c0104c38 <basic_check+0x1cc>
c0104c19:	8d 83 e9 f5 fe ff    	lea    -0x10a17(%ebx),%eax
c0104c1f:	50                   	push   %eax
c0104c20:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104c26:	50                   	push   %eax
c0104c27:	68 9f 00 00 00       	push   $0x9f
c0104c2c:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104c32:	50                   	push   %eax
c0104c33:	e8 95 b8 ff ff       	call   c01004cd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104c38:	83 ec 0c             	sub    $0xc,%esp
c0104c3b:	ff 75 f4             	pushl  -0xc(%ebp)
c0104c3e:	e8 eb f7 ff ff       	call   c010442e <page2pa>
c0104c43:	83 c4 10             	add    $0x10,%esp
c0104c46:	89 c2                	mov    %eax,%edx
c0104c48:	c7 c0 80 89 11 c0    	mov    $0xc0118980,%eax
c0104c4e:	8b 00                	mov    (%eax),%eax
c0104c50:	c1 e0 0c             	shl    $0xc,%eax
c0104c53:	39 c2                	cmp    %eax,%edx
c0104c55:	72 1f                	jb     c0104c76 <basic_check+0x20a>
c0104c57:	8d 83 06 f6 fe ff    	lea    -0x109fa(%ebx),%eax
c0104c5d:	50                   	push   %eax
c0104c5e:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104c64:	50                   	push   %eax
c0104c65:	68 a0 00 00 00       	push   $0xa0
c0104c6a:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104c70:	50                   	push   %eax
c0104c71:	e8 57 b8 ff ff       	call   c01004cd <__panic>

    list_entry_t free_list_store = free_list;
c0104c76:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0104c7c:	8b 50 04             	mov    0x4(%eax),%edx
c0104c7f:	8b 00                	mov    (%eax),%eax
c0104c81:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104c84:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104c87:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0104c8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0104c90:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c93:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104c96:	89 50 04             	mov    %edx,0x4(%eax)
c0104c99:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c9c:	8b 50 04             	mov    0x4(%eax),%edx
c0104c9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ca2:	89 10                	mov    %edx,(%eax)
c0104ca4:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0104caa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return list->next == list;
c0104cad:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104cb0:	8b 40 04             	mov    0x4(%eax),%eax
c0104cb3:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104cb6:	0f 94 c0             	sete   %al
c0104cb9:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104cbc:	85 c0                	test   %eax,%eax
c0104cbe:	75 1f                	jne    c0104cdf <basic_check+0x273>
c0104cc0:	8d 83 23 f6 fe ff    	lea    -0x109dd(%ebx),%eax
c0104cc6:	50                   	push   %eax
c0104cc7:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104ccd:	50                   	push   %eax
c0104cce:	68 a4 00 00 00       	push   $0xa4
c0104cd3:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104cd9:	50                   	push   %eax
c0104cda:	e8 ee b7 ff ff       	call   c01004cd <__panic>

    unsigned int nr_free_store = nr_free;
c0104cdf:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0104ce5:	8b 40 08             	mov    0x8(%eax),%eax
c0104ce8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104ceb:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0104cf1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

    assert(alloc_page() == NULL);
c0104cf8:	83 ec 0c             	sub    $0xc,%esp
c0104cfb:	6a 01                	push   $0x1
c0104cfd:	e8 4c e1 ff ff       	call   c0102e4e <alloc_pages>
c0104d02:	83 c4 10             	add    $0x10,%esp
c0104d05:	85 c0                	test   %eax,%eax
c0104d07:	74 1f                	je     c0104d28 <basic_check+0x2bc>
c0104d09:	8d 83 3a f6 fe ff    	lea    -0x109c6(%ebx),%eax
c0104d0f:	50                   	push   %eax
c0104d10:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104d16:	50                   	push   %eax
c0104d17:	68 a9 00 00 00       	push   $0xa9
c0104d1c:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104d22:	50                   	push   %eax
c0104d23:	e8 a5 b7 ff ff       	call   c01004cd <__panic>

    free_page(p0);
c0104d28:	83 ec 08             	sub    $0x8,%esp
c0104d2b:	6a 01                	push   $0x1
c0104d2d:	ff 75 ec             	pushl  -0x14(%ebp)
c0104d30:	e8 69 e1 ff ff       	call   c0102e9e <free_pages>
c0104d35:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104d38:	83 ec 08             	sub    $0x8,%esp
c0104d3b:	6a 01                	push   $0x1
c0104d3d:	ff 75 f0             	pushl  -0x10(%ebp)
c0104d40:	e8 59 e1 ff ff       	call   c0102e9e <free_pages>
c0104d45:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104d48:	83 ec 08             	sub    $0x8,%esp
c0104d4b:	6a 01                	push   $0x1
c0104d4d:	ff 75 f4             	pushl  -0xc(%ebp)
c0104d50:	e8 49 e1 ff ff       	call   c0102e9e <free_pages>
c0104d55:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c0104d58:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0104d5e:	8b 40 08             	mov    0x8(%eax),%eax
c0104d61:	83 f8 03             	cmp    $0x3,%eax
c0104d64:	74 1f                	je     c0104d85 <basic_check+0x319>
c0104d66:	8d 83 4f f6 fe ff    	lea    -0x109b1(%ebx),%eax
c0104d6c:	50                   	push   %eax
c0104d6d:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104d73:	50                   	push   %eax
c0104d74:	68 ae 00 00 00       	push   $0xae
c0104d79:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104d7f:	50                   	push   %eax
c0104d80:	e8 48 b7 ff ff       	call   c01004cd <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104d85:	83 ec 0c             	sub    $0xc,%esp
c0104d88:	6a 01                	push   $0x1
c0104d8a:	e8 bf e0 ff ff       	call   c0102e4e <alloc_pages>
c0104d8f:	83 c4 10             	add    $0x10,%esp
c0104d92:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104d95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104d99:	75 1f                	jne    c0104dba <basic_check+0x34e>
c0104d9b:	8d 83 15 f5 fe ff    	lea    -0x10aeb(%ebx),%eax
c0104da1:	50                   	push   %eax
c0104da2:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104da8:	50                   	push   %eax
c0104da9:	68 b0 00 00 00       	push   $0xb0
c0104dae:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104db4:	50                   	push   %eax
c0104db5:	e8 13 b7 ff ff       	call   c01004cd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104dba:	83 ec 0c             	sub    $0xc,%esp
c0104dbd:	6a 01                	push   $0x1
c0104dbf:	e8 8a e0 ff ff       	call   c0102e4e <alloc_pages>
c0104dc4:	83 c4 10             	add    $0x10,%esp
c0104dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104dca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104dce:	75 1f                	jne    c0104def <basic_check+0x383>
c0104dd0:	8d 83 31 f5 fe ff    	lea    -0x10acf(%ebx),%eax
c0104dd6:	50                   	push   %eax
c0104dd7:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104ddd:	50                   	push   %eax
c0104dde:	68 b1 00 00 00       	push   $0xb1
c0104de3:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104de9:	50                   	push   %eax
c0104dea:	e8 de b6 ff ff       	call   c01004cd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104def:	83 ec 0c             	sub    $0xc,%esp
c0104df2:	6a 01                	push   $0x1
c0104df4:	e8 55 e0 ff ff       	call   c0102e4e <alloc_pages>
c0104df9:	83 c4 10             	add    $0x10,%esp
c0104dfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104dff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e03:	75 1f                	jne    c0104e24 <basic_check+0x3b8>
c0104e05:	8d 83 4d f5 fe ff    	lea    -0x10ab3(%ebx),%eax
c0104e0b:	50                   	push   %eax
c0104e0c:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104e12:	50                   	push   %eax
c0104e13:	68 b2 00 00 00       	push   $0xb2
c0104e18:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104e1e:	50                   	push   %eax
c0104e1f:	e8 a9 b6 ff ff       	call   c01004cd <__panic>

    assert(alloc_page() == NULL);
c0104e24:	83 ec 0c             	sub    $0xc,%esp
c0104e27:	6a 01                	push   $0x1
c0104e29:	e8 20 e0 ff ff       	call   c0102e4e <alloc_pages>
c0104e2e:	83 c4 10             	add    $0x10,%esp
c0104e31:	85 c0                	test   %eax,%eax
c0104e33:	74 1f                	je     c0104e54 <basic_check+0x3e8>
c0104e35:	8d 83 3a f6 fe ff    	lea    -0x109c6(%ebx),%eax
c0104e3b:	50                   	push   %eax
c0104e3c:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104e42:	50                   	push   %eax
c0104e43:	68 b4 00 00 00       	push   $0xb4
c0104e48:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104e4e:	50                   	push   %eax
c0104e4f:	e8 79 b6 ff ff       	call   c01004cd <__panic>

    free_page(p0);
c0104e54:	83 ec 08             	sub    $0x8,%esp
c0104e57:	6a 01                	push   $0x1
c0104e59:	ff 75 ec             	pushl  -0x14(%ebp)
c0104e5c:	e8 3d e0 ff ff       	call   c0102e9e <free_pages>
c0104e61:	83 c4 10             	add    $0x10,%esp
c0104e64:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0104e6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104e6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104e70:	8b 40 04             	mov    0x4(%eax),%eax
c0104e73:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104e76:	0f 94 c0             	sete   %al
c0104e79:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104e7c:	85 c0                	test   %eax,%eax
c0104e7e:	74 1f                	je     c0104e9f <basic_check+0x433>
c0104e80:	8d 83 5c f6 fe ff    	lea    -0x109a4(%ebx),%eax
c0104e86:	50                   	push   %eax
c0104e87:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104e8d:	50                   	push   %eax
c0104e8e:	68 b7 00 00 00       	push   $0xb7
c0104e93:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104e99:	50                   	push   %eax
c0104e9a:	e8 2e b6 ff ff       	call   c01004cd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104e9f:	83 ec 0c             	sub    $0xc,%esp
c0104ea2:	6a 01                	push   $0x1
c0104ea4:	e8 a5 df ff ff       	call   c0102e4e <alloc_pages>
c0104ea9:	83 c4 10             	add    $0x10,%esp
c0104eac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104eaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104eb2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104eb5:	74 1f                	je     c0104ed6 <basic_check+0x46a>
c0104eb7:	8d 83 74 f6 fe ff    	lea    -0x1098c(%ebx),%eax
c0104ebd:	50                   	push   %eax
c0104ebe:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104ec4:	50                   	push   %eax
c0104ec5:	68 ba 00 00 00       	push   $0xba
c0104eca:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104ed0:	50                   	push   %eax
c0104ed1:	e8 f7 b5 ff ff       	call   c01004cd <__panic>
    assert(alloc_page() == NULL);
c0104ed6:	83 ec 0c             	sub    $0xc,%esp
c0104ed9:	6a 01                	push   $0x1
c0104edb:	e8 6e df ff ff       	call   c0102e4e <alloc_pages>
c0104ee0:	83 c4 10             	add    $0x10,%esp
c0104ee3:	85 c0                	test   %eax,%eax
c0104ee5:	74 1f                	je     c0104f06 <basic_check+0x49a>
c0104ee7:	8d 83 3a f6 fe ff    	lea    -0x109c6(%ebx),%eax
c0104eed:	50                   	push   %eax
c0104eee:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104ef4:	50                   	push   %eax
c0104ef5:	68 bb 00 00 00       	push   $0xbb
c0104efa:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104f00:	50                   	push   %eax
c0104f01:	e8 c7 b5 ff ff       	call   c01004cd <__panic>

    assert(nr_free == 0);
c0104f06:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0104f0c:	8b 40 08             	mov    0x8(%eax),%eax
c0104f0f:	85 c0                	test   %eax,%eax
c0104f11:	74 1f                	je     c0104f32 <basic_check+0x4c6>
c0104f13:	8d 83 8d f6 fe ff    	lea    -0x10973(%ebx),%eax
c0104f19:	50                   	push   %eax
c0104f1a:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104f20:	50                   	push   %eax
c0104f21:	68 bd 00 00 00       	push   $0xbd
c0104f26:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0104f2c:	50                   	push   %eax
c0104f2d:	e8 9b b5 ff ff       	call   c01004cd <__panic>
    free_list = free_list_store;
c0104f32:	c7 c1 1c 8a 11 c0    	mov    $0xc0118a1c,%ecx
c0104f38:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104f3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f3e:	89 01                	mov    %eax,(%ecx)
c0104f40:	89 51 04             	mov    %edx,0x4(%ecx)
    nr_free = nr_free_store;
c0104f43:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0104f49:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104f4c:	89 50 08             	mov    %edx,0x8(%eax)

    free_page(p);
c0104f4f:	83 ec 08             	sub    $0x8,%esp
c0104f52:	6a 01                	push   $0x1
c0104f54:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104f57:	e8 42 df ff ff       	call   c0102e9e <free_pages>
c0104f5c:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104f5f:	83 ec 08             	sub    $0x8,%esp
c0104f62:	6a 01                	push   $0x1
c0104f64:	ff 75 f0             	pushl  -0x10(%ebp)
c0104f67:	e8 32 df ff ff       	call   c0102e9e <free_pages>
c0104f6c:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104f6f:	83 ec 08             	sub    $0x8,%esp
c0104f72:	6a 01                	push   $0x1
c0104f74:	ff 75 f4             	pushl  -0xc(%ebp)
c0104f77:	e8 22 df ff ff       	call   c0102e9e <free_pages>
c0104f7c:	83 c4 10             	add    $0x10,%esp
}
c0104f7f:	90                   	nop
c0104f80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104f83:	c9                   	leave  
c0104f84:	c3                   	ret    

c0104f85 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104f85:	55                   	push   %ebp
c0104f86:	89 e5                	mov    %esp,%ebp
c0104f88:	53                   	push   %ebx
c0104f89:	81 ec 84 00 00 00    	sub    $0x84,%esp
c0104f8f:	e8 16 b3 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0104f94:	81 c3 dc 29 01 00    	add    $0x129dc,%ebx
    int count = 0, total = 0;
c0104f9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104fa1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104fa8:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0104fae:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104fb1:	eb 66                	jmp    c0105019 <default_check+0x94>
        struct Page *p = le2page(le, page_link);
c0104fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fb6:	83 e8 0c             	sub    $0xc,%eax
c0104fb9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0104fbc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104fbf:	83 c0 04             	add    $0x4,%eax
c0104fc2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104fc9:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104fcc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104fcf:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104fd2:	0f a3 10             	bt     %edx,(%eax)
c0104fd5:	19 c0                	sbb    %eax,%eax
c0104fd7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104fda:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104fde:	0f 95 c0             	setne  %al
c0104fe1:	0f b6 c0             	movzbl %al,%eax
c0104fe4:	85 c0                	test   %eax,%eax
c0104fe6:	75 1f                	jne    c0105007 <default_check+0x82>
c0104fe8:	8d 83 9a f6 fe ff    	lea    -0x10966(%ebx),%eax
c0104fee:	50                   	push   %eax
c0104fef:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0104ff5:	50                   	push   %eax
c0104ff6:	68 ce 00 00 00       	push   $0xce
c0104ffb:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0105001:	50                   	push   %eax
c0105002:	e8 c6 b4 ff ff       	call   c01004cd <__panic>
        count ++, total += p->property;
c0105007:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010500b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010500e:	8b 50 08             	mov    0x8(%eax),%edx
c0105011:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105014:	01 d0                	add    %edx,%eax
c0105016:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105019:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010501c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c010501f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105022:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105025:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105028:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c010502e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105031:	75 80                	jne    c0104fb3 <default_check+0x2e>
    }
    assert(total == nr_free_pages());
c0105033:	e8 ad de ff ff       	call   c0102ee5 <nr_free_pages>
c0105038:	89 c2                	mov    %eax,%edx
c010503a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010503d:	39 c2                	cmp    %eax,%edx
c010503f:	74 1f                	je     c0105060 <default_check+0xdb>
c0105041:	8d 83 aa f6 fe ff    	lea    -0x10956(%ebx),%eax
c0105047:	50                   	push   %eax
c0105048:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c010504e:	50                   	push   %eax
c010504f:	68 d1 00 00 00       	push   $0xd1
c0105054:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c010505a:	50                   	push   %eax
c010505b:	e8 6d b4 ff ff       	call   c01004cd <__panic>

    basic_check();
c0105060:	e8 07 fa ff ff       	call   c0104a6c <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0105065:	83 ec 0c             	sub    $0xc,%esp
c0105068:	6a 05                	push   $0x5
c010506a:	e8 df dd ff ff       	call   c0102e4e <alloc_pages>
c010506f:	83 c4 10             	add    $0x10,%esp
c0105072:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0105075:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105079:	75 1f                	jne    c010509a <default_check+0x115>
c010507b:	8d 83 c3 f6 fe ff    	lea    -0x1093d(%ebx),%eax
c0105081:	50                   	push   %eax
c0105082:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0105088:	50                   	push   %eax
c0105089:	68 d6 00 00 00       	push   $0xd6
c010508e:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0105094:	50                   	push   %eax
c0105095:	e8 33 b4 ff ff       	call   c01004cd <__panic>
    assert(!PageProperty(p0));
c010509a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010509d:	83 c0 04             	add    $0x4,%eax
c01050a0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01050a7:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01050aa:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01050ad:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01050b0:	0f a3 10             	bt     %edx,(%eax)
c01050b3:	19 c0                	sbb    %eax,%eax
c01050b5:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01050b8:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01050bc:	0f 95 c0             	setne  %al
c01050bf:	0f b6 c0             	movzbl %al,%eax
c01050c2:	85 c0                	test   %eax,%eax
c01050c4:	74 1f                	je     c01050e5 <default_check+0x160>
c01050c6:	8d 83 ce f6 fe ff    	lea    -0x10932(%ebx),%eax
c01050cc:	50                   	push   %eax
c01050cd:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c01050d3:	50                   	push   %eax
c01050d4:	68 d7 00 00 00       	push   $0xd7
c01050d9:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c01050df:	50                   	push   %eax
c01050e0:	e8 e8 b3 ff ff       	call   c01004cd <__panic>

    list_entry_t free_list_store = free_list;
c01050e5:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c01050eb:	8b 50 04             	mov    0x4(%eax),%edx
c01050ee:	8b 00                	mov    (%eax),%eax
c01050f0:	89 45 80             	mov    %eax,-0x80(%ebp)
c01050f3:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01050f6:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c01050fc:	89 45 b0             	mov    %eax,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01050ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105102:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105105:	89 50 04             	mov    %edx,0x4(%eax)
c0105108:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010510b:	8b 50 04             	mov    0x4(%eax),%edx
c010510e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105111:	89 10                	mov    %edx,(%eax)
c0105113:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0105119:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return list->next == list;
c010511c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010511f:	8b 40 04             	mov    0x4(%eax),%eax
c0105122:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0105125:	0f 94 c0             	sete   %al
c0105128:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010512b:	85 c0                	test   %eax,%eax
c010512d:	75 1f                	jne    c010514e <default_check+0x1c9>
c010512f:	8d 83 23 f6 fe ff    	lea    -0x109dd(%ebx),%eax
c0105135:	50                   	push   %eax
c0105136:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c010513c:	50                   	push   %eax
c010513d:	68 db 00 00 00       	push   $0xdb
c0105142:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0105148:	50                   	push   %eax
c0105149:	e8 7f b3 ff ff       	call   c01004cd <__panic>
    assert(alloc_page() == NULL);
c010514e:	83 ec 0c             	sub    $0xc,%esp
c0105151:	6a 01                	push   $0x1
c0105153:	e8 f6 dc ff ff       	call   c0102e4e <alloc_pages>
c0105158:	83 c4 10             	add    $0x10,%esp
c010515b:	85 c0                	test   %eax,%eax
c010515d:	74 1f                	je     c010517e <default_check+0x1f9>
c010515f:	8d 83 3a f6 fe ff    	lea    -0x109c6(%ebx),%eax
c0105165:	50                   	push   %eax
c0105166:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c010516c:	50                   	push   %eax
c010516d:	68 dc 00 00 00       	push   $0xdc
c0105172:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0105178:	50                   	push   %eax
c0105179:	e8 4f b3 ff ff       	call   c01004cd <__panic>

    unsigned int nr_free_store = nr_free;
c010517e:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0105184:	8b 40 08             	mov    0x8(%eax),%eax
c0105187:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c010518a:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0105190:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

    free_pages(p0 + 2, 3);
c0105197:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010519a:	83 c0 28             	add    $0x28,%eax
c010519d:	83 ec 08             	sub    $0x8,%esp
c01051a0:	6a 03                	push   $0x3
c01051a2:	50                   	push   %eax
c01051a3:	e8 f6 dc ff ff       	call   c0102e9e <free_pages>
c01051a8:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c01051ab:	83 ec 0c             	sub    $0xc,%esp
c01051ae:	6a 04                	push   $0x4
c01051b0:	e8 99 dc ff ff       	call   c0102e4e <alloc_pages>
c01051b5:	83 c4 10             	add    $0x10,%esp
c01051b8:	85 c0                	test   %eax,%eax
c01051ba:	74 1f                	je     c01051db <default_check+0x256>
c01051bc:	8d 83 e0 f6 fe ff    	lea    -0x10920(%ebx),%eax
c01051c2:	50                   	push   %eax
c01051c3:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c01051c9:	50                   	push   %eax
c01051ca:	68 e2 00 00 00       	push   $0xe2
c01051cf:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c01051d5:	50                   	push   %eax
c01051d6:	e8 f2 b2 ff ff       	call   c01004cd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01051db:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01051de:	83 c0 28             	add    $0x28,%eax
c01051e1:	83 c0 04             	add    $0x4,%eax
c01051e4:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01051eb:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01051ee:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01051f1:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01051f4:	0f a3 10             	bt     %edx,(%eax)
c01051f7:	19 c0                	sbb    %eax,%eax
c01051f9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01051fc:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0105200:	0f 95 c0             	setne  %al
c0105203:	0f b6 c0             	movzbl %al,%eax
c0105206:	85 c0                	test   %eax,%eax
c0105208:	74 0e                	je     c0105218 <default_check+0x293>
c010520a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010520d:	83 c0 28             	add    $0x28,%eax
c0105210:	8b 40 08             	mov    0x8(%eax),%eax
c0105213:	83 f8 03             	cmp    $0x3,%eax
c0105216:	74 1f                	je     c0105237 <default_check+0x2b2>
c0105218:	8d 83 f8 f6 fe ff    	lea    -0x10908(%ebx),%eax
c010521e:	50                   	push   %eax
c010521f:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0105225:	50                   	push   %eax
c0105226:	68 e3 00 00 00       	push   $0xe3
c010522b:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0105231:	50                   	push   %eax
c0105232:	e8 96 b2 ff ff       	call   c01004cd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0105237:	83 ec 0c             	sub    $0xc,%esp
c010523a:	6a 03                	push   $0x3
c010523c:	e8 0d dc ff ff       	call   c0102e4e <alloc_pages>
c0105241:	83 c4 10             	add    $0x10,%esp
c0105244:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105247:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010524b:	75 1f                	jne    c010526c <default_check+0x2e7>
c010524d:	8d 83 24 f7 fe ff    	lea    -0x108dc(%ebx),%eax
c0105253:	50                   	push   %eax
c0105254:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c010525a:	50                   	push   %eax
c010525b:	68 e4 00 00 00       	push   $0xe4
c0105260:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0105266:	50                   	push   %eax
c0105267:	e8 61 b2 ff ff       	call   c01004cd <__panic>
    assert(alloc_page() == NULL);
c010526c:	83 ec 0c             	sub    $0xc,%esp
c010526f:	6a 01                	push   $0x1
c0105271:	e8 d8 db ff ff       	call   c0102e4e <alloc_pages>
c0105276:	83 c4 10             	add    $0x10,%esp
c0105279:	85 c0                	test   %eax,%eax
c010527b:	74 1f                	je     c010529c <default_check+0x317>
c010527d:	8d 83 3a f6 fe ff    	lea    -0x109c6(%ebx),%eax
c0105283:	50                   	push   %eax
c0105284:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c010528a:	50                   	push   %eax
c010528b:	68 e5 00 00 00       	push   $0xe5
c0105290:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0105296:	50                   	push   %eax
c0105297:	e8 31 b2 ff ff       	call   c01004cd <__panic>
    assert(p0 + 2 == p1);
c010529c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010529f:	83 c0 28             	add    $0x28,%eax
c01052a2:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01052a5:	74 1f                	je     c01052c6 <default_check+0x341>
c01052a7:	8d 83 42 f7 fe ff    	lea    -0x108be(%ebx),%eax
c01052ad:	50                   	push   %eax
c01052ae:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c01052b4:	50                   	push   %eax
c01052b5:	68 e6 00 00 00       	push   $0xe6
c01052ba:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c01052c0:	50                   	push   %eax
c01052c1:	e8 07 b2 ff ff       	call   c01004cd <__panic>

    p2 = p0 + 1;
c01052c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052c9:	83 c0 14             	add    $0x14,%eax
c01052cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01052cf:	83 ec 08             	sub    $0x8,%esp
c01052d2:	6a 01                	push   $0x1
c01052d4:	ff 75 e8             	pushl  -0x18(%ebp)
c01052d7:	e8 c2 db ff ff       	call   c0102e9e <free_pages>
c01052dc:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c01052df:	83 ec 08             	sub    $0x8,%esp
c01052e2:	6a 03                	push   $0x3
c01052e4:	ff 75 e0             	pushl  -0x20(%ebp)
c01052e7:	e8 b2 db ff ff       	call   c0102e9e <free_pages>
c01052ec:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c01052ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052f2:	83 c0 04             	add    $0x4,%eax
c01052f5:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01052fc:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01052ff:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105302:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105305:	0f a3 10             	bt     %edx,(%eax)
c0105308:	19 c0                	sbb    %eax,%eax
c010530a:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010530d:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105311:	0f 95 c0             	setne  %al
c0105314:	0f b6 c0             	movzbl %al,%eax
c0105317:	85 c0                	test   %eax,%eax
c0105319:	74 0b                	je     c0105326 <default_check+0x3a1>
c010531b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010531e:	8b 40 08             	mov    0x8(%eax),%eax
c0105321:	83 f8 01             	cmp    $0x1,%eax
c0105324:	74 1f                	je     c0105345 <default_check+0x3c0>
c0105326:	8d 83 50 f7 fe ff    	lea    -0x108b0(%ebx),%eax
c010532c:	50                   	push   %eax
c010532d:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0105333:	50                   	push   %eax
c0105334:	68 eb 00 00 00       	push   $0xeb
c0105339:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c010533f:	50                   	push   %eax
c0105340:	e8 88 b1 ff ff       	call   c01004cd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0105345:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105348:	83 c0 04             	add    $0x4,%eax
c010534b:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0105352:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105355:	8b 45 90             	mov    -0x70(%ebp),%eax
c0105358:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010535b:	0f a3 10             	bt     %edx,(%eax)
c010535e:	19 c0                	sbb    %eax,%eax
c0105360:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0105363:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0105367:	0f 95 c0             	setne  %al
c010536a:	0f b6 c0             	movzbl %al,%eax
c010536d:	85 c0                	test   %eax,%eax
c010536f:	74 0b                	je     c010537c <default_check+0x3f7>
c0105371:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105374:	8b 40 08             	mov    0x8(%eax),%eax
c0105377:	83 f8 03             	cmp    $0x3,%eax
c010537a:	74 1f                	je     c010539b <default_check+0x416>
c010537c:	8d 83 78 f7 fe ff    	lea    -0x10888(%ebx),%eax
c0105382:	50                   	push   %eax
c0105383:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0105389:	50                   	push   %eax
c010538a:	68 ec 00 00 00       	push   $0xec
c010538f:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0105395:	50                   	push   %eax
c0105396:	e8 32 b1 ff ff       	call   c01004cd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010539b:	83 ec 0c             	sub    $0xc,%esp
c010539e:	6a 01                	push   $0x1
c01053a0:	e8 a9 da ff ff       	call   c0102e4e <alloc_pages>
c01053a5:	83 c4 10             	add    $0x10,%esp
c01053a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053ae:	83 e8 14             	sub    $0x14,%eax
c01053b1:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01053b4:	74 1f                	je     c01053d5 <default_check+0x450>
c01053b6:	8d 83 9e f7 fe ff    	lea    -0x10862(%ebx),%eax
c01053bc:	50                   	push   %eax
c01053bd:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c01053c3:	50                   	push   %eax
c01053c4:	68 ee 00 00 00       	push   $0xee
c01053c9:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c01053cf:	50                   	push   %eax
c01053d0:	e8 f8 b0 ff ff       	call   c01004cd <__panic>
    free_page(p0);
c01053d5:	83 ec 08             	sub    $0x8,%esp
c01053d8:	6a 01                	push   $0x1
c01053da:	ff 75 e8             	pushl  -0x18(%ebp)
c01053dd:	e8 bc da ff ff       	call   c0102e9e <free_pages>
c01053e2:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01053e5:	83 ec 0c             	sub    $0xc,%esp
c01053e8:	6a 02                	push   $0x2
c01053ea:	e8 5f da ff ff       	call   c0102e4e <alloc_pages>
c01053ef:	83 c4 10             	add    $0x10,%esp
c01053f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053f8:	83 c0 14             	add    $0x14,%eax
c01053fb:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01053fe:	74 1f                	je     c010541f <default_check+0x49a>
c0105400:	8d 83 bc f7 fe ff    	lea    -0x10844(%ebx),%eax
c0105406:	50                   	push   %eax
c0105407:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c010540d:	50                   	push   %eax
c010540e:	68 f0 00 00 00       	push   $0xf0
c0105413:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0105419:	50                   	push   %eax
c010541a:	e8 ae b0 ff ff       	call   c01004cd <__panic>

    free_pages(p0, 2);
c010541f:	83 ec 08             	sub    $0x8,%esp
c0105422:	6a 02                	push   $0x2
c0105424:	ff 75 e8             	pushl  -0x18(%ebp)
c0105427:	e8 72 da ff ff       	call   c0102e9e <free_pages>
c010542c:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010542f:	83 ec 08             	sub    $0x8,%esp
c0105432:	6a 01                	push   $0x1
c0105434:	ff 75 dc             	pushl  -0x24(%ebp)
c0105437:	e8 62 da ff ff       	call   c0102e9e <free_pages>
c010543c:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c010543f:	83 ec 0c             	sub    $0xc,%esp
c0105442:	6a 05                	push   $0x5
c0105444:	e8 05 da ff ff       	call   c0102e4e <alloc_pages>
c0105449:	83 c4 10             	add    $0x10,%esp
c010544c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010544f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105453:	75 1f                	jne    c0105474 <default_check+0x4ef>
c0105455:	8d 83 dc f7 fe ff    	lea    -0x10824(%ebx),%eax
c010545b:	50                   	push   %eax
c010545c:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0105462:	50                   	push   %eax
c0105463:	68 f5 00 00 00       	push   $0xf5
c0105468:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c010546e:	50                   	push   %eax
c010546f:	e8 59 b0 ff ff       	call   c01004cd <__panic>
    assert(alloc_page() == NULL);
c0105474:	83 ec 0c             	sub    $0xc,%esp
c0105477:	6a 01                	push   $0x1
c0105479:	e8 d0 d9 ff ff       	call   c0102e4e <alloc_pages>
c010547e:	83 c4 10             	add    $0x10,%esp
c0105481:	85 c0                	test   %eax,%eax
c0105483:	74 1f                	je     c01054a4 <default_check+0x51f>
c0105485:	8d 83 3a f6 fe ff    	lea    -0x109c6(%ebx),%eax
c010548b:	50                   	push   %eax
c010548c:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0105492:	50                   	push   %eax
c0105493:	68 f6 00 00 00       	push   $0xf6
c0105498:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c010549e:	50                   	push   %eax
c010549f:	e8 29 b0 ff ff       	call   c01004cd <__panic>

    assert(nr_free == 0);
c01054a4:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c01054aa:	8b 40 08             	mov    0x8(%eax),%eax
c01054ad:	85 c0                	test   %eax,%eax
c01054af:	74 1f                	je     c01054d0 <default_check+0x54b>
c01054b1:	8d 83 8d f6 fe ff    	lea    -0x10973(%ebx),%eax
c01054b7:	50                   	push   %eax
c01054b8:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c01054be:	50                   	push   %eax
c01054bf:	68 f8 00 00 00       	push   $0xf8
c01054c4:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c01054ca:	50                   	push   %eax
c01054cb:	e8 fd af ff ff       	call   c01004cd <__panic>
    nr_free = nr_free_store;
c01054d0:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c01054d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01054d9:	89 50 08             	mov    %edx,0x8(%eax)

    free_list = free_list_store;
c01054dc:	c7 c1 1c 8a 11 c0    	mov    $0xc0118a1c,%ecx
c01054e2:	8b 45 80             	mov    -0x80(%ebp),%eax
c01054e5:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01054e8:	89 01                	mov    %eax,(%ecx)
c01054ea:	89 51 04             	mov    %edx,0x4(%ecx)
    free_pages(p0, 5);
c01054ed:	83 ec 08             	sub    $0x8,%esp
c01054f0:	6a 05                	push   $0x5
c01054f2:	ff 75 e8             	pushl  -0x18(%ebp)
c01054f5:	e8 a4 d9 ff ff       	call   c0102e9e <free_pages>
c01054fa:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c01054fd:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c0105503:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105506:	eb 1d                	jmp    c0105525 <default_check+0x5a0>
        struct Page *p = le2page(le, page_link);
c0105508:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010550b:	83 e8 0c             	sub    $0xc,%eax
c010550e:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0105511:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0105515:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105518:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010551b:	8b 40 08             	mov    0x8(%eax),%eax
c010551e:	29 c2                	sub    %eax,%edx
c0105520:	89 d0                	mov    %edx,%eax
c0105522:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105525:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105528:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c010552b:	8b 45 88             	mov    -0x78(%ebp),%eax
c010552e:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105531:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105534:	c7 c0 1c 8a 11 c0    	mov    $0xc0118a1c,%eax
c010553a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010553d:	75 c9                	jne    c0105508 <default_check+0x583>
    }
    assert(count == 0);
c010553f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105543:	74 1f                	je     c0105564 <default_check+0x5df>
c0105545:	8d 83 fa f7 fe ff    	lea    -0x10806(%ebx),%eax
c010554b:	50                   	push   %eax
c010554c:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0105552:	50                   	push   %eax
c0105553:	68 03 01 00 00       	push   $0x103
c0105558:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c010555e:	50                   	push   %eax
c010555f:	e8 69 af ff ff       	call   c01004cd <__panic>
    assert(total == 0);
c0105564:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105568:	74 1f                	je     c0105589 <default_check+0x604>
c010556a:	8d 83 05 f8 fe ff    	lea    -0x107fb(%ebx),%eax
c0105570:	50                   	push   %eax
c0105571:	8d 83 b2 f4 fe ff    	lea    -0x10b4e(%ebx),%eax
c0105577:	50                   	push   %eax
c0105578:	68 04 01 00 00       	push   $0x104
c010557d:	8d 83 c7 f4 fe ff    	lea    -0x10b39(%ebx),%eax
c0105583:	50                   	push   %eax
c0105584:	e8 44 af ff ff       	call   c01004cd <__panic>
}
c0105589:	90                   	nop
c010558a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010558d:	c9                   	leave  
c010558e:	c3                   	ret    

c010558f <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010558f:	55                   	push   %ebp
c0105590:	89 e5                	mov    %esp,%ebp
c0105592:	83 ec 10             	sub    $0x10,%esp
c0105595:	e8 0c ad ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c010559a:	05 d6 23 01 00       	add    $0x123d6,%eax
    size_t cnt = 0;
c010559f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01055a6:	eb 04                	jmp    c01055ac <strlen+0x1d>
        cnt ++;
c01055a8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c01055ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01055af:	8d 50 01             	lea    0x1(%eax),%edx
c01055b2:	89 55 08             	mov    %edx,0x8(%ebp)
c01055b5:	0f b6 00             	movzbl (%eax),%eax
c01055b8:	84 c0                	test   %al,%al
c01055ba:	75 ec                	jne    c01055a8 <strlen+0x19>
    }
    return cnt;
c01055bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01055bf:	c9                   	leave  
c01055c0:	c3                   	ret    

c01055c1 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01055c1:	55                   	push   %ebp
c01055c2:	89 e5                	mov    %esp,%ebp
c01055c4:	83 ec 10             	sub    $0x10,%esp
c01055c7:	e8 da ac ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01055cc:	05 a4 23 01 00       	add    $0x123a4,%eax
    size_t cnt = 0;
c01055d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01055d8:	eb 04                	jmp    c01055de <strnlen+0x1d>
        cnt ++;
c01055da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01055de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01055e4:	73 10                	jae    c01055f6 <strnlen+0x35>
c01055e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e9:	8d 50 01             	lea    0x1(%eax),%edx
c01055ec:	89 55 08             	mov    %edx,0x8(%ebp)
c01055ef:	0f b6 00             	movzbl (%eax),%eax
c01055f2:	84 c0                	test   %al,%al
c01055f4:	75 e4                	jne    c01055da <strnlen+0x19>
    }
    return cnt;
c01055f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01055f9:	c9                   	leave  
c01055fa:	c3                   	ret    

c01055fb <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01055fb:	55                   	push   %ebp
c01055fc:	89 e5                	mov    %esp,%ebp
c01055fe:	57                   	push   %edi
c01055ff:	56                   	push   %esi
c0105600:	83 ec 20             	sub    $0x20,%esp
c0105603:	e8 9e ac ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0105608:	05 68 23 01 00       	add    $0x12368,%eax
c010560d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105610:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105613:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105616:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105619:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010561c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010561f:	89 d1                	mov    %edx,%ecx
c0105621:	89 c2                	mov    %eax,%edx
c0105623:	89 ce                	mov    %ecx,%esi
c0105625:	89 d7                	mov    %edx,%edi
c0105627:	ac                   	lods   %ds:(%esi),%al
c0105628:	aa                   	stos   %al,%es:(%edi)
c0105629:	84 c0                	test   %al,%al
c010562b:	75 fa                	jne    c0105627 <strcpy+0x2c>
c010562d:	89 fa                	mov    %edi,%edx
c010562f:	89 f1                	mov    %esi,%ecx
c0105631:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105634:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105637:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010563a:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c010563d:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010563e:	83 c4 20             	add    $0x20,%esp
c0105641:	5e                   	pop    %esi
c0105642:	5f                   	pop    %edi
c0105643:	5d                   	pop    %ebp
c0105644:	c3                   	ret    

c0105645 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105645:	55                   	push   %ebp
c0105646:	89 e5                	mov    %esp,%ebp
c0105648:	83 ec 10             	sub    $0x10,%esp
c010564b:	e8 56 ac ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0105650:	05 20 23 01 00       	add    $0x12320,%eax
    char *p = dst;
c0105655:	8b 45 08             	mov    0x8(%ebp),%eax
c0105658:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010565b:	eb 21                	jmp    c010567e <strncpy+0x39>
        if ((*p = *src) != '\0') {
c010565d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105660:	0f b6 10             	movzbl (%eax),%edx
c0105663:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105666:	88 10                	mov    %dl,(%eax)
c0105668:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010566b:	0f b6 00             	movzbl (%eax),%eax
c010566e:	84 c0                	test   %al,%al
c0105670:	74 04                	je     c0105676 <strncpy+0x31>
            src ++;
c0105672:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105676:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010567a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c010567e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105682:	75 d9                	jne    c010565d <strncpy+0x18>
    }
    return dst;
c0105684:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105687:	c9                   	leave  
c0105688:	c3                   	ret    

c0105689 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105689:	55                   	push   %ebp
c010568a:	89 e5                	mov    %esp,%ebp
c010568c:	57                   	push   %edi
c010568d:	56                   	push   %esi
c010568e:	83 ec 20             	sub    $0x20,%esp
c0105691:	e8 10 ac ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0105696:	05 da 22 01 00       	add    $0x122da,%eax
c010569b:	8b 45 08             	mov    0x8(%ebp),%eax
c010569e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01056a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01056a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056ad:	89 d1                	mov    %edx,%ecx
c01056af:	89 c2                	mov    %eax,%edx
c01056b1:	89 ce                	mov    %ecx,%esi
c01056b3:	89 d7                	mov    %edx,%edi
c01056b5:	ac                   	lods   %ds:(%esi),%al
c01056b6:	ae                   	scas   %es:(%edi),%al
c01056b7:	75 08                	jne    c01056c1 <strcmp+0x38>
c01056b9:	84 c0                	test   %al,%al
c01056bb:	75 f8                	jne    c01056b5 <strcmp+0x2c>
c01056bd:	31 c0                	xor    %eax,%eax
c01056bf:	eb 04                	jmp    c01056c5 <strcmp+0x3c>
c01056c1:	19 c0                	sbb    %eax,%eax
c01056c3:	0c 01                	or     $0x1,%al
c01056c5:	89 fa                	mov    %edi,%edx
c01056c7:	89 f1                	mov    %esi,%ecx
c01056c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01056cc:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01056cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c01056d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c01056d5:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01056d6:	83 c4 20             	add    $0x20,%esp
c01056d9:	5e                   	pop    %esi
c01056da:	5f                   	pop    %edi
c01056db:	5d                   	pop    %ebp
c01056dc:	c3                   	ret    

c01056dd <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01056dd:	55                   	push   %ebp
c01056de:	89 e5                	mov    %esp,%ebp
c01056e0:	e8 c1 ab ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01056e5:	05 8b 22 01 00       	add    $0x1228b,%eax
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01056ea:	eb 0c                	jmp    c01056f8 <strncmp+0x1b>
        n --, s1 ++, s2 ++;
c01056ec:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01056f0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01056f4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01056f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01056fc:	74 1a                	je     c0105718 <strncmp+0x3b>
c01056fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105701:	0f b6 00             	movzbl (%eax),%eax
c0105704:	84 c0                	test   %al,%al
c0105706:	74 10                	je     c0105718 <strncmp+0x3b>
c0105708:	8b 45 08             	mov    0x8(%ebp),%eax
c010570b:	0f b6 10             	movzbl (%eax),%edx
c010570e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105711:	0f b6 00             	movzbl (%eax),%eax
c0105714:	38 c2                	cmp    %al,%dl
c0105716:	74 d4                	je     c01056ec <strncmp+0xf>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105718:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010571c:	74 18                	je     c0105736 <strncmp+0x59>
c010571e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105721:	0f b6 00             	movzbl (%eax),%eax
c0105724:	0f b6 d0             	movzbl %al,%edx
c0105727:	8b 45 0c             	mov    0xc(%ebp),%eax
c010572a:	0f b6 00             	movzbl (%eax),%eax
c010572d:	0f b6 c0             	movzbl %al,%eax
c0105730:	29 c2                	sub    %eax,%edx
c0105732:	89 d0                	mov    %edx,%eax
c0105734:	eb 05                	jmp    c010573b <strncmp+0x5e>
c0105736:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010573b:	5d                   	pop    %ebp
c010573c:	c3                   	ret    

c010573d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010573d:	55                   	push   %ebp
c010573e:	89 e5                	mov    %esp,%ebp
c0105740:	83 ec 04             	sub    $0x4,%esp
c0105743:	e8 5e ab ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0105748:	05 28 22 01 00       	add    $0x12228,%eax
c010574d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105750:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105753:	eb 14                	jmp    c0105769 <strchr+0x2c>
        if (*s == c) {
c0105755:	8b 45 08             	mov    0x8(%ebp),%eax
c0105758:	0f b6 00             	movzbl (%eax),%eax
c010575b:	38 45 fc             	cmp    %al,-0x4(%ebp)
c010575e:	75 05                	jne    c0105765 <strchr+0x28>
            return (char *)s;
c0105760:	8b 45 08             	mov    0x8(%ebp),%eax
c0105763:	eb 13                	jmp    c0105778 <strchr+0x3b>
        }
        s ++;
c0105765:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0105769:	8b 45 08             	mov    0x8(%ebp),%eax
c010576c:	0f b6 00             	movzbl (%eax),%eax
c010576f:	84 c0                	test   %al,%al
c0105771:	75 e2                	jne    c0105755 <strchr+0x18>
    }
    return NULL;
c0105773:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105778:	c9                   	leave  
c0105779:	c3                   	ret    

c010577a <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010577a:	55                   	push   %ebp
c010577b:	89 e5                	mov    %esp,%ebp
c010577d:	83 ec 04             	sub    $0x4,%esp
c0105780:	e8 21 ab ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0105785:	05 eb 21 01 00       	add    $0x121eb,%eax
c010578a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010578d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105790:	eb 0f                	jmp    c01057a1 <strfind+0x27>
        if (*s == c) {
c0105792:	8b 45 08             	mov    0x8(%ebp),%eax
c0105795:	0f b6 00             	movzbl (%eax),%eax
c0105798:	38 45 fc             	cmp    %al,-0x4(%ebp)
c010579b:	74 10                	je     c01057ad <strfind+0x33>
            break;
        }
        s ++;
c010579d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c01057a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a4:	0f b6 00             	movzbl (%eax),%eax
c01057a7:	84 c0                	test   %al,%al
c01057a9:	75 e7                	jne    c0105792 <strfind+0x18>
c01057ab:	eb 01                	jmp    c01057ae <strfind+0x34>
            break;
c01057ad:	90                   	nop
    }
    return (char *)s;
c01057ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01057b1:	c9                   	leave  
c01057b2:	c3                   	ret    

c01057b3 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01057b3:	55                   	push   %ebp
c01057b4:	89 e5                	mov    %esp,%ebp
c01057b6:	83 ec 10             	sub    $0x10,%esp
c01057b9:	e8 e8 aa ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01057be:	05 b2 21 01 00       	add    $0x121b2,%eax
    int neg = 0;
c01057c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01057ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01057d1:	eb 04                	jmp    c01057d7 <strtol+0x24>
        s ++;
c01057d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01057d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01057da:	0f b6 00             	movzbl (%eax),%eax
c01057dd:	3c 20                	cmp    $0x20,%al
c01057df:	74 f2                	je     c01057d3 <strtol+0x20>
c01057e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e4:	0f b6 00             	movzbl (%eax),%eax
c01057e7:	3c 09                	cmp    $0x9,%al
c01057e9:	74 e8                	je     c01057d3 <strtol+0x20>
    }

    // plus/minus sign
    if (*s == '+') {
c01057eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ee:	0f b6 00             	movzbl (%eax),%eax
c01057f1:	3c 2b                	cmp    $0x2b,%al
c01057f3:	75 06                	jne    c01057fb <strtol+0x48>
        s ++;
c01057f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01057f9:	eb 15                	jmp    c0105810 <strtol+0x5d>
    }
    else if (*s == '-') {
c01057fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01057fe:	0f b6 00             	movzbl (%eax),%eax
c0105801:	3c 2d                	cmp    $0x2d,%al
c0105803:	75 0b                	jne    c0105810 <strtol+0x5d>
        s ++, neg = 1;
c0105805:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105809:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105810:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105814:	74 06                	je     c010581c <strtol+0x69>
c0105816:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010581a:	75 24                	jne    c0105840 <strtol+0x8d>
c010581c:	8b 45 08             	mov    0x8(%ebp),%eax
c010581f:	0f b6 00             	movzbl (%eax),%eax
c0105822:	3c 30                	cmp    $0x30,%al
c0105824:	75 1a                	jne    c0105840 <strtol+0x8d>
c0105826:	8b 45 08             	mov    0x8(%ebp),%eax
c0105829:	83 c0 01             	add    $0x1,%eax
c010582c:	0f b6 00             	movzbl (%eax),%eax
c010582f:	3c 78                	cmp    $0x78,%al
c0105831:	75 0d                	jne    c0105840 <strtol+0x8d>
        s += 2, base = 16;
c0105833:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105837:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010583e:	eb 2a                	jmp    c010586a <strtol+0xb7>
    }
    else if (base == 0 && s[0] == '0') {
c0105840:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105844:	75 17                	jne    c010585d <strtol+0xaa>
c0105846:	8b 45 08             	mov    0x8(%ebp),%eax
c0105849:	0f b6 00             	movzbl (%eax),%eax
c010584c:	3c 30                	cmp    $0x30,%al
c010584e:	75 0d                	jne    c010585d <strtol+0xaa>
        s ++, base = 8;
c0105850:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105854:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010585b:	eb 0d                	jmp    c010586a <strtol+0xb7>
    }
    else if (base == 0) {
c010585d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105861:	75 07                	jne    c010586a <strtol+0xb7>
        base = 10;
c0105863:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010586a:	8b 45 08             	mov    0x8(%ebp),%eax
c010586d:	0f b6 00             	movzbl (%eax),%eax
c0105870:	3c 2f                	cmp    $0x2f,%al
c0105872:	7e 1b                	jle    c010588f <strtol+0xdc>
c0105874:	8b 45 08             	mov    0x8(%ebp),%eax
c0105877:	0f b6 00             	movzbl (%eax),%eax
c010587a:	3c 39                	cmp    $0x39,%al
c010587c:	7f 11                	jg     c010588f <strtol+0xdc>
            dig = *s - '0';
c010587e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105881:	0f b6 00             	movzbl (%eax),%eax
c0105884:	0f be c0             	movsbl %al,%eax
c0105887:	83 e8 30             	sub    $0x30,%eax
c010588a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010588d:	eb 48                	jmp    c01058d7 <strtol+0x124>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010588f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105892:	0f b6 00             	movzbl (%eax),%eax
c0105895:	3c 60                	cmp    $0x60,%al
c0105897:	7e 1b                	jle    c01058b4 <strtol+0x101>
c0105899:	8b 45 08             	mov    0x8(%ebp),%eax
c010589c:	0f b6 00             	movzbl (%eax),%eax
c010589f:	3c 7a                	cmp    $0x7a,%al
c01058a1:	7f 11                	jg     c01058b4 <strtol+0x101>
            dig = *s - 'a' + 10;
c01058a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01058a6:	0f b6 00             	movzbl (%eax),%eax
c01058a9:	0f be c0             	movsbl %al,%eax
c01058ac:	83 e8 57             	sub    $0x57,%eax
c01058af:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01058b2:	eb 23                	jmp    c01058d7 <strtol+0x124>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01058b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01058b7:	0f b6 00             	movzbl (%eax),%eax
c01058ba:	3c 40                	cmp    $0x40,%al
c01058bc:	7e 3c                	jle    c01058fa <strtol+0x147>
c01058be:	8b 45 08             	mov    0x8(%ebp),%eax
c01058c1:	0f b6 00             	movzbl (%eax),%eax
c01058c4:	3c 5a                	cmp    $0x5a,%al
c01058c6:	7f 32                	jg     c01058fa <strtol+0x147>
            dig = *s - 'A' + 10;
c01058c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01058cb:	0f b6 00             	movzbl (%eax),%eax
c01058ce:	0f be c0             	movsbl %al,%eax
c01058d1:	83 e8 37             	sub    $0x37,%eax
c01058d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01058d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058da:	3b 45 10             	cmp    0x10(%ebp),%eax
c01058dd:	7d 1a                	jge    c01058f9 <strtol+0x146>
            break;
        }
        s ++, val = (val * base) + dig;
c01058df:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01058e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01058e6:	0f af 45 10          	imul   0x10(%ebp),%eax
c01058ea:	89 c2                	mov    %eax,%edx
c01058ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058ef:	01 d0                	add    %edx,%eax
c01058f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c01058f4:	e9 71 ff ff ff       	jmp    c010586a <strtol+0xb7>
            break;
c01058f9:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c01058fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01058fe:	74 08                	je     c0105908 <strtol+0x155>
        *endptr = (char *) s;
c0105900:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105903:	8b 55 08             	mov    0x8(%ebp),%edx
c0105906:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105908:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010590c:	74 07                	je     c0105915 <strtol+0x162>
c010590e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105911:	f7 d8                	neg    %eax
c0105913:	eb 03                	jmp    c0105918 <strtol+0x165>
c0105915:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105918:	c9                   	leave  
c0105919:	c3                   	ret    

c010591a <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010591a:	55                   	push   %ebp
c010591b:	89 e5                	mov    %esp,%ebp
c010591d:	57                   	push   %edi
c010591e:	83 ec 24             	sub    $0x24,%esp
c0105921:	e8 80 a9 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0105926:	05 4a 20 01 00       	add    $0x1204a,%eax
c010592b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010592e:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105931:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105935:	8b 55 08             	mov    0x8(%ebp),%edx
c0105938:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010593b:	88 45 f7             	mov    %al,-0x9(%ebp)
c010593e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105941:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105944:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105947:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010594b:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010594e:	89 d7                	mov    %edx,%edi
c0105950:	f3 aa                	rep stos %al,%es:(%edi)
c0105952:	89 fa                	mov    %edi,%edx
c0105954:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105957:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010595a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010595d:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010595e:	83 c4 24             	add    $0x24,%esp
c0105961:	5f                   	pop    %edi
c0105962:	5d                   	pop    %ebp
c0105963:	c3                   	ret    

c0105964 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105964:	55                   	push   %ebp
c0105965:	89 e5                	mov    %esp,%ebp
c0105967:	57                   	push   %edi
c0105968:	56                   	push   %esi
c0105969:	53                   	push   %ebx
c010596a:	83 ec 30             	sub    $0x30,%esp
c010596d:	e8 34 a9 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0105972:	05 fe 1f 01 00       	add    $0x11ffe,%eax
c0105977:	8b 45 08             	mov    0x8(%ebp),%eax
c010597a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010597d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105980:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105983:	8b 45 10             	mov    0x10(%ebp),%eax
c0105986:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105989:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010598c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010598f:	73 42                	jae    c01059d3 <memmove+0x6f>
c0105991:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105994:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105997:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010599a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010599d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01059a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01059a6:	c1 e8 02             	shr    $0x2,%eax
c01059a9:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01059ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01059ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059b1:	89 d7                	mov    %edx,%edi
c01059b3:	89 c6                	mov    %eax,%esi
c01059b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01059b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01059ba:	83 e1 03             	and    $0x3,%ecx
c01059bd:	74 02                	je     c01059c1 <memmove+0x5d>
c01059bf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01059c1:	89 f0                	mov    %esi,%eax
c01059c3:	89 fa                	mov    %edi,%edx
c01059c5:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01059c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01059cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01059ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c01059d1:	eb 36                	jmp    c0105a09 <memmove+0xa5>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01059d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059d6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01059d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059dc:	01 c2                	add    %eax,%edx
c01059de:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059e1:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01059e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059e7:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01059ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059ed:	89 c1                	mov    %eax,%ecx
c01059ef:	89 d8                	mov    %ebx,%eax
c01059f1:	89 d6                	mov    %edx,%esi
c01059f3:	89 c7                	mov    %eax,%edi
c01059f5:	fd                   	std    
c01059f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01059f8:	fc                   	cld    
c01059f9:	89 f8                	mov    %edi,%eax
c01059fb:	89 f2                	mov    %esi,%edx
c01059fd:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105a00:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105a03:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105a09:	83 c4 30             	add    $0x30,%esp
c0105a0c:	5b                   	pop    %ebx
c0105a0d:	5e                   	pop    %esi
c0105a0e:	5f                   	pop    %edi
c0105a0f:	5d                   	pop    %ebp
c0105a10:	c3                   	ret    

c0105a11 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105a11:	55                   	push   %ebp
c0105a12:	89 e5                	mov    %esp,%ebp
c0105a14:	57                   	push   %edi
c0105a15:	56                   	push   %esi
c0105a16:	83 ec 20             	sub    $0x20,%esp
c0105a19:	e8 88 a8 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0105a1e:	05 52 1f 01 00       	add    $0x11f52,%eax
c0105a23:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a2f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a32:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a38:	c1 e8 02             	shr    $0x2,%eax
c0105a3b:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a43:	89 d7                	mov    %edx,%edi
c0105a45:	89 c6                	mov    %eax,%esi
c0105a47:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105a49:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105a4c:	83 e1 03             	and    $0x3,%ecx
c0105a4f:	74 02                	je     c0105a53 <memcpy+0x42>
c0105a51:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105a53:	89 f0                	mov    %esi,%eax
c0105a55:	89 fa                	mov    %edi,%edx
c0105a57:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105a5a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105a5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0105a63:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105a64:	83 c4 20             	add    $0x20,%esp
c0105a67:	5e                   	pop    %esi
c0105a68:	5f                   	pop    %edi
c0105a69:	5d                   	pop    %ebp
c0105a6a:	c3                   	ret    

c0105a6b <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105a6b:	55                   	push   %ebp
c0105a6c:	89 e5                	mov    %esp,%ebp
c0105a6e:	83 ec 10             	sub    $0x10,%esp
c0105a71:	e8 30 a8 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0105a76:	05 fa 1e 01 00       	add    $0x11efa,%eax
    const char *s1 = (const char *)v1;
c0105a7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105a81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a84:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105a87:	eb 30                	jmp    c0105ab9 <memcmp+0x4e>
        if (*s1 != *s2) {
c0105a89:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a8c:	0f b6 10             	movzbl (%eax),%edx
c0105a8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105a92:	0f b6 00             	movzbl (%eax),%eax
c0105a95:	38 c2                	cmp    %al,%dl
c0105a97:	74 18                	je     c0105ab1 <memcmp+0x46>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105a99:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a9c:	0f b6 00             	movzbl (%eax),%eax
c0105a9f:	0f b6 d0             	movzbl %al,%edx
c0105aa2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105aa5:	0f b6 00             	movzbl (%eax),%eax
c0105aa8:	0f b6 c0             	movzbl %al,%eax
c0105aab:	29 c2                	sub    %eax,%edx
c0105aad:	89 d0                	mov    %edx,%eax
c0105aaf:	eb 1a                	jmp    c0105acb <memcmp+0x60>
        }
        s1 ++, s2 ++;
c0105ab1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105ab5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c0105ab9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105abc:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105abf:	89 55 10             	mov    %edx,0x10(%ebp)
c0105ac2:	85 c0                	test   %eax,%eax
c0105ac4:	75 c3                	jne    c0105a89 <memcmp+0x1e>
    }
    return 0;
c0105ac6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105acb:	c9                   	leave  
c0105acc:	c3                   	ret    

c0105acd <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105acd:	55                   	push   %ebp
c0105ace:	89 e5                	mov    %esp,%ebp
c0105ad0:	53                   	push   %ebx
c0105ad1:	83 ec 34             	sub    $0x34,%esp
c0105ad4:	e8 d1 a7 ff ff       	call   c01002aa <__x86.get_pc_thunk.bx>
c0105ad9:	81 c3 97 1e 01 00    	add    $0x11e97,%ebx
c0105adf:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ae2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105ae5:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ae8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105aeb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105aee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105af1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105af4:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105af7:	8b 45 18             	mov    0x18(%ebp),%eax
c0105afa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105afd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b00:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105b03:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105b06:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105b13:	74 1c                	je     c0105b31 <printnum+0x64>
c0105b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b18:	ba 00 00 00 00       	mov    $0x0,%edx
c0105b1d:	f7 75 e4             	divl   -0x1c(%ebp)
c0105b20:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b26:	ba 00 00 00 00       	mov    $0x0,%edx
c0105b2b:	f7 75 e4             	divl   -0x1c(%ebp)
c0105b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b37:	f7 75 e4             	divl   -0x1c(%ebp)
c0105b3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105b3d:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105b40:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b43:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b46:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105b49:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105b4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b4f:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105b52:	8b 45 18             	mov    0x18(%ebp),%eax
c0105b55:	ba 00 00 00 00       	mov    $0x0,%edx
c0105b5a:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0105b5d:	72 41                	jb     c0105ba0 <printnum+0xd3>
c0105b5f:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0105b62:	77 05                	ja     c0105b69 <printnum+0x9c>
c0105b64:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105b67:	72 37                	jb     c0105ba0 <printnum+0xd3>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105b69:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105b6c:	83 e8 01             	sub    $0x1,%eax
c0105b6f:	83 ec 04             	sub    $0x4,%esp
c0105b72:	ff 75 20             	pushl  0x20(%ebp)
c0105b75:	50                   	push   %eax
c0105b76:	ff 75 18             	pushl  0x18(%ebp)
c0105b79:	ff 75 ec             	pushl  -0x14(%ebp)
c0105b7c:	ff 75 e8             	pushl  -0x18(%ebp)
c0105b7f:	ff 75 0c             	pushl  0xc(%ebp)
c0105b82:	ff 75 08             	pushl  0x8(%ebp)
c0105b85:	e8 43 ff ff ff       	call   c0105acd <printnum>
c0105b8a:	83 c4 20             	add    $0x20,%esp
c0105b8d:	eb 1b                	jmp    c0105baa <printnum+0xdd>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105b8f:	83 ec 08             	sub    $0x8,%esp
c0105b92:	ff 75 0c             	pushl  0xc(%ebp)
c0105b95:	ff 75 20             	pushl  0x20(%ebp)
c0105b98:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b9b:	ff d0                	call   *%eax
c0105b9d:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
c0105ba0:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105ba4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105ba8:	7f e5                	jg     c0105b8f <printnum+0xc2>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105baa:	8d 93 86 f8 fe ff    	lea    -0x1077a(%ebx),%edx
c0105bb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105bb3:	01 d0                	add    %edx,%eax
c0105bb5:	0f b6 00             	movzbl (%eax),%eax
c0105bb8:	0f be c0             	movsbl %al,%eax
c0105bbb:	83 ec 08             	sub    $0x8,%esp
c0105bbe:	ff 75 0c             	pushl  0xc(%ebp)
c0105bc1:	50                   	push   %eax
c0105bc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc5:	ff d0                	call   *%eax
c0105bc7:	83 c4 10             	add    $0x10,%esp
}
c0105bca:	90                   	nop
c0105bcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0105bce:	c9                   	leave  
c0105bcf:	c3                   	ret    

c0105bd0 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105bd0:	55                   	push   %ebp
c0105bd1:	89 e5                	mov    %esp,%ebp
c0105bd3:	e8 ce a6 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0105bd8:	05 98 1d 01 00       	add    $0x11d98,%eax
    if (lflag >= 2) {
c0105bdd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105be1:	7e 14                	jle    c0105bf7 <getuint+0x27>
        return va_arg(*ap, unsigned long long);
c0105be3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be6:	8b 00                	mov    (%eax),%eax
c0105be8:	8d 48 08             	lea    0x8(%eax),%ecx
c0105beb:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bee:	89 0a                	mov    %ecx,(%edx)
c0105bf0:	8b 50 04             	mov    0x4(%eax),%edx
c0105bf3:	8b 00                	mov    (%eax),%eax
c0105bf5:	eb 30                	jmp    c0105c27 <getuint+0x57>
    }
    else if (lflag) {
c0105bf7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105bfb:	74 16                	je     c0105c13 <getuint+0x43>
        return va_arg(*ap, unsigned long);
c0105bfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c00:	8b 00                	mov    (%eax),%eax
c0105c02:	8d 48 04             	lea    0x4(%eax),%ecx
c0105c05:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c08:	89 0a                	mov    %ecx,(%edx)
c0105c0a:	8b 00                	mov    (%eax),%eax
c0105c0c:	ba 00 00 00 00       	mov    $0x0,%edx
c0105c11:	eb 14                	jmp    c0105c27 <getuint+0x57>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105c13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c16:	8b 00                	mov    (%eax),%eax
c0105c18:	8d 48 04             	lea    0x4(%eax),%ecx
c0105c1b:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c1e:	89 0a                	mov    %ecx,(%edx)
c0105c20:	8b 00                	mov    (%eax),%eax
c0105c22:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105c27:	5d                   	pop    %ebp
c0105c28:	c3                   	ret    

c0105c29 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105c29:	55                   	push   %ebp
c0105c2a:	89 e5                	mov    %esp,%ebp
c0105c2c:	e8 75 a6 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0105c31:	05 3f 1d 01 00       	add    $0x11d3f,%eax
    if (lflag >= 2) {
c0105c36:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105c3a:	7e 14                	jle    c0105c50 <getint+0x27>
        return va_arg(*ap, long long);
c0105c3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c3f:	8b 00                	mov    (%eax),%eax
c0105c41:	8d 48 08             	lea    0x8(%eax),%ecx
c0105c44:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c47:	89 0a                	mov    %ecx,(%edx)
c0105c49:	8b 50 04             	mov    0x4(%eax),%edx
c0105c4c:	8b 00                	mov    (%eax),%eax
c0105c4e:	eb 28                	jmp    c0105c78 <getint+0x4f>
    }
    else if (lflag) {
c0105c50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105c54:	74 12                	je     c0105c68 <getint+0x3f>
        return va_arg(*ap, long);
c0105c56:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c59:	8b 00                	mov    (%eax),%eax
c0105c5b:	8d 48 04             	lea    0x4(%eax),%ecx
c0105c5e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c61:	89 0a                	mov    %ecx,(%edx)
c0105c63:	8b 00                	mov    (%eax),%eax
c0105c65:	99                   	cltd   
c0105c66:	eb 10                	jmp    c0105c78 <getint+0x4f>
    }
    else {
        return va_arg(*ap, int);
c0105c68:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c6b:	8b 00                	mov    (%eax),%eax
c0105c6d:	8d 48 04             	lea    0x4(%eax),%ecx
c0105c70:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c73:	89 0a                	mov    %ecx,(%edx)
c0105c75:	8b 00                	mov    (%eax),%eax
c0105c77:	99                   	cltd   
    }
}
c0105c78:	5d                   	pop    %ebp
c0105c79:	c3                   	ret    

c0105c7a <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105c7a:	55                   	push   %ebp
c0105c7b:	89 e5                	mov    %esp,%ebp
c0105c7d:	83 ec 18             	sub    $0x18,%esp
c0105c80:	e8 21 a6 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0105c85:	05 eb 1c 01 00       	add    $0x11ceb,%eax
    va_list ap;

    va_start(ap, fmt);
c0105c8a:	8d 45 14             	lea    0x14(%ebp),%eax
c0105c8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c93:	50                   	push   %eax
c0105c94:	ff 75 10             	pushl  0x10(%ebp)
c0105c97:	ff 75 0c             	pushl  0xc(%ebp)
c0105c9a:	ff 75 08             	pushl  0x8(%ebp)
c0105c9d:	e8 06 00 00 00       	call   c0105ca8 <vprintfmt>
c0105ca2:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0105ca5:	90                   	nop
c0105ca6:	c9                   	leave  
c0105ca7:	c3                   	ret    

c0105ca8 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105ca8:	55                   	push   %ebp
c0105ca9:	89 e5                	mov    %esp,%ebp
c0105cab:	57                   	push   %edi
c0105cac:	56                   	push   %esi
c0105cad:	53                   	push   %ebx
c0105cae:	83 ec 2c             	sub    $0x2c,%esp
c0105cb1:	e8 8c 04 00 00       	call   c0106142 <__x86.get_pc_thunk.di>
c0105cb6:	81 c7 ba 1c 01 00    	add    $0x11cba,%edi
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105cbc:	eb 17                	jmp    c0105cd5 <vprintfmt+0x2d>
            if (ch == '\0') {
c0105cbe:	85 db                	test   %ebx,%ebx
c0105cc0:	0f 84 9a 03 00 00    	je     c0106060 <.L24+0x2d>
                return;
            }
            putch(ch, putdat);
c0105cc6:	83 ec 08             	sub    $0x8,%esp
c0105cc9:	ff 75 0c             	pushl  0xc(%ebp)
c0105ccc:	53                   	push   %ebx
c0105ccd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd0:	ff d0                	call   *%eax
c0105cd2:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105cd5:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cd8:	8d 50 01             	lea    0x1(%eax),%edx
c0105cdb:	89 55 10             	mov    %edx,0x10(%ebp)
c0105cde:	0f b6 00             	movzbl (%eax),%eax
c0105ce1:	0f b6 d8             	movzbl %al,%ebx
c0105ce4:	83 fb 25             	cmp    $0x25,%ebx
c0105ce7:	75 d5                	jne    c0105cbe <vprintfmt+0x16>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105ce9:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
        width = precision = -1;
c0105ced:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
c0105cf4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105cf7:	89 45 d8             	mov    %eax,-0x28(%ebp)
        lflag = altflag = 0;
c0105cfa:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
c0105d01:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105d04:	89 45 d0             	mov    %eax,-0x30(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105d07:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d0a:	8d 50 01             	lea    0x1(%eax),%edx
c0105d0d:	89 55 10             	mov    %edx,0x10(%ebp)
c0105d10:	0f b6 00             	movzbl (%eax),%eax
c0105d13:	0f b6 d8             	movzbl %al,%ebx
c0105d16:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105d19:	83 f8 55             	cmp    $0x55,%eax
c0105d1c:	0f 87 11 03 00 00    	ja     c0106033 <.L24>
c0105d22:	c1 e0 02             	shl    $0x2,%eax
c0105d25:	8b 84 38 ac f8 fe ff 	mov    -0x10754(%eax,%edi,1),%eax
c0105d2c:	01 f8                	add    %edi,%eax
c0105d2e:	ff e0                	jmp    *%eax

c0105d30 <.L29>:

        // flag to pad on the right
        case '-':
            padc = '-';
c0105d30:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
            goto reswitch;
c0105d34:	eb d1                	jmp    c0105d07 <vprintfmt+0x5f>

c0105d36 <.L31>:

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105d36:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
            goto reswitch;
c0105d3a:	eb cb                	jmp    c0105d07 <vprintfmt+0x5f>

c0105d3c <.L32>:

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105d3c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
                precision = precision * 10 + ch - '0';
c0105d43:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105d46:	89 d0                	mov    %edx,%eax
c0105d48:	c1 e0 02             	shl    $0x2,%eax
c0105d4b:	01 d0                	add    %edx,%eax
c0105d4d:	01 c0                	add    %eax,%eax
c0105d4f:	01 d8                	add    %ebx,%eax
c0105d51:	83 e8 30             	sub    $0x30,%eax
c0105d54:	89 45 d4             	mov    %eax,-0x2c(%ebp)
                ch = *fmt;
c0105d57:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d5a:	0f b6 00             	movzbl (%eax),%eax
c0105d5d:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105d60:	83 fb 2f             	cmp    $0x2f,%ebx
c0105d63:	7e 39                	jle    c0105d9e <.L25+0xc>
c0105d65:	83 fb 39             	cmp    $0x39,%ebx
c0105d68:	7f 34                	jg     c0105d9e <.L25+0xc>
            for (precision = 0; ; ++ fmt) {
c0105d6a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105d6e:	eb d3                	jmp    c0105d43 <.L32+0x7>

c0105d70 <.L28>:
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105d70:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d73:	8d 50 04             	lea    0x4(%eax),%edx
c0105d76:	89 55 14             	mov    %edx,0x14(%ebp)
c0105d79:	8b 00                	mov    (%eax),%eax
c0105d7b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            goto process_precision;
c0105d7e:	eb 1f                	jmp    c0105d9f <.L25+0xd>

c0105d80 <.L30>:

        case '.':
            if (width < 0)
c0105d80:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0105d84:	79 81                	jns    c0105d07 <vprintfmt+0x5f>
                width = 0;
c0105d86:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
            goto reswitch;
c0105d8d:	e9 75 ff ff ff       	jmp    c0105d07 <vprintfmt+0x5f>

c0105d92 <.L25>:

        case '#':
            altflag = 1;
c0105d92:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
            goto reswitch;
c0105d99:	e9 69 ff ff ff       	jmp    c0105d07 <vprintfmt+0x5f>
            goto process_precision;
c0105d9e:	90                   	nop

        process_precision:
            if (width < 0)
c0105d9f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0105da3:	0f 89 5e ff ff ff    	jns    c0105d07 <vprintfmt+0x5f>
                width = precision, precision = -1;
c0105da9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105dac:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0105daf:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
            goto reswitch;
c0105db6:	e9 4c ff ff ff       	jmp    c0105d07 <vprintfmt+0x5f>

c0105dbb <.L36>:

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105dbb:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
            goto reswitch;
c0105dbf:	e9 43 ff ff ff       	jmp    c0105d07 <vprintfmt+0x5f>

c0105dc4 <.L33>:

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105dc4:	8b 45 14             	mov    0x14(%ebp),%eax
c0105dc7:	8d 50 04             	lea    0x4(%eax),%edx
c0105dca:	89 55 14             	mov    %edx,0x14(%ebp)
c0105dcd:	8b 00                	mov    (%eax),%eax
c0105dcf:	83 ec 08             	sub    $0x8,%esp
c0105dd2:	ff 75 0c             	pushl  0xc(%ebp)
c0105dd5:	50                   	push   %eax
c0105dd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd9:	ff d0                	call   *%eax
c0105ddb:	83 c4 10             	add    $0x10,%esp
            break;
c0105dde:	e9 78 02 00 00       	jmp    c010605b <.L24+0x28>

c0105de3 <.L35>:

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105de3:	8b 45 14             	mov    0x14(%ebp),%eax
c0105de6:	8d 50 04             	lea    0x4(%eax),%edx
c0105de9:	89 55 14             	mov    %edx,0x14(%ebp)
c0105dec:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105dee:	85 db                	test   %ebx,%ebx
c0105df0:	79 02                	jns    c0105df4 <.L35+0x11>
                err = -err;
c0105df2:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105df4:	83 fb 06             	cmp    $0x6,%ebx
c0105df7:	7f 0b                	jg     c0105e04 <.L35+0x21>
c0105df9:	8b b4 9f 5c 01 00 00 	mov    0x15c(%edi,%ebx,4),%esi
c0105e00:	85 f6                	test   %esi,%esi
c0105e02:	75 1b                	jne    c0105e1f <.L35+0x3c>
                printfmt(putch, putdat, "error %d", err);
c0105e04:	53                   	push   %ebx
c0105e05:	8d 87 97 f8 fe ff    	lea    -0x10769(%edi),%eax
c0105e0b:	50                   	push   %eax
c0105e0c:	ff 75 0c             	pushl  0xc(%ebp)
c0105e0f:	ff 75 08             	pushl  0x8(%ebp)
c0105e12:	e8 63 fe ff ff       	call   c0105c7a <printfmt>
c0105e17:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105e1a:	e9 3c 02 00 00       	jmp    c010605b <.L24+0x28>
                printfmt(putch, putdat, "%s", p);
c0105e1f:	56                   	push   %esi
c0105e20:	8d 87 a0 f8 fe ff    	lea    -0x10760(%edi),%eax
c0105e26:	50                   	push   %eax
c0105e27:	ff 75 0c             	pushl  0xc(%ebp)
c0105e2a:	ff 75 08             	pushl  0x8(%ebp)
c0105e2d:	e8 48 fe ff ff       	call   c0105c7a <printfmt>
c0105e32:	83 c4 10             	add    $0x10,%esp
            break;
c0105e35:	e9 21 02 00 00       	jmp    c010605b <.L24+0x28>

c0105e3a <.L39>:

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105e3a:	8b 45 14             	mov    0x14(%ebp),%eax
c0105e3d:	8d 50 04             	lea    0x4(%eax),%edx
c0105e40:	89 55 14             	mov    %edx,0x14(%ebp)
c0105e43:	8b 30                	mov    (%eax),%esi
c0105e45:	85 f6                	test   %esi,%esi
c0105e47:	75 06                	jne    c0105e4f <.L39+0x15>
                p = "(null)";
c0105e49:	8d b7 a3 f8 fe ff    	lea    -0x1075d(%edi),%esi
            }
            if (width > 0 && padc != '-') {
c0105e4f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0105e53:	7e 78                	jle    c0105ecd <.L39+0x93>
c0105e55:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
c0105e59:	74 72                	je     c0105ecd <.L39+0x93>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105e5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105e5e:	83 ec 08             	sub    $0x8,%esp
c0105e61:	50                   	push   %eax
c0105e62:	56                   	push   %esi
c0105e63:	89 fb                	mov    %edi,%ebx
c0105e65:	e8 57 f7 ff ff       	call   c01055c1 <strnlen>
c0105e6a:	83 c4 10             	add    $0x10,%esp
c0105e6d:	89 c2                	mov    %eax,%edx
c0105e6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105e72:	29 d0                	sub    %edx,%eax
c0105e74:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0105e77:	eb 17                	jmp    c0105e90 <.L39+0x56>
                    putch(padc, putdat);
c0105e79:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
c0105e7d:	83 ec 08             	sub    $0x8,%esp
c0105e80:	ff 75 0c             	pushl  0xc(%ebp)
c0105e83:	50                   	push   %eax
c0105e84:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e87:	ff d0                	call   *%eax
c0105e89:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105e8c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
c0105e90:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0105e94:	7f e3                	jg     c0105e79 <.L39+0x3f>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105e96:	eb 35                	jmp    c0105ecd <.L39+0x93>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105e98:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105e9c:	74 1c                	je     c0105eba <.L39+0x80>
c0105e9e:	83 fb 1f             	cmp    $0x1f,%ebx
c0105ea1:	7e 05                	jle    c0105ea8 <.L39+0x6e>
c0105ea3:	83 fb 7e             	cmp    $0x7e,%ebx
c0105ea6:	7e 12                	jle    c0105eba <.L39+0x80>
                    putch('?', putdat);
c0105ea8:	83 ec 08             	sub    $0x8,%esp
c0105eab:	ff 75 0c             	pushl  0xc(%ebp)
c0105eae:	6a 3f                	push   $0x3f
c0105eb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eb3:	ff d0                	call   *%eax
c0105eb5:	83 c4 10             	add    $0x10,%esp
c0105eb8:	eb 0f                	jmp    c0105ec9 <.L39+0x8f>
                }
                else {
                    putch(ch, putdat);
c0105eba:	83 ec 08             	sub    $0x8,%esp
c0105ebd:	ff 75 0c             	pushl  0xc(%ebp)
c0105ec0:	53                   	push   %ebx
c0105ec1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ec4:	ff d0                	call   *%eax
c0105ec6:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105ec9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
c0105ecd:	89 f0                	mov    %esi,%eax
c0105ecf:	8d 70 01             	lea    0x1(%eax),%esi
c0105ed2:	0f b6 00             	movzbl (%eax),%eax
c0105ed5:	0f be d8             	movsbl %al,%ebx
c0105ed8:	85 db                	test   %ebx,%ebx
c0105eda:	74 26                	je     c0105f02 <.L39+0xc8>
c0105edc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0105ee0:	78 b6                	js     c0105e98 <.L39+0x5e>
c0105ee2:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
c0105ee6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0105eea:	79 ac                	jns    c0105e98 <.L39+0x5e>
                }
            }
            for (; width > 0; width --) {
c0105eec:	eb 14                	jmp    c0105f02 <.L39+0xc8>
                putch(' ', putdat);
c0105eee:	83 ec 08             	sub    $0x8,%esp
c0105ef1:	ff 75 0c             	pushl  0xc(%ebp)
c0105ef4:	6a 20                	push   $0x20
c0105ef6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ef9:	ff d0                	call   *%eax
c0105efb:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
c0105efe:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
c0105f02:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0105f06:	7f e6                	jg     c0105eee <.L39+0xb4>
            }
            break;
c0105f08:	e9 4e 01 00 00       	jmp    c010605b <.L24+0x28>

c0105f0d <.L34>:

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105f0d:	83 ec 08             	sub    $0x8,%esp
c0105f10:	ff 75 d0             	pushl  -0x30(%ebp)
c0105f13:	8d 45 14             	lea    0x14(%ebp),%eax
c0105f16:	50                   	push   %eax
c0105f17:	e8 0d fd ff ff       	call   c0105c29 <getint>
c0105f1c:	83 c4 10             	add    $0x10,%esp
c0105f1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105f22:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            if ((long long)num < 0) {
c0105f25:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f2b:	85 d2                	test   %edx,%edx
c0105f2d:	79 23                	jns    c0105f52 <.L34+0x45>
                putch('-', putdat);
c0105f2f:	83 ec 08             	sub    $0x8,%esp
c0105f32:	ff 75 0c             	pushl  0xc(%ebp)
c0105f35:	6a 2d                	push   $0x2d
c0105f37:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f3a:	ff d0                	call   *%eax
c0105f3c:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0105f3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f45:	f7 d8                	neg    %eax
c0105f47:	83 d2 00             	adc    $0x0,%edx
c0105f4a:	f7 da                	neg    %edx
c0105f4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105f4f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            }
            base = 10;
c0105f52:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
c0105f59:	e9 9f 00 00 00       	jmp    c0105ffd <.L41+0x1f>

c0105f5e <.L40>:

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105f5e:	83 ec 08             	sub    $0x8,%esp
c0105f61:	ff 75 d0             	pushl  -0x30(%ebp)
c0105f64:	8d 45 14             	lea    0x14(%ebp),%eax
c0105f67:	50                   	push   %eax
c0105f68:	e8 63 fc ff ff       	call   c0105bd0 <getuint>
c0105f6d:	83 c4 10             	add    $0x10,%esp
c0105f70:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105f73:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 10;
c0105f76:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
c0105f7d:	eb 7e                	jmp    c0105ffd <.L41+0x1f>

c0105f7f <.L37>:

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105f7f:	83 ec 08             	sub    $0x8,%esp
c0105f82:	ff 75 d0             	pushl  -0x30(%ebp)
c0105f85:	8d 45 14             	lea    0x14(%ebp),%eax
c0105f88:	50                   	push   %eax
c0105f89:	e8 42 fc ff ff       	call   c0105bd0 <getuint>
c0105f8e:	83 c4 10             	add    $0x10,%esp
c0105f91:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105f94:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 8;
c0105f97:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
            goto number;
c0105f9e:	eb 5d                	jmp    c0105ffd <.L41+0x1f>

c0105fa0 <.L38>:

        // pointer
        case 'p':
            putch('0', putdat);
c0105fa0:	83 ec 08             	sub    $0x8,%esp
c0105fa3:	ff 75 0c             	pushl  0xc(%ebp)
c0105fa6:	6a 30                	push   $0x30
c0105fa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fab:	ff d0                	call   *%eax
c0105fad:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0105fb0:	83 ec 08             	sub    $0x8,%esp
c0105fb3:	ff 75 0c             	pushl  0xc(%ebp)
c0105fb6:	6a 78                	push   $0x78
c0105fb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fbb:	ff d0                	call   *%eax
c0105fbd:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105fc0:	8b 45 14             	mov    0x14(%ebp),%eax
c0105fc3:	8d 50 04             	lea    0x4(%eax),%edx
c0105fc6:	89 55 14             	mov    %edx,0x14(%ebp)
c0105fc9:	8b 00                	mov    (%eax),%eax
c0105fcb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105fce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            base = 16;
c0105fd5:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
            goto number;
c0105fdc:	eb 1f                	jmp    c0105ffd <.L41+0x1f>

c0105fde <.L41>:

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105fde:	83 ec 08             	sub    $0x8,%esp
c0105fe1:	ff 75 d0             	pushl  -0x30(%ebp)
c0105fe4:	8d 45 14             	lea    0x14(%ebp),%eax
c0105fe7:	50                   	push   %eax
c0105fe8:	e8 e3 fb ff ff       	call   c0105bd0 <getuint>
c0105fed:	83 c4 10             	add    $0x10,%esp
c0105ff0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105ff3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 16;
c0105ff6:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105ffd:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
c0106001:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106004:	83 ec 04             	sub    $0x4,%esp
c0106007:	52                   	push   %edx
c0106008:	ff 75 d8             	pushl  -0x28(%ebp)
c010600b:	50                   	push   %eax
c010600c:	ff 75 e4             	pushl  -0x1c(%ebp)
c010600f:	ff 75 e0             	pushl  -0x20(%ebp)
c0106012:	ff 75 0c             	pushl  0xc(%ebp)
c0106015:	ff 75 08             	pushl  0x8(%ebp)
c0106018:	e8 b0 fa ff ff       	call   c0105acd <printnum>
c010601d:	83 c4 20             	add    $0x20,%esp
            break;
c0106020:	eb 39                	jmp    c010605b <.L24+0x28>

c0106022 <.L27>:

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0106022:	83 ec 08             	sub    $0x8,%esp
c0106025:	ff 75 0c             	pushl  0xc(%ebp)
c0106028:	53                   	push   %ebx
c0106029:	8b 45 08             	mov    0x8(%ebp),%eax
c010602c:	ff d0                	call   *%eax
c010602e:	83 c4 10             	add    $0x10,%esp
            break;
c0106031:	eb 28                	jmp    c010605b <.L24+0x28>

c0106033 <.L24>:

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0106033:	83 ec 08             	sub    $0x8,%esp
c0106036:	ff 75 0c             	pushl  0xc(%ebp)
c0106039:	6a 25                	push   $0x25
c010603b:	8b 45 08             	mov    0x8(%ebp),%eax
c010603e:	ff d0                	call   *%eax
c0106040:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0106043:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106047:	eb 04                	jmp    c010604d <.L24+0x1a>
c0106049:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010604d:	8b 45 10             	mov    0x10(%ebp),%eax
c0106050:	83 e8 01             	sub    $0x1,%eax
c0106053:	0f b6 00             	movzbl (%eax),%eax
c0106056:	3c 25                	cmp    $0x25,%al
c0106058:	75 ef                	jne    c0106049 <.L24+0x16>
                /* do nothing */;
            break;
c010605a:	90                   	nop
    while (1) {
c010605b:	e9 5c fc ff ff       	jmp    c0105cbc <vprintfmt+0x14>
                return;
c0106060:	90                   	nop
        }
    }
}
c0106061:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0106064:	5b                   	pop    %ebx
c0106065:	5e                   	pop    %esi
c0106066:	5f                   	pop    %edi
c0106067:	5d                   	pop    %ebp
c0106068:	c3                   	ret    

c0106069 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0106069:	55                   	push   %ebp
c010606a:	89 e5                	mov    %esp,%ebp
c010606c:	e8 35 a2 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c0106071:	05 ff 18 01 00       	add    $0x118ff,%eax
    b->cnt ++;
c0106076:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106079:	8b 40 08             	mov    0x8(%eax),%eax
c010607c:	8d 50 01             	lea    0x1(%eax),%edx
c010607f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106082:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0106085:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106088:	8b 10                	mov    (%eax),%edx
c010608a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010608d:	8b 40 04             	mov    0x4(%eax),%eax
c0106090:	39 c2                	cmp    %eax,%edx
c0106092:	73 12                	jae    c01060a6 <sprintputch+0x3d>
        *b->buf ++ = ch;
c0106094:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106097:	8b 00                	mov    (%eax),%eax
c0106099:	8d 48 01             	lea    0x1(%eax),%ecx
c010609c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010609f:	89 0a                	mov    %ecx,(%edx)
c01060a1:	8b 55 08             	mov    0x8(%ebp),%edx
c01060a4:	88 10                	mov    %dl,(%eax)
    }
}
c01060a6:	90                   	nop
c01060a7:	5d                   	pop    %ebp
c01060a8:	c3                   	ret    

c01060a9 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01060a9:	55                   	push   %ebp
c01060aa:	89 e5                	mov    %esp,%ebp
c01060ac:	83 ec 18             	sub    $0x18,%esp
c01060af:	e8 f2 a1 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01060b4:	05 bc 18 01 00       	add    $0x118bc,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01060b9:	8d 45 14             	lea    0x14(%ebp),%eax
c01060bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01060bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060c2:	50                   	push   %eax
c01060c3:	ff 75 10             	pushl  0x10(%ebp)
c01060c6:	ff 75 0c             	pushl  0xc(%ebp)
c01060c9:	ff 75 08             	pushl  0x8(%ebp)
c01060cc:	e8 0b 00 00 00       	call   c01060dc <vsnprintf>
c01060d1:	83 c4 10             	add    $0x10,%esp
c01060d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01060d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01060da:	c9                   	leave  
c01060db:	c3                   	ret    

c01060dc <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01060dc:	55                   	push   %ebp
c01060dd:	89 e5                	mov    %esp,%ebp
c01060df:	83 ec 18             	sub    $0x18,%esp
c01060e2:	e8 bf a1 ff ff       	call   c01002a6 <__x86.get_pc_thunk.ax>
c01060e7:	05 89 18 01 00       	add    $0x11889,%eax
    struct sprintbuf b = {str, str + size - 1, 0};
c01060ec:	8b 55 08             	mov    0x8(%ebp),%edx
c01060ef:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01060f2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01060f5:	8d 4a ff             	lea    -0x1(%edx),%ecx
c01060f8:	8b 55 08             	mov    0x8(%ebp),%edx
c01060fb:	01 ca                	add    %ecx,%edx
c01060fd:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0106100:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0106107:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010610b:	74 0a                	je     c0106117 <vsnprintf+0x3b>
c010610d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0106110:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106113:	39 d1                	cmp    %edx,%ecx
c0106115:	76 07                	jbe    c010611e <vsnprintf+0x42>
        return -E_INVAL;
c0106117:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010611c:	eb 22                	jmp    c0106140 <vsnprintf+0x64>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010611e:	ff 75 14             	pushl  0x14(%ebp)
c0106121:	ff 75 10             	pushl  0x10(%ebp)
c0106124:	8d 55 ec             	lea    -0x14(%ebp),%edx
c0106127:	52                   	push   %edx
c0106128:	8d 80 f9 e6 fe ff    	lea    -0x11907(%eax),%eax
c010612e:	50                   	push   %eax
c010612f:	e8 74 fb ff ff       	call   c0105ca8 <vprintfmt>
c0106134:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0106137:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010613a:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010613d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106140:	c9                   	leave  
c0106141:	c3                   	ret    

c0106142 <__x86.get_pc_thunk.di>:
c0106142:	8b 3c 24             	mov    (%esp),%edi
c0106145:	c3                   	ret    
