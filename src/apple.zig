const syscall = @import("syscall");

pub const IOCPARM_MASK = 0x2000;

pub inline fn IOCPARAM_LEN(x: comptime_int) comptime_int {
    return (x >> 16) & IOCPARM_MASK;
}

pub inline fn IOCBASECMD(x: comptime_int) comptime_int {
    return x & ~(IOCPARM_MASK << 16);
}

pub inline fn IOCGROUP(x: comptime_int) comptime_int {
    return (x >> 8) & 0xff;
}

pub const IOCPARM_MAX = (IOCPARM_MASK + 1);

pub const IOC_VOID = 0x20000000;

pub const IOC_OUT = 0x40000000;

pub const IOC_IN = 0x80000000;

pub const IOC_INOUT = IOC_IN | IOC_OUT;

pub const IOC_DIRMASK = 0xe0000000;

pub inline fn _IOC(inout: comptime_int, group: comptime_int, num: comptime_int, len: comptime_int) comptime_int {
    return inout | ((len & IOCPARM_MASK) << 16) | (group << 8) | num;
}

pub inline fn _IO(g: comptime_int, n: comptime_int) comptime_int {
    return _IOC(IOC_VOID, g, n, 0);
}

pub inline fn _IOR(g: comptime_int, n: comptime_int, comptime T: type) comptime_int {
    return _IOC(IOC_OUT, g, n, @sizeOf(T));
}

pub inline fn _IOW(g: comptime_int, n: comptime_int, comptime T: type) comptime_int {
    return _IOC(IOC_IN, g, n, @sizeOf(T));
}

pub inline fn _IOWR(g: comptime_int, n: comptime_int, comptime T: type) comptime_int {
    return _IOC(IOC_INOUT, g, n, @sizeOf(T));
}

pub const winsize = packed struct {
    ws_row: c_ushort,
    ws_col: c_ushort,
    ws_xpixel: c_ushort,
    ws_ypixel: c_ushort,
};

pub const tcflag_t = c_ulong;
pub const cc_t = u8;
pub const speed_t = c_ulong;
pub const NCCS = 20;

pub const termios = packed struct {
    c_iflag: tcflag_t,
    c_oflag: tcflag_t,
    c_cflag: tcflag_t,
    c_lflag: tcflag_t,
    c_cc: [NCCS]cc_t,
    c_ispeed: speed_t,
    c_ospeed: speed_t,
};

pub const timeval = packed struct {
    tv_sec: c_long,
    tv_usec: i32,
};

pub const TIOCMODG = _IOR('t', 3, c_int);
pub const TIOCMODS = _IOW('t', 4, c_int);
pub const TIOCM_LE = 0001;
pub const TIOCM_DTR = 0002;
pub const TIOCM_RTS = 0004;
pub const TIOCM_ST = 0010;
pub const TIOCM_SR = 0020;
pub const TIOCM_CTS = 0040;
pub const TIOCM_CAR = 0100;
pub const TIOCM_CD = TIOCM_CAR;
pub const TIOCM_RNG = 0200;
pub const TIOCM_RI = TIOCM_RNG;
pub const TIOCM_DSR = 0400;

pub const TIOCEXCL = _IO('t', 13);
pub const TIOCNXCL = _IO('t', 14);

pub const TIOCFLUSH = _IOW('t', 16, c_int);

pub const TIOCGETA = _IOR('t', 19, termios);
pub const TIOCSETA = _IOW('t', 20, termios);
pub const TIOCSETAW = _IOW('t', 21, termios);
pub const TIOCSETAF = _IOW('t', 22, termios);
pub const TIOCGETD = _IOR('t', 26, c_int);
pub const TIOCSETD = _IOW('t', 27, c_int);
pub const TIOCIXON = _IO('t', 129);
pub const TIOCIXOFF = _IO('t', 128);

pub const TIOCSBRK = _IO('t', 123);
pub const TIOCCBRK = _IO('t', 122);
pub const TIOCSDTR = _IO('t', 121);
pub const TIOCCDTR = _IO('t', 120);
pub const TIOCGPGRP = _IOR('t', 119, c_int);
pub const TIOCSPGRP = _IOW('t', 118, c_int);
pub const TIOCOUTQ = _IOR('t', 115, c_int);
pub const TIOCSTI = _IOW('t', 114, i8);
pub const TIOCNOTTY = _IO('t', 113);
pub const TIOCPKT = _IOW('t', 112, c_int);
pub const TIOCPKT_DATA = 0x00;
pub const TIOCPKT_FLUSHREAD = 0x01;
pub const TIOCPKT_FLUSHWRITE = 0x02;
pub const TIOCPKT_STOP = 0x04;
pub const TIOCPKT_START = 0x08;
pub const TIOCPKT_NOSTOP = 0x10;
pub const TIOCPKT_DOSTOP = 0x20;
pub const TIOCPKT_IOCTL = 0x40;
pub const TIOCSTOP = _IO('t', 111);
pub const TIOCSTART = _IO('t', 110);
pub const TIOCMSET = _IOW('t', 109, c_int);
pub const TIOCMBIS = _IOW('t', 108, c_int);
pub const TIOCMBIC = _IOW('t', 107, c_int);
pub const TIOCMGET = _IOR('t', 106, c_int);
pub const TIOCREMOTE = _IOW('t', 105, c_int);
pub const TIOCGWINSZ = _IOR('t', 104, winsize);
pub const TIOCSWINSZ = _IOW('t', 103, winsize);
pub const TIOCUCNTL = _IOW('t', 102, c_int);
pub const TIOCSTAT = _IO('t', 101);
pub inline fn UIOCCMD(n: comptime_int) comptime_int {
    return _IO('u', n);
}
pub const TIOCSCONS = _IO('t', 99);
pub const TIOCCONS = _IOW('t', 98, c_int);
pub const TIOCSCTTY = _IO('t', 97);
pub const TIOCEXT = _IOW('t', 96, c_int);
pub const TIOCSIG = _IO('t', 95);
pub const TIOCDRAIN = _IO('t', 94);
pub const TIOCMSDTRWAIT = _IOW('t', 91, c_int);
pub const TIOCMGDTRWAIT = _IOR('t', 90, c_int);
pub const TIOCTIMESTAMP = _IOR('t', 89, timeval);
pub const TIOCDCDTIMESTAMP = _IOR('t', 88, timeval);
pub const TIOCSDRAINWAIT = _IOW('t', 87, c_int);
pub const TIOCGDRAINWAIT = _IOR('t', 86, c_int);
pub const TIOCDSIMICROCODE = _IO('t', 85);
pub const TIOCPTYGRANT = _IO('t', 84);
pub const TIOCPTYGNAME = _IOC(IOC_OUT, 't', 83, 128);
pub const TIOCPTYUNLK = _IO('t', 82);

pub const TTYDISC = 0;
pub const TABLDISC = 3;
pub const SLIPDISC = 4;
pub const PPPDISC = 5;

pub const ttysize = struct {
    ts_lines: c_ushort,
    ts_cols: c_ushort,
    ts_xxx: c_ushort,
    ts_yyy: c_ushort,
};

pub const TIOCGSIZE = TIOCGWINSZ;
pub const TIOCSSIZE = TIOCSWINSZ;

pub const FIOCLEX = _IO('f', 1);
pub const FIONCLEX = _IO('f', 2);
pub const FIONREAD = _IOR('f', 127, c_int);
pub const FIONBIO = _IOW('f', 126, c_int);
pub const FIOASYNC = _IOW('f', 125, c_int);
pub const FIOSETOWN = _IOW('f', 124, c_int);
pub const FIOGETOWN = _IOR('f', 123, c_int);
pub const FIODTYPE = _IOR('f', 122, c_int);

pub const SIOCSHIWAT = _IOW('s', 0, c_int);
pub const SIOCGHIWAT = _IOR('s', 1, c_int);
pub const SIOCSLOWAT = _IOW('s', 2, c_int);
pub const SIOCGLOWAT = _IOR('s', 3, c_int);
pub const SIOCATMARK = _IOR('s', 7, c_int);
pub const SIOCSPGRP = _IOW('s', 8, c_int);
pub const SIOCGPGRP = _IOR('s', 9, c_int);

pub const IF_NAMESIZE = 16;

pub const IFNAMSIZ = IF_NAMESIZE;

pub const sa_family_t = u8;

pub const sockaddr = packed struct {
    sa_len: u8,
    sa_family: sa_family_t,
    sa_data: [14]u8,
};

pub const caddr_t = *u8;

pub const ifdevmtu = struct {
    ifdm_current: c_int,
    ifdm_min: c_int,
    ifdm_max: c_int,
};

pub const ifkpi = struct {
    ifk_module_id: c_uint,
    ifk_type: c_uint,
    ifk_data: union {
        ifk_ptr: *void,
        ifk_value: c_int,
    },
};

pub const ifreq = packed struct {
    ifr_name: [IFNAMSIZ]u8,

    ifr_ifru: union {
        ifru_addr: sockaddr,
        ifru_dstaddr: sockaddr,
        ifru_broadaddr: sockaddr,
        ifru_flags: c_short,
        ifru_metric: c_int,
        ifru_mtu: c_int,
        ifru_phys: c_int,
        ifru_media: c_int,
        ifru_intval: c_int,
        ifru_data: caddr_t,
        ifru_devmtu: ifdevmtu,
        ifru_kpi: ifkpi,
        ifru_wake_flags: u32,
        ifru_route_refcnt: u32,
        ifru_cap: [2]c_int,
        ifru_functional_type: u32,
    },
};

pub const ifaliasreq = packed struct {
    ifra_name: [IFNAMSIZ]u8,
    ifra_addr: sockaddr,
    ifra_broadaddr: sockaddr,
    ifra_mask: sockaddr,
};

pub const if_clonereq = packed struct {
    ifcr_total: c_int,
    ifcr_count: c_int,
    ifcr_buffer: *u8,
};

pub const ifconf = packed struct {
    ifc_len: c_int,
    ifc_ifcu: union {
        ifcu_buf: caddr_t,
        ifcu_req: *ifreq,
    },
};

pub const ifmediareq = packed struct {
    ifm_name: [IFNAMSIZ]u8,
    ifm_current: c_int,
    ifm_mask: c_int,
    ifm_status: c_int,
    ifm_active: c_int,
    ifm_count: c_int,
    ifm_ulist: *c_int,
};

pub const rslvmulti_req = packed struct {
    sa: *sockaddr,
    llsa: **sockaddr,
};

pub const IFSTATMAX = 800;

pub const ifstat = packed struct {
    ifs_name: [IFNAMSIZ]u8,
    ascii: [IFSTATMAX + 1]u8,
};

pub const ifdrv = packed struct {
    ifd_name: [IFNAMSIZ]u8,
    ifd_cmd: c_ulong,
    ifd_len: isize,
    ifd_data: *void,
};

pub const SIOCSIFADDR = _IOW('i', 12, ifreq);
pub const SIOCSIFDSTADDR = _IOW('i', 14, ifreq);
pub const SIOCSIFFLAGS = _IOW('i', 16, ifreq);
pub const SIOCGIFFLAGS = _IOWR('i', 17, ifreq);
pub const SIOCSIFBRDADDR = _IOW('i', 19, ifreq);
pub const SIOCSIFNETMASK = _IOW('i', 22, ifreq);
pub const SIOCGIFMETRIC = _IOWR('i', 23, ifreq);
pub const SIOCSIFMETRIC = _IOW('i', 24, ifreq);
pub const SIOCDIFADDR = _IOW('i', 25, ifreq);
pub const SIOCAIFADDR = _IOW('i', 26, ifaliasreq);

pub const SIOCGIFADDR = _IOWR('i', 33, ifreq);
pub const SIOCGIFDSTADDR = _IOWR('i', 34, ifreq);
pub const SIOCGIFBRDADDR = _IOWR('i', 35, ifreq);
pub const SIOCGIFCONF = _IOWR('i', 36, ifconf);
pub const SIOCGIFNETMASK = _IOWR('i', 37, ifreq);
pub const SIOCAUTOADDR = _IOWR('i', 38, ifreq);
pub const SIOCAUTONETMASK = _IOW('i', 39, ifreq);
pub const SIOCARPIPLL = _IOWR('i', 40, ifreq);

pub const SIOCADDMULTI = _IOW('i', 49, ifreq);
pub const SIOCDELMULTI = _IOW('i', 50, ifreq);
pub const SIOCGIFMTU = _IOWR('i', 51, ifreq);
pub const SIOCSIFMTU = _IOW('i', 52, ifreq);
pub const SIOCGIFPHYS = _IOWR('i', 53, ifreq);
pub const SIOCSIFPHYS = _IOW('i', 54, ifreq);
pub const SIOCSIFMEDIA = _IOWR('i', 55, ifreq);

pub const SIOCGIFMEDIA = _IOWR('i', 56, ifmediareq);

pub const SIOCSIFGENERIC = _IOW('i', 57, ifreq);
pub const SIOCGIFGENERIC = _IOWR('i', 58, ifreq);
pub const SIOCRSLVMULTI = _IOWR('i', 59, rslvmulti_req);

pub const SIOCSIFLLADDR = _IOW('i', 60, ifreq);
pub const SIOCGIFSTATUS = _IOWR('i', 61, ifstat);
pub const SIOCSIFPHYADDR = _IOW('i', 62, ifaliasreq);
pub const SIOCGIFPSRCADDR = _IOWR('i', 63, ifreq);
pub const SIOCGIFPDSTADDR = _IOWR('i', 64, ifreq);
pub const SIOCDIFPHYADDR = _IOW('i', 65, ifreq);

pub const SIOCGIFDEVMTU = _IOWR('i', 68, ifreq);
pub const SIOCSIFALTMTU = _IOW('i', 69, ifreq);
pub const SIOCGIFALTMTU = _IOWR('i', 72, ifreq);
pub const SIOCSIFBOND = _IOW('i', 70, ifreq);
pub const SIOCGIFBOND = _IOWR('i', 71, ifreq);

pub const SIOCGIFXMEDIA = _IOWR('i', 72, ifmediareq);

pub const SIOCSIFCAP = _IOW('i', 90, ifreq);
pub const SIOCGIFCAP = _IOWR('i', 91, ifreq);

pub const SIOCIFCREATE = _IOWR('i', 120, ifreq);
pub const SIOCIFDESTROY = _IOW('i', 121, ifreq);
pub const SIOCIFCREATE2 = _IOWR('i', 122, ifreq);

pub const SIOCSDRVSPEC = _IOW('i', 123, ifdrv);

pub const SIOCGDRVSPEC = _IOWR('i', 123, ifdrv);

pub const SIOCSIFVLAN = _IOW('i', 126, ifreq);
pub const SIOCGIFVLAN = _IOWR('i', 127, ifreq);
pub const SIOCSETVLAN = SIOCSIFVLAN;
pub const SIOCGETVLAN = SIOCGIFVLAN;

pub const SIOCIFGCLONERS = _IOWR('i', 129, if_clonereq);

pub const SIOCGIFASYNCMAP = _IOWR('i', 124, ifreq);
pub const SIOCSIFASYNCMAP = _IOW('i', 125, ifreq);

pub const SIOCGIFMAC = _IOWR('i', 130, ifreq);
pub const SIOCSIFMAC = _IOW('i', 131, ifreq);
pub const SIOCSIFKPI = _IOW('i', 134, ifreq);
pub const SIOCGIFKPI = _IOWR('i', 135, ifreq);

pub const SIOCGIFWAKEFLAGS = _IOWR('i', 136, ifreq);

pub const SIOCGIFFUNCTIONALTYPE = _IOWR('i', 173, ifreq);

pub const SIOCSIF6LOWPAN = _IOW('i', 196, ifreq);
pub const SIOCGIF6LOWPAN = _IOWR('i', 197, ifreq);

pub inline fn ioctl0(fd: usize, cmd: usize) usize {
    return syscall.syscall3(syscall.SYS_ioctl, fd, cmd);
}

pub inline fn ioctl(comptime T: type, fd: usize, cmd: usize, arg: *T) usize {
    return syscall.syscall3(syscall.SYS_ioctl, fd, cmd, @ptrToInt(arg));
}
