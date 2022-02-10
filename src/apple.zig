const IOCPARM_MASK = 0x1fff;

fn IOCPARAM_LEN(x: comptime_int) comptime_int {
    return (x >> 16) & IOCPARM_MASK;
}

fn IOCBASECMD(x: comptime_int) comptime_int {
    return x & ~(IOCPARM_MASK << 16);
}

fn IOCGROUP(x: comptime_int) comptime_int {
    return (x >> 8) & 0xff;
}

const IOCPARM_MAX = (IOCPARM_MASK + 1);

const IOC_VOID = 0x20000000;

const IOC_OUT = 0x40000000;

const IOC_IN = 0x80000000;

const IOC_INOUT = IOC_IN | IOC_OUT;

const IOC_DIRMASK = 0xe0000000;

fn _IOC(comptime inout: comptime_int, comptime group: comptime_int, comptime num: comptime_int, comptime len: comptime_int) comptime_int {
    return inout | ((len & IOCPARM_MASK) << 16) | (group << 8) | num;
}

fn _IO(comptime g: comptime_int, comptime n: comptime_int) comptime_int {
    return _IOC(IOC_VOID, g, n, 0);
}

fn _IOR(comptime g: comptime_int, comptime n: comptime_int, comptime T: type) comptime_int {
    return _IOC(IOC_OUT, g, n, @sizeOf(T));
}

fn _IOW(comptime g: comptime_int, comptime n: comptime_int, comptime T: type) comptime_int {
    return _IOC(IOC_IN, g, n, @sizeOf(T));
}

fn _IOWR(comptime g: comptime_int, comptime n: comptime_int, comptime T: type) comptime_int {
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

pub const ttysize = packed struct {
    ts_lines: c_ushort,
    ts_cols: c_ushort,
    ts_xxx: c_ushort,
    ts_yyy: c_ushort,
};

pub const IF_NAMESIZE = 16;

pub const IFNAMSIZ = IF_NAMESIZE;

pub const sa_family_t = u8;

pub const sockaddr = packed struct {
    sa_len: u8,
    sa_family: sa_family_t,
    sa_data: [14]u8,
};

pub const caddr_t = *u8;

pub const ifdevmtu = packed struct {
    ifdm_current: c_int,
    ifdm_min: c_int,
    ifdm_max: c_int,
};

pub const ifkpi = packed struct {
    ifk_module_id: c_uint,
    ifk_type: c_uint,
    ifk_data: packed union {
        ifk_ptr: *void,
        ifk_value: c_int,
    },
};

pub const ifreq = packed struct {
    ifr_name: [IFNAMSIZ]u8,

    ifr_ifru: packed union {
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
    ifc_ifcu: packed union {
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

pub const TIOCPKT = enum(usize) {
    data = 0x00,
    flushread = 0x01,
    flushwrite = 0x02,
    stop = 0x04,
    start = 0x08,
    nostop = 0x10,
    dostop = 0x20,
    ioctl = 0x40,
};

pub const TIOCM = enum(usize) {
    le = 0o001,
    dtr = 0o0002,
    rts = 0o0004,
    st = 0o0010,
    sr = 0o0020,
    cts = 0o0040,
    car = 0o0100,
    // cd = .car,
    rng = 0o0200,
    // ri = .rng,
    dsr = 0o0400,
};

pub const CMD = enum(usize) {
    tiocmodg = _IOR('t', 3, c_int),
    tiocmods = _IOW('t', 4, c_int),

    tiocexcl = _IO('t', 13),
    tiocnxcl = _IO('t', 14),

    tiocflush = _IOW('t', 16, c_int),

    tiocgeta = _IOR('t', 19, termios),
    tiocseta = _IOW('t', 20, termios),
    tiocsetaw = _IOW('t', 21, termios),
    tiocsetaf = _IOW('t', 22, termios),
    tiocgetd = _IOR('t', 26, c_int),
    tiocsetd = _IOW('t', 27, c_int),
    tiocixon = _IO('t', 129),
    tiocixoff = _IO('t', 128),

    tiocsbrk = _IO('t', 123),
    tioccbrk = _IO('t', 122),
    tiocsdtr = _IO('t', 121),
    tioccdtr = _IO('t', 120),
    tiocgpgrp = _IOR('t', 119, c_int),
    tiocspgrp = _IOW('t', 118, c_int),
    tiocoutq = _IOR('t', 115, c_int),
    tiocsti = _IOW('t', 114, i8),
    tiocnotty = _IO('t', 113),
    tiocpkt = _IOW('t', 112, c_int),
    tiocstop = _IO('t', 111),
    tiocstart = _IO('t', 110),
    tiocmset = _IOW('t', 109, c_int),
    tiocmbis = _IOW('t', 108, c_int),
    tiocmbic = _IOW('t', 107, c_int),
    tiocmget = _IOR('t', 106, c_int),
    tiocremote = _IOW('t', 105, c_int),
    tiocgwinsz = _IOR('t', 104, winsize),
    tiocswinsz = _IOW('t', 103, winsize),
    tiocucntl = _IOW('t', 102, c_int),
    tiocstat = _IO('t', 101),
    tiocscons = _IO('t', 99),
    tioccons = _IOW('t', 98, c_int),
    tiocsctty = _IO('t', 97),
    tiocext = _IOW('t', 96, c_int),
    tiocsig = _IO('t', 95),
    tiocdrain = _IO('t', 94),
    tiocmsdtrwait = _IOW('t', 91, c_int),
    tiocmgdtrwait = _IOR('t', 90, c_int),
    tioctimestamp = _IOR('t', 89, timeval),
    tiocdcdtimestamp = _IOR('t', 88, timeval),
    tiocsdrainwait = _IOW('t', 87, c_int),
    tiocgdrainwait = _IOR('t', 86, c_int),
    tiocdsimicrocode = _IO('t', 85),
    tiocptygrant = _IO('t', 84),
    tiocptygname = _IOC(IOC_OUT, 't', 83, 128),
    tiocptyunlk = _IO('t', 82),

    ttydisc = 0,
    tabldisc = 3,
    slipdisc = 4,
    pppdisc = 5,

    // tiocgsize = .tiocgwinsz,
    // tiocssize = .tiocswinsz,

    fioclex = _IO('f', 1),
    fionclex = _IO('f', 2),
    fionread = _IOR('f', 127, c_int),
    fionbio = _IOW('f', 126, c_int),
    fioasync = _IOW('f', 125, c_int),
    fiosetown = _IOW('f', 124, c_int),
    fiogetown = _IOR('f', 123, c_int),
    fiodtype = _IOR('f', 122, c_int),

    siocshiwat = _IOW('s', 0, c_int),
    siocghiwat = _IOR('s', 1, c_int),
    siocslowat = _IOW('s', 2, c_int),
    siocglowat = _IOR('s', 3, c_int),
    siocatmark = _IOR('s', 7, c_int),
    siocspgrp = _IOW('s', 8, c_int),
    siocgpgrp = _IOR('s', 9, c_int),

    siocsifaddr = _IOW('i', 12, ifreq),
    siocsifdstaddr = _IOW('i', 14, ifreq),
    siocsifflags = _IOW('i', 16, ifreq),
    siocgifflags = _IOWR('i', 17, ifreq),
    siocsifbrdaddr = _IOW('i', 19, ifreq),
    siocsifnetmask = _IOW('i', 22, ifreq),
    siocgifmetric = _IOWR('i', 23, ifreq),
    siocsifmetric = _IOW('i', 24, ifreq),
    siocdifaddr = _IOW('i', 25, ifreq),
    siocaifaddr = _IOW('i', 26, ifaliasreq),

    siocgifaddr = _IOWR('i', 33, ifreq),
    siocgifdstaddr = _IOWR('i', 34, ifreq),
    siocgifbrdaddr = _IOWR('i', 35, ifreq),
    siocgifconf = _IOWR('i', 36, ifconf),
    siocgifnetmask = _IOWR('i', 37, ifreq),
    siocautoaddr = _IOWR('i', 38, ifreq),
    siocautonetmask = _IOW('i', 39, ifreq),
    siocarpipll = _IOWR('i', 40, ifreq),

    siocaddmulti = _IOW('i', 49, ifreq),
    siocdelmulti = _IOW('i', 50, ifreq),
    siocgifmtu = _IOWR('i', 51, ifreq),
    siocsifmtu = _IOW('i', 52, ifreq),
    siocgifphys = _IOWR('i', 53, ifreq),
    siocsifphys = _IOW('i', 54, ifreq),
    siocsifmedia = _IOWR('i', 55, ifreq),

    siocgifmedia = _IOWR('i', 56, ifmediareq),

    siocsifgeneric = _IOW('i', 57, ifreq),
    siocgifgeneric = _IOWR('i', 58, ifreq),
    siocrslvmulti = _IOWR('i', 59, rslvmulti_req),

    siocsiflladdr = _IOW('i', 60, ifreq),
    siocgifstatus = _IOWR('i', 61, ifstat),
    siocsifphyaddr = _IOW('i', 62, ifaliasreq),
    siocgifpsrcaddr = _IOWR('i', 63, ifreq),
    siocgifpdstaddr = _IOWR('i', 64, ifreq),
    siocdifphyaddr = _IOW('i', 65, ifreq),

    siocgifdevmtu = _IOWR('i', 68, ifreq),
    siocsifaltmtu = _IOW('i', 69, ifreq),
    siocgifaltmtu = _IOWR('i', 72, ifreq),
    siocsifbond = _IOW('i', 70, ifreq),
    siocgifbond = _IOWR('i', 71, ifreq),

    siocgifxmedia = _IOWR('i', 72, ifmediareq),

    siocsifcap = _IOW('i', 90, ifreq),
    siocgifcap = _IOWR('i', 91, ifreq),

    siocifcreate = _IOWR('i', 120, ifreq),
    siocifdestroy = _IOW('i', 121, ifreq),
    siocifcreate2 = _IOWR('i', 122, ifreq),

    siocsdrvspec = _IOW('i', 123, ifdrv),

    siocgdrvspec = _IOWR('i', 123, ifdrv),

    siocsifvlan = _IOW('i', 126, ifreq),
    siocgifvlan = _IOWR('i', 127, ifreq),

    // siocsetvlan = .siocsifvlan,
    // siocgetvlan = .siocgifvlan,

    siocifgcloners = _IOWR('i', 129, if_clonereq),

    siocgifasyncmap = _IOWR('i', 124, ifreq),
    siocsifasyncmap = _IOW('i', 125, ifreq),

    siocgifmac = _IOWR('i', 130, ifreq),
    siocsifmac = _IOW('i', 131, ifreq),
    siocsifkpi = _IOW('i', 134, ifreq),
    siocgifkpi = _IOWR('i', 135, ifreq),

    siocgifwakeflags = _IOWR('i', 136, ifreq),

    siocgiffunctionaltype = _IOWR('i', 173, ifreq),

    siocsif6lowpan = _IOW('i', 196, ifreq),
    siocgif6lowpan = _IOWR('i', 197, ifreq),
};
