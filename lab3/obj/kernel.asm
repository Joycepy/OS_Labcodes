
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 20 12 00       	mov    $0x122000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 20 12 c0       	mov    %eax,0xc0122000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 10 12 c0       	mov    $0xc0121000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));

static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba fc 50 12 c0       	mov    $0xc01250fc,%edx
c0100041:	b8 00 40 12 c0       	mov    $0xc0124000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 40 12 c0 	movl   $0xc0124000,(%esp)
c010005d:	e8 d3 89 00 00       	call   c0108a35 <memset>

    cons_init();                // init the console
c0100062:	e8 06 1e 00 00       	call   c0101e6d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 20 93 10 c0 	movl   $0xc0109320,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 3c 93 10 c0 	movl   $0xc010933c,(%esp)
c010007c:	e8 20 02 00 00       	call   c01002a1 <cprintf>

    print_kerninfo();
c0100081:	e8 d2 08 00 00       	call   c0100958 <print_kerninfo>

    grade_backtrace();
c0100086:	e8 95 00 00 00       	call   c0100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 e2 71 00 00       	call   c0107272 <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 35 1f 00 00       	call   c0101fca <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 93 20 00 00       	call   c010212d <idt_init>

    vmm_init();                 // init virtual memory management
c010009a:	e8 2f 3c 00 00       	call   c0103cce <vmm_init>

    ide_init();                 // init ide devices
c010009f:	e8 64 0d 00 00       	call   c0100e08 <ide_init>
    swap_init();                // init swap
c01000a4:	e8 0a 46 00 00       	call   c01046b3 <swap_init>

    clock_init();               // init clock interrupt
c01000a9:	e8 75 15 00 00       	call   c0101623 <clock_init>
    intr_enable();              // enable irq interrupt
c01000ae:	e8 52 20 00 00       	call   c0102105 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000b3:	eb fe                	jmp    c01000b3 <kern_init+0x7d>

c01000b5 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b5:	55                   	push   %ebp
c01000b6:	89 e5                	mov    %esp,%ebp
c01000b8:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000c2:	00 
c01000c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000ca:	00 
c01000cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000d2:	e8 c5 0c 00 00       	call   c0100d9c <mon_backtrace>
}
c01000d7:	c9                   	leave  
c01000d8:	c3                   	ret    

c01000d9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d9:	55                   	push   %ebp
c01000da:	89 e5                	mov    %esp,%ebp
c01000dc:	53                   	push   %ebx
c01000dd:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000e0:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000e6:	8d 55 08             	lea    0x8(%ebp),%edx
c01000e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ec:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000f0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000f4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000f8:	89 04 24             	mov    %eax,(%esp)
c01000fb:	e8 b5 ff ff ff       	call   c01000b5 <grade_backtrace2>
}
c0100100:	83 c4 14             	add    $0x14,%esp
c0100103:	5b                   	pop    %ebx
c0100104:	5d                   	pop    %ebp
c0100105:	c3                   	ret    

c0100106 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100106:	55                   	push   %ebp
c0100107:	89 e5                	mov    %esp,%ebp
c0100109:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010c:	8b 45 10             	mov    0x10(%ebp),%eax
c010010f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100113:	8b 45 08             	mov    0x8(%ebp),%eax
c0100116:	89 04 24             	mov    %eax,(%esp)
c0100119:	e8 bb ff ff ff       	call   c01000d9 <grade_backtrace1>
}
c010011e:	c9                   	leave  
c010011f:	c3                   	ret    

c0100120 <grade_backtrace>:

void
grade_backtrace(void) {
c0100120:	55                   	push   %ebp
c0100121:	89 e5                	mov    %esp,%ebp
c0100123:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100126:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010012b:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100132:	ff 
c0100133:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100137:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010013e:	e8 c3 ff ff ff       	call   c0100106 <grade_backtrace0>
}
c0100143:	c9                   	leave  
c0100144:	c3                   	ret    

c0100145 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100145:	55                   	push   %ebp
c0100146:	89 e5                	mov    %esp,%ebp
c0100148:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010014b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010014e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100151:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100154:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100157:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010015b:	0f b7 c0             	movzwl %ax,%eax
c010015e:	83 e0 03             	and    $0x3,%eax
c0100161:	89 c2                	mov    %eax,%edx
c0100163:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c0100168:	89 54 24 08          	mov    %edx,0x8(%esp)
c010016c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100170:	c7 04 24 41 93 10 c0 	movl   $0xc0109341,(%esp)
c0100177:	e8 25 01 00 00       	call   c01002a1 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010017c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100180:	0f b7 d0             	movzwl %ax,%edx
c0100183:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c0100188:	89 54 24 08          	mov    %edx,0x8(%esp)
c010018c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100190:	c7 04 24 4f 93 10 c0 	movl   $0xc010934f,(%esp)
c0100197:	e8 05 01 00 00       	call   c01002a1 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010019c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a0:	0f b7 d0             	movzwl %ax,%edx
c01001a3:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b0:	c7 04 24 5d 93 10 c0 	movl   $0xc010935d,(%esp)
c01001b7:	e8 e5 00 00 00       	call   c01002a1 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001bc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c0:	0f b7 d0             	movzwl %ax,%edx
c01001c3:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001c8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d0:	c7 04 24 6b 93 10 c0 	movl   $0xc010936b,(%esp)
c01001d7:	e8 c5 00 00 00       	call   c01002a1 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001dc:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e0:	0f b7 d0             	movzwl %ax,%edx
c01001e3:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001e8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f0:	c7 04 24 79 93 10 c0 	movl   $0xc0109379,(%esp)
c01001f7:	e8 a5 00 00 00       	call   c01002a1 <cprintf>
    round ++;
c01001fc:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c0100201:	83 c0 01             	add    $0x1,%eax
c0100204:	a3 00 40 12 c0       	mov    %eax,0xc0124000
}
c0100209:	c9                   	leave  
c010020a:	c3                   	ret    

c010020b <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020b:	55                   	push   %ebp
c010020c:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c010020e:	5d                   	pop    %ebp
c010020f:	c3                   	ret    

c0100210 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100210:	55                   	push   %ebp
c0100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100213:	5d                   	pop    %ebp
c0100214:	c3                   	ret    

c0100215 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100215:	55                   	push   %ebp
c0100216:	89 e5                	mov    %esp,%ebp
c0100218:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010021b:	e8 25 ff ff ff       	call   c0100145 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100220:	c7 04 24 88 93 10 c0 	movl   $0xc0109388,(%esp)
c0100227:	e8 75 00 00 00       	call   c01002a1 <cprintf>
    lab1_switch_to_user();
c010022c:	e8 da ff ff ff       	call   c010020b <lab1_switch_to_user>
    lab1_print_cur_status();
c0100231:	e8 0f ff ff ff       	call   c0100145 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100236:	c7 04 24 a8 93 10 c0 	movl   $0xc01093a8,(%esp)
c010023d:	e8 5f 00 00 00       	call   c01002a1 <cprintf>
    lab1_switch_to_kernel();
c0100242:	e8 c9 ff ff ff       	call   c0100210 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100247:	e8 f9 fe ff ff       	call   c0100145 <lab1_print_cur_status>
}
c010024c:	c9                   	leave  
c010024d:	c3                   	ret    

c010024e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010024e:	55                   	push   %ebp
c010024f:	89 e5                	mov    %esp,%ebp
c0100251:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100254:	8b 45 08             	mov    0x8(%ebp),%eax
c0100257:	89 04 24             	mov    %eax,(%esp)
c010025a:	e8 3a 1c 00 00       	call   c0101e99 <cons_putc>
    (*cnt) ++;
c010025f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100262:	8b 00                	mov    (%eax),%eax
c0100264:	8d 50 01             	lea    0x1(%eax),%edx
c0100267:	8b 45 0c             	mov    0xc(%ebp),%eax
c010026a:	89 10                	mov    %edx,(%eax)
}
c010026c:	c9                   	leave  
c010026d:	c3                   	ret    

c010026e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010026e:	55                   	push   %ebp
c010026f:	89 e5                	mov    %esp,%ebp
c0100271:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100274:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010027b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010027e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100282:	8b 45 08             	mov    0x8(%ebp),%eax
c0100285:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100289:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010028c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100290:	c7 04 24 4e 02 10 c0 	movl   $0xc010024e,(%esp)
c0100297:	e8 eb 8a 00 00       	call   c0108d87 <vprintfmt>
    return cnt;
c010029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010029f:	c9                   	leave  
c01002a0:	c3                   	ret    

c01002a1 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002a1:	55                   	push   %ebp
c01002a2:	89 e5                	mov    %esp,%ebp
c01002a4:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002a7:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01002b7:	89 04 24             	mov    %eax,(%esp)
c01002ba:	e8 af ff ff ff       	call   c010026e <vcprintf>
c01002bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002c5:	c9                   	leave  
c01002c6:	c3                   	ret    

c01002c7 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002c7:	55                   	push   %ebp
c01002c8:	89 e5                	mov    %esp,%ebp
c01002ca:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01002d0:	89 04 24             	mov    %eax,(%esp)
c01002d3:	e8 c1 1b 00 00       	call   c0101e99 <cons_putc>
}
c01002d8:	c9                   	leave  
c01002d9:	c3                   	ret    

c01002da <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002da:	55                   	push   %ebp
c01002db:	89 e5                	mov    %esp,%ebp
c01002dd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002e7:	eb 13                	jmp    c01002fc <cputs+0x22>
        cputch(c, &cnt);
c01002e9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002ed:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002f0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002f4:	89 04 24             	mov    %eax,(%esp)
c01002f7:	e8 52 ff ff ff       	call   c010024e <cputch>
    while ((c = *str ++) != '\0') {
c01002fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	89 55 08             	mov    %edx,0x8(%ebp)
c0100305:	0f b6 00             	movzbl (%eax),%eax
c0100308:	88 45 f7             	mov    %al,-0x9(%ebp)
c010030b:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c010030f:	75 d8                	jne    c01002e9 <cputs+0xf>
    }
    cputch('\n', &cnt);
c0100311:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100314:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100318:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c010031f:	e8 2a ff ff ff       	call   c010024e <cputch>
    return cnt;
c0100324:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100327:	c9                   	leave  
c0100328:	c3                   	ret    

c0100329 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100329:	55                   	push   %ebp
c010032a:	89 e5                	mov    %esp,%ebp
c010032c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c010032f:	e8 a1 1b 00 00       	call   c0101ed5 <cons_getc>
c0100334:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100337:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010033b:	74 f2                	je     c010032f <getchar+0x6>
        /* do nothing */;
    return c;
c010033d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100340:	c9                   	leave  
c0100341:	c3                   	ret    

c0100342 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100342:	55                   	push   %ebp
c0100343:	89 e5                	mov    %esp,%ebp
c0100345:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100348:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010034c:	74 13                	je     c0100361 <readline+0x1f>
        cprintf("%s", prompt);
c010034e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100351:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100355:	c7 04 24 c7 93 10 c0 	movl   $0xc01093c7,(%esp)
c010035c:	e8 40 ff ff ff       	call   c01002a1 <cprintf>
    }
    int i = 0, c;
c0100361:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100368:	e8 bc ff ff ff       	call   c0100329 <getchar>
c010036d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100370:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100374:	79 07                	jns    c010037d <readline+0x3b>
            return NULL;
c0100376:	b8 00 00 00 00       	mov    $0x0,%eax
c010037b:	eb 79                	jmp    c01003f6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010037d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100381:	7e 28                	jle    c01003ab <readline+0x69>
c0100383:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010038a:	7f 1f                	jg     c01003ab <readline+0x69>
            cputchar(c);
c010038c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 30 ff ff ff       	call   c01002c7 <cputchar>
            buf[i ++] = c;
c0100397:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003a3:	88 90 20 40 12 c0    	mov    %dl,-0x3fedbfe0(%eax)
c01003a9:	eb 46                	jmp    c01003f1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01003ab:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003af:	75 17                	jne    c01003c8 <readline+0x86>
c01003b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003b5:	7e 11                	jle    c01003c8 <readline+0x86>
            cputchar(c);
c01003b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003ba:	89 04 24             	mov    %eax,(%esp)
c01003bd:	e8 05 ff ff ff       	call   c01002c7 <cputchar>
            i --;
c01003c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01003c6:	eb 29                	jmp    c01003f1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01003c8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003cc:	74 06                	je     c01003d4 <readline+0x92>
c01003ce:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003d2:	75 1d                	jne    c01003f1 <readline+0xaf>
            cputchar(c);
c01003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003d7:	89 04 24             	mov    %eax,(%esp)
c01003da:	e8 e8 fe ff ff       	call   c01002c7 <cputchar>
            buf[i] = '\0';
c01003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003e2:	05 20 40 12 c0       	add    $0xc0124020,%eax
c01003e7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003ea:	b8 20 40 12 c0       	mov    $0xc0124020,%eax
c01003ef:	eb 05                	jmp    c01003f6 <readline+0xb4>
        }
    }
c01003f1:	e9 72 ff ff ff       	jmp    c0100368 <readline+0x26>
}
c01003f6:	c9                   	leave  
c01003f7:	c3                   	ret    

c01003f8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003f8:	55                   	push   %ebp
c01003f9:	89 e5                	mov    %esp,%ebp
c01003fb:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c01003fe:	a1 20 44 12 c0       	mov    0xc0124420,%eax
c0100403:	85 c0                	test   %eax,%eax
c0100405:	74 02                	je     c0100409 <__panic+0x11>
        goto panic_dead;
c0100407:	eb 59                	jmp    c0100462 <__panic+0x6a>
    }
    is_panic = 1;
c0100409:	c7 05 20 44 12 c0 01 	movl   $0x1,0xc0124420
c0100410:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100413:	8d 45 14             	lea    0x14(%ebp),%eax
c0100416:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100419:	8b 45 0c             	mov    0xc(%ebp),%eax
c010041c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100420:	8b 45 08             	mov    0x8(%ebp),%eax
c0100423:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100427:	c7 04 24 ca 93 10 c0 	movl   $0xc01093ca,(%esp)
c010042e:	e8 6e fe ff ff       	call   c01002a1 <cprintf>
    vcprintf(fmt, ap);
c0100433:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100436:	89 44 24 04          	mov    %eax,0x4(%esp)
c010043a:	8b 45 10             	mov    0x10(%ebp),%eax
c010043d:	89 04 24             	mov    %eax,(%esp)
c0100440:	e8 29 fe ff ff       	call   c010026e <vcprintf>
    cprintf("\n");
c0100445:	c7 04 24 e6 93 10 c0 	movl   $0xc01093e6,(%esp)
c010044c:	e8 50 fe ff ff       	call   c01002a1 <cprintf>
    
    cprintf("stack trackback:\n");
c0100451:	c7 04 24 e8 93 10 c0 	movl   $0xc01093e8,(%esp)
c0100458:	e8 44 fe ff ff       	call   c01002a1 <cprintf>
    print_stackframe();
c010045d:	e8 40 06 00 00       	call   c0100aa2 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100462:	e8 a4 1c 00 00       	call   c010210b <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100467:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010046e:	e8 5a 08 00 00       	call   c0100ccd <kmonitor>
    }
c0100473:	eb f2                	jmp    c0100467 <__panic+0x6f>

c0100475 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100475:	55                   	push   %ebp
c0100476:	89 e5                	mov    %esp,%ebp
c0100478:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c010047b:	8d 45 14             	lea    0x14(%ebp),%eax
c010047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100481:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100484:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100488:	8b 45 08             	mov    0x8(%ebp),%eax
c010048b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010048f:	c7 04 24 fa 93 10 c0 	movl   $0xc01093fa,(%esp)
c0100496:	e8 06 fe ff ff       	call   c01002a1 <cprintf>
    vcprintf(fmt, ap);
c010049b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010049e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004a5:	89 04 24             	mov    %eax,(%esp)
c01004a8:	e8 c1 fd ff ff       	call   c010026e <vcprintf>
    cprintf("\n");
c01004ad:	c7 04 24 e6 93 10 c0 	movl   $0xc01093e6,(%esp)
c01004b4:	e8 e8 fd ff ff       	call   c01002a1 <cprintf>
    va_end(ap);
}
c01004b9:	c9                   	leave  
c01004ba:	c3                   	ret    

c01004bb <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004bb:	55                   	push   %ebp
c01004bc:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004be:	a1 20 44 12 c0       	mov    0xc0124420,%eax
}
c01004c3:	5d                   	pop    %ebp
c01004c4:	c3                   	ret    

c01004c5 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004c5:	55                   	push   %ebp
c01004c6:	89 e5                	mov    %esp,%ebp
c01004c8:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ce:	8b 00                	mov    (%eax),%eax
c01004d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01004d6:	8b 00                	mov    (%eax),%eax
c01004d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004e2:	e9 d2 00 00 00       	jmp    c01005b9 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004ed:	01 d0                	add    %edx,%eax
c01004ef:	89 c2                	mov    %eax,%edx
c01004f1:	c1 ea 1f             	shr    $0x1f,%edx
c01004f4:	01 d0                	add    %edx,%eax
c01004f6:	d1 f8                	sar    %eax
c01004f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004fe:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100501:	eb 04                	jmp    c0100507 <stab_binsearch+0x42>
            m --;
c0100503:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100507:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010050a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010050d:	7c 1f                	jl     c010052e <stab_binsearch+0x69>
c010050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100512:	89 d0                	mov    %edx,%eax
c0100514:	01 c0                	add    %eax,%eax
c0100516:	01 d0                	add    %edx,%eax
c0100518:	c1 e0 02             	shl    $0x2,%eax
c010051b:	89 c2                	mov    %eax,%edx
c010051d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100526:	0f b6 c0             	movzbl %al,%eax
c0100529:	3b 45 14             	cmp    0x14(%ebp),%eax
c010052c:	75 d5                	jne    c0100503 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c010052e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100531:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100534:	7d 0b                	jge    c0100541 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100536:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100539:	83 c0 01             	add    $0x1,%eax
c010053c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010053f:	eb 78                	jmp    c01005b9 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100541:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100548:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010054b:	89 d0                	mov    %edx,%eax
c010054d:	01 c0                	add    %eax,%eax
c010054f:	01 d0                	add    %edx,%eax
c0100551:	c1 e0 02             	shl    $0x2,%eax
c0100554:	89 c2                	mov    %eax,%edx
c0100556:	8b 45 08             	mov    0x8(%ebp),%eax
c0100559:	01 d0                	add    %edx,%eax
c010055b:	8b 40 08             	mov    0x8(%eax),%eax
c010055e:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100561:	73 13                	jae    c0100576 <stab_binsearch+0xb1>
            *region_left = m;
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100569:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010056b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010056e:	83 c0 01             	add    $0x1,%eax
c0100571:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100574:	eb 43                	jmp    c01005b9 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100576:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100579:	89 d0                	mov    %edx,%eax
c010057b:	01 c0                	add    %eax,%eax
c010057d:	01 d0                	add    %edx,%eax
c010057f:	c1 e0 02             	shl    $0x2,%eax
c0100582:	89 c2                	mov    %eax,%edx
c0100584:	8b 45 08             	mov    0x8(%ebp),%eax
c0100587:	01 d0                	add    %edx,%eax
c0100589:	8b 40 08             	mov    0x8(%eax),%eax
c010058c:	3b 45 18             	cmp    0x18(%ebp),%eax
c010058f:	76 16                	jbe    c01005a7 <stab_binsearch+0xe2>
            *region_right = m - 1;
c0100591:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100594:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100597:	8b 45 10             	mov    0x10(%ebp),%eax
c010059a:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c010059c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010059f:	83 e8 01             	sub    $0x1,%eax
c01005a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005a5:	eb 12                	jmp    c01005b9 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005ad:	89 10                	mov    %edx,(%eax)
            l = m;
c01005af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005b5:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c01005b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005bf:	0f 8e 22 ff ff ff    	jle    c01004e7 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01005c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005c9:	75 0f                	jne    c01005da <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01005cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ce:	8b 00                	mov    (%eax),%eax
c01005d0:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d6:	89 10                	mov    %edx,(%eax)
c01005d8:	eb 3f                	jmp    c0100619 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005da:	8b 45 10             	mov    0x10(%ebp),%eax
c01005dd:	8b 00                	mov    (%eax),%eax
c01005df:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005e2:	eb 04                	jmp    c01005e8 <stab_binsearch+0x123>
c01005e4:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005eb:	8b 00                	mov    (%eax),%eax
c01005ed:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005f0:	7d 1f                	jge    c0100611 <stab_binsearch+0x14c>
c01005f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005f5:	89 d0                	mov    %edx,%eax
c01005f7:	01 c0                	add    %eax,%eax
c01005f9:	01 d0                	add    %edx,%eax
c01005fb:	c1 e0 02             	shl    $0x2,%eax
c01005fe:	89 c2                	mov    %eax,%edx
c0100600:	8b 45 08             	mov    0x8(%ebp),%eax
c0100603:	01 d0                	add    %edx,%eax
c0100605:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100609:	0f b6 c0             	movzbl %al,%eax
c010060c:	3b 45 14             	cmp    0x14(%ebp),%eax
c010060f:	75 d3                	jne    c01005e4 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100611:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100614:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100617:	89 10                	mov    %edx,(%eax)
    }
}
c0100619:	c9                   	leave  
c010061a:	c3                   	ret    

c010061b <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010061b:	55                   	push   %ebp
c010061c:	89 e5                	mov    %esp,%ebp
c010061e:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100621:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100624:	c7 00 18 94 10 c0    	movl   $0xc0109418,(%eax)
    info->eip_line = 0;
c010062a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100634:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100637:	c7 40 08 18 94 10 c0 	movl   $0xc0109418,0x8(%eax)
    info->eip_fn_namelen = 9;
c010063e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100641:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100648:	8b 45 0c             	mov    0xc(%ebp),%eax
c010064b:	8b 55 08             	mov    0x8(%ebp),%edx
c010064e:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100651:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100654:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010065b:	c7 45 f4 90 b5 10 c0 	movl   $0xc010b590,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100662:	c7 45 f0 24 ae 11 c0 	movl   $0xc011ae24,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100669:	c7 45 ec 25 ae 11 c0 	movl   $0xc011ae25,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100670:	c7 45 e8 5a e8 11 c0 	movl   $0xc011e85a,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100677:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010067a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010067d:	76 0d                	jbe    c010068c <debuginfo_eip+0x71>
c010067f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100682:	83 e8 01             	sub    $0x1,%eax
c0100685:	0f b6 00             	movzbl (%eax),%eax
c0100688:	84 c0                	test   %al,%al
c010068a:	74 0a                	je     c0100696 <debuginfo_eip+0x7b>
        return -1;
c010068c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100691:	e9 c0 02 00 00       	jmp    c0100956 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100696:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c010069d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006a3:	29 c2                	sub    %eax,%edx
c01006a5:	89 d0                	mov    %edx,%eax
c01006a7:	c1 f8 02             	sar    $0x2,%eax
c01006aa:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006b0:	83 e8 01             	sub    $0x1,%eax
c01006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01006b9:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006bd:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006c4:	00 
c01006c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006c8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006cc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006d6:	89 04 24             	mov    %eax,(%esp)
c01006d9:	e8 e7 fd ff ff       	call   c01004c5 <stab_binsearch>
    if (lfile == 0)
c01006de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e1:	85 c0                	test   %eax,%eax
c01006e3:	75 0a                	jne    c01006ef <debuginfo_eip+0xd4>
        return -1;
c01006e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006ea:	e9 67 02 00 00       	jmp    c0100956 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01006fe:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100702:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100709:	00 
c010070a:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010070d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100711:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100714:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100718:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071b:	89 04 24             	mov    %eax,(%esp)
c010071e:	e8 a2 fd ff ff       	call   c01004c5 <stab_binsearch>

    if (lfun <= rfun) {
c0100723:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100726:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100729:	39 c2                	cmp    %eax,%edx
c010072b:	7f 7c                	jg     c01007a9 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010072d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100730:	89 c2                	mov    %eax,%edx
c0100732:	89 d0                	mov    %edx,%eax
c0100734:	01 c0                	add    %eax,%eax
c0100736:	01 d0                	add    %edx,%eax
c0100738:	c1 e0 02             	shl    $0x2,%eax
c010073b:	89 c2                	mov    %eax,%edx
c010073d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100740:	01 d0                	add    %edx,%eax
c0100742:	8b 10                	mov    (%eax),%edx
c0100744:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100747:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010074a:	29 c1                	sub    %eax,%ecx
c010074c:	89 c8                	mov    %ecx,%eax
c010074e:	39 c2                	cmp    %eax,%edx
c0100750:	73 22                	jae    c0100774 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100752:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100755:	89 c2                	mov    %eax,%edx
c0100757:	89 d0                	mov    %edx,%eax
c0100759:	01 c0                	add    %eax,%eax
c010075b:	01 d0                	add    %edx,%eax
c010075d:	c1 e0 02             	shl    $0x2,%eax
c0100760:	89 c2                	mov    %eax,%edx
c0100762:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100765:	01 d0                	add    %edx,%eax
c0100767:	8b 10                	mov    (%eax),%edx
c0100769:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010076c:	01 c2                	add    %eax,%edx
c010076e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100771:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100774:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100777:	89 c2                	mov    %eax,%edx
c0100779:	89 d0                	mov    %edx,%eax
c010077b:	01 c0                	add    %eax,%eax
c010077d:	01 d0                	add    %edx,%eax
c010077f:	c1 e0 02             	shl    $0x2,%eax
c0100782:	89 c2                	mov    %eax,%edx
c0100784:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	8b 50 08             	mov    0x8(%eax),%edx
c010078c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078f:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100792:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100795:	8b 40 10             	mov    0x10(%eax),%eax
c0100798:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c010079b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010079e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01007a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007a7:	eb 15                	jmp    c01007be <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ac:	8b 55 08             	mov    0x8(%ebp),%edx
c01007af:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c1:	8b 40 08             	mov    0x8(%eax),%eax
c01007c4:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007cb:	00 
c01007cc:	89 04 24             	mov    %eax,(%esp)
c01007cf:	e8 d5 80 00 00       	call   c01088a9 <strfind>
c01007d4:	89 c2                	mov    %eax,%edx
c01007d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d9:	8b 40 08             	mov    0x8(%eax),%eax
c01007dc:	29 c2                	sub    %eax,%edx
c01007de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e1:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01007e7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007eb:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007f2:	00 
c01007f3:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007fa:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100801:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100804:	89 04 24             	mov    %eax,(%esp)
c0100807:	e8 b9 fc ff ff       	call   c01004c5 <stab_binsearch>
    if (lline <= rline) {
c010080c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010080f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100812:	39 c2                	cmp    %eax,%edx
c0100814:	7f 24                	jg     c010083a <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100816:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100819:	89 c2                	mov    %eax,%edx
c010081b:	89 d0                	mov    %edx,%eax
c010081d:	01 c0                	add    %eax,%eax
c010081f:	01 d0                	add    %edx,%eax
c0100821:	c1 e0 02             	shl    $0x2,%eax
c0100824:	89 c2                	mov    %eax,%edx
c0100826:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100829:	01 d0                	add    %edx,%eax
c010082b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010082f:	0f b7 d0             	movzwl %ax,%edx
c0100832:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100835:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100838:	eb 13                	jmp    c010084d <debuginfo_eip+0x232>
        return -1;
c010083a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010083f:	e9 12 01 00 00       	jmp    c0100956 <debuginfo_eip+0x33b>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100844:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100847:	83 e8 01             	sub    $0x1,%eax
c010084a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c010084d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100853:	39 c2                	cmp    %eax,%edx
c0100855:	7c 56                	jl     c01008ad <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c0100857:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	89 d0                	mov    %edx,%eax
c010085e:	01 c0                	add    %eax,%eax
c0100860:	01 d0                	add    %edx,%eax
c0100862:	c1 e0 02             	shl    $0x2,%eax
c0100865:	89 c2                	mov    %eax,%edx
c0100867:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086a:	01 d0                	add    %edx,%eax
c010086c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100870:	3c 84                	cmp    $0x84,%al
c0100872:	74 39                	je     c01008ad <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100874:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100877:	89 c2                	mov    %eax,%edx
c0100879:	89 d0                	mov    %edx,%eax
c010087b:	01 c0                	add    %eax,%eax
c010087d:	01 d0                	add    %edx,%eax
c010087f:	c1 e0 02             	shl    $0x2,%eax
c0100882:	89 c2                	mov    %eax,%edx
c0100884:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100887:	01 d0                	add    %edx,%eax
c0100889:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010088d:	3c 64                	cmp    $0x64,%al
c010088f:	75 b3                	jne    c0100844 <debuginfo_eip+0x229>
c0100891:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100894:	89 c2                	mov    %eax,%edx
c0100896:	89 d0                	mov    %edx,%eax
c0100898:	01 c0                	add    %eax,%eax
c010089a:	01 d0                	add    %edx,%eax
c010089c:	c1 e0 02             	shl    $0x2,%eax
c010089f:	89 c2                	mov    %eax,%edx
c01008a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a4:	01 d0                	add    %edx,%eax
c01008a6:	8b 40 08             	mov    0x8(%eax),%eax
c01008a9:	85 c0                	test   %eax,%eax
c01008ab:	74 97                	je     c0100844 <debuginfo_eip+0x229>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008b3:	39 c2                	cmp    %eax,%edx
c01008b5:	7c 46                	jl     c01008fd <debuginfo_eip+0x2e2>
c01008b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008ba:	89 c2                	mov    %eax,%edx
c01008bc:	89 d0                	mov    %edx,%eax
c01008be:	01 c0                	add    %eax,%eax
c01008c0:	01 d0                	add    %edx,%eax
c01008c2:	c1 e0 02             	shl    $0x2,%eax
c01008c5:	89 c2                	mov    %eax,%edx
c01008c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ca:	01 d0                	add    %edx,%eax
c01008cc:	8b 10                	mov    (%eax),%edx
c01008ce:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008d4:	29 c1                	sub    %eax,%ecx
c01008d6:	89 c8                	mov    %ecx,%eax
c01008d8:	39 c2                	cmp    %eax,%edx
c01008da:	73 21                	jae    c01008fd <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008df:	89 c2                	mov    %eax,%edx
c01008e1:	89 d0                	mov    %edx,%eax
c01008e3:	01 c0                	add    %eax,%eax
c01008e5:	01 d0                	add    %edx,%eax
c01008e7:	c1 e0 02             	shl    $0x2,%eax
c01008ea:	89 c2                	mov    %eax,%edx
c01008ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ef:	01 d0                	add    %edx,%eax
c01008f1:	8b 10                	mov    (%eax),%edx
c01008f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008f6:	01 c2                	add    %eax,%edx
c01008f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008fb:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100900:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100903:	39 c2                	cmp    %eax,%edx
c0100905:	7d 4a                	jge    c0100951 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c0100907:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010090a:	83 c0 01             	add    $0x1,%eax
c010090d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100910:	eb 18                	jmp    c010092a <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100912:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100915:	8b 40 14             	mov    0x14(%eax),%eax
c0100918:	8d 50 01             	lea    0x1(%eax),%edx
c010091b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010091e:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100921:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100924:	83 c0 01             	add    $0x1,%eax
c0100927:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010092a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010092d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100930:	39 c2                	cmp    %eax,%edx
c0100932:	7d 1d                	jge    c0100951 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100934:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100937:	89 c2                	mov    %eax,%edx
c0100939:	89 d0                	mov    %edx,%eax
c010093b:	01 c0                	add    %eax,%eax
c010093d:	01 d0                	add    %edx,%eax
c010093f:	c1 e0 02             	shl    $0x2,%eax
c0100942:	89 c2                	mov    %eax,%edx
c0100944:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100947:	01 d0                	add    %edx,%eax
c0100949:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010094d:	3c a0                	cmp    $0xa0,%al
c010094f:	74 c1                	je     c0100912 <debuginfo_eip+0x2f7>
        }
    }
    return 0;
c0100951:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100956:	c9                   	leave  
c0100957:	c3                   	ret    

c0100958 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100958:	55                   	push   %ebp
c0100959:	89 e5                	mov    %esp,%ebp
c010095b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010095e:	c7 04 24 22 94 10 c0 	movl   $0xc0109422,(%esp)
c0100965:	e8 37 f9 ff ff       	call   c01002a1 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010096a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100971:	c0 
c0100972:	c7 04 24 3b 94 10 c0 	movl   $0xc010943b,(%esp)
c0100979:	e8 23 f9 ff ff       	call   c01002a1 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010097e:	c7 44 24 04 17 93 10 	movl   $0xc0109317,0x4(%esp)
c0100985:	c0 
c0100986:	c7 04 24 53 94 10 c0 	movl   $0xc0109453,(%esp)
c010098d:	e8 0f f9 ff ff       	call   c01002a1 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100992:	c7 44 24 04 00 40 12 	movl   $0xc0124000,0x4(%esp)
c0100999:	c0 
c010099a:	c7 04 24 6b 94 10 c0 	movl   $0xc010946b,(%esp)
c01009a1:	e8 fb f8 ff ff       	call   c01002a1 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009a6:	c7 44 24 04 fc 50 12 	movl   $0xc01250fc,0x4(%esp)
c01009ad:	c0 
c01009ae:	c7 04 24 83 94 10 c0 	movl   $0xc0109483,(%esp)
c01009b5:	e8 e7 f8 ff ff       	call   c01002a1 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009ba:	b8 fc 50 12 c0       	mov    $0xc01250fc,%eax
c01009bf:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009c5:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01009ca:	29 c2                	sub    %eax,%edx
c01009cc:	89 d0                	mov    %edx,%eax
c01009ce:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009d4:	85 c0                	test   %eax,%eax
c01009d6:	0f 48 c2             	cmovs  %edx,%eax
c01009d9:	c1 f8 0a             	sar    $0xa,%eax
c01009dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009e0:	c7 04 24 9c 94 10 c0 	movl   $0xc010949c,(%esp)
c01009e7:	e8 b5 f8 ff ff       	call   c01002a1 <cprintf>
}
c01009ec:	c9                   	leave  
c01009ed:	c3                   	ret    

c01009ee <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009ee:	55                   	push   %ebp
c01009ef:	89 e5                	mov    %esp,%ebp
c01009f1:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009f7:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a01:	89 04 24             	mov    %eax,(%esp)
c0100a04:	e8 12 fc ff ff       	call   c010061b <debuginfo_eip>
c0100a09:	85 c0                	test   %eax,%eax
c0100a0b:	74 15                	je     c0100a22 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a14:	c7 04 24 c6 94 10 c0 	movl   $0xc01094c6,(%esp)
c0100a1b:	e8 81 f8 ff ff       	call   c01002a1 <cprintf>
c0100a20:	eb 6d                	jmp    c0100a8f <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a29:	eb 1c                	jmp    c0100a47 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a31:	01 d0                	add    %edx,%eax
c0100a33:	0f b6 00             	movzbl (%eax),%eax
c0100a36:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a3f:	01 ca                	add    %ecx,%edx
c0100a41:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a43:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a4a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a4d:	7f dc                	jg     c0100a2b <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
c0100a4f:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a58:	01 d0                	add    %edx,%eax
c0100a5a:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a60:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a63:	89 d1                	mov    %edx,%ecx
c0100a65:	29 c1                	sub    %eax,%ecx
c0100a67:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a6d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a71:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a77:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a7b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a83:	c7 04 24 e2 94 10 c0 	movl   $0xc01094e2,(%esp)
c0100a8a:	e8 12 f8 ff ff       	call   c01002a1 <cprintf>
    }
}
c0100a8f:	c9                   	leave  
c0100a90:	c3                   	ret    

c0100a91 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a91:	55                   	push   %ebp
c0100a92:	89 e5                	mov    %esp,%ebp
c0100a94:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a97:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100aa0:	c9                   	leave  
c0100aa1:	c3                   	ret    

c0100aa2 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100aa2:	55                   	push   %ebp
c0100aa3:	89 e5                	mov    %esp,%ebp
c0100aa5:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100aa8:	89 e8                	mov    %ebp,%eax
c0100aaa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c0100ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100ab3:	e8 d9 ff ff ff       	call   c0100a91 <read_eip>
c0100ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100abb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100ac2:	e9 88 00 00 00       	jmp    c0100b4f <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100aca:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ad5:	c7 04 24 f4 94 10 c0 	movl   $0xc01094f4,(%esp)
c0100adc:	e8 c0 f7 ff ff       	call   c01002a1 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae4:	83 c0 08             	add    $0x8,%eax
c0100ae7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100aea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100af1:	eb 25                	jmp    c0100b18 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100af3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100af6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100b00:	01 d0                	add    %edx,%eax
c0100b02:	8b 00                	mov    (%eax),%eax
c0100b04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b08:	c7 04 24 10 95 10 c0 	movl   $0xc0109510,(%esp)
c0100b0f:	e8 8d f7 ff ff       	call   c01002a1 <cprintf>
        for (j = 0; j < 4; j ++) {
c0100b14:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100b18:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b1c:	7e d5                	jle    c0100af3 <print_stackframe+0x51>
        }
        cprintf("\n");
c0100b1e:	c7 04 24 18 95 10 c0 	movl   $0xc0109518,(%esp)
c0100b25:	e8 77 f7 ff ff       	call   c01002a1 <cprintf>
        print_debuginfo(eip - 1);
c0100b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b2d:	83 e8 01             	sub    $0x1,%eax
c0100b30:	89 04 24             	mov    %eax,(%esp)
c0100b33:	e8 b6 fe ff ff       	call   c01009ee <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b3b:	83 c0 04             	add    $0x4,%eax
c0100b3e:	8b 00                	mov    (%eax),%eax
c0100b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b46:	8b 00                	mov    (%eax),%eax
c0100b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100b4b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b53:	74 0a                	je     c0100b5f <print_stackframe+0xbd>
c0100b55:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b59:	0f 8e 68 ff ff ff    	jle    c0100ac7 <print_stackframe+0x25>
    }
}
c0100b5f:	c9                   	leave  
c0100b60:	c3                   	ret    

c0100b61 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b61:	55                   	push   %ebp
c0100b62:	89 e5                	mov    %esp,%ebp
c0100b64:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b6e:	eb 0c                	jmp    c0100b7c <parse+0x1b>
            *buf ++ = '\0';
c0100b70:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b73:	8d 50 01             	lea    0x1(%eax),%edx
c0100b76:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b79:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b7f:	0f b6 00             	movzbl (%eax),%eax
c0100b82:	84 c0                	test   %al,%al
c0100b84:	74 1d                	je     c0100ba3 <parse+0x42>
c0100b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b89:	0f b6 00             	movzbl (%eax),%eax
c0100b8c:	0f be c0             	movsbl %al,%eax
c0100b8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b93:	c7 04 24 9c 95 10 c0 	movl   $0xc010959c,(%esp)
c0100b9a:	e8 d7 7c 00 00       	call   c0108876 <strchr>
c0100b9f:	85 c0                	test   %eax,%eax
c0100ba1:	75 cd                	jne    c0100b70 <parse+0xf>
        }
        if (*buf == '\0') {
c0100ba3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba6:	0f b6 00             	movzbl (%eax),%eax
c0100ba9:	84 c0                	test   %al,%al
c0100bab:	75 02                	jne    c0100baf <parse+0x4e>
            break;
c0100bad:	eb 67                	jmp    c0100c16 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100baf:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bb3:	75 14                	jne    c0100bc9 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bb5:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100bbc:	00 
c0100bbd:	c7 04 24 a1 95 10 c0 	movl   $0xc01095a1,(%esp)
c0100bc4:	e8 d8 f6 ff ff       	call   c01002a1 <cprintf>
        }
        argv[argc ++] = buf;
c0100bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bcc:	8d 50 01             	lea    0x1(%eax),%edx
c0100bcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bd2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bdc:	01 c2                	add    %eax,%edx
c0100bde:	8b 45 08             	mov    0x8(%ebp),%eax
c0100be1:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100be3:	eb 04                	jmp    c0100be9 <parse+0x88>
            buf ++;
c0100be5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100be9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bec:	0f b6 00             	movzbl (%eax),%eax
c0100bef:	84 c0                	test   %al,%al
c0100bf1:	74 1d                	je     c0100c10 <parse+0xaf>
c0100bf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bf6:	0f b6 00             	movzbl (%eax),%eax
c0100bf9:	0f be c0             	movsbl %al,%eax
c0100bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c00:	c7 04 24 9c 95 10 c0 	movl   $0xc010959c,(%esp)
c0100c07:	e8 6a 7c 00 00       	call   c0108876 <strchr>
c0100c0c:	85 c0                	test   %eax,%eax
c0100c0e:	74 d5                	je     c0100be5 <parse+0x84>
        }
    }
c0100c10:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c11:	e9 66 ff ff ff       	jmp    c0100b7c <parse+0x1b>
    return argc;
c0100c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c19:	c9                   	leave  
c0100c1a:	c3                   	ret    

c0100c1b <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c1b:	55                   	push   %ebp
c0100c1c:	89 e5                	mov    %esp,%ebp
c0100c1e:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c21:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2b:	89 04 24             	mov    %eax,(%esp)
c0100c2e:	e8 2e ff ff ff       	call   c0100b61 <parse>
c0100c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c3a:	75 0a                	jne    c0100c46 <runcmd+0x2b>
        return 0;
c0100c3c:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c41:	e9 85 00 00 00       	jmp    c0100ccb <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c4d:	eb 5c                	jmp    c0100cab <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c4f:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c52:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c55:	89 d0                	mov    %edx,%eax
c0100c57:	01 c0                	add    %eax,%eax
c0100c59:	01 d0                	add    %edx,%eax
c0100c5b:	c1 e0 02             	shl    $0x2,%eax
c0100c5e:	05 00 10 12 c0       	add    $0xc0121000,%eax
c0100c63:	8b 00                	mov    (%eax),%eax
c0100c65:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c69:	89 04 24             	mov    %eax,(%esp)
c0100c6c:	e8 66 7b 00 00       	call   c01087d7 <strcmp>
c0100c71:	85 c0                	test   %eax,%eax
c0100c73:	75 32                	jne    c0100ca7 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c75:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c78:	89 d0                	mov    %edx,%eax
c0100c7a:	01 c0                	add    %eax,%eax
c0100c7c:	01 d0                	add    %edx,%eax
c0100c7e:	c1 e0 02             	shl    $0x2,%eax
c0100c81:	05 00 10 12 c0       	add    $0xc0121000,%eax
c0100c86:	8b 40 08             	mov    0x8(%eax),%eax
c0100c89:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100c8c:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100c92:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100c96:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100c99:	83 c2 04             	add    $0x4,%edx
c0100c9c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100ca0:	89 0c 24             	mov    %ecx,(%esp)
c0100ca3:	ff d0                	call   *%eax
c0100ca5:	eb 24                	jmp    c0100ccb <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ca7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cae:	83 f8 02             	cmp    $0x2,%eax
c0100cb1:	76 9c                	jbe    c0100c4f <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cb3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cba:	c7 04 24 bf 95 10 c0 	movl   $0xc01095bf,(%esp)
c0100cc1:	e8 db f5 ff ff       	call   c01002a1 <cprintf>
    return 0;
c0100cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccb:	c9                   	leave  
c0100ccc:	c3                   	ret    

c0100ccd <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100ccd:	55                   	push   %ebp
c0100cce:	89 e5                	mov    %esp,%ebp
c0100cd0:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cd3:	c7 04 24 d8 95 10 c0 	movl   $0xc01095d8,(%esp)
c0100cda:	e8 c2 f5 ff ff       	call   c01002a1 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100cdf:	c7 04 24 00 96 10 c0 	movl   $0xc0109600,(%esp)
c0100ce6:	e8 b6 f5 ff ff       	call   c01002a1 <cprintf>

    if (tf != NULL) {
c0100ceb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cef:	74 0b                	je     c0100cfc <kmonitor+0x2f>
        print_trapframe(tf);
c0100cf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf4:	89 04 24             	mov    %eax,(%esp)
c0100cf7:	e8 6a 15 00 00       	call   c0102266 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cfc:	c7 04 24 25 96 10 c0 	movl   $0xc0109625,(%esp)
c0100d03:	e8 3a f6 ff ff       	call   c0100342 <readline>
c0100d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d0f:	74 18                	je     c0100d29 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100d11:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d1b:	89 04 24             	mov    %eax,(%esp)
c0100d1e:	e8 f8 fe ff ff       	call   c0100c1b <runcmd>
c0100d23:	85 c0                	test   %eax,%eax
c0100d25:	79 02                	jns    c0100d29 <kmonitor+0x5c>
                break;
c0100d27:	eb 02                	jmp    c0100d2b <kmonitor+0x5e>
            }
        }
    }
c0100d29:	eb d1                	jmp    c0100cfc <kmonitor+0x2f>
}
c0100d2b:	c9                   	leave  
c0100d2c:	c3                   	ret    

c0100d2d <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d2d:	55                   	push   %ebp
c0100d2e:	89 e5                	mov    %esp,%ebp
c0100d30:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d3a:	eb 3f                	jmp    c0100d7b <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d3f:	89 d0                	mov    %edx,%eax
c0100d41:	01 c0                	add    %eax,%eax
c0100d43:	01 d0                	add    %edx,%eax
c0100d45:	c1 e0 02             	shl    $0x2,%eax
c0100d48:	05 00 10 12 c0       	add    $0xc0121000,%eax
c0100d4d:	8b 48 04             	mov    0x4(%eax),%ecx
c0100d50:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d53:	89 d0                	mov    %edx,%eax
c0100d55:	01 c0                	add    %eax,%eax
c0100d57:	01 d0                	add    %edx,%eax
c0100d59:	c1 e0 02             	shl    $0x2,%eax
c0100d5c:	05 00 10 12 c0       	add    $0xc0121000,%eax
c0100d61:	8b 00                	mov    (%eax),%eax
c0100d63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d6b:	c7 04 24 29 96 10 c0 	movl   $0xc0109629,(%esp)
c0100d72:	e8 2a f5 ff ff       	call   c01002a1 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d7e:	83 f8 02             	cmp    $0x2,%eax
c0100d81:	76 b9                	jbe    c0100d3c <mon_help+0xf>
    }
    return 0;
c0100d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d88:	c9                   	leave  
c0100d89:	c3                   	ret    

c0100d8a <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d8a:	55                   	push   %ebp
c0100d8b:	89 e5                	mov    %esp,%ebp
c0100d8d:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d90:	e8 c3 fb ff ff       	call   c0100958 <print_kerninfo>
    return 0;
c0100d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d9a:	c9                   	leave  
c0100d9b:	c3                   	ret    

c0100d9c <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d9c:	55                   	push   %ebp
c0100d9d:	89 e5                	mov    %esp,%ebp
c0100d9f:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100da2:	e8 fb fc ff ff       	call   c0100aa2 <print_stackframe>
    return 0;
c0100da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dac:	c9                   	leave  
c0100dad:	c3                   	ret    

c0100dae <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c0100dae:	55                   	push   %ebp
c0100daf:	89 e5                	mov    %esp,%ebp
c0100db1:	83 ec 14             	sub    $0x14,%esp
c0100db4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100db7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c0100dbb:	90                   	nop
c0100dbc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0100dc0:	83 c0 07             	add    $0x7,%eax
c0100dc3:	0f b7 c0             	movzwl %ax,%eax
c0100dc6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100dca:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100dce:	89 c2                	mov    %eax,%edx
c0100dd0:	ec                   	in     (%dx),%al
c0100dd1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100dd4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100dd8:	0f b6 c0             	movzbl %al,%eax
c0100ddb:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100dde:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100de1:	25 80 00 00 00       	and    $0x80,%eax
c0100de6:	85 c0                	test   %eax,%eax
c0100de8:	75 d2                	jne    c0100dbc <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0100dea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0100dee:	74 11                	je     c0100e01 <ide_wait_ready+0x53>
c0100df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100df3:	83 e0 21             	and    $0x21,%eax
c0100df6:	85 c0                	test   %eax,%eax
c0100df8:	74 07                	je     c0100e01 <ide_wait_ready+0x53>
        return -1;
c0100dfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100dff:	eb 05                	jmp    c0100e06 <ide_wait_ready+0x58>
    }
    return 0;
c0100e01:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e06:	c9                   	leave  
c0100e07:	c3                   	ret    

c0100e08 <ide_init>:

void
ide_init(void) {
c0100e08:	55                   	push   %ebp
c0100e09:	89 e5                	mov    %esp,%ebp
c0100e0b:	57                   	push   %edi
c0100e0c:	53                   	push   %ebx
c0100e0d:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0100e13:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0100e19:	e9 d6 02 00 00       	jmp    c01010f4 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0100e1e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e22:	c1 e0 03             	shl    $0x3,%eax
c0100e25:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100e2c:	29 c2                	sub    %eax,%edx
c0100e2e:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c0100e34:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0100e37:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e3b:	66 d1 e8             	shr    %ax
c0100e3e:	0f b7 c0             	movzwl %ax,%eax
c0100e41:	0f b7 04 85 34 96 10 	movzwl -0x3fef69cc(,%eax,4),%eax
c0100e48:	c0 
c0100e49:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0100e4d:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e51:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100e58:	00 
c0100e59:	89 04 24             	mov    %eax,(%esp)
c0100e5c:	e8 4d ff ff ff       	call   c0100dae <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0100e61:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e65:	83 e0 01             	and    $0x1,%eax
c0100e68:	c1 e0 04             	shl    $0x4,%eax
c0100e6b:	83 c8 e0             	or     $0xffffffe0,%eax
c0100e6e:	0f b6 c0             	movzbl %al,%eax
c0100e71:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e75:	83 c2 06             	add    $0x6,%edx
c0100e78:	0f b7 d2             	movzwl %dx,%edx
c0100e7b:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0100e7f:	88 45 d1             	mov    %al,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e82:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100e86:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100e8a:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100e8b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e8f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100e96:	00 
c0100e97:	89 04 24             	mov    %eax,(%esp)
c0100e9a:	e8 0f ff ff ff       	call   c0100dae <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c0100e9f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ea3:	83 c0 07             	add    $0x7,%eax
c0100ea6:	0f b7 c0             	movzwl %ax,%eax
c0100ea9:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c0100ead:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c0100eb1:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0100eb5:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0100eb9:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100eba:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ebe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100ec5:	00 
c0100ec6:	89 04 24             	mov    %eax,(%esp)
c0100ec9:	e8 e0 fe ff ff       	call   c0100dae <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c0100ece:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ed2:	83 c0 07             	add    $0x7,%eax
c0100ed5:	0f b7 c0             	movzwl %ax,%eax
c0100ed8:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100edc:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c0100ee0:	89 c2                	mov    %eax,%edx
c0100ee2:	ec                   	in     (%dx),%al
c0100ee3:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c0100ee6:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0100eea:	84 c0                	test   %al,%al
c0100eec:	0f 84 f7 01 00 00    	je     c01010e9 <ide_init+0x2e1>
c0100ef2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ef6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0100efd:	00 
c0100efe:	89 04 24             	mov    %eax,(%esp)
c0100f01:	e8 a8 fe ff ff       	call   c0100dae <ide_wait_ready>
c0100f06:	85 c0                	test   %eax,%eax
c0100f08:	0f 85 db 01 00 00    	jne    c01010e9 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0100f0e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f12:	c1 e0 03             	shl    $0x3,%eax
c0100f15:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100f1c:	29 c2                	sub    %eax,%edx
c0100f1e:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c0100f24:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0100f27:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f2b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0100f2e:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100f34:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0100f37:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
    asm volatile (
c0100f3e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0100f41:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0100f44:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0100f47:	89 cb                	mov    %ecx,%ebx
c0100f49:	89 df                	mov    %ebx,%edi
c0100f4b:	89 c1                	mov    %eax,%ecx
c0100f4d:	fc                   	cld    
c0100f4e:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0100f50:	89 c8                	mov    %ecx,%eax
c0100f52:	89 fb                	mov    %edi,%ebx
c0100f54:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0100f57:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0100f5a:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100f60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0100f63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100f66:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0100f6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0100f6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100f72:	25 00 00 00 04       	and    $0x4000000,%eax
c0100f77:	85 c0                	test   %eax,%eax
c0100f79:	74 0e                	je     c0100f89 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0100f7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100f7e:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0100f84:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0100f87:	eb 09                	jmp    c0100f92 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0100f89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100f8c:	8b 40 78             	mov    0x78(%eax),%eax
c0100f8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0100f92:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f96:	c1 e0 03             	shl    $0x3,%eax
c0100f99:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100fa0:	29 c2                	sub    %eax,%edx
c0100fa2:	81 c2 40 44 12 c0    	add    $0xc0124440,%edx
c0100fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100fab:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c0100fae:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100fb2:	c1 e0 03             	shl    $0x3,%eax
c0100fb5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100fbc:	29 c2                	sub    %eax,%edx
c0100fbe:	81 c2 40 44 12 c0    	add    $0xc0124440,%edx
c0100fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100fc7:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c0100fca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100fcd:	83 c0 62             	add    $0x62,%eax
c0100fd0:	0f b7 00             	movzwl (%eax),%eax
c0100fd3:	0f b7 c0             	movzwl %ax,%eax
c0100fd6:	25 00 02 00 00       	and    $0x200,%eax
c0100fdb:	85 c0                	test   %eax,%eax
c0100fdd:	75 24                	jne    c0101003 <ide_init+0x1fb>
c0100fdf:	c7 44 24 0c 3c 96 10 	movl   $0xc010963c,0xc(%esp)
c0100fe6:	c0 
c0100fe7:	c7 44 24 08 7f 96 10 	movl   $0xc010967f,0x8(%esp)
c0100fee:	c0 
c0100fef:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0100ff6:	00 
c0100ff7:	c7 04 24 94 96 10 c0 	movl   $0xc0109694,(%esp)
c0100ffe:	e8 f5 f3 ff ff       	call   c01003f8 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101003:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101007:	c1 e0 03             	shl    $0x3,%eax
c010100a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101011:	29 c2                	sub    %eax,%edx
c0101013:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c0101019:	83 c0 0c             	add    $0xc,%eax
c010101c:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010101f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101022:	83 c0 36             	add    $0x36,%eax
c0101025:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101028:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c010102f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101036:	eb 34                	jmp    c010106c <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101038:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010103b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010103e:	01 c2                	add    %eax,%edx
c0101040:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101043:	8d 48 01             	lea    0x1(%eax),%ecx
c0101046:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101049:	01 c8                	add    %ecx,%eax
c010104b:	0f b6 00             	movzbl (%eax),%eax
c010104e:	88 02                	mov    %al,(%edx)
c0101050:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101053:	8d 50 01             	lea    0x1(%eax),%edx
c0101056:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101059:	01 c2                	add    %eax,%edx
c010105b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010105e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101061:	01 c8                	add    %ecx,%eax
c0101063:	0f b6 00             	movzbl (%eax),%eax
c0101066:	88 02                	mov    %al,(%edx)
        for (i = 0; i < length; i += 2) {
c0101068:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c010106c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010106f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101072:	72 c4                	jb     c0101038 <ide_init+0x230>
        }
        do {
            model[i] = '\0';
c0101074:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101077:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010107a:	01 d0                	add    %edx,%eax
c010107c:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010107f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101082:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101085:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101088:	85 c0                	test   %eax,%eax
c010108a:	74 0f                	je     c010109b <ide_init+0x293>
c010108c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010108f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101092:	01 d0                	add    %edx,%eax
c0101094:	0f b6 00             	movzbl (%eax),%eax
c0101097:	3c 20                	cmp    $0x20,%al
c0101099:	74 d9                	je     c0101074 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c010109b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010109f:	c1 e0 03             	shl    $0x3,%eax
c01010a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01010a9:	29 c2                	sub    %eax,%edx
c01010ab:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c01010b1:	8d 48 0c             	lea    0xc(%eax),%ecx
c01010b4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010b8:	c1 e0 03             	shl    $0x3,%eax
c01010bb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01010c2:	29 c2                	sub    %eax,%edx
c01010c4:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c01010ca:	8b 50 08             	mov    0x8(%eax),%edx
c01010cd:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010d1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01010d5:	89 54 24 08          	mov    %edx,0x8(%esp)
c01010d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01010dd:	c7 04 24 a6 96 10 c0 	movl   $0xc01096a6,(%esp)
c01010e4:	e8 b8 f1 ff ff       	call   c01002a1 <cprintf>
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01010e9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010ed:	83 c0 01             	add    $0x1,%eax
c01010f0:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01010f4:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c01010f9:	0f 86 1f fd ff ff    	jbe    c0100e1e <ide_init+0x16>
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c01010ff:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101106:	e8 91 0e 00 00       	call   c0101f9c <pic_enable>
    pic_enable(IRQ_IDE2);
c010110b:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101112:	e8 85 0e 00 00       	call   c0101f9c <pic_enable>
}
c0101117:	81 c4 50 02 00 00    	add    $0x250,%esp
c010111d:	5b                   	pop    %ebx
c010111e:	5f                   	pop    %edi
c010111f:	5d                   	pop    %ebp
c0101120:	c3                   	ret    

c0101121 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101121:	55                   	push   %ebp
c0101122:	89 e5                	mov    %esp,%ebp
c0101124:	83 ec 04             	sub    $0x4,%esp
c0101127:	8b 45 08             	mov    0x8(%ebp),%eax
c010112a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c010112e:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101133:	77 24                	ja     c0101159 <ide_device_valid+0x38>
c0101135:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101139:	c1 e0 03             	shl    $0x3,%eax
c010113c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101143:	29 c2                	sub    %eax,%edx
c0101145:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c010114b:	0f b6 00             	movzbl (%eax),%eax
c010114e:	84 c0                	test   %al,%al
c0101150:	74 07                	je     c0101159 <ide_device_valid+0x38>
c0101152:	b8 01 00 00 00       	mov    $0x1,%eax
c0101157:	eb 05                	jmp    c010115e <ide_device_valid+0x3d>
c0101159:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010115e:	c9                   	leave  
c010115f:	c3                   	ret    

c0101160 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101160:	55                   	push   %ebp
c0101161:	89 e5                	mov    %esp,%ebp
c0101163:	83 ec 08             	sub    $0x8,%esp
c0101166:	8b 45 08             	mov    0x8(%ebp),%eax
c0101169:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c010116d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101171:	89 04 24             	mov    %eax,(%esp)
c0101174:	e8 a8 ff ff ff       	call   c0101121 <ide_device_valid>
c0101179:	85 c0                	test   %eax,%eax
c010117b:	74 1b                	je     c0101198 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c010117d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101181:	c1 e0 03             	shl    $0x3,%eax
c0101184:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010118b:	29 c2                	sub    %eax,%edx
c010118d:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c0101193:	8b 40 08             	mov    0x8(%eax),%eax
c0101196:	eb 05                	jmp    c010119d <ide_device_size+0x3d>
    }
    return 0;
c0101198:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010119d:	c9                   	leave  
c010119e:	c3                   	ret    

c010119f <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c010119f:	55                   	push   %ebp
c01011a0:	89 e5                	mov    %esp,%ebp
c01011a2:	57                   	push   %edi
c01011a3:	53                   	push   %ebx
c01011a4:	83 ec 50             	sub    $0x50,%esp
c01011a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01011aa:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c01011ae:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c01011b5:	77 24                	ja     c01011db <ide_read_secs+0x3c>
c01011b7:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c01011bc:	77 1d                	ja     c01011db <ide_read_secs+0x3c>
c01011be:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01011c2:	c1 e0 03             	shl    $0x3,%eax
c01011c5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01011cc:	29 c2                	sub    %eax,%edx
c01011ce:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c01011d4:	0f b6 00             	movzbl (%eax),%eax
c01011d7:	84 c0                	test   %al,%al
c01011d9:	75 24                	jne    c01011ff <ide_read_secs+0x60>
c01011db:	c7 44 24 0c c4 96 10 	movl   $0xc01096c4,0xc(%esp)
c01011e2:	c0 
c01011e3:	c7 44 24 08 7f 96 10 	movl   $0xc010967f,0x8(%esp)
c01011ea:	c0 
c01011eb:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c01011f2:	00 
c01011f3:	c7 04 24 94 96 10 c0 	movl   $0xc0109694,(%esp)
c01011fa:	e8 f9 f1 ff ff       	call   c01003f8 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01011ff:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101206:	77 0f                	ja     c0101217 <ide_read_secs+0x78>
c0101208:	8b 45 14             	mov    0x14(%ebp),%eax
c010120b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010120e:	01 d0                	add    %edx,%eax
c0101210:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101215:	76 24                	jbe    c010123b <ide_read_secs+0x9c>
c0101217:	c7 44 24 0c ec 96 10 	movl   $0xc01096ec,0xc(%esp)
c010121e:	c0 
c010121f:	c7 44 24 08 7f 96 10 	movl   $0xc010967f,0x8(%esp)
c0101226:	c0 
c0101227:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c010122e:	00 
c010122f:	c7 04 24 94 96 10 c0 	movl   $0xc0109694,(%esp)
c0101236:	e8 bd f1 ff ff       	call   c01003f8 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c010123b:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010123f:	66 d1 e8             	shr    %ax
c0101242:	0f b7 c0             	movzwl %ax,%eax
c0101245:	0f b7 04 85 34 96 10 	movzwl -0x3fef69cc(,%eax,4),%eax
c010124c:	c0 
c010124d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101251:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101255:	66 d1 e8             	shr    %ax
c0101258:	0f b7 c0             	movzwl %ax,%eax
c010125b:	0f b7 04 85 36 96 10 	movzwl -0x3fef69ca(,%eax,4),%eax
c0101262:	c0 
c0101263:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101267:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010126b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101272:	00 
c0101273:	89 04 24             	mov    %eax,(%esp)
c0101276:	e8 33 fb ff ff       	call   c0100dae <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c010127b:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010127f:	83 c0 02             	add    $0x2,%eax
c0101282:	0f b7 c0             	movzwl %ax,%eax
c0101285:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101289:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010128d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101291:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101295:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101296:	8b 45 14             	mov    0x14(%ebp),%eax
c0101299:	0f b6 c0             	movzbl %al,%eax
c010129c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012a0:	83 c2 02             	add    $0x2,%edx
c01012a3:	0f b7 d2             	movzwl %dx,%edx
c01012a6:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01012aa:	88 45 e9             	mov    %al,-0x17(%ebp)
c01012ad:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012b1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012b5:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c01012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012b9:	0f b6 c0             	movzbl %al,%eax
c01012bc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012c0:	83 c2 03             	add    $0x3,%edx
c01012c3:	0f b7 d2             	movzwl %dx,%edx
c01012c6:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ca:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012cd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012d1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012d5:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c01012d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012d9:	c1 e8 08             	shr    $0x8,%eax
c01012dc:	0f b6 c0             	movzbl %al,%eax
c01012df:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012e3:	83 c2 04             	add    $0x4,%edx
c01012e6:	0f b7 d2             	movzwl %dx,%edx
c01012e9:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c01012ed:	88 45 e1             	mov    %al,-0x1f(%ebp)
c01012f0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01012f4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01012f8:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c01012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012fc:	c1 e8 10             	shr    $0x10,%eax
c01012ff:	0f b6 c0             	movzbl %al,%eax
c0101302:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101306:	83 c2 05             	add    $0x5,%edx
c0101309:	0f b7 d2             	movzwl %dx,%edx
c010130c:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101310:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101313:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101317:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010131b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c010131c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101320:	83 e0 01             	and    $0x1,%eax
c0101323:	c1 e0 04             	shl    $0x4,%eax
c0101326:	89 c2                	mov    %eax,%edx
c0101328:	8b 45 0c             	mov    0xc(%ebp),%eax
c010132b:	c1 e8 18             	shr    $0x18,%eax
c010132e:	83 e0 0f             	and    $0xf,%eax
c0101331:	09 d0                	or     %edx,%eax
c0101333:	83 c8 e0             	or     $0xffffffe0,%eax
c0101336:	0f b6 c0             	movzbl %al,%eax
c0101339:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010133d:	83 c2 06             	add    $0x6,%edx
c0101340:	0f b7 d2             	movzwl %dx,%edx
c0101343:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101347:	88 45 d9             	mov    %al,-0x27(%ebp)
c010134a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010134e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101352:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101353:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101357:	83 c0 07             	add    $0x7,%eax
c010135a:	0f b7 c0             	movzwl %ax,%eax
c010135d:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101361:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101365:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101369:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010136d:	ee                   	out    %al,(%dx)

    int ret = 0;
c010136e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101375:	eb 5a                	jmp    c01013d1 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101377:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010137b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101382:	00 
c0101383:	89 04 24             	mov    %eax,(%esp)
c0101386:	e8 23 fa ff ff       	call   c0100dae <ide_wait_ready>
c010138b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010138e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101392:	74 02                	je     c0101396 <ide_read_secs+0x1f7>
            goto out;
c0101394:	eb 41                	jmp    c01013d7 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101396:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010139a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010139d:	8b 45 10             	mov    0x10(%ebp),%eax
c01013a0:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01013a3:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile (
c01013aa:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01013ad:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c01013b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01013b3:	89 cb                	mov    %ecx,%ebx
c01013b5:	89 df                	mov    %ebx,%edi
c01013b7:	89 c1                	mov    %eax,%ecx
c01013b9:	fc                   	cld    
c01013ba:	f2 6d                	repnz insl (%dx),%es:(%edi)
c01013bc:	89 c8                	mov    %ecx,%eax
c01013be:	89 fb                	mov    %edi,%ebx
c01013c0:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c01013c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c01013c6:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c01013ca:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c01013d1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c01013d5:	75 a0                	jne    c0101377 <ide_read_secs+0x1d8>
    }

out:
    return ret;
c01013d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01013da:	83 c4 50             	add    $0x50,%esp
c01013dd:	5b                   	pop    %ebx
c01013de:	5f                   	pop    %edi
c01013df:	5d                   	pop    %ebp
c01013e0:	c3                   	ret    

c01013e1 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c01013e1:	55                   	push   %ebp
c01013e2:	89 e5                	mov    %esp,%ebp
c01013e4:	56                   	push   %esi
c01013e5:	53                   	push   %ebx
c01013e6:	83 ec 50             	sub    $0x50,%esp
c01013e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ec:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c01013f0:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c01013f7:	77 24                	ja     c010141d <ide_write_secs+0x3c>
c01013f9:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c01013fe:	77 1d                	ja     c010141d <ide_write_secs+0x3c>
c0101400:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101404:	c1 e0 03             	shl    $0x3,%eax
c0101407:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010140e:	29 c2                	sub    %eax,%edx
c0101410:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c0101416:	0f b6 00             	movzbl (%eax),%eax
c0101419:	84 c0                	test   %al,%al
c010141b:	75 24                	jne    c0101441 <ide_write_secs+0x60>
c010141d:	c7 44 24 0c c4 96 10 	movl   $0xc01096c4,0xc(%esp)
c0101424:	c0 
c0101425:	c7 44 24 08 7f 96 10 	movl   $0xc010967f,0x8(%esp)
c010142c:	c0 
c010142d:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101434:	00 
c0101435:	c7 04 24 94 96 10 c0 	movl   $0xc0109694,(%esp)
c010143c:	e8 b7 ef ff ff       	call   c01003f8 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101441:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101448:	77 0f                	ja     c0101459 <ide_write_secs+0x78>
c010144a:	8b 45 14             	mov    0x14(%ebp),%eax
c010144d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101450:	01 d0                	add    %edx,%eax
c0101452:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101457:	76 24                	jbe    c010147d <ide_write_secs+0x9c>
c0101459:	c7 44 24 0c ec 96 10 	movl   $0xc01096ec,0xc(%esp)
c0101460:	c0 
c0101461:	c7 44 24 08 7f 96 10 	movl   $0xc010967f,0x8(%esp)
c0101468:	c0 
c0101469:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101470:	00 
c0101471:	c7 04 24 94 96 10 c0 	movl   $0xc0109694,(%esp)
c0101478:	e8 7b ef ff ff       	call   c01003f8 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c010147d:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101481:	66 d1 e8             	shr    %ax
c0101484:	0f b7 c0             	movzwl %ax,%eax
c0101487:	0f b7 04 85 34 96 10 	movzwl -0x3fef69cc(,%eax,4),%eax
c010148e:	c0 
c010148f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101493:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101497:	66 d1 e8             	shr    %ax
c010149a:	0f b7 c0             	movzwl %ax,%eax
c010149d:	0f b7 04 85 36 96 10 	movzwl -0x3fef69ca(,%eax,4),%eax
c01014a4:	c0 
c01014a5:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c01014a9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01014ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01014b4:	00 
c01014b5:	89 04 24             	mov    %eax,(%esp)
c01014b8:	e8 f1 f8 ff ff       	call   c0100dae <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c01014bd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01014c1:	83 c0 02             	add    $0x2,%eax
c01014c4:	0f b7 c0             	movzwl %ax,%eax
c01014c7:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01014cb:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01014cf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01014d3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01014d7:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c01014d8:	8b 45 14             	mov    0x14(%ebp),%eax
c01014db:	0f b6 c0             	movzbl %al,%eax
c01014de:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01014e2:	83 c2 02             	add    $0x2,%edx
c01014e5:	0f b7 d2             	movzwl %dx,%edx
c01014e8:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01014ec:	88 45 e9             	mov    %al,-0x17(%ebp)
c01014ef:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01014f3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01014f7:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c01014f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014fb:	0f b6 c0             	movzbl %al,%eax
c01014fe:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101502:	83 c2 03             	add    $0x3,%edx
c0101505:	0f b7 d2             	movzwl %dx,%edx
c0101508:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c010150c:	88 45 e5             	mov    %al,-0x1b(%ebp)
c010150f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101513:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101517:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101518:	8b 45 0c             	mov    0xc(%ebp),%eax
c010151b:	c1 e8 08             	shr    $0x8,%eax
c010151e:	0f b6 c0             	movzbl %al,%eax
c0101521:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101525:	83 c2 04             	add    $0x4,%edx
c0101528:	0f b7 d2             	movzwl %dx,%edx
c010152b:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c010152f:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101532:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101536:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010153a:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c010153b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010153e:	c1 e8 10             	shr    $0x10,%eax
c0101541:	0f b6 c0             	movzbl %al,%eax
c0101544:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101548:	83 c2 05             	add    $0x5,%edx
c010154b:	0f b7 d2             	movzwl %dx,%edx
c010154e:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101552:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101555:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101559:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010155d:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c010155e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101562:	83 e0 01             	and    $0x1,%eax
c0101565:	c1 e0 04             	shl    $0x4,%eax
c0101568:	89 c2                	mov    %eax,%edx
c010156a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010156d:	c1 e8 18             	shr    $0x18,%eax
c0101570:	83 e0 0f             	and    $0xf,%eax
c0101573:	09 d0                	or     %edx,%eax
c0101575:	83 c8 e0             	or     $0xffffffe0,%eax
c0101578:	0f b6 c0             	movzbl %al,%eax
c010157b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010157f:	83 c2 06             	add    $0x6,%edx
c0101582:	0f b7 d2             	movzwl %dx,%edx
c0101585:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101589:	88 45 d9             	mov    %al,-0x27(%ebp)
c010158c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101590:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101594:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101595:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101599:	83 c0 07             	add    $0x7,%eax
c010159c:	0f b7 c0             	movzwl %ax,%eax
c010159f:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c01015a3:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c01015a7:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01015ab:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01015af:	ee                   	out    %al,(%dx)

    int ret = 0;
c01015b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c01015b7:	eb 5a                	jmp    c0101613 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c01015b9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01015bd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01015c4:	00 
c01015c5:	89 04 24             	mov    %eax,(%esp)
c01015c8:	e8 e1 f7 ff ff       	call   c0100dae <ide_wait_ready>
c01015cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01015d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01015d4:	74 02                	je     c01015d8 <ide_write_secs+0x1f7>
            goto out;
c01015d6:	eb 41                	jmp    c0101619 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c01015d8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01015dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01015df:	8b 45 10             	mov    0x10(%ebp),%eax
c01015e2:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01015e5:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile (
c01015ec:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01015ef:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c01015f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01015f5:	89 cb                	mov    %ecx,%ebx
c01015f7:	89 de                	mov    %ebx,%esi
c01015f9:	89 c1                	mov    %eax,%ecx
c01015fb:	fc                   	cld    
c01015fc:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c01015fe:	89 c8                	mov    %ecx,%eax
c0101600:	89 f3                	mov    %esi,%ebx
c0101602:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101605:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101608:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c010160c:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101613:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101617:	75 a0                	jne    c01015b9 <ide_write_secs+0x1d8>
    }

out:
    return ret;
c0101619:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010161c:	83 c4 50             	add    $0x50,%esp
c010161f:	5b                   	pop    %ebx
c0101620:	5e                   	pop    %esi
c0101621:	5d                   	pop    %ebp
c0101622:	c3                   	ret    

c0101623 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0101623:	55                   	push   %ebp
c0101624:	89 e5                	mov    %esp,%ebp
c0101626:	83 ec 28             	sub    $0x28,%esp
c0101629:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c010162f:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101633:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101637:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010163b:	ee                   	out    %al,(%dx)
c010163c:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0101642:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0101646:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010164a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010164e:	ee                   	out    %al,(%dx)
c010164f:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0101655:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0101659:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010165d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101661:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0101662:	c7 05 0c 50 12 c0 00 	movl   $0x0,0xc012500c
c0101669:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c010166c:	c7 04 24 26 97 10 c0 	movl   $0xc0109726,(%esp)
c0101673:	e8 29 ec ff ff       	call   c01002a1 <cprintf>
    pic_enable(IRQ_TIMER);
c0101678:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010167f:	e8 18 09 00 00       	call   c0101f9c <pic_enable>
}
c0101684:	c9                   	leave  
c0101685:	c3                   	ret    

c0101686 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0101686:	55                   	push   %ebp
c0101687:	89 e5                	mov    %esp,%ebp
c0101689:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010168c:	9c                   	pushf  
c010168d:	58                   	pop    %eax
c010168e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0101691:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0101694:	25 00 02 00 00       	and    $0x200,%eax
c0101699:	85 c0                	test   %eax,%eax
c010169b:	74 0c                	je     c01016a9 <__intr_save+0x23>
        intr_disable();
c010169d:	e8 69 0a 00 00       	call   c010210b <intr_disable>
        return 1;
c01016a2:	b8 01 00 00 00       	mov    $0x1,%eax
c01016a7:	eb 05                	jmp    c01016ae <__intr_save+0x28>
    }
    return 0;
c01016a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01016ae:	c9                   	leave  
c01016af:	c3                   	ret    

c01016b0 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01016b0:	55                   	push   %ebp
c01016b1:	89 e5                	mov    %esp,%ebp
c01016b3:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01016b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01016ba:	74 05                	je     c01016c1 <__intr_restore+0x11>
        intr_enable();
c01016bc:	e8 44 0a 00 00       	call   c0102105 <intr_enable>
    }
}
c01016c1:	c9                   	leave  
c01016c2:	c3                   	ret    

c01016c3 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c01016c3:	55                   	push   %ebp
c01016c4:	89 e5                	mov    %esp,%ebp
c01016c6:	83 ec 10             	sub    $0x10,%esp
c01016c9:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016cf:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01016d3:	89 c2                	mov    %eax,%edx
c01016d5:	ec                   	in     (%dx),%al
c01016d6:	88 45 fd             	mov    %al,-0x3(%ebp)
c01016d9:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c01016df:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016e3:	89 c2                	mov    %eax,%edx
c01016e5:	ec                   	in     (%dx),%al
c01016e6:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016e9:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c01016ef:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01016f3:	89 c2                	mov    %eax,%edx
c01016f5:	ec                   	in     (%dx),%al
c01016f6:	88 45 f5             	mov    %al,-0xb(%ebp)
c01016f9:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c01016ff:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101703:	89 c2                	mov    %eax,%edx
c0101705:	ec                   	in     (%dx),%al
c0101706:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0101709:	c9                   	leave  
c010170a:	c3                   	ret    

c010170b <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c010170b:	55                   	push   %ebp
c010170c:	89 e5                	mov    %esp,%ebp
c010170e:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0101711:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0101718:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010171b:	0f b7 00             	movzwl (%eax),%eax
c010171e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0101722:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101725:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c010172a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010172d:	0f b7 00             	movzwl (%eax),%eax
c0101730:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0101734:	74 12                	je     c0101748 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0101736:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c010173d:	66 c7 05 26 45 12 c0 	movw   $0x3b4,0xc0124526
c0101744:	b4 03 
c0101746:	eb 13                	jmp    c010175b <cga_init+0x50>
    } else {
        *cp = was;
c0101748:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010174b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010174f:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0101752:	66 c7 05 26 45 12 c0 	movw   $0x3d4,0xc0124526
c0101759:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c010175b:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c0101762:	0f b7 c0             	movzwl %ax,%eax
c0101765:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101769:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010176d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101771:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101775:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0101776:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c010177d:	83 c0 01             	add    $0x1,%eax
c0101780:	0f b7 c0             	movzwl %ax,%eax
c0101783:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101787:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c010178b:	89 c2                	mov    %eax,%edx
c010178d:	ec                   	in     (%dx),%al
c010178e:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101791:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101795:	0f b6 c0             	movzbl %al,%eax
c0101798:	c1 e0 08             	shl    $0x8,%eax
c010179b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c010179e:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c01017a5:	0f b7 c0             	movzwl %ax,%eax
c01017a8:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01017ac:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017b0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017b8:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c01017b9:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c01017c0:	83 c0 01             	add    $0x1,%eax
c01017c3:	0f b7 c0             	movzwl %ax,%eax
c01017c6:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017ca:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01017ce:	89 c2                	mov    %eax,%edx
c01017d0:	ec                   	in     (%dx),%al
c01017d1:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c01017d4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017d8:	0f b6 c0             	movzbl %al,%eax
c01017db:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c01017de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017e1:	a3 20 45 12 c0       	mov    %eax,0xc0124520
    crt_pos = pos;
c01017e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01017e9:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
}
c01017ef:	c9                   	leave  
c01017f0:	c3                   	ret    

c01017f1 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c01017f1:	55                   	push   %ebp
c01017f2:	89 e5                	mov    %esp,%ebp
c01017f4:	83 ec 48             	sub    $0x48,%esp
c01017f7:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c01017fd:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101801:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101805:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101809:	ee                   	out    %al,(%dx)
c010180a:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0101810:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0101814:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101818:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010181c:	ee                   	out    %al,(%dx)
c010181d:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0101823:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0101827:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010182b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010182f:	ee                   	out    %al,(%dx)
c0101830:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101836:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c010183a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010183e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101842:	ee                   	out    %al,(%dx)
c0101843:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0101849:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c010184d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101851:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101855:	ee                   	out    %al,(%dx)
c0101856:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c010185c:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0101860:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101864:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101868:	ee                   	out    %al,(%dx)
c0101869:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c010186f:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0101873:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101877:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010187b:	ee                   	out    %al,(%dx)
c010187c:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101882:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101886:	89 c2                	mov    %eax,%edx
c0101888:	ec                   	in     (%dx),%al
c0101889:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c010188c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101890:	3c ff                	cmp    $0xff,%al
c0101892:	0f 95 c0             	setne  %al
c0101895:	0f b6 c0             	movzbl %al,%eax
c0101898:	a3 28 45 12 c0       	mov    %eax,0xc0124528
c010189d:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01018a3:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c01018a7:	89 c2                	mov    %eax,%edx
c01018a9:	ec                   	in     (%dx),%al
c01018aa:	88 45 d5             	mov    %al,-0x2b(%ebp)
c01018ad:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c01018b3:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c01018b7:	89 c2                	mov    %eax,%edx
c01018b9:	ec                   	in     (%dx),%al
c01018ba:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c01018bd:	a1 28 45 12 c0       	mov    0xc0124528,%eax
c01018c2:	85 c0                	test   %eax,%eax
c01018c4:	74 0c                	je     c01018d2 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c01018c6:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01018cd:	e8 ca 06 00 00       	call   c0101f9c <pic_enable>
    }
}
c01018d2:	c9                   	leave  
c01018d3:	c3                   	ret    

c01018d4 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01018d4:	55                   	push   %ebp
c01018d5:	89 e5                	mov    %esp,%ebp
c01018d7:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01018da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018e1:	eb 09                	jmp    c01018ec <lpt_putc_sub+0x18>
        delay();
c01018e3:	e8 db fd ff ff       	call   c01016c3 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01018e8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01018ec:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01018f2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01018f6:	89 c2                	mov    %eax,%edx
c01018f8:	ec                   	in     (%dx),%al
c01018f9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01018fc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101900:	84 c0                	test   %al,%al
c0101902:	78 09                	js     c010190d <lpt_putc_sub+0x39>
c0101904:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010190b:	7e d6                	jle    c01018e3 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c010190d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101910:	0f b6 c0             	movzbl %al,%eax
c0101913:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101919:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010191c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101920:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101924:	ee                   	out    %al,(%dx)
c0101925:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010192b:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010192f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101933:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101937:	ee                   	out    %al,(%dx)
c0101938:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c010193e:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c0101942:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101946:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010194a:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c010194b:	c9                   	leave  
c010194c:	c3                   	ret    

c010194d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c010194d:	55                   	push   %ebp
c010194e:	89 e5                	mov    %esp,%ebp
c0101950:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101953:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101957:	74 0d                	je     c0101966 <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101959:	8b 45 08             	mov    0x8(%ebp),%eax
c010195c:	89 04 24             	mov    %eax,(%esp)
c010195f:	e8 70 ff ff ff       	call   c01018d4 <lpt_putc_sub>
c0101964:	eb 24                	jmp    c010198a <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c0101966:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010196d:	e8 62 ff ff ff       	call   c01018d4 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101972:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101979:	e8 56 ff ff ff       	call   c01018d4 <lpt_putc_sub>
        lpt_putc_sub('\b');
c010197e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101985:	e8 4a ff ff ff       	call   c01018d4 <lpt_putc_sub>
    }
}
c010198a:	c9                   	leave  
c010198b:	c3                   	ret    

c010198c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010198c:	55                   	push   %ebp
c010198d:	89 e5                	mov    %esp,%ebp
c010198f:	53                   	push   %ebx
c0101990:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101993:	8b 45 08             	mov    0x8(%ebp),%eax
c0101996:	b0 00                	mov    $0x0,%al
c0101998:	85 c0                	test   %eax,%eax
c010199a:	75 07                	jne    c01019a3 <cga_putc+0x17>
        c |= 0x0700;
c010199c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01019a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01019a6:	0f b6 c0             	movzbl %al,%eax
c01019a9:	83 f8 0a             	cmp    $0xa,%eax
c01019ac:	74 4c                	je     c01019fa <cga_putc+0x6e>
c01019ae:	83 f8 0d             	cmp    $0xd,%eax
c01019b1:	74 57                	je     c0101a0a <cga_putc+0x7e>
c01019b3:	83 f8 08             	cmp    $0x8,%eax
c01019b6:	0f 85 88 00 00 00    	jne    c0101a44 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c01019bc:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c01019c3:	66 85 c0             	test   %ax,%ax
c01019c6:	74 30                	je     c01019f8 <cga_putc+0x6c>
            crt_pos --;
c01019c8:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c01019cf:	83 e8 01             	sub    $0x1,%eax
c01019d2:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01019d8:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c01019dd:	0f b7 15 24 45 12 c0 	movzwl 0xc0124524,%edx
c01019e4:	0f b7 d2             	movzwl %dx,%edx
c01019e7:	01 d2                	add    %edx,%edx
c01019e9:	01 c2                	add    %eax,%edx
c01019eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01019ee:	b0 00                	mov    $0x0,%al
c01019f0:	83 c8 20             	or     $0x20,%eax
c01019f3:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01019f6:	eb 72                	jmp    c0101a6a <cga_putc+0xde>
c01019f8:	eb 70                	jmp    c0101a6a <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c01019fa:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101a01:	83 c0 50             	add    $0x50,%eax
c0101a04:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101a0a:	0f b7 1d 24 45 12 c0 	movzwl 0xc0124524,%ebx
c0101a11:	0f b7 0d 24 45 12 c0 	movzwl 0xc0124524,%ecx
c0101a18:	0f b7 c1             	movzwl %cx,%eax
c0101a1b:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101a21:	c1 e8 10             	shr    $0x10,%eax
c0101a24:	89 c2                	mov    %eax,%edx
c0101a26:	66 c1 ea 06          	shr    $0x6,%dx
c0101a2a:	89 d0                	mov    %edx,%eax
c0101a2c:	c1 e0 02             	shl    $0x2,%eax
c0101a2f:	01 d0                	add    %edx,%eax
c0101a31:	c1 e0 04             	shl    $0x4,%eax
c0101a34:	29 c1                	sub    %eax,%ecx
c0101a36:	89 ca                	mov    %ecx,%edx
c0101a38:	89 d8                	mov    %ebx,%eax
c0101a3a:	29 d0                	sub    %edx,%eax
c0101a3c:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
        break;
c0101a42:	eb 26                	jmp    c0101a6a <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101a44:	8b 0d 20 45 12 c0    	mov    0xc0124520,%ecx
c0101a4a:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101a51:	8d 50 01             	lea    0x1(%eax),%edx
c0101a54:	66 89 15 24 45 12 c0 	mov    %dx,0xc0124524
c0101a5b:	0f b7 c0             	movzwl %ax,%eax
c0101a5e:	01 c0                	add    %eax,%eax
c0101a60:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101a63:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a66:	66 89 02             	mov    %ax,(%edx)
        break;
c0101a69:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101a6a:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101a71:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101a75:	76 5b                	jbe    c0101ad2 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101a77:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c0101a7c:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101a82:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c0101a87:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101a8e:	00 
c0101a8f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101a93:	89 04 24             	mov    %eax,(%esp)
c0101a96:	e8 d9 6f 00 00       	call   c0108a74 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101a9b:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101aa2:	eb 15                	jmp    c0101ab9 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101aa4:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c0101aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101aac:	01 d2                	add    %edx,%edx
c0101aae:	01 d0                	add    %edx,%eax
c0101ab0:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101ab5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101ab9:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101ac0:	7e e2                	jle    c0101aa4 <cga_putc+0x118>
        }
        crt_pos -= CRT_COLS;
c0101ac2:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101ac9:	83 e8 50             	sub    $0x50,%eax
c0101acc:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101ad2:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c0101ad9:	0f b7 c0             	movzwl %ax,%eax
c0101adc:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101ae0:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101ae4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101ae8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101aec:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101aed:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101af4:	66 c1 e8 08          	shr    $0x8,%ax
c0101af8:	0f b6 c0             	movzbl %al,%eax
c0101afb:	0f b7 15 26 45 12 c0 	movzwl 0xc0124526,%edx
c0101b02:	83 c2 01             	add    $0x1,%edx
c0101b05:	0f b7 d2             	movzwl %dx,%edx
c0101b08:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101b0c:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101b0f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b13:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101b17:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101b18:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c0101b1f:	0f b7 c0             	movzwl %ax,%eax
c0101b22:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101b26:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101b2a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101b2e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101b32:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101b33:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101b3a:	0f b6 c0             	movzbl %al,%eax
c0101b3d:	0f b7 15 26 45 12 c0 	movzwl 0xc0124526,%edx
c0101b44:	83 c2 01             	add    $0x1,%edx
c0101b47:	0f b7 d2             	movzwl %dx,%edx
c0101b4a:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101b4e:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101b51:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101b55:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101b59:	ee                   	out    %al,(%dx)
}
c0101b5a:	83 c4 34             	add    $0x34,%esp
c0101b5d:	5b                   	pop    %ebx
c0101b5e:	5d                   	pop    %ebp
c0101b5f:	c3                   	ret    

c0101b60 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101b60:	55                   	push   %ebp
c0101b61:	89 e5                	mov    %esp,%ebp
c0101b63:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101b66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101b6d:	eb 09                	jmp    c0101b78 <serial_putc_sub+0x18>
        delay();
c0101b6f:	e8 4f fb ff ff       	call   c01016c3 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101b74:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101b78:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101b7e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101b82:	89 c2                	mov    %eax,%edx
c0101b84:	ec                   	in     (%dx),%al
c0101b85:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101b88:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101b8c:	0f b6 c0             	movzbl %al,%eax
c0101b8f:	83 e0 20             	and    $0x20,%eax
c0101b92:	85 c0                	test   %eax,%eax
c0101b94:	75 09                	jne    c0101b9f <serial_putc_sub+0x3f>
c0101b96:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101b9d:	7e d0                	jle    c0101b6f <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101b9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba2:	0f b6 c0             	movzbl %al,%eax
c0101ba5:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101bab:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101bae:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101bb2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101bb6:	ee                   	out    %al,(%dx)
}
c0101bb7:	c9                   	leave  
c0101bb8:	c3                   	ret    

c0101bb9 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101bb9:	55                   	push   %ebp
c0101bba:	89 e5                	mov    %esp,%ebp
c0101bbc:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101bbf:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101bc3:	74 0d                	je     c0101bd2 <serial_putc+0x19>
        serial_putc_sub(c);
c0101bc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc8:	89 04 24             	mov    %eax,(%esp)
c0101bcb:	e8 90 ff ff ff       	call   c0101b60 <serial_putc_sub>
c0101bd0:	eb 24                	jmp    c0101bf6 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101bd2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101bd9:	e8 82 ff ff ff       	call   c0101b60 <serial_putc_sub>
        serial_putc_sub(' ');
c0101bde:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101be5:	e8 76 ff ff ff       	call   c0101b60 <serial_putc_sub>
        serial_putc_sub('\b');
c0101bea:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101bf1:	e8 6a ff ff ff       	call   c0101b60 <serial_putc_sub>
    }
}
c0101bf6:	c9                   	leave  
c0101bf7:	c3                   	ret    

c0101bf8 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101bf8:	55                   	push   %ebp
c0101bf9:	89 e5                	mov    %esp,%ebp
c0101bfb:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101bfe:	eb 33                	jmp    c0101c33 <cons_intr+0x3b>
        if (c != 0) {
c0101c00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c04:	74 2d                	je     c0101c33 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101c06:	a1 44 47 12 c0       	mov    0xc0124744,%eax
c0101c0b:	8d 50 01             	lea    0x1(%eax),%edx
c0101c0e:	89 15 44 47 12 c0    	mov    %edx,0xc0124744
c0101c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101c17:	88 90 40 45 12 c0    	mov    %dl,-0x3fedbac0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101c1d:	a1 44 47 12 c0       	mov    0xc0124744,%eax
c0101c22:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101c27:	75 0a                	jne    c0101c33 <cons_intr+0x3b>
                cons.wpos = 0;
c0101c29:	c7 05 44 47 12 c0 00 	movl   $0x0,0xc0124744
c0101c30:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101c33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c36:	ff d0                	call   *%eax
c0101c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c3b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101c3f:	75 bf                	jne    c0101c00 <cons_intr+0x8>
            }
        }
    }
}
c0101c41:	c9                   	leave  
c0101c42:	c3                   	ret    

c0101c43 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101c43:	55                   	push   %ebp
c0101c44:	89 e5                	mov    %esp,%ebp
c0101c46:	83 ec 10             	sub    $0x10,%esp
c0101c49:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c4f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101c53:	89 c2                	mov    %eax,%edx
c0101c55:	ec                   	in     (%dx),%al
c0101c56:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101c59:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101c5d:	0f b6 c0             	movzbl %al,%eax
c0101c60:	83 e0 01             	and    $0x1,%eax
c0101c63:	85 c0                	test   %eax,%eax
c0101c65:	75 07                	jne    c0101c6e <serial_proc_data+0x2b>
        return -1;
c0101c67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101c6c:	eb 2a                	jmp    c0101c98 <serial_proc_data+0x55>
c0101c6e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c74:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101c78:	89 c2                	mov    %eax,%edx
c0101c7a:	ec                   	in     (%dx),%al
c0101c7b:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101c7e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101c82:	0f b6 c0             	movzbl %al,%eax
c0101c85:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101c88:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101c8c:	75 07                	jne    c0101c95 <serial_proc_data+0x52>
        c = '\b';
c0101c8e:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101c98:	c9                   	leave  
c0101c99:	c3                   	ret    

c0101c9a <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101c9a:	55                   	push   %ebp
c0101c9b:	89 e5                	mov    %esp,%ebp
c0101c9d:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101ca0:	a1 28 45 12 c0       	mov    0xc0124528,%eax
c0101ca5:	85 c0                	test   %eax,%eax
c0101ca7:	74 0c                	je     c0101cb5 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101ca9:	c7 04 24 43 1c 10 c0 	movl   $0xc0101c43,(%esp)
c0101cb0:	e8 43 ff ff ff       	call   c0101bf8 <cons_intr>
    }
}
c0101cb5:	c9                   	leave  
c0101cb6:	c3                   	ret    

c0101cb7 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101cb7:	55                   	push   %ebp
c0101cb8:	89 e5                	mov    %esp,%ebp
c0101cba:	83 ec 38             	sub    $0x38,%esp
c0101cbd:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101cc3:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101cc7:	89 c2                	mov    %eax,%edx
c0101cc9:	ec                   	in     (%dx),%al
c0101cca:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101ccd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101cd1:	0f b6 c0             	movzbl %al,%eax
c0101cd4:	83 e0 01             	and    $0x1,%eax
c0101cd7:	85 c0                	test   %eax,%eax
c0101cd9:	75 0a                	jne    c0101ce5 <kbd_proc_data+0x2e>
        return -1;
c0101cdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101ce0:	e9 59 01 00 00       	jmp    c0101e3e <kbd_proc_data+0x187>
c0101ce5:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101ceb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101cef:	89 c2                	mov    %eax,%edx
c0101cf1:	ec                   	in     (%dx),%al
c0101cf2:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101cf5:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101cf9:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101cfc:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101d00:	75 17                	jne    c0101d19 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101d02:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d07:	83 c8 40             	or     $0x40,%eax
c0101d0a:	a3 48 47 12 c0       	mov    %eax,0xc0124748
        return 0;
c0101d0f:	b8 00 00 00 00       	mov    $0x0,%eax
c0101d14:	e9 25 01 00 00       	jmp    c0101e3e <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101d19:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d1d:	84 c0                	test   %al,%al
c0101d1f:	79 47                	jns    c0101d68 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101d21:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d26:	83 e0 40             	and    $0x40,%eax
c0101d29:	85 c0                	test   %eax,%eax
c0101d2b:	75 09                	jne    c0101d36 <kbd_proc_data+0x7f>
c0101d2d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d31:	83 e0 7f             	and    $0x7f,%eax
c0101d34:	eb 04                	jmp    c0101d3a <kbd_proc_data+0x83>
c0101d36:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d3a:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101d3d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d41:	0f b6 80 40 10 12 c0 	movzbl -0x3fedefc0(%eax),%eax
c0101d48:	83 c8 40             	or     $0x40,%eax
c0101d4b:	0f b6 c0             	movzbl %al,%eax
c0101d4e:	f7 d0                	not    %eax
c0101d50:	89 c2                	mov    %eax,%edx
c0101d52:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d57:	21 d0                	and    %edx,%eax
c0101d59:	a3 48 47 12 c0       	mov    %eax,0xc0124748
        return 0;
c0101d5e:	b8 00 00 00 00       	mov    $0x0,%eax
c0101d63:	e9 d6 00 00 00       	jmp    c0101e3e <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c0101d68:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d6d:	83 e0 40             	and    $0x40,%eax
c0101d70:	85 c0                	test   %eax,%eax
c0101d72:	74 11                	je     c0101d85 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101d74:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101d78:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d7d:	83 e0 bf             	and    $0xffffffbf,%eax
c0101d80:	a3 48 47 12 c0       	mov    %eax,0xc0124748
    }

    shift |= shiftcode[data];
c0101d85:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d89:	0f b6 80 40 10 12 c0 	movzbl -0x3fedefc0(%eax),%eax
c0101d90:	0f b6 d0             	movzbl %al,%edx
c0101d93:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d98:	09 d0                	or     %edx,%eax
c0101d9a:	a3 48 47 12 c0       	mov    %eax,0xc0124748
    shift ^= togglecode[data];
c0101d9f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101da3:	0f b6 80 40 11 12 c0 	movzbl -0x3fedeec0(%eax),%eax
c0101daa:	0f b6 d0             	movzbl %al,%edx
c0101dad:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101db2:	31 d0                	xor    %edx,%eax
c0101db4:	a3 48 47 12 c0       	mov    %eax,0xc0124748

    c = charcode[shift & (CTL | SHIFT)][data];
c0101db9:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101dbe:	83 e0 03             	and    $0x3,%eax
c0101dc1:	8b 14 85 40 15 12 c0 	mov    -0x3fedeac0(,%eax,4),%edx
c0101dc8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101dcc:	01 d0                	add    %edx,%eax
c0101dce:	0f b6 00             	movzbl (%eax),%eax
c0101dd1:	0f b6 c0             	movzbl %al,%eax
c0101dd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101dd7:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101ddc:	83 e0 08             	and    $0x8,%eax
c0101ddf:	85 c0                	test   %eax,%eax
c0101de1:	74 22                	je     c0101e05 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101de3:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101de7:	7e 0c                	jle    c0101df5 <kbd_proc_data+0x13e>
c0101de9:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101ded:	7f 06                	jg     c0101df5 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101def:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101df3:	eb 10                	jmp    c0101e05 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101df5:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101df9:	7e 0a                	jle    c0101e05 <kbd_proc_data+0x14e>
c0101dfb:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101dff:	7f 04                	jg     c0101e05 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101e01:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101e05:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101e0a:	f7 d0                	not    %eax
c0101e0c:	83 e0 06             	and    $0x6,%eax
c0101e0f:	85 c0                	test   %eax,%eax
c0101e11:	75 28                	jne    c0101e3b <kbd_proc_data+0x184>
c0101e13:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101e1a:	75 1f                	jne    c0101e3b <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101e1c:	c7 04 24 41 97 10 c0 	movl   $0xc0109741,(%esp)
c0101e23:	e8 79 e4 ff ff       	call   c01002a1 <cprintf>
c0101e28:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101e2e:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101e32:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101e36:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101e3a:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101e3e:	c9                   	leave  
c0101e3f:	c3                   	ret    

c0101e40 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101e40:	55                   	push   %ebp
c0101e41:	89 e5                	mov    %esp,%ebp
c0101e43:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101e46:	c7 04 24 b7 1c 10 c0 	movl   $0xc0101cb7,(%esp)
c0101e4d:	e8 a6 fd ff ff       	call   c0101bf8 <cons_intr>
}
c0101e52:	c9                   	leave  
c0101e53:	c3                   	ret    

c0101e54 <kbd_init>:

static void
kbd_init(void) {
c0101e54:	55                   	push   %ebp
c0101e55:	89 e5                	mov    %esp,%ebp
c0101e57:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101e5a:	e8 e1 ff ff ff       	call   c0101e40 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101e5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101e66:	e8 31 01 00 00       	call   c0101f9c <pic_enable>
}
c0101e6b:	c9                   	leave  
c0101e6c:	c3                   	ret    

c0101e6d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101e6d:	55                   	push   %ebp
c0101e6e:	89 e5                	mov    %esp,%ebp
c0101e70:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101e73:	e8 93 f8 ff ff       	call   c010170b <cga_init>
    serial_init();
c0101e78:	e8 74 f9 ff ff       	call   c01017f1 <serial_init>
    kbd_init();
c0101e7d:	e8 d2 ff ff ff       	call   c0101e54 <kbd_init>
    if (!serial_exists) {
c0101e82:	a1 28 45 12 c0       	mov    0xc0124528,%eax
c0101e87:	85 c0                	test   %eax,%eax
c0101e89:	75 0c                	jne    c0101e97 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101e8b:	c7 04 24 4d 97 10 c0 	movl   $0xc010974d,(%esp)
c0101e92:	e8 0a e4 ff ff       	call   c01002a1 <cprintf>
    }
}
c0101e97:	c9                   	leave  
c0101e98:	c3                   	ret    

c0101e99 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101e99:	55                   	push   %ebp
c0101e9a:	89 e5                	mov    %esp,%ebp
c0101e9c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101e9f:	e8 e2 f7 ff ff       	call   c0101686 <__intr_save>
c0101ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101ea7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eaa:	89 04 24             	mov    %eax,(%esp)
c0101ead:	e8 9b fa ff ff       	call   c010194d <lpt_putc>
        cga_putc(c);
c0101eb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb5:	89 04 24             	mov    %eax,(%esp)
c0101eb8:	e8 cf fa ff ff       	call   c010198c <cga_putc>
        serial_putc(c);
c0101ebd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec0:	89 04 24             	mov    %eax,(%esp)
c0101ec3:	e8 f1 fc ff ff       	call   c0101bb9 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ecb:	89 04 24             	mov    %eax,(%esp)
c0101ece:	e8 dd f7 ff ff       	call   c01016b0 <__intr_restore>
}
c0101ed3:	c9                   	leave  
c0101ed4:	c3                   	ret    

c0101ed5 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101ed5:	55                   	push   %ebp
c0101ed6:	89 e5                	mov    %esp,%ebp
c0101ed8:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101edb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101ee2:	e8 9f f7 ff ff       	call   c0101686 <__intr_save>
c0101ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101eea:	e8 ab fd ff ff       	call   c0101c9a <serial_intr>
        kbd_intr();
c0101eef:	e8 4c ff ff ff       	call   c0101e40 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101ef4:	8b 15 40 47 12 c0    	mov    0xc0124740,%edx
c0101efa:	a1 44 47 12 c0       	mov    0xc0124744,%eax
c0101eff:	39 c2                	cmp    %eax,%edx
c0101f01:	74 31                	je     c0101f34 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101f03:	a1 40 47 12 c0       	mov    0xc0124740,%eax
c0101f08:	8d 50 01             	lea    0x1(%eax),%edx
c0101f0b:	89 15 40 47 12 c0    	mov    %edx,0xc0124740
c0101f11:	0f b6 80 40 45 12 c0 	movzbl -0x3fedbac0(%eax),%eax
c0101f18:	0f b6 c0             	movzbl %al,%eax
c0101f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101f1e:	a1 40 47 12 c0       	mov    0xc0124740,%eax
c0101f23:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101f28:	75 0a                	jne    c0101f34 <cons_getc+0x5f>
                cons.rpos = 0;
c0101f2a:	c7 05 40 47 12 c0 00 	movl   $0x0,0xc0124740
c0101f31:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f37:	89 04 24             	mov    %eax,(%esp)
c0101f3a:	e8 71 f7 ff ff       	call   c01016b0 <__intr_restore>
    return c;
c0101f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f42:	c9                   	leave  
c0101f43:	c3                   	ret    

c0101f44 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f44:	55                   	push   %ebp
c0101f45:	89 e5                	mov    %esp,%ebp
c0101f47:	83 ec 14             	sub    $0x14,%esp
c0101f4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f4d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f51:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f55:	66 a3 50 15 12 c0    	mov    %ax,0xc0121550
    if (did_init) {
c0101f5b:	a1 4c 47 12 c0       	mov    0xc012474c,%eax
c0101f60:	85 c0                	test   %eax,%eax
c0101f62:	74 36                	je     c0101f9a <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f64:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f68:	0f b6 c0             	movzbl %al,%eax
c0101f6b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f71:	88 45 fd             	mov    %al,-0x3(%ebp)
c0101f74:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f78:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f7c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f7d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f81:	66 c1 e8 08          	shr    $0x8,%ax
c0101f85:	0f b6 c0             	movzbl %al,%eax
c0101f88:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f8e:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f91:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f95:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f99:	ee                   	out    %al,(%dx)
    }
}
c0101f9a:	c9                   	leave  
c0101f9b:	c3                   	ret    

c0101f9c <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f9c:	55                   	push   %ebp
c0101f9d:	89 e5                	mov    %esp,%ebp
c0101f9f:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101fa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fa5:	ba 01 00 00 00       	mov    $0x1,%edx
c0101faa:	89 c1                	mov    %eax,%ecx
c0101fac:	d3 e2                	shl    %cl,%edx
c0101fae:	89 d0                	mov    %edx,%eax
c0101fb0:	f7 d0                	not    %eax
c0101fb2:	89 c2                	mov    %eax,%edx
c0101fb4:	0f b7 05 50 15 12 c0 	movzwl 0xc0121550,%eax
c0101fbb:	21 d0                	and    %edx,%eax
c0101fbd:	0f b7 c0             	movzwl %ax,%eax
c0101fc0:	89 04 24             	mov    %eax,(%esp)
c0101fc3:	e8 7c ff ff ff       	call   c0101f44 <pic_setmask>
}
c0101fc8:	c9                   	leave  
c0101fc9:	c3                   	ret    

c0101fca <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fca:	55                   	push   %ebp
c0101fcb:	89 e5                	mov    %esp,%ebp
c0101fcd:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fd0:	c7 05 4c 47 12 c0 01 	movl   $0x1,0xc012474c
c0101fd7:	00 00 00 
c0101fda:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fe0:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fe4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fe8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fec:	ee                   	out    %al,(%dx)
c0101fed:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101ff3:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101ff7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101ffb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fff:	ee                   	out    %al,(%dx)
c0102000:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0102006:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010200a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010200e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102012:	ee                   	out    %al,(%dx)
c0102013:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102019:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010201d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102021:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102025:	ee                   	out    %al,(%dx)
c0102026:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010202c:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0102030:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102034:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102038:	ee                   	out    %al,(%dx)
c0102039:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010203f:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102043:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102047:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010204b:	ee                   	out    %al,(%dx)
c010204c:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102052:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102056:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010205a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010205e:	ee                   	out    %al,(%dx)
c010205f:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102065:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102069:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010206d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102071:	ee                   	out    %al,(%dx)
c0102072:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102078:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010207c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102080:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102084:	ee                   	out    %al,(%dx)
c0102085:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010208b:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010208f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102093:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102097:	ee                   	out    %al,(%dx)
c0102098:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010209e:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c01020a2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01020a6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01020aa:	ee                   	out    %al,(%dx)
c01020ab:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020b1:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020b5:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020b9:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020bd:	ee                   	out    %al,(%dx)
c01020be:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020c4:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020c8:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020cc:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020d0:	ee                   	out    %al,(%dx)
c01020d1:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020d7:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020db:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020df:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020e3:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020e4:	0f b7 05 50 15 12 c0 	movzwl 0xc0121550,%eax
c01020eb:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020ef:	74 12                	je     c0102103 <pic_init+0x139>
        pic_setmask(irq_mask);
c01020f1:	0f b7 05 50 15 12 c0 	movzwl 0xc0121550,%eax
c01020f8:	0f b7 c0             	movzwl %ax,%eax
c01020fb:	89 04 24             	mov    %eax,(%esp)
c01020fe:	e8 41 fe ff ff       	call   c0101f44 <pic_setmask>
    }
}
c0102103:	c9                   	leave  
c0102104:	c3                   	ret    

c0102105 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0102105:	55                   	push   %ebp
c0102106:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0102108:	fb                   	sti    
    sti();
}
c0102109:	5d                   	pop    %ebp
c010210a:	c3                   	ret    

c010210b <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010210b:	55                   	push   %ebp
c010210c:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010210e:	fa                   	cli    
    cli();
}
c010210f:	5d                   	pop    %ebp
c0102110:	c3                   	ret    

c0102111 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0102111:	55                   	push   %ebp
c0102112:	89 e5                	mov    %esp,%ebp
c0102114:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102117:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010211e:	00 
c010211f:	c7 04 24 80 97 10 c0 	movl   $0xc0109780,(%esp)
c0102126:	e8 76 e1 ff ff       	call   c01002a1 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010212b:	c9                   	leave  
c010212c:	c3                   	ret    

c010212d <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010212d:	55                   	push   %ebp
c010212e:	89 e5                	mov    %esp,%ebp
c0102130:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0102133:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010213a:	e9 c3 00 00 00       	jmp    c0102202 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010213f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102142:	8b 04 85 e0 15 12 c0 	mov    -0x3fedea20(,%eax,4),%eax
c0102149:	89 c2                	mov    %eax,%edx
c010214b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010214e:	66 89 14 c5 60 47 12 	mov    %dx,-0x3fedb8a0(,%eax,8)
c0102155:	c0 
c0102156:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102159:	66 c7 04 c5 62 47 12 	movw   $0x8,-0x3fedb89e(,%eax,8)
c0102160:	c0 08 00 
c0102163:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102166:	0f b6 14 c5 64 47 12 	movzbl -0x3fedb89c(,%eax,8),%edx
c010216d:	c0 
c010216e:	83 e2 e0             	and    $0xffffffe0,%edx
c0102171:	88 14 c5 64 47 12 c0 	mov    %dl,-0x3fedb89c(,%eax,8)
c0102178:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010217b:	0f b6 14 c5 64 47 12 	movzbl -0x3fedb89c(,%eax,8),%edx
c0102182:	c0 
c0102183:	83 e2 1f             	and    $0x1f,%edx
c0102186:	88 14 c5 64 47 12 c0 	mov    %dl,-0x3fedb89c(,%eax,8)
c010218d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102190:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c0102197:	c0 
c0102198:	83 e2 f0             	and    $0xfffffff0,%edx
c010219b:	83 ca 0e             	or     $0xe,%edx
c010219e:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c01021a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a8:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c01021af:	c0 
c01021b0:	83 e2 ef             	and    $0xffffffef,%edx
c01021b3:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c01021ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021bd:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c01021c4:	c0 
c01021c5:	83 e2 9f             	and    $0xffffff9f,%edx
c01021c8:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c01021cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d2:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c01021d9:	c0 
c01021da:	83 ca 80             	or     $0xffffff80,%edx
c01021dd:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c01021e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e7:	8b 04 85 e0 15 12 c0 	mov    -0x3fedea20(,%eax,4),%eax
c01021ee:	c1 e8 10             	shr    $0x10,%eax
c01021f1:	89 c2                	mov    %eax,%edx
c01021f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021f6:	66 89 14 c5 66 47 12 	mov    %dx,-0x3fedb89a(,%eax,8)
c01021fd:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01021fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102202:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102205:	3d ff 00 00 00       	cmp    $0xff,%eax
c010220a:	0f 86 2f ff ff ff    	jbe    c010213f <idt_init+0x12>
c0102210:	c7 45 f8 60 15 12 c0 	movl   $0xc0121560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102217:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010221a:	0f 01 18             	lidtl  (%eax)
    }
    lidt(&idt_pd);
}
c010221d:	c9                   	leave  
c010221e:	c3                   	ret    

c010221f <trapname>:

static const char *
trapname(int trapno) {
c010221f:	55                   	push   %ebp
c0102220:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102222:	8b 45 08             	mov    0x8(%ebp),%eax
c0102225:	83 f8 13             	cmp    $0x13,%eax
c0102228:	77 0c                	ja     c0102236 <trapname+0x17>
        return excnames[trapno];
c010222a:	8b 45 08             	mov    0x8(%ebp),%eax
c010222d:	8b 04 85 60 9b 10 c0 	mov    -0x3fef64a0(,%eax,4),%eax
c0102234:	eb 18                	jmp    c010224e <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102236:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010223a:	7e 0d                	jle    c0102249 <trapname+0x2a>
c010223c:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102240:	7f 07                	jg     c0102249 <trapname+0x2a>
        return "Hardware Interrupt";
c0102242:	b8 8a 97 10 c0       	mov    $0xc010978a,%eax
c0102247:	eb 05                	jmp    c010224e <trapname+0x2f>
    }
    return "(unknown trap)";
c0102249:	b8 9d 97 10 c0       	mov    $0xc010979d,%eax
}
c010224e:	5d                   	pop    %ebp
c010224f:	c3                   	ret    

c0102250 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0102250:	55                   	push   %ebp
c0102251:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0102253:	8b 45 08             	mov    0x8(%ebp),%eax
c0102256:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010225a:	66 83 f8 08          	cmp    $0x8,%ax
c010225e:	0f 94 c0             	sete   %al
c0102261:	0f b6 c0             	movzbl %al,%eax
}
c0102264:	5d                   	pop    %ebp
c0102265:	c3                   	ret    

c0102266 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102266:	55                   	push   %ebp
c0102267:	89 e5                	mov    %esp,%ebp
c0102269:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c010226c:	8b 45 08             	mov    0x8(%ebp),%eax
c010226f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102273:	c7 04 24 de 97 10 c0 	movl   $0xc01097de,(%esp)
c010227a:	e8 22 e0 ff ff       	call   c01002a1 <cprintf>
    print_regs(&tf->tf_regs);
c010227f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102282:	89 04 24             	mov    %eax,(%esp)
c0102285:	e8 a1 01 00 00       	call   c010242b <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c010228a:	8b 45 08             	mov    0x8(%ebp),%eax
c010228d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102291:	0f b7 c0             	movzwl %ax,%eax
c0102294:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102298:	c7 04 24 ef 97 10 c0 	movl   $0xc01097ef,(%esp)
c010229f:	e8 fd df ff ff       	call   c01002a1 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01022a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01022a7:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01022ab:	0f b7 c0             	movzwl %ax,%eax
c01022ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022b2:	c7 04 24 02 98 10 c0 	movl   $0xc0109802,(%esp)
c01022b9:	e8 e3 df ff ff       	call   c01002a1 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01022be:	8b 45 08             	mov    0x8(%ebp),%eax
c01022c1:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01022c5:	0f b7 c0             	movzwl %ax,%eax
c01022c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022cc:	c7 04 24 15 98 10 c0 	movl   $0xc0109815,(%esp)
c01022d3:	e8 c9 df ff ff       	call   c01002a1 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c01022d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01022db:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c01022df:	0f b7 c0             	movzwl %ax,%eax
c01022e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022e6:	c7 04 24 28 98 10 c0 	movl   $0xc0109828,(%esp)
c01022ed:	e8 af df ff ff       	call   c01002a1 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c01022f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01022f5:	8b 40 30             	mov    0x30(%eax),%eax
c01022f8:	89 04 24             	mov    %eax,(%esp)
c01022fb:	e8 1f ff ff ff       	call   c010221f <trapname>
c0102300:	8b 55 08             	mov    0x8(%ebp),%edx
c0102303:	8b 52 30             	mov    0x30(%edx),%edx
c0102306:	89 44 24 08          	mov    %eax,0x8(%esp)
c010230a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010230e:	c7 04 24 3b 98 10 c0 	movl   $0xc010983b,(%esp)
c0102315:	e8 87 df ff ff       	call   c01002a1 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c010231a:	8b 45 08             	mov    0x8(%ebp),%eax
c010231d:	8b 40 34             	mov    0x34(%eax),%eax
c0102320:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102324:	c7 04 24 4d 98 10 c0 	movl   $0xc010984d,(%esp)
c010232b:	e8 71 df ff ff       	call   c01002a1 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102330:	8b 45 08             	mov    0x8(%ebp),%eax
c0102333:	8b 40 38             	mov    0x38(%eax),%eax
c0102336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010233a:	c7 04 24 5c 98 10 c0 	movl   $0xc010985c,(%esp)
c0102341:	e8 5b df ff ff       	call   c01002a1 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102346:	8b 45 08             	mov    0x8(%ebp),%eax
c0102349:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010234d:	0f b7 c0             	movzwl %ax,%eax
c0102350:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102354:	c7 04 24 6b 98 10 c0 	movl   $0xc010986b,(%esp)
c010235b:	e8 41 df ff ff       	call   c01002a1 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0102360:	8b 45 08             	mov    0x8(%ebp),%eax
c0102363:	8b 40 40             	mov    0x40(%eax),%eax
c0102366:	89 44 24 04          	mov    %eax,0x4(%esp)
c010236a:	c7 04 24 7e 98 10 c0 	movl   $0xc010987e,(%esp)
c0102371:	e8 2b df ff ff       	call   c01002a1 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102376:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010237d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102384:	eb 3e                	jmp    c01023c4 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102386:	8b 45 08             	mov    0x8(%ebp),%eax
c0102389:	8b 50 40             	mov    0x40(%eax),%edx
c010238c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010238f:	21 d0                	and    %edx,%eax
c0102391:	85 c0                	test   %eax,%eax
c0102393:	74 28                	je     c01023bd <print_trapframe+0x157>
c0102395:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102398:	8b 04 85 80 15 12 c0 	mov    -0x3fedea80(,%eax,4),%eax
c010239f:	85 c0                	test   %eax,%eax
c01023a1:	74 1a                	je     c01023bd <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023a6:	8b 04 85 80 15 12 c0 	mov    -0x3fedea80(,%eax,4),%eax
c01023ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023b1:	c7 04 24 8d 98 10 c0 	movl   $0xc010988d,(%esp)
c01023b8:	e8 e4 de ff ff       	call   c01002a1 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01023c1:	d1 65 f0             	shll   -0x10(%ebp)
c01023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023c7:	83 f8 17             	cmp    $0x17,%eax
c01023ca:	76 ba                	jbe    c0102386 <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01023cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01023cf:	8b 40 40             	mov    0x40(%eax),%eax
c01023d2:	25 00 30 00 00       	and    $0x3000,%eax
c01023d7:	c1 e8 0c             	shr    $0xc,%eax
c01023da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023de:	c7 04 24 91 98 10 c0 	movl   $0xc0109891,(%esp)
c01023e5:	e8 b7 de ff ff       	call   c01002a1 <cprintf>

    if (!trap_in_kernel(tf)) {
c01023ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ed:	89 04 24             	mov    %eax,(%esp)
c01023f0:	e8 5b fe ff ff       	call   c0102250 <trap_in_kernel>
c01023f5:	85 c0                	test   %eax,%eax
c01023f7:	75 30                	jne    c0102429 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c01023f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01023fc:	8b 40 44             	mov    0x44(%eax),%eax
c01023ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102403:	c7 04 24 9a 98 10 c0 	movl   $0xc010989a,(%esp)
c010240a:	e8 92 de ff ff       	call   c01002a1 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010240f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102412:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102416:	0f b7 c0             	movzwl %ax,%eax
c0102419:	89 44 24 04          	mov    %eax,0x4(%esp)
c010241d:	c7 04 24 a9 98 10 c0 	movl   $0xc01098a9,(%esp)
c0102424:	e8 78 de ff ff       	call   c01002a1 <cprintf>
    }
}
c0102429:	c9                   	leave  
c010242a:	c3                   	ret    

c010242b <print_regs>:

void
print_regs(struct pushregs *regs) {
c010242b:	55                   	push   %ebp
c010242c:	89 e5                	mov    %esp,%ebp
c010242e:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102431:	8b 45 08             	mov    0x8(%ebp),%eax
c0102434:	8b 00                	mov    (%eax),%eax
c0102436:	89 44 24 04          	mov    %eax,0x4(%esp)
c010243a:	c7 04 24 bc 98 10 c0 	movl   $0xc01098bc,(%esp)
c0102441:	e8 5b de ff ff       	call   c01002a1 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102446:	8b 45 08             	mov    0x8(%ebp),%eax
c0102449:	8b 40 04             	mov    0x4(%eax),%eax
c010244c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102450:	c7 04 24 cb 98 10 c0 	movl   $0xc01098cb,(%esp)
c0102457:	e8 45 de ff ff       	call   c01002a1 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c010245c:	8b 45 08             	mov    0x8(%ebp),%eax
c010245f:	8b 40 08             	mov    0x8(%eax),%eax
c0102462:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102466:	c7 04 24 da 98 10 c0 	movl   $0xc01098da,(%esp)
c010246d:	e8 2f de ff ff       	call   c01002a1 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102472:	8b 45 08             	mov    0x8(%ebp),%eax
c0102475:	8b 40 0c             	mov    0xc(%eax),%eax
c0102478:	89 44 24 04          	mov    %eax,0x4(%esp)
c010247c:	c7 04 24 e9 98 10 c0 	movl   $0xc01098e9,(%esp)
c0102483:	e8 19 de ff ff       	call   c01002a1 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102488:	8b 45 08             	mov    0x8(%ebp),%eax
c010248b:	8b 40 10             	mov    0x10(%eax),%eax
c010248e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102492:	c7 04 24 f8 98 10 c0 	movl   $0xc01098f8,(%esp)
c0102499:	e8 03 de ff ff       	call   c01002a1 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c010249e:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a1:	8b 40 14             	mov    0x14(%eax),%eax
c01024a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a8:	c7 04 24 07 99 10 c0 	movl   $0xc0109907,(%esp)
c01024af:	e8 ed dd ff ff       	call   c01002a1 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01024b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b7:	8b 40 18             	mov    0x18(%eax),%eax
c01024ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024be:	c7 04 24 16 99 10 c0 	movl   $0xc0109916,(%esp)
c01024c5:	e8 d7 dd ff ff       	call   c01002a1 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c01024ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01024cd:	8b 40 1c             	mov    0x1c(%eax),%eax
c01024d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024d4:	c7 04 24 25 99 10 c0 	movl   $0xc0109925,(%esp)
c01024db:	e8 c1 dd ff ff       	call   c01002a1 <cprintf>
}
c01024e0:	c9                   	leave  
c01024e1:	c3                   	ret    

c01024e2 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c01024e2:	55                   	push   %ebp
c01024e3:	89 e5                	mov    %esp,%ebp
c01024e5:	53                   	push   %ebx
c01024e6:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c01024e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ec:	8b 40 34             	mov    0x34(%eax),%eax
c01024ef:	83 e0 01             	and    $0x1,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01024f2:	85 c0                	test   %eax,%eax
c01024f4:	74 07                	je     c01024fd <print_pgfault+0x1b>
c01024f6:	b9 34 99 10 c0       	mov    $0xc0109934,%ecx
c01024fb:	eb 05                	jmp    c0102502 <print_pgfault+0x20>
c01024fd:	b9 45 99 10 c0       	mov    $0xc0109945,%ecx
            (tf->tf_err & 2) ? 'W' : 'R',
c0102502:	8b 45 08             	mov    0x8(%ebp),%eax
c0102505:	8b 40 34             	mov    0x34(%eax),%eax
c0102508:	83 e0 02             	and    $0x2,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010250b:	85 c0                	test   %eax,%eax
c010250d:	74 07                	je     c0102516 <print_pgfault+0x34>
c010250f:	ba 57 00 00 00       	mov    $0x57,%edx
c0102514:	eb 05                	jmp    c010251b <print_pgfault+0x39>
c0102516:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c010251b:	8b 45 08             	mov    0x8(%ebp),%eax
c010251e:	8b 40 34             	mov    0x34(%eax),%eax
c0102521:	83 e0 04             	and    $0x4,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102524:	85 c0                	test   %eax,%eax
c0102526:	74 07                	je     c010252f <print_pgfault+0x4d>
c0102528:	b8 55 00 00 00       	mov    $0x55,%eax
c010252d:	eb 05                	jmp    c0102534 <print_pgfault+0x52>
c010252f:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102534:	0f 20 d3             	mov    %cr2,%ebx
c0102537:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c010253a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c010253d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0102541:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102545:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102549:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010254d:	c7 04 24 54 99 10 c0 	movl   $0xc0109954,(%esp)
c0102554:	e8 48 dd ff ff       	call   c01002a1 <cprintf>
}
c0102559:	83 c4 34             	add    $0x34,%esp
c010255c:	5b                   	pop    %ebx
c010255d:	5d                   	pop    %ebp
c010255e:	c3                   	ret    

c010255f <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c010255f:	55                   	push   %ebp
c0102560:	89 e5                	mov    %esp,%ebp
c0102562:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c0102565:	8b 45 08             	mov    0x8(%ebp),%eax
c0102568:	89 04 24             	mov    %eax,(%esp)
c010256b:	e8 72 ff ff ff       	call   c01024e2 <print_pgfault>
    if (check_mm_struct != NULL) {
c0102570:	a1 1c 50 12 c0       	mov    0xc012501c,%eax
c0102575:	85 c0                	test   %eax,%eax
c0102577:	74 28                	je     c01025a1 <pgfault_handler+0x42>
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102579:	0f 20 d0             	mov    %cr2,%eax
c010257c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c010257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c0102582:	89 c1                	mov    %eax,%ecx
c0102584:	8b 45 08             	mov    0x8(%ebp),%eax
c0102587:	8b 50 34             	mov    0x34(%eax),%edx
c010258a:	a1 1c 50 12 c0       	mov    0xc012501c,%eax
c010258f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0102593:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102597:	89 04 24             	mov    %eax,(%esp)
c010259a:	e8 9c 1e 00 00       	call   c010443b <do_pgfault>
c010259f:	eb 1c                	jmp    c01025bd <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c01025a1:	c7 44 24 08 77 99 10 	movl   $0xc0109977,0x8(%esp)
c01025a8:	c0 
c01025a9:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c01025b0:	00 
c01025b1:	c7 04 24 8e 99 10 c0 	movl   $0xc010998e,(%esp)
c01025b8:	e8 3b de ff ff       	call   c01003f8 <__panic>
}
c01025bd:	c9                   	leave  
c01025be:	c3                   	ret    

c01025bf <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01025bf:	55                   	push   %ebp
c01025c0:	89 e5                	mov    %esp,%ebp
c01025c2:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c01025c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01025c8:	8b 40 30             	mov    0x30(%eax),%eax
c01025cb:	83 f8 24             	cmp    $0x24,%eax
c01025ce:	0f 84 c2 00 00 00    	je     c0102696 <trap_dispatch+0xd7>
c01025d4:	83 f8 24             	cmp    $0x24,%eax
c01025d7:	77 18                	ja     c01025f1 <trap_dispatch+0x32>
c01025d9:	83 f8 20             	cmp    $0x20,%eax
c01025dc:	74 7d                	je     c010265b <trap_dispatch+0x9c>
c01025de:	83 f8 21             	cmp    $0x21,%eax
c01025e1:	0f 84 d5 00 00 00    	je     c01026bc <trap_dispatch+0xfd>
c01025e7:	83 f8 0e             	cmp    $0xe,%eax
c01025ea:	74 28                	je     c0102614 <trap_dispatch+0x55>
c01025ec:	e9 0d 01 00 00       	jmp    c01026fe <trap_dispatch+0x13f>
c01025f1:	83 f8 2e             	cmp    $0x2e,%eax
c01025f4:	0f 82 04 01 00 00    	jb     c01026fe <trap_dispatch+0x13f>
c01025fa:	83 f8 2f             	cmp    $0x2f,%eax
c01025fd:	0f 86 33 01 00 00    	jbe    c0102736 <trap_dispatch+0x177>
c0102603:	83 e8 78             	sub    $0x78,%eax
c0102606:	83 f8 01             	cmp    $0x1,%eax
c0102609:	0f 87 ef 00 00 00    	ja     c01026fe <trap_dispatch+0x13f>
c010260f:	e9 ce 00 00 00       	jmp    c01026e2 <trap_dispatch+0x123>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102614:	8b 45 08             	mov    0x8(%ebp),%eax
c0102617:	89 04 24             	mov    %eax,(%esp)
c010261a:	e8 40 ff ff ff       	call   c010255f <pgfault_handler>
c010261f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102622:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102626:	74 2e                	je     c0102656 <trap_dispatch+0x97>
            print_trapframe(tf);
c0102628:	8b 45 08             	mov    0x8(%ebp),%eax
c010262b:	89 04 24             	mov    %eax,(%esp)
c010262e:	e8 33 fc ff ff       	call   c0102266 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102633:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102636:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010263a:	c7 44 24 08 9f 99 10 	movl   $0xc010999f,0x8(%esp)
c0102641:	c0 
c0102642:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0102649:	00 
c010264a:	c7 04 24 8e 99 10 c0 	movl   $0xc010998e,(%esp)
c0102651:	e8 a2 dd ff ff       	call   c01003f8 <__panic>
        }
        break;
c0102656:	e9 dc 00 00 00       	jmp    c0102737 <trap_dispatch+0x178>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c010265b:	a1 0c 50 12 c0       	mov    0xc012500c,%eax
c0102660:	83 c0 01             	add    $0x1,%eax
c0102663:	a3 0c 50 12 c0       	mov    %eax,0xc012500c
        if (ticks % TICK_NUM == 0) {
c0102668:	8b 0d 0c 50 12 c0    	mov    0xc012500c,%ecx
c010266e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0102673:	89 c8                	mov    %ecx,%eax
c0102675:	f7 e2                	mul    %edx
c0102677:	89 d0                	mov    %edx,%eax
c0102679:	c1 e8 05             	shr    $0x5,%eax
c010267c:	6b c0 64             	imul   $0x64,%eax,%eax
c010267f:	29 c1                	sub    %eax,%ecx
c0102681:	89 c8                	mov    %ecx,%eax
c0102683:	85 c0                	test   %eax,%eax
c0102685:	75 0a                	jne    c0102691 <trap_dispatch+0xd2>
            print_ticks();
c0102687:	e8 85 fa ff ff       	call   c0102111 <print_ticks>
        }
        break;
c010268c:	e9 a6 00 00 00       	jmp    c0102737 <trap_dispatch+0x178>
c0102691:	e9 a1 00 00 00       	jmp    c0102737 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102696:	e8 3a f8 ff ff       	call   c0101ed5 <cons_getc>
c010269b:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c010269e:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026a2:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026a6:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026ae:	c7 04 24 ba 99 10 c0 	movl   $0xc01099ba,(%esp)
c01026b5:	e8 e7 db ff ff       	call   c01002a1 <cprintf>
        break;
c01026ba:	eb 7b                	jmp    c0102737 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01026bc:	e8 14 f8 ff ff       	call   c0101ed5 <cons_getc>
c01026c1:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01026c4:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026c8:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026cc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026d4:	c7 04 24 cc 99 10 c0 	movl   $0xc01099cc,(%esp)
c01026db:	e8 c1 db ff ff       	call   c01002a1 <cprintf>
        break;
c01026e0:	eb 55                	jmp    c0102737 <trap_dispatch+0x178>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c01026e2:	c7 44 24 08 db 99 10 	movl   $0xc01099db,0x8(%esp)
c01026e9:	c0 
c01026ea:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01026f1:	00 
c01026f2:	c7 04 24 8e 99 10 c0 	movl   $0xc010998e,(%esp)
c01026f9:	e8 fa dc ff ff       	call   c01003f8 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01026fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102701:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102705:	0f b7 c0             	movzwl %ax,%eax
c0102708:	83 e0 03             	and    $0x3,%eax
c010270b:	85 c0                	test   %eax,%eax
c010270d:	75 28                	jne    c0102737 <trap_dispatch+0x178>
            print_trapframe(tf);
c010270f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102712:	89 04 24             	mov    %eax,(%esp)
c0102715:	e8 4c fb ff ff       	call   c0102266 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010271a:	c7 44 24 08 eb 99 10 	movl   $0xc01099eb,0x8(%esp)
c0102721:	c0 
c0102722:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0102729:	00 
c010272a:	c7 04 24 8e 99 10 c0 	movl   $0xc010998e,(%esp)
c0102731:	e8 c2 dc ff ff       	call   c01003f8 <__panic>
        break;
c0102736:	90                   	nop
        }
    }
}
c0102737:	c9                   	leave  
c0102738:	c3                   	ret    

c0102739 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102739:	55                   	push   %ebp
c010273a:	89 e5                	mov    %esp,%ebp
c010273c:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010273f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102742:	89 04 24             	mov    %eax,(%esp)
c0102745:	e8 75 fe ff ff       	call   c01025bf <trap_dispatch>
}
c010274a:	c9                   	leave  
c010274b:	c3                   	ret    

c010274c <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c010274c:	6a 00                	push   $0x0
  pushl $0
c010274e:	6a 00                	push   $0x0
  jmp __alltraps
c0102750:	e9 67 0a 00 00       	jmp    c01031bc <__alltraps>

c0102755 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102755:	6a 00                	push   $0x0
  pushl $1
c0102757:	6a 01                	push   $0x1
  jmp __alltraps
c0102759:	e9 5e 0a 00 00       	jmp    c01031bc <__alltraps>

c010275e <vector2>:
.globl vector2
vector2:
  pushl $0
c010275e:	6a 00                	push   $0x0
  pushl $2
c0102760:	6a 02                	push   $0x2
  jmp __alltraps
c0102762:	e9 55 0a 00 00       	jmp    c01031bc <__alltraps>

c0102767 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102767:	6a 00                	push   $0x0
  pushl $3
c0102769:	6a 03                	push   $0x3
  jmp __alltraps
c010276b:	e9 4c 0a 00 00       	jmp    c01031bc <__alltraps>

c0102770 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102770:	6a 00                	push   $0x0
  pushl $4
c0102772:	6a 04                	push   $0x4
  jmp __alltraps
c0102774:	e9 43 0a 00 00       	jmp    c01031bc <__alltraps>

c0102779 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102779:	6a 00                	push   $0x0
  pushl $5
c010277b:	6a 05                	push   $0x5
  jmp __alltraps
c010277d:	e9 3a 0a 00 00       	jmp    c01031bc <__alltraps>

c0102782 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102782:	6a 00                	push   $0x0
  pushl $6
c0102784:	6a 06                	push   $0x6
  jmp __alltraps
c0102786:	e9 31 0a 00 00       	jmp    c01031bc <__alltraps>

c010278b <vector7>:
.globl vector7
vector7:
  pushl $0
c010278b:	6a 00                	push   $0x0
  pushl $7
c010278d:	6a 07                	push   $0x7
  jmp __alltraps
c010278f:	e9 28 0a 00 00       	jmp    c01031bc <__alltraps>

c0102794 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102794:	6a 08                	push   $0x8
  jmp __alltraps
c0102796:	e9 21 0a 00 00       	jmp    c01031bc <__alltraps>

c010279b <vector9>:
.globl vector9
vector9:
  pushl $9
c010279b:	6a 09                	push   $0x9
  jmp __alltraps
c010279d:	e9 1a 0a 00 00       	jmp    c01031bc <__alltraps>

c01027a2 <vector10>:
.globl vector10
vector10:
  pushl $10
c01027a2:	6a 0a                	push   $0xa
  jmp __alltraps
c01027a4:	e9 13 0a 00 00       	jmp    c01031bc <__alltraps>

c01027a9 <vector11>:
.globl vector11
vector11:
  pushl $11
c01027a9:	6a 0b                	push   $0xb
  jmp __alltraps
c01027ab:	e9 0c 0a 00 00       	jmp    c01031bc <__alltraps>

c01027b0 <vector12>:
.globl vector12
vector12:
  pushl $12
c01027b0:	6a 0c                	push   $0xc
  jmp __alltraps
c01027b2:	e9 05 0a 00 00       	jmp    c01031bc <__alltraps>

c01027b7 <vector13>:
.globl vector13
vector13:
  pushl $13
c01027b7:	6a 0d                	push   $0xd
  jmp __alltraps
c01027b9:	e9 fe 09 00 00       	jmp    c01031bc <__alltraps>

c01027be <vector14>:
.globl vector14
vector14:
  pushl $14
c01027be:	6a 0e                	push   $0xe
  jmp __alltraps
c01027c0:	e9 f7 09 00 00       	jmp    c01031bc <__alltraps>

c01027c5 <vector15>:
.globl vector15
vector15:
  pushl $0
c01027c5:	6a 00                	push   $0x0
  pushl $15
c01027c7:	6a 0f                	push   $0xf
  jmp __alltraps
c01027c9:	e9 ee 09 00 00       	jmp    c01031bc <__alltraps>

c01027ce <vector16>:
.globl vector16
vector16:
  pushl $0
c01027ce:	6a 00                	push   $0x0
  pushl $16
c01027d0:	6a 10                	push   $0x10
  jmp __alltraps
c01027d2:	e9 e5 09 00 00       	jmp    c01031bc <__alltraps>

c01027d7 <vector17>:
.globl vector17
vector17:
  pushl $17
c01027d7:	6a 11                	push   $0x11
  jmp __alltraps
c01027d9:	e9 de 09 00 00       	jmp    c01031bc <__alltraps>

c01027de <vector18>:
.globl vector18
vector18:
  pushl $0
c01027de:	6a 00                	push   $0x0
  pushl $18
c01027e0:	6a 12                	push   $0x12
  jmp __alltraps
c01027e2:	e9 d5 09 00 00       	jmp    c01031bc <__alltraps>

c01027e7 <vector19>:
.globl vector19
vector19:
  pushl $0
c01027e7:	6a 00                	push   $0x0
  pushl $19
c01027e9:	6a 13                	push   $0x13
  jmp __alltraps
c01027eb:	e9 cc 09 00 00       	jmp    c01031bc <__alltraps>

c01027f0 <vector20>:
.globl vector20
vector20:
  pushl $0
c01027f0:	6a 00                	push   $0x0
  pushl $20
c01027f2:	6a 14                	push   $0x14
  jmp __alltraps
c01027f4:	e9 c3 09 00 00       	jmp    c01031bc <__alltraps>

c01027f9 <vector21>:
.globl vector21
vector21:
  pushl $0
c01027f9:	6a 00                	push   $0x0
  pushl $21
c01027fb:	6a 15                	push   $0x15
  jmp __alltraps
c01027fd:	e9 ba 09 00 00       	jmp    c01031bc <__alltraps>

c0102802 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102802:	6a 00                	push   $0x0
  pushl $22
c0102804:	6a 16                	push   $0x16
  jmp __alltraps
c0102806:	e9 b1 09 00 00       	jmp    c01031bc <__alltraps>

c010280b <vector23>:
.globl vector23
vector23:
  pushl $0
c010280b:	6a 00                	push   $0x0
  pushl $23
c010280d:	6a 17                	push   $0x17
  jmp __alltraps
c010280f:	e9 a8 09 00 00       	jmp    c01031bc <__alltraps>

c0102814 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102814:	6a 00                	push   $0x0
  pushl $24
c0102816:	6a 18                	push   $0x18
  jmp __alltraps
c0102818:	e9 9f 09 00 00       	jmp    c01031bc <__alltraps>

c010281d <vector25>:
.globl vector25
vector25:
  pushl $0
c010281d:	6a 00                	push   $0x0
  pushl $25
c010281f:	6a 19                	push   $0x19
  jmp __alltraps
c0102821:	e9 96 09 00 00       	jmp    c01031bc <__alltraps>

c0102826 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102826:	6a 00                	push   $0x0
  pushl $26
c0102828:	6a 1a                	push   $0x1a
  jmp __alltraps
c010282a:	e9 8d 09 00 00       	jmp    c01031bc <__alltraps>

c010282f <vector27>:
.globl vector27
vector27:
  pushl $0
c010282f:	6a 00                	push   $0x0
  pushl $27
c0102831:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102833:	e9 84 09 00 00       	jmp    c01031bc <__alltraps>

c0102838 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102838:	6a 00                	push   $0x0
  pushl $28
c010283a:	6a 1c                	push   $0x1c
  jmp __alltraps
c010283c:	e9 7b 09 00 00       	jmp    c01031bc <__alltraps>

c0102841 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102841:	6a 00                	push   $0x0
  pushl $29
c0102843:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102845:	e9 72 09 00 00       	jmp    c01031bc <__alltraps>

c010284a <vector30>:
.globl vector30
vector30:
  pushl $0
c010284a:	6a 00                	push   $0x0
  pushl $30
c010284c:	6a 1e                	push   $0x1e
  jmp __alltraps
c010284e:	e9 69 09 00 00       	jmp    c01031bc <__alltraps>

c0102853 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102853:	6a 00                	push   $0x0
  pushl $31
c0102855:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102857:	e9 60 09 00 00       	jmp    c01031bc <__alltraps>

c010285c <vector32>:
.globl vector32
vector32:
  pushl $0
c010285c:	6a 00                	push   $0x0
  pushl $32
c010285e:	6a 20                	push   $0x20
  jmp __alltraps
c0102860:	e9 57 09 00 00       	jmp    c01031bc <__alltraps>

c0102865 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102865:	6a 00                	push   $0x0
  pushl $33
c0102867:	6a 21                	push   $0x21
  jmp __alltraps
c0102869:	e9 4e 09 00 00       	jmp    c01031bc <__alltraps>

c010286e <vector34>:
.globl vector34
vector34:
  pushl $0
c010286e:	6a 00                	push   $0x0
  pushl $34
c0102870:	6a 22                	push   $0x22
  jmp __alltraps
c0102872:	e9 45 09 00 00       	jmp    c01031bc <__alltraps>

c0102877 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102877:	6a 00                	push   $0x0
  pushl $35
c0102879:	6a 23                	push   $0x23
  jmp __alltraps
c010287b:	e9 3c 09 00 00       	jmp    c01031bc <__alltraps>

c0102880 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102880:	6a 00                	push   $0x0
  pushl $36
c0102882:	6a 24                	push   $0x24
  jmp __alltraps
c0102884:	e9 33 09 00 00       	jmp    c01031bc <__alltraps>

c0102889 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102889:	6a 00                	push   $0x0
  pushl $37
c010288b:	6a 25                	push   $0x25
  jmp __alltraps
c010288d:	e9 2a 09 00 00       	jmp    c01031bc <__alltraps>

c0102892 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102892:	6a 00                	push   $0x0
  pushl $38
c0102894:	6a 26                	push   $0x26
  jmp __alltraps
c0102896:	e9 21 09 00 00       	jmp    c01031bc <__alltraps>

c010289b <vector39>:
.globl vector39
vector39:
  pushl $0
c010289b:	6a 00                	push   $0x0
  pushl $39
c010289d:	6a 27                	push   $0x27
  jmp __alltraps
c010289f:	e9 18 09 00 00       	jmp    c01031bc <__alltraps>

c01028a4 <vector40>:
.globl vector40
vector40:
  pushl $0
c01028a4:	6a 00                	push   $0x0
  pushl $40
c01028a6:	6a 28                	push   $0x28
  jmp __alltraps
c01028a8:	e9 0f 09 00 00       	jmp    c01031bc <__alltraps>

c01028ad <vector41>:
.globl vector41
vector41:
  pushl $0
c01028ad:	6a 00                	push   $0x0
  pushl $41
c01028af:	6a 29                	push   $0x29
  jmp __alltraps
c01028b1:	e9 06 09 00 00       	jmp    c01031bc <__alltraps>

c01028b6 <vector42>:
.globl vector42
vector42:
  pushl $0
c01028b6:	6a 00                	push   $0x0
  pushl $42
c01028b8:	6a 2a                	push   $0x2a
  jmp __alltraps
c01028ba:	e9 fd 08 00 00       	jmp    c01031bc <__alltraps>

c01028bf <vector43>:
.globl vector43
vector43:
  pushl $0
c01028bf:	6a 00                	push   $0x0
  pushl $43
c01028c1:	6a 2b                	push   $0x2b
  jmp __alltraps
c01028c3:	e9 f4 08 00 00       	jmp    c01031bc <__alltraps>

c01028c8 <vector44>:
.globl vector44
vector44:
  pushl $0
c01028c8:	6a 00                	push   $0x0
  pushl $44
c01028ca:	6a 2c                	push   $0x2c
  jmp __alltraps
c01028cc:	e9 eb 08 00 00       	jmp    c01031bc <__alltraps>

c01028d1 <vector45>:
.globl vector45
vector45:
  pushl $0
c01028d1:	6a 00                	push   $0x0
  pushl $45
c01028d3:	6a 2d                	push   $0x2d
  jmp __alltraps
c01028d5:	e9 e2 08 00 00       	jmp    c01031bc <__alltraps>

c01028da <vector46>:
.globl vector46
vector46:
  pushl $0
c01028da:	6a 00                	push   $0x0
  pushl $46
c01028dc:	6a 2e                	push   $0x2e
  jmp __alltraps
c01028de:	e9 d9 08 00 00       	jmp    c01031bc <__alltraps>

c01028e3 <vector47>:
.globl vector47
vector47:
  pushl $0
c01028e3:	6a 00                	push   $0x0
  pushl $47
c01028e5:	6a 2f                	push   $0x2f
  jmp __alltraps
c01028e7:	e9 d0 08 00 00       	jmp    c01031bc <__alltraps>

c01028ec <vector48>:
.globl vector48
vector48:
  pushl $0
c01028ec:	6a 00                	push   $0x0
  pushl $48
c01028ee:	6a 30                	push   $0x30
  jmp __alltraps
c01028f0:	e9 c7 08 00 00       	jmp    c01031bc <__alltraps>

c01028f5 <vector49>:
.globl vector49
vector49:
  pushl $0
c01028f5:	6a 00                	push   $0x0
  pushl $49
c01028f7:	6a 31                	push   $0x31
  jmp __alltraps
c01028f9:	e9 be 08 00 00       	jmp    c01031bc <__alltraps>

c01028fe <vector50>:
.globl vector50
vector50:
  pushl $0
c01028fe:	6a 00                	push   $0x0
  pushl $50
c0102900:	6a 32                	push   $0x32
  jmp __alltraps
c0102902:	e9 b5 08 00 00       	jmp    c01031bc <__alltraps>

c0102907 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102907:	6a 00                	push   $0x0
  pushl $51
c0102909:	6a 33                	push   $0x33
  jmp __alltraps
c010290b:	e9 ac 08 00 00       	jmp    c01031bc <__alltraps>

c0102910 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102910:	6a 00                	push   $0x0
  pushl $52
c0102912:	6a 34                	push   $0x34
  jmp __alltraps
c0102914:	e9 a3 08 00 00       	jmp    c01031bc <__alltraps>

c0102919 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102919:	6a 00                	push   $0x0
  pushl $53
c010291b:	6a 35                	push   $0x35
  jmp __alltraps
c010291d:	e9 9a 08 00 00       	jmp    c01031bc <__alltraps>

c0102922 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102922:	6a 00                	push   $0x0
  pushl $54
c0102924:	6a 36                	push   $0x36
  jmp __alltraps
c0102926:	e9 91 08 00 00       	jmp    c01031bc <__alltraps>

c010292b <vector55>:
.globl vector55
vector55:
  pushl $0
c010292b:	6a 00                	push   $0x0
  pushl $55
c010292d:	6a 37                	push   $0x37
  jmp __alltraps
c010292f:	e9 88 08 00 00       	jmp    c01031bc <__alltraps>

c0102934 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102934:	6a 00                	push   $0x0
  pushl $56
c0102936:	6a 38                	push   $0x38
  jmp __alltraps
c0102938:	e9 7f 08 00 00       	jmp    c01031bc <__alltraps>

c010293d <vector57>:
.globl vector57
vector57:
  pushl $0
c010293d:	6a 00                	push   $0x0
  pushl $57
c010293f:	6a 39                	push   $0x39
  jmp __alltraps
c0102941:	e9 76 08 00 00       	jmp    c01031bc <__alltraps>

c0102946 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102946:	6a 00                	push   $0x0
  pushl $58
c0102948:	6a 3a                	push   $0x3a
  jmp __alltraps
c010294a:	e9 6d 08 00 00       	jmp    c01031bc <__alltraps>

c010294f <vector59>:
.globl vector59
vector59:
  pushl $0
c010294f:	6a 00                	push   $0x0
  pushl $59
c0102951:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102953:	e9 64 08 00 00       	jmp    c01031bc <__alltraps>

c0102958 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102958:	6a 00                	push   $0x0
  pushl $60
c010295a:	6a 3c                	push   $0x3c
  jmp __alltraps
c010295c:	e9 5b 08 00 00       	jmp    c01031bc <__alltraps>

c0102961 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102961:	6a 00                	push   $0x0
  pushl $61
c0102963:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102965:	e9 52 08 00 00       	jmp    c01031bc <__alltraps>

c010296a <vector62>:
.globl vector62
vector62:
  pushl $0
c010296a:	6a 00                	push   $0x0
  pushl $62
c010296c:	6a 3e                	push   $0x3e
  jmp __alltraps
c010296e:	e9 49 08 00 00       	jmp    c01031bc <__alltraps>

c0102973 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102973:	6a 00                	push   $0x0
  pushl $63
c0102975:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102977:	e9 40 08 00 00       	jmp    c01031bc <__alltraps>

c010297c <vector64>:
.globl vector64
vector64:
  pushl $0
c010297c:	6a 00                	push   $0x0
  pushl $64
c010297e:	6a 40                	push   $0x40
  jmp __alltraps
c0102980:	e9 37 08 00 00       	jmp    c01031bc <__alltraps>

c0102985 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102985:	6a 00                	push   $0x0
  pushl $65
c0102987:	6a 41                	push   $0x41
  jmp __alltraps
c0102989:	e9 2e 08 00 00       	jmp    c01031bc <__alltraps>

c010298e <vector66>:
.globl vector66
vector66:
  pushl $0
c010298e:	6a 00                	push   $0x0
  pushl $66
c0102990:	6a 42                	push   $0x42
  jmp __alltraps
c0102992:	e9 25 08 00 00       	jmp    c01031bc <__alltraps>

c0102997 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102997:	6a 00                	push   $0x0
  pushl $67
c0102999:	6a 43                	push   $0x43
  jmp __alltraps
c010299b:	e9 1c 08 00 00       	jmp    c01031bc <__alltraps>

c01029a0 <vector68>:
.globl vector68
vector68:
  pushl $0
c01029a0:	6a 00                	push   $0x0
  pushl $68
c01029a2:	6a 44                	push   $0x44
  jmp __alltraps
c01029a4:	e9 13 08 00 00       	jmp    c01031bc <__alltraps>

c01029a9 <vector69>:
.globl vector69
vector69:
  pushl $0
c01029a9:	6a 00                	push   $0x0
  pushl $69
c01029ab:	6a 45                	push   $0x45
  jmp __alltraps
c01029ad:	e9 0a 08 00 00       	jmp    c01031bc <__alltraps>

c01029b2 <vector70>:
.globl vector70
vector70:
  pushl $0
c01029b2:	6a 00                	push   $0x0
  pushl $70
c01029b4:	6a 46                	push   $0x46
  jmp __alltraps
c01029b6:	e9 01 08 00 00       	jmp    c01031bc <__alltraps>

c01029bb <vector71>:
.globl vector71
vector71:
  pushl $0
c01029bb:	6a 00                	push   $0x0
  pushl $71
c01029bd:	6a 47                	push   $0x47
  jmp __alltraps
c01029bf:	e9 f8 07 00 00       	jmp    c01031bc <__alltraps>

c01029c4 <vector72>:
.globl vector72
vector72:
  pushl $0
c01029c4:	6a 00                	push   $0x0
  pushl $72
c01029c6:	6a 48                	push   $0x48
  jmp __alltraps
c01029c8:	e9 ef 07 00 00       	jmp    c01031bc <__alltraps>

c01029cd <vector73>:
.globl vector73
vector73:
  pushl $0
c01029cd:	6a 00                	push   $0x0
  pushl $73
c01029cf:	6a 49                	push   $0x49
  jmp __alltraps
c01029d1:	e9 e6 07 00 00       	jmp    c01031bc <__alltraps>

c01029d6 <vector74>:
.globl vector74
vector74:
  pushl $0
c01029d6:	6a 00                	push   $0x0
  pushl $74
c01029d8:	6a 4a                	push   $0x4a
  jmp __alltraps
c01029da:	e9 dd 07 00 00       	jmp    c01031bc <__alltraps>

c01029df <vector75>:
.globl vector75
vector75:
  pushl $0
c01029df:	6a 00                	push   $0x0
  pushl $75
c01029e1:	6a 4b                	push   $0x4b
  jmp __alltraps
c01029e3:	e9 d4 07 00 00       	jmp    c01031bc <__alltraps>

c01029e8 <vector76>:
.globl vector76
vector76:
  pushl $0
c01029e8:	6a 00                	push   $0x0
  pushl $76
c01029ea:	6a 4c                	push   $0x4c
  jmp __alltraps
c01029ec:	e9 cb 07 00 00       	jmp    c01031bc <__alltraps>

c01029f1 <vector77>:
.globl vector77
vector77:
  pushl $0
c01029f1:	6a 00                	push   $0x0
  pushl $77
c01029f3:	6a 4d                	push   $0x4d
  jmp __alltraps
c01029f5:	e9 c2 07 00 00       	jmp    c01031bc <__alltraps>

c01029fa <vector78>:
.globl vector78
vector78:
  pushl $0
c01029fa:	6a 00                	push   $0x0
  pushl $78
c01029fc:	6a 4e                	push   $0x4e
  jmp __alltraps
c01029fe:	e9 b9 07 00 00       	jmp    c01031bc <__alltraps>

c0102a03 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a03:	6a 00                	push   $0x0
  pushl $79
c0102a05:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a07:	e9 b0 07 00 00       	jmp    c01031bc <__alltraps>

c0102a0c <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a0c:	6a 00                	push   $0x0
  pushl $80
c0102a0e:	6a 50                	push   $0x50
  jmp __alltraps
c0102a10:	e9 a7 07 00 00       	jmp    c01031bc <__alltraps>

c0102a15 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a15:	6a 00                	push   $0x0
  pushl $81
c0102a17:	6a 51                	push   $0x51
  jmp __alltraps
c0102a19:	e9 9e 07 00 00       	jmp    c01031bc <__alltraps>

c0102a1e <vector82>:
.globl vector82
vector82:
  pushl $0
c0102a1e:	6a 00                	push   $0x0
  pushl $82
c0102a20:	6a 52                	push   $0x52
  jmp __alltraps
c0102a22:	e9 95 07 00 00       	jmp    c01031bc <__alltraps>

c0102a27 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102a27:	6a 00                	push   $0x0
  pushl $83
c0102a29:	6a 53                	push   $0x53
  jmp __alltraps
c0102a2b:	e9 8c 07 00 00       	jmp    c01031bc <__alltraps>

c0102a30 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102a30:	6a 00                	push   $0x0
  pushl $84
c0102a32:	6a 54                	push   $0x54
  jmp __alltraps
c0102a34:	e9 83 07 00 00       	jmp    c01031bc <__alltraps>

c0102a39 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102a39:	6a 00                	push   $0x0
  pushl $85
c0102a3b:	6a 55                	push   $0x55
  jmp __alltraps
c0102a3d:	e9 7a 07 00 00       	jmp    c01031bc <__alltraps>

c0102a42 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102a42:	6a 00                	push   $0x0
  pushl $86
c0102a44:	6a 56                	push   $0x56
  jmp __alltraps
c0102a46:	e9 71 07 00 00       	jmp    c01031bc <__alltraps>

c0102a4b <vector87>:
.globl vector87
vector87:
  pushl $0
c0102a4b:	6a 00                	push   $0x0
  pushl $87
c0102a4d:	6a 57                	push   $0x57
  jmp __alltraps
c0102a4f:	e9 68 07 00 00       	jmp    c01031bc <__alltraps>

c0102a54 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102a54:	6a 00                	push   $0x0
  pushl $88
c0102a56:	6a 58                	push   $0x58
  jmp __alltraps
c0102a58:	e9 5f 07 00 00       	jmp    c01031bc <__alltraps>

c0102a5d <vector89>:
.globl vector89
vector89:
  pushl $0
c0102a5d:	6a 00                	push   $0x0
  pushl $89
c0102a5f:	6a 59                	push   $0x59
  jmp __alltraps
c0102a61:	e9 56 07 00 00       	jmp    c01031bc <__alltraps>

c0102a66 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102a66:	6a 00                	push   $0x0
  pushl $90
c0102a68:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102a6a:	e9 4d 07 00 00       	jmp    c01031bc <__alltraps>

c0102a6f <vector91>:
.globl vector91
vector91:
  pushl $0
c0102a6f:	6a 00                	push   $0x0
  pushl $91
c0102a71:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102a73:	e9 44 07 00 00       	jmp    c01031bc <__alltraps>

c0102a78 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102a78:	6a 00                	push   $0x0
  pushl $92
c0102a7a:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102a7c:	e9 3b 07 00 00       	jmp    c01031bc <__alltraps>

c0102a81 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102a81:	6a 00                	push   $0x0
  pushl $93
c0102a83:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102a85:	e9 32 07 00 00       	jmp    c01031bc <__alltraps>

c0102a8a <vector94>:
.globl vector94
vector94:
  pushl $0
c0102a8a:	6a 00                	push   $0x0
  pushl $94
c0102a8c:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102a8e:	e9 29 07 00 00       	jmp    c01031bc <__alltraps>

c0102a93 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102a93:	6a 00                	push   $0x0
  pushl $95
c0102a95:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102a97:	e9 20 07 00 00       	jmp    c01031bc <__alltraps>

c0102a9c <vector96>:
.globl vector96
vector96:
  pushl $0
c0102a9c:	6a 00                	push   $0x0
  pushl $96
c0102a9e:	6a 60                	push   $0x60
  jmp __alltraps
c0102aa0:	e9 17 07 00 00       	jmp    c01031bc <__alltraps>

c0102aa5 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102aa5:	6a 00                	push   $0x0
  pushl $97
c0102aa7:	6a 61                	push   $0x61
  jmp __alltraps
c0102aa9:	e9 0e 07 00 00       	jmp    c01031bc <__alltraps>

c0102aae <vector98>:
.globl vector98
vector98:
  pushl $0
c0102aae:	6a 00                	push   $0x0
  pushl $98
c0102ab0:	6a 62                	push   $0x62
  jmp __alltraps
c0102ab2:	e9 05 07 00 00       	jmp    c01031bc <__alltraps>

c0102ab7 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102ab7:	6a 00                	push   $0x0
  pushl $99
c0102ab9:	6a 63                	push   $0x63
  jmp __alltraps
c0102abb:	e9 fc 06 00 00       	jmp    c01031bc <__alltraps>

c0102ac0 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102ac0:	6a 00                	push   $0x0
  pushl $100
c0102ac2:	6a 64                	push   $0x64
  jmp __alltraps
c0102ac4:	e9 f3 06 00 00       	jmp    c01031bc <__alltraps>

c0102ac9 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102ac9:	6a 00                	push   $0x0
  pushl $101
c0102acb:	6a 65                	push   $0x65
  jmp __alltraps
c0102acd:	e9 ea 06 00 00       	jmp    c01031bc <__alltraps>

c0102ad2 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102ad2:	6a 00                	push   $0x0
  pushl $102
c0102ad4:	6a 66                	push   $0x66
  jmp __alltraps
c0102ad6:	e9 e1 06 00 00       	jmp    c01031bc <__alltraps>

c0102adb <vector103>:
.globl vector103
vector103:
  pushl $0
c0102adb:	6a 00                	push   $0x0
  pushl $103
c0102add:	6a 67                	push   $0x67
  jmp __alltraps
c0102adf:	e9 d8 06 00 00       	jmp    c01031bc <__alltraps>

c0102ae4 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102ae4:	6a 00                	push   $0x0
  pushl $104
c0102ae6:	6a 68                	push   $0x68
  jmp __alltraps
c0102ae8:	e9 cf 06 00 00       	jmp    c01031bc <__alltraps>

c0102aed <vector105>:
.globl vector105
vector105:
  pushl $0
c0102aed:	6a 00                	push   $0x0
  pushl $105
c0102aef:	6a 69                	push   $0x69
  jmp __alltraps
c0102af1:	e9 c6 06 00 00       	jmp    c01031bc <__alltraps>

c0102af6 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102af6:	6a 00                	push   $0x0
  pushl $106
c0102af8:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102afa:	e9 bd 06 00 00       	jmp    c01031bc <__alltraps>

c0102aff <vector107>:
.globl vector107
vector107:
  pushl $0
c0102aff:	6a 00                	push   $0x0
  pushl $107
c0102b01:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b03:	e9 b4 06 00 00       	jmp    c01031bc <__alltraps>

c0102b08 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b08:	6a 00                	push   $0x0
  pushl $108
c0102b0a:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b0c:	e9 ab 06 00 00       	jmp    c01031bc <__alltraps>

c0102b11 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b11:	6a 00                	push   $0x0
  pushl $109
c0102b13:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b15:	e9 a2 06 00 00       	jmp    c01031bc <__alltraps>

c0102b1a <vector110>:
.globl vector110
vector110:
  pushl $0
c0102b1a:	6a 00                	push   $0x0
  pushl $110
c0102b1c:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102b1e:	e9 99 06 00 00       	jmp    c01031bc <__alltraps>

c0102b23 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102b23:	6a 00                	push   $0x0
  pushl $111
c0102b25:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102b27:	e9 90 06 00 00       	jmp    c01031bc <__alltraps>

c0102b2c <vector112>:
.globl vector112
vector112:
  pushl $0
c0102b2c:	6a 00                	push   $0x0
  pushl $112
c0102b2e:	6a 70                	push   $0x70
  jmp __alltraps
c0102b30:	e9 87 06 00 00       	jmp    c01031bc <__alltraps>

c0102b35 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102b35:	6a 00                	push   $0x0
  pushl $113
c0102b37:	6a 71                	push   $0x71
  jmp __alltraps
c0102b39:	e9 7e 06 00 00       	jmp    c01031bc <__alltraps>

c0102b3e <vector114>:
.globl vector114
vector114:
  pushl $0
c0102b3e:	6a 00                	push   $0x0
  pushl $114
c0102b40:	6a 72                	push   $0x72
  jmp __alltraps
c0102b42:	e9 75 06 00 00       	jmp    c01031bc <__alltraps>

c0102b47 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102b47:	6a 00                	push   $0x0
  pushl $115
c0102b49:	6a 73                	push   $0x73
  jmp __alltraps
c0102b4b:	e9 6c 06 00 00       	jmp    c01031bc <__alltraps>

c0102b50 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102b50:	6a 00                	push   $0x0
  pushl $116
c0102b52:	6a 74                	push   $0x74
  jmp __alltraps
c0102b54:	e9 63 06 00 00       	jmp    c01031bc <__alltraps>

c0102b59 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102b59:	6a 00                	push   $0x0
  pushl $117
c0102b5b:	6a 75                	push   $0x75
  jmp __alltraps
c0102b5d:	e9 5a 06 00 00       	jmp    c01031bc <__alltraps>

c0102b62 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102b62:	6a 00                	push   $0x0
  pushl $118
c0102b64:	6a 76                	push   $0x76
  jmp __alltraps
c0102b66:	e9 51 06 00 00       	jmp    c01031bc <__alltraps>

c0102b6b <vector119>:
.globl vector119
vector119:
  pushl $0
c0102b6b:	6a 00                	push   $0x0
  pushl $119
c0102b6d:	6a 77                	push   $0x77
  jmp __alltraps
c0102b6f:	e9 48 06 00 00       	jmp    c01031bc <__alltraps>

c0102b74 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102b74:	6a 00                	push   $0x0
  pushl $120
c0102b76:	6a 78                	push   $0x78
  jmp __alltraps
c0102b78:	e9 3f 06 00 00       	jmp    c01031bc <__alltraps>

c0102b7d <vector121>:
.globl vector121
vector121:
  pushl $0
c0102b7d:	6a 00                	push   $0x0
  pushl $121
c0102b7f:	6a 79                	push   $0x79
  jmp __alltraps
c0102b81:	e9 36 06 00 00       	jmp    c01031bc <__alltraps>

c0102b86 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102b86:	6a 00                	push   $0x0
  pushl $122
c0102b88:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102b8a:	e9 2d 06 00 00       	jmp    c01031bc <__alltraps>

c0102b8f <vector123>:
.globl vector123
vector123:
  pushl $0
c0102b8f:	6a 00                	push   $0x0
  pushl $123
c0102b91:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102b93:	e9 24 06 00 00       	jmp    c01031bc <__alltraps>

c0102b98 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102b98:	6a 00                	push   $0x0
  pushl $124
c0102b9a:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102b9c:	e9 1b 06 00 00       	jmp    c01031bc <__alltraps>

c0102ba1 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102ba1:	6a 00                	push   $0x0
  pushl $125
c0102ba3:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102ba5:	e9 12 06 00 00       	jmp    c01031bc <__alltraps>

c0102baa <vector126>:
.globl vector126
vector126:
  pushl $0
c0102baa:	6a 00                	push   $0x0
  pushl $126
c0102bac:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102bae:	e9 09 06 00 00       	jmp    c01031bc <__alltraps>

c0102bb3 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102bb3:	6a 00                	push   $0x0
  pushl $127
c0102bb5:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102bb7:	e9 00 06 00 00       	jmp    c01031bc <__alltraps>

c0102bbc <vector128>:
.globl vector128
vector128:
  pushl $0
c0102bbc:	6a 00                	push   $0x0
  pushl $128
c0102bbe:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102bc3:	e9 f4 05 00 00       	jmp    c01031bc <__alltraps>

c0102bc8 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102bc8:	6a 00                	push   $0x0
  pushl $129
c0102bca:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102bcf:	e9 e8 05 00 00       	jmp    c01031bc <__alltraps>

c0102bd4 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102bd4:	6a 00                	push   $0x0
  pushl $130
c0102bd6:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102bdb:	e9 dc 05 00 00       	jmp    c01031bc <__alltraps>

c0102be0 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102be0:	6a 00                	push   $0x0
  pushl $131
c0102be2:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102be7:	e9 d0 05 00 00       	jmp    c01031bc <__alltraps>

c0102bec <vector132>:
.globl vector132
vector132:
  pushl $0
c0102bec:	6a 00                	push   $0x0
  pushl $132
c0102bee:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102bf3:	e9 c4 05 00 00       	jmp    c01031bc <__alltraps>

c0102bf8 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102bf8:	6a 00                	push   $0x0
  pushl $133
c0102bfa:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102bff:	e9 b8 05 00 00       	jmp    c01031bc <__alltraps>

c0102c04 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c04:	6a 00                	push   $0x0
  pushl $134
c0102c06:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c0b:	e9 ac 05 00 00       	jmp    c01031bc <__alltraps>

c0102c10 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c10:	6a 00                	push   $0x0
  pushl $135
c0102c12:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c17:	e9 a0 05 00 00       	jmp    c01031bc <__alltraps>

c0102c1c <vector136>:
.globl vector136
vector136:
  pushl $0
c0102c1c:	6a 00                	push   $0x0
  pushl $136
c0102c1e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102c23:	e9 94 05 00 00       	jmp    c01031bc <__alltraps>

c0102c28 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102c28:	6a 00                	push   $0x0
  pushl $137
c0102c2a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102c2f:	e9 88 05 00 00       	jmp    c01031bc <__alltraps>

c0102c34 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102c34:	6a 00                	push   $0x0
  pushl $138
c0102c36:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102c3b:	e9 7c 05 00 00       	jmp    c01031bc <__alltraps>

c0102c40 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102c40:	6a 00                	push   $0x0
  pushl $139
c0102c42:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102c47:	e9 70 05 00 00       	jmp    c01031bc <__alltraps>

c0102c4c <vector140>:
.globl vector140
vector140:
  pushl $0
c0102c4c:	6a 00                	push   $0x0
  pushl $140
c0102c4e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102c53:	e9 64 05 00 00       	jmp    c01031bc <__alltraps>

c0102c58 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102c58:	6a 00                	push   $0x0
  pushl $141
c0102c5a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102c5f:	e9 58 05 00 00       	jmp    c01031bc <__alltraps>

c0102c64 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102c64:	6a 00                	push   $0x0
  pushl $142
c0102c66:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102c6b:	e9 4c 05 00 00       	jmp    c01031bc <__alltraps>

c0102c70 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102c70:	6a 00                	push   $0x0
  pushl $143
c0102c72:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102c77:	e9 40 05 00 00       	jmp    c01031bc <__alltraps>

c0102c7c <vector144>:
.globl vector144
vector144:
  pushl $0
c0102c7c:	6a 00                	push   $0x0
  pushl $144
c0102c7e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102c83:	e9 34 05 00 00       	jmp    c01031bc <__alltraps>

c0102c88 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102c88:	6a 00                	push   $0x0
  pushl $145
c0102c8a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102c8f:	e9 28 05 00 00       	jmp    c01031bc <__alltraps>

c0102c94 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102c94:	6a 00                	push   $0x0
  pushl $146
c0102c96:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102c9b:	e9 1c 05 00 00       	jmp    c01031bc <__alltraps>

c0102ca0 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102ca0:	6a 00                	push   $0x0
  pushl $147
c0102ca2:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102ca7:	e9 10 05 00 00       	jmp    c01031bc <__alltraps>

c0102cac <vector148>:
.globl vector148
vector148:
  pushl $0
c0102cac:	6a 00                	push   $0x0
  pushl $148
c0102cae:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102cb3:	e9 04 05 00 00       	jmp    c01031bc <__alltraps>

c0102cb8 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102cb8:	6a 00                	push   $0x0
  pushl $149
c0102cba:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102cbf:	e9 f8 04 00 00       	jmp    c01031bc <__alltraps>

c0102cc4 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102cc4:	6a 00                	push   $0x0
  pushl $150
c0102cc6:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102ccb:	e9 ec 04 00 00       	jmp    c01031bc <__alltraps>

c0102cd0 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102cd0:	6a 00                	push   $0x0
  pushl $151
c0102cd2:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102cd7:	e9 e0 04 00 00       	jmp    c01031bc <__alltraps>

c0102cdc <vector152>:
.globl vector152
vector152:
  pushl $0
c0102cdc:	6a 00                	push   $0x0
  pushl $152
c0102cde:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102ce3:	e9 d4 04 00 00       	jmp    c01031bc <__alltraps>

c0102ce8 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102ce8:	6a 00                	push   $0x0
  pushl $153
c0102cea:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102cef:	e9 c8 04 00 00       	jmp    c01031bc <__alltraps>

c0102cf4 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102cf4:	6a 00                	push   $0x0
  pushl $154
c0102cf6:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102cfb:	e9 bc 04 00 00       	jmp    c01031bc <__alltraps>

c0102d00 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d00:	6a 00                	push   $0x0
  pushl $155
c0102d02:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d07:	e9 b0 04 00 00       	jmp    c01031bc <__alltraps>

c0102d0c <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d0c:	6a 00                	push   $0x0
  pushl $156
c0102d0e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d13:	e9 a4 04 00 00       	jmp    c01031bc <__alltraps>

c0102d18 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d18:	6a 00                	push   $0x0
  pushl $157
c0102d1a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102d1f:	e9 98 04 00 00       	jmp    c01031bc <__alltraps>

c0102d24 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102d24:	6a 00                	push   $0x0
  pushl $158
c0102d26:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102d2b:	e9 8c 04 00 00       	jmp    c01031bc <__alltraps>

c0102d30 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102d30:	6a 00                	push   $0x0
  pushl $159
c0102d32:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102d37:	e9 80 04 00 00       	jmp    c01031bc <__alltraps>

c0102d3c <vector160>:
.globl vector160
vector160:
  pushl $0
c0102d3c:	6a 00                	push   $0x0
  pushl $160
c0102d3e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102d43:	e9 74 04 00 00       	jmp    c01031bc <__alltraps>

c0102d48 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102d48:	6a 00                	push   $0x0
  pushl $161
c0102d4a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102d4f:	e9 68 04 00 00       	jmp    c01031bc <__alltraps>

c0102d54 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102d54:	6a 00                	push   $0x0
  pushl $162
c0102d56:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102d5b:	e9 5c 04 00 00       	jmp    c01031bc <__alltraps>

c0102d60 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102d60:	6a 00                	push   $0x0
  pushl $163
c0102d62:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102d67:	e9 50 04 00 00       	jmp    c01031bc <__alltraps>

c0102d6c <vector164>:
.globl vector164
vector164:
  pushl $0
c0102d6c:	6a 00                	push   $0x0
  pushl $164
c0102d6e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102d73:	e9 44 04 00 00       	jmp    c01031bc <__alltraps>

c0102d78 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102d78:	6a 00                	push   $0x0
  pushl $165
c0102d7a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102d7f:	e9 38 04 00 00       	jmp    c01031bc <__alltraps>

c0102d84 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102d84:	6a 00                	push   $0x0
  pushl $166
c0102d86:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102d8b:	e9 2c 04 00 00       	jmp    c01031bc <__alltraps>

c0102d90 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102d90:	6a 00                	push   $0x0
  pushl $167
c0102d92:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102d97:	e9 20 04 00 00       	jmp    c01031bc <__alltraps>

c0102d9c <vector168>:
.globl vector168
vector168:
  pushl $0
c0102d9c:	6a 00                	push   $0x0
  pushl $168
c0102d9e:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102da3:	e9 14 04 00 00       	jmp    c01031bc <__alltraps>

c0102da8 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102da8:	6a 00                	push   $0x0
  pushl $169
c0102daa:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102daf:	e9 08 04 00 00       	jmp    c01031bc <__alltraps>

c0102db4 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102db4:	6a 00                	push   $0x0
  pushl $170
c0102db6:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102dbb:	e9 fc 03 00 00       	jmp    c01031bc <__alltraps>

c0102dc0 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102dc0:	6a 00                	push   $0x0
  pushl $171
c0102dc2:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102dc7:	e9 f0 03 00 00       	jmp    c01031bc <__alltraps>

c0102dcc <vector172>:
.globl vector172
vector172:
  pushl $0
c0102dcc:	6a 00                	push   $0x0
  pushl $172
c0102dce:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102dd3:	e9 e4 03 00 00       	jmp    c01031bc <__alltraps>

c0102dd8 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102dd8:	6a 00                	push   $0x0
  pushl $173
c0102dda:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102ddf:	e9 d8 03 00 00       	jmp    c01031bc <__alltraps>

c0102de4 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102de4:	6a 00                	push   $0x0
  pushl $174
c0102de6:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102deb:	e9 cc 03 00 00       	jmp    c01031bc <__alltraps>

c0102df0 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102df0:	6a 00                	push   $0x0
  pushl $175
c0102df2:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102df7:	e9 c0 03 00 00       	jmp    c01031bc <__alltraps>

c0102dfc <vector176>:
.globl vector176
vector176:
  pushl $0
c0102dfc:	6a 00                	push   $0x0
  pushl $176
c0102dfe:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e03:	e9 b4 03 00 00       	jmp    c01031bc <__alltraps>

c0102e08 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e08:	6a 00                	push   $0x0
  pushl $177
c0102e0a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e0f:	e9 a8 03 00 00       	jmp    c01031bc <__alltraps>

c0102e14 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e14:	6a 00                	push   $0x0
  pushl $178
c0102e16:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102e1b:	e9 9c 03 00 00       	jmp    c01031bc <__alltraps>

c0102e20 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102e20:	6a 00                	push   $0x0
  pushl $179
c0102e22:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102e27:	e9 90 03 00 00       	jmp    c01031bc <__alltraps>

c0102e2c <vector180>:
.globl vector180
vector180:
  pushl $0
c0102e2c:	6a 00                	push   $0x0
  pushl $180
c0102e2e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102e33:	e9 84 03 00 00       	jmp    c01031bc <__alltraps>

c0102e38 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102e38:	6a 00                	push   $0x0
  pushl $181
c0102e3a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102e3f:	e9 78 03 00 00       	jmp    c01031bc <__alltraps>

c0102e44 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102e44:	6a 00                	push   $0x0
  pushl $182
c0102e46:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102e4b:	e9 6c 03 00 00       	jmp    c01031bc <__alltraps>

c0102e50 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102e50:	6a 00                	push   $0x0
  pushl $183
c0102e52:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102e57:	e9 60 03 00 00       	jmp    c01031bc <__alltraps>

c0102e5c <vector184>:
.globl vector184
vector184:
  pushl $0
c0102e5c:	6a 00                	push   $0x0
  pushl $184
c0102e5e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102e63:	e9 54 03 00 00       	jmp    c01031bc <__alltraps>

c0102e68 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102e68:	6a 00                	push   $0x0
  pushl $185
c0102e6a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102e6f:	e9 48 03 00 00       	jmp    c01031bc <__alltraps>

c0102e74 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102e74:	6a 00                	push   $0x0
  pushl $186
c0102e76:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102e7b:	e9 3c 03 00 00       	jmp    c01031bc <__alltraps>

c0102e80 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102e80:	6a 00                	push   $0x0
  pushl $187
c0102e82:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102e87:	e9 30 03 00 00       	jmp    c01031bc <__alltraps>

c0102e8c <vector188>:
.globl vector188
vector188:
  pushl $0
c0102e8c:	6a 00                	push   $0x0
  pushl $188
c0102e8e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102e93:	e9 24 03 00 00       	jmp    c01031bc <__alltraps>

c0102e98 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102e98:	6a 00                	push   $0x0
  pushl $189
c0102e9a:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102e9f:	e9 18 03 00 00       	jmp    c01031bc <__alltraps>

c0102ea4 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102ea4:	6a 00                	push   $0x0
  pushl $190
c0102ea6:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102eab:	e9 0c 03 00 00       	jmp    c01031bc <__alltraps>

c0102eb0 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102eb0:	6a 00                	push   $0x0
  pushl $191
c0102eb2:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102eb7:	e9 00 03 00 00       	jmp    c01031bc <__alltraps>

c0102ebc <vector192>:
.globl vector192
vector192:
  pushl $0
c0102ebc:	6a 00                	push   $0x0
  pushl $192
c0102ebe:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102ec3:	e9 f4 02 00 00       	jmp    c01031bc <__alltraps>

c0102ec8 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102ec8:	6a 00                	push   $0x0
  pushl $193
c0102eca:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102ecf:	e9 e8 02 00 00       	jmp    c01031bc <__alltraps>

c0102ed4 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102ed4:	6a 00                	push   $0x0
  pushl $194
c0102ed6:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102edb:	e9 dc 02 00 00       	jmp    c01031bc <__alltraps>

c0102ee0 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102ee0:	6a 00                	push   $0x0
  pushl $195
c0102ee2:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102ee7:	e9 d0 02 00 00       	jmp    c01031bc <__alltraps>

c0102eec <vector196>:
.globl vector196
vector196:
  pushl $0
c0102eec:	6a 00                	push   $0x0
  pushl $196
c0102eee:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102ef3:	e9 c4 02 00 00       	jmp    c01031bc <__alltraps>

c0102ef8 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102ef8:	6a 00                	push   $0x0
  pushl $197
c0102efa:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102eff:	e9 b8 02 00 00       	jmp    c01031bc <__alltraps>

c0102f04 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f04:	6a 00                	push   $0x0
  pushl $198
c0102f06:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f0b:	e9 ac 02 00 00       	jmp    c01031bc <__alltraps>

c0102f10 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f10:	6a 00                	push   $0x0
  pushl $199
c0102f12:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f17:	e9 a0 02 00 00       	jmp    c01031bc <__alltraps>

c0102f1c <vector200>:
.globl vector200
vector200:
  pushl $0
c0102f1c:	6a 00                	push   $0x0
  pushl $200
c0102f1e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102f23:	e9 94 02 00 00       	jmp    c01031bc <__alltraps>

c0102f28 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102f28:	6a 00                	push   $0x0
  pushl $201
c0102f2a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102f2f:	e9 88 02 00 00       	jmp    c01031bc <__alltraps>

c0102f34 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102f34:	6a 00                	push   $0x0
  pushl $202
c0102f36:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102f3b:	e9 7c 02 00 00       	jmp    c01031bc <__alltraps>

c0102f40 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102f40:	6a 00                	push   $0x0
  pushl $203
c0102f42:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102f47:	e9 70 02 00 00       	jmp    c01031bc <__alltraps>

c0102f4c <vector204>:
.globl vector204
vector204:
  pushl $0
c0102f4c:	6a 00                	push   $0x0
  pushl $204
c0102f4e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102f53:	e9 64 02 00 00       	jmp    c01031bc <__alltraps>

c0102f58 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102f58:	6a 00                	push   $0x0
  pushl $205
c0102f5a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102f5f:	e9 58 02 00 00       	jmp    c01031bc <__alltraps>

c0102f64 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102f64:	6a 00                	push   $0x0
  pushl $206
c0102f66:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102f6b:	e9 4c 02 00 00       	jmp    c01031bc <__alltraps>

c0102f70 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102f70:	6a 00                	push   $0x0
  pushl $207
c0102f72:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102f77:	e9 40 02 00 00       	jmp    c01031bc <__alltraps>

c0102f7c <vector208>:
.globl vector208
vector208:
  pushl $0
c0102f7c:	6a 00                	push   $0x0
  pushl $208
c0102f7e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102f83:	e9 34 02 00 00       	jmp    c01031bc <__alltraps>

c0102f88 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102f88:	6a 00                	push   $0x0
  pushl $209
c0102f8a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102f8f:	e9 28 02 00 00       	jmp    c01031bc <__alltraps>

c0102f94 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102f94:	6a 00                	push   $0x0
  pushl $210
c0102f96:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102f9b:	e9 1c 02 00 00       	jmp    c01031bc <__alltraps>

c0102fa0 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102fa0:	6a 00                	push   $0x0
  pushl $211
c0102fa2:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102fa7:	e9 10 02 00 00       	jmp    c01031bc <__alltraps>

c0102fac <vector212>:
.globl vector212
vector212:
  pushl $0
c0102fac:	6a 00                	push   $0x0
  pushl $212
c0102fae:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102fb3:	e9 04 02 00 00       	jmp    c01031bc <__alltraps>

c0102fb8 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102fb8:	6a 00                	push   $0x0
  pushl $213
c0102fba:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102fbf:	e9 f8 01 00 00       	jmp    c01031bc <__alltraps>

c0102fc4 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102fc4:	6a 00                	push   $0x0
  pushl $214
c0102fc6:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102fcb:	e9 ec 01 00 00       	jmp    c01031bc <__alltraps>

c0102fd0 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102fd0:	6a 00                	push   $0x0
  pushl $215
c0102fd2:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102fd7:	e9 e0 01 00 00       	jmp    c01031bc <__alltraps>

c0102fdc <vector216>:
.globl vector216
vector216:
  pushl $0
c0102fdc:	6a 00                	push   $0x0
  pushl $216
c0102fde:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102fe3:	e9 d4 01 00 00       	jmp    c01031bc <__alltraps>

c0102fe8 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102fe8:	6a 00                	push   $0x0
  pushl $217
c0102fea:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102fef:	e9 c8 01 00 00       	jmp    c01031bc <__alltraps>

c0102ff4 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102ff4:	6a 00                	push   $0x0
  pushl $218
c0102ff6:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102ffb:	e9 bc 01 00 00       	jmp    c01031bc <__alltraps>

c0103000 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103000:	6a 00                	push   $0x0
  pushl $219
c0103002:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0103007:	e9 b0 01 00 00       	jmp    c01031bc <__alltraps>

c010300c <vector220>:
.globl vector220
vector220:
  pushl $0
c010300c:	6a 00                	push   $0x0
  pushl $220
c010300e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103013:	e9 a4 01 00 00       	jmp    c01031bc <__alltraps>

c0103018 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103018:	6a 00                	push   $0x0
  pushl $221
c010301a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010301f:	e9 98 01 00 00       	jmp    c01031bc <__alltraps>

c0103024 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103024:	6a 00                	push   $0x0
  pushl $222
c0103026:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010302b:	e9 8c 01 00 00       	jmp    c01031bc <__alltraps>

c0103030 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103030:	6a 00                	push   $0x0
  pushl $223
c0103032:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0103037:	e9 80 01 00 00       	jmp    c01031bc <__alltraps>

c010303c <vector224>:
.globl vector224
vector224:
  pushl $0
c010303c:	6a 00                	push   $0x0
  pushl $224
c010303e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103043:	e9 74 01 00 00       	jmp    c01031bc <__alltraps>

c0103048 <vector225>:
.globl vector225
vector225:
  pushl $0
c0103048:	6a 00                	push   $0x0
  pushl $225
c010304a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010304f:	e9 68 01 00 00       	jmp    c01031bc <__alltraps>

c0103054 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103054:	6a 00                	push   $0x0
  pushl $226
c0103056:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010305b:	e9 5c 01 00 00       	jmp    c01031bc <__alltraps>

c0103060 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103060:	6a 00                	push   $0x0
  pushl $227
c0103062:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0103067:	e9 50 01 00 00       	jmp    c01031bc <__alltraps>

c010306c <vector228>:
.globl vector228
vector228:
  pushl $0
c010306c:	6a 00                	push   $0x0
  pushl $228
c010306e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103073:	e9 44 01 00 00       	jmp    c01031bc <__alltraps>

c0103078 <vector229>:
.globl vector229
vector229:
  pushl $0
c0103078:	6a 00                	push   $0x0
  pushl $229
c010307a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010307f:	e9 38 01 00 00       	jmp    c01031bc <__alltraps>

c0103084 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103084:	6a 00                	push   $0x0
  pushl $230
c0103086:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010308b:	e9 2c 01 00 00       	jmp    c01031bc <__alltraps>

c0103090 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103090:	6a 00                	push   $0x0
  pushl $231
c0103092:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0103097:	e9 20 01 00 00       	jmp    c01031bc <__alltraps>

c010309c <vector232>:
.globl vector232
vector232:
  pushl $0
c010309c:	6a 00                	push   $0x0
  pushl $232
c010309e:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01030a3:	e9 14 01 00 00       	jmp    c01031bc <__alltraps>

c01030a8 <vector233>:
.globl vector233
vector233:
  pushl $0
c01030a8:	6a 00                	push   $0x0
  pushl $233
c01030aa:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01030af:	e9 08 01 00 00       	jmp    c01031bc <__alltraps>

c01030b4 <vector234>:
.globl vector234
vector234:
  pushl $0
c01030b4:	6a 00                	push   $0x0
  pushl $234
c01030b6:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01030bb:	e9 fc 00 00 00       	jmp    c01031bc <__alltraps>

c01030c0 <vector235>:
.globl vector235
vector235:
  pushl $0
c01030c0:	6a 00                	push   $0x0
  pushl $235
c01030c2:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01030c7:	e9 f0 00 00 00       	jmp    c01031bc <__alltraps>

c01030cc <vector236>:
.globl vector236
vector236:
  pushl $0
c01030cc:	6a 00                	push   $0x0
  pushl $236
c01030ce:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01030d3:	e9 e4 00 00 00       	jmp    c01031bc <__alltraps>

c01030d8 <vector237>:
.globl vector237
vector237:
  pushl $0
c01030d8:	6a 00                	push   $0x0
  pushl $237
c01030da:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01030df:	e9 d8 00 00 00       	jmp    c01031bc <__alltraps>

c01030e4 <vector238>:
.globl vector238
vector238:
  pushl $0
c01030e4:	6a 00                	push   $0x0
  pushl $238
c01030e6:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01030eb:	e9 cc 00 00 00       	jmp    c01031bc <__alltraps>

c01030f0 <vector239>:
.globl vector239
vector239:
  pushl $0
c01030f0:	6a 00                	push   $0x0
  pushl $239
c01030f2:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01030f7:	e9 c0 00 00 00       	jmp    c01031bc <__alltraps>

c01030fc <vector240>:
.globl vector240
vector240:
  pushl $0
c01030fc:	6a 00                	push   $0x0
  pushl $240
c01030fe:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103103:	e9 b4 00 00 00       	jmp    c01031bc <__alltraps>

c0103108 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103108:	6a 00                	push   $0x0
  pushl $241
c010310a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010310f:	e9 a8 00 00 00       	jmp    c01031bc <__alltraps>

c0103114 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103114:	6a 00                	push   $0x0
  pushl $242
c0103116:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010311b:	e9 9c 00 00 00       	jmp    c01031bc <__alltraps>

c0103120 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103120:	6a 00                	push   $0x0
  pushl $243
c0103122:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0103127:	e9 90 00 00 00       	jmp    c01031bc <__alltraps>

c010312c <vector244>:
.globl vector244
vector244:
  pushl $0
c010312c:	6a 00                	push   $0x0
  pushl $244
c010312e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103133:	e9 84 00 00 00       	jmp    c01031bc <__alltraps>

c0103138 <vector245>:
.globl vector245
vector245:
  pushl $0
c0103138:	6a 00                	push   $0x0
  pushl $245
c010313a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010313f:	e9 78 00 00 00       	jmp    c01031bc <__alltraps>

c0103144 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103144:	6a 00                	push   $0x0
  pushl $246
c0103146:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010314b:	e9 6c 00 00 00       	jmp    c01031bc <__alltraps>

c0103150 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103150:	6a 00                	push   $0x0
  pushl $247
c0103152:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0103157:	e9 60 00 00 00       	jmp    c01031bc <__alltraps>

c010315c <vector248>:
.globl vector248
vector248:
  pushl $0
c010315c:	6a 00                	push   $0x0
  pushl $248
c010315e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103163:	e9 54 00 00 00       	jmp    c01031bc <__alltraps>

c0103168 <vector249>:
.globl vector249
vector249:
  pushl $0
c0103168:	6a 00                	push   $0x0
  pushl $249
c010316a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010316f:	e9 48 00 00 00       	jmp    c01031bc <__alltraps>

c0103174 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103174:	6a 00                	push   $0x0
  pushl $250
c0103176:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010317b:	e9 3c 00 00 00       	jmp    c01031bc <__alltraps>

c0103180 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103180:	6a 00                	push   $0x0
  pushl $251
c0103182:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0103187:	e9 30 00 00 00       	jmp    c01031bc <__alltraps>

c010318c <vector252>:
.globl vector252
vector252:
  pushl $0
c010318c:	6a 00                	push   $0x0
  pushl $252
c010318e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103193:	e9 24 00 00 00       	jmp    c01031bc <__alltraps>

c0103198 <vector253>:
.globl vector253
vector253:
  pushl $0
c0103198:	6a 00                	push   $0x0
  pushl $253
c010319a:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010319f:	e9 18 00 00 00       	jmp    c01031bc <__alltraps>

c01031a4 <vector254>:
.globl vector254
vector254:
  pushl $0
c01031a4:	6a 00                	push   $0x0
  pushl $254
c01031a6:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01031ab:	e9 0c 00 00 00       	jmp    c01031bc <__alltraps>

c01031b0 <vector255>:
.globl vector255
vector255:
  pushl $0
c01031b0:	6a 00                	push   $0x0
  pushl $255
c01031b2:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01031b7:	e9 00 00 00 00       	jmp    c01031bc <__alltraps>

c01031bc <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01031bc:	1e                   	push   %ds
    pushl %es
c01031bd:	06                   	push   %es
    pushl %fs
c01031be:	0f a0                	push   %fs
    pushl %gs
c01031c0:	0f a8                	push   %gs
    pushal
c01031c2:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01031c3:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01031c8:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01031ca:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01031cc:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01031cd:	e8 67 f5 ff ff       	call   c0102739 <trap>

    # pop the pushed stack pointer
    popl %esp
c01031d2:	5c                   	pop    %esp

c01031d3 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01031d3:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01031d4:	0f a9                	pop    %gs
    popl %fs
c01031d6:	0f a1                	pop    %fs
    popl %es
c01031d8:	07                   	pop    %es
    popl %ds
c01031d9:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01031da:	83 c4 08             	add    $0x8,%esp
    iret
c01031dd:	cf                   	iret   

c01031de <_extended_clock_init_mm>:
//当访问页时，相应的A位和D位都会被CPU修改
//不用操作系统进行专门修改，所以只要对发生缺页时的情况进行处理即可。

static int
_extended_clock_init_mm(struct mm_struct *mm)
{     
c01031de:	55                   	push   %ebp
c01031df:	89 e5                	mov    %esp,%ebp
c01031e1:	83 ec 10             	sub    $0x10,%esp
c01031e4:	c7 45 fc 10 50 12 c0 	movl   $0xc0125010,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01031eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01031ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01031f1:	89 50 04             	mov    %edx,0x4(%eax)
c01031f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01031f7:	8b 50 04             	mov    0x4(%eax),%edx
c01031fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01031fd:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c01031ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0103202:	c7 40 14 10 50 12 c0 	movl   $0xc0125010,0x14(%eax)
     // 将头指针指向pra_list_head的起始地址
     clock_p = (list_entry_t*)&pra_list_head;
c0103209:	c7 05 18 50 12 c0 10 	movl   $0xc0125010,0xc0125018
c0103210:	50 12 c0 
     //cprintf(" mm->sm_priv %x in extended_clock_init_mm\n",mm->sm_priv);
     return 0;
c0103213:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103218:	c9                   	leave  
c0103219:	c3                   	ret    

c010321a <_extended_clock_map_swappable>:
/*
 * (3)_extended_clock_map_swappable: According extended_clock PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_extended_clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c010321a:	55                   	push   %ebp
c010321b:	89 e5                	mov    %esp,%ebp
c010321d:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0103220:	8b 45 08             	mov    0x8(%ebp),%eax
c0103223:	8b 40 14             	mov    0x14(%eax),%eax
c0103226:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0103229:	8b 45 10             	mov    0x10(%ebp),%eax
c010322c:	83 c0 14             	add    $0x14,%eax
c010322f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0103232:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103236:	74 06                	je     c010323e <_extended_clock_map_swappable+0x24>
c0103238:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010323c:	75 24                	jne    c0103262 <_extended_clock_map_swappable+0x48>
c010323e:	c7 44 24 0c b0 9b 10 	movl   $0xc0109bb0,0xc(%esp)
c0103245:	c0 
c0103246:	c7 44 24 08 ce 9b 10 	movl   $0xc0109bce,0x8(%esp)
c010324d:	c0 
c010324e:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
c0103255:	00 
c0103256:	c7 04 24 e3 9b 10 c0 	movl   $0xc0109be3,(%esp)
c010325d:	e8 96 d1 ff ff       	call   c01003f8 <__panic>
    //将换进的页加入链表
    list_add_before(clock_p, entry);
c0103262:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c0103267:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010326a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010326d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103270:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103273:	8b 00                	mov    (%eax),%eax
c0103275:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103278:	89 55 e0             	mov    %edx,-0x20(%ebp)
c010327b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010327e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103281:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103284:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103287:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010328a:	89 10                	mov    %edx,(%eax)
c010328c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010328f:	8b 10                	mov    (%eax),%edx
c0103291:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103294:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103297:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010329a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010329d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01032a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01032a6:	89 10                	mov    %edx,(%eax)
    //pte_t *pte = get_pte(mm->pgdir, page2kva(page), 0);
	pte_t *pte = get_pte(mm->pgdir, addr, 0);
c01032a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01032ab:	8b 40 0c             	mov    0xc(%eax),%eax
c01032ae:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01032b5:	00 
c01032b6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01032b9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01032bd:	89 04 24             	mov    %eax,(%esp)
c01032c0:	e8 92 40 00 00       	call   c0107357 <get_pte>
c01032c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //int access = (*pte)&(PTE_A)?1:0;
    //int dirty = (*pte)&(PTE_D)?1:0;
    return 0;
c01032c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01032cd:	c9                   	leave  
c01032ce:	c3                   	ret    

c01032cf <_extended_clock_swap_out_victim>:
	(0,0) 置换        
当找到（0，0）时置换此页，并将指针下移。
*/
static int
_extended_clock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c01032cf:	55                   	push   %ebp
c01032d0:	89 e5                	mov    %esp,%ebp
c01032d2:	83 ec 68             	sub    $0x68,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01032d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01032d8:	8b 40 14             	mov    0x14(%eax),%eax
c01032db:	89 45 f0             	mov    %eax,-0x10(%ebp)
         assert(head != NULL);
c01032de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01032e2:	75 24                	jne    c0103308 <_extended_clock_swap_out_victim+0x39>
c01032e4:	c7 44 24 0c 01 9c 10 	movl   $0xc0109c01,0xc(%esp)
c01032eb:	c0 
c01032ec:	c7 44 24 08 ce 9b 10 	movl   $0xc0109bce,0x8(%esp)
c01032f3:	c0 
c01032f4:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
c01032fb:	00 
c01032fc:	c7 04 24 e3 9b 10 c0 	movl   $0xc0109be3,(%esp)
c0103303:	e8 f0 d0 ff ff       	call   c01003f8 <__panic>
     assert(in_tick==0);
c0103308:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010330c:	74 24                	je     c0103332 <_extended_clock_swap_out_victim+0x63>
c010330e:	c7 44 24 0c 0e 9c 10 	movl   $0xc0109c0e,0xc(%esp)
c0103315:	c0 
c0103316:	c7 44 24 08 ce 9b 10 	movl   $0xc0109bce,0x8(%esp)
c010331d:	c0 
c010331e:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
c0103325:	00 
c0103326:	c7 04 24 e3 9b 10 c0 	movl   $0xc0109be3,(%esp)
c010332d:	e8 c6 d0 ff ff       	call   c01003f8 <__panic>
     list_entry_t *le = clock_p;
c0103332:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c0103337:	89 45 f4             	mov    %eax,-0xc(%ebp)
     le = head->next;
c010333a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010333d:	8b 40 04             	mov    0x4(%eax),%eax
c0103340:	89 45 f4             	mov    %eax,-0xc(%ebp)
     cprintf("\n---start---\n");
c0103343:	c7 04 24 19 9c 10 c0 	movl   $0xc0109c19,(%esp)
c010334a:	e8 52 cf ff ff       	call   c01002a1 <cprintf>
     while (1) {
    	 struct Page *page = le2page(le, pra_page_link);
c010334f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103352:	83 e8 14             	sub    $0x14,%eax
c0103355:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	 pte_t * pte = get_pte(mm->pgdir, page->pra_vaddr, 0);
c0103358:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010335b:	8b 50 1c             	mov    0x1c(%eax),%edx
c010335e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103361:	8b 40 0c             	mov    0xc(%eax),%eax
c0103364:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010336b:	00 
c010336c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103370:	89 04 24             	mov    %eax,(%esp)
c0103373:	e8 df 3f 00 00       	call   c0107357 <get_pte>
c0103378:	89 45 e8             	mov    %eax,-0x18(%ebp)
    	 int accessed = (*pte)&(PTE_A)?1:0;
c010337b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010337e:	8b 00                	mov    (%eax),%eax
c0103380:	83 e0 20             	and    $0x20,%eax
c0103383:	85 c0                	test   %eax,%eax
c0103385:	0f 95 c0             	setne  %al
c0103388:	0f b6 c0             	movzbl %al,%eax
c010338b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	 int dirty = (*pte)&(PTE_D)?1:0;
c010338e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103391:	8b 00                	mov    (%eax),%eax
c0103393:	83 e0 40             	and    $0x40,%eax
c0103396:	85 c0                	test   %eax,%eax
c0103398:	0f 95 c0             	setne  %al
c010339b:	0f b6 c0             	movzbl %al,%eax
c010339e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 if (le==clock_p)
c01033a1:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c01033a6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01033a9:	75 0e                	jne    c01033b9 <_extended_clock_swap_out_victim+0xea>
			 cprintf("->");
c01033ab:	c7 04 24 27 9c 10 c0 	movl   $0xc0109c27,(%esp)
c01033b2:	e8 ea ce ff ff       	call   c01002a1 <cprintf>
c01033b7:	eb 0c                	jmp    c01033c5 <_extended_clock_swap_out_victim+0xf6>
		 else
			 cprintf("  ");
c01033b9:	c7 04 24 2a 9c 10 c0 	movl   $0xc0109c2a,(%esp)
c01033c0:	e8 dc ce ff ff       	call   c01002a1 <cprintf>
    	 cprintf("clock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, accessed, dirty);
c01033c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033c8:	8b 40 1c             	mov    0x1c(%eax),%eax
c01033cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01033ce:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01033d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01033d5:	89 54 24 08          	mov    %edx,0x8(%esp)
c01033d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01033dd:	c7 04 24 30 9c 10 c0 	movl   $0xc0109c30,(%esp)
c01033e4:	e8 b8 ce ff ff       	call   c01002a1 <cprintf>
    	 le = le->next;
c01033e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033ec:	8b 40 04             	mov    0x4(%eax),%eax
c01033ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	 if (le == head) {
c01033f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033f5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01033f8:	75 17                	jne    c0103411 <_extended_clock_swap_out_victim+0x142>
    		 break;
c01033fa:	90                   	nop
    	 }
     }
     cprintf("----end----\n");
c01033fb:	c7 04 24 50 9c 10 c0 	movl   $0xc0109c50,(%esp)
c0103402:	e8 9a ce ff ff       	call   c01002a1 <cprintf>

     le = clock_p;
c0103407:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c010340c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010340f:	eb 05                	jmp    c0103416 <_extended_clock_swap_out_victim+0x147>
     }
c0103411:	e9 39 ff ff ff       	jmp    c010334f <_extended_clock_swap_out_victim+0x80>
     while (1) {
    	 if (le == head) {
c0103416:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103419:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010341c:	75 16                	jne    c0103434 <_extended_clock_swap_out_victim+0x165>
    		 le = le->next;
c010341e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103421:	8b 40 04             	mov    0x4(%eax),%eax
c0103424:	89 45 f4             	mov    %eax,-0xc(%ebp)
    		 clock_p = clock_p -> next;
c0103427:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c010342c:	8b 40 04             	mov    0x4(%eax),%eax
c010342f:	a3 18 50 12 c0       	mov    %eax,0xc0125018
    	 }
    	 struct Page *page = le2page(le, pra_page_link);
c0103434:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103437:	83 e8 14             	sub    $0x14,%eax
c010343a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    	 pte_t * pte = get_pte(mm->pgdir, page->pra_vaddr, 0);
c010343d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103440:	8b 50 1c             	mov    0x1c(%eax),%edx
c0103443:	8b 45 08             	mov    0x8(%ebp),%eax
c0103446:	8b 40 0c             	mov    0xc(%eax),%eax
c0103449:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103450:	00 
c0103451:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103455:	89 04 24             	mov    %eax,(%esp)
c0103458:	e8 fa 3e 00 00       	call   c0107357 <get_pte>
c010345d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    	 int accessed = (*pte)&(PTE_A)?1:0;
c0103460:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103463:	8b 00                	mov    (%eax),%eax
c0103465:	83 e0 20             	and    $0x20,%eax
c0103468:	85 c0                	test   %eax,%eax
c010346a:	0f 95 c0             	setne  %al
c010346d:	0f b6 c0             	movzbl %al,%eax
c0103470:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    	 int dirty = (*pte)&(PTE_D)?1:0;
c0103473:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103476:	8b 00                	mov    (%eax),%eax
c0103478:	83 e0 40             	and    $0x40,%eax
c010347b:	85 c0                	test   %eax,%eax
c010347d:	0f 95 c0             	setne  %al
c0103480:	0f b6 c0             	movzbl %al,%eax
c0103483:	89 45 d0             	mov    %eax,-0x30(%ebp)
    	 if (accessed) {//如果A为1，则将其变为0；
c0103486:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010348a:	74 76                	je     c0103502 <_extended_clock_swap_out_victim+0x233>
    		 cprintf("clock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, accessed, dirty);
c010348c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010348f:	8b 40 1c             	mov    0x1c(%eax),%eax
c0103492:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103495:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0103499:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010349c:	89 54 24 08          	mov    %edx,0x8(%esp)
c01034a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01034a4:	c7 04 24 30 9c 10 c0 	movl   $0xc0109c30,(%esp)
c01034ab:	e8 f1 cd ff ff       	call   c01002a1 <cprintf>
    		 (*pte) = (*pte) & (~PTE_A);
c01034b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034b3:	8b 00                	mov    (%eax),%eax
c01034b5:	83 e0 df             	and    $0xffffffdf,%eax
c01034b8:	89 c2                	mov    %eax,%edx
c01034ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034bd:	89 10                	mov    %edx,(%eax)
    		 cprintf("\tclock state: 0x%4x: A:%x, D:%x\n",page->pra_vaddr, (*pte)&(PTE_A)?1:0, (*pte)&(PTE_D)?1:0);
c01034bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034c2:	8b 00                	mov    (%eax),%eax
c01034c4:	83 e0 40             	and    $0x40,%eax
c01034c7:	85 c0                	test   %eax,%eax
c01034c9:	0f 95 c0             	setne  %al
c01034cc:	0f b6 c8             	movzbl %al,%ecx
c01034cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034d2:	8b 00                	mov    (%eax),%eax
c01034d4:	83 e0 20             	and    $0x20,%eax
c01034d7:	85 c0                	test   %eax,%eax
c01034d9:	0f 95 c0             	setne  %al
c01034dc:	0f b6 d0             	movzbl %al,%edx
c01034df:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034e2:	8b 40 1c             	mov    0x1c(%eax),%eax
c01034e5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01034e9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01034ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01034f1:	c7 04 24 60 9c 10 c0 	movl   $0xc0109c60,(%esp)
c01034f8:	e8 a4 cd ff ff       	call   c01002a1 <cprintf>
c01034fd:	e9 df 01 00 00       	jmp    c01036e1 <_extended_clock_swap_out_victim+0x412>
    	 }
    	 else if (!accessed && dirty) {//如果A为0，D为1 ，则D变为0；
c0103502:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0103506:	75 7c                	jne    c0103584 <_extended_clock_swap_out_victim+0x2b5>
c0103508:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010350c:	74 76                	je     c0103584 <_extended_clock_swap_out_victim+0x2b5>
    		 cprintf("clock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, accessed, dirty);
c010350e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103511:	8b 40 1c             	mov    0x1c(%eax),%eax
c0103514:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103517:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010351b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010351e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0103522:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103526:	c7 04 24 30 9c 10 c0 	movl   $0xc0109c30,(%esp)
c010352d:	e8 6f cd ff ff       	call   c01002a1 <cprintf>
    		 (*pte) = (*pte) & (~PTE_D);
c0103532:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103535:	8b 00                	mov    (%eax),%eax
c0103537:	83 e0 bf             	and    $0xffffffbf,%eax
c010353a:	89 c2                	mov    %eax,%edx
c010353c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010353f:	89 10                	mov    %edx,(%eax)
    		 cprintf("\tclock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, (*pte)&(PTE_A)?1:0, (*pte)&(PTE_D)?1:0);
c0103541:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103544:	8b 00                	mov    (%eax),%eax
c0103546:	83 e0 40             	and    $0x40,%eax
c0103549:	85 c0                	test   %eax,%eax
c010354b:	0f 95 c0             	setne  %al
c010354e:	0f b6 c8             	movzbl %al,%ecx
c0103551:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103554:	8b 00                	mov    (%eax),%eax
c0103556:	83 e0 20             	and    $0x20,%eax
c0103559:	85 c0                	test   %eax,%eax
c010355b:	0f 95 c0             	setne  %al
c010355e:	0f b6 d0             	movzbl %al,%edx
c0103561:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103564:	8b 40 1c             	mov    0x1c(%eax),%eax
c0103567:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010356b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010356f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103573:	c7 04 24 60 9c 10 c0 	movl   $0xc0109c60,(%esp)
c010357a:	e8 22 cd ff ff       	call   c01002a1 <cprintf>
c010357f:	e9 5d 01 00 00       	jmp    c01036e1 <_extended_clock_swap_out_victim+0x412>
    	 } else if (!accessed && !dirty){//如果都为0，则置换此页，且clock_p指针下移一位；
c0103584:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0103588:	0f 85 53 01 00 00    	jne    c01036e1 <_extended_clock_swap_out_victim+0x412>
c010358e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0103592:	0f 85 49 01 00 00    	jne    c01036e1 <_extended_clock_swap_out_victim+0x412>
    	     struct Page *p = le2page(le, pra_page_link);
c0103598:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010359b:	83 e8 14             	sub    $0x14,%eax
c010359e:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01035a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035a4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    __list_del(listelm->prev, listelm->next);
c01035a7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01035aa:	8b 40 04             	mov    0x4(%eax),%eax
c01035ad:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01035b0:	8b 12                	mov    (%edx),%edx
c01035b2:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c01035b5:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01035b8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01035bb:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01035be:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01035c1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01035c4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01035c7:	89 10                	mov    %edx,(%eax)
    	     list_del(le);
    	     clock_p = clock_p->next;
c01035c9:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c01035ce:	8b 40 04             	mov    0x4(%eax),%eax
c01035d1:	a3 18 50 12 c0       	mov    %eax,0xc0125018
    	     assert(p !=NULL);
c01035d6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01035da:	75 24                	jne    c0103600 <_extended_clock_swap_out_victim+0x331>
c01035dc:	c7 44 24 0c 81 9c 10 	movl   $0xc0109c81,0xc(%esp)
c01035e3:	c0 
c01035e4:	c7 44 24 08 ce 9b 10 	movl   $0xc0109bce,0x8(%esp)
c01035eb:	c0 
c01035ec:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01035f3:	00 
c01035f4:	c7 04 24 e3 9b 10 c0 	movl   $0xc0109be3,(%esp)
c01035fb:	e8 f8 cd ff ff       	call   c01003f8 <__panic>
    	     *ptr_page = p;
c0103600:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103603:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103606:	89 10                	mov    %edx,(%eax)

			 le = head->next;
c0103608:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010360b:	8b 40 04             	mov    0x4(%eax),%eax
c010360e:	89 45 f4             	mov    %eax,-0xc(%ebp)
			 cprintf("\n--after--start---\n");
c0103611:	c7 04 24 8a 9c 10 c0 	movl   $0xc0109c8a,(%esp)
c0103618:	e8 84 cc ff ff       	call   c01002a1 <cprintf>
			 while (1) {
				 struct Page *page = le2page(le, pra_page_link);
c010361d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103620:	83 e8 14             	sub    $0x14,%eax
c0103623:	89 45 c8             	mov    %eax,-0x38(%ebp)
				 pte_t * pte = get_pte(mm->pgdir, page->pra_vaddr, 0);
c0103626:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103629:	8b 50 1c             	mov    0x1c(%eax),%edx
c010362c:	8b 45 08             	mov    0x8(%ebp),%eax
c010362f:	8b 40 0c             	mov    0xc(%eax),%eax
c0103632:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103639:	00 
c010363a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010363e:	89 04 24             	mov    %eax,(%esp)
c0103641:	e8 11 3d 00 00       	call   c0107357 <get_pte>
c0103646:	89 45 c4             	mov    %eax,-0x3c(%ebp)
				 int accessed = (*pte)&(PTE_A)?1:0;
c0103649:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010364c:	8b 00                	mov    (%eax),%eax
c010364e:	83 e0 20             	and    $0x20,%eax
c0103651:	85 c0                	test   %eax,%eax
c0103653:	0f 95 c0             	setne  %al
c0103656:	0f b6 c0             	movzbl %al,%eax
c0103659:	89 45 c0             	mov    %eax,-0x40(%ebp)
				 int dirty = (*pte)&(PTE_D)?1:0;
c010365c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010365f:	8b 00                	mov    (%eax),%eax
c0103661:	83 e0 40             	and    $0x40,%eax
c0103664:	85 c0                	test   %eax,%eax
c0103666:	0f 95 c0             	setne  %al
c0103669:	0f b6 c0             	movzbl %al,%eax
c010366c:	89 45 bc             	mov    %eax,-0x44(%ebp)
				 if (le==clock_p)
c010366f:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c0103674:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103677:	75 0e                	jne    c0103687 <_extended_clock_swap_out_victim+0x3b8>
					 cprintf("->");
c0103679:	c7 04 24 27 9c 10 c0 	movl   $0xc0109c27,(%esp)
c0103680:	e8 1c cc ff ff       	call   c01002a1 <cprintf>
c0103685:	eb 0c                	jmp    c0103693 <_extended_clock_swap_out_victim+0x3c4>
				 else
					 cprintf("  ");
c0103687:	c7 04 24 2a 9c 10 c0 	movl   $0xc0109c2a,(%esp)
c010368e:	e8 0e cc ff ff       	call   c01002a1 <cprintf>
				 cprintf("clock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, accessed, dirty);
c0103693:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103696:	8b 40 1c             	mov    0x1c(%eax),%eax
c0103699:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010369c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01036a0:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01036a3:	89 54 24 08          	mov    %edx,0x8(%esp)
c01036a7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01036ab:	c7 04 24 30 9c 10 c0 	movl   $0xc0109c30,(%esp)
c01036b2:	e8 ea cb ff ff       	call   c01002a1 <cprintf>
				 le = le->next;
c01036b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ba:	8b 40 04             	mov    0x4(%eax),%eax
c01036bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
				 if (le == head) {
c01036c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01036c6:	75 14                	jne    c01036dc <_extended_clock_swap_out_victim+0x40d>
					 break;
c01036c8:	90                   	nop
				 }
			 }
			 cprintf("--after--end----\n");
c01036c9:	c7 04 24 9e 9c 10 c0 	movl   $0xc0109c9e,(%esp)
c01036d0:	e8 cc cb ff ff       	call   c01002a1 <cprintf>
    	     return 0;
c01036d5:	b8 00 00 00 00       	mov    $0x0,%eax
c01036da:	eb 20                	jmp    c01036fc <_extended_clock_swap_out_victim+0x42d>
			 }
c01036dc:	e9 3c ff ff ff       	jmp    c010361d <_extended_clock_swap_out_victim+0x34e>
    	 }
    	 le = le->next;
c01036e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036e4:	8b 40 04             	mov    0x4(%eax),%eax
c01036e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	 clock_p = clock_p->next;
c01036ea:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c01036ef:	8b 40 04             	mov    0x4(%eax),%eax
c01036f2:	a3 18 50 12 c0       	mov    %eax,0xc0125018
     }
c01036f7:	e9 1a fd ff ff       	jmp    c0103416 <_extended_clock_swap_out_victim+0x147>

}
c01036fc:	c9                   	leave  
c01036fd:	c3                   	ret    

c01036fe <_extended_clock_check_swap>:

static int
_extended_clock_check_swap(void) {
c01036fe:	55                   	push   %ebp
c01036ff:	89 e5                	mov    %esp,%ebp
c0103701:	83 ec 28             	sub    $0x28,%esp
    //初始状态置入了abcd四页，然后进行了写e，读c，写d，读a，写b，
    //写e，写c，写e，读c，写e，写a，写a，读b，读c，读d，写e，读a，写b，写e 这些操作
	unsigned char tmp;
	cprintf("write Virt Page e in extended_clock_check_swap\n");
c0103704:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c010370b:	e8 91 cb ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x1e;
c0103710:	b8 00 50 00 00       	mov    $0x5000,%eax
c0103715:	c6 00 1e             	movb   $0x1e,(%eax)
	
	
    cprintf("read Virt Page c in extended_clock_check_swap\n");
c0103718:	c7 04 24 e0 9c 10 c0 	movl   $0xc0109ce0,(%esp)
c010371f:	e8 7d cb ff ff       	call   c01002a1 <cprintf>
    tmp = *(unsigned char *)0x3000;
c0103724:	b8 00 30 00 00       	mov    $0x3000,%eax
c0103729:	0f b6 00             	movzbl (%eax),%eax
c010372c:	88 45 f7             	mov    %al,-0x9(%ebp)
    //cprintf("tmp = 0x%4x\n", tmp);
	
    cprintf("write Virt Page d in extended_clock_check_swap\n");
c010372f:	c7 04 24 10 9d 10 c0 	movl   $0xc0109d10,(%esp)
c0103736:	e8 66 cb ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x4000 = 0x0a;
c010373b:	b8 00 40 00 00       	mov    $0x4000,%eax
c0103740:	c6 00 0a             	movb   $0xa,(%eax)

    cprintf("read Virt Page a in extended_clock_check_swap\n");
c0103743:	c7 04 24 40 9d 10 c0 	movl   $0xc0109d40,(%esp)
c010374a:	e8 52 cb ff ff       	call   c01002a1 <cprintf>
    tmp = *(unsigned char *)0x1000;
c010374f:	b8 00 10 00 00       	mov    $0x1000,%eax
c0103754:	0f b6 00             	movzbl (%eax),%eax
c0103757:	88 45 f7             	mov    %al,-0x9(%ebp)
    //cprintf("tmp = 0x%4x\n", tmp);

	
    cprintf("write Virt Page b in extended_clock_check_swap\n");
c010375a:	c7 04 24 70 9d 10 c0 	movl   $0xc0109d70,(%esp)
c0103761:	e8 3b cb ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0103766:	b8 00 20 00 00       	mov    $0x2000,%eax
c010376b:	c6 00 0b             	movb   $0xb,(%eax)

    cprintf("write Virt Page e in extended_clock_check_swap\n");
c010376e:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103775:	e8 27 cb ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x1e;
c010377a:	b8 00 50 00 00       	mov    $0x5000,%eax
c010377f:	c6 00 1e             	movb   $0x1e,(%eax)
	
	cprintf("write Virt Page c in extended_clock_check_swap\n");
c0103782:	c7 04 24 a0 9d 10 c0 	movl   $0xc0109da0,(%esp)
c0103789:	e8 13 cb ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x3000 = 0x0e;
c010378e:	b8 00 30 00 00       	mov    $0x3000,%eax
c0103793:	c6 00 0e             	movb   $0xe,(%eax)
	
	cprintf("write Virt Page e in extended_clock_check_swap\n");
c0103796:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c010379d:	e8 ff ca ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x2e;
c01037a2:	b8 00 50 00 00       	mov    $0x5000,%eax
c01037a7:	c6 00 2e             	movb   $0x2e,(%eax)
	
	cprintf("read Virt Page c in extended_clock_check_swap\n");
c01037aa:	c7 04 24 e0 9c 10 c0 	movl   $0xc0109ce0,(%esp)
c01037b1:	e8 eb ca ff ff       	call   c01002a1 <cprintf>
    tmp = *(unsigned char *)0x3000;
c01037b6:	b8 00 30 00 00       	mov    $0x3000,%eax
c01037bb:	0f b6 00             	movzbl (%eax),%eax
c01037be:	88 45 f7             	mov    %al,-0x9(%ebp)
	
	cprintf("write Virt Page e in extended_clock_check_swap\n");
c01037c1:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c01037c8:	e8 d4 ca ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x2e;
c01037cd:	b8 00 50 00 00       	mov    $0x5000,%eax
c01037d2:	c6 00 2e             	movb   $0x2e,(%eax)
	//cprintf("--------\n");
	cprintf("write Virt Page a in extended_clock_check_swap\n");
c01037d5:	c7 04 24 d0 9d 10 c0 	movl   $0xc0109dd0,(%esp)
c01037dc:	e8 c0 ca ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x1000 = 0x1a;
c01037e1:	b8 00 10 00 00       	mov    $0x1000,%eax
c01037e6:	c6 00 1a             	movb   $0x1a,(%eax)
	cprintf("write Virt Page a in extended_clock_check_swap\n");
c01037e9:	c7 04 24 d0 9d 10 c0 	movl   $0xc0109dd0,(%esp)
c01037f0:	e8 ac ca ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x1000 = 0x1a;
c01037f5:	b8 00 10 00 00       	mov    $0x1000,%eax
c01037fa:	c6 00 1a             	movb   $0x1a,(%eax)
    
	//cprintf("--------\n");
    cprintf("read Virt Page b in extended_clock_check_swap\n");
c01037fd:	c7 04 24 00 9e 10 c0 	movl   $0xc0109e00,(%esp)
c0103804:	e8 98 ca ff ff       	call   c01002a1 <cprintf>
    tmp = *(unsigned char *)0x2000;
c0103809:	b8 00 20 00 00       	mov    $0x2000,%eax
c010380e:	0f b6 00             	movzbl (%eax),%eax
c0103811:	88 45 f7             	mov    %al,-0x9(%ebp)
    //cprintf("tmp = 0x%4x\n", tmp);
	//cprintf("--------\n");

    cprintf("read Virt Page c in extended_clock_check_swap\n");
c0103814:	c7 04 24 e0 9c 10 c0 	movl   $0xc0109ce0,(%esp)
c010381b:	e8 81 ca ff ff       	call   c01002a1 <cprintf>
    tmp = *(unsigned char *)0x3000;
c0103820:	b8 00 30 00 00       	mov    $0x3000,%eax
c0103825:	0f b6 00             	movzbl (%eax),%eax
c0103828:	88 45 f7             	mov    %al,-0x9(%ebp)
    //cprintf("tmp = 0x%4x\n", tmp);

    cprintf("read Virt Page d in extended_clock_check_swap\n");
c010382b:	c7 04 24 30 9e 10 c0 	movl   $0xc0109e30,(%esp)
c0103832:	e8 6a ca ff ff       	call   c01002a1 <cprintf>
    tmp = *(unsigned char *)0x4000;
c0103837:	b8 00 40 00 00       	mov    $0x4000,%eax
c010383c:	0f b6 00             	movzbl (%eax),%eax
c010383f:	88 45 f7             	mov    %al,-0x9(%ebp)
    //cprintf("tmp = 0x%4x\n", tmp);

    cprintf("write Virt Page e in extended_clock_check_swap\n");
c0103842:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103849:	e8 53 ca ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c010384e:	b8 00 50 00 00       	mov    $0x5000,%eax
c0103853:	c6 00 0e             	movb   $0xe,(%eax)

    cprintf("read Virt Page a in extended_clock_check_swap\n");
c0103856:	c7 04 24 40 9d 10 c0 	movl   $0xc0109d40,(%esp)
c010385d:	e8 3f ca ff ff       	call   c01002a1 <cprintf>
    tmp = *(unsigned char *)0x1000;
c0103862:	b8 00 10 00 00       	mov    $0x1000,%eax
c0103867:	0f b6 00             	movzbl (%eax),%eax
c010386a:	88 45 f7             	mov    %al,-0x9(%ebp)
    //cprintf("tmp = 0x%4x\n", tmp);

    cprintf("write Virt Page b in extended_clock_check_swap\n");
c010386d:	c7 04 24 70 9d 10 c0 	movl   $0xc0109d70,(%esp)
c0103874:	e8 28 ca ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0103879:	b8 00 20 00 00       	mov    $0x2000,%eax
c010387e:	c6 00 0b             	movb   $0xb,(%eax)

    cprintf("write Virt Page e in extended_clock_check_swap\n");
c0103881:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103888:	e8 14 ca ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c010388d:	b8 00 50 00 00       	mov    $0x5000,%eax
c0103892:	c6 00 0e             	movb   $0xe,(%eax)


    return 0;
c0103895:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010389a:	c9                   	leave  
c010389b:	c3                   	ret    

c010389c <_extended_clock_init>:


static int
_extended_clock_init(void)
{
c010389c:	55                   	push   %ebp
c010389d:	89 e5                	mov    %esp,%ebp
    return 0;
c010389f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01038a4:	5d                   	pop    %ebp
c01038a5:	c3                   	ret    

c01038a6 <_extended_clock_set_unswappable>:

static int
_extended_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01038a6:	55                   	push   %ebp
c01038a7:	89 e5                	mov    %esp,%ebp
    return 0;
c01038a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01038ae:	5d                   	pop    %ebp
c01038af:	c3                   	ret    

c01038b0 <_extended_clock_tick_event>:

static int
_extended_clock_tick_event(struct mm_struct *mm)
{ return 0; }
c01038b0:	55                   	push   %ebp
c01038b1:	89 e5                	mov    %esp,%ebp
c01038b3:	b8 00 00 00 00       	mov    $0x0,%eax
c01038b8:	5d                   	pop    %ebp
c01038b9:	c3                   	ret    

c01038ba <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c01038ba:	55                   	push   %ebp
c01038bb:	89 e5                	mov    %esp,%ebp
c01038bd:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01038c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01038c3:	c1 e8 0c             	shr    $0xc,%eax
c01038c6:	89 c2                	mov    %eax,%edx
c01038c8:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01038cd:	39 c2                	cmp    %eax,%edx
c01038cf:	72 1c                	jb     c01038ed <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01038d1:	c7 44 24 08 7c 9e 10 	movl   $0xc0109e7c,0x8(%esp)
c01038d8:	c0 
c01038d9:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01038e0:	00 
c01038e1:	c7 04 24 9b 9e 10 c0 	movl   $0xc0109e9b,(%esp)
c01038e8:	e8 0b cb ff ff       	call   c01003f8 <__panic>
    }
    return &pages[PPN(pa)];
c01038ed:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c01038f2:	8b 55 08             	mov    0x8(%ebp),%edx
c01038f5:	c1 ea 0c             	shr    $0xc,%edx
c01038f8:	c1 e2 05             	shl    $0x5,%edx
c01038fb:	01 d0                	add    %edx,%eax
}
c01038fd:	c9                   	leave  
c01038fe:	c3                   	ret    

c01038ff <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c01038ff:	55                   	push   %ebp
c0103900:	89 e5                	mov    %esp,%ebp
c0103902:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103905:	8b 45 08             	mov    0x8(%ebp),%eax
c0103908:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010390d:	89 04 24             	mov    %eax,(%esp)
c0103910:	e8 a5 ff ff ff       	call   c01038ba <pa2page>
}
c0103915:	c9                   	leave  
c0103916:	c3                   	ret    

c0103917 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0103917:	55                   	push   %ebp
c0103918:	89 e5                	mov    %esp,%ebp
c010391a:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c010391d:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0103924:	e8 f9 4a 00 00       	call   c0108422 <kmalloc>
c0103929:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c010392c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103930:	74 58                	je     c010398a <mm_create+0x73>
        list_init(&(mm->mmap_list));
c0103932:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103935:	89 45 f0             	mov    %eax,-0x10(%ebp)
    elm->prev = elm->next = elm;
c0103938:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010393b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010393e:	89 50 04             	mov    %edx,0x4(%eax)
c0103941:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103944:	8b 50 04             	mov    0x4(%eax),%edx
c0103947:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010394a:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c010394c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010394f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0103956:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103959:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0103960:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103963:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c010396a:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c010396f:	85 c0                	test   %eax,%eax
c0103971:	74 0d                	je     c0103980 <mm_create+0x69>
c0103973:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103976:	89 04 24             	mov    %eax,(%esp)
c0103979:	e8 c5 0d 00 00       	call   c0104743 <swap_init_mm>
c010397e:	eb 0a                	jmp    c010398a <mm_create+0x73>
        else mm->sm_priv = NULL;
c0103980:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103983:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c010398a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010398d:	c9                   	leave  
c010398e:	c3                   	ret    

c010398f <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c010398f:	55                   	push   %ebp
c0103990:	89 e5                	mov    %esp,%ebp
c0103992:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0103995:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c010399c:	e8 81 4a 00 00       	call   c0108422 <kmalloc>
c01039a1:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c01039a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01039a8:	74 1b                	je     c01039c5 <vma_create+0x36>
        vma->vm_start = vm_start;
c01039aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039ad:	8b 55 08             	mov    0x8(%ebp),%edx
c01039b0:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c01039b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039b6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01039b9:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c01039bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039bf:	8b 55 10             	mov    0x10(%ebp),%edx
c01039c2:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c01039c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01039c8:	c9                   	leave  
c01039c9:	c3                   	ret    

c01039ca <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c01039ca:	55                   	push   %ebp
c01039cb:	89 e5                	mov    %esp,%ebp
c01039cd:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c01039d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c01039d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01039db:	0f 84 95 00 00 00    	je     c0103a76 <find_vma+0xac>
        vma = mm->mmap_cache;
c01039e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01039e4:	8b 40 08             	mov    0x8(%eax),%eax
c01039e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c01039ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01039ee:	74 16                	je     c0103a06 <find_vma+0x3c>
c01039f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01039f3:	8b 40 04             	mov    0x4(%eax),%eax
c01039f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01039f9:	77 0b                	ja     c0103a06 <find_vma+0x3c>
c01039fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01039fe:	8b 40 08             	mov    0x8(%eax),%eax
c0103a01:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103a04:	77 61                	ja     c0103a67 <find_vma+0x9d>
                bool found = 0;
c0103a06:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0103a0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a10:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a16:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0103a19:	eb 28                	jmp    c0103a43 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0103a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a1e:	83 e8 10             	sub    $0x10,%eax
c0103a21:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0103a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103a27:	8b 40 04             	mov    0x4(%eax),%eax
c0103a2a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103a2d:	77 14                	ja     c0103a43 <find_vma+0x79>
c0103a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103a32:	8b 40 08             	mov    0x8(%eax),%eax
c0103a35:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103a38:	76 09                	jbe    c0103a43 <find_vma+0x79>
                        found = 1;
c0103a3a:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0103a41:	eb 17                	jmp    c0103a5a <find_vma+0x90>
c0103a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a46:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return listelm->next;
c0103a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a4c:	8b 40 04             	mov    0x4(%eax),%eax
                while ((le = list_next(le)) != list) {
c0103a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a55:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103a58:	75 c1                	jne    c0103a1b <find_vma+0x51>
                    }
                }
                if (!found) {
c0103a5a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103a5e:	75 07                	jne    c0103a67 <find_vma+0x9d>
                    vma = NULL;
c0103a60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0103a67:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103a6b:	74 09                	je     c0103a76 <find_vma+0xac>
            mm->mmap_cache = vma;
c0103a6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a70:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103a73:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0103a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0103a79:	c9                   	leave  
c0103a7a:	c3                   	ret    

c0103a7b <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0103a7b:	55                   	push   %ebp
c0103a7c:	89 e5                	mov    %esp,%ebp
c0103a7e:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0103a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a84:	8b 50 04             	mov    0x4(%eax),%edx
c0103a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a8a:	8b 40 08             	mov    0x8(%eax),%eax
c0103a8d:	39 c2                	cmp    %eax,%edx
c0103a8f:	72 24                	jb     c0103ab5 <check_vma_overlap+0x3a>
c0103a91:	c7 44 24 0c a9 9e 10 	movl   $0xc0109ea9,0xc(%esp)
c0103a98:	c0 
c0103a99:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0103aa0:	c0 
c0103aa1:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0103aa8:	00 
c0103aa9:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0103ab0:	e8 43 c9 ff ff       	call   c01003f8 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0103ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ab8:	8b 50 08             	mov    0x8(%eax),%edx
c0103abb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103abe:	8b 40 04             	mov    0x4(%eax),%eax
c0103ac1:	39 c2                	cmp    %eax,%edx
c0103ac3:	76 24                	jbe    c0103ae9 <check_vma_overlap+0x6e>
c0103ac5:	c7 44 24 0c ec 9e 10 	movl   $0xc0109eec,0xc(%esp)
c0103acc:	c0 
c0103acd:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0103ad4:	c0 
c0103ad5:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0103adc:	00 
c0103add:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0103ae4:	e8 0f c9 ff ff       	call   c01003f8 <__panic>
    assert(next->vm_start < next->vm_end);
c0103ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103aec:	8b 50 04             	mov    0x4(%eax),%edx
c0103aef:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103af2:	8b 40 08             	mov    0x8(%eax),%eax
c0103af5:	39 c2                	cmp    %eax,%edx
c0103af7:	72 24                	jb     c0103b1d <check_vma_overlap+0xa2>
c0103af9:	c7 44 24 0c 0b 9f 10 	movl   $0xc0109f0b,0xc(%esp)
c0103b00:	c0 
c0103b01:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0103b08:	c0 
c0103b09:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0103b10:	00 
c0103b11:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0103b18:	e8 db c8 ff ff       	call   c01003f8 <__panic>
}
c0103b1d:	c9                   	leave  
c0103b1e:	c3                   	ret    

c0103b1f <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0103b1f:	55                   	push   %ebp
c0103b20:	89 e5                	mov    %esp,%ebp
c0103b22:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0103b25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b28:	8b 50 04             	mov    0x4(%eax),%edx
c0103b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b2e:	8b 40 08             	mov    0x8(%eax),%eax
c0103b31:	39 c2                	cmp    %eax,%edx
c0103b33:	72 24                	jb     c0103b59 <insert_vma_struct+0x3a>
c0103b35:	c7 44 24 0c 29 9f 10 	movl   $0xc0109f29,0xc(%esp)
c0103b3c:	c0 
c0103b3d:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0103b44:	c0 
c0103b45:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0103b4c:	00 
c0103b4d:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0103b54:	e8 9f c8 ff ff       	call   c01003f8 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0103b59:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0103b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b62:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0103b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0103b6b:	eb 21                	jmp    c0103b8e <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0103b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b70:	83 e8 10             	sub    $0x10,%eax
c0103b73:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0103b76:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b79:	8b 50 04             	mov    0x4(%eax),%edx
c0103b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b7f:	8b 40 04             	mov    0x4(%eax),%eax
c0103b82:	39 c2                	cmp    %eax,%edx
c0103b84:	76 02                	jbe    c0103b88 <insert_vma_struct+0x69>
                break;
c0103b86:	eb 1d                	jmp    c0103ba5 <insert_vma_struct+0x86>
            }
            le_prev = le;
c0103b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b91:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103b94:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103b97:	8b 40 04             	mov    0x4(%eax),%eax
        while ((le = list_next(le)) != list) {
c0103b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ba0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103ba3:	75 c8                	jne    c0103b6d <insert_vma_struct+0x4e>
c0103ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ba8:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103bab:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103bae:	8b 40 04             	mov    0x4(%eax),%eax
        }

    le_next = list_next(le_prev);
c0103bb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0103bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bb7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103bba:	74 15                	je     c0103bd1 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0103bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bbf:	8d 50 f0             	lea    -0x10(%eax),%edx
c0103bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103bc9:	89 14 24             	mov    %edx,(%esp)
c0103bcc:	e8 aa fe ff ff       	call   c0103a7b <check_vma_overlap>
    }
    if (le_next != list) {
c0103bd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bd4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103bd7:	74 15                	je     c0103bee <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0103bd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bdc:	83 e8 10             	sub    $0x10,%eax
c0103bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103be3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103be6:	89 04 24             	mov    %eax,(%esp)
c0103be9:	e8 8d fe ff ff       	call   c0103a7b <check_vma_overlap>
    }

    vma->vm_mm = mm;
c0103bee:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103bf1:	8b 55 08             	mov    0x8(%ebp),%edx
c0103bf4:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0103bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103bf9:	8d 50 10             	lea    0x10(%eax),%edx
c0103bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bff:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103c02:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0103c05:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103c08:	8b 40 04             	mov    0x4(%eax),%eax
c0103c0b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103c0e:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0103c11:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103c14:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103c17:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c0103c1a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103c1d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103c20:	89 10                	mov    %edx,(%eax)
c0103c22:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103c25:	8b 10                	mov    (%eax),%edx
c0103c27:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103c2a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103c2d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103c30:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103c33:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103c36:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103c39:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103c3c:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0103c3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c41:	8b 40 10             	mov    0x10(%eax),%eax
c0103c44:	8d 50 01             	lea    0x1(%eax),%edx
c0103c47:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c4a:	89 50 10             	mov    %edx,0x10(%eax)
}
c0103c4d:	c9                   	leave  
c0103c4e:	c3                   	ret    

c0103c4f <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0103c4f:	55                   	push   %ebp
c0103c50:	89 e5                	mov    %esp,%ebp
c0103c52:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0103c55:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0103c5b:	eb 3e                	jmp    c0103c9b <mm_destroy+0x4c>
c0103c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c60:	89 45 ec             	mov    %eax,-0x14(%ebp)
    __list_del(listelm->prev, listelm->next);
c0103c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c66:	8b 40 04             	mov    0x4(%eax),%eax
c0103c69:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103c6c:	8b 12                	mov    (%edx),%edx
c0103c6e:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0103c71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    prev->next = next;
c0103c74:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103c7a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103c7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c80:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0103c83:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c0103c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c88:	83 e8 10             	sub    $0x10,%eax
c0103c8b:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0103c92:	00 
c0103c93:	89 04 24             	mov    %eax,(%esp)
c0103c96:	e8 27 48 00 00       	call   c01084c2 <kfree>
c0103c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
c0103ca1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ca4:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(list)) != list) {
c0103ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103cb0:	75 ab                	jne    c0103c5d <mm_destroy+0xe>
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c0103cb2:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0103cb9:	00 
c0103cba:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cbd:	89 04 24             	mov    %eax,(%esp)
c0103cc0:	e8 fd 47 00 00       	call   c01084c2 <kfree>
    mm=NULL;
c0103cc5:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0103ccc:	c9                   	leave  
c0103ccd:	c3                   	ret    

c0103cce <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0103cce:	55                   	push   %ebp
c0103ccf:	89 e5                	mov    %esp,%ebp
c0103cd1:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0103cd4:	e8 02 00 00 00       	call   c0103cdb <check_vmm>
}
c0103cd9:	c9                   	leave  
c0103cda:	c3                   	ret    

c0103cdb <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0103cdb:	55                   	push   %ebp
c0103cdc:	89 e5                	mov    %esp,%ebp
c0103cde:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103ce1:	e8 2f 30 00 00       	call   c0106d15 <nr_free_pages>
c0103ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0103ce9:	e8 41 00 00 00       	call   c0103d2f <check_vma_struct>
    check_pgfault();
c0103cee:	e8 03 05 00 00       	call   c01041f6 <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c0103cf3:	e8 1d 30 00 00       	call   c0106d15 <nr_free_pages>
c0103cf8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103cfb:	74 24                	je     c0103d21 <check_vmm+0x46>
c0103cfd:	c7 44 24 0c 48 9f 10 	movl   $0xc0109f48,0xc(%esp)
c0103d04:	c0 
c0103d05:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0103d0c:	c0 
c0103d0d:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0103d14:	00 
c0103d15:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0103d1c:	e8 d7 c6 ff ff       	call   c01003f8 <__panic>

    cprintf("check_vmm() succeeded.\n");
c0103d21:	c7 04 24 6f 9f 10 c0 	movl   $0xc0109f6f,(%esp)
c0103d28:	e8 74 c5 ff ff       	call   c01002a1 <cprintf>
}
c0103d2d:	c9                   	leave  
c0103d2e:	c3                   	ret    

c0103d2f <check_vma_struct>:

static void
check_vma_struct(void) {
c0103d2f:	55                   	push   %ebp
c0103d30:	89 e5                	mov    %esp,%ebp
c0103d32:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103d35:	e8 db 2f 00 00       	call   c0106d15 <nr_free_pages>
c0103d3a:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0103d3d:	e8 d5 fb ff ff       	call   c0103917 <mm_create>
c0103d42:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0103d45:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103d49:	75 24                	jne    c0103d6f <check_vma_struct+0x40>
c0103d4b:	c7 44 24 0c 87 9f 10 	movl   $0xc0109f87,0xc(%esp)
c0103d52:	c0 
c0103d53:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0103d5a:	c0 
c0103d5b:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0103d62:	00 
c0103d63:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0103d6a:	e8 89 c6 ff ff       	call   c01003f8 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0103d6f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0103d76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103d79:	89 d0                	mov    %edx,%eax
c0103d7b:	c1 e0 02             	shl    $0x2,%eax
c0103d7e:	01 d0                	add    %edx,%eax
c0103d80:	01 c0                	add    %eax,%eax
c0103d82:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0103d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103d8b:	eb 70                	jmp    c0103dfd <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103d8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103d90:	89 d0                	mov    %edx,%eax
c0103d92:	c1 e0 02             	shl    $0x2,%eax
c0103d95:	01 d0                	add    %edx,%eax
c0103d97:	83 c0 02             	add    $0x2,%eax
c0103d9a:	89 c1                	mov    %eax,%ecx
c0103d9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103d9f:	89 d0                	mov    %edx,%eax
c0103da1:	c1 e0 02             	shl    $0x2,%eax
c0103da4:	01 d0                	add    %edx,%eax
c0103da6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103dad:	00 
c0103dae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103db2:	89 04 24             	mov    %eax,(%esp)
c0103db5:	e8 d5 fb ff ff       	call   c010398f <vma_create>
c0103dba:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0103dbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103dc1:	75 24                	jne    c0103de7 <check_vma_struct+0xb8>
c0103dc3:	c7 44 24 0c 92 9f 10 	movl   $0xc0109f92,0xc(%esp)
c0103dca:	c0 
c0103dcb:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0103dd2:	c0 
c0103dd3:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0103dda:	00 
c0103ddb:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0103de2:	e8 11 c6 ff ff       	call   c01003f8 <__panic>
        insert_vma_struct(mm, vma);
c0103de7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103dea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103dee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103df1:	89 04 24             	mov    %eax,(%esp)
c0103df4:	e8 26 fd ff ff       	call   c0103b1f <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
c0103df9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103dfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103e01:	7f 8a                	jg     c0103d8d <check_vma_struct+0x5e>
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0103e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e06:	83 c0 01             	add    $0x1,%eax
c0103e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103e0c:	eb 70                	jmp    c0103e7e <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103e0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103e11:	89 d0                	mov    %edx,%eax
c0103e13:	c1 e0 02             	shl    $0x2,%eax
c0103e16:	01 d0                	add    %edx,%eax
c0103e18:	83 c0 02             	add    $0x2,%eax
c0103e1b:	89 c1                	mov    %eax,%ecx
c0103e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103e20:	89 d0                	mov    %edx,%eax
c0103e22:	c1 e0 02             	shl    $0x2,%eax
c0103e25:	01 d0                	add    %edx,%eax
c0103e27:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103e2e:	00 
c0103e2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103e33:	89 04 24             	mov    %eax,(%esp)
c0103e36:	e8 54 fb ff ff       	call   c010398f <vma_create>
c0103e3b:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0103e3e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103e42:	75 24                	jne    c0103e68 <check_vma_struct+0x139>
c0103e44:	c7 44 24 0c 92 9f 10 	movl   $0xc0109f92,0xc(%esp)
c0103e4b:	c0 
c0103e4c:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0103e53:	c0 
c0103e54:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0103e5b:	00 
c0103e5c:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0103e63:	e8 90 c5 ff ff       	call   c01003f8 <__panic>
        insert_vma_struct(mm, vma);
c0103e68:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103e6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103e6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e72:	89 04 24             	mov    %eax,(%esp)
c0103e75:	e8 a5 fc ff ff       	call   c0103b1f <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
c0103e7a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e81:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103e84:	7e 88                	jle    c0103e0e <check_vma_struct+0xdf>
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0103e86:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e89:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e8c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e8f:	8b 40 04             	mov    0x4(%eax),%eax
c0103e92:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0103e95:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0103e9c:	e9 97 00 00 00       	jmp    c0103f38 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0103ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ea4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103ea7:	75 24                	jne    c0103ecd <check_vma_struct+0x19e>
c0103ea9:	c7 44 24 0c 9e 9f 10 	movl   $0xc0109f9e,0xc(%esp)
c0103eb0:	c0 
c0103eb1:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0103eb8:	c0 
c0103eb9:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103ec0:	00 
c0103ec1:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0103ec8:	e8 2b c5 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0103ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ed0:	83 e8 10             	sub    $0x10,%eax
c0103ed3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0103ed6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103ed9:	8b 48 04             	mov    0x4(%eax),%ecx
c0103edc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103edf:	89 d0                	mov    %edx,%eax
c0103ee1:	c1 e0 02             	shl    $0x2,%eax
c0103ee4:	01 d0                	add    %edx,%eax
c0103ee6:	39 c1                	cmp    %eax,%ecx
c0103ee8:	75 17                	jne    c0103f01 <check_vma_struct+0x1d2>
c0103eea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103eed:	8b 48 08             	mov    0x8(%eax),%ecx
c0103ef0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103ef3:	89 d0                	mov    %edx,%eax
c0103ef5:	c1 e0 02             	shl    $0x2,%eax
c0103ef8:	01 d0                	add    %edx,%eax
c0103efa:	83 c0 02             	add    $0x2,%eax
c0103efd:	39 c1                	cmp    %eax,%ecx
c0103eff:	74 24                	je     c0103f25 <check_vma_struct+0x1f6>
c0103f01:	c7 44 24 0c b8 9f 10 	movl   $0xc0109fb8,0xc(%esp)
c0103f08:	c0 
c0103f09:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0103f10:	c0 
c0103f11:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103f18:	00 
c0103f19:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0103f20:	e8 d3 c4 ff ff       	call   c01003f8 <__panic>
c0103f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f28:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0103f2b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f2e:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0103f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (i = 1; i <= step2; i ++) {
c0103f34:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f3b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103f3e:	0f 8e 5d ff ff ff    	jle    c0103ea1 <check_vma_struct+0x172>
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0103f44:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0103f4b:	e9 cd 01 00 00       	jmp    c010411d <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0103f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f57:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f5a:	89 04 24             	mov    %eax,(%esp)
c0103f5d:	e8 68 fa ff ff       	call   c01039ca <find_vma>
c0103f62:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0103f65:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0103f69:	75 24                	jne    c0103f8f <check_vma_struct+0x260>
c0103f6b:	c7 44 24 0c ed 9f 10 	movl   $0xc0109fed,0xc(%esp)
c0103f72:	c0 
c0103f73:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0103f7a:	c0 
c0103f7b:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0103f82:	00 
c0103f83:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0103f8a:	e8 69 c4 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0103f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f92:	83 c0 01             	add    $0x1,%eax
c0103f95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f99:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f9c:	89 04 24             	mov    %eax,(%esp)
c0103f9f:	e8 26 fa ff ff       	call   c01039ca <find_vma>
c0103fa4:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0103fa7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103fab:	75 24                	jne    c0103fd1 <check_vma_struct+0x2a2>
c0103fad:	c7 44 24 0c fa 9f 10 	movl   $0xc0109ffa,0xc(%esp)
c0103fb4:	c0 
c0103fb5:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0103fbc:	c0 
c0103fbd:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103fc4:	00 
c0103fc5:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0103fcc:	e8 27 c4 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0103fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fd4:	83 c0 02             	add    $0x2,%eax
c0103fd7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103fdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103fde:	89 04 24             	mov    %eax,(%esp)
c0103fe1:	e8 e4 f9 ff ff       	call   c01039ca <find_vma>
c0103fe6:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0103fe9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103fed:	74 24                	je     c0104013 <check_vma_struct+0x2e4>
c0103fef:	c7 44 24 0c 07 a0 10 	movl   $0xc010a007,0xc(%esp)
c0103ff6:	c0 
c0103ff7:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0103ffe:	c0 
c0103fff:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0104006:	00 
c0104007:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c010400e:	e8 e5 c3 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0104013:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104016:	83 c0 03             	add    $0x3,%eax
c0104019:	89 44 24 04          	mov    %eax,0x4(%esp)
c010401d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104020:	89 04 24             	mov    %eax,(%esp)
c0104023:	e8 a2 f9 ff ff       	call   c01039ca <find_vma>
c0104028:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c010402b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c010402f:	74 24                	je     c0104055 <check_vma_struct+0x326>
c0104031:	c7 44 24 0c 14 a0 10 	movl   $0xc010a014,0xc(%esp)
c0104038:	c0 
c0104039:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0104040:	c0 
c0104041:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0104048:	00 
c0104049:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0104050:	e8 a3 c3 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0104055:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104058:	83 c0 04             	add    $0x4,%eax
c010405b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010405f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104062:	89 04 24             	mov    %eax,(%esp)
c0104065:	e8 60 f9 ff ff       	call   c01039ca <find_vma>
c010406a:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c010406d:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0104071:	74 24                	je     c0104097 <check_vma_struct+0x368>
c0104073:	c7 44 24 0c 21 a0 10 	movl   $0xc010a021,0xc(%esp)
c010407a:	c0 
c010407b:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0104082:	c0 
c0104083:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c010408a:	00 
c010408b:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0104092:	e8 61 c3 ff ff       	call   c01003f8 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0104097:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010409a:	8b 50 04             	mov    0x4(%eax),%edx
c010409d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040a0:	39 c2                	cmp    %eax,%edx
c01040a2:	75 10                	jne    c01040b4 <check_vma_struct+0x385>
c01040a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040a7:	8b 50 08             	mov    0x8(%eax),%edx
c01040aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040ad:	83 c0 02             	add    $0x2,%eax
c01040b0:	39 c2                	cmp    %eax,%edx
c01040b2:	74 24                	je     c01040d8 <check_vma_struct+0x3a9>
c01040b4:	c7 44 24 0c 30 a0 10 	movl   $0xc010a030,0xc(%esp)
c01040bb:	c0 
c01040bc:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c01040c3:	c0 
c01040c4:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01040cb:	00 
c01040cc:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c01040d3:	e8 20 c3 ff ff       	call   c01003f8 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c01040d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01040db:	8b 50 04             	mov    0x4(%eax),%edx
c01040de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040e1:	39 c2                	cmp    %eax,%edx
c01040e3:	75 10                	jne    c01040f5 <check_vma_struct+0x3c6>
c01040e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01040e8:	8b 50 08             	mov    0x8(%eax),%edx
c01040eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040ee:	83 c0 02             	add    $0x2,%eax
c01040f1:	39 c2                	cmp    %eax,%edx
c01040f3:	74 24                	je     c0104119 <check_vma_struct+0x3ea>
c01040f5:	c7 44 24 0c 60 a0 10 	movl   $0xc010a060,0xc(%esp)
c01040fc:	c0 
c01040fd:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0104104:	c0 
c0104105:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c010410c:	00 
c010410d:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0104114:	e8 df c2 ff ff       	call   c01003f8 <__panic>
    for (i = 5; i <= 5 * step2; i +=5) {
c0104119:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c010411d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104120:	89 d0                	mov    %edx,%eax
c0104122:	c1 e0 02             	shl    $0x2,%eax
c0104125:	01 d0                	add    %edx,%eax
c0104127:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010412a:	0f 8d 20 fe ff ff    	jge    c0103f50 <check_vma_struct+0x221>
    }

    for (i =4; i>=0; i--) {
c0104130:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0104137:	eb 70                	jmp    c01041a9 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0104139:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010413c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104140:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104143:	89 04 24             	mov    %eax,(%esp)
c0104146:	e8 7f f8 ff ff       	call   c01039ca <find_vma>
c010414b:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c010414e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104152:	74 27                	je     c010417b <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0104154:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104157:	8b 50 08             	mov    0x8(%eax),%edx
c010415a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010415d:	8b 40 04             	mov    0x4(%eax),%eax
c0104160:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0104164:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104168:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010416b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010416f:	c7 04 24 90 a0 10 c0 	movl   $0xc010a090,(%esp)
c0104176:	e8 26 c1 ff ff       	call   c01002a1 <cprintf>
        }
        assert(vma_below_5 == NULL);
c010417b:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010417f:	74 24                	je     c01041a5 <check_vma_struct+0x476>
c0104181:	c7 44 24 0c b5 a0 10 	movl   $0xc010a0b5,0xc(%esp)
c0104188:	c0 
c0104189:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0104190:	c0 
c0104191:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0104198:	00 
c0104199:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c01041a0:	e8 53 c2 ff ff       	call   c01003f8 <__panic>
    for (i =4; i>=0; i--) {
c01041a5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01041a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01041ad:	79 8a                	jns    c0104139 <check_vma_struct+0x40a>
    }

    mm_destroy(mm);
c01041af:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041b2:	89 04 24             	mov    %eax,(%esp)
c01041b5:	e8 95 fa ff ff       	call   c0103c4f <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c01041ba:	e8 56 2b 00 00       	call   c0106d15 <nr_free_pages>
c01041bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01041c2:	74 24                	je     c01041e8 <check_vma_struct+0x4b9>
c01041c4:	c7 44 24 0c 48 9f 10 	movl   $0xc0109f48,0xc(%esp)
c01041cb:	c0 
c01041cc:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c01041d3:	c0 
c01041d4:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01041db:	00 
c01041dc:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c01041e3:	e8 10 c2 ff ff       	call   c01003f8 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c01041e8:	c7 04 24 cc a0 10 c0 	movl   $0xc010a0cc,(%esp)
c01041ef:	e8 ad c0 ff ff       	call   c01002a1 <cprintf>
}
c01041f4:	c9                   	leave  
c01041f5:	c3                   	ret    

c01041f6 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c01041f6:	55                   	push   %ebp
c01041f7:	89 e5                	mov    %esp,%ebp
c01041f9:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01041fc:	e8 14 2b 00 00       	call   c0106d15 <nr_free_pages>
c0104201:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0104204:	e8 0e f7 ff ff       	call   c0103917 <mm_create>
c0104209:	a3 1c 50 12 c0       	mov    %eax,0xc012501c
    assert(check_mm_struct != NULL);
c010420e:	a1 1c 50 12 c0       	mov    0xc012501c,%eax
c0104213:	85 c0                	test   %eax,%eax
c0104215:	75 24                	jne    c010423b <check_pgfault+0x45>
c0104217:	c7 44 24 0c eb a0 10 	movl   $0xc010a0eb,0xc(%esp)
c010421e:	c0 
c010421f:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0104226:	c0 
c0104227:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c010422e:	00 
c010422f:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0104236:	e8 bd c1 ff ff       	call   c01003f8 <__panic>

    struct mm_struct *mm = check_mm_struct;
c010423b:	a1 1c 50 12 c0       	mov    0xc012501c,%eax
c0104240:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0104243:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0104249:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010424c:	89 50 0c             	mov    %edx,0xc(%eax)
c010424f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104252:	8b 40 0c             	mov    0xc(%eax),%eax
c0104255:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0104258:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010425b:	8b 00                	mov    (%eax),%eax
c010425d:	85 c0                	test   %eax,%eax
c010425f:	74 24                	je     c0104285 <check_pgfault+0x8f>
c0104261:	c7 44 24 0c 03 a1 10 	movl   $0xc010a103,0xc(%esp)
c0104268:	c0 
c0104269:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0104270:	c0 
c0104271:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0104278:	00 
c0104279:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0104280:	e8 73 c1 ff ff       	call   c01003f8 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0104285:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c010428c:	00 
c010428d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0104294:	00 
c0104295:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010429c:	e8 ee f6 ff ff       	call   c010398f <vma_create>
c01042a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c01042a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01042a8:	75 24                	jne    c01042ce <check_pgfault+0xd8>
c01042aa:	c7 44 24 0c 92 9f 10 	movl   $0xc0109f92,0xc(%esp)
c01042b1:	c0 
c01042b2:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c01042b9:	c0 
c01042ba:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01042c1:	00 
c01042c2:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c01042c9:	e8 2a c1 ff ff       	call   c01003f8 <__panic>

    insert_vma_struct(mm, vma);
c01042ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01042d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042d8:	89 04 24             	mov    %eax,(%esp)
c01042db:	e8 3f f8 ff ff       	call   c0103b1f <insert_vma_struct>

    uintptr_t addr = 0x100;
c01042e0:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c01042e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01042ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042f1:	89 04 24             	mov    %eax,(%esp)
c01042f4:	e8 d1 f6 ff ff       	call   c01039ca <find_vma>
c01042f9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01042fc:	74 24                	je     c0104322 <check_pgfault+0x12c>
c01042fe:	c7 44 24 0c 11 a1 10 	movl   $0xc010a111,0xc(%esp)
c0104305:	c0 
c0104306:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c010430d:	c0 
c010430e:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0104315:	00 
c0104316:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c010431d:	e8 d6 c0 ff ff       	call   c01003f8 <__panic>

    int i, sum = 0;
c0104322:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0104329:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104330:	eb 17                	jmp    c0104349 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0104332:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104335:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104338:	01 d0                	add    %edx,%eax
c010433a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010433d:	88 10                	mov    %dl,(%eax)
        sum += i;
c010433f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104342:	01 45 f0             	add    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0104345:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104349:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010434d:	7e e3                	jle    c0104332 <check_pgfault+0x13c>
    }
    for (i = 0; i < 100; i ++) {
c010434f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104356:	eb 15                	jmp    c010436d <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0104358:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010435b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010435e:	01 d0                	add    %edx,%eax
c0104360:	0f b6 00             	movzbl (%eax),%eax
c0104363:	0f be c0             	movsbl %al,%eax
c0104366:	29 45 f0             	sub    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0104369:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010436d:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0104371:	7e e5                	jle    c0104358 <check_pgfault+0x162>
    }
    assert(sum == 0);
c0104373:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104377:	74 24                	je     c010439d <check_pgfault+0x1a7>
c0104379:	c7 44 24 0c 2b a1 10 	movl   $0xc010a12b,0xc(%esp)
c0104380:	c0 
c0104381:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0104388:	c0 
c0104389:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104390:	00 
c0104391:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0104398:	e8 5b c0 ff ff       	call   c01003f8 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c010439d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01043a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01043ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01043af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043b2:	89 04 24             	mov    %eax,(%esp)
c01043b5:	e8 8f 31 00 00       	call   c0107549 <page_remove>
    free_page(pde2page(pgdir[0]));
c01043ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043bd:	8b 00                	mov    (%eax),%eax
c01043bf:	89 04 24             	mov    %eax,(%esp)
c01043c2:	e8 38 f5 ff ff       	call   c01038ff <pde2page>
c01043c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01043ce:	00 
c01043cf:	89 04 24             	mov    %eax,(%esp)
c01043d2:	e8 0c 29 00 00       	call   c0106ce3 <free_pages>
    pgdir[0] = 0;
c01043d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c01043e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c01043ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043ed:	89 04 24             	mov    %eax,(%esp)
c01043f0:	e8 5a f8 ff ff       	call   c0103c4f <mm_destroy>
    check_mm_struct = NULL;
c01043f5:	c7 05 1c 50 12 c0 00 	movl   $0x0,0xc012501c
c01043fc:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c01043ff:	e8 11 29 00 00       	call   c0106d15 <nr_free_pages>
c0104404:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104407:	74 24                	je     c010442d <check_pgfault+0x237>
c0104409:	c7 44 24 0c 48 9f 10 	movl   $0xc0109f48,0xc(%esp)
c0104410:	c0 
c0104411:	c7 44 24 08 c7 9e 10 	movl   $0xc0109ec7,0x8(%esp)
c0104418:	c0 
c0104419:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0104420:	00 
c0104421:	c7 04 24 dc 9e 10 c0 	movl   $0xc0109edc,(%esp)
c0104428:	e8 cb bf ff ff       	call   c01003f8 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c010442d:	c7 04 24 34 a1 10 c0 	movl   $0xc010a134,(%esp)
c0104434:	e8 68 be ff ff       	call   c01002a1 <cprintf>
}
c0104439:	c9                   	leave  
c010443a:	c3                   	ret    

c010443b <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c010443b:	55                   	push   %ebp
c010443c:	89 e5                	mov    %esp,%ebp
c010443e:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0104441:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0104448:	8b 45 10             	mov    0x10(%ebp),%eax
c010444b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010444f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104452:	89 04 24             	mov    %eax,(%esp)
c0104455:	e8 70 f5 ff ff       	call   c01039ca <find_vma>
c010445a:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c010445d:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104462:	83 c0 01             	add    $0x1,%eax
c0104465:	a3 64 4f 12 c0       	mov    %eax,0xc0124f64
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c010446a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010446e:	74 0b                	je     c010447b <do_pgfault+0x40>
c0104470:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104473:	8b 40 04             	mov    0x4(%eax),%eax
c0104476:	3b 45 10             	cmp    0x10(%ebp),%eax
c0104479:	76 18                	jbe    c0104493 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c010447b:	8b 45 10             	mov    0x10(%ebp),%eax
c010447e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104482:	c7 04 24 50 a1 10 c0 	movl   $0xc010a150,(%esp)
c0104489:	e8 13 be ff ff       	call   c01002a1 <cprintf>
        goto failed;
c010448e:	e9 98 01 00 00       	jmp    c010462b <do_pgfault+0x1f0>
    }
    //check the error_code
    switch (error_code & 3) {
c0104493:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104496:	83 e0 03             	and    $0x3,%eax
c0104499:	85 c0                	test   %eax,%eax
c010449b:	74 36                	je     c01044d3 <do_pgfault+0x98>
c010449d:	83 f8 01             	cmp    $0x1,%eax
c01044a0:	74 20                	je     c01044c2 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c01044a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044a5:	8b 40 0c             	mov    0xc(%eax),%eax
c01044a8:	83 e0 02             	and    $0x2,%eax
c01044ab:	85 c0                	test   %eax,%eax
c01044ad:	75 11                	jne    c01044c0 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c01044af:	c7 04 24 80 a1 10 c0 	movl   $0xc010a180,(%esp)
c01044b6:	e8 e6 bd ff ff       	call   c01002a1 <cprintf>
            goto failed;
c01044bb:	e9 6b 01 00 00       	jmp    c010462b <do_pgfault+0x1f0>
        }
        break;
c01044c0:	eb 2f                	jmp    c01044f1 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c01044c2:	c7 04 24 e0 a1 10 c0 	movl   $0xc010a1e0,(%esp)
c01044c9:	e8 d3 bd ff ff       	call   c01002a1 <cprintf>
        goto failed;
c01044ce:	e9 58 01 00 00       	jmp    c010462b <do_pgfault+0x1f0>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c01044d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044d6:	8b 40 0c             	mov    0xc(%eax),%eax
c01044d9:	83 e0 05             	and    $0x5,%eax
c01044dc:	85 c0                	test   %eax,%eax
c01044de:	75 11                	jne    c01044f1 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c01044e0:	c7 04 24 18 a2 10 c0 	movl   $0xc010a218,(%esp)
c01044e7:	e8 b5 bd ff ff       	call   c01002a1 <cprintf>
            goto failed;
c01044ec:	e9 3a 01 00 00       	jmp    c010462b <do_pgfault+0x1f0>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c01044f1:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c01044f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044fb:	8b 40 0c             	mov    0xc(%eax),%eax
c01044fe:	83 e0 02             	and    $0x2,%eax
c0104501:	85 c0                	test   %eax,%eax
c0104503:	74 04                	je     c0104509 <do_pgfault+0xce>
        perm |= PTE_W;
c0104505:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0104509:	8b 45 10             	mov    0x10(%ebp),%eax
c010450c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010450f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104512:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104517:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c010451a:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0104521:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    * VARIABLES:
    *   mm->pgdir : the PDT of these vma
    *
    */
    /*LAB3 EXERCISE 1: YOUR CODE*/
ptep = get_pte(mm->pgdir,addr,1);//(1) 根据引发缺页异常的地址 去找到 地址所对应的 PTE 如果找不到 则创建一页表
c0104528:	8b 45 08             	mov    0x8(%ebp),%eax
c010452b:	8b 40 0c             	mov    0xc(%eax),%eax
c010452e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104535:	00 
c0104536:	8b 55 10             	mov    0x10(%ebp),%edx
c0104539:	89 54 24 04          	mov    %edx,0x4(%esp)
c010453d:	89 04 24             	mov    %eax,(%esp)
c0104540:	e8 12 2e 00 00       	call   c0107357 <get_pte>
c0104545:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (*ptep == 0) {//(2) PTE 所指向的 物理页表地址 若不存在 则分配一物理页并将逻辑地址和物理地址作映射 (就是让 PTE 指向 物理页帧)
c0104548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010454b:	8b 00                	mov    (%eax),%eax
c010454d:	85 c0                	test   %eax,%eax
c010454f:	75 29                	jne    c010457a <do_pgfault+0x13f>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c0104551:	8b 45 08             	mov    0x8(%ebp),%eax
c0104554:	8b 40 0c             	mov    0xc(%eax),%eax
c0104557:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010455a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010455e:	8b 55 10             	mov    0x10(%ebp),%edx
c0104561:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104565:	89 04 24             	mov    %eax,(%esp)
c0104568:	e8 36 31 00 00       	call   c01076a3 <pgdir_alloc_page>
c010456d:	85 c0                	test   %eax,%eax
c010456f:	0f 85 af 00 00 00    	jne    c0104624 <do_pgfault+0x1e9>
            goto failed;
c0104575:	e9 b1 00 00 00       	jmp    c010462b <do_pgfault+0x1f0>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok) {// 是否可以换入页面
c010457a:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c010457f:	85 c0                	test   %eax,%eax
c0104581:	0f 84 86 00 00 00    	je     c010460d <do_pgfault+0x1d2>
            struct Page *page=NULL;
c0104587:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            ret = swap_in(mm, addr, &page); //(1）根据 PTE 找到 换出那页所在的硬盘地址 并将其从外存中换入
c010458e:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0104591:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104595:	8b 45 10             	mov    0x10(%ebp),%eax
c0104598:	89 44 24 04          	mov    %eax,0x4(%esp)
c010459c:	8b 45 08             	mov    0x8(%ebp),%eax
c010459f:	89 04 24             	mov    %eax,(%esp)
c01045a2:	e8 95 03 00 00       	call   c010493c <swap_in>
c01045a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c01045aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045ae:	74 0e                	je     c01045be <do_pgfault+0x183>
                cprintf("swap_in in do_pgfault failed\n");
c01045b0:	c7 04 24 7b a2 10 c0 	movl   $0xc010a27b,(%esp)
c01045b7:	e8 e5 bc ff ff       	call   c01002a1 <cprintf>
c01045bc:	eb 6d                	jmp    c010462b <do_pgfault+0x1f0>
                goto failed;
            }
            page_insert(mm->pgdir, page, addr, perm); //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
c01045be:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01045c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01045c4:	8b 40 0c             	mov    0xc(%eax),%eax
c01045c7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01045ca:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01045ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
c01045d1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01045d5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01045d9:	89 04 24             	mov    %eax,(%esp)
c01045dc:	e8 ac 2f 00 00       	call   c010758d <page_insert>
            
            swap_map_swappable(mm, addr, page, 0); //(3)使这一页可以置换
c01045e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045e4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01045eb:	00 
c01045ec:	89 44 24 08          	mov    %eax,0x8(%esp)
c01045f0:	8b 45 10             	mov    0x10(%ebp),%eax
c01045f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01045fa:	89 04 24             	mov    %eax,(%esp)
c01045fd:	e8 71 01 00 00       	call   c0104773 <swap_map_swappable>
            page->pra_vaddr = addr; //设置 这一页的虚拟地址
c0104602:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104605:	8b 55 10             	mov    0x10(%ebp),%edx
c0104608:	89 50 1c             	mov    %edx,0x1c(%eax)
c010460b:	eb 17                	jmp    c0104624 <do_pgfault+0x1e9>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c010460d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104610:	8b 00                	mov    (%eax),%eax
c0104612:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104616:	c7 04 24 9c a2 10 c0 	movl   $0xc010a29c,(%esp)
c010461d:	e8 7f bc ff ff       	call   c01002a1 <cprintf>
            goto failed;
c0104622:	eb 07                	jmp    c010462b <do_pgfault+0x1f0>
        }
   }
   ret = 0;
c0104624:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c010462b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010462e:	c9                   	leave  
c010462f:	c3                   	ret    

c0104630 <pa2page>:
pa2page(uintptr_t pa) {
c0104630:	55                   	push   %ebp
c0104631:	89 e5                	mov    %esp,%ebp
c0104633:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104636:	8b 45 08             	mov    0x8(%ebp),%eax
c0104639:	c1 e8 0c             	shr    $0xc,%eax
c010463c:	89 c2                	mov    %eax,%edx
c010463e:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0104643:	39 c2                	cmp    %eax,%edx
c0104645:	72 1c                	jb     c0104663 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104647:	c7 44 24 08 c4 a2 10 	movl   $0xc010a2c4,0x8(%esp)
c010464e:	c0 
c010464f:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0104656:	00 
c0104657:	c7 04 24 e3 a2 10 c0 	movl   $0xc010a2e3,(%esp)
c010465e:	e8 95 bd ff ff       	call   c01003f8 <__panic>
    return &pages[PPN(pa)];
c0104663:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0104668:	8b 55 08             	mov    0x8(%ebp),%edx
c010466b:	c1 ea 0c             	shr    $0xc,%edx
c010466e:	c1 e2 05             	shl    $0x5,%edx
c0104671:	01 d0                	add    %edx,%eax
}
c0104673:	c9                   	leave  
c0104674:	c3                   	ret    

c0104675 <pte2page>:
pte2page(pte_t pte) {
c0104675:	55                   	push   %ebp
c0104676:	89 e5                	mov    %esp,%ebp
c0104678:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c010467b:	8b 45 08             	mov    0x8(%ebp),%eax
c010467e:	83 e0 01             	and    $0x1,%eax
c0104681:	85 c0                	test   %eax,%eax
c0104683:	75 1c                	jne    c01046a1 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104685:	c7 44 24 08 f4 a2 10 	movl   $0xc010a2f4,0x8(%esp)
c010468c:	c0 
c010468d:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0104694:	00 
c0104695:	c7 04 24 e3 a2 10 c0 	movl   $0xc010a2e3,(%esp)
c010469c:	e8 57 bd ff ff       	call   c01003f8 <__panic>
    return pa2page(PTE_ADDR(pte));
c01046a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01046a9:	89 04 24             	mov    %eax,(%esp)
c01046ac:	e8 7f ff ff ff       	call   c0104630 <pa2page>
}
c01046b1:	c9                   	leave  
c01046b2:	c3                   	ret    

c01046b3 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c01046b3:	55                   	push   %ebp
c01046b4:	89 e5                	mov    %esp,%ebp
c01046b6:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c01046b9:	e8 1c 3f 00 00       	call   c01085da <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c01046be:	a1 bc 50 12 c0       	mov    0xc01250bc,%eax
c01046c3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c01046c8:	76 0c                	jbe    c01046d6 <swap_init+0x23>
c01046ca:	a1 bc 50 12 c0       	mov    0xc01250bc,%eax
c01046cf:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c01046d4:	76 25                	jbe    c01046fb <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c01046d6:	a1 bc 50 12 c0       	mov    0xc01250bc,%eax
c01046db:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046df:	c7 44 24 08 15 a3 10 	movl   $0xc010a315,0x8(%esp)
c01046e6:	c0 
c01046e7:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
c01046ee:	00 
c01046ef:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c01046f6:	e8 fd bc ff ff       	call   c01003f8 <__panic>
     }
     

     //sm = &swap_manager_fifo;
     sm = &swap_manager_extended_clock;
c01046fb:	c7 05 70 4f 12 c0 e0 	movl   $0xc01219e0,0xc0124f70
c0104702:	19 12 c0 
     
     int r = sm->init();
c0104705:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c010470a:	8b 40 04             	mov    0x4(%eax),%eax
c010470d:	ff d0                	call   *%eax
c010470f:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0104712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104716:	75 26                	jne    c010473e <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0104718:	c7 05 68 4f 12 c0 01 	movl   $0x1,0xc0124f68
c010471f:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0104722:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104727:	8b 00                	mov    (%eax),%eax
c0104729:	89 44 24 04          	mov    %eax,0x4(%esp)
c010472d:	c7 04 24 3f a3 10 c0 	movl   $0xc010a33f,(%esp)
c0104734:	e8 68 bb ff ff       	call   c01002a1 <cprintf>
          check_swap();
c0104739:	e8 a4 04 00 00       	call   c0104be2 <check_swap>
     }

     return r;
c010473e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104741:	c9                   	leave  
c0104742:	c3                   	ret    

c0104743 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0104743:	55                   	push   %ebp
c0104744:	89 e5                	mov    %esp,%ebp
c0104746:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0104749:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c010474e:	8b 40 08             	mov    0x8(%eax),%eax
c0104751:	8b 55 08             	mov    0x8(%ebp),%edx
c0104754:	89 14 24             	mov    %edx,(%esp)
c0104757:	ff d0                	call   *%eax
}
c0104759:	c9                   	leave  
c010475a:	c3                   	ret    

c010475b <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c010475b:	55                   	push   %ebp
c010475c:	89 e5                	mov    %esp,%ebp
c010475e:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0104761:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104766:	8b 40 0c             	mov    0xc(%eax),%eax
c0104769:	8b 55 08             	mov    0x8(%ebp),%edx
c010476c:	89 14 24             	mov    %edx,(%esp)
c010476f:	ff d0                	call   *%eax
}
c0104771:	c9                   	leave  
c0104772:	c3                   	ret    

c0104773 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0104773:	55                   	push   %ebp
c0104774:	89 e5                	mov    %esp,%ebp
c0104776:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0104779:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c010477e:	8b 40 10             	mov    0x10(%eax),%eax
c0104781:	8b 55 14             	mov    0x14(%ebp),%edx
c0104784:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0104788:	8b 55 10             	mov    0x10(%ebp),%edx
c010478b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010478f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104792:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104796:	8b 55 08             	mov    0x8(%ebp),%edx
c0104799:	89 14 24             	mov    %edx,(%esp)
c010479c:	ff d0                	call   *%eax
}
c010479e:	c9                   	leave  
c010479f:	c3                   	ret    

c01047a0 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01047a0:	55                   	push   %ebp
c01047a1:	89 e5                	mov    %esp,%ebp
c01047a3:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c01047a6:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c01047ab:	8b 40 14             	mov    0x14(%eax),%eax
c01047ae:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047b1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047b5:	8b 55 08             	mov    0x8(%ebp),%edx
c01047b8:	89 14 24             	mov    %edx,(%esp)
c01047bb:	ff d0                	call   *%eax
}
c01047bd:	c9                   	leave  
c01047be:	c3                   	ret    

c01047bf <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c01047bf:	55                   	push   %ebp
c01047c0:	89 e5                	mov    %esp,%ebp
c01047c2:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c01047c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01047cc:	e9 5a 01 00 00       	jmp    c010492b <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c01047d1:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c01047d6:	8b 40 18             	mov    0x18(%eax),%eax
c01047d9:	8b 55 10             	mov    0x10(%ebp),%edx
c01047dc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01047e0:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c01047e3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047e7:	8b 55 08             	mov    0x8(%ebp),%edx
c01047ea:	89 14 24             	mov    %edx,(%esp)
c01047ed:	ff d0                	call   *%eax
c01047ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c01047f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01047f6:	74 18                	je     c0104810 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c01047f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047ff:	c7 04 24 54 a3 10 c0 	movl   $0xc010a354,(%esp)
c0104806:	e8 96 ba ff ff       	call   c01002a1 <cprintf>
c010480b:	e9 27 01 00 00       	jmp    c0104937 <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0104810:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104813:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104816:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0104819:	8b 45 08             	mov    0x8(%ebp),%eax
c010481c:	8b 40 0c             	mov    0xc(%eax),%eax
c010481f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104826:	00 
c0104827:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010482a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010482e:	89 04 24             	mov    %eax,(%esp)
c0104831:	e8 21 2b 00 00       	call   c0107357 <get_pte>
c0104836:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0104839:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010483c:	8b 00                	mov    (%eax),%eax
c010483e:	83 e0 01             	and    $0x1,%eax
c0104841:	85 c0                	test   %eax,%eax
c0104843:	75 24                	jne    c0104869 <swap_out+0xaa>
c0104845:	c7 44 24 0c 81 a3 10 	movl   $0xc010a381,0xc(%esp)
c010484c:	c0 
c010484d:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104854:	c0 
c0104855:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c010485c:	00 
c010485d:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104864:	e8 8f bb ff ff       	call   c01003f8 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0104869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010486c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010486f:	8b 52 1c             	mov    0x1c(%edx),%edx
c0104872:	c1 ea 0c             	shr    $0xc,%edx
c0104875:	83 c2 01             	add    $0x1,%edx
c0104878:	c1 e2 08             	shl    $0x8,%edx
c010487b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010487f:	89 14 24             	mov    %edx,(%esp)
c0104882:	e8 0d 3e 00 00       	call   c0108694 <swapfs_write>
c0104887:	85 c0                	test   %eax,%eax
c0104889:	74 34                	je     c01048bf <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c010488b:	c7 04 24 ab a3 10 c0 	movl   $0xc010a3ab,(%esp)
c0104892:	e8 0a ba ff ff       	call   c01002a1 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c0104897:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c010489c:	8b 40 10             	mov    0x10(%eax),%eax
c010489f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01048a2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01048a9:	00 
c01048aa:	89 54 24 08          	mov    %edx,0x8(%esp)
c01048ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01048b1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048b5:	8b 55 08             	mov    0x8(%ebp),%edx
c01048b8:	89 14 24             	mov    %edx,(%esp)
c01048bb:	ff d0                	call   *%eax
c01048bd:	eb 68                	jmp    c0104927 <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c01048bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01048c2:	8b 40 1c             	mov    0x1c(%eax),%eax
c01048c5:	c1 e8 0c             	shr    $0xc,%eax
c01048c8:	83 c0 01             	add    $0x1,%eax
c01048cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048d2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01048d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048dd:	c7 04 24 c4 a3 10 c0 	movl   $0xc010a3c4,(%esp)
c01048e4:	e8 b8 b9 ff ff       	call   c01002a1 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c01048e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01048ec:	8b 40 1c             	mov    0x1c(%eax),%eax
c01048ef:	c1 e8 0c             	shr    $0xc,%eax
c01048f2:	83 c0 01             	add    $0x1,%eax
c01048f5:	c1 e0 08             	shl    $0x8,%eax
c01048f8:	89 c2                	mov    %eax,%edx
c01048fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01048fd:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c01048ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104902:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104909:	00 
c010490a:	89 04 24             	mov    %eax,(%esp)
c010490d:	e8 d1 23 00 00       	call   c0106ce3 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0104912:	8b 45 08             	mov    0x8(%ebp),%eax
c0104915:	8b 40 0c             	mov    0xc(%eax),%eax
c0104918:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010491b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010491f:	89 04 24             	mov    %eax,(%esp)
c0104922:	e8 1f 2d 00 00       	call   c0107646 <tlb_invalidate>
     for (i = 0; i != n; ++ i)
c0104927:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010492b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010492e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104931:	0f 85 9a fe ff ff    	jne    c01047d1 <swap_out+0x12>
     }
     return i;
c0104937:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010493a:	c9                   	leave  
c010493b:	c3                   	ret    

c010493c <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c010493c:	55                   	push   %ebp
c010493d:	89 e5                	mov    %esp,%ebp
c010493f:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0104942:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104949:	e8 2a 23 00 00       	call   c0106c78 <alloc_pages>
c010494e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0104951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104955:	75 24                	jne    c010497b <swap_in+0x3f>
c0104957:	c7 44 24 0c 04 a4 10 	movl   $0xc010a404,0xc(%esp)
c010495e:	c0 
c010495f:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104966:	c0 
c0104967:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
c010496e:	00 
c010496f:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104976:	e8 7d ba ff ff       	call   c01003f8 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c010497b:	8b 45 08             	mov    0x8(%ebp),%eax
c010497e:	8b 40 0c             	mov    0xc(%eax),%eax
c0104981:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104988:	00 
c0104989:	8b 55 0c             	mov    0xc(%ebp),%edx
c010498c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104990:	89 04 24             	mov    %eax,(%esp)
c0104993:	e8 bf 29 00 00       	call   c0107357 <get_pte>
c0104998:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c010499b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010499e:	8b 00                	mov    (%eax),%eax
c01049a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01049a3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01049a7:	89 04 24             	mov    %eax,(%esp)
c01049aa:	e8 73 3c 00 00       	call   c0108622 <swapfs_read>
c01049af:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01049b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01049b6:	74 2a                	je     c01049e2 <swap_in+0xa6>
     {
        assert(r!=0);
c01049b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01049bc:	75 24                	jne    c01049e2 <swap_in+0xa6>
c01049be:	c7 44 24 0c 11 a4 10 	movl   $0xc010a411,0xc(%esp)
c01049c5:	c0 
c01049c6:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c01049cd:	c0 
c01049ce:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
c01049d5:	00 
c01049d6:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c01049dd:	e8 16 ba ff ff       	call   c01003f8 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c01049e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049e5:	8b 00                	mov    (%eax),%eax
c01049e7:	c1 e8 08             	shr    $0x8,%eax
c01049ea:	89 c2                	mov    %eax,%edx
c01049ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01049f3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01049f7:	c7 04 24 18 a4 10 c0 	movl   $0xc010a418,(%esp)
c01049fe:	e8 9e b8 ff ff       	call   c01002a1 <cprintf>
     *ptr_result=result;
c0104a03:	8b 45 10             	mov    0x10(%ebp),%eax
c0104a06:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a09:	89 10                	mov    %edx,(%eax)
     return 0;
c0104a0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104a10:	c9                   	leave  
c0104a11:	c3                   	ret    

c0104a12 <check_content_set>:



static inline void
check_content_set(void)
{
c0104a12:	55                   	push   %ebp
c0104a13:	89 e5                	mov    %esp,%ebp
c0104a15:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0104a18:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104a1d:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0104a20:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104a25:	83 f8 01             	cmp    $0x1,%eax
c0104a28:	74 24                	je     c0104a4e <check_content_set+0x3c>
c0104a2a:	c7 44 24 0c 56 a4 10 	movl   $0xc010a456,0xc(%esp)
c0104a31:	c0 
c0104a32:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104a39:	c0 
c0104a3a:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
c0104a41:	00 
c0104a42:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104a49:	e8 aa b9 ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0104a4e:	b8 10 10 00 00       	mov    $0x1010,%eax
c0104a53:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0104a56:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104a5b:	83 f8 01             	cmp    $0x1,%eax
c0104a5e:	74 24                	je     c0104a84 <check_content_set+0x72>
c0104a60:	c7 44 24 0c 56 a4 10 	movl   $0xc010a456,0xc(%esp)
c0104a67:	c0 
c0104a68:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104a6f:	c0 
c0104a70:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
c0104a77:	00 
c0104a78:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104a7f:	e8 74 b9 ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0104a84:	b8 00 20 00 00       	mov    $0x2000,%eax
c0104a89:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0104a8c:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104a91:	83 f8 02             	cmp    $0x2,%eax
c0104a94:	74 24                	je     c0104aba <check_content_set+0xa8>
c0104a96:	c7 44 24 0c 65 a4 10 	movl   $0xc010a465,0xc(%esp)
c0104a9d:	c0 
c0104a9e:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104aa5:	c0 
c0104aa6:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c0104aad:	00 
c0104aae:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104ab5:	e8 3e b9 ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0104aba:	b8 10 20 00 00       	mov    $0x2010,%eax
c0104abf:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0104ac2:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104ac7:	83 f8 02             	cmp    $0x2,%eax
c0104aca:	74 24                	je     c0104af0 <check_content_set+0xde>
c0104acc:	c7 44 24 0c 65 a4 10 	movl   $0xc010a465,0xc(%esp)
c0104ad3:	c0 
c0104ad4:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104adb:	c0 
c0104adc:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c0104ae3:	00 
c0104ae4:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104aeb:	e8 08 b9 ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0104af0:	b8 00 30 00 00       	mov    $0x3000,%eax
c0104af5:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0104af8:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104afd:	83 f8 03             	cmp    $0x3,%eax
c0104b00:	74 24                	je     c0104b26 <check_content_set+0x114>
c0104b02:	c7 44 24 0c 74 a4 10 	movl   $0xc010a474,0xc(%esp)
c0104b09:	c0 
c0104b0a:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104b11:	c0 
c0104b12:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c0104b19:	00 
c0104b1a:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104b21:	e8 d2 b8 ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0104b26:	b8 10 30 00 00       	mov    $0x3010,%eax
c0104b2b:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0104b2e:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104b33:	83 f8 03             	cmp    $0x3,%eax
c0104b36:	74 24                	je     c0104b5c <check_content_set+0x14a>
c0104b38:	c7 44 24 0c 74 a4 10 	movl   $0xc010a474,0xc(%esp)
c0104b3f:	c0 
c0104b40:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104b47:	c0 
c0104b48:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c0104b4f:	00 
c0104b50:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104b57:	e8 9c b8 ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0104b5c:	b8 00 40 00 00       	mov    $0x4000,%eax
c0104b61:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0104b64:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104b69:	83 f8 04             	cmp    $0x4,%eax
c0104b6c:	74 24                	je     c0104b92 <check_content_set+0x180>
c0104b6e:	c7 44 24 0c 83 a4 10 	movl   $0xc010a483,0xc(%esp)
c0104b75:	c0 
c0104b76:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104b7d:	c0 
c0104b7e:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0104b85:	00 
c0104b86:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104b8d:	e8 66 b8 ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0104b92:	b8 10 40 00 00       	mov    $0x4010,%eax
c0104b97:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0104b9a:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104b9f:	83 f8 04             	cmp    $0x4,%eax
c0104ba2:	74 24                	je     c0104bc8 <check_content_set+0x1b6>
c0104ba4:	c7 44 24 0c 83 a4 10 	movl   $0xc010a483,0xc(%esp)
c0104bab:	c0 
c0104bac:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104bb3:	c0 
c0104bb4:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c0104bbb:	00 
c0104bbc:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104bc3:	e8 30 b8 ff ff       	call   c01003f8 <__panic>
}
c0104bc8:	c9                   	leave  
c0104bc9:	c3                   	ret    

c0104bca <check_content_access>:

static inline int
check_content_access(void)
{
c0104bca:	55                   	push   %ebp
c0104bcb:	89 e5                	mov    %esp,%ebp
c0104bcd:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0104bd0:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104bd5:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104bd8:	ff d0                	call   *%eax
c0104bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0104bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104be0:	c9                   	leave  
c0104be1:	c3                   	ret    

c0104be2 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0104be2:	55                   	push   %ebp
c0104be3:	89 e5                	mov    %esp,%ebp
c0104be5:	53                   	push   %ebx
c0104be6:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0104be9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104bf0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0104bf7:	c7 45 e8 e4 50 12 c0 	movl   $0xc01250e4,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0104bfe:	eb 6b                	jmp    c0104c6b <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0104c00:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104c03:	83 e8 0c             	sub    $0xc,%eax
c0104c06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0104c09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c0c:	83 c0 04             	add    $0x4,%eax
c0104c0f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0104c16:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104c19:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104c1c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104c1f:	0f a3 10             	bt     %edx,(%eax)
c0104c22:	19 c0                	sbb    %eax,%eax
c0104c24:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0104c27:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104c2b:	0f 95 c0             	setne  %al
c0104c2e:	0f b6 c0             	movzbl %al,%eax
c0104c31:	85 c0                	test   %eax,%eax
c0104c33:	75 24                	jne    c0104c59 <check_swap+0x77>
c0104c35:	c7 44 24 0c 92 a4 10 	movl   $0xc010a492,0xc(%esp)
c0104c3c:	c0 
c0104c3d:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104c44:	c0 
c0104c45:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0104c4c:	00 
c0104c4d:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104c54:	e8 9f b7 ff ff       	call   c01003f8 <__panic>
        count ++, total += p->property;
c0104c59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104c5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c60:	8b 50 08             	mov    0x8(%eax),%edx
c0104c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c66:	01 d0                	add    %edx,%eax
c0104c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104c6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104c71:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104c74:	8b 40 04             	mov    0x4(%eax),%eax
     while ((le = list_next(le)) != &free_list) {
c0104c77:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104c7a:	81 7d e8 e4 50 12 c0 	cmpl   $0xc01250e4,-0x18(%ebp)
c0104c81:	0f 85 79 ff ff ff    	jne    c0104c00 <check_swap+0x1e>
     }
     assert(total == nr_free_pages());
c0104c87:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0104c8a:	e8 86 20 00 00       	call   c0106d15 <nr_free_pages>
c0104c8f:	39 c3                	cmp    %eax,%ebx
c0104c91:	74 24                	je     c0104cb7 <check_swap+0xd5>
c0104c93:	c7 44 24 0c a2 a4 10 	movl   $0xc010a4a2,0xc(%esp)
c0104c9a:	c0 
c0104c9b:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104ca2:	c0 
c0104ca3:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0104caa:	00 
c0104cab:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104cb2:	e8 41 b7 ff ff       	call   c01003f8 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0104cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cba:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104cc5:	c7 04 24 bc a4 10 c0 	movl   $0xc010a4bc,(%esp)
c0104ccc:	e8 d0 b5 ff ff       	call   c01002a1 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0104cd1:	e8 41 ec ff ff       	call   c0103917 <mm_create>
c0104cd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0104cd9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104cdd:	75 24                	jne    c0104d03 <check_swap+0x121>
c0104cdf:	c7 44 24 0c e2 a4 10 	movl   $0xc010a4e2,0xc(%esp)
c0104ce6:	c0 
c0104ce7:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104cee:	c0 
c0104cef:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0104cf6:	00 
c0104cf7:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104cfe:	e8 f5 b6 ff ff       	call   c01003f8 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0104d03:	a1 1c 50 12 c0       	mov    0xc012501c,%eax
c0104d08:	85 c0                	test   %eax,%eax
c0104d0a:	74 24                	je     c0104d30 <check_swap+0x14e>
c0104d0c:	c7 44 24 0c ed a4 10 	movl   $0xc010a4ed,0xc(%esp)
c0104d13:	c0 
c0104d14:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104d1b:	c0 
c0104d1c:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0104d23:	00 
c0104d24:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104d2b:	e8 c8 b6 ff ff       	call   c01003f8 <__panic>

     check_mm_struct = mm;
c0104d30:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d33:	a3 1c 50 12 c0       	mov    %eax,0xc012501c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0104d38:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0104d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d41:	89 50 0c             	mov    %edx,0xc(%eax)
c0104d44:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d47:	8b 40 0c             	mov    0xc(%eax),%eax
c0104d4a:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0104d4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d50:	8b 00                	mov    (%eax),%eax
c0104d52:	85 c0                	test   %eax,%eax
c0104d54:	74 24                	je     c0104d7a <check_swap+0x198>
c0104d56:	c7 44 24 0c 05 a5 10 	movl   $0xc010a505,0xc(%esp)
c0104d5d:	c0 
c0104d5e:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104d65:	c0 
c0104d66:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0104d6d:	00 
c0104d6e:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104d75:	e8 7e b6 ff ff       	call   c01003f8 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0104d7a:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0104d81:	00 
c0104d82:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0104d89:	00 
c0104d8a:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0104d91:	e8 f9 eb ff ff       	call   c010398f <vma_create>
c0104d96:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0104d99:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104d9d:	75 24                	jne    c0104dc3 <check_swap+0x1e1>
c0104d9f:	c7 44 24 0c 13 a5 10 	movl   $0xc010a513,0xc(%esp)
c0104da6:	c0 
c0104da7:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104dae:	c0 
c0104daf:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0104db6:	00 
c0104db7:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104dbe:	e8 35 b6 ff ff       	call   c01003f8 <__panic>

     insert_vma_struct(mm, vma);
c0104dc3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104dca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104dcd:	89 04 24             	mov    %eax,(%esp)
c0104dd0:	e8 4a ed ff ff       	call   c0103b1f <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0104dd5:	c7 04 24 20 a5 10 c0 	movl   $0xc010a520,(%esp)
c0104ddc:	e8 c0 b4 ff ff       	call   c01002a1 <cprintf>
     pte_t *temp_ptep=NULL;
c0104de1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0104de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104deb:	8b 40 0c             	mov    0xc(%eax),%eax
c0104dee:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104df5:	00 
c0104df6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104dfd:	00 
c0104dfe:	89 04 24             	mov    %eax,(%esp)
c0104e01:	e8 51 25 00 00       	call   c0107357 <get_pte>
c0104e06:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0104e09:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104e0d:	75 24                	jne    c0104e33 <check_swap+0x251>
c0104e0f:	c7 44 24 0c 54 a5 10 	movl   $0xc010a554,0xc(%esp)
c0104e16:	c0 
c0104e17:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104e1e:	c0 
c0104e1f:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0104e26:	00 
c0104e27:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104e2e:	e8 c5 b5 ff ff       	call   c01003f8 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0104e33:	c7 04 24 68 a5 10 c0 	movl   $0xc010a568,(%esp)
c0104e3a:	e8 62 b4 ff ff       	call   c01002a1 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104e3f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104e46:	e9 a3 00 00 00       	jmp    c0104eee <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0104e4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e52:	e8 21 1e 00 00       	call   c0106c78 <alloc_pages>
c0104e57:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104e5a:	89 04 95 20 50 12 c0 	mov    %eax,-0x3fedafe0(,%edx,4)
          assert(check_rp[i] != NULL );
c0104e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e64:	8b 04 85 20 50 12 c0 	mov    -0x3fedafe0(,%eax,4),%eax
c0104e6b:	85 c0                	test   %eax,%eax
c0104e6d:	75 24                	jne    c0104e93 <check_swap+0x2b1>
c0104e6f:	c7 44 24 0c 8c a5 10 	movl   $0xc010a58c,0xc(%esp)
c0104e76:	c0 
c0104e77:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104e7e:	c0 
c0104e7f:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0104e86:	00 
c0104e87:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104e8e:	e8 65 b5 ff ff       	call   c01003f8 <__panic>
          assert(!PageProperty(check_rp[i]));
c0104e93:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e96:	8b 04 85 20 50 12 c0 	mov    -0x3fedafe0(,%eax,4),%eax
c0104e9d:	83 c0 04             	add    $0x4,%eax
c0104ea0:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0104ea7:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104eaa:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104ead:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104eb0:	0f a3 10             	bt     %edx,(%eax)
c0104eb3:	19 c0                	sbb    %eax,%eax
c0104eb5:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0104eb8:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0104ebc:	0f 95 c0             	setne  %al
c0104ebf:	0f b6 c0             	movzbl %al,%eax
c0104ec2:	85 c0                	test   %eax,%eax
c0104ec4:	74 24                	je     c0104eea <check_swap+0x308>
c0104ec6:	c7 44 24 0c a0 a5 10 	movl   $0xc010a5a0,0xc(%esp)
c0104ecd:	c0 
c0104ece:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104ed5:	c0 
c0104ed6:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0104edd:	00 
c0104ede:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104ee5:	e8 0e b5 ff ff       	call   c01003f8 <__panic>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104eea:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0104eee:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104ef2:	0f 8e 53 ff ff ff    	jle    c0104e4b <check_swap+0x269>
     }
     list_entry_t free_list_store = free_list;
c0104ef8:	a1 e4 50 12 c0       	mov    0xc01250e4,%eax
c0104efd:	8b 15 e8 50 12 c0    	mov    0xc01250e8,%edx
c0104f03:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104f06:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0104f09:	c7 45 a8 e4 50 12 c0 	movl   $0xc01250e4,-0x58(%ebp)
    elm->prev = elm->next = elm;
c0104f10:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104f13:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104f16:	89 50 04             	mov    %edx,0x4(%eax)
c0104f19:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104f1c:	8b 50 04             	mov    0x4(%eax),%edx
c0104f1f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104f22:	89 10                	mov    %edx,(%eax)
c0104f24:	c7 45 a4 e4 50 12 c0 	movl   $0xc01250e4,-0x5c(%ebp)
    return list->next == list;
c0104f2b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104f2e:	8b 40 04             	mov    0x4(%eax),%eax
c0104f31:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0104f34:	0f 94 c0             	sete   %al
c0104f37:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0104f3a:	85 c0                	test   %eax,%eax
c0104f3c:	75 24                	jne    c0104f62 <check_swap+0x380>
c0104f3e:	c7 44 24 0c bb a5 10 	movl   $0xc010a5bb,0xc(%esp)
c0104f45:	c0 
c0104f46:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104f4d:	c0 
c0104f4e:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0104f55:	00 
c0104f56:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104f5d:	e8 96 b4 ff ff       	call   c01003f8 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0104f62:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0104f67:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0104f6a:	c7 05 ec 50 12 c0 00 	movl   $0x0,0xc01250ec
c0104f71:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104f74:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104f7b:	eb 1e                	jmp    c0104f9b <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0104f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f80:	8b 04 85 20 50 12 c0 	mov    -0x3fedafe0(,%eax,4),%eax
c0104f87:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f8e:	00 
c0104f8f:	89 04 24             	mov    %eax,(%esp)
c0104f92:	e8 4c 1d 00 00       	call   c0106ce3 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104f97:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0104f9b:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104f9f:	7e dc                	jle    c0104f7d <check_swap+0x39b>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0104fa1:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0104fa6:	83 f8 04             	cmp    $0x4,%eax
c0104fa9:	74 24                	je     c0104fcf <check_swap+0x3ed>
c0104fab:	c7 44 24 0c d4 a5 10 	movl   $0xc010a5d4,0xc(%esp)
c0104fb2:	c0 
c0104fb3:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0104fba:	c0 
c0104fbb:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0104fc2:	00 
c0104fc3:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0104fca:	e8 29 b4 ff ff       	call   c01003f8 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0104fcf:	c7 04 24 f8 a5 10 c0 	movl   $0xc010a5f8,(%esp)
c0104fd6:	e8 c6 b2 ff ff       	call   c01002a1 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0104fdb:	c7 05 64 4f 12 c0 00 	movl   $0x0,0xc0124f64
c0104fe2:	00 00 00 
     
     check_content_set();
c0104fe5:	e8 28 fa ff ff       	call   c0104a12 <check_content_set>
     assert( nr_free == 0);         
c0104fea:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0104fef:	85 c0                	test   %eax,%eax
c0104ff1:	74 24                	je     c0105017 <check_swap+0x435>
c0104ff3:	c7 44 24 0c 1f a6 10 	movl   $0xc010a61f,0xc(%esp)
c0104ffa:	c0 
c0104ffb:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0105002:	c0 
c0105003:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c010500a:	00 
c010500b:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0105012:	e8 e1 b3 ff ff       	call   c01003f8 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0105017:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010501e:	eb 26                	jmp    c0105046 <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0105020:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105023:	c7 04 85 40 50 12 c0 	movl   $0xffffffff,-0x3fedafc0(,%eax,4)
c010502a:	ff ff ff ff 
c010502e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105031:	8b 14 85 40 50 12 c0 	mov    -0x3fedafc0(,%eax,4),%edx
c0105038:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010503b:	89 14 85 80 50 12 c0 	mov    %edx,-0x3fedaf80(,%eax,4)
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0105042:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105046:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c010504a:	7e d4                	jle    c0105020 <check_swap+0x43e>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010504c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105053:	e9 eb 00 00 00       	jmp    c0105143 <check_swap+0x561>
         check_ptep[i]=0;
c0105058:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010505b:	c7 04 85 d4 50 12 c0 	movl   $0x0,-0x3fedaf2c(,%eax,4)
c0105062:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0105066:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105069:	83 c0 01             	add    $0x1,%eax
c010506c:	c1 e0 0c             	shl    $0xc,%eax
c010506f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105076:	00 
c0105077:	89 44 24 04          	mov    %eax,0x4(%esp)
c010507b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010507e:	89 04 24             	mov    %eax,(%esp)
c0105081:	e8 d1 22 00 00       	call   c0107357 <get_pte>
c0105086:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105089:	89 04 95 d4 50 12 c0 	mov    %eax,-0x3fedaf2c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0105090:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105093:	8b 04 85 d4 50 12 c0 	mov    -0x3fedaf2c(,%eax,4),%eax
c010509a:	85 c0                	test   %eax,%eax
c010509c:	75 24                	jne    c01050c2 <check_swap+0x4e0>
c010509e:	c7 44 24 0c 2c a6 10 	movl   $0xc010a62c,0xc(%esp)
c01050a5:	c0 
c01050a6:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c01050ad:	c0 
c01050ae:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01050b5:	00 
c01050b6:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c01050bd:	e8 36 b3 ff ff       	call   c01003f8 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c01050c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050c5:	8b 04 85 d4 50 12 c0 	mov    -0x3fedaf2c(,%eax,4),%eax
c01050cc:	8b 00                	mov    (%eax),%eax
c01050ce:	89 04 24             	mov    %eax,(%esp)
c01050d1:	e8 9f f5 ff ff       	call   c0104675 <pte2page>
c01050d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01050d9:	8b 14 95 20 50 12 c0 	mov    -0x3fedafe0(,%edx,4),%edx
c01050e0:	39 d0                	cmp    %edx,%eax
c01050e2:	74 24                	je     c0105108 <check_swap+0x526>
c01050e4:	c7 44 24 0c 44 a6 10 	movl   $0xc010a644,0xc(%esp)
c01050eb:	c0 
c01050ec:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c01050f3:	c0 
c01050f4:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01050fb:	00 
c01050fc:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0105103:	e8 f0 b2 ff ff       	call   c01003f8 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0105108:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010510b:	8b 04 85 d4 50 12 c0 	mov    -0x3fedaf2c(,%eax,4),%eax
c0105112:	8b 00                	mov    (%eax),%eax
c0105114:	83 e0 01             	and    $0x1,%eax
c0105117:	85 c0                	test   %eax,%eax
c0105119:	75 24                	jne    c010513f <check_swap+0x55d>
c010511b:	c7 44 24 0c 6c a6 10 	movl   $0xc010a66c,0xc(%esp)
c0105122:	c0 
c0105123:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c010512a:	c0 
c010512b:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0105132:	00 
c0105133:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c010513a:	e8 b9 b2 ff ff       	call   c01003f8 <__panic>
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010513f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105143:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0105147:	0f 8e 0b ff ff ff    	jle    c0105058 <check_swap+0x476>
     }
     cprintf("set up init env for check_swap over!\n");
c010514d:	c7 04 24 88 a6 10 c0 	movl   $0xc010a688,(%esp)
c0105154:	e8 48 b1 ff ff       	call   c01002a1 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0105159:	e8 6c fa ff ff       	call   c0104bca <check_content_access>
c010515e:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0105161:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105165:	74 24                	je     c010518b <check_swap+0x5a9>
c0105167:	c7 44 24 0c ae a6 10 	movl   $0xc010a6ae,0xc(%esp)
c010516e:	c0 
c010516f:	c7 44 24 08 96 a3 10 	movl   $0xc010a396,0x8(%esp)
c0105176:	c0 
c0105177:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c010517e:	00 
c010517f:	c7 04 24 30 a3 10 c0 	movl   $0xc010a330,(%esp)
c0105186:	e8 6d b2 ff ff       	call   c01003f8 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010518b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105192:	eb 1e                	jmp    c01051b2 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0105194:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105197:	8b 04 85 20 50 12 c0 	mov    -0x3fedafe0(,%eax,4),%eax
c010519e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051a5:	00 
c01051a6:	89 04 24             	mov    %eax,(%esp)
c01051a9:	e8 35 1b 00 00       	call   c0106ce3 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01051ae:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01051b2:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01051b6:	7e dc                	jle    c0105194 <check_swap+0x5b2>
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c01051b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051bb:	89 04 24             	mov    %eax,(%esp)
c01051be:	e8 8c ea ff ff       	call   c0103c4f <mm_destroy>
         
     nr_free = nr_free_store;
c01051c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01051c6:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec
     free_list = free_list_store;
c01051cb:	8b 45 98             	mov    -0x68(%ebp),%eax
c01051ce:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01051d1:	a3 e4 50 12 c0       	mov    %eax,0xc01250e4
c01051d6:	89 15 e8 50 12 c0    	mov    %edx,0xc01250e8

     
     le = &free_list;
c01051dc:	c7 45 e8 e4 50 12 c0 	movl   $0xc01250e4,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01051e3:	eb 1d                	jmp    c0105202 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c01051e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01051e8:	83 e8 0c             	sub    $0xc,%eax
c01051eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c01051ee:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01051f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01051f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01051f8:	8b 40 08             	mov    0x8(%eax),%eax
c01051fb:	29 c2                	sub    %eax,%edx
c01051fd:	89 d0                	mov    %edx,%eax
c01051ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105202:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105205:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
c0105208:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010520b:	8b 40 04             	mov    0x4(%eax),%eax
     while ((le = list_next(le)) != &free_list) {
c010520e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105211:	81 7d e8 e4 50 12 c0 	cmpl   $0xc01250e4,-0x18(%ebp)
c0105218:	75 cb                	jne    c01051e5 <check_swap+0x603>
     }
     cprintf("count is %d, total is %d\n",count,total);
c010521a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010521d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105221:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105224:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105228:	c7 04 24 b5 a6 10 c0 	movl   $0xc010a6b5,(%esp)
c010522f:	e8 6d b0 ff ff       	call   c01002a1 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0105234:	c7 04 24 cf a6 10 c0 	movl   $0xc010a6cf,(%esp)
c010523b:	e8 61 b0 ff ff       	call   c01002a1 <cprintf>
}
c0105240:	83 c4 74             	add    $0x74,%esp
c0105243:	5b                   	pop    %ebx
c0105244:	5d                   	pop    %ebp
c0105245:	c3                   	ret    

c0105246 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0105246:	55                   	push   %ebp
c0105247:	89 e5                	mov    %esp,%ebp
c0105249:	83 ec 10             	sub    $0x10,%esp
c010524c:	c7 45 fc 10 50 12 c0 	movl   $0xc0125010,-0x4(%ebp)
    elm->prev = elm->next = elm;
c0105253:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105256:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0105259:	89 50 04             	mov    %edx,0x4(%eax)
c010525c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010525f:	8b 50 04             	mov    0x4(%eax),%edx
c0105262:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105265:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0105267:	8b 45 08             	mov    0x8(%ebp),%eax
c010526a:	c7 40 14 10 50 12 c0 	movl   $0xc0125010,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0105271:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105276:	c9                   	leave  
c0105277:	c3                   	ret    

c0105278 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0105278:	55                   	push   %ebp
c0105279:	89 e5                	mov    %esp,%ebp
c010527b:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c010527e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105281:	8b 40 14             	mov    0x14(%eax),%eax
c0105284:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0105287:	8b 45 10             	mov    0x10(%ebp),%eax
c010528a:	83 c0 14             	add    $0x14,%eax
c010528d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0105290:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105294:	74 06                	je     c010529c <_fifo_map_swappable+0x24>
c0105296:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010529a:	75 24                	jne    c01052c0 <_fifo_map_swappable+0x48>
c010529c:	c7 44 24 0c e8 a6 10 	movl   $0xc010a6e8,0xc(%esp)
c01052a3:	c0 
c01052a4:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c01052ab:	c0 
c01052ac:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c01052b3:	00 
c01052b4:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c01052bb:	e8 38 b1 ff ff       	call   c01003f8 <__panic>
c01052c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01052c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01052cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_add(elm, listelm, listelm->next);
c01052d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052db:	8b 40 04             	mov    0x4(%eax),%eax
c01052de:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01052e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01052e7:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01052ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    prev->next = next->prev = elm;
c01052ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01052f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052f3:	89 10                	mov    %edx,(%eax)
c01052f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01052f8:	8b 10                	mov    (%eax),%edx
c01052fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01052fd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105300:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105303:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105306:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105309:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010530c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010530f:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    list_add(head, entry); // (1) 将这一页加入到链表头中(最近访问过的放前面) 使其可以被置换算法使用到
    return 0;
c0105311:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105316:	c9                   	leave  
c0105317:	c3                   	ret    

c0105318 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0105318:	55                   	push   %ebp
c0105319:	89 e5                	mov    %esp,%ebp
c010531b:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c010531e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105321:	8b 40 14             	mov    0x14(%eax),%eax
c0105324:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0105327:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010532b:	75 24                	jne    c0105351 <_fifo_swap_out_victim+0x39>
c010532d:	c7 44 24 0c 2f a7 10 	movl   $0xc010a72f,0xc(%esp)
c0105334:	c0 
c0105335:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c010533c:	c0 
c010533d:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
c0105344:	00 
c0105345:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c010534c:	e8 a7 b0 ff ff       	call   c01003f8 <__panic>
     assert(in_tick==0);
c0105351:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105355:	74 24                	je     c010537b <_fifo_swap_out_victim+0x63>
c0105357:	c7 44 24 0c 3c a7 10 	movl   $0xc010a73c,0xc(%esp)
c010535e:	c0 
c010535f:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c0105366:	c0 
c0105367:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c010536e:	00 
c010536f:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c0105376:	e8 7d b0 ff ff       	call   c01003f8 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  assign the value of *ptr_page to the addr of this page
     /* Select the tail */
     list_entry_t *le = head->prev;//(1) 换出最先进来的页 (因为每次访问一个页 都是插入到头节点的后面 因此 头节点的前面就是最先访问的页)
c010537b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010537e:	8b 00                	mov    (%eax),%eax
c0105380:	89 45 f0             	mov    %eax,-0x10(%ebp)
     struct Page* page = le2page(le, pra_page_link); // 通过 le 这个链表节点的地址 减去 pra_page_link 在 Page 结构体中的 Offset 得到 Page 的地址
c0105383:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105386:	83 e8 14             	sub    $0x14,%eax
c0105389:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010538c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010538f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105392:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105395:	8b 40 04             	mov    0x4(%eax),%eax
c0105398:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010539b:	8b 12                	mov    (%edx),%edx
c010539d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01053a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    prev->next = next;
c01053a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01053a9:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01053ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01053b2:	89 10                	mov    %edx,(%eax)
     list_del(le); // 删掉这个节点
     *ptr_page = page; //(2) 将这一页地址存到 ptr_page 中 给 调用本函数的函数使用
c01053b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01053ba:	89 10                	mov    %edx,(%eax)
     return 0;
c01053bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01053c1:	c9                   	leave  
c01053c2:	c3                   	ret    

c01053c3 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c01053c3:	55                   	push   %ebp
c01053c4:	89 e5                	mov    %esp,%ebp
c01053c6:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c01053c9:	c7 04 24 48 a7 10 c0 	movl   $0xc010a748,(%esp)
c01053d0:	e8 cc ae ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01053d5:	b8 00 30 00 00       	mov    $0x3000,%eax
c01053da:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c01053dd:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01053e2:	83 f8 04             	cmp    $0x4,%eax
c01053e5:	74 24                	je     c010540b <_fifo_check_swap+0x48>
c01053e7:	c7 44 24 0c 6e a7 10 	movl   $0xc010a76e,0xc(%esp)
c01053ee:	c0 
c01053ef:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c01053f6:	c0 
c01053f7:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
c01053fe:	00 
c01053ff:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c0105406:	e8 ed af ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010540b:	c7 04 24 80 a7 10 c0 	movl   $0xc010a780,(%esp)
c0105412:	e8 8a ae ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0105417:	b8 00 10 00 00       	mov    $0x1000,%eax
c010541c:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c010541f:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105424:	83 f8 04             	cmp    $0x4,%eax
c0105427:	74 24                	je     c010544d <_fifo_check_swap+0x8a>
c0105429:	c7 44 24 0c 6e a7 10 	movl   $0xc010a76e,0xc(%esp)
c0105430:	c0 
c0105431:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c0105438:	c0 
c0105439:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0105440:	00 
c0105441:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c0105448:	e8 ab af ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c010544d:	c7 04 24 a8 a7 10 c0 	movl   $0xc010a7a8,(%esp)
c0105454:	e8 48 ae ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0105459:	b8 00 40 00 00       	mov    $0x4000,%eax
c010545e:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0105461:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105466:	83 f8 04             	cmp    $0x4,%eax
c0105469:	74 24                	je     c010548f <_fifo_check_swap+0xcc>
c010546b:	c7 44 24 0c 6e a7 10 	movl   $0xc010a76e,0xc(%esp)
c0105472:	c0 
c0105473:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c010547a:	c0 
c010547b:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c0105482:	00 
c0105483:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c010548a:	e8 69 af ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010548f:	c7 04 24 d0 a7 10 c0 	movl   $0xc010a7d0,(%esp)
c0105496:	e8 06 ae ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010549b:	b8 00 20 00 00       	mov    $0x2000,%eax
c01054a0:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c01054a3:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01054a8:	83 f8 04             	cmp    $0x4,%eax
c01054ab:	74 24                	je     c01054d1 <_fifo_check_swap+0x10e>
c01054ad:	c7 44 24 0c 6e a7 10 	movl   $0xc010a76e,0xc(%esp)
c01054b4:	c0 
c01054b5:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c01054bc:	c0 
c01054bd:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01054c4:	00 
c01054c5:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c01054cc:	e8 27 af ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01054d1:	c7 04 24 f8 a7 10 c0 	movl   $0xc010a7f8,(%esp)
c01054d8:	e8 c4 ad ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01054dd:	b8 00 50 00 00       	mov    $0x5000,%eax
c01054e2:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c01054e5:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01054ea:	83 f8 05             	cmp    $0x5,%eax
c01054ed:	74 24                	je     c0105513 <_fifo_check_swap+0x150>
c01054ef:	c7 44 24 0c 1e a8 10 	movl   $0xc010a81e,0xc(%esp)
c01054f6:	c0 
c01054f7:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c01054fe:	c0 
c01054ff:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0105506:	00 
c0105507:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c010550e:	e8 e5 ae ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0105513:	c7 04 24 d0 a7 10 c0 	movl   $0xc010a7d0,(%esp)
c010551a:	e8 82 ad ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010551f:	b8 00 20 00 00       	mov    $0x2000,%eax
c0105524:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0105527:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010552c:	83 f8 05             	cmp    $0x5,%eax
c010552f:	74 24                	je     c0105555 <_fifo_check_swap+0x192>
c0105531:	c7 44 24 0c 1e a8 10 	movl   $0xc010a81e,0xc(%esp)
c0105538:	c0 
c0105539:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c0105540:	c0 
c0105541:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0105548:	00 
c0105549:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c0105550:	e8 a3 ae ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0105555:	c7 04 24 80 a7 10 c0 	movl   $0xc010a780,(%esp)
c010555c:	e8 40 ad ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0105561:	b8 00 10 00 00       	mov    $0x1000,%eax
c0105566:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0105569:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010556e:	83 f8 06             	cmp    $0x6,%eax
c0105571:	74 24                	je     c0105597 <_fifo_check_swap+0x1d4>
c0105573:	c7 44 24 0c 2d a8 10 	movl   $0xc010a82d,0xc(%esp)
c010557a:	c0 
c010557b:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c0105582:	c0 
c0105583:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010558a:	00 
c010558b:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c0105592:	e8 61 ae ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0105597:	c7 04 24 d0 a7 10 c0 	movl   $0xc010a7d0,(%esp)
c010559e:	e8 fe ac ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01055a3:	b8 00 20 00 00       	mov    $0x2000,%eax
c01055a8:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c01055ab:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01055b0:	83 f8 07             	cmp    $0x7,%eax
c01055b3:	74 24                	je     c01055d9 <_fifo_check_swap+0x216>
c01055b5:	c7 44 24 0c 3c a8 10 	movl   $0xc010a83c,0xc(%esp)
c01055bc:	c0 
c01055bd:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c01055c4:	c0 
c01055c5:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01055cc:	00 
c01055cd:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c01055d4:	e8 1f ae ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c01055d9:	c7 04 24 48 a7 10 c0 	movl   $0xc010a748,(%esp)
c01055e0:	e8 bc ac ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01055e5:	b8 00 30 00 00       	mov    $0x3000,%eax
c01055ea:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c01055ed:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01055f2:	83 f8 08             	cmp    $0x8,%eax
c01055f5:	74 24                	je     c010561b <_fifo_check_swap+0x258>
c01055f7:	c7 44 24 0c 4b a8 10 	movl   $0xc010a84b,0xc(%esp)
c01055fe:	c0 
c01055ff:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c0105606:	c0 
c0105607:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c010560e:	00 
c010560f:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c0105616:	e8 dd ad ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c010561b:	c7 04 24 a8 a7 10 c0 	movl   $0xc010a7a8,(%esp)
c0105622:	e8 7a ac ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0105627:	b8 00 40 00 00       	mov    $0x4000,%eax
c010562c:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c010562f:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105634:	83 f8 09             	cmp    $0x9,%eax
c0105637:	74 24                	je     c010565d <_fifo_check_swap+0x29a>
c0105639:	c7 44 24 0c 5a a8 10 	movl   $0xc010a85a,0xc(%esp)
c0105640:	c0 
c0105641:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c0105648:	c0 
c0105649:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0105650:	00 
c0105651:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c0105658:	e8 9b ad ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c010565d:	c7 04 24 f8 a7 10 c0 	movl   $0xc010a7f8,(%esp)
c0105664:	e8 38 ac ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0105669:	b8 00 50 00 00       	mov    $0x5000,%eax
c010566e:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c0105671:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105676:	83 f8 0a             	cmp    $0xa,%eax
c0105679:	74 24                	je     c010569f <_fifo_check_swap+0x2dc>
c010567b:	c7 44 24 0c 69 a8 10 	movl   $0xc010a869,0xc(%esp)
c0105682:	c0 
c0105683:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c010568a:	c0 
c010568b:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0105692:	00 
c0105693:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c010569a:	e8 59 ad ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010569f:	c7 04 24 80 a7 10 c0 	movl   $0xc010a780,(%esp)
c01056a6:	e8 f6 ab ff ff       	call   c01002a1 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c01056ab:	b8 00 10 00 00       	mov    $0x1000,%eax
c01056b0:	0f b6 00             	movzbl (%eax),%eax
c01056b3:	3c 0a                	cmp    $0xa,%al
c01056b5:	74 24                	je     c01056db <_fifo_check_swap+0x318>
c01056b7:	c7 44 24 0c 7c a8 10 	movl   $0xc010a87c,0xc(%esp)
c01056be:	c0 
c01056bf:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c01056c6:	c0 
c01056c7:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
c01056ce:	00 
c01056cf:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c01056d6:	e8 1d ad ff ff       	call   c01003f8 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c01056db:	b8 00 10 00 00       	mov    $0x1000,%eax
c01056e0:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c01056e3:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01056e8:	83 f8 0b             	cmp    $0xb,%eax
c01056eb:	74 24                	je     c0105711 <_fifo_check_swap+0x34e>
c01056ed:	c7 44 24 0c 9d a8 10 	movl   $0xc010a89d,0xc(%esp)
c01056f4:	c0 
c01056f5:	c7 44 24 08 06 a7 10 	movl   $0xc010a706,0x8(%esp)
c01056fc:	c0 
c01056fd:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0105704:	00 
c0105705:	c7 04 24 1b a7 10 c0 	movl   $0xc010a71b,(%esp)
c010570c:	e8 e7 ac ff ff       	call   c01003f8 <__panic>
    return 0;
c0105711:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105716:	c9                   	leave  
c0105717:	c3                   	ret    

c0105718 <_fifo_init>:


static int
_fifo_init(void)
{
c0105718:	55                   	push   %ebp
c0105719:	89 e5                	mov    %esp,%ebp
    return 0;
c010571b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105720:	5d                   	pop    %ebp
c0105721:	c3                   	ret    

c0105722 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0105722:	55                   	push   %ebp
c0105723:	89 e5                	mov    %esp,%ebp
    return 0;
c0105725:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010572a:	5d                   	pop    %ebp
c010572b:	c3                   	ret    

c010572c <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c010572c:	55                   	push   %ebp
c010572d:	89 e5                	mov    %esp,%ebp
c010572f:	b8 00 00 00 00       	mov    $0x0,%eax
c0105734:	5d                   	pop    %ebp
c0105735:	c3                   	ret    

c0105736 <page2ppn>:
page2ppn(struct Page *page) {
c0105736:	55                   	push   %ebp
c0105737:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0105739:	8b 55 08             	mov    0x8(%ebp),%edx
c010573c:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0105741:	29 c2                	sub    %eax,%edx
c0105743:	89 d0                	mov    %edx,%eax
c0105745:	c1 f8 05             	sar    $0x5,%eax
}
c0105748:	5d                   	pop    %ebp
c0105749:	c3                   	ret    

c010574a <page2pa>:
page2pa(struct Page *page) {
c010574a:	55                   	push   %ebp
c010574b:	89 e5                	mov    %esp,%ebp
c010574d:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0105750:	8b 45 08             	mov    0x8(%ebp),%eax
c0105753:	89 04 24             	mov    %eax,(%esp)
c0105756:	e8 db ff ff ff       	call   c0105736 <page2ppn>
c010575b:	c1 e0 0c             	shl    $0xc,%eax
}
c010575e:	c9                   	leave  
c010575f:	c3                   	ret    

c0105760 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0105760:	55                   	push   %ebp
c0105761:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0105763:	8b 45 08             	mov    0x8(%ebp),%eax
c0105766:	8b 00                	mov    (%eax),%eax
}
c0105768:	5d                   	pop    %ebp
c0105769:	c3                   	ret    

c010576a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010576a:	55                   	push   %ebp
c010576b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010576d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105770:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105773:	89 10                	mov    %edx,(%eax)
}
c0105775:	5d                   	pop    %ebp
c0105776:	c3                   	ret    

c0105777 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0105777:	55                   	push   %ebp
c0105778:	89 e5                	mov    %esp,%ebp
c010577a:	83 ec 10             	sub    $0x10,%esp
c010577d:	c7 45 fc e4 50 12 c0 	movl   $0xc01250e4,-0x4(%ebp)
    elm->prev = elm->next = elm;
c0105784:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105787:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010578a:	89 50 04             	mov    %edx,0x4(%eax)
c010578d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105790:	8b 50 04             	mov    0x4(%eax),%edx
c0105793:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105796:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0105798:	c7 05 ec 50 12 c0 00 	movl   $0x0,0xc01250ec
c010579f:	00 00 00 
}
c01057a2:	c9                   	leave  
c01057a3:	c3                   	ret    

c01057a4 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01057a4:	55                   	push   %ebp
c01057a5:	89 e5                	mov    %esp,%ebp
c01057a7:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01057aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01057ae:	75 24                	jne    c01057d4 <default_init_memmap+0x30>
c01057b0:	c7 44 24 0c c0 a8 10 	movl   $0xc010a8c0,0xc(%esp)
c01057b7:	c0 
c01057b8:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c01057bf:	c0 
c01057c0:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01057c7:	00 
c01057c8:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c01057cf:	e8 24 ac ff ff       	call   c01003f8 <__panic>
    struct Page *p = base;
c01057d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01057da:	eb 7d                	jmp    c0105859 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01057dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057df:	83 c0 04             	add    $0x4,%eax
c01057e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01057e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01057ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01057f2:	0f a3 10             	bt     %edx,(%eax)
c01057f5:	19 c0                	sbb    %eax,%eax
c01057f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01057fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057fe:	0f 95 c0             	setne  %al
c0105801:	0f b6 c0             	movzbl %al,%eax
c0105804:	85 c0                	test   %eax,%eax
c0105806:	75 24                	jne    c010582c <default_init_memmap+0x88>
c0105808:	c7 44 24 0c f1 a8 10 	movl   $0xc010a8f1,0xc(%esp)
c010580f:	c0 
c0105810:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0105817:	c0 
c0105818:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c010581f:	00 
c0105820:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0105827:	e8 cc ab ff ff       	call   c01003f8 <__panic>
        p->flags = p->property = 0;
c010582c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010582f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0105836:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105839:	8b 50 08             	mov    0x8(%eax),%edx
c010583c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010583f:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0105842:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105849:	00 
c010584a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010584d:	89 04 24             	mov    %eax,(%esp)
c0105850:	e8 15 ff ff ff       	call   c010576a <set_page_ref>
    for (; p != base + n; p ++) {
c0105855:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0105859:	8b 45 0c             	mov    0xc(%ebp),%eax
c010585c:	c1 e0 05             	shl    $0x5,%eax
c010585f:	89 c2                	mov    %eax,%edx
c0105861:	8b 45 08             	mov    0x8(%ebp),%eax
c0105864:	01 d0                	add    %edx,%eax
c0105866:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105869:	0f 85 6d ff ff ff    	jne    c01057dc <default_init_memmap+0x38>
    }
    base->property = n;
c010586f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105872:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105875:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0105878:	8b 45 08             	mov    0x8(%ebp),%eax
c010587b:	83 c0 04             	add    $0x4,%eax
c010587e:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0105885:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105888:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010588b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010588e:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0105891:	8b 15 ec 50 12 c0    	mov    0xc01250ec,%edx
c0105897:	8b 45 0c             	mov    0xc(%ebp),%eax
c010589a:	01 d0                	add    %edx,%eax
c010589c:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec
    list_add_before(&free_list, &(base->page_link));
c01058a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01058a4:	83 c0 0c             	add    $0xc,%eax
c01058a7:	c7 45 dc e4 50 12 c0 	movl   $0xc01250e4,-0x24(%ebp)
c01058ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
    __list_add(elm, listelm->prev, listelm);
c01058b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01058b4:	8b 00                	mov    (%eax),%eax
c01058b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01058b9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01058bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01058bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01058c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
    prev->next = next->prev = elm;
c01058c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01058c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01058cb:	89 10                	mov    %edx,(%eax)
c01058cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01058d0:	8b 10                	mov    (%eax),%edx
c01058d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01058d5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01058d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01058db:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01058de:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01058e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01058e4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01058e7:	89 10                	mov    %edx,(%eax)
}
c01058e9:	c9                   	leave  
c01058ea:	c3                   	ret    

c01058eb <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01058eb:	55                   	push   %ebp
c01058ec:	89 e5                	mov    %esp,%ebp
c01058ee:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01058f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01058f5:	75 24                	jne    c010591b <default_alloc_pages+0x30>
c01058f7:	c7 44 24 0c c0 a8 10 	movl   $0xc010a8c0,0xc(%esp)
c01058fe:	c0 
c01058ff:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0105906:	c0 
c0105907:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c010590e:	00 
c010590f:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0105916:	e8 dd aa ff ff       	call   c01003f8 <__panic>
    if (n > nr_free) {
c010591b:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0105920:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105923:	73 0a                	jae    c010592f <default_alloc_pages+0x44>
        return NULL;
c0105925:	b8 00 00 00 00       	mov    $0x0,%eax
c010592a:	e9 36 01 00 00       	jmp    c0105a65 <default_alloc_pages+0x17a>
    }
    struct Page *page = NULL;
c010592f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0105936:	c7 45 f0 e4 50 12 c0 	movl   $0xc01250e4,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c010593d:	eb 1c                	jmp    c010595b <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c010593f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105942:	83 e8 0c             	sub    $0xc,%eax
c0105945:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0105948:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010594b:	8b 40 08             	mov    0x8(%eax),%eax
c010594e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105951:	72 08                	jb     c010595b <default_alloc_pages+0x70>
            page = p;
c0105953:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105956:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0105959:	eb 18                	jmp    c0105973 <default_alloc_pages+0x88>
c010595b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010595e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0105961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105964:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105967:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010596a:	81 7d f0 e4 50 12 c0 	cmpl   $0xc01250e4,-0x10(%ebp)
c0105971:	75 cc                	jne    c010593f <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c0105973:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105977:	0f 84 e5 00 00 00    	je     c0105a62 <default_alloc_pages+0x177>
        if (page->property > n) {
c010597d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105980:	8b 40 08             	mov    0x8(%eax),%eax
c0105983:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105986:	0f 86 85 00 00 00    	jbe    c0105a11 <default_alloc_pages+0x126>
            struct Page *p = page + n;
c010598c:	8b 45 08             	mov    0x8(%ebp),%eax
c010598f:	c1 e0 05             	shl    $0x5,%eax
c0105992:	89 c2                	mov    %eax,%edx
c0105994:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105997:	01 d0                	add    %edx,%eax
c0105999:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c010599c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010599f:	8b 40 08             	mov    0x8(%eax),%eax
c01059a2:	2b 45 08             	sub    0x8(%ebp),%eax
c01059a5:	89 c2                	mov    %eax,%edx
c01059a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059aa:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c01059ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059b0:	83 c0 04             	add    $0x4,%eax
c01059b3:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01059ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01059bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01059c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01059c3:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c01059c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059c9:	83 c0 0c             	add    $0xc,%eax
c01059cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059cf:	83 c2 0c             	add    $0xc,%edx
c01059d2:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01059d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c01059d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01059db:	8b 40 04             	mov    0x4(%eax),%eax
c01059de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01059e1:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01059e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01059e7:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01059ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c01059ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01059f0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01059f3:	89 10                	mov    %edx,(%eax)
c01059f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01059f8:	8b 10                	mov    (%eax),%edx
c01059fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01059fd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105a00:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105a03:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105a06:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105a09:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105a0c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105a0f:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0105a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a14:	83 c0 0c             	add    $0xc,%eax
c0105a17:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105a1a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105a1d:	8b 40 04             	mov    0x4(%eax),%eax
c0105a20:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105a23:	8b 12                	mov    (%edx),%edx
c0105a25:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0105a28:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0105a2b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105a2e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105a31:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105a34:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105a37:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105a3a:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0105a3c:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0105a41:	2b 45 08             	sub    0x8(%ebp),%eax
c0105a44:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec
        ClearPageProperty(page);
c0105a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a4c:	83 c0 04             	add    $0x4,%eax
c0105a4f:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0105a56:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105a59:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105a5c:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0105a5f:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0105a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a65:	c9                   	leave  
c0105a66:	c3                   	ret    

c0105a67 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0105a67:	55                   	push   %ebp
c0105a68:	89 e5                	mov    %esp,%ebp
c0105a6a:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0105a70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105a74:	75 24                	jne    c0105a9a <default_free_pages+0x33>
c0105a76:	c7 44 24 0c c0 a8 10 	movl   $0xc010a8c0,0xc(%esp)
c0105a7d:	c0 
c0105a7e:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0105a85:	c0 
c0105a86:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0105a8d:	00 
c0105a8e:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0105a95:	e8 5e a9 ff ff       	call   c01003f8 <__panic>
    struct Page *p = base;
c0105a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0105aa0:	e9 9d 00 00 00       	jmp    c0105b42 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0105aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105aa8:	83 c0 04             	add    $0x4,%eax
c0105aab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105ab2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105ab5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ab8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105abb:	0f a3 10             	bt     %edx,(%eax)
c0105abe:	19 c0                	sbb    %eax,%eax
c0105ac0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0105ac3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105ac7:	0f 95 c0             	setne  %al
c0105aca:	0f b6 c0             	movzbl %al,%eax
c0105acd:	85 c0                	test   %eax,%eax
c0105acf:	75 2c                	jne    c0105afd <default_free_pages+0x96>
c0105ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ad4:	83 c0 04             	add    $0x4,%eax
c0105ad7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0105ade:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105ae1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105ae4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105ae7:	0f a3 10             	bt     %edx,(%eax)
c0105aea:	19 c0                	sbb    %eax,%eax
c0105aec:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0105aef:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0105af3:	0f 95 c0             	setne  %al
c0105af6:	0f b6 c0             	movzbl %al,%eax
c0105af9:	85 c0                	test   %eax,%eax
c0105afb:	74 24                	je     c0105b21 <default_free_pages+0xba>
c0105afd:	c7 44 24 0c 04 a9 10 	movl   $0xc010a904,0xc(%esp)
c0105b04:	c0 
c0105b05:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0105b0c:	c0 
c0105b0d:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c0105b14:	00 
c0105b15:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0105b1c:	e8 d7 a8 ff ff       	call   c01003f8 <__panic>
        p->flags = 0;
c0105b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0105b2b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105b32:	00 
c0105b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b36:	89 04 24             	mov    %eax,(%esp)
c0105b39:	e8 2c fc ff ff       	call   c010576a <set_page_ref>
    for (; p != base + n; p ++) {
c0105b3e:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0105b42:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b45:	c1 e0 05             	shl    $0x5,%eax
c0105b48:	89 c2                	mov    %eax,%edx
c0105b4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b4d:	01 d0                	add    %edx,%eax
c0105b4f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105b52:	0f 85 4d ff ff ff    	jne    c0105aa5 <default_free_pages+0x3e>
    }
    base->property = n;
c0105b58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105b5e:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0105b61:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b64:	83 c0 04             	add    $0x4,%eax
c0105b67:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0105b6e:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105b71:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105b74:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105b77:	0f ab 10             	bts    %edx,(%eax)
c0105b7a:	c7 45 cc e4 50 12 c0 	movl   $0xc01250e4,-0x34(%ebp)
    return listelm->next;
c0105b81:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105b84:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0105b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0105b8a:	e9 fa 00 00 00       	jmp    c0105c89 <default_free_pages+0x222>
        p = le2page(le, page_link);
c0105b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b92:	83 e8 0c             	sub    $0xc,%eax
c0105b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b9b:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105b9e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105ba1:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0105ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0105ba7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105baa:	8b 40 08             	mov    0x8(%eax),%eax
c0105bad:	c1 e0 05             	shl    $0x5,%eax
c0105bb0:	89 c2                	mov    %eax,%edx
c0105bb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb5:	01 d0                	add    %edx,%eax
c0105bb7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105bba:	75 5a                	jne    c0105c16 <default_free_pages+0x1af>
            base->property += p->property;
c0105bbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbf:	8b 50 08             	mov    0x8(%eax),%edx
c0105bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bc5:	8b 40 08             	mov    0x8(%eax),%eax
c0105bc8:	01 c2                	add    %eax,%edx
c0105bca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bcd:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0105bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bd3:	83 c0 04             	add    $0x4,%eax
c0105bd6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0105bdd:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105be0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105be3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105be6:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0105be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bec:	83 c0 0c             	add    $0xc,%eax
c0105bef:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105bf2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105bf5:	8b 40 04             	mov    0x4(%eax),%eax
c0105bf8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105bfb:	8b 12                	mov    (%edx),%edx
c0105bfd:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0105c00:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next;
c0105c03:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105c06:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105c09:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105c0c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105c0f:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0105c12:	89 10                	mov    %edx,(%eax)
c0105c14:	eb 73                	jmp    c0105c89 <default_free_pages+0x222>
        }
        else if (p + p->property == base) {
c0105c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c19:	8b 40 08             	mov    0x8(%eax),%eax
c0105c1c:	c1 e0 05             	shl    $0x5,%eax
c0105c1f:	89 c2                	mov    %eax,%edx
c0105c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c24:	01 d0                	add    %edx,%eax
c0105c26:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105c29:	75 5e                	jne    c0105c89 <default_free_pages+0x222>
            p->property += base->property;
c0105c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c2e:	8b 50 08             	mov    0x8(%eax),%edx
c0105c31:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c34:	8b 40 08             	mov    0x8(%eax),%eax
c0105c37:	01 c2                	add    %eax,%edx
c0105c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c3c:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0105c3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c42:	83 c0 04             	add    $0x4,%eax
c0105c45:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0105c4c:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0105c4f:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105c52:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105c55:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0105c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c5b:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0105c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c61:	83 c0 0c             	add    $0xc,%eax
c0105c64:	89 45 a8             	mov    %eax,-0x58(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105c67:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105c6a:	8b 40 04             	mov    0x4(%eax),%eax
c0105c6d:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0105c70:	8b 12                	mov    (%edx),%edx
c0105c72:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0105c75:	89 45 a0             	mov    %eax,-0x60(%ebp)
    prev->next = next;
c0105c78:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105c7b:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105c7e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105c81:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105c84:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0105c87:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
c0105c89:	81 7d f0 e4 50 12 c0 	cmpl   $0xc01250e4,-0x10(%ebp)
c0105c90:	0f 85 f9 fe ff ff    	jne    c0105b8f <default_free_pages+0x128>
        }
    }
    nr_free += n;
c0105c96:	8b 15 ec 50 12 c0    	mov    0xc01250ec,%edx
c0105c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c9f:	01 d0                	add    %edx,%eax
c0105ca1:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec
c0105ca6:	c7 45 9c e4 50 12 c0 	movl   $0xc01250e4,-0x64(%ebp)
    return listelm->next;
c0105cad:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105cb0:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0105cb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0105cb6:	eb 68                	jmp    c0105d20 <default_free_pages+0x2b9>
        p = le2page(le, page_link);
c0105cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cbb:	83 e8 0c             	sub    $0xc,%eax
c0105cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0105cc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc4:	8b 40 08             	mov    0x8(%eax),%eax
c0105cc7:	c1 e0 05             	shl    $0x5,%eax
c0105cca:	89 c2                	mov    %eax,%edx
c0105ccc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ccf:	01 d0                	add    %edx,%eax
c0105cd1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105cd4:	77 3b                	ja     c0105d11 <default_free_pages+0x2aa>
            assert(base + base->property != p);
c0105cd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd9:	8b 40 08             	mov    0x8(%eax),%eax
c0105cdc:	c1 e0 05             	shl    $0x5,%eax
c0105cdf:	89 c2                	mov    %eax,%edx
c0105ce1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce4:	01 d0                	add    %edx,%eax
c0105ce6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105ce9:	75 24                	jne    c0105d0f <default_free_pages+0x2a8>
c0105ceb:	c7 44 24 0c 29 a9 10 	movl   $0xc010a929,0xc(%esp)
c0105cf2:	c0 
c0105cf3:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0105cfa:	c0 
c0105cfb:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0105d02:	00 
c0105d03:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0105d0a:	e8 e9 a6 ff ff       	call   c01003f8 <__panic>
            break;
c0105d0f:	eb 18                	jmp    c0105d29 <default_free_pages+0x2c2>
c0105d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d14:	89 45 98             	mov    %eax,-0x68(%ebp)
c0105d17:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105d1a:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
c0105d1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0105d20:	81 7d f0 e4 50 12 c0 	cmpl   $0xc01250e4,-0x10(%ebp)
c0105d27:	75 8f                	jne    c0105cb8 <default_free_pages+0x251>
    }
    list_add_before(le, &(base->page_link));
c0105d29:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d2c:	8d 50 0c             	lea    0xc(%eax),%edx
c0105d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d32:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105d35:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0105d38:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105d3b:	8b 00                	mov    (%eax),%eax
c0105d3d:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105d40:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0105d43:	89 45 88             	mov    %eax,-0x78(%ebp)
c0105d46:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105d49:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0105d4c:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105d4f:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0105d52:	89 10                	mov    %edx,(%eax)
c0105d54:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105d57:	8b 10                	mov    (%eax),%edx
c0105d59:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105d5c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105d5f:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105d62:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105d65:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105d68:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105d6b:	8b 55 88             	mov    -0x78(%ebp),%edx
c0105d6e:	89 10                	mov    %edx,(%eax)
}
c0105d70:	c9                   	leave  
c0105d71:	c3                   	ret    

c0105d72 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0105d72:	55                   	push   %ebp
c0105d73:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0105d75:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
}
c0105d7a:	5d                   	pop    %ebp
c0105d7b:	c3                   	ret    

c0105d7c <basic_check>:

static void
basic_check(void) {
c0105d7c:	55                   	push   %ebp
c0105d7d:	89 e5                	mov    %esp,%ebp
c0105d7f:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0105d82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d92:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0105d95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105d9c:	e8 d7 0e 00 00       	call   c0106c78 <alloc_pages>
c0105da1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105da4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105da8:	75 24                	jne    c0105dce <basic_check+0x52>
c0105daa:	c7 44 24 0c 44 a9 10 	movl   $0xc010a944,0xc(%esp)
c0105db1:	c0 
c0105db2:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0105db9:	c0 
c0105dba:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0105dc1:	00 
c0105dc2:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0105dc9:	e8 2a a6 ff ff       	call   c01003f8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105dce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105dd5:	e8 9e 0e 00 00       	call   c0106c78 <alloc_pages>
c0105dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ddd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105de1:	75 24                	jne    c0105e07 <basic_check+0x8b>
c0105de3:	c7 44 24 0c 60 a9 10 	movl   $0xc010a960,0xc(%esp)
c0105dea:	c0 
c0105deb:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0105df2:	c0 
c0105df3:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0105dfa:	00 
c0105dfb:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0105e02:	e8 f1 a5 ff ff       	call   c01003f8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0105e07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105e0e:	e8 65 0e 00 00       	call   c0106c78 <alloc_pages>
c0105e13:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105e1a:	75 24                	jne    c0105e40 <basic_check+0xc4>
c0105e1c:	c7 44 24 0c 7c a9 10 	movl   $0xc010a97c,0xc(%esp)
c0105e23:	c0 
c0105e24:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0105e2b:	c0 
c0105e2c:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0105e33:	00 
c0105e34:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0105e3b:	e8 b8 a5 ff ff       	call   c01003f8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0105e40:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e43:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105e46:	74 10                	je     c0105e58 <basic_check+0xdc>
c0105e48:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e4b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105e4e:	74 08                	je     c0105e58 <basic_check+0xdc>
c0105e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e53:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105e56:	75 24                	jne    c0105e7c <basic_check+0x100>
c0105e58:	c7 44 24 0c 98 a9 10 	movl   $0xc010a998,0xc(%esp)
c0105e5f:	c0 
c0105e60:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0105e67:	c0 
c0105e68:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0105e6f:	00 
c0105e70:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0105e77:	e8 7c a5 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0105e7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e7f:	89 04 24             	mov    %eax,(%esp)
c0105e82:	e8 d9 f8 ff ff       	call   c0105760 <page_ref>
c0105e87:	85 c0                	test   %eax,%eax
c0105e89:	75 1e                	jne    c0105ea9 <basic_check+0x12d>
c0105e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e8e:	89 04 24             	mov    %eax,(%esp)
c0105e91:	e8 ca f8 ff ff       	call   c0105760 <page_ref>
c0105e96:	85 c0                	test   %eax,%eax
c0105e98:	75 0f                	jne    c0105ea9 <basic_check+0x12d>
c0105e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e9d:	89 04 24             	mov    %eax,(%esp)
c0105ea0:	e8 bb f8 ff ff       	call   c0105760 <page_ref>
c0105ea5:	85 c0                	test   %eax,%eax
c0105ea7:	74 24                	je     c0105ecd <basic_check+0x151>
c0105ea9:	c7 44 24 0c bc a9 10 	movl   $0xc010a9bc,0xc(%esp)
c0105eb0:	c0 
c0105eb1:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0105eb8:	c0 
c0105eb9:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0105ec0:	00 
c0105ec1:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0105ec8:	e8 2b a5 ff ff       	call   c01003f8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0105ecd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ed0:	89 04 24             	mov    %eax,(%esp)
c0105ed3:	e8 72 f8 ff ff       	call   c010574a <page2pa>
c0105ed8:	8b 15 80 4f 12 c0    	mov    0xc0124f80,%edx
c0105ede:	c1 e2 0c             	shl    $0xc,%edx
c0105ee1:	39 d0                	cmp    %edx,%eax
c0105ee3:	72 24                	jb     c0105f09 <basic_check+0x18d>
c0105ee5:	c7 44 24 0c f8 a9 10 	movl   $0xc010a9f8,0xc(%esp)
c0105eec:	c0 
c0105eed:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0105ef4:	c0 
c0105ef5:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0105efc:	00 
c0105efd:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0105f04:	e8 ef a4 ff ff       	call   c01003f8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0105f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f0c:	89 04 24             	mov    %eax,(%esp)
c0105f0f:	e8 36 f8 ff ff       	call   c010574a <page2pa>
c0105f14:	8b 15 80 4f 12 c0    	mov    0xc0124f80,%edx
c0105f1a:	c1 e2 0c             	shl    $0xc,%edx
c0105f1d:	39 d0                	cmp    %edx,%eax
c0105f1f:	72 24                	jb     c0105f45 <basic_check+0x1c9>
c0105f21:	c7 44 24 0c 15 aa 10 	movl   $0xc010aa15,0xc(%esp)
c0105f28:	c0 
c0105f29:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0105f30:	c0 
c0105f31:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0105f38:	00 
c0105f39:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0105f40:	e8 b3 a4 ff ff       	call   c01003f8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0105f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f48:	89 04 24             	mov    %eax,(%esp)
c0105f4b:	e8 fa f7 ff ff       	call   c010574a <page2pa>
c0105f50:	8b 15 80 4f 12 c0    	mov    0xc0124f80,%edx
c0105f56:	c1 e2 0c             	shl    $0xc,%edx
c0105f59:	39 d0                	cmp    %edx,%eax
c0105f5b:	72 24                	jb     c0105f81 <basic_check+0x205>
c0105f5d:	c7 44 24 0c 32 aa 10 	movl   $0xc010aa32,0xc(%esp)
c0105f64:	c0 
c0105f65:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0105f6c:	c0 
c0105f6d:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0105f74:	00 
c0105f75:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0105f7c:	e8 77 a4 ff ff       	call   c01003f8 <__panic>

    list_entry_t free_list_store = free_list;
c0105f81:	a1 e4 50 12 c0       	mov    0xc01250e4,%eax
c0105f86:	8b 15 e8 50 12 c0    	mov    0xc01250e8,%edx
c0105f8c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105f8f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105f92:	c7 45 e0 e4 50 12 c0 	movl   $0xc01250e4,-0x20(%ebp)
    elm->prev = elm->next = elm;
c0105f99:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105f9f:	89 50 04             	mov    %edx,0x4(%eax)
c0105fa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105fa5:	8b 50 04             	mov    0x4(%eax),%edx
c0105fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105fab:	89 10                	mov    %edx,(%eax)
c0105fad:	c7 45 dc e4 50 12 c0 	movl   $0xc01250e4,-0x24(%ebp)
    return list->next == list;
c0105fb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105fb7:	8b 40 04             	mov    0x4(%eax),%eax
c0105fba:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105fbd:	0f 94 c0             	sete   %al
c0105fc0:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0105fc3:	85 c0                	test   %eax,%eax
c0105fc5:	75 24                	jne    c0105feb <basic_check+0x26f>
c0105fc7:	c7 44 24 0c 4f aa 10 	movl   $0xc010aa4f,0xc(%esp)
c0105fce:	c0 
c0105fcf:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0105fd6:	c0 
c0105fd7:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0105fde:	00 
c0105fdf:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0105fe6:	e8 0d a4 ff ff       	call   c01003f8 <__panic>

    unsigned int nr_free_store = nr_free;
c0105feb:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0105ff0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0105ff3:	c7 05 ec 50 12 c0 00 	movl   $0x0,0xc01250ec
c0105ffa:	00 00 00 

    assert(alloc_page() == NULL);
c0105ffd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106004:	e8 6f 0c 00 00       	call   c0106c78 <alloc_pages>
c0106009:	85 c0                	test   %eax,%eax
c010600b:	74 24                	je     c0106031 <basic_check+0x2b5>
c010600d:	c7 44 24 0c 66 aa 10 	movl   $0xc010aa66,0xc(%esp)
c0106014:	c0 
c0106015:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c010601c:	c0 
c010601d:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0106024:	00 
c0106025:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c010602c:	e8 c7 a3 ff ff       	call   c01003f8 <__panic>

    free_page(p0);
c0106031:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106038:	00 
c0106039:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010603c:	89 04 24             	mov    %eax,(%esp)
c010603f:	e8 9f 0c 00 00       	call   c0106ce3 <free_pages>
    free_page(p1);
c0106044:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010604b:	00 
c010604c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010604f:	89 04 24             	mov    %eax,(%esp)
c0106052:	e8 8c 0c 00 00       	call   c0106ce3 <free_pages>
    free_page(p2);
c0106057:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010605e:	00 
c010605f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106062:	89 04 24             	mov    %eax,(%esp)
c0106065:	e8 79 0c 00 00       	call   c0106ce3 <free_pages>
    assert(nr_free == 3);
c010606a:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c010606f:	83 f8 03             	cmp    $0x3,%eax
c0106072:	74 24                	je     c0106098 <basic_check+0x31c>
c0106074:	c7 44 24 0c 7b aa 10 	movl   $0xc010aa7b,0xc(%esp)
c010607b:	c0 
c010607c:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0106083:	c0 
c0106084:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c010608b:	00 
c010608c:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0106093:	e8 60 a3 ff ff       	call   c01003f8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0106098:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010609f:	e8 d4 0b 00 00       	call   c0106c78 <alloc_pages>
c01060a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01060a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01060ab:	75 24                	jne    c01060d1 <basic_check+0x355>
c01060ad:	c7 44 24 0c 44 a9 10 	movl   $0xc010a944,0xc(%esp)
c01060b4:	c0 
c01060b5:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c01060bc:	c0 
c01060bd:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01060c4:	00 
c01060c5:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c01060cc:	e8 27 a3 ff ff       	call   c01003f8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01060d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01060d8:	e8 9b 0b 00 00       	call   c0106c78 <alloc_pages>
c01060dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01060e4:	75 24                	jne    c010610a <basic_check+0x38e>
c01060e6:	c7 44 24 0c 60 a9 10 	movl   $0xc010a960,0xc(%esp)
c01060ed:	c0 
c01060ee:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c01060f5:	c0 
c01060f6:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c01060fd:	00 
c01060fe:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0106105:	e8 ee a2 ff ff       	call   c01003f8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010610a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106111:	e8 62 0b 00 00       	call   c0106c78 <alloc_pages>
c0106116:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106119:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010611d:	75 24                	jne    c0106143 <basic_check+0x3c7>
c010611f:	c7 44 24 0c 7c a9 10 	movl   $0xc010a97c,0xc(%esp)
c0106126:	c0 
c0106127:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c010612e:	c0 
c010612f:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0106136:	00 
c0106137:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c010613e:	e8 b5 a2 ff ff       	call   c01003f8 <__panic>

    assert(alloc_page() == NULL);
c0106143:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010614a:	e8 29 0b 00 00       	call   c0106c78 <alloc_pages>
c010614f:	85 c0                	test   %eax,%eax
c0106151:	74 24                	je     c0106177 <basic_check+0x3fb>
c0106153:	c7 44 24 0c 66 aa 10 	movl   $0xc010aa66,0xc(%esp)
c010615a:	c0 
c010615b:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0106162:	c0 
c0106163:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c010616a:	00 
c010616b:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0106172:	e8 81 a2 ff ff       	call   c01003f8 <__panic>

    free_page(p0);
c0106177:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010617e:	00 
c010617f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106182:	89 04 24             	mov    %eax,(%esp)
c0106185:	e8 59 0b 00 00       	call   c0106ce3 <free_pages>
c010618a:	c7 45 d8 e4 50 12 c0 	movl   $0xc01250e4,-0x28(%ebp)
c0106191:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106194:	8b 40 04             	mov    0x4(%eax),%eax
c0106197:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010619a:	0f 94 c0             	sete   %al
c010619d:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01061a0:	85 c0                	test   %eax,%eax
c01061a2:	74 24                	je     c01061c8 <basic_check+0x44c>
c01061a4:	c7 44 24 0c 88 aa 10 	movl   $0xc010aa88,0xc(%esp)
c01061ab:	c0 
c01061ac:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c01061b3:	c0 
c01061b4:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c01061bb:	00 
c01061bc:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c01061c3:	e8 30 a2 ff ff       	call   c01003f8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01061c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01061cf:	e8 a4 0a 00 00       	call   c0106c78 <alloc_pages>
c01061d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01061d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061da:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01061dd:	74 24                	je     c0106203 <basic_check+0x487>
c01061df:	c7 44 24 0c a0 aa 10 	movl   $0xc010aaa0,0xc(%esp)
c01061e6:	c0 
c01061e7:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c01061ee:	c0 
c01061ef:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c01061f6:	00 
c01061f7:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c01061fe:	e8 f5 a1 ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c0106203:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010620a:	e8 69 0a 00 00       	call   c0106c78 <alloc_pages>
c010620f:	85 c0                	test   %eax,%eax
c0106211:	74 24                	je     c0106237 <basic_check+0x4bb>
c0106213:	c7 44 24 0c 66 aa 10 	movl   $0xc010aa66,0xc(%esp)
c010621a:	c0 
c010621b:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0106222:	c0 
c0106223:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c010622a:	00 
c010622b:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0106232:	e8 c1 a1 ff ff       	call   c01003f8 <__panic>

    assert(nr_free == 0);
c0106237:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c010623c:	85 c0                	test   %eax,%eax
c010623e:	74 24                	je     c0106264 <basic_check+0x4e8>
c0106240:	c7 44 24 0c b9 aa 10 	movl   $0xc010aab9,0xc(%esp)
c0106247:	c0 
c0106248:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c010624f:	c0 
c0106250:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0106257:	00 
c0106258:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c010625f:	e8 94 a1 ff ff       	call   c01003f8 <__panic>
    free_list = free_list_store;
c0106264:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106267:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010626a:	a3 e4 50 12 c0       	mov    %eax,0xc01250e4
c010626f:	89 15 e8 50 12 c0    	mov    %edx,0xc01250e8
    nr_free = nr_free_store;
c0106275:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106278:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec

    free_page(p);
c010627d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106284:	00 
c0106285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106288:	89 04 24             	mov    %eax,(%esp)
c010628b:	e8 53 0a 00 00       	call   c0106ce3 <free_pages>
    free_page(p1);
c0106290:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106297:	00 
c0106298:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010629b:	89 04 24             	mov    %eax,(%esp)
c010629e:	e8 40 0a 00 00       	call   c0106ce3 <free_pages>
    free_page(p2);
c01062a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062aa:	00 
c01062ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01062ae:	89 04 24             	mov    %eax,(%esp)
c01062b1:	e8 2d 0a 00 00       	call   c0106ce3 <free_pages>
}
c01062b6:	c9                   	leave  
c01062b7:	c3                   	ret    

c01062b8 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01062b8:	55                   	push   %ebp
c01062b9:	89 e5                	mov    %esp,%ebp
c01062bb:	53                   	push   %ebx
c01062bc:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01062c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01062c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01062d0:	c7 45 ec e4 50 12 c0 	movl   $0xc01250e4,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01062d7:	eb 6b                	jmp    c0106344 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01062d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01062dc:	83 e8 0c             	sub    $0xc,%eax
c01062df:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01062e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01062e5:	83 c0 04             	add    $0x4,%eax
c01062e8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01062ef:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01062f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01062f5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01062f8:	0f a3 10             	bt     %edx,(%eax)
c01062fb:	19 c0                	sbb    %eax,%eax
c01062fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0106300:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0106304:	0f 95 c0             	setne  %al
c0106307:	0f b6 c0             	movzbl %al,%eax
c010630a:	85 c0                	test   %eax,%eax
c010630c:	75 24                	jne    c0106332 <default_check+0x7a>
c010630e:	c7 44 24 0c c6 aa 10 	movl   $0xc010aac6,0xc(%esp)
c0106315:	c0 
c0106316:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c010631d:	c0 
c010631e:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0106325:	00 
c0106326:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c010632d:	e8 c6 a0 ff ff       	call   c01003f8 <__panic>
        count ++, total += p->property;
c0106332:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106336:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106339:	8b 50 08             	mov    0x8(%eax),%edx
c010633c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010633f:	01 d0                	add    %edx,%eax
c0106341:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106344:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106347:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c010634a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010634d:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0106350:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106353:	81 7d ec e4 50 12 c0 	cmpl   $0xc01250e4,-0x14(%ebp)
c010635a:	0f 85 79 ff ff ff    	jne    c01062d9 <default_check+0x21>
    }
    assert(total == nr_free_pages());
c0106360:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0106363:	e8 ad 09 00 00       	call   c0106d15 <nr_free_pages>
c0106368:	39 c3                	cmp    %eax,%ebx
c010636a:	74 24                	je     c0106390 <default_check+0xd8>
c010636c:	c7 44 24 0c d6 aa 10 	movl   $0xc010aad6,0xc(%esp)
c0106373:	c0 
c0106374:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c010637b:	c0 
c010637c:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0106383:	00 
c0106384:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c010638b:	e8 68 a0 ff ff       	call   c01003f8 <__panic>

    basic_check();
c0106390:	e8 e7 f9 ff ff       	call   c0105d7c <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0106395:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010639c:	e8 d7 08 00 00       	call   c0106c78 <alloc_pages>
c01063a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01063a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01063a8:	75 24                	jne    c01063ce <default_check+0x116>
c01063aa:	c7 44 24 0c ef aa 10 	movl   $0xc010aaef,0xc(%esp)
c01063b1:	c0 
c01063b2:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c01063b9:	c0 
c01063ba:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c01063c1:	00 
c01063c2:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c01063c9:	e8 2a a0 ff ff       	call   c01003f8 <__panic>
    assert(!PageProperty(p0));
c01063ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063d1:	83 c0 04             	add    $0x4,%eax
c01063d4:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01063db:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01063de:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01063e1:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01063e4:	0f a3 10             	bt     %edx,(%eax)
c01063e7:	19 c0                	sbb    %eax,%eax
c01063e9:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01063ec:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01063f0:	0f 95 c0             	setne  %al
c01063f3:	0f b6 c0             	movzbl %al,%eax
c01063f6:	85 c0                	test   %eax,%eax
c01063f8:	74 24                	je     c010641e <default_check+0x166>
c01063fa:	c7 44 24 0c fa aa 10 	movl   $0xc010aafa,0xc(%esp)
c0106401:	c0 
c0106402:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0106409:	c0 
c010640a:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0106411:	00 
c0106412:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0106419:	e8 da 9f ff ff       	call   c01003f8 <__panic>

    list_entry_t free_list_store = free_list;
c010641e:	a1 e4 50 12 c0       	mov    0xc01250e4,%eax
c0106423:	8b 15 e8 50 12 c0    	mov    0xc01250e8,%edx
c0106429:	89 45 80             	mov    %eax,-0x80(%ebp)
c010642c:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010642f:	c7 45 b4 e4 50 12 c0 	movl   $0xc01250e4,-0x4c(%ebp)
    elm->prev = elm->next = elm;
c0106436:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106439:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010643c:	89 50 04             	mov    %edx,0x4(%eax)
c010643f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106442:	8b 50 04             	mov    0x4(%eax),%edx
c0106445:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106448:	89 10                	mov    %edx,(%eax)
c010644a:	c7 45 b0 e4 50 12 c0 	movl   $0xc01250e4,-0x50(%ebp)
    return list->next == list;
c0106451:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106454:	8b 40 04             	mov    0x4(%eax),%eax
c0106457:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c010645a:	0f 94 c0             	sete   %al
c010645d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0106460:	85 c0                	test   %eax,%eax
c0106462:	75 24                	jne    c0106488 <default_check+0x1d0>
c0106464:	c7 44 24 0c 4f aa 10 	movl   $0xc010aa4f,0xc(%esp)
c010646b:	c0 
c010646c:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0106473:	c0 
c0106474:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c010647b:	00 
c010647c:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0106483:	e8 70 9f ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c0106488:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010648f:	e8 e4 07 00 00       	call   c0106c78 <alloc_pages>
c0106494:	85 c0                	test   %eax,%eax
c0106496:	74 24                	je     c01064bc <default_check+0x204>
c0106498:	c7 44 24 0c 66 aa 10 	movl   $0xc010aa66,0xc(%esp)
c010649f:	c0 
c01064a0:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c01064a7:	c0 
c01064a8:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c01064af:	00 
c01064b0:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c01064b7:	e8 3c 9f ff ff       	call   c01003f8 <__panic>

    unsigned int nr_free_store = nr_free;
c01064bc:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c01064c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01064c4:	c7 05 ec 50 12 c0 00 	movl   $0x0,0xc01250ec
c01064cb:	00 00 00 

    free_pages(p0 + 2, 3);
c01064ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064d1:	83 c0 40             	add    $0x40,%eax
c01064d4:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01064db:	00 
c01064dc:	89 04 24             	mov    %eax,(%esp)
c01064df:	e8 ff 07 00 00       	call   c0106ce3 <free_pages>
    assert(alloc_pages(4) == NULL);
c01064e4:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01064eb:	e8 88 07 00 00       	call   c0106c78 <alloc_pages>
c01064f0:	85 c0                	test   %eax,%eax
c01064f2:	74 24                	je     c0106518 <default_check+0x260>
c01064f4:	c7 44 24 0c 0c ab 10 	movl   $0xc010ab0c,0xc(%esp)
c01064fb:	c0 
c01064fc:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0106503:	c0 
c0106504:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c010650b:	00 
c010650c:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0106513:	e8 e0 9e ff ff       	call   c01003f8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0106518:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010651b:	83 c0 40             	add    $0x40,%eax
c010651e:	83 c0 04             	add    $0x4,%eax
c0106521:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0106528:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010652b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010652e:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0106531:	0f a3 10             	bt     %edx,(%eax)
c0106534:	19 c0                	sbb    %eax,%eax
c0106536:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0106539:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010653d:	0f 95 c0             	setne  %al
c0106540:	0f b6 c0             	movzbl %al,%eax
c0106543:	85 c0                	test   %eax,%eax
c0106545:	74 0e                	je     c0106555 <default_check+0x29d>
c0106547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010654a:	83 c0 40             	add    $0x40,%eax
c010654d:	8b 40 08             	mov    0x8(%eax),%eax
c0106550:	83 f8 03             	cmp    $0x3,%eax
c0106553:	74 24                	je     c0106579 <default_check+0x2c1>
c0106555:	c7 44 24 0c 24 ab 10 	movl   $0xc010ab24,0xc(%esp)
c010655c:	c0 
c010655d:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0106564:	c0 
c0106565:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010656c:	00 
c010656d:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0106574:	e8 7f 9e ff ff       	call   c01003f8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0106579:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0106580:	e8 f3 06 00 00       	call   c0106c78 <alloc_pages>
c0106585:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106588:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010658c:	75 24                	jne    c01065b2 <default_check+0x2fa>
c010658e:	c7 44 24 0c 50 ab 10 	movl   $0xc010ab50,0xc(%esp)
c0106595:	c0 
c0106596:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c010659d:	c0 
c010659e:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c01065a5:	00 
c01065a6:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c01065ad:	e8 46 9e ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c01065b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01065b9:	e8 ba 06 00 00       	call   c0106c78 <alloc_pages>
c01065be:	85 c0                	test   %eax,%eax
c01065c0:	74 24                	je     c01065e6 <default_check+0x32e>
c01065c2:	c7 44 24 0c 66 aa 10 	movl   $0xc010aa66,0xc(%esp)
c01065c9:	c0 
c01065ca:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c01065d1:	c0 
c01065d2:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01065d9:	00 
c01065da:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c01065e1:	e8 12 9e ff ff       	call   c01003f8 <__panic>
    assert(p0 + 2 == p1);
c01065e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065e9:	83 c0 40             	add    $0x40,%eax
c01065ec:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01065ef:	74 24                	je     c0106615 <default_check+0x35d>
c01065f1:	c7 44 24 0c 6e ab 10 	movl   $0xc010ab6e,0xc(%esp)
c01065f8:	c0 
c01065f9:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0106600:	c0 
c0106601:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0106608:	00 
c0106609:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0106610:	e8 e3 9d ff ff       	call   c01003f8 <__panic>

    p2 = p0 + 1;
c0106615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106618:	83 c0 20             	add    $0x20,%eax
c010661b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010661e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106625:	00 
c0106626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106629:	89 04 24             	mov    %eax,(%esp)
c010662c:	e8 b2 06 00 00       	call   c0106ce3 <free_pages>
    free_pages(p1, 3);
c0106631:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0106638:	00 
c0106639:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010663c:	89 04 24             	mov    %eax,(%esp)
c010663f:	e8 9f 06 00 00       	call   c0106ce3 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0106644:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106647:	83 c0 04             	add    $0x4,%eax
c010664a:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0106651:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106654:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0106657:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010665a:	0f a3 10             	bt     %edx,(%eax)
c010665d:	19 c0                	sbb    %eax,%eax
c010665f:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0106662:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0106666:	0f 95 c0             	setne  %al
c0106669:	0f b6 c0             	movzbl %al,%eax
c010666c:	85 c0                	test   %eax,%eax
c010666e:	74 0b                	je     c010667b <default_check+0x3c3>
c0106670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106673:	8b 40 08             	mov    0x8(%eax),%eax
c0106676:	83 f8 01             	cmp    $0x1,%eax
c0106679:	74 24                	je     c010669f <default_check+0x3e7>
c010667b:	c7 44 24 0c 7c ab 10 	movl   $0xc010ab7c,0xc(%esp)
c0106682:	c0 
c0106683:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c010668a:	c0 
c010668b:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0106692:	00 
c0106693:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c010669a:	e8 59 9d ff ff       	call   c01003f8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010669f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01066a2:	83 c0 04             	add    $0x4,%eax
c01066a5:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01066ac:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01066af:	8b 45 90             	mov    -0x70(%ebp),%eax
c01066b2:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01066b5:	0f a3 10             	bt     %edx,(%eax)
c01066b8:	19 c0                	sbb    %eax,%eax
c01066ba:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01066bd:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01066c1:	0f 95 c0             	setne  %al
c01066c4:	0f b6 c0             	movzbl %al,%eax
c01066c7:	85 c0                	test   %eax,%eax
c01066c9:	74 0b                	je     c01066d6 <default_check+0x41e>
c01066cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01066ce:	8b 40 08             	mov    0x8(%eax),%eax
c01066d1:	83 f8 03             	cmp    $0x3,%eax
c01066d4:	74 24                	je     c01066fa <default_check+0x442>
c01066d6:	c7 44 24 0c a4 ab 10 	movl   $0xc010aba4,0xc(%esp)
c01066dd:	c0 
c01066de:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c01066e5:	c0 
c01066e6:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c01066ed:	00 
c01066ee:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c01066f5:	e8 fe 9c ff ff       	call   c01003f8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01066fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106701:	e8 72 05 00 00       	call   c0106c78 <alloc_pages>
c0106706:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106709:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010670c:	83 e8 20             	sub    $0x20,%eax
c010670f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0106712:	74 24                	je     c0106738 <default_check+0x480>
c0106714:	c7 44 24 0c ca ab 10 	movl   $0xc010abca,0xc(%esp)
c010671b:	c0 
c010671c:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0106723:	c0 
c0106724:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c010672b:	00 
c010672c:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0106733:	e8 c0 9c ff ff       	call   c01003f8 <__panic>
    free_page(p0);
c0106738:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010673f:	00 
c0106740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106743:	89 04 24             	mov    %eax,(%esp)
c0106746:	e8 98 05 00 00       	call   c0106ce3 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010674b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0106752:	e8 21 05 00 00       	call   c0106c78 <alloc_pages>
c0106757:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010675a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010675d:	83 c0 20             	add    $0x20,%eax
c0106760:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0106763:	74 24                	je     c0106789 <default_check+0x4d1>
c0106765:	c7 44 24 0c e8 ab 10 	movl   $0xc010abe8,0xc(%esp)
c010676c:	c0 
c010676d:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0106774:	c0 
c0106775:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c010677c:	00 
c010677d:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0106784:	e8 6f 9c ff ff       	call   c01003f8 <__panic>

    free_pages(p0, 2);
c0106789:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0106790:	00 
c0106791:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106794:	89 04 24             	mov    %eax,(%esp)
c0106797:	e8 47 05 00 00       	call   c0106ce3 <free_pages>
    free_page(p2);
c010679c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01067a3:	00 
c01067a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01067a7:	89 04 24             	mov    %eax,(%esp)
c01067aa:	e8 34 05 00 00       	call   c0106ce3 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01067af:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01067b6:	e8 bd 04 00 00       	call   c0106c78 <alloc_pages>
c01067bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01067be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01067c2:	75 24                	jne    c01067e8 <default_check+0x530>
c01067c4:	c7 44 24 0c 08 ac 10 	movl   $0xc010ac08,0xc(%esp)
c01067cb:	c0 
c01067cc:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c01067d3:	c0 
c01067d4:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c01067db:	00 
c01067dc:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c01067e3:	e8 10 9c ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c01067e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01067ef:	e8 84 04 00 00       	call   c0106c78 <alloc_pages>
c01067f4:	85 c0                	test   %eax,%eax
c01067f6:	74 24                	je     c010681c <default_check+0x564>
c01067f8:	c7 44 24 0c 66 aa 10 	movl   $0xc010aa66,0xc(%esp)
c01067ff:	c0 
c0106800:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0106807:	c0 
c0106808:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c010680f:	00 
c0106810:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0106817:	e8 dc 9b ff ff       	call   c01003f8 <__panic>

    assert(nr_free == 0);
c010681c:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0106821:	85 c0                	test   %eax,%eax
c0106823:	74 24                	je     c0106849 <default_check+0x591>
c0106825:	c7 44 24 0c b9 aa 10 	movl   $0xc010aab9,0xc(%esp)
c010682c:	c0 
c010682d:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c0106834:	c0 
c0106835:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c010683c:	00 
c010683d:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0106844:	e8 af 9b ff ff       	call   c01003f8 <__panic>
    nr_free = nr_free_store;
c0106849:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010684c:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec

    free_list = free_list_store;
c0106851:	8b 45 80             	mov    -0x80(%ebp),%eax
c0106854:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0106857:	a3 e4 50 12 c0       	mov    %eax,0xc01250e4
c010685c:	89 15 e8 50 12 c0    	mov    %edx,0xc01250e8
    free_pages(p0, 5);
c0106862:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0106869:	00 
c010686a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010686d:	89 04 24             	mov    %eax,(%esp)
c0106870:	e8 6e 04 00 00       	call   c0106ce3 <free_pages>

    le = &free_list;
c0106875:	c7 45 ec e4 50 12 c0 	movl   $0xc01250e4,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010687c:	eb 1d                	jmp    c010689b <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010687e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106881:	83 e8 0c             	sub    $0xc,%eax
c0106884:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0106887:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010688b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010688e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106891:	8b 40 08             	mov    0x8(%eax),%eax
c0106894:	29 c2                	sub    %eax,%edx
c0106896:	89 d0                	mov    %edx,%eax
c0106898:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010689b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010689e:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c01068a1:	8b 45 88             	mov    -0x78(%ebp),%eax
c01068a4:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01068a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01068aa:	81 7d ec e4 50 12 c0 	cmpl   $0xc01250e4,-0x14(%ebp)
c01068b1:	75 cb                	jne    c010687e <default_check+0x5c6>
    }
    assert(count == 0);
c01068b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01068b7:	74 24                	je     c01068dd <default_check+0x625>
c01068b9:	c7 44 24 0c 26 ac 10 	movl   $0xc010ac26,0xc(%esp)
c01068c0:	c0 
c01068c1:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c01068c8:	c0 
c01068c9:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c01068d0:	00 
c01068d1:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c01068d8:	e8 1b 9b ff ff       	call   c01003f8 <__panic>
    assert(total == 0);
c01068dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01068e1:	74 24                	je     c0106907 <default_check+0x64f>
c01068e3:	c7 44 24 0c 31 ac 10 	movl   $0xc010ac31,0xc(%esp)
c01068ea:	c0 
c01068eb:	c7 44 24 08 c6 a8 10 	movl   $0xc010a8c6,0x8(%esp)
c01068f2:	c0 
c01068f3:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c01068fa:	00 
c01068fb:	c7 04 24 db a8 10 c0 	movl   $0xc010a8db,(%esp)
c0106902:	e8 f1 9a ff ff       	call   c01003f8 <__panic>
}
c0106907:	81 c4 94 00 00 00    	add    $0x94,%esp
c010690d:	5b                   	pop    %ebx
c010690e:	5d                   	pop    %ebp
c010690f:	c3                   	ret    

c0106910 <page2ppn>:
page2ppn(struct Page *page) {
c0106910:	55                   	push   %ebp
c0106911:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0106913:	8b 55 08             	mov    0x8(%ebp),%edx
c0106916:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c010691b:	29 c2                	sub    %eax,%edx
c010691d:	89 d0                	mov    %edx,%eax
c010691f:	c1 f8 05             	sar    $0x5,%eax
}
c0106922:	5d                   	pop    %ebp
c0106923:	c3                   	ret    

c0106924 <page2pa>:
page2pa(struct Page *page) {
c0106924:	55                   	push   %ebp
c0106925:	89 e5                	mov    %esp,%ebp
c0106927:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010692a:	8b 45 08             	mov    0x8(%ebp),%eax
c010692d:	89 04 24             	mov    %eax,(%esp)
c0106930:	e8 db ff ff ff       	call   c0106910 <page2ppn>
c0106935:	c1 e0 0c             	shl    $0xc,%eax
}
c0106938:	c9                   	leave  
c0106939:	c3                   	ret    

c010693a <pa2page>:
pa2page(uintptr_t pa) {
c010693a:	55                   	push   %ebp
c010693b:	89 e5                	mov    %esp,%ebp
c010693d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0106940:	8b 45 08             	mov    0x8(%ebp),%eax
c0106943:	c1 e8 0c             	shr    $0xc,%eax
c0106946:	89 c2                	mov    %eax,%edx
c0106948:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c010694d:	39 c2                	cmp    %eax,%edx
c010694f:	72 1c                	jb     c010696d <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0106951:	c7 44 24 08 6c ac 10 	movl   $0xc010ac6c,0x8(%esp)
c0106958:	c0 
c0106959:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0106960:	00 
c0106961:	c7 04 24 8b ac 10 c0 	movl   $0xc010ac8b,(%esp)
c0106968:	e8 8b 9a ff ff       	call   c01003f8 <__panic>
    return &pages[PPN(pa)];
c010696d:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0106972:	8b 55 08             	mov    0x8(%ebp),%edx
c0106975:	c1 ea 0c             	shr    $0xc,%edx
c0106978:	c1 e2 05             	shl    $0x5,%edx
c010697b:	01 d0                	add    %edx,%eax
}
c010697d:	c9                   	leave  
c010697e:	c3                   	ret    

c010697f <page2kva>:
page2kva(struct Page *page) {
c010697f:	55                   	push   %ebp
c0106980:	89 e5                	mov    %esp,%ebp
c0106982:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0106985:	8b 45 08             	mov    0x8(%ebp),%eax
c0106988:	89 04 24             	mov    %eax,(%esp)
c010698b:	e8 94 ff ff ff       	call   c0106924 <page2pa>
c0106990:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106993:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106996:	c1 e8 0c             	shr    $0xc,%eax
c0106999:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010699c:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01069a1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01069a4:	72 23                	jb     c01069c9 <page2kva+0x4a>
c01069a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01069ad:	c7 44 24 08 9c ac 10 	movl   $0xc010ac9c,0x8(%esp)
c01069b4:	c0 
c01069b5:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01069bc:	00 
c01069bd:	c7 04 24 8b ac 10 c0 	movl   $0xc010ac8b,(%esp)
c01069c4:	e8 2f 9a ff ff       	call   c01003f8 <__panic>
c01069c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069cc:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01069d1:	c9                   	leave  
c01069d2:	c3                   	ret    

c01069d3 <kva2page>:
kva2page(void *kva) {
c01069d3:	55                   	push   %ebp
c01069d4:	89 e5                	mov    %esp,%ebp
c01069d6:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01069d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01069dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01069df:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01069e6:	77 23                	ja     c0106a0b <kva2page+0x38>
c01069e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01069ef:	c7 44 24 08 c0 ac 10 	movl   $0xc010acc0,0x8(%esp)
c01069f6:	c0 
c01069f7:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01069fe:	00 
c01069ff:	c7 04 24 8b ac 10 c0 	movl   $0xc010ac8b,(%esp)
c0106a06:	e8 ed 99 ff ff       	call   c01003f8 <__panic>
c0106a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a0e:	05 00 00 00 40       	add    $0x40000000,%eax
c0106a13:	89 04 24             	mov    %eax,(%esp)
c0106a16:	e8 1f ff ff ff       	call   c010693a <pa2page>
}
c0106a1b:	c9                   	leave  
c0106a1c:	c3                   	ret    

c0106a1d <pte2page>:
pte2page(pte_t pte) {
c0106a1d:	55                   	push   %ebp
c0106a1e:	89 e5                	mov    %esp,%ebp
c0106a20:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106a23:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a26:	83 e0 01             	and    $0x1,%eax
c0106a29:	85 c0                	test   %eax,%eax
c0106a2b:	75 1c                	jne    c0106a49 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106a2d:	c7 44 24 08 e4 ac 10 	movl   $0xc010ace4,0x8(%esp)
c0106a34:	c0 
c0106a35:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106a3c:	00 
c0106a3d:	c7 04 24 8b ac 10 c0 	movl   $0xc010ac8b,(%esp)
c0106a44:	e8 af 99 ff ff       	call   c01003f8 <__panic>
    return pa2page(PTE_ADDR(pte));
c0106a49:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a4c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106a51:	89 04 24             	mov    %eax,(%esp)
c0106a54:	e8 e1 fe ff ff       	call   c010693a <pa2page>
}
c0106a59:	c9                   	leave  
c0106a5a:	c3                   	ret    

c0106a5b <pde2page>:
pde2page(pde_t pde) {
c0106a5b:	55                   	push   %ebp
c0106a5c:	89 e5                	mov    %esp,%ebp
c0106a5e:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0106a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106a69:	89 04 24             	mov    %eax,(%esp)
c0106a6c:	e8 c9 fe ff ff       	call   c010693a <pa2page>
}
c0106a71:	c9                   	leave  
c0106a72:	c3                   	ret    

c0106a73 <page_ref>:
page_ref(struct Page *page) {
c0106a73:	55                   	push   %ebp
c0106a74:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0106a76:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a79:	8b 00                	mov    (%eax),%eax
}
c0106a7b:	5d                   	pop    %ebp
c0106a7c:	c3                   	ret    

c0106a7d <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0106a7d:	55                   	push   %ebp
c0106a7e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0106a80:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a83:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106a86:	89 10                	mov    %edx,(%eax)
}
c0106a88:	5d                   	pop    %ebp
c0106a89:	c3                   	ret    

c0106a8a <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0106a8a:	55                   	push   %ebp
c0106a8b:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0106a8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a90:	8b 00                	mov    (%eax),%eax
c0106a92:	8d 50 01             	lea    0x1(%eax),%edx
c0106a95:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a98:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a9d:	8b 00                	mov    (%eax),%eax
}
c0106a9f:	5d                   	pop    %ebp
c0106aa0:	c3                   	ret    

c0106aa1 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0106aa1:	55                   	push   %ebp
c0106aa2:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0106aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0106aa7:	8b 00                	mov    (%eax),%eax
c0106aa9:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106aac:	8b 45 08             	mov    0x8(%ebp),%eax
c0106aaf:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106ab1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ab4:	8b 00                	mov    (%eax),%eax
}
c0106ab6:	5d                   	pop    %ebp
c0106ab7:	c3                   	ret    

c0106ab8 <__intr_save>:
__intr_save(void) {
c0106ab8:	55                   	push   %ebp
c0106ab9:	89 e5                	mov    %esp,%ebp
c0106abb:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0106abe:	9c                   	pushf  
c0106abf:	58                   	pop    %eax
c0106ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0106ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0106ac6:	25 00 02 00 00       	and    $0x200,%eax
c0106acb:	85 c0                	test   %eax,%eax
c0106acd:	74 0c                	je     c0106adb <__intr_save+0x23>
        intr_disable();
c0106acf:	e8 37 b6 ff ff       	call   c010210b <intr_disable>
        return 1;
c0106ad4:	b8 01 00 00 00       	mov    $0x1,%eax
c0106ad9:	eb 05                	jmp    c0106ae0 <__intr_save+0x28>
    return 0;
c0106adb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106ae0:	c9                   	leave  
c0106ae1:	c3                   	ret    

c0106ae2 <__intr_restore>:
__intr_restore(bool flag) {
c0106ae2:	55                   	push   %ebp
c0106ae3:	89 e5                	mov    %esp,%ebp
c0106ae5:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0106ae8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106aec:	74 05                	je     c0106af3 <__intr_restore+0x11>
        intr_enable();
c0106aee:	e8 12 b6 ff ff       	call   c0102105 <intr_enable>
}
c0106af3:	c9                   	leave  
c0106af4:	c3                   	ret    

c0106af5 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0106af5:	55                   	push   %ebp
c0106af6:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0106af8:	8b 45 08             	mov    0x8(%ebp),%eax
c0106afb:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0106afe:	b8 23 00 00 00       	mov    $0x23,%eax
c0106b03:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0106b05:	b8 23 00 00 00       	mov    $0x23,%eax
c0106b0a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0106b0c:	b8 10 00 00 00       	mov    $0x10,%eax
c0106b11:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0106b13:	b8 10 00 00 00       	mov    $0x10,%eax
c0106b18:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0106b1a:	b8 10 00 00 00       	mov    $0x10,%eax
c0106b1f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0106b21:	ea 28 6b 10 c0 08 00 	ljmp   $0x8,$0xc0106b28
}
c0106b28:	5d                   	pop    %ebp
c0106b29:	c3                   	ret    

c0106b2a <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0106b2a:	55                   	push   %ebp
c0106b2b:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0106b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b30:	a3 a4 4f 12 c0       	mov    %eax,0xc0124fa4
}
c0106b35:	5d                   	pop    %ebp
c0106b36:	c3                   	ret    

c0106b37 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0106b37:	55                   	push   %ebp
c0106b38:	89 e5                	mov    %esp,%ebp
c0106b3a:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0106b3d:	b8 00 10 12 c0       	mov    $0xc0121000,%eax
c0106b42:	89 04 24             	mov    %eax,(%esp)
c0106b45:	e8 e0 ff ff ff       	call   c0106b2a <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0106b4a:	66 c7 05 a8 4f 12 c0 	movw   $0x10,0xc0124fa8
c0106b51:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0106b53:	66 c7 05 68 1a 12 c0 	movw   $0x68,0xc0121a68
c0106b5a:	68 00 
c0106b5c:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c0106b61:	66 a3 6a 1a 12 c0    	mov    %ax,0xc0121a6a
c0106b67:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c0106b6c:	c1 e8 10             	shr    $0x10,%eax
c0106b6f:	a2 6c 1a 12 c0       	mov    %al,0xc0121a6c
c0106b74:	0f b6 05 6d 1a 12 c0 	movzbl 0xc0121a6d,%eax
c0106b7b:	83 e0 f0             	and    $0xfffffff0,%eax
c0106b7e:	83 c8 09             	or     $0x9,%eax
c0106b81:	a2 6d 1a 12 c0       	mov    %al,0xc0121a6d
c0106b86:	0f b6 05 6d 1a 12 c0 	movzbl 0xc0121a6d,%eax
c0106b8d:	83 e0 ef             	and    $0xffffffef,%eax
c0106b90:	a2 6d 1a 12 c0       	mov    %al,0xc0121a6d
c0106b95:	0f b6 05 6d 1a 12 c0 	movzbl 0xc0121a6d,%eax
c0106b9c:	83 e0 9f             	and    $0xffffff9f,%eax
c0106b9f:	a2 6d 1a 12 c0       	mov    %al,0xc0121a6d
c0106ba4:	0f b6 05 6d 1a 12 c0 	movzbl 0xc0121a6d,%eax
c0106bab:	83 c8 80             	or     $0xffffff80,%eax
c0106bae:	a2 6d 1a 12 c0       	mov    %al,0xc0121a6d
c0106bb3:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106bba:	83 e0 f0             	and    $0xfffffff0,%eax
c0106bbd:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106bc2:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106bc9:	83 e0 ef             	and    $0xffffffef,%eax
c0106bcc:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106bd1:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106bd8:	83 e0 df             	and    $0xffffffdf,%eax
c0106bdb:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106be0:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106be7:	83 c8 40             	or     $0x40,%eax
c0106bea:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106bef:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106bf6:	83 e0 7f             	and    $0x7f,%eax
c0106bf9:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106bfe:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c0106c03:	c1 e8 18             	shr    $0x18,%eax
c0106c06:	a2 6f 1a 12 c0       	mov    %al,0xc0121a6f

    // reload all segment registers
    lgdt(&gdt_pd);
c0106c0b:	c7 04 24 70 1a 12 c0 	movl   $0xc0121a70,(%esp)
c0106c12:	e8 de fe ff ff       	call   c0106af5 <lgdt>
c0106c17:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0106c1d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0106c21:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0106c24:	c9                   	leave  
c0106c25:	c3                   	ret    

c0106c26 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0106c26:	55                   	push   %ebp
c0106c27:	89 e5                	mov    %esp,%ebp
c0106c29:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0106c2c:	c7 05 f0 50 12 c0 50 	movl   $0xc010ac50,0xc01250f0
c0106c33:	ac 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0106c36:	a1 f0 50 12 c0       	mov    0xc01250f0,%eax
c0106c3b:	8b 00                	mov    (%eax),%eax
c0106c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c41:	c7 04 24 10 ad 10 c0 	movl   $0xc010ad10,(%esp)
c0106c48:	e8 54 96 ff ff       	call   c01002a1 <cprintf>
    pmm_manager->init();
c0106c4d:	a1 f0 50 12 c0       	mov    0xc01250f0,%eax
c0106c52:	8b 40 04             	mov    0x4(%eax),%eax
c0106c55:	ff d0                	call   *%eax
}
c0106c57:	c9                   	leave  
c0106c58:	c3                   	ret    

c0106c59 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0106c59:	55                   	push   %ebp
c0106c5a:	89 e5                	mov    %esp,%ebp
c0106c5c:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0106c5f:	a1 f0 50 12 c0       	mov    0xc01250f0,%eax
c0106c64:	8b 40 08             	mov    0x8(%eax),%eax
c0106c67:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106c6a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106c6e:	8b 55 08             	mov    0x8(%ebp),%edx
c0106c71:	89 14 24             	mov    %edx,(%esp)
c0106c74:	ff d0                	call   *%eax
}
c0106c76:	c9                   	leave  
c0106c77:	c3                   	ret    

c0106c78 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0106c78:	55                   	push   %ebp
c0106c79:	89 e5                	mov    %esp,%ebp
c0106c7b:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0106c7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0106c85:	e8 2e fe ff ff       	call   c0106ab8 <__intr_save>
c0106c8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0106c8d:	a1 f0 50 12 c0       	mov    0xc01250f0,%eax
c0106c92:	8b 40 0c             	mov    0xc(%eax),%eax
c0106c95:	8b 55 08             	mov    0x8(%ebp),%edx
c0106c98:	89 14 24             	mov    %edx,(%esp)
c0106c9b:	ff d0                	call   *%eax
c0106c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0106ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ca3:	89 04 24             	mov    %eax,(%esp)
c0106ca6:	e8 37 fe ff ff       	call   c0106ae2 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0106cab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106caf:	75 2d                	jne    c0106cde <alloc_pages+0x66>
c0106cb1:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0106cb5:	77 27                	ja     c0106cde <alloc_pages+0x66>
c0106cb7:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c0106cbc:	85 c0                	test   %eax,%eax
c0106cbe:	74 1e                	je     c0106cde <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0106cc0:	8b 55 08             	mov    0x8(%ebp),%edx
c0106cc3:	a1 1c 50 12 c0       	mov    0xc012501c,%eax
c0106cc8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106ccf:	00 
c0106cd0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106cd4:	89 04 24             	mov    %eax,(%esp)
c0106cd7:	e8 e3 da ff ff       	call   c01047bf <swap_out>
    }
c0106cdc:	eb a7                	jmp    c0106c85 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0106cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106ce1:	c9                   	leave  
c0106ce2:	c3                   	ret    

c0106ce3 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0106ce3:	55                   	push   %ebp
c0106ce4:	89 e5                	mov    %esp,%ebp
c0106ce6:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0106ce9:	e8 ca fd ff ff       	call   c0106ab8 <__intr_save>
c0106cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0106cf1:	a1 f0 50 12 c0       	mov    0xc01250f0,%eax
c0106cf6:	8b 40 10             	mov    0x10(%eax),%eax
c0106cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106cfc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106d00:	8b 55 08             	mov    0x8(%ebp),%edx
c0106d03:	89 14 24             	mov    %edx,(%esp)
c0106d06:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0106d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d0b:	89 04 24             	mov    %eax,(%esp)
c0106d0e:	e8 cf fd ff ff       	call   c0106ae2 <__intr_restore>
}
c0106d13:	c9                   	leave  
c0106d14:	c3                   	ret    

c0106d15 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0106d15:	55                   	push   %ebp
c0106d16:	89 e5                	mov    %esp,%ebp
c0106d18:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0106d1b:	e8 98 fd ff ff       	call   c0106ab8 <__intr_save>
c0106d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0106d23:	a1 f0 50 12 c0       	mov    0xc01250f0,%eax
c0106d28:	8b 40 14             	mov    0x14(%eax),%eax
c0106d2b:	ff d0                	call   *%eax
c0106d2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0106d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d33:	89 04 24             	mov    %eax,(%esp)
c0106d36:	e8 a7 fd ff ff       	call   c0106ae2 <__intr_restore>
    return ret;
c0106d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0106d3e:	c9                   	leave  
c0106d3f:	c3                   	ret    

c0106d40 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0106d40:	55                   	push   %ebp
c0106d41:	89 e5                	mov    %esp,%ebp
c0106d43:	57                   	push   %edi
c0106d44:	56                   	push   %esi
c0106d45:	53                   	push   %ebx
c0106d46:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0106d4c:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0106d53:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0106d5a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0106d61:	c7 04 24 27 ad 10 c0 	movl   $0xc010ad27,(%esp)
c0106d68:	e8 34 95 ff ff       	call   c01002a1 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0106d6d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106d74:	e9 15 01 00 00       	jmp    c0106e8e <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106d79:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106d7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106d7f:	89 d0                	mov    %edx,%eax
c0106d81:	c1 e0 02             	shl    $0x2,%eax
c0106d84:	01 d0                	add    %edx,%eax
c0106d86:	c1 e0 02             	shl    $0x2,%eax
c0106d89:	01 c8                	add    %ecx,%eax
c0106d8b:	8b 50 08             	mov    0x8(%eax),%edx
c0106d8e:	8b 40 04             	mov    0x4(%eax),%eax
c0106d91:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106d94:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0106d97:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106d9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106d9d:	89 d0                	mov    %edx,%eax
c0106d9f:	c1 e0 02             	shl    $0x2,%eax
c0106da2:	01 d0                	add    %edx,%eax
c0106da4:	c1 e0 02             	shl    $0x2,%eax
c0106da7:	01 c8                	add    %ecx,%eax
c0106da9:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106dac:	8b 58 10             	mov    0x10(%eax),%ebx
c0106daf:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106db2:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0106db5:	01 c8                	add    %ecx,%eax
c0106db7:	11 da                	adc    %ebx,%edx
c0106db9:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0106dbc:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0106dbf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106dc2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106dc5:	89 d0                	mov    %edx,%eax
c0106dc7:	c1 e0 02             	shl    $0x2,%eax
c0106dca:	01 d0                	add    %edx,%eax
c0106dcc:	c1 e0 02             	shl    $0x2,%eax
c0106dcf:	01 c8                	add    %ecx,%eax
c0106dd1:	83 c0 14             	add    $0x14,%eax
c0106dd4:	8b 00                	mov    (%eax),%eax
c0106dd6:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0106ddc:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106ddf:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106de2:	83 c0 ff             	add    $0xffffffff,%eax
c0106de5:	83 d2 ff             	adc    $0xffffffff,%edx
c0106de8:	89 c6                	mov    %eax,%esi
c0106dea:	89 d7                	mov    %edx,%edi
c0106dec:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106def:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106df2:	89 d0                	mov    %edx,%eax
c0106df4:	c1 e0 02             	shl    $0x2,%eax
c0106df7:	01 d0                	add    %edx,%eax
c0106df9:	c1 e0 02             	shl    $0x2,%eax
c0106dfc:	01 c8                	add    %ecx,%eax
c0106dfe:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106e01:	8b 58 10             	mov    0x10(%eax),%ebx
c0106e04:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0106e0a:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0106e0e:	89 74 24 14          	mov    %esi,0x14(%esp)
c0106e12:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0106e16:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106e19:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0106e1c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106e20:	89 54 24 10          	mov    %edx,0x10(%esp)
c0106e24:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0106e28:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0106e2c:	c7 04 24 34 ad 10 c0 	movl   $0xc010ad34,(%esp)
c0106e33:	e8 69 94 ff ff       	call   c01002a1 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0106e38:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106e3b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106e3e:	89 d0                	mov    %edx,%eax
c0106e40:	c1 e0 02             	shl    $0x2,%eax
c0106e43:	01 d0                	add    %edx,%eax
c0106e45:	c1 e0 02             	shl    $0x2,%eax
c0106e48:	01 c8                	add    %ecx,%eax
c0106e4a:	83 c0 14             	add    $0x14,%eax
c0106e4d:	8b 00                	mov    (%eax),%eax
c0106e4f:	83 f8 01             	cmp    $0x1,%eax
c0106e52:	75 36                	jne    c0106e8a <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0106e54:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106e57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106e5a:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0106e5d:	77 2b                	ja     c0106e8a <page_init+0x14a>
c0106e5f:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0106e62:	72 05                	jb     c0106e69 <page_init+0x129>
c0106e64:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0106e67:	73 21                	jae    c0106e8a <page_init+0x14a>
c0106e69:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106e6d:	77 1b                	ja     c0106e8a <page_init+0x14a>
c0106e6f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106e73:	72 09                	jb     c0106e7e <page_init+0x13e>
c0106e75:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0106e7c:	77 0c                	ja     c0106e8a <page_init+0x14a>
                maxpa = end;
c0106e7e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106e81:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106e84:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106e87:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0106e8a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0106e8e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106e91:	8b 00                	mov    (%eax),%eax
c0106e93:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0106e96:	0f 8f dd fe ff ff    	jg     c0106d79 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0106e9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106ea0:	72 1d                	jb     c0106ebf <page_init+0x17f>
c0106ea2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106ea6:	77 09                	ja     c0106eb1 <page_init+0x171>
c0106ea8:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0106eaf:	76 0e                	jbe    c0106ebf <page_init+0x17f>
        maxpa = KMEMSIZE;
c0106eb1:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0106eb8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0106ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106ec2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106ec5:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0106ec9:	c1 ea 0c             	shr    $0xc,%edx
c0106ecc:	a3 80 4f 12 c0       	mov    %eax,0xc0124f80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0106ed1:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0106ed8:	b8 fc 50 12 c0       	mov    $0xc01250fc,%eax
c0106edd:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106ee0:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106ee3:	01 d0                	add    %edx,%eax
c0106ee5:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0106ee8:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106eeb:	ba 00 00 00 00       	mov    $0x0,%edx
c0106ef0:	f7 75 ac             	divl   -0x54(%ebp)
c0106ef3:	89 d0                	mov    %edx,%eax
c0106ef5:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0106ef8:	29 c2                	sub    %eax,%edx
c0106efa:	89 d0                	mov    %edx,%eax
c0106efc:	a3 f8 50 12 c0       	mov    %eax,0xc01250f8

    for (i = 0; i < npage; i ++) {
c0106f01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106f08:	eb 27                	jmp    c0106f31 <page_init+0x1f1>
        SetPageReserved(pages + i);
c0106f0a:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0106f0f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106f12:	c1 e2 05             	shl    $0x5,%edx
c0106f15:	01 d0                	add    %edx,%eax
c0106f17:	83 c0 04             	add    $0x4,%eax
c0106f1a:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0106f21:	89 45 8c             	mov    %eax,-0x74(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0106f24:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0106f27:	8b 55 90             	mov    -0x70(%ebp),%edx
c0106f2a:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0106f2d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0106f31:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106f34:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106f39:	39 c2                	cmp    %eax,%edx
c0106f3b:	72 cd                	jb     c0106f0a <page_init+0x1ca>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0106f3d:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106f42:	c1 e0 05             	shl    $0x5,%eax
c0106f45:	89 c2                	mov    %eax,%edx
c0106f47:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0106f4c:	01 d0                	add    %edx,%eax
c0106f4e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0106f51:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0106f58:	77 23                	ja     c0106f7d <page_init+0x23d>
c0106f5a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106f5d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106f61:	c7 44 24 08 c0 ac 10 	movl   $0xc010acc0,0x8(%esp)
c0106f68:	c0 
c0106f69:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0106f70:	00 
c0106f71:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0106f78:	e8 7b 94 ff ff       	call   c01003f8 <__panic>
c0106f7d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106f80:	05 00 00 00 40       	add    $0x40000000,%eax
c0106f85:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0106f88:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106f8f:	e9 74 01 00 00       	jmp    c0107108 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106f94:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106f97:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106f9a:	89 d0                	mov    %edx,%eax
c0106f9c:	c1 e0 02             	shl    $0x2,%eax
c0106f9f:	01 d0                	add    %edx,%eax
c0106fa1:	c1 e0 02             	shl    $0x2,%eax
c0106fa4:	01 c8                	add    %ecx,%eax
c0106fa6:	8b 50 08             	mov    0x8(%eax),%edx
c0106fa9:	8b 40 04             	mov    0x4(%eax),%eax
c0106fac:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106faf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106fb2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106fb5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106fb8:	89 d0                	mov    %edx,%eax
c0106fba:	c1 e0 02             	shl    $0x2,%eax
c0106fbd:	01 d0                	add    %edx,%eax
c0106fbf:	c1 e0 02             	shl    $0x2,%eax
c0106fc2:	01 c8                	add    %ecx,%eax
c0106fc4:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106fc7:	8b 58 10             	mov    0x10(%eax),%ebx
c0106fca:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106fcd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106fd0:	01 c8                	add    %ecx,%eax
c0106fd2:	11 da                	adc    %ebx,%edx
c0106fd4:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0106fd7:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0106fda:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106fdd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106fe0:	89 d0                	mov    %edx,%eax
c0106fe2:	c1 e0 02             	shl    $0x2,%eax
c0106fe5:	01 d0                	add    %edx,%eax
c0106fe7:	c1 e0 02             	shl    $0x2,%eax
c0106fea:	01 c8                	add    %ecx,%eax
c0106fec:	83 c0 14             	add    $0x14,%eax
c0106fef:	8b 00                	mov    (%eax),%eax
c0106ff1:	83 f8 01             	cmp    $0x1,%eax
c0106ff4:	0f 85 0a 01 00 00    	jne    c0107104 <page_init+0x3c4>
            if (begin < freemem) {
c0106ffa:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106ffd:	ba 00 00 00 00       	mov    $0x0,%edx
c0107002:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107005:	72 17                	jb     c010701e <page_init+0x2de>
c0107007:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010700a:	77 05                	ja     c0107011 <page_init+0x2d1>
c010700c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010700f:	76 0d                	jbe    c010701e <page_init+0x2de>
                begin = freemem;
c0107011:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0107014:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107017:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010701e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107022:	72 1d                	jb     c0107041 <page_init+0x301>
c0107024:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107028:	77 09                	ja     c0107033 <page_init+0x2f3>
c010702a:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0107031:	76 0e                	jbe    c0107041 <page_init+0x301>
                end = KMEMSIZE;
c0107033:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010703a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0107041:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107044:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107047:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010704a:	0f 87 b4 00 00 00    	ja     c0107104 <page_init+0x3c4>
c0107050:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0107053:	72 09                	jb     c010705e <page_init+0x31e>
c0107055:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0107058:	0f 83 a6 00 00 00    	jae    c0107104 <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c010705e:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0107065:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107068:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010706b:	01 d0                	add    %edx,%eax
c010706d:	83 e8 01             	sub    $0x1,%eax
c0107070:	89 45 98             	mov    %eax,-0x68(%ebp)
c0107073:	8b 45 98             	mov    -0x68(%ebp),%eax
c0107076:	ba 00 00 00 00       	mov    $0x0,%edx
c010707b:	f7 75 9c             	divl   -0x64(%ebp)
c010707e:	89 d0                	mov    %edx,%eax
c0107080:	8b 55 98             	mov    -0x68(%ebp),%edx
c0107083:	29 c2                	sub    %eax,%edx
c0107085:	89 d0                	mov    %edx,%eax
c0107087:	ba 00 00 00 00       	mov    $0x0,%edx
c010708c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010708f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0107092:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107095:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0107098:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010709b:	ba 00 00 00 00       	mov    $0x0,%edx
c01070a0:	89 c7                	mov    %eax,%edi
c01070a2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01070a8:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01070ab:	89 d0                	mov    %edx,%eax
c01070ad:	83 e0 00             	and    $0x0,%eax
c01070b0:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01070b3:	8b 45 80             	mov    -0x80(%ebp),%eax
c01070b6:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01070b9:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01070bc:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01070bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01070c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01070c5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01070c8:	77 3a                	ja     c0107104 <page_init+0x3c4>
c01070ca:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01070cd:	72 05                	jb     c01070d4 <page_init+0x394>
c01070cf:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01070d2:	73 30                	jae    c0107104 <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01070d4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01070d7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01070da:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01070dd:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01070e0:	29 c8                	sub    %ecx,%eax
c01070e2:	19 da                	sbb    %ebx,%edx
c01070e4:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01070e8:	c1 ea 0c             	shr    $0xc,%edx
c01070eb:	89 c3                	mov    %eax,%ebx
c01070ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01070f0:	89 04 24             	mov    %eax,(%esp)
c01070f3:	e8 42 f8 ff ff       	call   c010693a <pa2page>
c01070f8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01070fc:	89 04 24             	mov    %eax,(%esp)
c01070ff:	e8 55 fb ff ff       	call   c0106c59 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c0107104:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0107108:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010710b:	8b 00                	mov    (%eax),%eax
c010710d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0107110:	0f 8f 7e fe ff ff    	jg     c0106f94 <page_init+0x254>
                }
            }
        }
    }
}
c0107116:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010711c:	5b                   	pop    %ebx
c010711d:	5e                   	pop    %esi
c010711e:	5f                   	pop    %edi
c010711f:	5d                   	pop    %ebp
c0107120:	c3                   	ret    

c0107121 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0107121:	55                   	push   %ebp
c0107122:	89 e5                	mov    %esp,%ebp
c0107124:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0107127:	8b 45 14             	mov    0x14(%ebp),%eax
c010712a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010712d:	31 d0                	xor    %edx,%eax
c010712f:	25 ff 0f 00 00       	and    $0xfff,%eax
c0107134:	85 c0                	test   %eax,%eax
c0107136:	74 24                	je     c010715c <boot_map_segment+0x3b>
c0107138:	c7 44 24 0c 72 ad 10 	movl   $0xc010ad72,0xc(%esp)
c010713f:	c0 
c0107140:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107147:	c0 
c0107148:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c010714f:	00 
c0107150:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107157:	e8 9c 92 ff ff       	call   c01003f8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010715c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0107163:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107166:	25 ff 0f 00 00       	and    $0xfff,%eax
c010716b:	89 c2                	mov    %eax,%edx
c010716d:	8b 45 10             	mov    0x10(%ebp),%eax
c0107170:	01 c2                	add    %eax,%edx
c0107172:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107175:	01 d0                	add    %edx,%eax
c0107177:	83 e8 01             	sub    $0x1,%eax
c010717a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010717d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107180:	ba 00 00 00 00       	mov    $0x0,%edx
c0107185:	f7 75 f0             	divl   -0x10(%ebp)
c0107188:	89 d0                	mov    %edx,%eax
c010718a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010718d:	29 c2                	sub    %eax,%edx
c010718f:	89 d0                	mov    %edx,%eax
c0107191:	c1 e8 0c             	shr    $0xc,%eax
c0107194:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0107197:	8b 45 0c             	mov    0xc(%ebp),%eax
c010719a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010719d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01071a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01071a5:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01071a8:	8b 45 14             	mov    0x14(%ebp),%eax
c01071ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01071ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01071b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01071b6:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01071b9:	eb 6b                	jmp    c0107226 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01071bb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01071c2:	00 
c01071c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01071ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01071cd:	89 04 24             	mov    %eax,(%esp)
c01071d0:	e8 82 01 00 00       	call   c0107357 <get_pte>
c01071d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01071d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01071dc:	75 24                	jne    c0107202 <boot_map_segment+0xe1>
c01071de:	c7 44 24 0c 9e ad 10 	movl   $0xc010ad9e,0xc(%esp)
c01071e5:	c0 
c01071e6:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c01071ed:	c0 
c01071ee:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c01071f5:	00 
c01071f6:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c01071fd:	e8 f6 91 ff ff       	call   c01003f8 <__panic>
        *ptep = pa | PTE_P | perm;
c0107202:	8b 45 18             	mov    0x18(%ebp),%eax
c0107205:	8b 55 14             	mov    0x14(%ebp),%edx
c0107208:	09 d0                	or     %edx,%eax
c010720a:	83 c8 01             	or     $0x1,%eax
c010720d:	89 c2                	mov    %eax,%edx
c010720f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107212:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0107214:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107218:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010721f:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0107226:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010722a:	75 8f                	jne    c01071bb <boot_map_segment+0x9a>
    }
}
c010722c:	c9                   	leave  
c010722d:	c3                   	ret    

c010722e <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010722e:	55                   	push   %ebp
c010722f:	89 e5                	mov    %esp,%ebp
c0107231:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0107234:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010723b:	e8 38 fa ff ff       	call   c0106c78 <alloc_pages>
c0107240:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0107243:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107247:	75 1c                	jne    c0107265 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0107249:	c7 44 24 08 ab ad 10 	movl   $0xc010adab,0x8(%esp)
c0107250:	c0 
c0107251:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0107258:	00 
c0107259:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107260:	e8 93 91 ff ff       	call   c01003f8 <__panic>
    }
    return page2kva(p);
c0107265:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107268:	89 04 24             	mov    %eax,(%esp)
c010726b:	e8 0f f7 ff ff       	call   c010697f <page2kva>
}
c0107270:	c9                   	leave  
c0107271:	c3                   	ret    

c0107272 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0107272:	55                   	push   %ebp
c0107273:	89 e5                	mov    %esp,%ebp
c0107275:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0107278:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010727d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107280:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0107287:	77 23                	ja     c01072ac <pmm_init+0x3a>
c0107289:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010728c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107290:	c7 44 24 08 c0 ac 10 	movl   $0xc010acc0,0x8(%esp)
c0107297:	c0 
c0107298:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c010729f:	00 
c01072a0:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c01072a7:	e8 4c 91 ff ff       	call   c01003f8 <__panic>
c01072ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072af:	05 00 00 00 40       	add    $0x40000000,%eax
c01072b4:	a3 f4 50 12 c0       	mov    %eax,0xc01250f4
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01072b9:	e8 68 f9 ff ff       	call   c0106c26 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01072be:	e8 7d fa ff ff       	call   c0106d40 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01072c3:	e8 a6 04 00 00       	call   c010776e <check_alloc_page>

    check_pgdir();
c01072c8:	e8 bf 04 00 00       	call   c010778c <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01072cd:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01072d2:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01072d8:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01072dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01072e0:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01072e7:	77 23                	ja     c010730c <pmm_init+0x9a>
c01072e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01072f0:	c7 44 24 08 c0 ac 10 	movl   $0xc010acc0,0x8(%esp)
c01072f7:	c0 
c01072f8:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c01072ff:	00 
c0107300:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107307:	e8 ec 90 ff ff       	call   c01003f8 <__panic>
c010730c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010730f:	05 00 00 00 40       	add    $0x40000000,%eax
c0107314:	83 c8 03             	or     $0x3,%eax
c0107317:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0107319:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010731e:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0107325:	00 
c0107326:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010732d:	00 
c010732e:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0107335:	38 
c0107336:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010733d:	c0 
c010733e:	89 04 24             	mov    %eax,(%esp)
c0107341:	e8 db fd ff ff       	call   c0107121 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0107346:	e8 ec f7 ff ff       	call   c0106b37 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010734b:	e8 d7 0a 00 00       	call   c0107e27 <check_boot_pgdir>

    print_pgdir();
c0107350:	e8 5f 0f 00 00       	call   c01082b4 <print_pgdir>

}
c0107355:	c9                   	leave  
c0107356:	c3                   	ret    

c0107357 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0107357:	55                   	push   %ebp
c0107358:	89 e5                	mov    %esp,%ebp
c010735a:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c010735d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107360:	c1 e8 16             	shr    $0x16,%eax
c0107363:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010736a:	8b 45 08             	mov    0x8(%ebp),%eax
c010736d:	01 d0                	add    %edx,%eax
c010736f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0107372:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107375:	8b 00                	mov    (%eax),%eax
c0107377:	83 e0 01             	and    $0x1,%eax
c010737a:	85 c0                	test   %eax,%eax
c010737c:	0f 85 af 00 00 00    	jne    c0107431 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c0107382:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107386:	74 15                	je     c010739d <get_pte+0x46>
c0107388:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010738f:	e8 e4 f8 ff ff       	call   c0106c78 <alloc_pages>
c0107394:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107397:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010739b:	75 0a                	jne    c01073a7 <get_pte+0x50>
            return NULL;
c010739d:	b8 00 00 00 00       	mov    $0x0,%eax
c01073a2:	e9 e6 00 00 00       	jmp    c010748d <get_pte+0x136>
        }
        set_page_ref(page, 1);
c01073a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01073ae:	00 
c01073af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073b2:	89 04 24             	mov    %eax,(%esp)
c01073b5:	e8 c3 f6 ff ff       	call   c0106a7d <set_page_ref>
        uintptr_t pa = page2pa(page);
c01073ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073bd:	89 04 24             	mov    %eax,(%esp)
c01073c0:	e8 5f f5 ff ff       	call   c0106924 <page2pa>
c01073c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c01073c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01073cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01073ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01073d1:	c1 e8 0c             	shr    $0xc,%eax
c01073d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01073d7:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01073dc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01073df:	72 23                	jb     c0107404 <get_pte+0xad>
c01073e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01073e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01073e8:	c7 44 24 08 9c ac 10 	movl   $0xc010ac9c,0x8(%esp)
c01073ef:	c0 
c01073f0:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
c01073f7:	00 
c01073f8:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c01073ff:	e8 f4 8f ff ff       	call   c01003f8 <__panic>
c0107404:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107407:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010740c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107413:	00 
c0107414:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010741b:	00 
c010741c:	89 04 24             	mov    %eax,(%esp)
c010741f:	e8 11 16 00 00       	call   c0108a35 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0107424:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107427:	83 c8 07             	or     $0x7,%eax
c010742a:	89 c2                	mov    %eax,%edx
c010742c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010742f:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0107431:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107434:	8b 00                	mov    (%eax),%eax
c0107436:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010743b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010743e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107441:	c1 e8 0c             	shr    $0xc,%eax
c0107444:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107447:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c010744c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010744f:	72 23                	jb     c0107474 <get_pte+0x11d>
c0107451:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107454:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107458:	c7 44 24 08 9c ac 10 	movl   $0xc010ac9c,0x8(%esp)
c010745f:	c0 
c0107460:	c7 44 24 04 82 01 00 	movl   $0x182,0x4(%esp)
c0107467:	00 
c0107468:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c010746f:	e8 84 8f ff ff       	call   c01003f8 <__panic>
c0107474:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107477:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010747c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010747f:	c1 ea 0c             	shr    $0xc,%edx
c0107482:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0107488:	c1 e2 02             	shl    $0x2,%edx
c010748b:	01 d0                	add    %edx,%eax
}
c010748d:	c9                   	leave  
c010748e:	c3                   	ret    

c010748f <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010748f:	55                   	push   %ebp
c0107490:	89 e5                	mov    %esp,%ebp
c0107492:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0107495:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010749c:	00 
c010749d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01074a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01074a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01074a7:	89 04 24             	mov    %eax,(%esp)
c01074aa:	e8 a8 fe ff ff       	call   c0107357 <get_pte>
c01074af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01074b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01074b6:	74 08                	je     c01074c0 <get_page+0x31>
        *ptep_store = ptep;
c01074b8:	8b 45 10             	mov    0x10(%ebp),%eax
c01074bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01074be:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01074c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01074c4:	74 1b                	je     c01074e1 <get_page+0x52>
c01074c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074c9:	8b 00                	mov    (%eax),%eax
c01074cb:	83 e0 01             	and    $0x1,%eax
c01074ce:	85 c0                	test   %eax,%eax
c01074d0:	74 0f                	je     c01074e1 <get_page+0x52>
        return pte2page(*ptep);
c01074d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074d5:	8b 00                	mov    (%eax),%eax
c01074d7:	89 04 24             	mov    %eax,(%esp)
c01074da:	e8 3e f5 ff ff       	call   c0106a1d <pte2page>
c01074df:	eb 05                	jmp    c01074e6 <get_page+0x57>
    }
    return NULL;
c01074e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01074e6:	c9                   	leave  
c01074e7:	c3                   	ret    

c01074e8 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01074e8:	55                   	push   %ebp
c01074e9:	89 e5                	mov    %esp,%ebp
c01074eb:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c01074ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01074f1:	8b 00                	mov    (%eax),%eax
c01074f3:	83 e0 01             	and    $0x1,%eax
c01074f6:	85 c0                	test   %eax,%eax
c01074f8:	74 4d                	je     c0107547 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c01074fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01074fd:	8b 00                	mov    (%eax),%eax
c01074ff:	89 04 24             	mov    %eax,(%esp)
c0107502:	e8 16 f5 ff ff       	call   c0106a1d <pte2page>
c0107507:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c010750a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010750d:	89 04 24             	mov    %eax,(%esp)
c0107510:	e8 8c f5 ff ff       	call   c0106aa1 <page_ref_dec>
c0107515:	85 c0                	test   %eax,%eax
c0107517:	75 13                	jne    c010752c <page_remove_pte+0x44>
            free_page(page);
c0107519:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107520:	00 
c0107521:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107524:	89 04 24             	mov    %eax,(%esp)
c0107527:	e8 b7 f7 ff ff       	call   c0106ce3 <free_pages>
        }
        *ptep = 0;
c010752c:	8b 45 10             	mov    0x10(%ebp),%eax
c010752f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0107535:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107538:	89 44 24 04          	mov    %eax,0x4(%esp)
c010753c:	8b 45 08             	mov    0x8(%ebp),%eax
c010753f:	89 04 24             	mov    %eax,(%esp)
c0107542:	e8 ff 00 00 00       	call   c0107646 <tlb_invalidate>
    }
}
c0107547:	c9                   	leave  
c0107548:	c3                   	ret    

c0107549 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0107549:	55                   	push   %ebp
c010754a:	89 e5                	mov    %esp,%ebp
c010754c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010754f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107556:	00 
c0107557:	8b 45 0c             	mov    0xc(%ebp),%eax
c010755a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010755e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107561:	89 04 24             	mov    %eax,(%esp)
c0107564:	e8 ee fd ff ff       	call   c0107357 <get_pte>
c0107569:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010756c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107570:	74 19                	je     c010758b <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0107572:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107575:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107579:	8b 45 0c             	mov    0xc(%ebp),%eax
c010757c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107580:	8b 45 08             	mov    0x8(%ebp),%eax
c0107583:	89 04 24             	mov    %eax,(%esp)
c0107586:	e8 5d ff ff ff       	call   c01074e8 <page_remove_pte>
    }
}
c010758b:	c9                   	leave  
c010758c:	c3                   	ret    

c010758d <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010758d:	55                   	push   %ebp
c010758e:	89 e5                	mov    %esp,%ebp
c0107590:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0107593:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010759a:	00 
c010759b:	8b 45 10             	mov    0x10(%ebp),%eax
c010759e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01075a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01075a5:	89 04 24             	mov    %eax,(%esp)
c01075a8:	e8 aa fd ff ff       	call   c0107357 <get_pte>
c01075ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01075b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01075b4:	75 0a                	jne    c01075c0 <page_insert+0x33>
        return -E_NO_MEM;
c01075b6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01075bb:	e9 84 00 00 00       	jmp    c0107644 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01075c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01075c3:	89 04 24             	mov    %eax,(%esp)
c01075c6:	e8 bf f4 ff ff       	call   c0106a8a <page_ref_inc>
    if (*ptep & PTE_P) {
c01075cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01075ce:	8b 00                	mov    (%eax),%eax
c01075d0:	83 e0 01             	and    $0x1,%eax
c01075d3:	85 c0                	test   %eax,%eax
c01075d5:	74 3e                	je     c0107615 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01075d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01075da:	8b 00                	mov    (%eax),%eax
c01075dc:	89 04 24             	mov    %eax,(%esp)
c01075df:	e8 39 f4 ff ff       	call   c0106a1d <pte2page>
c01075e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01075e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01075ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01075ed:	75 0d                	jne    c01075fc <page_insert+0x6f>
            page_ref_dec(page);
c01075ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01075f2:	89 04 24             	mov    %eax,(%esp)
c01075f5:	e8 a7 f4 ff ff       	call   c0106aa1 <page_ref_dec>
c01075fa:	eb 19                	jmp    c0107615 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01075fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01075ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107603:	8b 45 10             	mov    0x10(%ebp),%eax
c0107606:	89 44 24 04          	mov    %eax,0x4(%esp)
c010760a:	8b 45 08             	mov    0x8(%ebp),%eax
c010760d:	89 04 24             	mov    %eax,(%esp)
c0107610:	e8 d3 fe ff ff       	call   c01074e8 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0107615:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107618:	89 04 24             	mov    %eax,(%esp)
c010761b:	e8 04 f3 ff ff       	call   c0106924 <page2pa>
c0107620:	0b 45 14             	or     0x14(%ebp),%eax
c0107623:	83 c8 01             	or     $0x1,%eax
c0107626:	89 c2                	mov    %eax,%edx
c0107628:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010762b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010762d:	8b 45 10             	mov    0x10(%ebp),%eax
c0107630:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107634:	8b 45 08             	mov    0x8(%ebp),%eax
c0107637:	89 04 24             	mov    %eax,(%esp)
c010763a:	e8 07 00 00 00       	call   c0107646 <tlb_invalidate>
    return 0;
c010763f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107644:	c9                   	leave  
c0107645:	c3                   	ret    

c0107646 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0107646:	55                   	push   %ebp
c0107647:	89 e5                	mov    %esp,%ebp
c0107649:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010764c:	0f 20 d8             	mov    %cr3,%eax
c010764f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0107652:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0107655:	89 c2                	mov    %eax,%edx
c0107657:	8b 45 08             	mov    0x8(%ebp),%eax
c010765a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010765d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0107664:	77 23                	ja     c0107689 <tlb_invalidate+0x43>
c0107666:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107669:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010766d:	c7 44 24 08 c0 ac 10 	movl   $0xc010acc0,0x8(%esp)
c0107674:	c0 
c0107675:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c010767c:	00 
c010767d:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107684:	e8 6f 8d ff ff       	call   c01003f8 <__panic>
c0107689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010768c:	05 00 00 00 40       	add    $0x40000000,%eax
c0107691:	39 c2                	cmp    %eax,%edx
c0107693:	75 0c                	jne    c01076a1 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0107695:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107698:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010769b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010769e:	0f 01 38             	invlpg (%eax)
    }
}
c01076a1:	c9                   	leave  
c01076a2:	c3                   	ret    

c01076a3 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c01076a3:	55                   	push   %ebp
c01076a4:	89 e5                	mov    %esp,%ebp
c01076a6:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c01076a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01076b0:	e8 c3 f5 ff ff       	call   c0106c78 <alloc_pages>
c01076b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01076b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01076bc:	0f 84 a7 00 00 00    	je     c0107769 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01076c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01076c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01076c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01076cc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01076d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01076d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01076da:	89 04 24             	mov    %eax,(%esp)
c01076dd:	e8 ab fe ff ff       	call   c010758d <page_insert>
c01076e2:	85 c0                	test   %eax,%eax
c01076e4:	74 1a                	je     c0107700 <pgdir_alloc_page+0x5d>
            free_page(page);
c01076e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01076ed:	00 
c01076ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076f1:	89 04 24             	mov    %eax,(%esp)
c01076f4:	e8 ea f5 ff ff       	call   c0106ce3 <free_pages>
            return NULL;
c01076f9:	b8 00 00 00 00       	mov    $0x0,%eax
c01076fe:	eb 6c                	jmp    c010776c <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c0107700:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c0107705:	85 c0                	test   %eax,%eax
c0107707:	74 60                	je     c0107769 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0107709:	a1 1c 50 12 c0       	mov    0xc012501c,%eax
c010770e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0107715:	00 
c0107716:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107719:	89 54 24 08          	mov    %edx,0x8(%esp)
c010771d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107720:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107724:	89 04 24             	mov    %eax,(%esp)
c0107727:	e8 47 d0 ff ff       	call   c0104773 <swap_map_swappable>
            page->pra_vaddr=la;
c010772c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010772f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107732:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0107735:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107738:	89 04 24             	mov    %eax,(%esp)
c010773b:	e8 33 f3 ff ff       	call   c0106a73 <page_ref>
c0107740:	83 f8 01             	cmp    $0x1,%eax
c0107743:	74 24                	je     c0107769 <pgdir_alloc_page+0xc6>
c0107745:	c7 44 24 0c c4 ad 10 	movl   $0xc010adc4,0xc(%esp)
c010774c:	c0 
c010774d:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107754:	c0 
c0107755:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c010775c:	00 
c010775d:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107764:	e8 8f 8c ff ff       	call   c01003f8 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0107769:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010776c:	c9                   	leave  
c010776d:	c3                   	ret    

c010776e <check_alloc_page>:

static void
check_alloc_page(void) {
c010776e:	55                   	push   %ebp
c010776f:	89 e5                	mov    %esp,%ebp
c0107771:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0107774:	a1 f0 50 12 c0       	mov    0xc01250f0,%eax
c0107779:	8b 40 18             	mov    0x18(%eax),%eax
c010777c:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010777e:	c7 04 24 d8 ad 10 c0 	movl   $0xc010add8,(%esp)
c0107785:	e8 17 8b ff ff       	call   c01002a1 <cprintf>
}
c010778a:	c9                   	leave  
c010778b:	c3                   	ret    

c010778c <check_pgdir>:

static void
check_pgdir(void) {
c010778c:	55                   	push   %ebp
c010778d:	89 e5                	mov    %esp,%ebp
c010778f:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0107792:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107797:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010779c:	76 24                	jbe    c01077c2 <check_pgdir+0x36>
c010779e:	c7 44 24 0c f7 ad 10 	movl   $0xc010adf7,0xc(%esp)
c01077a5:	c0 
c01077a6:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c01077ad:	c0 
c01077ae:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c01077b5:	00 
c01077b6:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c01077bd:	e8 36 8c ff ff       	call   c01003f8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01077c2:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01077c7:	85 c0                	test   %eax,%eax
c01077c9:	74 0e                	je     c01077d9 <check_pgdir+0x4d>
c01077cb:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01077d0:	25 ff 0f 00 00       	and    $0xfff,%eax
c01077d5:	85 c0                	test   %eax,%eax
c01077d7:	74 24                	je     c01077fd <check_pgdir+0x71>
c01077d9:	c7 44 24 0c 14 ae 10 	movl   $0xc010ae14,0xc(%esp)
c01077e0:	c0 
c01077e1:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c01077e8:	c0 
c01077e9:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c01077f0:	00 
c01077f1:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c01077f8:	e8 fb 8b ff ff       	call   c01003f8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01077fd:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107802:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107809:	00 
c010780a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107811:	00 
c0107812:	89 04 24             	mov    %eax,(%esp)
c0107815:	e8 75 fc ff ff       	call   c010748f <get_page>
c010781a:	85 c0                	test   %eax,%eax
c010781c:	74 24                	je     c0107842 <check_pgdir+0xb6>
c010781e:	c7 44 24 0c 4c ae 10 	movl   $0xc010ae4c,0xc(%esp)
c0107825:	c0 
c0107826:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c010782d:	c0 
c010782e:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0107835:	00 
c0107836:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c010783d:	e8 b6 8b ff ff       	call   c01003f8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0107842:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107849:	e8 2a f4 ff ff       	call   c0106c78 <alloc_pages>
c010784e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0107851:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107856:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010785d:	00 
c010785e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107865:	00 
c0107866:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107869:	89 54 24 04          	mov    %edx,0x4(%esp)
c010786d:	89 04 24             	mov    %eax,(%esp)
c0107870:	e8 18 fd ff ff       	call   c010758d <page_insert>
c0107875:	85 c0                	test   %eax,%eax
c0107877:	74 24                	je     c010789d <check_pgdir+0x111>
c0107879:	c7 44 24 0c 74 ae 10 	movl   $0xc010ae74,0xc(%esp)
c0107880:	c0 
c0107881:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107888:	c0 
c0107889:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0107890:	00 
c0107891:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107898:	e8 5b 8b ff ff       	call   c01003f8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010789d:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01078a2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01078a9:	00 
c01078aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01078b1:	00 
c01078b2:	89 04 24             	mov    %eax,(%esp)
c01078b5:	e8 9d fa ff ff       	call   c0107357 <get_pte>
c01078ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01078bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01078c1:	75 24                	jne    c01078e7 <check_pgdir+0x15b>
c01078c3:	c7 44 24 0c a0 ae 10 	movl   $0xc010aea0,0xc(%esp)
c01078ca:	c0 
c01078cb:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c01078d2:	c0 
c01078d3:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c01078da:	00 
c01078db:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c01078e2:	e8 11 8b ff ff       	call   c01003f8 <__panic>
    assert(pte2page(*ptep) == p1);
c01078e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078ea:	8b 00                	mov    (%eax),%eax
c01078ec:	89 04 24             	mov    %eax,(%esp)
c01078ef:	e8 29 f1 ff ff       	call   c0106a1d <pte2page>
c01078f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01078f7:	74 24                	je     c010791d <check_pgdir+0x191>
c01078f9:	c7 44 24 0c cd ae 10 	movl   $0xc010aecd,0xc(%esp)
c0107900:	c0 
c0107901:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107908:	c0 
c0107909:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0107910:	00 
c0107911:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107918:	e8 db 8a ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p1) == 1);
c010791d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107920:	89 04 24             	mov    %eax,(%esp)
c0107923:	e8 4b f1 ff ff       	call   c0106a73 <page_ref>
c0107928:	83 f8 01             	cmp    $0x1,%eax
c010792b:	74 24                	je     c0107951 <check_pgdir+0x1c5>
c010792d:	c7 44 24 0c e3 ae 10 	movl   $0xc010aee3,0xc(%esp)
c0107934:	c0 
c0107935:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c010793c:	c0 
c010793d:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0107944:	00 
c0107945:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c010794c:	e8 a7 8a ff ff       	call   c01003f8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0107951:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107956:	8b 00                	mov    (%eax),%eax
c0107958:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010795d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107960:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107963:	c1 e8 0c             	shr    $0xc,%eax
c0107966:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107969:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c010796e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0107971:	72 23                	jb     c0107996 <check_pgdir+0x20a>
c0107973:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107976:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010797a:	c7 44 24 08 9c ac 10 	movl   $0xc010ac9c,0x8(%esp)
c0107981:	c0 
c0107982:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0107989:	00 
c010798a:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107991:	e8 62 8a ff ff       	call   c01003f8 <__panic>
c0107996:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107999:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010799e:	83 c0 04             	add    $0x4,%eax
c01079a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01079a4:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01079a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01079b0:	00 
c01079b1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01079b8:	00 
c01079b9:	89 04 24             	mov    %eax,(%esp)
c01079bc:	e8 96 f9 ff ff       	call   c0107357 <get_pte>
c01079c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01079c4:	74 24                	je     c01079ea <check_pgdir+0x25e>
c01079c6:	c7 44 24 0c f8 ae 10 	movl   $0xc010aef8,0xc(%esp)
c01079cd:	c0 
c01079ce:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c01079d5:	c0 
c01079d6:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c01079dd:	00 
c01079de:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c01079e5:	e8 0e 8a ff ff       	call   c01003f8 <__panic>

    p2 = alloc_page();
c01079ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01079f1:	e8 82 f2 ff ff       	call   c0106c78 <alloc_pages>
c01079f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01079f9:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01079fe:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0107a05:	00 
c0107a06:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107a0d:	00 
c0107a0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107a11:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107a15:	89 04 24             	mov    %eax,(%esp)
c0107a18:	e8 70 fb ff ff       	call   c010758d <page_insert>
c0107a1d:	85 c0                	test   %eax,%eax
c0107a1f:	74 24                	je     c0107a45 <check_pgdir+0x2b9>
c0107a21:	c7 44 24 0c 20 af 10 	movl   $0xc010af20,0xc(%esp)
c0107a28:	c0 
c0107a29:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107a30:	c0 
c0107a31:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0107a38:	00 
c0107a39:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107a40:	e8 b3 89 ff ff       	call   c01003f8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107a45:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107a4a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107a51:	00 
c0107a52:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107a59:	00 
c0107a5a:	89 04 24             	mov    %eax,(%esp)
c0107a5d:	e8 f5 f8 ff ff       	call   c0107357 <get_pte>
c0107a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107a65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107a69:	75 24                	jne    c0107a8f <check_pgdir+0x303>
c0107a6b:	c7 44 24 0c 58 af 10 	movl   $0xc010af58,0xc(%esp)
c0107a72:	c0 
c0107a73:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107a7a:	c0 
c0107a7b:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0107a82:	00 
c0107a83:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107a8a:	e8 69 89 ff ff       	call   c01003f8 <__panic>
    assert(*ptep & PTE_U);
c0107a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a92:	8b 00                	mov    (%eax),%eax
c0107a94:	83 e0 04             	and    $0x4,%eax
c0107a97:	85 c0                	test   %eax,%eax
c0107a99:	75 24                	jne    c0107abf <check_pgdir+0x333>
c0107a9b:	c7 44 24 0c 88 af 10 	movl   $0xc010af88,0xc(%esp)
c0107aa2:	c0 
c0107aa3:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107aaa:	c0 
c0107aab:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0107ab2:	00 
c0107ab3:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107aba:	e8 39 89 ff ff       	call   c01003f8 <__panic>
    assert(*ptep & PTE_W);
c0107abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ac2:	8b 00                	mov    (%eax),%eax
c0107ac4:	83 e0 02             	and    $0x2,%eax
c0107ac7:	85 c0                	test   %eax,%eax
c0107ac9:	75 24                	jne    c0107aef <check_pgdir+0x363>
c0107acb:	c7 44 24 0c 96 af 10 	movl   $0xc010af96,0xc(%esp)
c0107ad2:	c0 
c0107ad3:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107ada:	c0 
c0107adb:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0107ae2:	00 
c0107ae3:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107aea:	e8 09 89 ff ff       	call   c01003f8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0107aef:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107af4:	8b 00                	mov    (%eax),%eax
c0107af6:	83 e0 04             	and    $0x4,%eax
c0107af9:	85 c0                	test   %eax,%eax
c0107afb:	75 24                	jne    c0107b21 <check_pgdir+0x395>
c0107afd:	c7 44 24 0c a4 af 10 	movl   $0xc010afa4,0xc(%esp)
c0107b04:	c0 
c0107b05:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107b0c:	c0 
c0107b0d:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0107b14:	00 
c0107b15:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107b1c:	e8 d7 88 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 1);
c0107b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b24:	89 04 24             	mov    %eax,(%esp)
c0107b27:	e8 47 ef ff ff       	call   c0106a73 <page_ref>
c0107b2c:	83 f8 01             	cmp    $0x1,%eax
c0107b2f:	74 24                	je     c0107b55 <check_pgdir+0x3c9>
c0107b31:	c7 44 24 0c ba af 10 	movl   $0xc010afba,0xc(%esp)
c0107b38:	c0 
c0107b39:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107b40:	c0 
c0107b41:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0107b48:	00 
c0107b49:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107b50:	e8 a3 88 ff ff       	call   c01003f8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0107b55:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107b5a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0107b61:	00 
c0107b62:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107b69:	00 
c0107b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b6d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107b71:	89 04 24             	mov    %eax,(%esp)
c0107b74:	e8 14 fa ff ff       	call   c010758d <page_insert>
c0107b79:	85 c0                	test   %eax,%eax
c0107b7b:	74 24                	je     c0107ba1 <check_pgdir+0x415>
c0107b7d:	c7 44 24 0c cc af 10 	movl   $0xc010afcc,0xc(%esp)
c0107b84:	c0 
c0107b85:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107b8c:	c0 
c0107b8d:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0107b94:	00 
c0107b95:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107b9c:	e8 57 88 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p1) == 2);
c0107ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ba4:	89 04 24             	mov    %eax,(%esp)
c0107ba7:	e8 c7 ee ff ff       	call   c0106a73 <page_ref>
c0107bac:	83 f8 02             	cmp    $0x2,%eax
c0107baf:	74 24                	je     c0107bd5 <check_pgdir+0x449>
c0107bb1:	c7 44 24 0c f8 af 10 	movl   $0xc010aff8,0xc(%esp)
c0107bb8:	c0 
c0107bb9:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107bc0:	c0 
c0107bc1:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0107bc8:	00 
c0107bc9:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107bd0:	e8 23 88 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 0);
c0107bd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107bd8:	89 04 24             	mov    %eax,(%esp)
c0107bdb:	e8 93 ee ff ff       	call   c0106a73 <page_ref>
c0107be0:	85 c0                	test   %eax,%eax
c0107be2:	74 24                	je     c0107c08 <check_pgdir+0x47c>
c0107be4:	c7 44 24 0c 0a b0 10 	movl   $0xc010b00a,0xc(%esp)
c0107beb:	c0 
c0107bec:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107bf3:	c0 
c0107bf4:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0107bfb:	00 
c0107bfc:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107c03:	e8 f0 87 ff ff       	call   c01003f8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107c08:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107c0d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107c14:	00 
c0107c15:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107c1c:	00 
c0107c1d:	89 04 24             	mov    %eax,(%esp)
c0107c20:	e8 32 f7 ff ff       	call   c0107357 <get_pte>
c0107c25:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107c28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107c2c:	75 24                	jne    c0107c52 <check_pgdir+0x4c6>
c0107c2e:	c7 44 24 0c 58 af 10 	movl   $0xc010af58,0xc(%esp)
c0107c35:	c0 
c0107c36:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107c3d:	c0 
c0107c3e:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0107c45:	00 
c0107c46:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107c4d:	e8 a6 87 ff ff       	call   c01003f8 <__panic>
    assert(pte2page(*ptep) == p1);
c0107c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c55:	8b 00                	mov    (%eax),%eax
c0107c57:	89 04 24             	mov    %eax,(%esp)
c0107c5a:	e8 be ed ff ff       	call   c0106a1d <pte2page>
c0107c5f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107c62:	74 24                	je     c0107c88 <check_pgdir+0x4fc>
c0107c64:	c7 44 24 0c cd ae 10 	movl   $0xc010aecd,0xc(%esp)
c0107c6b:	c0 
c0107c6c:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107c73:	c0 
c0107c74:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0107c7b:	00 
c0107c7c:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107c83:	e8 70 87 ff ff       	call   c01003f8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0107c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c8b:	8b 00                	mov    (%eax),%eax
c0107c8d:	83 e0 04             	and    $0x4,%eax
c0107c90:	85 c0                	test   %eax,%eax
c0107c92:	74 24                	je     c0107cb8 <check_pgdir+0x52c>
c0107c94:	c7 44 24 0c 1c b0 10 	movl   $0xc010b01c,0xc(%esp)
c0107c9b:	c0 
c0107c9c:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107ca3:	c0 
c0107ca4:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0107cab:	00 
c0107cac:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107cb3:	e8 40 87 ff ff       	call   c01003f8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0107cb8:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107cbd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107cc4:	00 
c0107cc5:	89 04 24             	mov    %eax,(%esp)
c0107cc8:	e8 7c f8 ff ff       	call   c0107549 <page_remove>
    assert(page_ref(p1) == 1);
c0107ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cd0:	89 04 24             	mov    %eax,(%esp)
c0107cd3:	e8 9b ed ff ff       	call   c0106a73 <page_ref>
c0107cd8:	83 f8 01             	cmp    $0x1,%eax
c0107cdb:	74 24                	je     c0107d01 <check_pgdir+0x575>
c0107cdd:	c7 44 24 0c e3 ae 10 	movl   $0xc010aee3,0xc(%esp)
c0107ce4:	c0 
c0107ce5:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107cec:	c0 
c0107ced:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0107cf4:	00 
c0107cf5:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107cfc:	e8 f7 86 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 0);
c0107d01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d04:	89 04 24             	mov    %eax,(%esp)
c0107d07:	e8 67 ed ff ff       	call   c0106a73 <page_ref>
c0107d0c:	85 c0                	test   %eax,%eax
c0107d0e:	74 24                	je     c0107d34 <check_pgdir+0x5a8>
c0107d10:	c7 44 24 0c 0a b0 10 	movl   $0xc010b00a,0xc(%esp)
c0107d17:	c0 
c0107d18:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107d1f:	c0 
c0107d20:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0107d27:	00 
c0107d28:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107d2f:	e8 c4 86 ff ff       	call   c01003f8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0107d34:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107d39:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107d40:	00 
c0107d41:	89 04 24             	mov    %eax,(%esp)
c0107d44:	e8 00 f8 ff ff       	call   c0107549 <page_remove>
    assert(page_ref(p1) == 0);
c0107d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d4c:	89 04 24             	mov    %eax,(%esp)
c0107d4f:	e8 1f ed ff ff       	call   c0106a73 <page_ref>
c0107d54:	85 c0                	test   %eax,%eax
c0107d56:	74 24                	je     c0107d7c <check_pgdir+0x5f0>
c0107d58:	c7 44 24 0c 31 b0 10 	movl   $0xc010b031,0xc(%esp)
c0107d5f:	c0 
c0107d60:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107d67:	c0 
c0107d68:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0107d6f:	00 
c0107d70:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107d77:	e8 7c 86 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 0);
c0107d7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d7f:	89 04 24             	mov    %eax,(%esp)
c0107d82:	e8 ec ec ff ff       	call   c0106a73 <page_ref>
c0107d87:	85 c0                	test   %eax,%eax
c0107d89:	74 24                	je     c0107daf <check_pgdir+0x623>
c0107d8b:	c7 44 24 0c 0a b0 10 	movl   $0xc010b00a,0xc(%esp)
c0107d92:	c0 
c0107d93:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107d9a:	c0 
c0107d9b:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0107da2:	00 
c0107da3:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107daa:	e8 49 86 ff ff       	call   c01003f8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0107daf:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107db4:	8b 00                	mov    (%eax),%eax
c0107db6:	89 04 24             	mov    %eax,(%esp)
c0107db9:	e8 9d ec ff ff       	call   c0106a5b <pde2page>
c0107dbe:	89 04 24             	mov    %eax,(%esp)
c0107dc1:	e8 ad ec ff ff       	call   c0106a73 <page_ref>
c0107dc6:	83 f8 01             	cmp    $0x1,%eax
c0107dc9:	74 24                	je     c0107def <check_pgdir+0x663>
c0107dcb:	c7 44 24 0c 44 b0 10 	movl   $0xc010b044,0xc(%esp)
c0107dd2:	c0 
c0107dd3:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107dda:	c0 
c0107ddb:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0107de2:	00 
c0107de3:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107dea:	e8 09 86 ff ff       	call   c01003f8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0107def:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107df4:	8b 00                	mov    (%eax),%eax
c0107df6:	89 04 24             	mov    %eax,(%esp)
c0107df9:	e8 5d ec ff ff       	call   c0106a5b <pde2page>
c0107dfe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107e05:	00 
c0107e06:	89 04 24             	mov    %eax,(%esp)
c0107e09:	e8 d5 ee ff ff       	call   c0106ce3 <free_pages>
    boot_pgdir[0] = 0;
c0107e0e:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107e13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0107e19:	c7 04 24 6b b0 10 c0 	movl   $0xc010b06b,(%esp)
c0107e20:	e8 7c 84 ff ff       	call   c01002a1 <cprintf>
}
c0107e25:	c9                   	leave  
c0107e26:	c3                   	ret    

c0107e27 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0107e27:	55                   	push   %ebp
c0107e28:	89 e5                	mov    %esp,%ebp
c0107e2a:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0107e2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107e34:	e9 ca 00 00 00       	jmp    c0107f03 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0107e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e42:	c1 e8 0c             	shr    $0xc,%eax
c0107e45:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107e48:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107e4d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0107e50:	72 23                	jb     c0107e75 <check_boot_pgdir+0x4e>
c0107e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e55:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107e59:	c7 44 24 08 9c ac 10 	movl   $0xc010ac9c,0x8(%esp)
c0107e60:	c0 
c0107e61:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0107e68:	00 
c0107e69:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107e70:	e8 83 85 ff ff       	call   c01003f8 <__panic>
c0107e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e78:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107e7d:	89 c2                	mov    %eax,%edx
c0107e7f:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107e84:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107e8b:	00 
c0107e8c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107e90:	89 04 24             	mov    %eax,(%esp)
c0107e93:	e8 bf f4 ff ff       	call   c0107357 <get_pte>
c0107e98:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107e9b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107e9f:	75 24                	jne    c0107ec5 <check_boot_pgdir+0x9e>
c0107ea1:	c7 44 24 0c 88 b0 10 	movl   $0xc010b088,0xc(%esp)
c0107ea8:	c0 
c0107ea9:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107eb0:	c0 
c0107eb1:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0107eb8:	00 
c0107eb9:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107ec0:	e8 33 85 ff ff       	call   c01003f8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0107ec5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ec8:	8b 00                	mov    (%eax),%eax
c0107eca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107ecf:	89 c2                	mov    %eax,%edx
c0107ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ed4:	39 c2                	cmp    %eax,%edx
c0107ed6:	74 24                	je     c0107efc <check_boot_pgdir+0xd5>
c0107ed8:	c7 44 24 0c c5 b0 10 	movl   $0xc010b0c5,0xc(%esp)
c0107edf:	c0 
c0107ee0:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107ee7:	c0 
c0107ee8:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0107eef:	00 
c0107ef0:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107ef7:	e8 fc 84 ff ff       	call   c01003f8 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0107efc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0107f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107f06:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107f0b:	39 c2                	cmp    %eax,%edx
c0107f0d:	0f 82 26 ff ff ff    	jb     c0107e39 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0107f13:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107f18:	05 ac 0f 00 00       	add    $0xfac,%eax
c0107f1d:	8b 00                	mov    (%eax),%eax
c0107f1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107f24:	89 c2                	mov    %eax,%edx
c0107f26:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107f2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107f2e:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0107f35:	77 23                	ja     c0107f5a <check_boot_pgdir+0x133>
c0107f37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107f3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107f3e:	c7 44 24 08 c0 ac 10 	movl   $0xc010acc0,0x8(%esp)
c0107f45:	c0 
c0107f46:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0107f4d:	00 
c0107f4e:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107f55:	e8 9e 84 ff ff       	call   c01003f8 <__panic>
c0107f5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107f5d:	05 00 00 00 40       	add    $0x40000000,%eax
c0107f62:	39 c2                	cmp    %eax,%edx
c0107f64:	74 24                	je     c0107f8a <check_boot_pgdir+0x163>
c0107f66:	c7 44 24 0c dc b0 10 	movl   $0xc010b0dc,0xc(%esp)
c0107f6d:	c0 
c0107f6e:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107f75:	c0 
c0107f76:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0107f7d:	00 
c0107f7e:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107f85:	e8 6e 84 ff ff       	call   c01003f8 <__panic>

    assert(boot_pgdir[0] == 0);
c0107f8a:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107f8f:	8b 00                	mov    (%eax),%eax
c0107f91:	85 c0                	test   %eax,%eax
c0107f93:	74 24                	je     c0107fb9 <check_boot_pgdir+0x192>
c0107f95:	c7 44 24 0c 10 b1 10 	movl   $0xc010b110,0xc(%esp)
c0107f9c:	c0 
c0107f9d:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107fa4:	c0 
c0107fa5:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0107fac:	00 
c0107fad:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0107fb4:	e8 3f 84 ff ff       	call   c01003f8 <__panic>

    struct Page *p;
    p = alloc_page();
c0107fb9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107fc0:	e8 b3 ec ff ff       	call   c0106c78 <alloc_pages>
c0107fc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0107fc8:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107fcd:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0107fd4:	00 
c0107fd5:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0107fdc:	00 
c0107fdd:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107fe0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107fe4:	89 04 24             	mov    %eax,(%esp)
c0107fe7:	e8 a1 f5 ff ff       	call   c010758d <page_insert>
c0107fec:	85 c0                	test   %eax,%eax
c0107fee:	74 24                	je     c0108014 <check_boot_pgdir+0x1ed>
c0107ff0:	c7 44 24 0c 24 b1 10 	movl   $0xc010b124,0xc(%esp)
c0107ff7:	c0 
c0107ff8:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0107fff:	c0 
c0108000:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c0108007:	00 
c0108008:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c010800f:	e8 e4 83 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p) == 1);
c0108014:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108017:	89 04 24             	mov    %eax,(%esp)
c010801a:	e8 54 ea ff ff       	call   c0106a73 <page_ref>
c010801f:	83 f8 01             	cmp    $0x1,%eax
c0108022:	74 24                	je     c0108048 <check_boot_pgdir+0x221>
c0108024:	c7 44 24 0c 52 b1 10 	movl   $0xc010b152,0xc(%esp)
c010802b:	c0 
c010802c:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0108033:	c0 
c0108034:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c010803b:	00 
c010803c:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0108043:	e8 b0 83 ff ff       	call   c01003f8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0108048:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010804d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0108054:	00 
c0108055:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010805c:	00 
c010805d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108060:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108064:	89 04 24             	mov    %eax,(%esp)
c0108067:	e8 21 f5 ff ff       	call   c010758d <page_insert>
c010806c:	85 c0                	test   %eax,%eax
c010806e:	74 24                	je     c0108094 <check_boot_pgdir+0x26d>
c0108070:	c7 44 24 0c 64 b1 10 	movl   $0xc010b164,0xc(%esp)
c0108077:	c0 
c0108078:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c010807f:	c0 
c0108080:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0108087:	00 
c0108088:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c010808f:	e8 64 83 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p) == 2);
c0108094:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108097:	89 04 24             	mov    %eax,(%esp)
c010809a:	e8 d4 e9 ff ff       	call   c0106a73 <page_ref>
c010809f:	83 f8 02             	cmp    $0x2,%eax
c01080a2:	74 24                	je     c01080c8 <check_boot_pgdir+0x2a1>
c01080a4:	c7 44 24 0c 9b b1 10 	movl   $0xc010b19b,0xc(%esp)
c01080ab:	c0 
c01080ac:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c01080b3:	c0 
c01080b4:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
c01080bb:	00 
c01080bc:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c01080c3:	e8 30 83 ff ff       	call   c01003f8 <__panic>

    const char *str = "ucore: Hello world!!";
c01080c8:	c7 45 dc ac b1 10 c0 	movl   $0xc010b1ac,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01080cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01080d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080d6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01080dd:	e8 7c 06 00 00       	call   c010875e <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01080e2:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01080e9:	00 
c01080ea:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01080f1:	e8 e1 06 00 00       	call   c01087d7 <strcmp>
c01080f6:	85 c0                	test   %eax,%eax
c01080f8:	74 24                	je     c010811e <check_boot_pgdir+0x2f7>
c01080fa:	c7 44 24 0c c4 b1 10 	movl   $0xc010b1c4,0xc(%esp)
c0108101:	c0 
c0108102:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0108109:	c0 
c010810a:	c7 44 24 04 4c 02 00 	movl   $0x24c,0x4(%esp)
c0108111:	00 
c0108112:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0108119:	e8 da 82 ff ff       	call   c01003f8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010811e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108121:	89 04 24             	mov    %eax,(%esp)
c0108124:	e8 56 e8 ff ff       	call   c010697f <page2kva>
c0108129:	05 00 01 00 00       	add    $0x100,%eax
c010812e:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0108131:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0108138:	e8 c9 05 00 00       	call   c0108706 <strlen>
c010813d:	85 c0                	test   %eax,%eax
c010813f:	74 24                	je     c0108165 <check_boot_pgdir+0x33e>
c0108141:	c7 44 24 0c fc b1 10 	movl   $0xc010b1fc,0xc(%esp)
c0108148:	c0 
c0108149:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0108150:	c0 
c0108151:	c7 44 24 04 4f 02 00 	movl   $0x24f,0x4(%esp)
c0108158:	00 
c0108159:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0108160:	e8 93 82 ff ff       	call   c01003f8 <__panic>

    free_page(p);
c0108165:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010816c:	00 
c010816d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108170:	89 04 24             	mov    %eax,(%esp)
c0108173:	e8 6b eb ff ff       	call   c0106ce3 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0108178:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010817d:	8b 00                	mov    (%eax),%eax
c010817f:	89 04 24             	mov    %eax,(%esp)
c0108182:	e8 d4 e8 ff ff       	call   c0106a5b <pde2page>
c0108187:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010818e:	00 
c010818f:	89 04 24             	mov    %eax,(%esp)
c0108192:	e8 4c eb ff ff       	call   c0106ce3 <free_pages>
    boot_pgdir[0] = 0;
c0108197:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010819c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01081a2:	c7 04 24 20 b2 10 c0 	movl   $0xc010b220,(%esp)
c01081a9:	e8 f3 80 ff ff       	call   c01002a1 <cprintf>
}
c01081ae:	c9                   	leave  
c01081af:	c3                   	ret    

c01081b0 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01081b0:	55                   	push   %ebp
c01081b1:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01081b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01081b6:	83 e0 04             	and    $0x4,%eax
c01081b9:	85 c0                	test   %eax,%eax
c01081bb:	74 07                	je     c01081c4 <perm2str+0x14>
c01081bd:	b8 75 00 00 00       	mov    $0x75,%eax
c01081c2:	eb 05                	jmp    c01081c9 <perm2str+0x19>
c01081c4:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01081c9:	a2 08 50 12 c0       	mov    %al,0xc0125008
    str[1] = 'r';
c01081ce:	c6 05 09 50 12 c0 72 	movb   $0x72,0xc0125009
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01081d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01081d8:	83 e0 02             	and    $0x2,%eax
c01081db:	85 c0                	test   %eax,%eax
c01081dd:	74 07                	je     c01081e6 <perm2str+0x36>
c01081df:	b8 77 00 00 00       	mov    $0x77,%eax
c01081e4:	eb 05                	jmp    c01081eb <perm2str+0x3b>
c01081e6:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01081eb:	a2 0a 50 12 c0       	mov    %al,0xc012500a
    str[3] = '\0';
c01081f0:	c6 05 0b 50 12 c0 00 	movb   $0x0,0xc012500b
    return str;
c01081f7:	b8 08 50 12 c0       	mov    $0xc0125008,%eax
}
c01081fc:	5d                   	pop    %ebp
c01081fd:	c3                   	ret    

c01081fe <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01081fe:	55                   	push   %ebp
c01081ff:	89 e5                	mov    %esp,%ebp
c0108201:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0108204:	8b 45 10             	mov    0x10(%ebp),%eax
c0108207:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010820a:	72 0a                	jb     c0108216 <get_pgtable_items+0x18>
        return 0;
c010820c:	b8 00 00 00 00       	mov    $0x0,%eax
c0108211:	e9 9c 00 00 00       	jmp    c01082b2 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0108216:	eb 04                	jmp    c010821c <get_pgtable_items+0x1e>
        start ++;
c0108218:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c010821c:	8b 45 10             	mov    0x10(%ebp),%eax
c010821f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108222:	73 18                	jae    c010823c <get_pgtable_items+0x3e>
c0108224:	8b 45 10             	mov    0x10(%ebp),%eax
c0108227:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010822e:	8b 45 14             	mov    0x14(%ebp),%eax
c0108231:	01 d0                	add    %edx,%eax
c0108233:	8b 00                	mov    (%eax),%eax
c0108235:	83 e0 01             	and    $0x1,%eax
c0108238:	85 c0                	test   %eax,%eax
c010823a:	74 dc                	je     c0108218 <get_pgtable_items+0x1a>
    }
    if (start < right) {
c010823c:	8b 45 10             	mov    0x10(%ebp),%eax
c010823f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108242:	73 69                	jae    c01082ad <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0108244:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0108248:	74 08                	je     c0108252 <get_pgtable_items+0x54>
            *left_store = start;
c010824a:	8b 45 18             	mov    0x18(%ebp),%eax
c010824d:	8b 55 10             	mov    0x10(%ebp),%edx
c0108250:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0108252:	8b 45 10             	mov    0x10(%ebp),%eax
c0108255:	8d 50 01             	lea    0x1(%eax),%edx
c0108258:	89 55 10             	mov    %edx,0x10(%ebp)
c010825b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0108262:	8b 45 14             	mov    0x14(%ebp),%eax
c0108265:	01 d0                	add    %edx,%eax
c0108267:	8b 00                	mov    (%eax),%eax
c0108269:	83 e0 07             	and    $0x7,%eax
c010826c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010826f:	eb 04                	jmp    c0108275 <get_pgtable_items+0x77>
            start ++;
c0108271:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0108275:	8b 45 10             	mov    0x10(%ebp),%eax
c0108278:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010827b:	73 1d                	jae    c010829a <get_pgtable_items+0x9c>
c010827d:	8b 45 10             	mov    0x10(%ebp),%eax
c0108280:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0108287:	8b 45 14             	mov    0x14(%ebp),%eax
c010828a:	01 d0                	add    %edx,%eax
c010828c:	8b 00                	mov    (%eax),%eax
c010828e:	83 e0 07             	and    $0x7,%eax
c0108291:	89 c2                	mov    %eax,%edx
c0108293:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108296:	39 c2                	cmp    %eax,%edx
c0108298:	74 d7                	je     c0108271 <get_pgtable_items+0x73>
        }
        if (right_store != NULL) {
c010829a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010829e:	74 08                	je     c01082a8 <get_pgtable_items+0xaa>
            *right_store = start;
c01082a0:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01082a3:	8b 55 10             	mov    0x10(%ebp),%edx
c01082a6:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01082a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01082ab:	eb 05                	jmp    c01082b2 <get_pgtable_items+0xb4>
    }
    return 0;
c01082ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01082b2:	c9                   	leave  
c01082b3:	c3                   	ret    

c01082b4 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01082b4:	55                   	push   %ebp
c01082b5:	89 e5                	mov    %esp,%ebp
c01082b7:	57                   	push   %edi
c01082b8:	56                   	push   %esi
c01082b9:	53                   	push   %ebx
c01082ba:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01082bd:	c7 04 24 40 b2 10 c0 	movl   $0xc010b240,(%esp)
c01082c4:	e8 d8 7f ff ff       	call   c01002a1 <cprintf>
    size_t left, right = 0, perm;
c01082c9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01082d0:	e9 fa 00 00 00       	jmp    c01083cf <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01082d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082d8:	89 04 24             	mov    %eax,(%esp)
c01082db:	e8 d0 fe ff ff       	call   c01081b0 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01082e0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01082e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01082e6:	29 d1                	sub    %edx,%ecx
c01082e8:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01082ea:	89 d6                	mov    %edx,%esi
c01082ec:	c1 e6 16             	shl    $0x16,%esi
c01082ef:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01082f2:	89 d3                	mov    %edx,%ebx
c01082f4:	c1 e3 16             	shl    $0x16,%ebx
c01082f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01082fa:	89 d1                	mov    %edx,%ecx
c01082fc:	c1 e1 16             	shl    $0x16,%ecx
c01082ff:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0108302:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108305:	29 d7                	sub    %edx,%edi
c0108307:	89 fa                	mov    %edi,%edx
c0108309:	89 44 24 14          	mov    %eax,0x14(%esp)
c010830d:	89 74 24 10          	mov    %esi,0x10(%esp)
c0108311:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0108315:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108319:	89 54 24 04          	mov    %edx,0x4(%esp)
c010831d:	c7 04 24 71 b2 10 c0 	movl   $0xc010b271,(%esp)
c0108324:	e8 78 7f ff ff       	call   c01002a1 <cprintf>
        size_t l, r = left * NPTEENTRY;
c0108329:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010832c:	c1 e0 0a             	shl    $0xa,%eax
c010832f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0108332:	eb 54                	jmp    c0108388 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0108334:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108337:	89 04 24             	mov    %eax,(%esp)
c010833a:	e8 71 fe ff ff       	call   c01081b0 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010833f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0108342:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108345:	29 d1                	sub    %edx,%ecx
c0108347:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0108349:	89 d6                	mov    %edx,%esi
c010834b:	c1 e6 0c             	shl    $0xc,%esi
c010834e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108351:	89 d3                	mov    %edx,%ebx
c0108353:	c1 e3 0c             	shl    $0xc,%ebx
c0108356:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108359:	c1 e2 0c             	shl    $0xc,%edx
c010835c:	89 d1                	mov    %edx,%ecx
c010835e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0108361:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108364:	29 d7                	sub    %edx,%edi
c0108366:	89 fa                	mov    %edi,%edx
c0108368:	89 44 24 14          	mov    %eax,0x14(%esp)
c010836c:	89 74 24 10          	mov    %esi,0x10(%esp)
c0108370:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0108374:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108378:	89 54 24 04          	mov    %edx,0x4(%esp)
c010837c:	c7 04 24 90 b2 10 c0 	movl   $0xc010b290,(%esp)
c0108383:	e8 19 7f ff ff       	call   c01002a1 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0108388:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010838d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108390:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108393:	89 ce                	mov    %ecx,%esi
c0108395:	c1 e6 0a             	shl    $0xa,%esi
c0108398:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010839b:	89 cb                	mov    %ecx,%ebx
c010839d:	c1 e3 0a             	shl    $0xa,%ebx
c01083a0:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01083a3:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01083a7:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01083aa:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01083ae:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01083b2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01083b6:	89 74 24 04          	mov    %esi,0x4(%esp)
c01083ba:	89 1c 24             	mov    %ebx,(%esp)
c01083bd:	e8 3c fe ff ff       	call   c01081fe <get_pgtable_items>
c01083c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01083c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01083c9:	0f 85 65 ff ff ff    	jne    c0108334 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01083cf:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01083d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01083d7:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01083da:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01083de:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01083e1:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01083e5:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01083e9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01083ed:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01083f4:	00 
c01083f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01083fc:	e8 fd fd ff ff       	call   c01081fe <get_pgtable_items>
c0108401:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108404:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108408:	0f 85 c7 fe ff ff    	jne    c01082d5 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010840e:	c7 04 24 b4 b2 10 c0 	movl   $0xc010b2b4,(%esp)
c0108415:	e8 87 7e ff ff       	call   c01002a1 <cprintf>
}
c010841a:	83 c4 4c             	add    $0x4c,%esp
c010841d:	5b                   	pop    %ebx
c010841e:	5e                   	pop    %esi
c010841f:	5f                   	pop    %edi
c0108420:	5d                   	pop    %ebp
c0108421:	c3                   	ret    

c0108422 <kmalloc>:

void *
kmalloc(size_t n) {
c0108422:	55                   	push   %ebp
c0108423:	89 e5                	mov    %esp,%ebp
c0108425:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c0108428:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c010842f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0108436:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010843a:	74 09                	je     c0108445 <kmalloc+0x23>
c010843c:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0108443:	76 24                	jbe    c0108469 <kmalloc+0x47>
c0108445:	c7 44 24 0c e5 b2 10 	movl   $0xc010b2e5,0xc(%esp)
c010844c:	c0 
c010844d:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0108454:	c0 
c0108455:	c7 44 24 04 9b 02 00 	movl   $0x29b,0x4(%esp)
c010845c:	00 
c010845d:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0108464:	e8 8f 7f ff ff       	call   c01003f8 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0108469:	8b 45 08             	mov    0x8(%ebp),%eax
c010846c:	05 ff 0f 00 00       	add    $0xfff,%eax
c0108471:	c1 e8 0c             	shr    $0xc,%eax
c0108474:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0108477:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010847a:	89 04 24             	mov    %eax,(%esp)
c010847d:	e8 f6 e7 ff ff       	call   c0106c78 <alloc_pages>
c0108482:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0108485:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108489:	75 24                	jne    c01084af <kmalloc+0x8d>
c010848b:	c7 44 24 0c fc b2 10 	movl   $0xc010b2fc,0xc(%esp)
c0108492:	c0 
c0108493:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c010849a:	c0 
c010849b:	c7 44 24 04 9e 02 00 	movl   $0x29e,0x4(%esp)
c01084a2:	00 
c01084a3:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c01084aa:	e8 49 7f ff ff       	call   c01003f8 <__panic>
    ptr=page2kva(base);
c01084af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01084b2:	89 04 24             	mov    %eax,(%esp)
c01084b5:	e8 c5 e4 ff ff       	call   c010697f <page2kva>
c01084ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c01084bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01084c0:	c9                   	leave  
c01084c1:	c3                   	ret    

c01084c2 <kfree>:

void 
kfree(void *ptr, size_t n) {
c01084c2:	55                   	push   %ebp
c01084c3:	89 e5                	mov    %esp,%ebp
c01084c5:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c01084c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01084cc:	74 09                	je     c01084d7 <kfree+0x15>
c01084ce:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c01084d5:	76 24                	jbe    c01084fb <kfree+0x39>
c01084d7:	c7 44 24 0c e5 b2 10 	movl   $0xc010b2e5,0xc(%esp)
c01084de:	c0 
c01084df:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c01084e6:	c0 
c01084e7:	c7 44 24 04 a5 02 00 	movl   $0x2a5,0x4(%esp)
c01084ee:	00 
c01084ef:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c01084f6:	e8 fd 7e ff ff       	call   c01003f8 <__panic>
    assert(ptr != NULL);
c01084fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01084ff:	75 24                	jne    c0108525 <kfree+0x63>
c0108501:	c7 44 24 0c 09 b3 10 	movl   $0xc010b309,0xc(%esp)
c0108508:	c0 
c0108509:	c7 44 24 08 89 ad 10 	movl   $0xc010ad89,0x8(%esp)
c0108510:	c0 
c0108511:	c7 44 24 04 a6 02 00 	movl   $0x2a6,0x4(%esp)
c0108518:	00 
c0108519:	c7 04 24 64 ad 10 c0 	movl   $0xc010ad64,(%esp)
c0108520:	e8 d3 7e ff ff       	call   c01003f8 <__panic>
    struct Page *base=NULL;
c0108525:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c010852c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010852f:	05 ff 0f 00 00       	add    $0xfff,%eax
c0108534:	c1 e8 0c             	shr    $0xc,%eax
c0108537:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c010853a:	8b 45 08             	mov    0x8(%ebp),%eax
c010853d:	89 04 24             	mov    %eax,(%esp)
c0108540:	e8 8e e4 ff ff       	call   c01069d3 <kva2page>
c0108545:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0108548:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010854b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010854f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108552:	89 04 24             	mov    %eax,(%esp)
c0108555:	e8 89 e7 ff ff       	call   c0106ce3 <free_pages>
}
c010855a:	c9                   	leave  
c010855b:	c3                   	ret    

c010855c <page2ppn>:
page2ppn(struct Page *page) {
c010855c:	55                   	push   %ebp
c010855d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010855f:	8b 55 08             	mov    0x8(%ebp),%edx
c0108562:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0108567:	29 c2                	sub    %eax,%edx
c0108569:	89 d0                	mov    %edx,%eax
c010856b:	c1 f8 05             	sar    $0x5,%eax
}
c010856e:	5d                   	pop    %ebp
c010856f:	c3                   	ret    

c0108570 <page2pa>:
page2pa(struct Page *page) {
c0108570:	55                   	push   %ebp
c0108571:	89 e5                	mov    %esp,%ebp
c0108573:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108576:	8b 45 08             	mov    0x8(%ebp),%eax
c0108579:	89 04 24             	mov    %eax,(%esp)
c010857c:	e8 db ff ff ff       	call   c010855c <page2ppn>
c0108581:	c1 e0 0c             	shl    $0xc,%eax
}
c0108584:	c9                   	leave  
c0108585:	c3                   	ret    

c0108586 <page2kva>:
page2kva(struct Page *page) {
c0108586:	55                   	push   %ebp
c0108587:	89 e5                	mov    %esp,%ebp
c0108589:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010858c:	8b 45 08             	mov    0x8(%ebp),%eax
c010858f:	89 04 24             	mov    %eax,(%esp)
c0108592:	e8 d9 ff ff ff       	call   c0108570 <page2pa>
c0108597:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010859a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010859d:	c1 e8 0c             	shr    $0xc,%eax
c01085a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01085a3:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01085a8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01085ab:	72 23                	jb     c01085d0 <page2kva+0x4a>
c01085ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01085b4:	c7 44 24 08 18 b3 10 	movl   $0xc010b318,0x8(%esp)
c01085bb:	c0 
c01085bc:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01085c3:	00 
c01085c4:	c7 04 24 3b b3 10 c0 	movl   $0xc010b33b,(%esp)
c01085cb:	e8 28 7e ff ff       	call   c01003f8 <__panic>
c01085d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085d3:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01085d8:	c9                   	leave  
c01085d9:	c3                   	ret    

c01085da <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c01085da:	55                   	push   %ebp
c01085db:	89 e5                	mov    %esp,%ebp
c01085dd:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c01085e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01085e7:	e8 35 8b ff ff       	call   c0101121 <ide_device_valid>
c01085ec:	85 c0                	test   %eax,%eax
c01085ee:	75 1c                	jne    c010860c <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c01085f0:	c7 44 24 08 49 b3 10 	movl   $0xc010b349,0x8(%esp)
c01085f7:	c0 
c01085f8:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c01085ff:	00 
c0108600:	c7 04 24 63 b3 10 c0 	movl   $0xc010b363,(%esp)
c0108607:	e8 ec 7d ff ff       	call   c01003f8 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c010860c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108613:	e8 48 8b ff ff       	call   c0101160 <ide_device_size>
c0108618:	c1 e8 03             	shr    $0x3,%eax
c010861b:	a3 bc 50 12 c0       	mov    %eax,0xc01250bc
}
c0108620:	c9                   	leave  
c0108621:	c3                   	ret    

c0108622 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0108622:	55                   	push   %ebp
c0108623:	89 e5                	mov    %esp,%ebp
c0108625:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108628:	8b 45 0c             	mov    0xc(%ebp),%eax
c010862b:	89 04 24             	mov    %eax,(%esp)
c010862e:	e8 53 ff ff ff       	call   c0108586 <page2kva>
c0108633:	8b 55 08             	mov    0x8(%ebp),%edx
c0108636:	c1 ea 08             	shr    $0x8,%edx
c0108639:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010863c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108640:	74 0b                	je     c010864d <swapfs_read+0x2b>
c0108642:	8b 15 bc 50 12 c0    	mov    0xc01250bc,%edx
c0108648:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c010864b:	72 23                	jb     c0108670 <swapfs_read+0x4e>
c010864d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108650:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108654:	c7 44 24 08 74 b3 10 	movl   $0xc010b374,0x8(%esp)
c010865b:	c0 
c010865c:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0108663:	00 
c0108664:	c7 04 24 63 b3 10 c0 	movl   $0xc010b363,(%esp)
c010866b:	e8 88 7d ff ff       	call   c01003f8 <__panic>
c0108670:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108673:	c1 e2 03             	shl    $0x3,%edx
c0108676:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c010867d:	00 
c010867e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108682:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108686:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010868d:	e8 0d 8b ff ff       	call   c010119f <ide_read_secs>
}
c0108692:	c9                   	leave  
c0108693:	c3                   	ret    

c0108694 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0108694:	55                   	push   %ebp
c0108695:	89 e5                	mov    %esp,%ebp
c0108697:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c010869a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010869d:	89 04 24             	mov    %eax,(%esp)
c01086a0:	e8 e1 fe ff ff       	call   c0108586 <page2kva>
c01086a5:	8b 55 08             	mov    0x8(%ebp),%edx
c01086a8:	c1 ea 08             	shr    $0x8,%edx
c01086ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01086ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01086b2:	74 0b                	je     c01086bf <swapfs_write+0x2b>
c01086b4:	8b 15 bc 50 12 c0    	mov    0xc01250bc,%edx
c01086ba:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01086bd:	72 23                	jb     c01086e2 <swapfs_write+0x4e>
c01086bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01086c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01086c6:	c7 44 24 08 74 b3 10 	movl   $0xc010b374,0x8(%esp)
c01086cd:	c0 
c01086ce:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c01086d5:	00 
c01086d6:	c7 04 24 63 b3 10 c0 	movl   $0xc010b363,(%esp)
c01086dd:	e8 16 7d ff ff       	call   c01003f8 <__panic>
c01086e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01086e5:	c1 e2 03             	shl    $0x3,%edx
c01086e8:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01086ef:	00 
c01086f0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01086f4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01086f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01086ff:	e8 dd 8c ff ff       	call   c01013e1 <ide_write_secs>
}
c0108704:	c9                   	leave  
c0108705:	c3                   	ret    

c0108706 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0108706:	55                   	push   %ebp
c0108707:	89 e5                	mov    %esp,%ebp
c0108709:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010870c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0108713:	eb 04                	jmp    c0108719 <strlen+0x13>
        cnt ++;
c0108715:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c0108719:	8b 45 08             	mov    0x8(%ebp),%eax
c010871c:	8d 50 01             	lea    0x1(%eax),%edx
c010871f:	89 55 08             	mov    %edx,0x8(%ebp)
c0108722:	0f b6 00             	movzbl (%eax),%eax
c0108725:	84 c0                	test   %al,%al
c0108727:	75 ec                	jne    c0108715 <strlen+0xf>
    }
    return cnt;
c0108729:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010872c:	c9                   	leave  
c010872d:	c3                   	ret    

c010872e <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010872e:	55                   	push   %ebp
c010872f:	89 e5                	mov    %esp,%ebp
c0108731:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0108734:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010873b:	eb 04                	jmp    c0108741 <strnlen+0x13>
        cnt ++;
c010873d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0108741:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108744:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108747:	73 10                	jae    c0108759 <strnlen+0x2b>
c0108749:	8b 45 08             	mov    0x8(%ebp),%eax
c010874c:	8d 50 01             	lea    0x1(%eax),%edx
c010874f:	89 55 08             	mov    %edx,0x8(%ebp)
c0108752:	0f b6 00             	movzbl (%eax),%eax
c0108755:	84 c0                	test   %al,%al
c0108757:	75 e4                	jne    c010873d <strnlen+0xf>
    }
    return cnt;
c0108759:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010875c:	c9                   	leave  
c010875d:	c3                   	ret    

c010875e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010875e:	55                   	push   %ebp
c010875f:	89 e5                	mov    %esp,%ebp
c0108761:	57                   	push   %edi
c0108762:	56                   	push   %esi
c0108763:	83 ec 20             	sub    $0x20,%esp
c0108766:	8b 45 08             	mov    0x8(%ebp),%eax
c0108769:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010876c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010876f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0108772:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108775:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108778:	89 d1                	mov    %edx,%ecx
c010877a:	89 c2                	mov    %eax,%edx
c010877c:	89 ce                	mov    %ecx,%esi
c010877e:	89 d7                	mov    %edx,%edi
c0108780:	ac                   	lods   %ds:(%esi),%al
c0108781:	aa                   	stos   %al,%es:(%edi)
c0108782:	84 c0                	test   %al,%al
c0108784:	75 fa                	jne    c0108780 <strcpy+0x22>
c0108786:	89 fa                	mov    %edi,%edx
c0108788:	89 f1                	mov    %esi,%ecx
c010878a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010878d:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108790:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0108793:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0108796:	83 c4 20             	add    $0x20,%esp
c0108799:	5e                   	pop    %esi
c010879a:	5f                   	pop    %edi
c010879b:	5d                   	pop    %ebp
c010879c:	c3                   	ret    

c010879d <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010879d:	55                   	push   %ebp
c010879e:	89 e5                	mov    %esp,%ebp
c01087a0:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01087a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01087a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01087a9:	eb 21                	jmp    c01087cc <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01087ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087ae:	0f b6 10             	movzbl (%eax),%edx
c01087b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01087b4:	88 10                	mov    %dl,(%eax)
c01087b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01087b9:	0f b6 00             	movzbl (%eax),%eax
c01087bc:	84 c0                	test   %al,%al
c01087be:	74 04                	je     c01087c4 <strncpy+0x27>
            src ++;
c01087c0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01087c4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01087c8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c01087cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01087d0:	75 d9                	jne    c01087ab <strncpy+0xe>
    }
    return dst;
c01087d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01087d5:	c9                   	leave  
c01087d6:	c3                   	ret    

c01087d7 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01087d7:	55                   	push   %ebp
c01087d8:	89 e5                	mov    %esp,%ebp
c01087da:	57                   	push   %edi
c01087db:	56                   	push   %esi
c01087dc:	83 ec 20             	sub    $0x20,%esp
c01087df:	8b 45 08             	mov    0x8(%ebp),%eax
c01087e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01087e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01087eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01087ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01087f1:	89 d1                	mov    %edx,%ecx
c01087f3:	89 c2                	mov    %eax,%edx
c01087f5:	89 ce                	mov    %ecx,%esi
c01087f7:	89 d7                	mov    %edx,%edi
c01087f9:	ac                   	lods   %ds:(%esi),%al
c01087fa:	ae                   	scas   %es:(%edi),%al
c01087fb:	75 08                	jne    c0108805 <strcmp+0x2e>
c01087fd:	84 c0                	test   %al,%al
c01087ff:	75 f8                	jne    c01087f9 <strcmp+0x22>
c0108801:	31 c0                	xor    %eax,%eax
c0108803:	eb 04                	jmp    c0108809 <strcmp+0x32>
c0108805:	19 c0                	sbb    %eax,%eax
c0108807:	0c 01                	or     $0x1,%al
c0108809:	89 fa                	mov    %edi,%edx
c010880b:	89 f1                	mov    %esi,%ecx
c010880d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108810:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108813:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0108816:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0108819:	83 c4 20             	add    $0x20,%esp
c010881c:	5e                   	pop    %esi
c010881d:	5f                   	pop    %edi
c010881e:	5d                   	pop    %ebp
c010881f:	c3                   	ret    

c0108820 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0108820:	55                   	push   %ebp
c0108821:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108823:	eb 0c                	jmp    c0108831 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0108825:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108829:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010882d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108831:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108835:	74 1a                	je     c0108851 <strncmp+0x31>
c0108837:	8b 45 08             	mov    0x8(%ebp),%eax
c010883a:	0f b6 00             	movzbl (%eax),%eax
c010883d:	84 c0                	test   %al,%al
c010883f:	74 10                	je     c0108851 <strncmp+0x31>
c0108841:	8b 45 08             	mov    0x8(%ebp),%eax
c0108844:	0f b6 10             	movzbl (%eax),%edx
c0108847:	8b 45 0c             	mov    0xc(%ebp),%eax
c010884a:	0f b6 00             	movzbl (%eax),%eax
c010884d:	38 c2                	cmp    %al,%dl
c010884f:	74 d4                	je     c0108825 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108851:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108855:	74 18                	je     c010886f <strncmp+0x4f>
c0108857:	8b 45 08             	mov    0x8(%ebp),%eax
c010885a:	0f b6 00             	movzbl (%eax),%eax
c010885d:	0f b6 d0             	movzbl %al,%edx
c0108860:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108863:	0f b6 00             	movzbl (%eax),%eax
c0108866:	0f b6 c0             	movzbl %al,%eax
c0108869:	29 c2                	sub    %eax,%edx
c010886b:	89 d0                	mov    %edx,%eax
c010886d:	eb 05                	jmp    c0108874 <strncmp+0x54>
c010886f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108874:	5d                   	pop    %ebp
c0108875:	c3                   	ret    

c0108876 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0108876:	55                   	push   %ebp
c0108877:	89 e5                	mov    %esp,%ebp
c0108879:	83 ec 04             	sub    $0x4,%esp
c010887c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010887f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108882:	eb 14                	jmp    c0108898 <strchr+0x22>
        if (*s == c) {
c0108884:	8b 45 08             	mov    0x8(%ebp),%eax
c0108887:	0f b6 00             	movzbl (%eax),%eax
c010888a:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010888d:	75 05                	jne    c0108894 <strchr+0x1e>
            return (char *)s;
c010888f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108892:	eb 13                	jmp    c01088a7 <strchr+0x31>
        }
        s ++;
c0108894:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0108898:	8b 45 08             	mov    0x8(%ebp),%eax
c010889b:	0f b6 00             	movzbl (%eax),%eax
c010889e:	84 c0                	test   %al,%al
c01088a0:	75 e2                	jne    c0108884 <strchr+0xe>
    }
    return NULL;
c01088a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01088a7:	c9                   	leave  
c01088a8:	c3                   	ret    

c01088a9 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01088a9:	55                   	push   %ebp
c01088aa:	89 e5                	mov    %esp,%ebp
c01088ac:	83 ec 04             	sub    $0x4,%esp
c01088af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088b2:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01088b5:	eb 11                	jmp    c01088c8 <strfind+0x1f>
        if (*s == c) {
c01088b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01088ba:	0f b6 00             	movzbl (%eax),%eax
c01088bd:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01088c0:	75 02                	jne    c01088c4 <strfind+0x1b>
            break;
c01088c2:	eb 0e                	jmp    c01088d2 <strfind+0x29>
        }
        s ++;
c01088c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c01088c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01088cb:	0f b6 00             	movzbl (%eax),%eax
c01088ce:	84 c0                	test   %al,%al
c01088d0:	75 e5                	jne    c01088b7 <strfind+0xe>
    }
    return (char *)s;
c01088d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01088d5:	c9                   	leave  
c01088d6:	c3                   	ret    

c01088d7 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01088d7:	55                   	push   %ebp
c01088d8:	89 e5                	mov    %esp,%ebp
c01088da:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01088dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01088e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01088eb:	eb 04                	jmp    c01088f1 <strtol+0x1a>
        s ++;
c01088ed:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01088f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01088f4:	0f b6 00             	movzbl (%eax),%eax
c01088f7:	3c 20                	cmp    $0x20,%al
c01088f9:	74 f2                	je     c01088ed <strtol+0x16>
c01088fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01088fe:	0f b6 00             	movzbl (%eax),%eax
c0108901:	3c 09                	cmp    $0x9,%al
c0108903:	74 e8                	je     c01088ed <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0108905:	8b 45 08             	mov    0x8(%ebp),%eax
c0108908:	0f b6 00             	movzbl (%eax),%eax
c010890b:	3c 2b                	cmp    $0x2b,%al
c010890d:	75 06                	jne    c0108915 <strtol+0x3e>
        s ++;
c010890f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108913:	eb 15                	jmp    c010892a <strtol+0x53>
    }
    else if (*s == '-') {
c0108915:	8b 45 08             	mov    0x8(%ebp),%eax
c0108918:	0f b6 00             	movzbl (%eax),%eax
c010891b:	3c 2d                	cmp    $0x2d,%al
c010891d:	75 0b                	jne    c010892a <strtol+0x53>
        s ++, neg = 1;
c010891f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108923:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010892a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010892e:	74 06                	je     c0108936 <strtol+0x5f>
c0108930:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0108934:	75 24                	jne    c010895a <strtol+0x83>
c0108936:	8b 45 08             	mov    0x8(%ebp),%eax
c0108939:	0f b6 00             	movzbl (%eax),%eax
c010893c:	3c 30                	cmp    $0x30,%al
c010893e:	75 1a                	jne    c010895a <strtol+0x83>
c0108940:	8b 45 08             	mov    0x8(%ebp),%eax
c0108943:	83 c0 01             	add    $0x1,%eax
c0108946:	0f b6 00             	movzbl (%eax),%eax
c0108949:	3c 78                	cmp    $0x78,%al
c010894b:	75 0d                	jne    c010895a <strtol+0x83>
        s += 2, base = 16;
c010894d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0108951:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0108958:	eb 2a                	jmp    c0108984 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010895a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010895e:	75 17                	jne    c0108977 <strtol+0xa0>
c0108960:	8b 45 08             	mov    0x8(%ebp),%eax
c0108963:	0f b6 00             	movzbl (%eax),%eax
c0108966:	3c 30                	cmp    $0x30,%al
c0108968:	75 0d                	jne    c0108977 <strtol+0xa0>
        s ++, base = 8;
c010896a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010896e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0108975:	eb 0d                	jmp    c0108984 <strtol+0xad>
    }
    else if (base == 0) {
c0108977:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010897b:	75 07                	jne    c0108984 <strtol+0xad>
        base = 10;
c010897d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0108984:	8b 45 08             	mov    0x8(%ebp),%eax
c0108987:	0f b6 00             	movzbl (%eax),%eax
c010898a:	3c 2f                	cmp    $0x2f,%al
c010898c:	7e 1b                	jle    c01089a9 <strtol+0xd2>
c010898e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108991:	0f b6 00             	movzbl (%eax),%eax
c0108994:	3c 39                	cmp    $0x39,%al
c0108996:	7f 11                	jg     c01089a9 <strtol+0xd2>
            dig = *s - '0';
c0108998:	8b 45 08             	mov    0x8(%ebp),%eax
c010899b:	0f b6 00             	movzbl (%eax),%eax
c010899e:	0f be c0             	movsbl %al,%eax
c01089a1:	83 e8 30             	sub    $0x30,%eax
c01089a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01089a7:	eb 48                	jmp    c01089f1 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01089a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01089ac:	0f b6 00             	movzbl (%eax),%eax
c01089af:	3c 60                	cmp    $0x60,%al
c01089b1:	7e 1b                	jle    c01089ce <strtol+0xf7>
c01089b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01089b6:	0f b6 00             	movzbl (%eax),%eax
c01089b9:	3c 7a                	cmp    $0x7a,%al
c01089bb:	7f 11                	jg     c01089ce <strtol+0xf7>
            dig = *s - 'a' + 10;
c01089bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01089c0:	0f b6 00             	movzbl (%eax),%eax
c01089c3:	0f be c0             	movsbl %al,%eax
c01089c6:	83 e8 57             	sub    $0x57,%eax
c01089c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01089cc:	eb 23                	jmp    c01089f1 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01089ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01089d1:	0f b6 00             	movzbl (%eax),%eax
c01089d4:	3c 40                	cmp    $0x40,%al
c01089d6:	7e 3d                	jle    c0108a15 <strtol+0x13e>
c01089d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01089db:	0f b6 00             	movzbl (%eax),%eax
c01089de:	3c 5a                	cmp    $0x5a,%al
c01089e0:	7f 33                	jg     c0108a15 <strtol+0x13e>
            dig = *s - 'A' + 10;
c01089e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01089e5:	0f b6 00             	movzbl (%eax),%eax
c01089e8:	0f be c0             	movsbl %al,%eax
c01089eb:	83 e8 37             	sub    $0x37,%eax
c01089ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01089f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089f4:	3b 45 10             	cmp    0x10(%ebp),%eax
c01089f7:	7c 02                	jl     c01089fb <strtol+0x124>
            break;
c01089f9:	eb 1a                	jmp    c0108a15 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c01089fb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01089ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a02:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108a06:	89 c2                	mov    %eax,%edx
c0108a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a0b:	01 d0                	add    %edx,%eax
c0108a0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0108a10:	e9 6f ff ff ff       	jmp    c0108984 <strtol+0xad>

    if (endptr) {
c0108a15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108a19:	74 08                	je     c0108a23 <strtol+0x14c>
        *endptr = (char *) s;
c0108a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a1e:	8b 55 08             	mov    0x8(%ebp),%edx
c0108a21:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0108a23:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108a27:	74 07                	je     c0108a30 <strtol+0x159>
c0108a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a2c:	f7 d8                	neg    %eax
c0108a2e:	eb 03                	jmp    c0108a33 <strtol+0x15c>
c0108a30:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0108a33:	c9                   	leave  
c0108a34:	c3                   	ret    

c0108a35 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0108a35:	55                   	push   %ebp
c0108a36:	89 e5                	mov    %esp,%ebp
c0108a38:	57                   	push   %edi
c0108a39:	83 ec 24             	sub    $0x24,%esp
c0108a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a3f:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108a42:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0108a46:	8b 55 08             	mov    0x8(%ebp),%edx
c0108a49:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0108a4c:	88 45 f7             	mov    %al,-0x9(%ebp)
c0108a4f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0108a55:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108a58:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0108a5c:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0108a5f:	89 d7                	mov    %edx,%edi
c0108a61:	f3 aa                	rep stos %al,%es:(%edi)
c0108a63:	89 fa                	mov    %edi,%edx
c0108a65:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108a68:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0108a6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108a6e:	83 c4 24             	add    $0x24,%esp
c0108a71:	5f                   	pop    %edi
c0108a72:	5d                   	pop    %ebp
c0108a73:	c3                   	ret    

c0108a74 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108a74:	55                   	push   %ebp
c0108a75:	89 e5                	mov    %esp,%ebp
c0108a77:	57                   	push   %edi
c0108a78:	56                   	push   %esi
c0108a79:	53                   	push   %ebx
c0108a7a:	83 ec 30             	sub    $0x30,%esp
c0108a7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a83:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a86:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108a89:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a8c:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a92:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108a95:	73 42                	jae    c0108ad9 <memmove+0x65>
c0108a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108a9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108aa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108aa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108aa6:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108aa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108aac:	c1 e8 02             	shr    $0x2,%eax
c0108aaf:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0108ab1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108ab4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108ab7:	89 d7                	mov    %edx,%edi
c0108ab9:	89 c6                	mov    %eax,%esi
c0108abb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108abd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108ac0:	83 e1 03             	and    $0x3,%ecx
c0108ac3:	74 02                	je     c0108ac7 <memmove+0x53>
c0108ac5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108ac7:	89 f0                	mov    %esi,%eax
c0108ac9:	89 fa                	mov    %edi,%edx
c0108acb:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108ace:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108ad1:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0108ad4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108ad7:	eb 36                	jmp    c0108b0f <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0108ad9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108adc:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108adf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ae2:	01 c2                	add    %eax,%edx
c0108ae4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108ae7:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0108aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108aed:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0108af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108af3:	89 c1                	mov    %eax,%ecx
c0108af5:	89 d8                	mov    %ebx,%eax
c0108af7:	89 d6                	mov    %edx,%esi
c0108af9:	89 c7                	mov    %eax,%edi
c0108afb:	fd                   	std    
c0108afc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108afe:	fc                   	cld    
c0108aff:	89 f8                	mov    %edi,%eax
c0108b01:	89 f2                	mov    %esi,%edx
c0108b03:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108b06:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0108b09:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0108b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108b0f:	83 c4 30             	add    $0x30,%esp
c0108b12:	5b                   	pop    %ebx
c0108b13:	5e                   	pop    %esi
c0108b14:	5f                   	pop    %edi
c0108b15:	5d                   	pop    %ebp
c0108b16:	c3                   	ret    

c0108b17 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108b17:	55                   	push   %ebp
c0108b18:	89 e5                	mov    %esp,%ebp
c0108b1a:	57                   	push   %edi
c0108b1b:	56                   	push   %esi
c0108b1c:	83 ec 20             	sub    $0x20,%esp
c0108b1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b22:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108b25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b2b:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b34:	c1 e8 02             	shr    $0x2,%eax
c0108b37:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0108b39:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b3f:	89 d7                	mov    %edx,%edi
c0108b41:	89 c6                	mov    %eax,%esi
c0108b43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108b45:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108b48:	83 e1 03             	and    $0x3,%ecx
c0108b4b:	74 02                	je     c0108b4f <memcpy+0x38>
c0108b4d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108b4f:	89 f0                	mov    %esi,%eax
c0108b51:	89 fa                	mov    %edi,%edx
c0108b53:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108b56:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108b59:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0108b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108b5f:	83 c4 20             	add    $0x20,%esp
c0108b62:	5e                   	pop    %esi
c0108b63:	5f                   	pop    %edi
c0108b64:	5d                   	pop    %ebp
c0108b65:	c3                   	ret    

c0108b66 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108b66:	55                   	push   %ebp
c0108b67:	89 e5                	mov    %esp,%ebp
c0108b69:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108b6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108b72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b75:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108b78:	eb 30                	jmp    c0108baa <memcmp+0x44>
        if (*s1 != *s2) {
c0108b7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108b7d:	0f b6 10             	movzbl (%eax),%edx
c0108b80:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108b83:	0f b6 00             	movzbl (%eax),%eax
c0108b86:	38 c2                	cmp    %al,%dl
c0108b88:	74 18                	je     c0108ba2 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108b8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108b8d:	0f b6 00             	movzbl (%eax),%eax
c0108b90:	0f b6 d0             	movzbl %al,%edx
c0108b93:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108b96:	0f b6 00             	movzbl (%eax),%eax
c0108b99:	0f b6 c0             	movzbl %al,%eax
c0108b9c:	29 c2                	sub    %eax,%edx
c0108b9e:	89 d0                	mov    %edx,%eax
c0108ba0:	eb 1a                	jmp    c0108bbc <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0108ba2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108ba6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c0108baa:	8b 45 10             	mov    0x10(%ebp),%eax
c0108bad:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108bb0:	89 55 10             	mov    %edx,0x10(%ebp)
c0108bb3:	85 c0                	test   %eax,%eax
c0108bb5:	75 c3                	jne    c0108b7a <memcmp+0x14>
    }
    return 0;
c0108bb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108bbc:	c9                   	leave  
c0108bbd:	c3                   	ret    

c0108bbe <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0108bbe:	55                   	push   %ebp
c0108bbf:	89 e5                	mov    %esp,%ebp
c0108bc1:	83 ec 58             	sub    $0x58,%esp
c0108bc4:	8b 45 10             	mov    0x10(%ebp),%eax
c0108bc7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0108bca:	8b 45 14             	mov    0x14(%ebp),%eax
c0108bcd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0108bd0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108bd3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108bd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108bd9:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0108bdc:	8b 45 18             	mov    0x18(%ebp),%eax
c0108bdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108be2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108be5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108be8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108beb:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0108bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108bf4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108bf8:	74 1c                	je     c0108c16 <printnum+0x58>
c0108bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bfd:	ba 00 00 00 00       	mov    $0x0,%edx
c0108c02:	f7 75 e4             	divl   -0x1c(%ebp)
c0108c05:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c0b:	ba 00 00 00 00       	mov    $0x0,%edx
c0108c10:	f7 75 e4             	divl   -0x1c(%ebp)
c0108c13:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108c16:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108c1c:	f7 75 e4             	divl   -0x1c(%ebp)
c0108c1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108c22:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0108c25:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108c28:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108c2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108c2e:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108c31:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108c34:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0108c37:	8b 45 18             	mov    0x18(%ebp),%eax
c0108c3a:	ba 00 00 00 00       	mov    $0x0,%edx
c0108c3f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0108c42:	77 56                	ja     c0108c9a <printnum+0xdc>
c0108c44:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0108c47:	72 05                	jb     c0108c4e <printnum+0x90>
c0108c49:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0108c4c:	77 4c                	ja     c0108c9a <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0108c4e:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0108c51:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108c54:	8b 45 20             	mov    0x20(%ebp),%eax
c0108c57:	89 44 24 18          	mov    %eax,0x18(%esp)
c0108c5b:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108c5f:	8b 45 18             	mov    0x18(%ebp),%eax
c0108c62:	89 44 24 10          	mov    %eax,0x10(%esp)
c0108c66:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c69:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108c6c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108c70:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108c74:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c7e:	89 04 24             	mov    %eax,(%esp)
c0108c81:	e8 38 ff ff ff       	call   c0108bbe <printnum>
c0108c86:	eb 1c                	jmp    c0108ca4 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0108c88:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c8b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c8f:	8b 45 20             	mov    0x20(%ebp),%eax
c0108c92:	89 04 24             	mov    %eax,(%esp)
c0108c95:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c98:	ff d0                	call   *%eax
        while (-- width > 0)
c0108c9a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0108c9e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0108ca2:	7f e4                	jg     c0108c88 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0108ca4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108ca7:	05 14 b4 10 c0       	add    $0xc010b414,%eax
c0108cac:	0f b6 00             	movzbl (%eax),%eax
c0108caf:	0f be c0             	movsbl %al,%eax
c0108cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108cb5:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108cb9:	89 04 24             	mov    %eax,(%esp)
c0108cbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cbf:	ff d0                	call   *%eax
}
c0108cc1:	c9                   	leave  
c0108cc2:	c3                   	ret    

c0108cc3 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0108cc3:	55                   	push   %ebp
c0108cc4:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108cc6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108cca:	7e 14                	jle    c0108ce0 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0108ccc:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ccf:	8b 00                	mov    (%eax),%eax
c0108cd1:	8d 48 08             	lea    0x8(%eax),%ecx
c0108cd4:	8b 55 08             	mov    0x8(%ebp),%edx
c0108cd7:	89 0a                	mov    %ecx,(%edx)
c0108cd9:	8b 50 04             	mov    0x4(%eax),%edx
c0108cdc:	8b 00                	mov    (%eax),%eax
c0108cde:	eb 30                	jmp    c0108d10 <getuint+0x4d>
    }
    else if (lflag) {
c0108ce0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108ce4:	74 16                	je     c0108cfc <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0108ce6:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ce9:	8b 00                	mov    (%eax),%eax
c0108ceb:	8d 48 04             	lea    0x4(%eax),%ecx
c0108cee:	8b 55 08             	mov    0x8(%ebp),%edx
c0108cf1:	89 0a                	mov    %ecx,(%edx)
c0108cf3:	8b 00                	mov    (%eax),%eax
c0108cf5:	ba 00 00 00 00       	mov    $0x0,%edx
c0108cfa:	eb 14                	jmp    c0108d10 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0108cfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cff:	8b 00                	mov    (%eax),%eax
c0108d01:	8d 48 04             	lea    0x4(%eax),%ecx
c0108d04:	8b 55 08             	mov    0x8(%ebp),%edx
c0108d07:	89 0a                	mov    %ecx,(%edx)
c0108d09:	8b 00                	mov    (%eax),%eax
c0108d0b:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0108d10:	5d                   	pop    %ebp
c0108d11:	c3                   	ret    

c0108d12 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0108d12:	55                   	push   %ebp
c0108d13:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108d15:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108d19:	7e 14                	jle    c0108d2f <getint+0x1d>
        return va_arg(*ap, long long);
c0108d1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d1e:	8b 00                	mov    (%eax),%eax
c0108d20:	8d 48 08             	lea    0x8(%eax),%ecx
c0108d23:	8b 55 08             	mov    0x8(%ebp),%edx
c0108d26:	89 0a                	mov    %ecx,(%edx)
c0108d28:	8b 50 04             	mov    0x4(%eax),%edx
c0108d2b:	8b 00                	mov    (%eax),%eax
c0108d2d:	eb 28                	jmp    c0108d57 <getint+0x45>
    }
    else if (lflag) {
c0108d2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108d33:	74 12                	je     c0108d47 <getint+0x35>
        return va_arg(*ap, long);
c0108d35:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d38:	8b 00                	mov    (%eax),%eax
c0108d3a:	8d 48 04             	lea    0x4(%eax),%ecx
c0108d3d:	8b 55 08             	mov    0x8(%ebp),%edx
c0108d40:	89 0a                	mov    %ecx,(%edx)
c0108d42:	8b 00                	mov    (%eax),%eax
c0108d44:	99                   	cltd   
c0108d45:	eb 10                	jmp    c0108d57 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0108d47:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d4a:	8b 00                	mov    (%eax),%eax
c0108d4c:	8d 48 04             	lea    0x4(%eax),%ecx
c0108d4f:	8b 55 08             	mov    0x8(%ebp),%edx
c0108d52:	89 0a                	mov    %ecx,(%edx)
c0108d54:	8b 00                	mov    (%eax),%eax
c0108d56:	99                   	cltd   
    }
}
c0108d57:	5d                   	pop    %ebp
c0108d58:	c3                   	ret    

c0108d59 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0108d59:	55                   	push   %ebp
c0108d5a:	89 e5                	mov    %esp,%ebp
c0108d5c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0108d5f:	8d 45 14             	lea    0x14(%ebp),%eax
c0108d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0108d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d68:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108d6c:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d6f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108d73:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d7d:	89 04 24             	mov    %eax,(%esp)
c0108d80:	e8 02 00 00 00       	call   c0108d87 <vprintfmt>
    va_end(ap);
}
c0108d85:	c9                   	leave  
c0108d86:	c3                   	ret    

c0108d87 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0108d87:	55                   	push   %ebp
c0108d88:	89 e5                	mov    %esp,%ebp
c0108d8a:	56                   	push   %esi
c0108d8b:	53                   	push   %ebx
c0108d8c:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108d8f:	eb 18                	jmp    c0108da9 <vprintfmt+0x22>
            if (ch == '\0') {
c0108d91:	85 db                	test   %ebx,%ebx
c0108d93:	75 05                	jne    c0108d9a <vprintfmt+0x13>
                return;
c0108d95:	e9 d1 03 00 00       	jmp    c010916b <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0108d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d9d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108da1:	89 1c 24             	mov    %ebx,(%esp)
c0108da4:	8b 45 08             	mov    0x8(%ebp),%eax
c0108da7:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108da9:	8b 45 10             	mov    0x10(%ebp),%eax
c0108dac:	8d 50 01             	lea    0x1(%eax),%edx
c0108daf:	89 55 10             	mov    %edx,0x10(%ebp)
c0108db2:	0f b6 00             	movzbl (%eax),%eax
c0108db5:	0f b6 d8             	movzbl %al,%ebx
c0108db8:	83 fb 25             	cmp    $0x25,%ebx
c0108dbb:	75 d4                	jne    c0108d91 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0108dbd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0108dc1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0108dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108dcb:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0108dce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0108dd5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108dd8:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0108ddb:	8b 45 10             	mov    0x10(%ebp),%eax
c0108dde:	8d 50 01             	lea    0x1(%eax),%edx
c0108de1:	89 55 10             	mov    %edx,0x10(%ebp)
c0108de4:	0f b6 00             	movzbl (%eax),%eax
c0108de7:	0f b6 d8             	movzbl %al,%ebx
c0108dea:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0108ded:	83 f8 55             	cmp    $0x55,%eax
c0108df0:	0f 87 44 03 00 00    	ja     c010913a <vprintfmt+0x3b3>
c0108df6:	8b 04 85 38 b4 10 c0 	mov    -0x3fef4bc8(,%eax,4),%eax
c0108dfd:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0108dff:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0108e03:	eb d6                	jmp    c0108ddb <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0108e05:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0108e09:	eb d0                	jmp    c0108ddb <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0108e0b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0108e12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108e15:	89 d0                	mov    %edx,%eax
c0108e17:	c1 e0 02             	shl    $0x2,%eax
c0108e1a:	01 d0                	add    %edx,%eax
c0108e1c:	01 c0                	add    %eax,%eax
c0108e1e:	01 d8                	add    %ebx,%eax
c0108e20:	83 e8 30             	sub    $0x30,%eax
c0108e23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0108e26:	8b 45 10             	mov    0x10(%ebp),%eax
c0108e29:	0f b6 00             	movzbl (%eax),%eax
c0108e2c:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0108e2f:	83 fb 2f             	cmp    $0x2f,%ebx
c0108e32:	7e 0b                	jle    c0108e3f <vprintfmt+0xb8>
c0108e34:	83 fb 39             	cmp    $0x39,%ebx
c0108e37:	7f 06                	jg     c0108e3f <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
c0108e39:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
c0108e3d:	eb d3                	jmp    c0108e12 <vprintfmt+0x8b>
            goto process_precision;
c0108e3f:	eb 33                	jmp    c0108e74 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0108e41:	8b 45 14             	mov    0x14(%ebp),%eax
c0108e44:	8d 50 04             	lea    0x4(%eax),%edx
c0108e47:	89 55 14             	mov    %edx,0x14(%ebp)
c0108e4a:	8b 00                	mov    (%eax),%eax
c0108e4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0108e4f:	eb 23                	jmp    c0108e74 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0108e51:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108e55:	79 0c                	jns    c0108e63 <vprintfmt+0xdc>
                width = 0;
c0108e57:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0108e5e:	e9 78 ff ff ff       	jmp    c0108ddb <vprintfmt+0x54>
c0108e63:	e9 73 ff ff ff       	jmp    c0108ddb <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0108e68:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0108e6f:	e9 67 ff ff ff       	jmp    c0108ddb <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0108e74:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108e78:	79 12                	jns    c0108e8c <vprintfmt+0x105>
                width = precision, precision = -1;
c0108e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108e7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108e80:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0108e87:	e9 4f ff ff ff       	jmp    c0108ddb <vprintfmt+0x54>
c0108e8c:	e9 4a ff ff ff       	jmp    c0108ddb <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0108e91:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0108e95:	e9 41 ff ff ff       	jmp    c0108ddb <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108e9a:	8b 45 14             	mov    0x14(%ebp),%eax
c0108e9d:	8d 50 04             	lea    0x4(%eax),%edx
c0108ea0:	89 55 14             	mov    %edx,0x14(%ebp)
c0108ea3:	8b 00                	mov    (%eax),%eax
c0108ea5:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108ea8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108eac:	89 04 24             	mov    %eax,(%esp)
c0108eaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0108eb2:	ff d0                	call   *%eax
            break;
c0108eb4:	e9 ac 02 00 00       	jmp    c0109165 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0108eb9:	8b 45 14             	mov    0x14(%ebp),%eax
c0108ebc:	8d 50 04             	lea    0x4(%eax),%edx
c0108ebf:	89 55 14             	mov    %edx,0x14(%ebp)
c0108ec2:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0108ec4:	85 db                	test   %ebx,%ebx
c0108ec6:	79 02                	jns    c0108eca <vprintfmt+0x143>
                err = -err;
c0108ec8:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0108eca:	83 fb 06             	cmp    $0x6,%ebx
c0108ecd:	7f 0b                	jg     c0108eda <vprintfmt+0x153>
c0108ecf:	8b 34 9d f8 b3 10 c0 	mov    -0x3fef4c08(,%ebx,4),%esi
c0108ed6:	85 f6                	test   %esi,%esi
c0108ed8:	75 23                	jne    c0108efd <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0108eda:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0108ede:	c7 44 24 08 25 b4 10 	movl   $0xc010b425,0x8(%esp)
c0108ee5:	c0 
c0108ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108eed:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ef0:	89 04 24             	mov    %eax,(%esp)
c0108ef3:	e8 61 fe ff ff       	call   c0108d59 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0108ef8:	e9 68 02 00 00       	jmp    c0109165 <vprintfmt+0x3de>
                printfmt(putch, putdat, "%s", p);
c0108efd:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0108f01:	c7 44 24 08 2e b4 10 	movl   $0xc010b42e,0x8(%esp)
c0108f08:	c0 
c0108f09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108f0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108f10:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f13:	89 04 24             	mov    %eax,(%esp)
c0108f16:	e8 3e fe ff ff       	call   c0108d59 <printfmt>
            break;
c0108f1b:	e9 45 02 00 00       	jmp    c0109165 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0108f20:	8b 45 14             	mov    0x14(%ebp),%eax
c0108f23:	8d 50 04             	lea    0x4(%eax),%edx
c0108f26:	89 55 14             	mov    %edx,0x14(%ebp)
c0108f29:	8b 30                	mov    (%eax),%esi
c0108f2b:	85 f6                	test   %esi,%esi
c0108f2d:	75 05                	jne    c0108f34 <vprintfmt+0x1ad>
                p = "(null)";
c0108f2f:	be 31 b4 10 c0       	mov    $0xc010b431,%esi
            }
            if (width > 0 && padc != '-') {
c0108f34:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108f38:	7e 3e                	jle    c0108f78 <vprintfmt+0x1f1>
c0108f3a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0108f3e:	74 38                	je     c0108f78 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108f40:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0108f43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108f46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108f4a:	89 34 24             	mov    %esi,(%esp)
c0108f4d:	e8 dc f7 ff ff       	call   c010872e <strnlen>
c0108f52:	29 c3                	sub    %eax,%ebx
c0108f54:	89 d8                	mov    %ebx,%eax
c0108f56:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108f59:	eb 17                	jmp    c0108f72 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0108f5b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0108f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108f62:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108f66:	89 04 24             	mov    %eax,(%esp)
c0108f69:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f6c:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108f6e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108f72:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108f76:	7f e3                	jg     c0108f5b <vprintfmt+0x1d4>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108f78:	eb 38                	jmp    c0108fb2 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0108f7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108f7e:	74 1f                	je     c0108f9f <vprintfmt+0x218>
c0108f80:	83 fb 1f             	cmp    $0x1f,%ebx
c0108f83:	7e 05                	jle    c0108f8a <vprintfmt+0x203>
c0108f85:	83 fb 7e             	cmp    $0x7e,%ebx
c0108f88:	7e 15                	jle    c0108f9f <vprintfmt+0x218>
                    putch('?', putdat);
c0108f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108f8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108f91:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0108f98:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f9b:	ff d0                	call   *%eax
c0108f9d:	eb 0f                	jmp    c0108fae <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0108f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108fa2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108fa6:	89 1c 24             	mov    %ebx,(%esp)
c0108fa9:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fac:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108fae:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108fb2:	89 f0                	mov    %esi,%eax
c0108fb4:	8d 70 01             	lea    0x1(%eax),%esi
c0108fb7:	0f b6 00             	movzbl (%eax),%eax
c0108fba:	0f be d8             	movsbl %al,%ebx
c0108fbd:	85 db                	test   %ebx,%ebx
c0108fbf:	74 10                	je     c0108fd1 <vprintfmt+0x24a>
c0108fc1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108fc5:	78 b3                	js     c0108f7a <vprintfmt+0x1f3>
c0108fc7:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0108fcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108fcf:	79 a9                	jns    c0108f7a <vprintfmt+0x1f3>
                }
            }
            for (; width > 0; width --) {
c0108fd1:	eb 17                	jmp    c0108fea <vprintfmt+0x263>
                putch(' ', putdat);
c0108fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108fd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108fda:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0108fe1:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fe4:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0108fe6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108fea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108fee:	7f e3                	jg     c0108fd3 <vprintfmt+0x24c>
            }
            break;
c0108ff0:	e9 70 01 00 00       	jmp    c0109165 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0108ff5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108ff8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ffc:	8d 45 14             	lea    0x14(%ebp),%eax
c0108fff:	89 04 24             	mov    %eax,(%esp)
c0109002:	e8 0b fd ff ff       	call   c0108d12 <getint>
c0109007:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010900a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010900d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109010:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109013:	85 d2                	test   %edx,%edx
c0109015:	79 26                	jns    c010903d <vprintfmt+0x2b6>
                putch('-', putdat);
c0109017:	8b 45 0c             	mov    0xc(%ebp),%eax
c010901a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010901e:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0109025:	8b 45 08             	mov    0x8(%ebp),%eax
c0109028:	ff d0                	call   *%eax
                num = -(long long)num;
c010902a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010902d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109030:	f7 d8                	neg    %eax
c0109032:	83 d2 00             	adc    $0x0,%edx
c0109035:	f7 da                	neg    %edx
c0109037:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010903a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010903d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109044:	e9 a8 00 00 00       	jmp    c01090f1 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0109049:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010904c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109050:	8d 45 14             	lea    0x14(%ebp),%eax
c0109053:	89 04 24             	mov    %eax,(%esp)
c0109056:	e8 68 fc ff ff       	call   c0108cc3 <getuint>
c010905b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010905e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0109061:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109068:	e9 84 00 00 00       	jmp    c01090f1 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010906d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109070:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109074:	8d 45 14             	lea    0x14(%ebp),%eax
c0109077:	89 04 24             	mov    %eax,(%esp)
c010907a:	e8 44 fc ff ff       	call   c0108cc3 <getuint>
c010907f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109082:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0109085:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010908c:	eb 63                	jmp    c01090f1 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c010908e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109091:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109095:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010909c:	8b 45 08             	mov    0x8(%ebp),%eax
c010909f:	ff d0                	call   *%eax
            putch('x', putdat);
c01090a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01090a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01090a8:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01090af:	8b 45 08             	mov    0x8(%ebp),%eax
c01090b2:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01090b4:	8b 45 14             	mov    0x14(%ebp),%eax
c01090b7:	8d 50 04             	lea    0x4(%eax),%edx
c01090ba:	89 55 14             	mov    %edx,0x14(%ebp)
c01090bd:	8b 00                	mov    (%eax),%eax
c01090bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01090c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01090c9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01090d0:	eb 1f                	jmp    c01090f1 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01090d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01090d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01090d9:	8d 45 14             	lea    0x14(%ebp),%eax
c01090dc:	89 04 24             	mov    %eax,(%esp)
c01090df:	e8 df fb ff ff       	call   c0108cc3 <getuint>
c01090e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01090e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01090ea:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01090f1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01090f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01090f8:	89 54 24 18          	mov    %edx,0x18(%esp)
c01090fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01090ff:	89 54 24 14          	mov    %edx,0x14(%esp)
c0109103:	89 44 24 10          	mov    %eax,0x10(%esp)
c0109107:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010910a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010910d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109111:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0109115:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010911c:	8b 45 08             	mov    0x8(%ebp),%eax
c010911f:	89 04 24             	mov    %eax,(%esp)
c0109122:	e8 97 fa ff ff       	call   c0108bbe <printnum>
            break;
c0109127:	eb 3c                	jmp    c0109165 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0109129:	8b 45 0c             	mov    0xc(%ebp),%eax
c010912c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109130:	89 1c 24             	mov    %ebx,(%esp)
c0109133:	8b 45 08             	mov    0x8(%ebp),%eax
c0109136:	ff d0                	call   *%eax
            break;
c0109138:	eb 2b                	jmp    c0109165 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010913a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010913d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109141:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0109148:	8b 45 08             	mov    0x8(%ebp),%eax
c010914b:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010914d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109151:	eb 04                	jmp    c0109157 <vprintfmt+0x3d0>
c0109153:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109157:	8b 45 10             	mov    0x10(%ebp),%eax
c010915a:	83 e8 01             	sub    $0x1,%eax
c010915d:	0f b6 00             	movzbl (%eax),%eax
c0109160:	3c 25                	cmp    $0x25,%al
c0109162:	75 ef                	jne    c0109153 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0109164:	90                   	nop
        }
    }
c0109165:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109166:	e9 3e fc ff ff       	jmp    c0108da9 <vprintfmt+0x22>
}
c010916b:	83 c4 40             	add    $0x40,%esp
c010916e:	5b                   	pop    %ebx
c010916f:	5e                   	pop    %esi
c0109170:	5d                   	pop    %ebp
c0109171:	c3                   	ret    

c0109172 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0109172:	55                   	push   %ebp
c0109173:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0109175:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109178:	8b 40 08             	mov    0x8(%eax),%eax
c010917b:	8d 50 01             	lea    0x1(%eax),%edx
c010917e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109181:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0109184:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109187:	8b 10                	mov    (%eax),%edx
c0109189:	8b 45 0c             	mov    0xc(%ebp),%eax
c010918c:	8b 40 04             	mov    0x4(%eax),%eax
c010918f:	39 c2                	cmp    %eax,%edx
c0109191:	73 12                	jae    c01091a5 <sprintputch+0x33>
        *b->buf ++ = ch;
c0109193:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109196:	8b 00                	mov    (%eax),%eax
c0109198:	8d 48 01             	lea    0x1(%eax),%ecx
c010919b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010919e:	89 0a                	mov    %ecx,(%edx)
c01091a0:	8b 55 08             	mov    0x8(%ebp),%edx
c01091a3:	88 10                	mov    %dl,(%eax)
    }
}
c01091a5:	5d                   	pop    %ebp
c01091a6:	c3                   	ret    

c01091a7 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01091a7:	55                   	push   %ebp
c01091a8:	89 e5                	mov    %esp,%ebp
c01091aa:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01091ad:	8d 45 14             	lea    0x14(%ebp),%eax
c01091b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01091b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01091b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01091ba:	8b 45 10             	mov    0x10(%ebp),%eax
c01091bd:	89 44 24 08          	mov    %eax,0x8(%esp)
c01091c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01091c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01091cb:	89 04 24             	mov    %eax,(%esp)
c01091ce:	e8 08 00 00 00       	call   c01091db <vsnprintf>
c01091d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01091d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01091d9:	c9                   	leave  
c01091da:	c3                   	ret    

c01091db <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01091db:	55                   	push   %ebp
c01091dc:	89 e5                	mov    %esp,%ebp
c01091de:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01091e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01091e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01091e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091ea:	8d 50 ff             	lea    -0x1(%eax),%edx
c01091ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01091f0:	01 d0                	add    %edx,%eax
c01091f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01091f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01091fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109200:	74 0a                	je     c010920c <vsnprintf+0x31>
c0109202:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109205:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109208:	39 c2                	cmp    %eax,%edx
c010920a:	76 07                	jbe    c0109213 <vsnprintf+0x38>
        return -E_INVAL;
c010920c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0109211:	eb 2a                	jmp    c010923d <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0109213:	8b 45 14             	mov    0x14(%ebp),%eax
c0109216:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010921a:	8b 45 10             	mov    0x10(%ebp),%eax
c010921d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109221:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0109224:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109228:	c7 04 24 72 91 10 c0 	movl   $0xc0109172,(%esp)
c010922f:	e8 53 fb ff ff       	call   c0108d87 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0109234:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109237:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010923a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010923d:	c9                   	leave  
c010923e:	c3                   	ret    

c010923f <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c010923f:	55                   	push   %ebp
c0109240:	89 e5                	mov    %esp,%ebp
c0109242:	57                   	push   %edi
c0109243:	56                   	push   %esi
c0109244:	53                   	push   %ebx
c0109245:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0109248:	a1 78 1a 12 c0       	mov    0xc0121a78,%eax
c010924d:	8b 15 7c 1a 12 c0    	mov    0xc0121a7c,%edx
c0109253:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0109259:	6b f0 05             	imul   $0x5,%eax,%esi
c010925c:	01 f7                	add    %esi,%edi
c010925e:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c0109263:	f7 e6                	mul    %esi
c0109265:	8d 34 17             	lea    (%edi,%edx,1),%esi
c0109268:	89 f2                	mov    %esi,%edx
c010926a:	83 c0 0b             	add    $0xb,%eax
c010926d:	83 d2 00             	adc    $0x0,%edx
c0109270:	89 c7                	mov    %eax,%edi
c0109272:	83 e7 ff             	and    $0xffffffff,%edi
c0109275:	89 f9                	mov    %edi,%ecx
c0109277:	0f b7 da             	movzwl %dx,%ebx
c010927a:	89 0d 78 1a 12 c0    	mov    %ecx,0xc0121a78
c0109280:	89 1d 7c 1a 12 c0    	mov    %ebx,0xc0121a7c
    unsigned long long result = (next >> 12);
c0109286:	a1 78 1a 12 c0       	mov    0xc0121a78,%eax
c010928b:	8b 15 7c 1a 12 c0    	mov    0xc0121a7c,%edx
c0109291:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0109295:	c1 ea 0c             	shr    $0xc,%edx
c0109298:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010929b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c010929e:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c01092a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01092a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01092ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01092ae:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01092b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01092b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01092b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01092bb:	74 1c                	je     c01092d9 <rand+0x9a>
c01092bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01092c0:	ba 00 00 00 00       	mov    $0x0,%edx
c01092c5:	f7 75 dc             	divl   -0x24(%ebp)
c01092c8:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01092cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01092ce:	ba 00 00 00 00       	mov    $0x0,%edx
c01092d3:	f7 75 dc             	divl   -0x24(%ebp)
c01092d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01092d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01092dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01092df:	f7 75 dc             	divl   -0x24(%ebp)
c01092e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01092e5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01092e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01092eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01092ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01092f1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01092f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c01092f7:	83 c4 24             	add    $0x24,%esp
c01092fa:	5b                   	pop    %ebx
c01092fb:	5e                   	pop    %esi
c01092fc:	5f                   	pop    %edi
c01092fd:	5d                   	pop    %ebp
c01092fe:	c3                   	ret    

c01092ff <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c01092ff:	55                   	push   %ebp
c0109300:	89 e5                	mov    %esp,%ebp
    next = seed;
c0109302:	8b 45 08             	mov    0x8(%ebp),%eax
c0109305:	ba 00 00 00 00       	mov    $0x0,%edx
c010930a:	a3 78 1a 12 c0       	mov    %eax,0xc0121a78
c010930f:	89 15 7c 1a 12 c0    	mov    %edx,0xc0121a7c
}
c0109315:	5d                   	pop    %ebp
c0109316:	c3                   	ret    
