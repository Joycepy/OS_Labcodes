
obj/__user_faultread.out:     file format elf32-i386


Disassembly of section .text:

00800020 <__panic>:
#include <stdio.h>
#include <ulib.h>
#include <error.h>

void
__panic(const char *file, int line, const char *fmt, ...) {
  800020:	55                   	push   %ebp
  800021:	89 e5                	mov    %esp,%ebp
  800023:	83 ec 28             	sub    $0x28,%esp
    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  800026:	8d 45 14             	lea    0x14(%ebp),%eax
  800029:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("user panic at %s:%d:\n    ", file, line);
  80002c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80002f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800033:	8b 45 08             	mov    0x8(%ebp),%eax
  800036:	89 44 24 04          	mov    %eax,0x4(%esp)
  80003a:	c7 04 24 00 18 80 00 	movl   $0x801800,(%esp)
  800041:	e8 83 07 00 00       	call   8007c9 <cprintf>
    vcprintf(fmt, ap);
  800046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800049:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004d:	8b 45 10             	mov    0x10(%ebp),%eax
  800050:	89 04 24             	mov    %eax,(%esp)
  800053:	e8 36 07 00 00       	call   80078e <vcprintf>
    cprintf("\n");
  800058:	c7 04 24 1a 18 80 00 	movl   $0x80181a,(%esp)
  80005f:	e8 65 07 00 00       	call   8007c9 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800064:	c7 04 24 f6 ff ff ff 	movl   $0xfffffff6,(%esp)
  80006b:	e8 f8 03 00 00       	call   800468 <exit>

00800070 <__warn>:
}

void
__warn(const char *file, int line, const char *fmt, ...) {
  800070:	55                   	push   %ebp
  800071:	89 e5                	mov    %esp,%ebp
  800073:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  800076:	8d 45 14             	lea    0x14(%ebp),%eax
  800079:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("user warning at %s:%d:\n    ", file, line);
  80007c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80007f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800083:	8b 45 08             	mov    0x8(%ebp),%eax
  800086:	89 44 24 04          	mov    %eax,0x4(%esp)
  80008a:	c7 04 24 1c 18 80 00 	movl   $0x80181c,(%esp)
  800091:	e8 33 07 00 00       	call   8007c9 <cprintf>
    vcprintf(fmt, ap);
  800096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800099:	89 44 24 04          	mov    %eax,0x4(%esp)
  80009d:	8b 45 10             	mov    0x10(%ebp),%eax
  8000a0:	89 04 24             	mov    %eax,(%esp)
  8000a3:	e8 e6 06 00 00       	call   80078e <vcprintf>
    cprintf("\n");
  8000a8:	c7 04 24 1a 18 80 00 	movl   $0x80181a,(%esp)
  8000af:	e8 15 07 00 00       	call   8007c9 <cprintf>
    va_end(ap);
}
  8000b4:	c9                   	leave  
  8000b5:	c3                   	ret    

008000b6 <syscall>:


#define MAX_ARGS            5

static inline int
syscall(int num, ...) {
  8000b6:	55                   	push   %ebp
  8000b7:	89 e5                	mov    %esp,%ebp
  8000b9:	57                   	push   %edi
  8000ba:	56                   	push   %esi
  8000bb:	53                   	push   %ebx
  8000bc:	83 ec 20             	sub    $0x20,%esp
    va_list ap;
    va_start(ap, num);
  8000bf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8000c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    uint32_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
  8000c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000cc:	eb 16                	jmp    8000e4 <syscall+0x2e>
        a[i] = va_arg(ap, uint32_t);
  8000ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d1:	8d 50 04             	lea    0x4(%eax),%edx
  8000d4:	89 55 e8             	mov    %edx,-0x18(%ebp)
  8000d7:	8b 10                	mov    (%eax),%edx
  8000d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000dc:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
    for (i = 0; i < MAX_ARGS; i ++) {
  8000e0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  8000e4:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
  8000e8:	7e e4                	jle    8000ce <syscall+0x18>
    asm volatile (
        "int %1;"
        : "=a" (ret)
        : "i" (T_SYSCALL),
          "a" (num),
          "d" (a[0]),
  8000ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
          "c" (a[1]),
  8000ed:	8b 4d d8             	mov    -0x28(%ebp),%ecx
          "b" (a[2]),
  8000f0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
          "D" (a[3]),
  8000f3:	8b 7d e0             	mov    -0x20(%ebp),%edi
          "S" (a[4])
  8000f6:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    asm volatile (
  8000f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8000fc:	cd 80                	int    $0x80
  8000fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "cc", "memory");
    return ret;
  800101:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	5b                   	pop    %ebx
  800108:	5e                   	pop    %esi
  800109:	5f                   	pop    %edi
  80010a:	5d                   	pop    %ebp
  80010b:	c3                   	ret    

0080010c <sys_exit>:

int
sys_exit(int error_code) {
  80010c:	55                   	push   %ebp
  80010d:	89 e5                	mov    %esp,%ebp
  80010f:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_exit, error_code);
  800112:	8b 45 08             	mov    0x8(%ebp),%eax
  800115:	89 44 24 04          	mov    %eax,0x4(%esp)
  800119:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800120:	e8 91 ff ff ff       	call   8000b6 <syscall>
}
  800125:	c9                   	leave  
  800126:	c3                   	ret    

00800127 <sys_fork>:

int
sys_fork(void) {
  800127:	55                   	push   %ebp
  800128:	89 e5                	mov    %esp,%ebp
  80012a:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_fork);
  80012d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800134:	e8 7d ff ff ff       	call   8000b6 <syscall>
}
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <sys_wait>:

int
sys_wait(int pid, int *store) {
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_wait, pid, store);
  800141:	8b 45 0c             	mov    0xc(%ebp),%eax
  800144:	89 44 24 08          	mov    %eax,0x8(%esp)
  800148:	8b 45 08             	mov    0x8(%ebp),%eax
  80014b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014f:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  800156:	e8 5b ff ff ff       	call   8000b6 <syscall>
}
  80015b:	c9                   	leave  
  80015c:	c3                   	ret    

0080015d <sys_yield>:

int
sys_yield(void) {
  80015d:	55                   	push   %ebp
  80015e:	89 e5                	mov    %esp,%ebp
  800160:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_yield);
  800163:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80016a:	e8 47 ff ff ff       	call   8000b6 <syscall>
}
  80016f:	c9                   	leave  
  800170:	c3                   	ret    

00800171 <sys_kill>:

int
sys_kill(int pid) {
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_kill, pid);
  800177:	8b 45 08             	mov    0x8(%ebp),%eax
  80017a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017e:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  800185:	e8 2c ff ff ff       	call   8000b6 <syscall>
}
  80018a:	c9                   	leave  
  80018b:	c3                   	ret    

0080018c <sys_getpid>:

int
sys_getpid(void) {
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_getpid);
  800192:	c7 04 24 12 00 00 00 	movl   $0x12,(%esp)
  800199:	e8 18 ff ff ff       	call   8000b6 <syscall>
}
  80019e:	c9                   	leave  
  80019f:	c3                   	ret    

008001a0 <sys_putc>:

int
sys_putc(int c) {
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_putc, c);
  8001a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ad:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
  8001b4:	e8 fd fe ff ff       	call   8000b6 <syscall>
}
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <sys_pgdir>:

int
sys_pgdir(void) {
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_pgdir);
  8001c1:	c7 04 24 1f 00 00 00 	movl   $0x1f,(%esp)
  8001c8:	e8 e9 fe ff ff       	call   8000b6 <syscall>
}
  8001cd:	c9                   	leave  
  8001ce:	c3                   	ret    

008001cf <sys_lab6_set_priority>:

void
sys_lab6_set_priority(uint32_t priority)
{
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	83 ec 08             	sub    $0x8,%esp
    syscall(SYS_lab6_set_priority, priority);
  8001d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001dc:	c7 04 24 ff 00 00 00 	movl   $0xff,(%esp)
  8001e3:	e8 ce fe ff ff       	call   8000b6 <syscall>
}
  8001e8:	c9                   	leave  
  8001e9:	c3                   	ret    

008001ea <sys_sleep>:

int
sys_sleep(unsigned int time) {
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_sleep, time);
  8001f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f7:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  8001fe:	e8 b3 fe ff ff       	call   8000b6 <syscall>
}
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <sys_gettime>:

size_t
sys_gettime(void) {
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_gettime);
  80020b:	c7 04 24 11 00 00 00 	movl   $0x11,(%esp)
  800212:	e8 9f fe ff ff       	call   8000b6 <syscall>
}
  800217:	c9                   	leave  
  800218:	c3                   	ret    

00800219 <sys_exec>:

int
sys_exec(const char *name, int argc, const char **argv) {
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	83 ec 10             	sub    $0x10,%esp
    return syscall(SYS_exec, name, argc, argv);
  80021f:	8b 45 10             	mov    0x10(%ebp),%eax
  800222:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800226:	8b 45 0c             	mov    0xc(%ebp),%eax
  800229:	89 44 24 08          	mov    %eax,0x8(%esp)
  80022d:	8b 45 08             	mov    0x8(%ebp),%eax
  800230:	89 44 24 04          	mov    %eax,0x4(%esp)
  800234:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  80023b:	e8 76 fe ff ff       	call   8000b6 <syscall>
}
  800240:	c9                   	leave  
  800241:	c3                   	ret    

00800242 <sys_open>:

int
sys_open(const char *path, uint32_t open_flags) {
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_open, path, open_flags);
  800248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80024f:	8b 45 08             	mov    0x8(%ebp),%eax
  800252:	89 44 24 04          	mov    %eax,0x4(%esp)
  800256:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  80025d:	e8 54 fe ff ff       	call   8000b6 <syscall>
}
  800262:	c9                   	leave  
  800263:	c3                   	ret    

00800264 <sys_close>:

int
sys_close(int fd) {
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_close, fd);
  80026a:	8b 45 08             	mov    0x8(%ebp),%eax
  80026d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800271:	c7 04 24 65 00 00 00 	movl   $0x65,(%esp)
  800278:	e8 39 fe ff ff       	call   8000b6 <syscall>
}
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <sys_read>:

int
sys_read(int fd, void *base, size_t len) {
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 10             	sub    $0x10,%esp
    return syscall(SYS_read, fd, base, len);
  800285:	8b 45 10             	mov    0x10(%ebp),%eax
  800288:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80028c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800293:	8b 45 08             	mov    0x8(%ebp),%eax
  800296:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029a:	c7 04 24 66 00 00 00 	movl   $0x66,(%esp)
  8002a1:	e8 10 fe ff ff       	call   8000b6 <syscall>
}
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <sys_write>:

int
sys_write(int fd, void *base, size_t len) {
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 10             	sub    $0x10,%esp
    return syscall(SYS_write, fd, base, len);
  8002ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c3:	c7 04 24 67 00 00 00 	movl   $0x67,(%esp)
  8002ca:	e8 e7 fd ff ff       	call   8000b6 <syscall>
}
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <sys_seek>:

int
sys_seek(int fd, off_t pos, int whence) {
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 10             	sub    $0x10,%esp
    return syscall(SYS_seek, fd, pos, whence);
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ec:	c7 04 24 68 00 00 00 	movl   $0x68,(%esp)
  8002f3:	e8 be fd ff ff       	call   8000b6 <syscall>
}
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    

008002fa <sys_fstat>:

int
sys_fstat(int fd, struct stat *stat) {
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_fstat, fd, stat);
  800300:	8b 45 0c             	mov    0xc(%ebp),%eax
  800303:	89 44 24 08          	mov    %eax,0x8(%esp)
  800307:	8b 45 08             	mov    0x8(%ebp),%eax
  80030a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80030e:	c7 04 24 6e 00 00 00 	movl   $0x6e,(%esp)
  800315:	e8 9c fd ff ff       	call   8000b6 <syscall>
}
  80031a:	c9                   	leave  
  80031b:	c3                   	ret    

0080031c <sys_fsync>:

int
sys_fsync(int fd) {
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_fsync, fd);
  800322:	8b 45 08             	mov    0x8(%ebp),%eax
  800325:	89 44 24 04          	mov    %eax,0x4(%esp)
  800329:	c7 04 24 6f 00 00 00 	movl   $0x6f,(%esp)
  800330:	e8 81 fd ff ff       	call   8000b6 <syscall>
}
  800335:	c9                   	leave  
  800336:	c3                   	ret    

00800337 <sys_getcwd>:

int
sys_getcwd(char *buffer, size_t len) {
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_getcwd, buffer, len);
  80033d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800340:	89 44 24 08          	mov    %eax,0x8(%esp)
  800344:	8b 45 08             	mov    0x8(%ebp),%eax
  800347:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034b:	c7 04 24 79 00 00 00 	movl   $0x79,(%esp)
  800352:	e8 5f fd ff ff       	call   8000b6 <syscall>
}
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <sys_getdirentry>:

int
sys_getdirentry(int fd, struct dirent *dirent) {
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_getdirentry, fd, dirent);
  80035f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800362:	89 44 24 08          	mov    %eax,0x8(%esp)
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036d:	c7 04 24 80 00 00 00 	movl   $0x80,(%esp)
  800374:	e8 3d fd ff ff       	call   8000b6 <syscall>
}
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <sys_dup>:

int
sys_dup(int fd1, int fd2) {
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_dup, fd1, fd2);
  800381:	8b 45 0c             	mov    0xc(%ebp),%eax
  800384:	89 44 24 08          	mov    %eax,0x8(%esp)
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038f:	c7 04 24 82 00 00 00 	movl   $0x82,(%esp)
  800396:	e8 1b fd ff ff       	call   8000b6 <syscall>
}
  80039b:	c9                   	leave  
  80039c:	c3                   	ret    

0080039d <try_lock>:
lock_init(lock_t *l) {
    *l = 0;
}

static inline bool
try_lock(lock_t *l) {
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 10             	sub    $0x10,%esp
  8003a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_and_set_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btsl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
  8003b0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8003b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b6:	0f ab 02             	bts    %eax,(%edx)
  8003b9:	19 c0                	sbb    %eax,%eax
  8003bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return oldbit != 0;
  8003be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8003c2:	0f 95 c0             	setne  %al
  8003c5:	0f b6 c0             	movzbl %al,%eax
    return test_and_set_bit(0, l);
}
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    

008003ca <lock>:

static inline void
lock(lock_t *l) {
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	83 ec 28             	sub    $0x28,%esp
    if (try_lock(l)) {
  8003d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d3:	89 04 24             	mov    %eax,(%esp)
  8003d6:	e8 c2 ff ff ff       	call   80039d <try_lock>
  8003db:	85 c0                	test   %eax,%eax
  8003dd:	74 38                	je     800417 <lock+0x4d>
        int step = 0;
  8003df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        do {
            yield();
  8003e6:	e8 df 00 00 00       	call   8004ca <yield>
            if (++ step == 100) {
  8003eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8003ef:	83 7d f4 64          	cmpl   $0x64,-0xc(%ebp)
  8003f3:	75 13                	jne    800408 <lock+0x3e>
                step = 0;
  8003f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
                sleep(10);
  8003fc:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800403:	e8 0f 01 00 00       	call   800517 <sleep>
            }
        } while (try_lock(l));
  800408:	8b 45 08             	mov    0x8(%ebp),%eax
  80040b:	89 04 24             	mov    %eax,(%esp)
  80040e:	e8 8a ff ff ff       	call   80039d <try_lock>
  800413:	85 c0                	test   %eax,%eax
  800415:	75 cf                	jne    8003e6 <lock+0x1c>
    }
}
  800417:	c9                   	leave  
  800418:	c3                   	ret    

00800419 <unlock>:

static inline void
unlock(lock_t *l) {
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 10             	sub    $0x10,%esp
  80041f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	89 45 f8             	mov    %eax,-0x8(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_and_clear_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btrl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
  80042c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80042f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800432:	0f b3 02             	btr    %eax,(%edx)
  800435:	19 c0                	sbb    %eax,%eax
  800437:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return oldbit != 0;
  80043a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    test_and_clear_bit(0, l);
}
  80043e:	c9                   	leave  
  80043f:	c3                   	ret    

00800440 <lock_fork>:
#include <lock.h>

static lock_t fork_lock = INIT_LOCK;

void
lock_fork(void) {
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	83 ec 18             	sub    $0x18,%esp
    lock(&fork_lock);
  800446:	c7 04 24 20 20 80 00 	movl   $0x802020,(%esp)
  80044d:	e8 78 ff ff ff       	call   8003ca <lock>
}
  800452:	c9                   	leave  
  800453:	c3                   	ret    

00800454 <unlock_fork>:

void
unlock_fork(void) {
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	83 ec 04             	sub    $0x4,%esp
    unlock(&fork_lock);
  80045a:	c7 04 24 20 20 80 00 	movl   $0x802020,(%esp)
  800461:	e8 b3 ff ff ff       	call   800419 <unlock>
}
  800466:	c9                   	leave  
  800467:	c3                   	ret    

00800468 <exit>:

void
exit(int error_code) {
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
  80046b:	83 ec 18             	sub    $0x18,%esp
    sys_exit(error_code);
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	89 04 24             	mov    %eax,(%esp)
  800474:	e8 93 fc ff ff       	call   80010c <sys_exit>
    cprintf("BUG: exit failed.\n");
  800479:	c7 04 24 38 18 80 00 	movl   $0x801838,(%esp)
  800480:	e8 44 03 00 00       	call   8007c9 <cprintf>
    while (1);
  800485:	eb fe                	jmp    800485 <exit+0x1d>

00800487 <fork>:
}

int
fork(void) {
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 08             	sub    $0x8,%esp
    return sys_fork();
  80048d:	e8 95 fc ff ff       	call   800127 <sys_fork>
}
  800492:	c9                   	leave  
  800493:	c3                   	ret    

00800494 <wait>:

int
wait(void) {
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(0, NULL);
  80049a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004a1:	00 
  8004a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004a9:	e8 8d fc ff ff       	call   80013b <sys_wait>
}
  8004ae:	c9                   	leave  
  8004af:	c3                   	ret    

008004b0 <waitpid>:

int
waitpid(int pid, int *store) {
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(pid, store);
  8004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	89 04 24             	mov    %eax,(%esp)
  8004c3:	e8 73 fc ff ff       	call   80013b <sys_wait>
}
  8004c8:	c9                   	leave  
  8004c9:	c3                   	ret    

008004ca <yield>:

void
yield(void) {
  8004ca:	55                   	push   %ebp
  8004cb:	89 e5                	mov    %esp,%ebp
  8004cd:	83 ec 08             	sub    $0x8,%esp
    sys_yield();
  8004d0:	e8 88 fc ff ff       	call   80015d <sys_yield>
}
  8004d5:	c9                   	leave  
  8004d6:	c3                   	ret    

008004d7 <kill>:

int
kill(int pid) {
  8004d7:	55                   	push   %ebp
  8004d8:	89 e5                	mov    %esp,%ebp
  8004da:	83 ec 18             	sub    $0x18,%esp
    return sys_kill(pid);
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	89 04 24             	mov    %eax,(%esp)
  8004e3:	e8 89 fc ff ff       	call   800171 <sys_kill>
}
  8004e8:	c9                   	leave  
  8004e9:	c3                   	ret    

008004ea <getpid>:

int
getpid(void) {
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	83 ec 08             	sub    $0x8,%esp
    return sys_getpid();
  8004f0:	e8 97 fc ff ff       	call   80018c <sys_getpid>
}
  8004f5:	c9                   	leave  
  8004f6:	c3                   	ret    

008004f7 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
  8004fa:	83 ec 08             	sub    $0x8,%esp
    sys_pgdir();
  8004fd:	e8 b9 fc ff ff       	call   8001bb <sys_pgdir>
}
  800502:	c9                   	leave  
  800503:	c3                   	ret    

00800504 <lab6_set_priority>:

void
lab6_set_priority(uint32_t priority)
{
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
  800507:	83 ec 18             	sub    $0x18,%esp
    sys_lab6_set_priority(priority);
  80050a:	8b 45 08             	mov    0x8(%ebp),%eax
  80050d:	89 04 24             	mov    %eax,(%esp)
  800510:	e8 ba fc ff ff       	call   8001cf <sys_lab6_set_priority>
}
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <sleep>:

int
sleep(unsigned int time) {
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	83 ec 18             	sub    $0x18,%esp
    return sys_sleep(time);
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	89 04 24             	mov    %eax,(%esp)
  800523:	e8 c2 fc ff ff       	call   8001ea <sys_sleep>
}
  800528:	c9                   	leave  
  800529:	c3                   	ret    

0080052a <gettime_msec>:

unsigned int
gettime_msec(void) {
  80052a:	55                   	push   %ebp
  80052b:	89 e5                	mov    %esp,%ebp
  80052d:	83 ec 08             	sub    $0x8,%esp
    return (unsigned int)sys_gettime();
  800530:	e8 d0 fc ff ff       	call   800205 <sys_gettime>
}
  800535:	c9                   	leave  
  800536:	c3                   	ret    

00800537 <__exec>:

int
__exec(const char *name, const char **argv) {
  800537:	55                   	push   %ebp
  800538:	89 e5                	mov    %esp,%ebp
  80053a:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  80053d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (argv[argc] != NULL) {
  800544:	eb 04                	jmp    80054a <__exec+0x13>
        argc ++;
  800546:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while (argv[argc] != NULL) {
  80054a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80054d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	01 d0                	add    %edx,%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	85 c0                	test   %eax,%eax
  80055d:	75 e7                	jne    800546 <__exec+0xf>
    }
    return sys_exec(name, argc, argv);
  80055f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800562:	89 44 24 08          	mov    %eax,0x8(%esp)
  800566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800569:	89 44 24 04          	mov    %eax,0x4(%esp)
  80056d:	8b 45 08             	mov    0x8(%ebp),%eax
  800570:	89 04 24             	mov    %eax,(%esp)
  800573:	e8 a1 fc ff ff       	call   800219 <sys_exec>
}
  800578:	c9                   	leave  
  800579:	c3                   	ret    

0080057a <_start>:
.text
.globl _start
_start:
    # set ebp for backtrace
    movl $0x0, %ebp
  80057a:	bd 00 00 00 00       	mov    $0x0,%ebp

    # load argc and argv
    movl (%esp), %ebx
  80057f:	8b 1c 24             	mov    (%esp),%ebx
    lea 0x4(%esp), %ecx
  800582:	8d 4c 24 04          	lea    0x4(%esp),%ecx


    # move down the esp register
    # since it may cause page fault in backtrace
    subl $0x20, %esp
  800586:	83 ec 20             	sub    $0x20,%esp

    # save argc and argv on stack
    pushl %ecx
  800589:	51                   	push   %ecx
    pushl %ebx
  80058a:	53                   	push   %ebx

    # call user-program function
    call umain
  80058b:	e8 80 04 00 00       	call   800a10 <umain>
1:  jmp 1b
  800590:	eb fe                	jmp    800590 <_start+0x16>

00800592 <open>:
#include <stat.h>
#include <error.h>
#include <unistd.h>

int
open(const char *path, uint32_t open_flags) {
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 18             	sub    $0x18,%esp
    return sys_open(path, open_flags);
  800598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80059f:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a2:	89 04 24             	mov    %eax,(%esp)
  8005a5:	e8 98 fc ff ff       	call   800242 <sys_open>
}
  8005aa:	c9                   	leave  
  8005ab:	c3                   	ret    

008005ac <close>:

int
close(int fd) {
  8005ac:	55                   	push   %ebp
  8005ad:	89 e5                	mov    %esp,%ebp
  8005af:	83 ec 18             	sub    $0x18,%esp
    return sys_close(fd);
  8005b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b5:	89 04 24             	mov    %eax,(%esp)
  8005b8:	e8 a7 fc ff ff       	call   800264 <sys_close>
}
  8005bd:	c9                   	leave  
  8005be:	c3                   	ret    

008005bf <read>:

int
read(int fd, void *base, size_t len) {
  8005bf:	55                   	push   %ebp
  8005c0:	89 e5                	mov    %esp,%ebp
  8005c2:	83 ec 18             	sub    $0x18,%esp
    return sys_read(fd, base, len);
  8005c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d6:	89 04 24             	mov    %eax,(%esp)
  8005d9:	e8 a1 fc ff ff       	call   80027f <sys_read>
}
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <write>:

int
write(int fd, void *base, size_t len) {
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
  8005e3:	83 ec 18             	sub    $0x18,%esp
    return sys_write(fd, base, len);
  8005e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	89 04 24             	mov    %eax,(%esp)
  8005fa:	e8 a9 fc ff ff       	call   8002a8 <sys_write>
}
  8005ff:	c9                   	leave  
  800600:	c3                   	ret    

00800601 <seek>:

int
seek(int fd, off_t pos, int whence) {
  800601:	55                   	push   %ebp
  800602:	89 e5                	mov    %esp,%ebp
  800604:	83 ec 18             	sub    $0x18,%esp
    return sys_seek(fd, pos, whence);
  800607:	8b 45 10             	mov    0x10(%ebp),%eax
  80060a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80060e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800611:	89 44 24 04          	mov    %eax,0x4(%esp)
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	89 04 24             	mov    %eax,(%esp)
  80061b:	e8 b1 fc ff ff       	call   8002d1 <sys_seek>
}
  800620:	c9                   	leave  
  800621:	c3                   	ret    

00800622 <fstat>:

int
fstat(int fd, struct stat *stat) {
  800622:	55                   	push   %ebp
  800623:	89 e5                	mov    %esp,%ebp
  800625:	83 ec 18             	sub    $0x18,%esp
    return sys_fstat(fd, stat);
  800628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	89 04 24             	mov    %eax,(%esp)
  800635:	e8 c0 fc ff ff       	call   8002fa <sys_fstat>
}
  80063a:	c9                   	leave  
  80063b:	c3                   	ret    

0080063c <fsync>:

int
fsync(int fd) {
  80063c:	55                   	push   %ebp
  80063d:	89 e5                	mov    %esp,%ebp
  80063f:	83 ec 18             	sub    $0x18,%esp
    return sys_fsync(fd);
  800642:	8b 45 08             	mov    0x8(%ebp),%eax
  800645:	89 04 24             	mov    %eax,(%esp)
  800648:	e8 cf fc ff ff       	call   80031c <sys_fsync>
}
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    

0080064f <dup2>:

int
dup2(int fd1, int fd2) {
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	83 ec 18             	sub    $0x18,%esp
    return sys_dup(fd1, fd2);
  800655:	8b 45 0c             	mov    0xc(%ebp),%eax
  800658:	89 44 24 04          	mov    %eax,0x4(%esp)
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	89 04 24             	mov    %eax,(%esp)
  800662:	e8 14 fd ff ff       	call   80037b <sys_dup>
}
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <transmode>:

static char
transmode(struct stat *stat) {
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
  80066c:	83 ec 10             	sub    $0x10,%esp
    uint32_t mode = stat->st_mode;
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (S_ISREG(mode)) return 'r';
  800677:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80067a:	25 00 70 00 00       	and    $0x7000,%eax
  80067f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800684:	75 07                	jne    80068d <transmode+0x24>
  800686:	b8 72 00 00 00       	mov    $0x72,%eax
  80068b:	eb 5d                	jmp    8006ea <transmode+0x81>
    if (S_ISDIR(mode)) return 'd';
  80068d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800690:	25 00 70 00 00       	and    $0x7000,%eax
  800695:	3d 00 20 00 00       	cmp    $0x2000,%eax
  80069a:	75 07                	jne    8006a3 <transmode+0x3a>
  80069c:	b8 64 00 00 00       	mov    $0x64,%eax
  8006a1:	eb 47                	jmp    8006ea <transmode+0x81>
    if (S_ISLNK(mode)) return 'l';
  8006a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a6:	25 00 70 00 00       	and    $0x7000,%eax
  8006ab:	3d 00 30 00 00       	cmp    $0x3000,%eax
  8006b0:	75 07                	jne    8006b9 <transmode+0x50>
  8006b2:	b8 6c 00 00 00       	mov    $0x6c,%eax
  8006b7:	eb 31                	jmp    8006ea <transmode+0x81>
    if (S_ISCHR(mode)) return 'c';
  8006b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006bc:	25 00 70 00 00       	and    $0x7000,%eax
  8006c1:	3d 00 40 00 00       	cmp    $0x4000,%eax
  8006c6:	75 07                	jne    8006cf <transmode+0x66>
  8006c8:	b8 63 00 00 00       	mov    $0x63,%eax
  8006cd:	eb 1b                	jmp    8006ea <transmode+0x81>
    if (S_ISBLK(mode)) return 'b';
  8006cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d2:	25 00 70 00 00       	and    $0x7000,%eax
  8006d7:	3d 00 50 00 00       	cmp    $0x5000,%eax
  8006dc:	75 07                	jne    8006e5 <transmode+0x7c>
  8006de:	b8 62 00 00 00       	mov    $0x62,%eax
  8006e3:	eb 05                	jmp    8006ea <transmode+0x81>
    return '-';
  8006e5:	b8 2d 00 00 00       	mov    $0x2d,%eax
}
  8006ea:	c9                   	leave  
  8006eb:	c3                   	ret    

008006ec <print_stat>:

void
print_stat(const char *name, int fd, struct stat *stat) {
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
  8006ef:	83 ec 18             	sub    $0x18,%esp
    cprintf("[%03d] %s\n", fd, name);
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800700:	c7 04 24 4b 18 80 00 	movl   $0x80184b,(%esp)
  800707:	e8 bd 00 00 00       	call   8007c9 <cprintf>
    cprintf("    mode    : %c\n", transmode(stat));
  80070c:	8b 45 10             	mov    0x10(%ebp),%eax
  80070f:	89 04 24             	mov    %eax,(%esp)
  800712:	e8 52 ff ff ff       	call   800669 <transmode>
  800717:	0f be c0             	movsbl %al,%eax
  80071a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071e:	c7 04 24 56 18 80 00 	movl   $0x801856,(%esp)
  800725:	e8 9f 00 00 00       	call   8007c9 <cprintf>
    cprintf("    links   : %lu\n", stat->st_nlinks);
  80072a:	8b 45 10             	mov    0x10(%ebp),%eax
  80072d:	8b 40 04             	mov    0x4(%eax),%eax
  800730:	89 44 24 04          	mov    %eax,0x4(%esp)
  800734:	c7 04 24 68 18 80 00 	movl   $0x801868,(%esp)
  80073b:	e8 89 00 00 00       	call   8007c9 <cprintf>
    cprintf("    blocks  : %lu\n", stat->st_blocks);
  800740:	8b 45 10             	mov    0x10(%ebp),%eax
  800743:	8b 40 08             	mov    0x8(%eax),%eax
  800746:	89 44 24 04          	mov    %eax,0x4(%esp)
  80074a:	c7 04 24 7b 18 80 00 	movl   $0x80187b,(%esp)
  800751:	e8 73 00 00 00       	call   8007c9 <cprintf>
    cprintf("    size    : %lu\n", stat->st_size);
  800756:	8b 45 10             	mov    0x10(%ebp),%eax
  800759:	8b 40 0c             	mov    0xc(%eax),%eax
  80075c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800760:	c7 04 24 8e 18 80 00 	movl   $0x80188e,(%esp)
  800767:	e8 5d 00 00 00       	call   8007c9 <cprintf>
}
  80076c:	c9                   	leave  
  80076d:	c3                   	ret    

0080076e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  80076e:	55                   	push   %ebp
  80076f:	89 e5                	mov    %esp,%ebp
  800771:	83 ec 18             	sub    $0x18,%esp
    sys_putc(c);
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	89 04 24             	mov    %eax,(%esp)
  80077a:	e8 21 fa ff ff       	call   8001a0 <sys_putc>
    (*cnt) ++;
  80077f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 01             	lea    0x1(%eax),%edx
  800787:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
}
  80078c:	c9                   	leave  
  80078d:	c3                   	ret    

0080078e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  80078e:	55                   	push   %ebp
  80078f:	89 e5                	mov    %esp,%ebp
  800791:	83 ec 38             	sub    $0x38,%esp
    int cnt = 0;
  800794:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, NO_FD, &cnt, fmt, ap);
  80079b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079e:	89 44 24 10          	mov    %eax,0x10(%esp)
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007b0:	c7 44 24 04 d9 6a ff 	movl   $0xffff6ad9,0x4(%esp)
  8007b7:	ff 
  8007b8:	c7 04 24 6e 07 80 00 	movl   $0x80076e,(%esp)
  8007bf:	e8 c6 09 00 00       	call   80118a <vprintfmt>
    return cnt;
  8007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  8007cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int cnt = vcprintf(fmt, ap);
  8007d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	89 04 24             	mov    %eax,(%esp)
  8007e2:	e8 a7 ff ff ff       	call   80078e <vcprintf>
  8007e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);

    return cnt;
  8007ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007ed:	c9                   	leave  
  8007ee:	c3                   	ret    

008007ef <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  8007f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  8007fc:	eb 13                	jmp    800811 <cputs+0x22>
        cputch(c, &cnt);
  8007fe:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800802:	8d 55 f0             	lea    -0x10(%ebp),%edx
  800805:	89 54 24 04          	mov    %edx,0x4(%esp)
  800809:	89 04 24             	mov    %eax,(%esp)
  80080c:	e8 5d ff ff ff       	call   80076e <cputch>
    while ((c = *str ++) != '\0') {
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8d 50 01             	lea    0x1(%eax),%edx
  800817:	89 55 08             	mov    %edx,0x8(%ebp)
  80081a:	0f b6 00             	movzbl (%eax),%eax
  80081d:	88 45 f7             	mov    %al,-0x9(%ebp)
  800820:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800824:	75 d8                	jne    8007fe <cputs+0xf>
    }
    cputch('\n', &cnt);
  800826:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800829:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082d:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800834:	e8 35 ff ff ff       	call   80076e <cputch>
    return cnt;
  800839:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80083c:	c9                   	leave  
  80083d:	c3                   	ret    

0080083e <fputch>:


static void
fputch(char c, int *cnt, int fd) {
  80083e:	55                   	push   %ebp
  80083f:	89 e5                	mov    %esp,%ebp
  800841:	83 ec 18             	sub    $0x18,%esp
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	88 45 f4             	mov    %al,-0xc(%ebp)
    write(fd, &c, sizeof(char));
  80084a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800851:	00 
  800852:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800855:	89 44 24 04          	mov    %eax,0x4(%esp)
  800859:	8b 45 10             	mov    0x10(%ebp),%eax
  80085c:	89 04 24             	mov    %eax,(%esp)
  80085f:	e8 7c fd ff ff       	call   8005e0 <write>
    (*cnt) ++;
  800864:	8b 45 0c             	mov    0xc(%ebp),%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	8d 50 01             	lea    0x1(%eax),%edx
  80086c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086f:	89 10                	mov    %edx,(%eax)
}
  800871:	c9                   	leave  
  800872:	c3                   	ret    

00800873 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	83 ec 38             	sub    $0x38,%esp
    int cnt = 0;
  800879:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)fputch, fd, &cnt, fmt, ap);
  800880:	8b 45 10             	mov    0x10(%ebp),%eax
  800883:	89 44 24 10          	mov    %eax,0x10(%esp)
  800887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80088e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800891:	89 44 24 08          	mov    %eax,0x8(%esp)
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	89 44 24 04          	mov    %eax,0x4(%esp)
  80089c:	c7 04 24 3e 08 80 00 	movl   $0x80083e,(%esp)
  8008a3:	e8 e2 08 00 00       	call   80118a <vprintfmt>
    return cnt;
  8008a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008ab:	c9                   	leave  
  8008ac:	c3                   	ret    

008008ad <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  8008b3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int cnt = vfprintf(fd, fmt, ap);
  8008b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	89 04 24             	mov    %eax,(%esp)
  8008cd:	e8 a1 ff ff ff       	call   800873 <vfprintf>
  8008d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);

    return cnt;
  8008d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008d8:	c9                   	leave  
  8008d9:	c3                   	ret    

008008da <opendir>:
#include <error.h>
#include <unistd.h>

DIR dir, *dirp=&dir;
DIR *
opendir(const char *path) {
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	53                   	push   %ebx
  8008de:	83 ec 34             	sub    $0x34,%esp

    if ((dirp->fd = open(path, O_RDONLY)) < 0) {
  8008e1:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  8008e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8008ee:	00 
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	89 04 24             	mov    %eax,(%esp)
  8008f5:	e8 98 fc ff ff       	call   800592 <open>
  8008fa:	89 03                	mov    %eax,(%ebx)
  8008fc:	8b 03                	mov    (%ebx),%eax
  8008fe:	85 c0                	test   %eax,%eax
  800900:	79 02                	jns    800904 <opendir+0x2a>
        goto failed;
  800902:	eb 44                	jmp    800948 <opendir+0x6e>
    }
    struct stat __stat, *stat = &__stat;
  800904:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800907:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (fstat(dirp->fd, stat) != 0 || !S_ISDIR(stat->st_mode)) {
  80090a:	a1 00 20 80 00       	mov    0x802000,%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800914:	89 54 24 04          	mov    %edx,0x4(%esp)
  800918:	89 04 24             	mov    %eax,(%esp)
  80091b:	e8 02 fd ff ff       	call   800622 <fstat>
  800920:	85 c0                	test   %eax,%eax
  800922:	75 24                	jne    800948 <opendir+0x6e>
  800924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	25 00 70 00 00       	and    $0x7000,%eax
  80092e:	3d 00 20 00 00       	cmp    $0x2000,%eax
  800933:	75 13                	jne    800948 <opendir+0x6e>
        goto failed;
    }
    dirp->dirent.offset = 0;
  800935:	a1 00 20 80 00       	mov    0x802000,%eax
  80093a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    return dirp;
  800941:	a1 00 20 80 00       	mov    0x802000,%eax
  800946:	eb 05                	jmp    80094d <opendir+0x73>

failed:
    return NULL;
  800948:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80094d:	83 c4 34             	add    $0x34,%esp
  800950:	5b                   	pop    %ebx
  800951:	5d                   	pop    %ebp
  800952:	c3                   	ret    

00800953 <readdir>:

struct dirent *
readdir(DIR *dirp) {
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	83 ec 18             	sub    $0x18,%esp
    if (sys_getdirentry(dirp->fd, &(dirp->dirent)) == 0) {
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8d 50 04             	lea    0x4(%eax),%edx
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 00                	mov    (%eax),%eax
  800964:	89 54 24 04          	mov    %edx,0x4(%esp)
  800968:	89 04 24             	mov    %eax,(%esp)
  80096b:	e8 e9 f9 ff ff       	call   800359 <sys_getdirentry>
  800970:	85 c0                	test   %eax,%eax
  800972:	75 08                	jne    80097c <readdir+0x29>
        return &(dirp->dirent);
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	83 c0 04             	add    $0x4,%eax
  80097a:	eb 05                	jmp    800981 <readdir+0x2e>
    }
    return NULL;
  80097c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <closedir>:

void
closedir(DIR *dirp) {
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 18             	sub    $0x18,%esp
    close(dirp->fd);
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 00                	mov    (%eax),%eax
  80098e:	89 04 24             	mov    %eax,(%esp)
  800991:	e8 16 fc ff ff       	call   8005ac <close>
}
  800996:	c9                   	leave  
  800997:	c3                   	ret    

00800998 <getcwd>:

int
getcwd(char *buffer, size_t len) {
  800998:	55                   	push   %ebp
  800999:	89 e5                	mov    %esp,%ebp
  80099b:	83 ec 18             	sub    $0x18,%esp
    return sys_getcwd(buffer, len);
  80099e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	89 04 24             	mov    %eax,(%esp)
  8009ab:	e8 87 f9 ff ff       	call   800337 <sys_getcwd>
}
  8009b0:	c9                   	leave  
  8009b1:	c3                   	ret    

008009b2 <initfd>:
#include <stat.h>

int main(int argc, char *argv[]);

static int
initfd(int fd2, const char *path, uint32_t open_flags) {
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	83 ec 28             	sub    $0x28,%esp
    int fd1, ret;
    if ((fd1 = open(path, open_flags)) < 0) {
  8009b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	89 04 24             	mov    %eax,(%esp)
  8009c5:	e8 c8 fb ff ff       	call   800592 <open>
  8009ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009d1:	79 05                	jns    8009d8 <initfd+0x26>
        return fd1;
  8009d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d6:	eb 36                	jmp    800a0e <initfd+0x5c>
    }
    if (fd1 != fd2) {
  8009d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8009de:	74 2b                	je     800a0b <initfd+0x59>
        close(fd2);
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	89 04 24             	mov    %eax,(%esp)
  8009e6:	e8 c1 fb ff ff       	call   8005ac <close>
        ret = dup2(fd1, fd2);
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f5:	89 04 24             	mov    %eax,(%esp)
  8009f8:	e8 52 fc ff ff       	call   80064f <dup2>
  8009fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        close(fd1);
  800a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a03:	89 04 24             	mov    %eax,(%esp)
  800a06:	e8 a1 fb ff ff       	call   8005ac <close>
    }
    return ret;
  800a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a0e:	c9                   	leave  
  800a0f:	c3                   	ret    

00800a10 <umain>:

void
umain(int argc, char *argv[]) {
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	83 ec 28             	sub    $0x28,%esp
    int fd;
    if ((fd = initfd(0, "stdin:", O_RDONLY)) < 0) {
  800a16:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800a1d:	00 
  800a1e:	c7 44 24 04 a1 18 80 	movl   $0x8018a1,0x4(%esp)
  800a25:	00 
  800a26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a2d:	e8 80 ff ff ff       	call   8009b2 <initfd>
  800a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a39:	79 23                	jns    800a5e <umain+0x4e>
        warn("open <stdin> failed: %e.\n", fd);
  800a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a42:	c7 44 24 08 a8 18 80 	movl   $0x8018a8,0x8(%esp)
  800a49:	00 
  800a4a:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800a51:	00 
  800a52:	c7 04 24 c2 18 80 00 	movl   $0x8018c2,(%esp)
  800a59:	e8 12 f6 ff ff       	call   800070 <__warn>
    }
    if ((fd = initfd(1, "stdout:", O_WRONLY)) < 0) {
  800a5e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800a65:	00 
  800a66:	c7 44 24 04 d4 18 80 	movl   $0x8018d4,0x4(%esp)
  800a6d:	00 
  800a6e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a75:	e8 38 ff ff ff       	call   8009b2 <initfd>
  800a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a81:	79 23                	jns    800aa6 <umain+0x96>
        warn("open <stdout> failed: %e.\n", fd);
  800a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a86:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a8a:	c7 44 24 08 dc 18 80 	movl   $0x8018dc,0x8(%esp)
  800a91:	00 
  800a92:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  800a99:	00 
  800a9a:	c7 04 24 c2 18 80 00 	movl   $0x8018c2,(%esp)
  800aa1:	e8 ca f5 ff ff       	call   800070 <__warn>
    }
    int ret = main(argc, argv);
  800aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	89 04 24             	mov    %eax,(%esp)
  800ab3:	e8 f1 0c 00 00       	call   8017a9 <main>
  800ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    exit(ret);
  800abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800abe:	89 04 24             	mov    %eax,(%esp)
  800ac1:	e8 a2 f9 ff ff       	call   800468 <exit>

00800ac6 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  800acc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  800ad3:	eb 04                	jmp    800ad9 <strlen+0x13>
        cnt ++;
  800ad5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8d 50 01             	lea    0x1(%eax),%edx
  800adf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ae2:	0f b6 00             	movzbl (%eax),%eax
  800ae5:	84 c0                	test   %al,%al
  800ae7:	75 ec                	jne    800ad5 <strlen+0xf>
    }
    return cnt;
  800ae9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  800af4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  800afb:	eb 04                	jmp    800b01 <strnlen+0x13>
        cnt ++;
  800afd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  800b01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b04:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b07:	73 10                	jae    800b19 <strnlen+0x2b>
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8d 50 01             	lea    0x1(%eax),%edx
  800b0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800b12:	0f b6 00             	movzbl (%eax),%eax
  800b15:	84 c0                	test   %al,%al
  800b17:	75 e4                	jne    800afd <strnlen+0xf>
    }
    return cnt;
  800b19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <strcat>:
 * @dst:    pointer to the @dst array, which should be large enough to contain the concatenated
 *          resulting string.
 * @src:    string to be appended, this should not overlap @dst
 * */
char *
strcat(char *dst, const char *src) {
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 18             	sub    $0x18,%esp
    return strcpy(dst + strlen(dst), src);
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	89 04 24             	mov    %eax,(%esp)
  800b2a:	e8 97 ff ff ff       	call   800ac6 <strlen>
  800b2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b32:	01 c2                	add    %eax,%edx
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b3b:	89 14 24             	mov    %edx,(%esp)
  800b3e:	e8 02 00 00 00       	call   800b45 <strcpy>
}
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	57                   	push   %edi
  800b49:	56                   	push   %esi
  800b4a:	83 ec 20             	sub    $0x20,%esp
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  800b59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b5f:	89 d1                	mov    %edx,%ecx
  800b61:	89 c2                	mov    %eax,%edx
  800b63:	89 ce                	mov    %ecx,%esi
  800b65:	89 d7                	mov    %edx,%edi
  800b67:	ac                   	lods   %ds:(%esi),%al
  800b68:	aa                   	stos   %al,%es:(%edi)
  800b69:	84 c0                	test   %al,%al
  800b6b:	75 fa                	jne    800b67 <strcpy+0x22>
  800b6d:	89 fa                	mov    %edi,%edx
  800b6f:	89 f1                	mov    %esi,%ecx
  800b71:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  800b74:	89 55 e8             	mov    %edx,-0x18(%ebp)
  800b77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  800b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  800b7d:	83 c4 20             	add    $0x20,%esp
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  800b90:	eb 21                	jmp    800bb3 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	0f b6 10             	movzbl (%eax),%edx
  800b98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b9b:	88 10                	mov    %dl,(%eax)
  800b9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba0:	0f b6 00             	movzbl (%eax),%eax
  800ba3:	84 c0                	test   %al,%al
  800ba5:	74 04                	je     800bab <strncpy+0x27>
            src ++;
  800ba7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  800bab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800baf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  800bb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bb7:	75 d9                	jne    800b92 <strncpy+0xe>
    }
    return dst;
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	57                   	push   %edi
  800bc2:	56                   	push   %esi
  800bc3:	83 ec 20             	sub    $0x20,%esp
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  800bd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd8:	89 d1                	mov    %edx,%ecx
  800bda:	89 c2                	mov    %eax,%edx
  800bdc:	89 ce                	mov    %ecx,%esi
  800bde:	89 d7                	mov    %edx,%edi
  800be0:	ac                   	lods   %ds:(%esi),%al
  800be1:	ae                   	scas   %es:(%edi),%al
  800be2:	75 08                	jne    800bec <strcmp+0x2e>
  800be4:	84 c0                	test   %al,%al
  800be6:	75 f8                	jne    800be0 <strcmp+0x22>
  800be8:	31 c0                	xor    %eax,%eax
  800bea:	eb 04                	jmp    800bf0 <strcmp+0x32>
  800bec:	19 c0                	sbb    %eax,%eax
  800bee:	0c 01                	or     $0x1,%al
  800bf0:	89 fa                	mov    %edi,%edx
  800bf2:	89 f1                	mov    %esi,%ecx
  800bf4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  800bfa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  800bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  800c00:	83 c4 20             	add    $0x20,%esp
  800c03:	5e                   	pop    %esi
  800c04:	5f                   	pop    %edi
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800c0a:	eb 0c                	jmp    800c18 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  800c0c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800c10:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c14:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800c18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c1c:	74 1a                	je     800c38 <strncmp+0x31>
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	0f b6 00             	movzbl (%eax),%eax
  800c24:	84 c0                	test   %al,%al
  800c26:	74 10                	je     800c38 <strncmp+0x31>
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	0f b6 10             	movzbl (%eax),%edx
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	0f b6 00             	movzbl (%eax),%eax
  800c34:	38 c2                	cmp    %al,%dl
  800c36:	74 d4                	je     800c0c <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  800c38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c3c:	74 18                	je     800c56 <strncmp+0x4f>
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	0f b6 00             	movzbl (%eax),%eax
  800c44:	0f b6 d0             	movzbl %al,%edx
  800c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4a:	0f b6 00             	movzbl (%eax),%eax
  800c4d:	0f b6 c0             	movzbl %al,%eax
  800c50:	29 c2                	sub    %eax,%edx
  800c52:	89 d0                	mov    %edx,%eax
  800c54:	eb 05                	jmp    800c5b <strncmp+0x54>
  800c56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c5b:	5d                   	pop    %ebp
  800c5c:	c3                   	ret    

00800c5d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  800c5d:	55                   	push   %ebp
  800c5e:	89 e5                	mov    %esp,%ebp
  800c60:	83 ec 04             	sub    $0x4,%esp
  800c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c66:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800c69:	eb 14                	jmp    800c7f <strchr+0x22>
        if (*s == c) {
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	0f b6 00             	movzbl (%eax),%eax
  800c71:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c74:	75 05                	jne    800c7b <strchr+0x1e>
            return (char *)s;
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	eb 13                	jmp    800c8e <strchr+0x31>
        }
        s ++;
  800c7b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	0f b6 00             	movzbl (%eax),%eax
  800c85:	84 c0                	test   %al,%al
  800c87:	75 e2                	jne    800c6b <strchr+0xe>
    }
    return NULL;
  800c89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    

00800c90 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	83 ec 04             	sub    $0x4,%esp
  800c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c99:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800c9c:	eb 11                	jmp    800caf <strfind+0x1f>
        if (*s == c) {
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	0f b6 00             	movzbl (%eax),%eax
  800ca4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ca7:	75 02                	jne    800cab <strfind+0x1b>
            break;
  800ca9:	eb 0e                	jmp    800cb9 <strfind+0x29>
        }
        s ++;
  800cab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	0f b6 00             	movzbl (%eax),%eax
  800cb5:	84 c0                	test   %al,%al
  800cb7:	75 e5                	jne    800c9e <strfind+0xe>
    }
    return (char *)s;
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cbc:	c9                   	leave  
  800cbd:	c3                   	ret    

00800cbe <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  800cc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  800ccb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800cd2:	eb 04                	jmp    800cd8 <strtol+0x1a>
        s ++;
  800cd4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	0f b6 00             	movzbl (%eax),%eax
  800cde:	3c 20                	cmp    $0x20,%al
  800ce0:	74 f2                	je     800cd4 <strtol+0x16>
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	0f b6 00             	movzbl (%eax),%eax
  800ce8:	3c 09                	cmp    $0x9,%al
  800cea:	74 e8                	je     800cd4 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	0f b6 00             	movzbl (%eax),%eax
  800cf2:	3c 2b                	cmp    $0x2b,%al
  800cf4:	75 06                	jne    800cfc <strtol+0x3e>
        s ++;
  800cf6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cfa:	eb 15                	jmp    800d11 <strtol+0x53>
    }
    else if (*s == '-') {
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	0f b6 00             	movzbl (%eax),%eax
  800d02:	3c 2d                	cmp    $0x2d,%al
  800d04:	75 0b                	jne    800d11 <strtol+0x53>
        s ++, neg = 1;
  800d06:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d0a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800d11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d15:	74 06                	je     800d1d <strtol+0x5f>
  800d17:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d1b:	75 24                	jne    800d41 <strtol+0x83>
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	0f b6 00             	movzbl (%eax),%eax
  800d23:	3c 30                	cmp    $0x30,%al
  800d25:	75 1a                	jne    800d41 <strtol+0x83>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	83 c0 01             	add    $0x1,%eax
  800d2d:	0f b6 00             	movzbl (%eax),%eax
  800d30:	3c 78                	cmp    $0x78,%al
  800d32:	75 0d                	jne    800d41 <strtol+0x83>
        s += 2, base = 16;
  800d34:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d38:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d3f:	eb 2a                	jmp    800d6b <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  800d41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d45:	75 17                	jne    800d5e <strtol+0xa0>
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	0f b6 00             	movzbl (%eax),%eax
  800d4d:	3c 30                	cmp    $0x30,%al
  800d4f:	75 0d                	jne    800d5e <strtol+0xa0>
        s ++, base = 8;
  800d51:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d55:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d5c:	eb 0d                	jmp    800d6b <strtol+0xad>
    }
    else if (base == 0) {
  800d5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d62:	75 07                	jne    800d6b <strtol+0xad>
        base = 10;
  800d64:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	0f b6 00             	movzbl (%eax),%eax
  800d71:	3c 2f                	cmp    $0x2f,%al
  800d73:	7e 1b                	jle    800d90 <strtol+0xd2>
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	0f b6 00             	movzbl (%eax),%eax
  800d7b:	3c 39                	cmp    $0x39,%al
  800d7d:	7f 11                	jg     800d90 <strtol+0xd2>
            dig = *s - '0';
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	0f b6 00             	movzbl (%eax),%eax
  800d85:	0f be c0             	movsbl %al,%eax
  800d88:	83 e8 30             	sub    $0x30,%eax
  800d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d8e:	eb 48                	jmp    800dd8 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	0f b6 00             	movzbl (%eax),%eax
  800d96:	3c 60                	cmp    $0x60,%al
  800d98:	7e 1b                	jle    800db5 <strtol+0xf7>
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	0f b6 00             	movzbl (%eax),%eax
  800da0:	3c 7a                	cmp    $0x7a,%al
  800da2:	7f 11                	jg     800db5 <strtol+0xf7>
            dig = *s - 'a' + 10;
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	0f b6 00             	movzbl (%eax),%eax
  800daa:	0f be c0             	movsbl %al,%eax
  800dad:	83 e8 57             	sub    $0x57,%eax
  800db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800db3:	eb 23                	jmp    800dd8 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	0f b6 00             	movzbl (%eax),%eax
  800dbb:	3c 40                	cmp    $0x40,%al
  800dbd:	7e 3d                	jle    800dfc <strtol+0x13e>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	0f b6 00             	movzbl (%eax),%eax
  800dc5:	3c 5a                	cmp    $0x5a,%al
  800dc7:	7f 33                	jg     800dfc <strtol+0x13e>
            dig = *s - 'A' + 10;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	0f b6 00             	movzbl (%eax),%eax
  800dcf:	0f be c0             	movsbl %al,%eax
  800dd2:	83 e8 37             	sub    $0x37,%eax
  800dd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  800dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ddb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dde:	7c 02                	jl     800de2 <strtol+0x124>
            break;
  800de0:	eb 1a                	jmp    800dfc <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  800de2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800de6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ded:	89 c2                	mov    %eax,%edx
  800def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800df2:	01 d0                	add    %edx,%eax
  800df4:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  800df7:	e9 6f ff ff ff       	jmp    800d6b <strtol+0xad>

    if (endptr) {
  800dfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e00:	74 08                	je     800e0a <strtol+0x14c>
        *endptr = (char *) s;
  800e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  800e0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e0e:	74 07                	je     800e17 <strtol+0x159>
  800e10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e13:	f7 d8                	neg    %eax
  800e15:	eb 03                	jmp    800e1a <strtol+0x15c>
  800e17:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e1a:	c9                   	leave  
  800e1b:	c3                   	ret    

00800e1c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	57                   	push   %edi
  800e20:	83 ec 24             	sub    $0x24,%esp
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  800e29:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800e2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e30:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e33:	88 45 f7             	mov    %al,-0x9(%ebp)
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  800e3c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e3f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800e43:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e46:	89 d7                	mov    %edx,%edi
  800e48:	f3 aa                	rep stos %al,%es:(%edi)
  800e4a:	89 fa                	mov    %edi,%edx
  800e4c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  800e4f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  800e52:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  800e55:	83 c4 24             	add    $0x24,%esp
  800e58:	5f                   	pop    %edi
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    

00800e5b <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
  800e61:	83 ec 30             	sub    $0x30,%esp
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e70:	8b 45 10             	mov    0x10(%ebp),%eax
  800e73:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  800e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e79:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800e7c:	73 42                	jae    800ec0 <memmove+0x65>
  800e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e87:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  800e90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e93:	c1 e8 02             	shr    $0x2,%eax
  800e96:	89 c1                	mov    %eax,%ecx
    asm volatile (
  800e98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e9e:	89 d7                	mov    %edx,%edi
  800ea0:	89 c6                	mov    %eax,%esi
  800ea2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ea4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800ea7:	83 e1 03             	and    $0x3,%ecx
  800eaa:	74 02                	je     800eae <memmove+0x53>
  800eac:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800eae:	89 f0                	mov    %esi,%eax
  800eb0:	89 fa                	mov    %edi,%edx
  800eb2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  800eb5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800eb8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  800ebb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ebe:	eb 36                	jmp    800ef6 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  800ec0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ec3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ec9:	01 c2                	add    %eax,%edx
  800ecb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ece:	8d 48 ff             	lea    -0x1(%eax),%ecx
  800ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed4:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  800ed7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800eda:	89 c1                	mov    %eax,%ecx
  800edc:	89 d8                	mov    %ebx,%eax
  800ede:	89 d6                	mov    %edx,%esi
  800ee0:	89 c7                	mov    %eax,%edi
  800ee2:	fd                   	std    
  800ee3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800ee5:	fc                   	cld    
  800ee6:	89 f8                	mov    %edi,%eax
  800ee8:	89 f2                	mov    %esi,%edx
  800eea:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800eed:	89 55 c8             	mov    %edx,-0x38(%ebp)
  800ef0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  800ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  800ef6:	83 c4 30             	add    $0x30,%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    

00800efe <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	57                   	push   %edi
  800f02:	56                   	push   %esi
  800f03:	83 ec 20             	sub    $0x20,%esp
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f12:	8b 45 10             	mov    0x10(%ebp),%eax
  800f15:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  800f18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f1b:	c1 e8 02             	shr    $0x2,%eax
  800f1e:	89 c1                	mov    %eax,%ecx
    asm volatile (
  800f20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f26:	89 d7                	mov    %edx,%edi
  800f28:	89 c6                	mov    %eax,%esi
  800f2a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f2c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  800f2f:	83 e1 03             	and    $0x3,%ecx
  800f32:	74 02                	je     800f36 <memcpy+0x38>
  800f34:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800f36:	89 f0                	mov    %esi,%eax
  800f38:	89 fa                	mov    %edi,%edx
  800f3a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  800f3d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800f40:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  800f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  800f46:	83 c4 20             	add    $0x20,%esp
  800f49:	5e                   	pop    %esi
  800f4a:	5f                   	pop    %edi
  800f4b:	5d                   	pop    %ebp
  800f4c:	c3                   	ret    

00800f4d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  800f5f:	eb 30                	jmp    800f91 <memcmp+0x44>
        if (*s1 != *s2) {
  800f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f64:	0f b6 10             	movzbl (%eax),%edx
  800f67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6a:	0f b6 00             	movzbl (%eax),%eax
  800f6d:	38 c2                	cmp    %al,%dl
  800f6f:	74 18                	je     800f89 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  800f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f74:	0f b6 00             	movzbl (%eax),%eax
  800f77:	0f b6 d0             	movzbl %al,%edx
  800f7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7d:	0f b6 00             	movzbl (%eax),%eax
  800f80:	0f b6 c0             	movzbl %al,%eax
  800f83:	29 c2                	sub    %eax,%edx
  800f85:	89 d0                	mov    %edx,%eax
  800f87:	eb 1a                	jmp    800fa3 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  800f89:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800f8d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  800f91:	8b 45 10             	mov    0x10(%ebp),%eax
  800f94:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f97:	89 55 10             	mov    %edx,0x10(%ebp)
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	75 c3                	jne    800f61 <memcmp+0x14>
    }
    return 0;
  800f9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*, int), int fd, void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 58             	sub    $0x58,%esp
  800fab:	8b 45 14             	mov    0x14(%ebp),%eax
  800fae:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800fb1:	8b 45 18             	mov    0x18(%ebp),%eax
  800fb4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  800fb7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fbd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800fc0:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  800fc3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800fcc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fcf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800fd2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fdf:	74 1c                	je     800ffd <printnum+0x58>
  800fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe4:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe9:	f7 75 e4             	divl   -0x1c(%ebp)
  800fec:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff7:	f7 75 e4             	divl   -0x1c(%ebp)
  800ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801000:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801003:	f7 75 e4             	divl   -0x1c(%ebp)
  801006:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801009:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80100c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80100f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801012:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801015:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801018:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80101b:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  80101e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801021:	ba 00 00 00 00       	mov    $0x0,%edx
  801026:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  801029:	77 64                	ja     80108f <printnum+0xea>
  80102b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  80102e:	72 05                	jb     801035 <printnum+0x90>
  801030:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801033:	77 5a                	ja     80108f <printnum+0xea>
        printnum(putch, fd, putdat, result, base, width - 1, padc);
  801035:	8b 45 20             	mov    0x20(%ebp),%eax
  801038:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103b:	8b 45 24             	mov    0x24(%ebp),%eax
  80103e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  801042:	89 54 24 18          	mov    %edx,0x18(%esp)
  801046:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801049:	89 44 24 14          	mov    %eax,0x14(%esp)
  80104d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801050:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801053:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801057:	89 54 24 10          	mov    %edx,0x10(%esp)
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801062:	8b 45 0c             	mov    0xc(%ebp),%eax
  801065:	89 44 24 04          	mov    %eax,0x4(%esp)
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	89 04 24             	mov    %eax,(%esp)
  80106f:	e8 31 ff ff ff       	call   800fa5 <printnum>
  801074:	eb 23                	jmp    801099 <printnum+0xf4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat, fd);
  801076:	8b 45 0c             	mov    0xc(%ebp),%eax
  801079:	89 44 24 08          	mov    %eax,0x8(%esp)
  80107d:	8b 45 10             	mov    0x10(%ebp),%eax
  801080:	89 44 24 04          	mov    %eax,0x4(%esp)
  801084:	8b 45 24             	mov    0x24(%ebp),%eax
  801087:	89 04 24             	mov    %eax,(%esp)
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	ff d0                	call   *%eax
        while (-- width > 0)
  80108f:	83 6d 20 01          	subl   $0x1,0x20(%ebp)
  801093:	83 7d 20 00          	cmpl   $0x0,0x20(%ebp)
  801097:	7f dd                	jg     801076 <printnum+0xd1>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat, fd);
  801099:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80109c:	05 04 1b 80 00       	add    $0x801b04,%eax
  8010a1:	0f b6 00             	movzbl (%eax),%eax
  8010a4:	0f be c0             	movsbl %al,%eax
  8010a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8010ae:	8b 55 10             	mov    0x10(%ebp),%edx
  8010b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010b5:	89 04 24             	mov    %eax,(%esp)
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	ff d0                	call   *%eax
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  8010c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010c6:	7e 14                	jle    8010dc <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8b 00                	mov    (%eax),%eax
  8010cd:	8d 48 08             	lea    0x8(%eax),%ecx
  8010d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d3:	89 0a                	mov    %ecx,(%edx)
  8010d5:	8b 50 04             	mov    0x4(%eax),%edx
  8010d8:	8b 00                	mov    (%eax),%eax
  8010da:	eb 30                	jmp    80110c <getuint+0x4d>
    }
    else if (lflag) {
  8010dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e0:	74 16                	je     8010f8 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8b 00                	mov    (%eax),%eax
  8010e7:	8d 48 04             	lea    0x4(%eax),%ecx
  8010ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ed:	89 0a                	mov    %ecx,(%edx)
  8010ef:	8b 00                	mov    (%eax),%eax
  8010f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f6:	eb 14                	jmp    80110c <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8b 00                	mov    (%eax),%eax
  8010fd:	8d 48 04             	lea    0x4(%eax),%ecx
  801100:	8b 55 08             	mov    0x8(%ebp),%edx
  801103:	89 0a                	mov    %ecx,(%edx)
  801105:	8b 00                	mov    (%eax),%eax
  801107:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    

0080110e <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  801111:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801115:	7e 14                	jle    80112b <getint+0x1d>
        return va_arg(*ap, long long);
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8b 00                	mov    (%eax),%eax
  80111c:	8d 48 08             	lea    0x8(%eax),%ecx
  80111f:	8b 55 08             	mov    0x8(%ebp),%edx
  801122:	89 0a                	mov    %ecx,(%edx)
  801124:	8b 50 04             	mov    0x4(%eax),%edx
  801127:	8b 00                	mov    (%eax),%eax
  801129:	eb 28                	jmp    801153 <getint+0x45>
    }
    else if (lflag) {
  80112b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112f:	74 12                	je     801143 <getint+0x35>
        return va_arg(*ap, long);
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8b 00                	mov    (%eax),%eax
  801136:	8d 48 04             	lea    0x4(%eax),%ecx
  801139:	8b 55 08             	mov    0x8(%ebp),%edx
  80113c:	89 0a                	mov    %ecx,(%edx)
  80113e:	8b 00                	mov    (%eax),%eax
  801140:	99                   	cltd   
  801141:	eb 10                	jmp    801153 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8b 00                	mov    (%eax),%eax
  801148:	8d 48 04             	lea    0x4(%eax),%ecx
  80114b:	8b 55 08             	mov    0x8(%ebp),%edx
  80114e:	89 0a                	mov    %ecx,(%edx)
  801150:	8b 00                	mov    (%eax),%eax
  801152:	99                   	cltd   
    }
}
  801153:	5d                   	pop    %ebp
  801154:	c3                   	ret    

00801155 <printfmt>:
 * @fd:         file descriptor
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*, int), int fd, void *putdat, const char *fmt, ...) {
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
  801158:	83 ec 38             	sub    $0x38,%esp
    va_list ap;

    va_start(ap, fmt);
  80115b:	8d 45 18             	lea    0x18(%ebp),%eax
  80115e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, fd, putdat, fmt, ap);
  801161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801164:	89 44 24 10          	mov    %eax,0x10(%esp)
  801168:	8b 45 14             	mov    0x14(%ebp),%eax
  80116b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80116f:	8b 45 10             	mov    0x10(%ebp),%eax
  801172:	89 44 24 08          	mov    %eax,0x8(%esp)
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	89 44 24 04          	mov    %eax,0x4(%esp)
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	89 04 24             	mov    %eax,(%esp)
  801183:	e8 02 00 00 00       	call   80118a <vprintfmt>
    va_end(ap);
}
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*, int), int fd, void *putdat, const char *fmt, va_list ap) {
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	56                   	push   %esi
  80118e:	53                   	push   %ebx
  80118f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  801192:	eb 1f                	jmp    8011b3 <vprintfmt+0x29>
            if (ch == '\0') {
  801194:	85 db                	test   %ebx,%ebx
  801196:	75 05                	jne    80119d <vprintfmt+0x13>
                return;
  801198:	e9 33 04 00 00       	jmp    8015d0 <vprintfmt+0x446>
            }
            putch(ch, putdat, fd);
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ab:	89 1c 24             	mov    %ebx,(%esp)
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8011b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b6:	8d 50 01             	lea    0x1(%eax),%edx
  8011b9:	89 55 14             	mov    %edx,0x14(%ebp)
  8011bc:	0f b6 00             	movzbl (%eax),%eax
  8011bf:	0f b6 d8             	movzbl %al,%ebx
  8011c2:	83 fb 25             	cmp    $0x25,%ebx
  8011c5:	75 cd                	jne    801194 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  8011c7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  8011cb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8011d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  8011d8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8011df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  8011e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e8:	8d 50 01             	lea    0x1(%eax),%edx
  8011eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8011ee:	0f b6 00             	movzbl (%eax),%eax
  8011f1:	0f b6 d8             	movzbl %al,%ebx
  8011f4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8011f7:	83 f8 55             	cmp    $0x55,%eax
  8011fa:	0f 87 98 03 00 00    	ja     801598 <vprintfmt+0x40e>
  801200:	8b 04 85 28 1b 80 00 	mov    0x801b28(,%eax,4),%eax
  801207:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  801209:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  80120d:	eb d6                	jmp    8011e5 <vprintfmt+0x5b>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  80120f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  801213:	eb d0                	jmp    8011e5 <vprintfmt+0x5b>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  801215:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  80121c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80121f:	89 d0                	mov    %edx,%eax
  801221:	c1 e0 02             	shl    $0x2,%eax
  801224:	01 d0                	add    %edx,%eax
  801226:	01 c0                	add    %eax,%eax
  801228:	01 d8                	add    %ebx,%eax
  80122a:	83 e8 30             	sub    $0x30,%eax
  80122d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  801230:	8b 45 14             	mov    0x14(%ebp),%eax
  801233:	0f b6 00             	movzbl (%eax),%eax
  801236:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  801239:	83 fb 2f             	cmp    $0x2f,%ebx
  80123c:	7e 0b                	jle    801249 <vprintfmt+0xbf>
  80123e:	83 fb 39             	cmp    $0x39,%ebx
  801241:	7f 06                	jg     801249 <vprintfmt+0xbf>
            for (precision = 0; ; ++ fmt) {
  801243:	83 45 14 01          	addl   $0x1,0x14(%ebp)
                    break;
                }
            }
  801247:	eb d3                	jmp    80121c <vprintfmt+0x92>
            goto process_precision;
  801249:	eb 33                	jmp    80127e <vprintfmt+0xf4>

        case '*':
            precision = va_arg(ap, int);
  80124b:	8b 45 18             	mov    0x18(%ebp),%eax
  80124e:	8d 50 04             	lea    0x4(%eax),%edx
  801251:	89 55 18             	mov    %edx,0x18(%ebp)
  801254:	8b 00                	mov    (%eax),%eax
  801256:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  801259:	eb 23                	jmp    80127e <vprintfmt+0xf4>

        case '.':
            if (width < 0)
  80125b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80125f:	79 0c                	jns    80126d <vprintfmt+0xe3>
                width = 0;
  801261:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  801268:	e9 78 ff ff ff       	jmp    8011e5 <vprintfmt+0x5b>
  80126d:	e9 73 ff ff ff       	jmp    8011e5 <vprintfmt+0x5b>

        case '#':
            altflag = 1;
  801272:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  801279:	e9 67 ff ff ff       	jmp    8011e5 <vprintfmt+0x5b>

        process_precision:
            if (width < 0)
  80127e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801282:	79 12                	jns    801296 <vprintfmt+0x10c>
                width = precision, precision = -1;
  801284:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801287:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80128a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  801291:	e9 4f ff ff ff       	jmp    8011e5 <vprintfmt+0x5b>
  801296:	e9 4a ff ff ff       	jmp    8011e5 <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  80129b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  80129f:	e9 41 ff ff ff       	jmp    8011e5 <vprintfmt+0x5b>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat, fd);
  8012a4:	8b 45 18             	mov    0x18(%ebp),%eax
  8012a7:	8d 50 04             	lea    0x4(%eax),%edx
  8012aa:	89 55 18             	mov    %edx,0x18(%ebp)
  8012ad:	8b 00                	mov    (%eax),%eax
  8012af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8012b6:	8b 55 10             	mov    0x10(%ebp),%edx
  8012b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012bd:	89 04 24             	mov    %eax,(%esp)
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	ff d0                	call   *%eax
            break;
  8012c5:	e9 00 03 00 00       	jmp    8015ca <vprintfmt+0x440>

        // error message
        case 'e':
            err = va_arg(ap, int);
  8012ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8012cd:	8d 50 04             	lea    0x4(%eax),%edx
  8012d0:	89 55 18             	mov    %edx,0x18(%ebp)
  8012d3:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  8012d5:	85 db                	test   %ebx,%ebx
  8012d7:	79 02                	jns    8012db <vprintfmt+0x151>
                err = -err;
  8012d9:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8012db:	83 fb 18             	cmp    $0x18,%ebx
  8012de:	7f 0b                	jg     8012eb <vprintfmt+0x161>
  8012e0:	8b 34 9d a0 1a 80 00 	mov    0x801aa0(,%ebx,4),%esi
  8012e7:	85 f6                	test   %esi,%esi
  8012e9:	75 2a                	jne    801315 <vprintfmt+0x18b>
                printfmt(putch, fd, putdat, "error %d", err);
  8012eb:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  8012ef:	c7 44 24 0c 15 1b 80 	movl   $0x801b15,0xc(%esp)
  8012f6:	00 
  8012f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801301:	89 44 24 04          	mov    %eax,0x4(%esp)
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	89 04 24             	mov    %eax,(%esp)
  80130b:	e8 45 fe ff ff       	call   801155 <printfmt>
            }
            else {
                printfmt(putch, fd, putdat, "%s", p);
            }
            break;
  801310:	e9 b5 02 00 00       	jmp    8015ca <vprintfmt+0x440>
                printfmt(putch, fd, putdat, "%s", p);
  801315:	89 74 24 10          	mov    %esi,0x10(%esp)
  801319:	c7 44 24 0c 1e 1b 80 	movl   $0x801b1e,0xc(%esp)
  801320:	00 
  801321:	8b 45 10             	mov    0x10(%ebp),%eax
  801324:	89 44 24 08          	mov    %eax,0x8(%esp)
  801328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	89 04 24             	mov    %eax,(%esp)
  801335:	e8 1b fe ff ff       	call   801155 <printfmt>
            break;
  80133a:	e9 8b 02 00 00       	jmp    8015ca <vprintfmt+0x440>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  80133f:	8b 45 18             	mov    0x18(%ebp),%eax
  801342:	8d 50 04             	lea    0x4(%eax),%edx
  801345:	89 55 18             	mov    %edx,0x18(%ebp)
  801348:	8b 30                	mov    (%eax),%esi
  80134a:	85 f6                	test   %esi,%esi
  80134c:	75 05                	jne    801353 <vprintfmt+0x1c9>
                p = "(null)";
  80134e:	be 21 1b 80 00       	mov    $0x801b21,%esi
            }
            if (width > 0 && padc != '-') {
  801353:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801357:	7e 45                	jle    80139e <vprintfmt+0x214>
  801359:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80135d:	74 3f                	je     80139e <vprintfmt+0x214>
                for (width -= strnlen(p, precision); width > 0; width --) {
  80135f:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  801362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801365:	89 44 24 04          	mov    %eax,0x4(%esp)
  801369:	89 34 24             	mov    %esi,(%esp)
  80136c:	e8 7d f7 ff ff       	call   800aee <strnlen>
  801371:	29 c3                	sub    %eax,%ebx
  801373:	89 d8                	mov    %ebx,%eax
  801375:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801378:	eb 1e                	jmp    801398 <vprintfmt+0x20e>
                    putch(padc, putdat, fd);
  80137a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80137e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801381:	89 54 24 08          	mov    %edx,0x8(%esp)
  801385:	8b 55 10             	mov    0x10(%ebp),%edx
  801388:	89 54 24 04          	mov    %edx,0x4(%esp)
  80138c:	89 04 24             	mov    %eax,(%esp)
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  801394:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  801398:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80139c:	7f dc                	jg     80137a <vprintfmt+0x1f0>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80139e:	eb 46                	jmp    8013e6 <vprintfmt+0x25c>
                if (altflag && (ch < ' ' || ch > '~')) {
  8013a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8013a4:	74 26                	je     8013cc <vprintfmt+0x242>
  8013a6:	83 fb 1f             	cmp    $0x1f,%ebx
  8013a9:	7e 05                	jle    8013b0 <vprintfmt+0x226>
  8013ab:	83 fb 7e             	cmp    $0x7e,%ebx
  8013ae:	7e 1c                	jle    8013cc <vprintfmt+0x242>
                    putch('?', putdat, fd);
  8013b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013be:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	ff d0                	call   *%eax
  8013ca:	eb 16                	jmp    8013e2 <vprintfmt+0x258>
                }
                else {
                    putch(ch, putdat, fd);
  8013cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013da:	89 1c 24             	mov    %ebx,(%esp)
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8013e2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  8013e6:	89 f0                	mov    %esi,%eax
  8013e8:	8d 70 01             	lea    0x1(%eax),%esi
  8013eb:	0f b6 00             	movzbl (%eax),%eax
  8013ee:	0f be d8             	movsbl %al,%ebx
  8013f1:	85 db                	test   %ebx,%ebx
  8013f3:	74 10                	je     801405 <vprintfmt+0x27b>
  8013f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013f9:	78 a5                	js     8013a0 <vprintfmt+0x216>
  8013fb:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8013ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801403:	79 9b                	jns    8013a0 <vprintfmt+0x216>
                }
            }
            for (; width > 0; width --) {
  801405:	eb 1e                	jmp    801425 <vprintfmt+0x29b>
                putch(' ', putdat, fd);
  801407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80140e:	8b 45 10             	mov    0x10(%ebp),%eax
  801411:	89 44 24 04          	mov    %eax,0x4(%esp)
  801415:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  801421:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  801425:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801429:	7f dc                	jg     801407 <vprintfmt+0x27d>
            }
            break;
  80142b:	e9 9a 01 00 00       	jmp    8015ca <vprintfmt+0x440>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  801430:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801433:	89 44 24 04          	mov    %eax,0x4(%esp)
  801437:	8d 45 18             	lea    0x18(%ebp),%eax
  80143a:	89 04 24             	mov    %eax,(%esp)
  80143d:	e8 cc fc ff ff       	call   80110e <getint>
  801442:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801445:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  801448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144e:	85 d2                	test   %edx,%edx
  801450:	79 2d                	jns    80147f <vprintfmt+0x2f5>
                putch('-', putdat, fd);
  801452:	8b 45 0c             	mov    0xc(%ebp),%eax
  801455:	89 44 24 08          	mov    %eax,0x8(%esp)
  801459:	8b 45 10             	mov    0x10(%ebp),%eax
  80145c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801460:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	ff d0                	call   *%eax
                num = -(long long)num;
  80146c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801472:	f7 d8                	neg    %eax
  801474:	83 d2 00             	adc    $0x0,%edx
  801477:	f7 da                	neg    %edx
  801479:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80147c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  80147f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  801486:	e9 b6 00 00 00       	jmp    801541 <vprintfmt+0x3b7>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  80148b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801492:	8d 45 18             	lea    0x18(%ebp),%eax
  801495:	89 04 24             	mov    %eax,(%esp)
  801498:	e8 22 fc ff ff       	call   8010bf <getuint>
  80149d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  8014a3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  8014aa:	e9 92 00 00 00       	jmp    801541 <vprintfmt+0x3b7>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  8014af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b6:	8d 45 18             	lea    0x18(%ebp),%eax
  8014b9:	89 04 24             	mov    %eax,(%esp)
  8014bc:	e8 fe fb ff ff       	call   8010bf <getuint>
  8014c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  8014c7:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  8014ce:	eb 71                	jmp    801541 <vprintfmt+0x3b7>

        // pointer
        case 'p':
            putch('0', putdat, fd);
  8014d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014de:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	ff d0                	call   *%eax
            putch('x', putdat, fd);
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f8:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  801504:	8b 45 18             	mov    0x18(%ebp),%eax
  801507:	8d 50 04             	lea    0x4(%eax),%edx
  80150a:	89 55 18             	mov    %edx,0x18(%ebp)
  80150d:	8b 00                	mov    (%eax),%eax
  80150f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801512:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  801519:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  801520:	eb 1f                	jmp    801541 <vprintfmt+0x3b7>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  801522:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801525:	89 44 24 04          	mov    %eax,0x4(%esp)
  801529:	8d 45 18             	lea    0x18(%ebp),%eax
  80152c:	89 04 24             	mov    %eax,(%esp)
  80152f:	e8 8b fb ff ff       	call   8010bf <getuint>
  801534:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801537:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  80153a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, fd, putdat, num, base, width, padc);
  801541:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801545:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801548:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  80154c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80154f:	89 54 24 18          	mov    %edx,0x18(%esp)
  801553:	89 44 24 14          	mov    %eax,0x14(%esp)
  801557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801561:	89 54 24 10          	mov    %edx,0x10(%esp)
  801565:	8b 45 10             	mov    0x10(%ebp),%eax
  801568:	89 44 24 08          	mov    %eax,0x8(%esp)
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	89 04 24             	mov    %eax,(%esp)
  801579:	e8 27 fa ff ff       	call   800fa5 <printnum>
            break;
  80157e:	eb 4a                	jmp    8015ca <vprintfmt+0x440>

        // escaped '%' character
        case '%':
            putch(ch, putdat, fd);
  801580:	8b 45 0c             	mov    0xc(%ebp),%eax
  801583:	89 44 24 08          	mov    %eax,0x8(%esp)
  801587:	8b 45 10             	mov    0x10(%ebp),%eax
  80158a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80158e:	89 1c 24             	mov    %ebx,(%esp)
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	ff d0                	call   *%eax
            break;
  801596:	eb 32                	jmp    8015ca <vprintfmt+0x440>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat, fd);
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80159f:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a6:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  8015b2:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
  8015b6:	eb 04                	jmp    8015bc <vprintfmt+0x432>
  8015b8:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
  8015bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8015bf:	83 e8 01             	sub    $0x1,%eax
  8015c2:	0f b6 00             	movzbl (%eax),%eax
  8015c5:	3c 25                	cmp    $0x25,%al
  8015c7:	75 ef                	jne    8015b8 <vprintfmt+0x42e>
                /* do nothing */;
            break;
  8015c9:	90                   	nop
        }
    }
  8015ca:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8015cb:	e9 e3 fb ff ff       	jmp    8011b3 <vprintfmt+0x29>
}
  8015d0:	83 c4 40             	add    $0x40,%esp
  8015d3:	5b                   	pop    %ebx
  8015d4:	5e                   	pop    %esi
  8015d5:	5d                   	pop    %ebp
  8015d6:	c3                   	ret    

008015d7 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  8015da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dd:	8b 40 08             	mov    0x8(%eax),%eax
  8015e0:	8d 50 01             	lea    0x1(%eax),%edx
  8015e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e6:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  8015e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ec:	8b 10                	mov    (%eax),%edx
  8015ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f1:	8b 40 04             	mov    0x4(%eax),%eax
  8015f4:	39 c2                	cmp    %eax,%edx
  8015f6:	73 12                	jae    80160a <sprintputch+0x33>
        *b->buf ++ = ch;
  8015f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fb:	8b 00                	mov    (%eax),%eax
  8015fd:	8d 48 01             	lea    0x1(%eax),%ecx
  801600:	8b 55 0c             	mov    0xc(%ebp),%edx
  801603:	89 0a                	mov    %ecx,(%edx)
  801605:	8b 55 08             	mov    0x8(%ebp),%edx
  801608:	88 10                	mov    %dl,(%eax)
    }
}
  80160a:	5d                   	pop    %ebp
  80160b:	c3                   	ret    

0080160c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  801612:	8d 45 14             	lea    0x14(%ebp),%eax
  801615:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  801618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80161f:	8b 45 10             	mov    0x10(%ebp),%eax
  801622:	89 44 24 08          	mov    %eax,0x8(%esp)
  801626:	8b 45 0c             	mov    0xc(%ebp),%eax
  801629:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	89 04 24             	mov    %eax,(%esp)
  801633:	e8 08 00 00 00       	call   801640 <vsnprintf>
  801638:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  80163b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 38             	sub    $0x38,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80164c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	01 d0                	add    %edx,%eax
  801657:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80165a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  801661:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801665:	74 0a                	je     801671 <vsnprintf+0x31>
  801667:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80166a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166d:	39 c2                	cmp    %eax,%edx
  80166f:	76 07                	jbe    801678 <vsnprintf+0x38>
        return -E_INVAL;
  801671:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801676:	eb 32                	jmp    8016aa <vsnprintf+0x6a>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, NO_FD, &b, fmt, ap);
  801678:	8b 45 14             	mov    0x14(%ebp),%eax
  80167b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80167f:	8b 45 10             	mov    0x10(%ebp),%eax
  801682:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801686:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801689:	89 44 24 08          	mov    %eax,0x8(%esp)
  80168d:	c7 44 24 04 d9 6a ff 	movl   $0xffff6ad9,0x4(%esp)
  801694:	ff 
  801695:	c7 04 24 d7 15 80 00 	movl   $0x8015d7,(%esp)
  80169c:	e8 e9 fa ff ff       	call   80118a <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  8016a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  8016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
  8016bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
  8016be:	b8 20 00 00 00       	mov    $0x20,%eax
  8016c3:	2b 45 0c             	sub    0xc(%ebp),%eax
  8016c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c9:	89 c1                	mov    %eax,%ecx
  8016cb:	d3 ea                	shr    %cl,%edx
  8016cd:	89 d0                	mov    %edx,%eax
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	57                   	push   %edi
  8016d5:	56                   	push   %esi
  8016d6:	53                   	push   %ebx
  8016d7:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
  8016da:	a1 08 20 80 00       	mov    0x802008,%eax
  8016df:	8b 15 0c 20 80 00    	mov    0x80200c,%edx
  8016e5:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
  8016eb:	6b f0 05             	imul   $0x5,%eax,%esi
  8016ee:	01 f7                	add    %esi,%edi
  8016f0:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
  8016f5:	f7 e6                	mul    %esi
  8016f7:	8d 34 17             	lea    (%edi,%edx,1),%esi
  8016fa:	89 f2                	mov    %esi,%edx
  8016fc:	83 c0 0b             	add    $0xb,%eax
  8016ff:	83 d2 00             	adc    $0x0,%edx
  801702:	89 c7                	mov    %eax,%edi
  801704:	83 e7 ff             	and    $0xffffffff,%edi
  801707:	89 f9                	mov    %edi,%ecx
  801709:	0f b7 da             	movzwl %dx,%ebx
  80170c:	89 0d 08 20 80 00    	mov    %ecx,0x802008
  801712:	89 1d 0c 20 80 00    	mov    %ebx,0x80200c
    unsigned long long result = (next >> 12);
  801718:	a1 08 20 80 00       	mov    0x802008,%eax
  80171d:	8b 15 0c 20 80 00    	mov    0x80200c,%edx
  801723:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  801727:	c1 ea 0c             	shr    $0xc,%edx
  80172a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80172d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
  801730:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
  801737:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80173a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80173d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801740:	89 55 e8             	mov    %edx,-0x18(%ebp)
  801743:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801746:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801749:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80174d:	74 1c                	je     80176b <rand+0x9a>
  80174f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801752:	ba 00 00 00 00       	mov    $0x0,%edx
  801757:	f7 75 dc             	divl   -0x24(%ebp)
  80175a:	89 55 ec             	mov    %edx,-0x14(%ebp)
  80175d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801760:	ba 00 00 00 00       	mov    $0x0,%edx
  801765:	f7 75 dc             	divl   -0x24(%ebp)
  801768:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80176b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80176e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801771:	f7 75 dc             	divl   -0x24(%ebp)
  801774:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801777:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80177a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80177d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801780:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801783:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801786:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  801789:	83 c4 24             	add    $0x24,%esp
  80178c:	5b                   	pop    %ebx
  80178d:	5e                   	pop    %esi
  80178e:	5f                   	pop    %edi
  80178f:	5d                   	pop    %ebp
  801790:	c3                   	ret    

00801791 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
    next = seed;
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
  80179c:	a3 08 20 80 00       	mov    %eax,0x802008
  8017a1:	89 15 0c 20 80 00    	mov    %edx,0x80200c
}
  8017a7:	5d                   	pop    %ebp
  8017a8:	c3                   	ret    

008017a9 <main>:
#include <stdio.h>
#include <ulib.h>

int
main(void) {
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	83 e4 f0             	and    $0xfffffff0,%esp
  8017af:	83 ec 10             	sub    $0x10,%esp
    cprintf("I read %8x from 0.\n", *(unsigned int *)0);
  8017b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b7:	8b 00                	mov    (%eax),%eax
  8017b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bd:	c7 04 24 80 1c 80 00 	movl   $0x801c80,(%esp)
  8017c4:	e8 00 f0 ff ff       	call   8007c9 <cprintf>
    panic("FAIL: T.T\n");
  8017c9:	c7 44 24 08 94 1c 80 	movl   $0x801c94,0x8(%esp)
  8017d0:	00 
  8017d1:	c7 44 24 04 07 00 00 	movl   $0x7,0x4(%esp)
  8017d8:	00 
  8017d9:	c7 04 24 9f 1c 80 00 	movl   $0x801c9f,(%esp)
  8017e0:	e8 3b e8 ff ff       	call   800020 <__panic>
