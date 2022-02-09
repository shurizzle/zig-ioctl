const syscall = @import("syscall");

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

inline fn _IOC(dir: comptime_int, typ: comptime_int, nr: comptime_int, size: comptime_int) comptime_int {
    return (dir << _IOC_DIRMASK) | (typ << _IOC_TYPESHIFT) | (nr << _IOC_NRSHIFT) | (size << _IOC_SIZESHIFT);
}

inline fn _IOC_TYPECHECK(comptime T: type) comptime_int {
    return @sizeOf(T);
}

inline fn _IO(typ: comptime_int, nr: comptime_int) comptime_int {
    return _IOC(_IOC_NONE, typ, nr, 0);
}

inline fn _IOR(typ: comptime_int, nr: comptime_int, comptime size: type) comptime_int {
    return _IOC(_IOC_READ, typ, nr, _IOC_TYPECHECK(size));
}

inline fn _IOW(typ: comptime_int, nr: comptime_int, comptime size: type) comptime_int {
    return _IOC(_IOC_WRITE, typ, nr, _IOC_TYPECHECK(size));
}

inline fn _IOWR(typ: comptime_int, nr: comptime_int, comptime size: type) comptime_int {
    return _IOC(_IOC_READ | _IOC_WRITE, typ, nr, _IOC_TYPECHECK(size));
}

inline fn _IOR_BAD(typ: comptime_int, nr: comptime_int, comptime size: type) comptime_int {
    return _IOC(_IOC_READ, typ, nr, @sizeOf(size));
}

inline fn _IOW_BAD(typ: comptime_int, nr: comptime_int, comptime size: type) comptime_int {
    return _IOC(_IOC_WRITE, typ, nr, @sizeOf(size));
}

inline fn _IOWR_BAD(typ: comptime_int, nr: comptime_int, comptime size: type) comptime_int {
    return _IOC(_IOC_READ | _IOC_WRITE, typ, nr, @sizeOf(size));
}

inline fn _IOC_DIR(nr: comptime_int) comptime_int {
    return (nr >> _IOC_DIRSHIFT) & _IOC_DIRMASK;
}

inline fn _IOC_TYPE(nr: comptime_int) comptime_int {
    return (nr >> _IOC_TYPESHIFT) & _IOC_TYPEMASK;
}

inline fn _IOC_NR(nr: comptime_int) comptime_int {
    return (nr >> _IOC_NRSHIFT) & _IOC_NRMASK;
}

inline fn _IOC_SIZE(nr: comptime_int) comptime_int {
    return (nr >> _IOC_SIZESHIFT) & _IOC_SIZEMASK;
}

const _IOC_IN = _IOC_WRITE << _IOC_DIRSHIFT;
const _IOC_OUT = _IOC_READ << _IOC_DIRSHIFT;
const _IOC_INOUT = (_IOC_WRITE | _IOC_READ) << _IOC_DIRSHIFT;
const IOCSIZE_MASK = _IOC_SIZEMASK << _IOC_SIZESHIFT;
const IOCSIZE_SHIFT = _IOC_SIZESHIFT;

pub const SIOCADDRT = 0x890B;
pub const SIOCDELRT = 0x890C;
pub const SIOCRTMSG = 0x890D;

pub const SIOCGIFNAME = 0x8910;
pub const SIOCSIFLINK = 0x8911;
pub const SIOCGIFCONF = 0x8912;
pub const SIOCGIFFLAGS = 0x8913;
pub const SIOCSIFFLAGS = 0x8914;
pub const SIOCGIFADDR = 0x8915;
pub const SIOCSIFADDR = 0x8916;
pub const SIOCGIFDSTADDR = 0x8917;
pub const SIOCSIFDSTADDR = 0x8918;
pub const SIOCGIFBRDADDR = 0x8919;
pub const SIOCSIFBRDADDR = 0x891a;
pub const SIOCGIFNETMASK = 0x891b;
pub const SIOCSIFNETMASK = 0x891c;
pub const SIOCGIFMETRIC = 0x891d;
pub const SIOCSIFMETRIC = 0x891e;
pub const SIOCGIFMEM = 0x891f;
pub const SIOCSIFMEM = 0x8920;
pub const SIOCGIFMTU = 0x8921;
pub const SIOCSIFMTU = 0x8922;
pub const SIOCSIFNAME = 0x8923;
pub const SIOCSIFHWADDR = 0x8924;
pub const SIOCGIFENCAP = 0x8925;
pub const SIOCSIFENCAP = 0x8926;
pub const SIOCGIFHWADDR = 0x8927;
pub const SIOCGIFSLAVE = 0x8929;
pub const SIOCSIFSLAVE = 0x8930;
pub const SIOCADDMULTI = 0x8931;
pub const SIOCDELMULTI = 0x8932;
pub const SIOCGIFINDEX = 0x8933;
pub const SIOGIFINDEX = SIOCGIFINDEX;
pub const SIOCSIFPFLAGS = 0x8934;
pub const SIOCGIFPFLAGS = 0x8935;
pub const SIOCDIFADDR = 0x8936;
pub const SIOCSIFHWBROADCAST = 0x8937;
pub const SIOCGIFCOUNT = 0x8938;

pub const SIOCGIFBR = 0x8940;
pub const SIOCSIFBR = 0x8941;

pub const SIOCGIFTXQLEN = 0x8942;
pub const SIOCSIFTXQLEN = 0x8943;

pub const SIOCDARP = 0x8953;
pub const SIOCGARP = 0x8954;
pub const SIOCSARP = 0x8955;

pub const SIOCDRARP = 0x8960;
pub const SIOCGRARP = 0x8961;
pub const SIOCSRARP = 0x8962;

pub const SIOCGIFMAP = 0x8970;
pub const SIOCSIFMAP = 0x8971;

pub const SIOCADDDLCI = 0x8980;
pub const SIOCDELDLCI = 0x8981;

pub const SIOCDEVPRIVATE = 0x89F0;

pub const SIOCPROTOPRIVATE = 0x89E0;

pub const TCGETS = 0x5401;
pub const TCSETS = 0x5402;
pub const TCSETSW = 0x5403;
pub const TCSETSF = 0x5404;
pub const TCGETA = 0x5405;
pub const TCSETA = 0x5406;
pub const TCSETAW = 0x5407;
pub const TCSETAF = 0x5408;
pub const TCSBRK = 0x5409;
pub const TCXONC = 0x540A;
pub const TCFLSH = 0x540B;
pub const TIOCEXCL = 0x540C;
pub const TIOCNXCL = 0x540D;
pub const TIOCSCTTY = 0x540E;
pub const TIOCGPGRP = 0x540F;
pub const TIOCSPGRP = 0x5410;
pub const TIOCOUTQ = 0x5411;
pub const TIOCSTI = 0x5412;
pub const TIOCGWINSZ = 0x5413;
pub const TIOCSWINSZ = 0x5414;
pub const TIOCMGET = 0x5415;
pub const TIOCMBIS = 0x5416;
pub const TIOCMBIC = 0x5417;
pub const TIOCMSET = 0x5418;
pub const TIOCGSOFTCAR = 0x5419;
pub const TIOCSSOFTCAR = 0x541A;
pub const FIONREAD = 0x541B;
pub const TIOCINQ = FIONREAD;
pub const TIOCLINUX = 0x541C;
pub const TIOCCONS = 0x541D;
pub const TIOCGSERIAL = 0x541E;
pub const TIOCSSERIAL = 0x541F;
pub const TIOCPKT = 0x5420;
pub const FIONBIO = 0x5421;
pub const TIOCNOTTY = 0x5422;
pub const TIOCSETD = 0x5423;
pub const TIOCGETD = 0x5424;
pub const TCSBRKP = 0x5425;
pub const TIOCSBRK = 0x5427;
pub const TIOCCBRK = 0x5428;
pub const TIOCGSID = 0x5429;
pub const TCGETS2 = _IOR('T', 0x2A, termios2);
pub const TCSETS2 = _IOW('T', 0x2B, termios2);
pub const TCSETSW2 = _IOW('T', 0x2C, termios2);
pub const TCSETSF2 = _IOW('T', 0x2D, termios2);
pub const TIOCGRS485 = 0x542E;
pub const TIOCSRS485 = 0x542F;
pub const TIOCGPTN = _IOR('T', 0x30, c_uint);
pub const TIOCSPTLCK = _IOW('T', 0x31, c_int);
pub const TIOCGDEV = _IOR('T', 0x32, c_uint);
pub const TCGETX = 0x5432;
pub const TCSETX = 0x5433;
pub const TCSETXF = 0x5434;
pub const TCSETXW = 0x5435;
pub const TIOCSIG = _IOW('T', 0x36, c_int);
pub const TIOCVHANGUP = 0x5437;
pub const TIOCGPKT = _IOR('T', 0x38, c_int);
pub const TIOCGPTLCK = _IOR('T', 0x39, c_int);
pub const TIOCGEXCL = _IOR('T', 0x40, c_int);
pub const TIOCGPTPEER = _IO('T', 0x41);
pub const TIOCGISO7816 = _IOR('T', 0x42, serial_iso7816);
pub const TIOCSISO7816 = _IOWR('T', 0x43, serial_iso7816);

pub const FIONCLEX = 0x5450;
pub const FIOCLEX = 0x5451;
pub const FIOASYNC = 0x5452;
pub const TIOCSERCONFIG = 0x5453;
pub const TIOCSERGWILD = 0x5454;
pub const TIOCSERSWILD = 0x5455;
pub const TIOCGLCKTRMIOS = 0x5456;
pub const TIOCSLCKTRMIOS = 0x5457;
pub const TIOCSERGSTRUCT = 0x5458;
pub const TIOCSERGETLSR = 0x5459;
pub const TIOCSERGETMULTI = 0x545A;
pub const TIOCSERSETMULTI = 0x545B;

pub const TIOCMIWAIT = 0x545C;
pub const TIOCGICOUNT = 0x545D;

pub const FIOQSIZE = 0x5460;

pub const TIOCPKT_DATA = 0;
pub const TIOCPKT_FLUSHREAD = 1;
pub const TIOCPKT_FLUSHWRITE = 2;
pub const TIOCPKT_STOP = 4;
pub const TIOCPKT_START = 8;
pub const TIOCPKT_NOSTOP = 16;
pub const TIOCPKT_DOSTOP = 32;
pub const TIOCPKT_IOCTL = 64;

pub const TIOCSER_TEMT = 0x01;

pub const TIOCM_LE = 0x001;
pub const TIOCM_DTR = 0x002;
pub const TIOCM_RTS = 0x004;
pub const TIOCM_ST = 0x008;
pub const TIOCM_SR = 0x010;
pub const TIOCM_CTS = 0x020;
pub const TIOCM_CAR = 0x040;
pub const TIOCM_RNG = 0x080;
pub const TIOCM_DSR = 0x100;
pub const TIOCM_CD = TIOCM_CAR;
pub const TIOCM_RI = TIOCM_RNG;

pub const N_TTY = 0;
pub const N_SLIP = 1;
pub const N_MOUSE = 2;
pub const N_PPP = 3;
pub const N_STRIP = 4;
pub const N_AX25 = 5;
pub const N_X25 = 6;
pub const N_6PACK = 7;
pub const N_MASC = 8;
pub const N_R3964 = 9;
pub const N_PROFIBUS_FDL = 10;
pub const N_IRDA = 11;
pub const N_SMSBLOCK = 12;
pub const N_HDLC = 13;
pub const N_SYNC_PPP = 14;
pub const N_HCI = 15;

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
pub inline fn SER_ISO7816_T(t: comptime_int) comptime_int {
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

pub inline fn ioctl0(fd: usize, cmd: usize) usize {
    return syscall.syscall3(syscall.SYS_ioctl, fd, cmd);
}

pub inline fn ioctl(comptime T: type, fd: usize, cmd: usize, arg: *T) usize {
    return syscall.syscall3(syscall.SYS_ioctl, fd, cmd, @ptrToInt(arg));
}
