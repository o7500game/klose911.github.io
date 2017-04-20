#include <termios.h>
#include "apue.h"

int main(void)
{
        struct termios term;
        long vdisible;

        if(0 == isatty(STDIN_FILENO) )
                err_quit("standard input is not a terminal device");

        //��ȡ_POSIX_VDISABLE����
        if( (vdisible = fpathconf(STDIN_FILENO, _PC_VDISABLE)) < 0)
                err_quit("fpathconf error or _POSIX_VDISABLE not in effect");

        if(tcgetattr(STDIN_FILENO, &term) < 0)
                err_sys("tcgetattr error");

        term.c_cc[VINTR] = vdisible; //��ֹ INTR �ַ��� ���ǲ���ֹINTR�źţ� �Ծɿ���ʹ��kill����
        term.c_cc[VEOF] = 2; //�޸�EOFΪ CTRL+B

        if(tcsetattr(STDIN_FILENO, TCSAFLUSH, &term) < 0)
                err_sys("tcsetattr error");

        exit(0);

        
}
