const _IOC_NRBITS = 8;
const _IOC_TYPEBITS = 8;
const _IOC_SIZEBITS = 14;
const _IOC_DIRBITS = 2;

const _IOC_NRMASK = ((1 << _IOC_NRBITS) - 1);
const _IOC_TYPEMASK = ((1 << _IOC_TYPEBITS) - 1);
const _IOC_SIZEMASK = ((1 << _IOC_SIZEBITS) - 1);
const _IOC_DIRMASK = ((1 << _IOC_DIRBITS) - 1);

const _IOC_NRSHIFT = 0;
const _IOC_TYPESHIFT = (_IOC_NRSHIFT + _IOC_NRBITS);
const _IOC_SIZESHIFT = (_IOC_TYPESHIFT + _IOC_TYPEBITS);
const _IOC_DIRSHIFT = (_IOC_SIZESHIFT + _IOC_SIZEBITS);

const _IOC_NONE = 0;
const _IOC_WRITE = 1;
const _IOC_READ = 2;

fn _IOC(comptime dir: comptime_int, comptime typ: comptime_int, comptime nr: comptime_int, comptime size: comptime_int) comptime_int {
    return (dir << _IOC_DIRSHIFT) | (typ << _IOC_TYPESHIFT) | (nr << _IOC_NRSHIFT) | (size << _IOC_SIZESHIFT);
}

fn _IOC_TYPECHECK(comptime T: type) comptime_int {
    return @sizeOf(T);
}

fn _IO(comptime typ: comptime_int, comptime nr: comptime_int) comptime_int {
    return _IOC(_IOC_NONE, typ, nr, 0);
}

fn _IOR(comptime typ: comptime_int, comptime nr: comptime_int, comptime size: type) comptime_int {
    return _IOC(_IOC_READ, typ, nr, _IOC_TYPECHECK(size));
}

fn _IOW(comptime typ: comptime_int, comptime nr: comptime_int, comptime size: type) comptime_int {
    return _IOC(_IOC_WRITE, typ, nr, _IOC_TYPECHECK(size));
}

fn _IOWR(comptime typ: comptime_int, comptime nr: comptime_int, comptime size: type) comptime_int {
    return _IOC(_IOC_READ | _IOC_WRITE, typ, nr, _IOC_TYPECHECK(size));
}

fn _IOR_BAD(comptime typ: comptime_int, comptime nr: comptime_int, comptime size: type) comptime_int {
    return _IOC(_IOC_READ, typ, nr, @sizeOf(size));
}

fn _IOW_BAD(comptime typ: comptime_int, comptime nr: comptime_int, comptime size: type) comptime_int {
    return _IOC(_IOC_WRITE, typ, nr, @sizeOf(size));
}

fn _IOWR_BAD(comptime typ: comptime_int, comptime nr: comptime_int, comptime size: type) comptime_int {
    return _IOC(_IOC_READ | _IOC_WRITE, typ, nr, @sizeOf(size));
}

fn _IOC_DIR(comptime nr: comptime_int) comptime_int {
    return (nr >> _IOC_DIRSHIFT) & _IOC_DIRMASK;
}

fn _IOC_TYPE(comptime nr: comptime_int) comptime_int {
    return (nr >> _IOC_TYPESHIFT) & _IOC_TYPEMASK;
}

fn _IOC_NR(comptime nr: comptime_int) comptime_int {
    return (nr >> _IOC_NRSHIFT) & _IOC_NRMASK;
}

fn _IOC_SIZE(comptime nr: comptime_int) comptime_int {
    return (nr >> _IOC_SIZESHIFT) & _IOC_SIZEMASK;
}

const _IOC_IN = _IOC_WRITE << _IOC_DIRSHIFT;
const _IOC_OUT = _IOC_READ << _IOC_DIRSHIFT;
const _IOC_INOUT = (_IOC_WRITE | _IOC_READ) << _IOC_DIRSHIFT;
const IOCSIZE_MASK = _IOC_SIZEMASK << _IOC_SIZESHIFT;
const IOCSIZE_SHIFT = _IOC_SIZESHIFT;

pub const CMD = enum(usize) {
    siocaddrt = 0x890B,
    siocdelrt = 0x890C,
    siocrtmsg = 0x890D,

    siocgifname = 0x8910,
    siocsiflink = 0x8911,
    siocgifconf = 0x8912,
    siocgifflags = 0x8913,
    siocsifflags = 0x8914,
    siocgifaddr = 0x8915,
    siocsifaddr = 0x8916,
    siocgifdstaddr = 0x8917,
    siocsifdstaddr = 0x8918,
    siocgifbrdaddr = 0x8919,
    siocsifbrdaddr = 0x891a,
    siocgifnetmask = 0x891b,
    siocsifnetmask = 0x891c,
    siocgifmetric = 0x891d,
    siocsifmetric = 0x891e,
    siocgifmem = 0x891f,
    siocsifmem = 0x8920,
    siocgifmtu = 0x8921,
    siocsifmtu = 0x8922,
    siocsifname = 0x8923,
    siocsifhwaddr = 0x8924,
    siocgifencap = 0x8925,
    siocsifencap = 0x8926,
    siocgifhwaddr = 0x8927,
    siocgifslave = 0x8929,
    siocsifslave = 0x8930,
    siocaddmulti = 0x8931,
    siocdelmulti = 0x8932,
    siocgifindex = 0x8933,
    // siogifindex = .siocgifindex,
    siocsifpflags = 0x8934,
    siocgifpflags = 0x8935,
    siocdifaddr = 0x8936,
    siocsifhwbroadcast = 0x8937,
    siocgifcount = 0x8938,

    siocgifbr = 0x8940,
    siocsifbr = 0x8941,

    siocgiftxqlen = 0x8942,
    siocsiftxqlen = 0x8943,

    siocdarp = 0x8953,
    siocgarp = 0x8954,
    siocsarp = 0x8955,

    siocdrarp = 0x8960,
    siocgrarp = 0x8961,
    siocsrarp = 0x8962,

    siocgifmap = 0x8970,
    siocsifmap = 0x8971,

    siocadddlci = 0x8980,
    siocdeldlci = 0x8981,

    siocdevprivate = 0x89F0,

    siocprotoprivate = 0x89E0,

    tcgets = 0x5401,
    tcsets = 0x5402,
    tcsetsw = 0x5403,
    tcsetsf = 0x5404,
    tcgeta = 0x5405,
    tcseta = 0x5406,
    tcsetaw = 0x5407,
    tcsetaf = 0x5408,
    tcsbrk = 0x5409,
    tcxonc = 0x540A,
    tcflsh = 0x540B,
    tiocexcl = 0x540C,
    tiocnxcl = 0x540D,
    tiocsctty = 0x540E,
    tiocgpgrp = 0x540F,
    tiocspgrp = 0x5410,
    tiocoutq = 0x5411,
    tiocsti = 0x5412,
    tiocgwinsz = 0x5413,
    tiocswinsz = 0x5414,
    tiocmget = 0x5415,
    tiocmbis = 0x5416,
    tiocmbic = 0x5417,
    tiocmset = 0x5418,
    tiocgsoftcar = 0x5419,
    tiocssoftcar = 0x541A,
    fionread = 0x541B,
    // tiocinq = .fionread,
    tioclinux = 0x541C,
    tioccons = 0x541D,
    tiocgserial = 0x541E,
    tiocsserial = 0x541F,
    tiocpkt = 0x5420,
    fionbio = 0x5421,
    tiocnotty = 0x5422,
    tiocsetd = 0x5423,
    tiocgetd = 0x5424,
    tcsbrkp = 0x5425,
    tiocsbrk = 0x5427,
    tioccbrk = 0x5428,
    tiocgsid = 0x5429,
    tcgets2 = _IOR('T', 0x2A, termios2),
    tcsets2 = _IOW('T', 0x2B, termios2),
    tcsetsw2 = _IOW('T', 0x2C, termios2),
    tcsetsf2 = _IOW('T', 0x2D, termios2),
    tiocgrs485 = 0x542E,
    tiocsrs485 = 0x542F,
    tiocgptn = _IOR('T', 0x30, c_uint),
    tiocsptlck = _IOW('T', 0x31, c_int),
    tiocgdev = _IOR('T', 0x32, c_uint),
    tcgetx = 0x5432,
    tcsetx = 0x5433,
    tcsetxf = 0x5434,
    tcsetxw = 0x5435,
    tiocsig = _IOW('T', 0x36, c_int),
    tiocvhangup = 0x5437,
    tiocgpkt = _IOR('T', 0x38, c_int),
    tiocgptlck = _IOR('T', 0x39, c_int),
    tiocgexcl = _IOR('T', 0x40, c_int),
    tiocgptpeer = _IO('T', 0x41),
    tiocgiso7816 = _IOR('T', 0x42, serial_iso7816),
    tiocsiso7816 = _IOWR('T', 0x43, serial_iso7816),

    fionclex = 0x5450,
    fioclex = 0x5451,
    fioasync = 0x5452,
    tiocserconfig = 0x5453,
    tiocsergwild = 0x5454,
    tiocserswild = 0x5455,
    tiocglcktrmios = 0x5456,
    tiocslcktrmios = 0x5457,
    tiocsergstruct = 0x5458,
    tiocsergetlsr = 0x5459,
    tiocsergetmulti = 0x545A,
    tiocsersetmulti = 0x545B,

    tiocmiwait = 0x545C,
    tiocgicount = 0x545D,

    fioqsize = 0x5460,
};

pub const TIOCPKT = enum(usize) {
    data = 0,
    flushread = 1,
    flushwrite = 2,
    stop = 4,
    start = 8,
    nostop = 16,
    dostop = 32,
    ioctl = 64,
};

pub const TIOCSER = enum(usize) { temt = 0x01 };

pub const TIOCM = enum(usize) {
    le = 0x001,
    dtr = 0x002,
    rts = 0x004,
    st = 0x008,
    sr = 0x010,
    cts = 0x020,
    car = 0x040,
    rng = 0x080,
    dsr = 0x100,
    // cd = .car,
    // ri = .rng,
};

pub const N = enum(usize) {
    tty = 0,
    slip = 1,
    mouse = 2,
    ppp = 3,
    strip = 4,
    ax25 = 5,
    x25 = 6,
    @"6pack" = 7,
    masc = 8,
    r3964 = 9,
    profibus_fdl = 10,
    irda = 11,
    smsblock = 12,
    hdlc = 13,
    sync_ppp = 14,
    hci = 15,
};

pub const NCC = 8;

pub const winsize = packed struct {
    ws_row: c_ushort,
    ws_col: c_ushort,
    ws_xpixel: c_ushort,
    ws_ypixel: c_ushort,
};

pub const termio = packed struct {
    c_iflag: c_ushort,
    c_oflag: c_ushort,
    c_cflag: c_ushort,
    c_lflag: c_ushort,
    c_line: u8,
    c_cc: [NCC]u8,
};

pub const cc_t = u8;
pub const speed_t = c_uint;
pub const tcflag_t = c_uint;

pub const NCCS = 19;

pub const termios = packed struct {
    c_iflag: tcflag_t,
    c_oflag: tcflag_t,
    c_cflag: tcflag_t,
    c_lflag: tcflag_t,
    c_line: cc_t,
    c_cc: [NCCS]cc_t,
};

pub const termios2 = packed struct {
    c_iflag: tcflag_t,
    c_oflag: tcflag_t,
    c_cflag: tcflag_t,
    c_lflag: tcflag_t,
    c_line: cc_t,
    c_cc: [NCCS]cc_t,
    c_ispeed: speed_t,
    c_ospeed: speed_t,
};

pub const ktermios = packed struct {
    c_iflag: tcflag_t,
    c_oflag: tcflag_t,
    c_cflag: tcflag_t,
    c_lflag: tcflag_t,
    c_line: cc_t,
    c_cc: [NCCS]cc_t,
    c_ispeed: speed_t,
    c_ospeed: speed_t,
};

pub const SER_ISO7816_ENABLED = (1 << 0);
pub const SER_ISO7816_T_PARAM = (0x0f << 4);
pub inline fn SER_ISO7816_T(comptime t: comptime_int) comptime_int {
    return (t & 0x0f) << 4;
}

pub const serial_iso7816 = packed struct {
    flags: u32,
    tg: u32,
    sc_fi: u32,
    sc_di: u32,
    clk: u32,
    reserved: [5]u32,
};
