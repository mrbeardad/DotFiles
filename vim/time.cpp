#include <iostream>
#include <chrono>
#include <string>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>

using namespace std ;

int main( int argc, char *argv[] )
{
    ios::sync_with_stdio(false) ;
    cin.tie(nullptr) ;

    cout << "\e[32m[RUNNING]" ;
    string coutStrStdin, coutStrStdout, coutStrRedirect ; // 用于输出提示，以及调用open()函数
    int childArgsIdx{1} ;

    if ( auto argv1 = argv[1]; argv1 == "-i"s ) {
        if ( 2 == argc ) {
            cout << "\e[31mQuickrun Error:\e[m no argument for '-i'" << endl ;
            return EXIT_FAILURE ;
        }
        childArgsIdx = 3 ;
        coutStrStdin = argv[2] ;
        coutStrRedirect += " < "s + argv[2] ;
        if ( auto argv3 = argv[3]; argv3 == "-o"s ) {
            if ( 4 == argc ) {
                cout << "\e[31mQuickrun Error:\e[m no argument for '-o'" << endl ;
                return EXIT_FAILURE ;
            }
            childArgsIdx = 5 ;
            coutStrStdout = argv[4] ;
            coutStrRedirect += " > " + coutStrStdout ;
        }
    } else if ( auto argv1 = argv[1]; argv1 == "-o"s ) {
        if ( 2 == argc ) {
            cout << "\e[31mQuickrun Error:\e[m no argument for '-o'" << endl ;
            return EXIT_FAILURE ;
        }
        childArgsIdx = 3 ;
        coutStrStdout = argv[2] ;
        coutStrRedirect += " > " + coutStrStdout ;
        if ( auto argv3 = argv[3]; argv3 == "-i"s ) {
            if ( 4 == argc ) {
                cout << "\e[31mQuickrun Error:\e[m no argument for '-i'" << endl ;
                return EXIT_FAILURE ;
            }
            childArgsIdx = 5 ;
            coutStrStdin = argv[4] ;
            coutStrRedirect += " < " + coutStrStdin ;
        }
    }

    for ( int i = childArgsIdx; i < argc; ++i ) {
        cout << ' ' << argv[i] ;
    }
    cout << coutStrRedirect ;
    cout << "\n\n\e[m-----------------------------------------------------------------" << endl ; // 注意冲刷防止fork()的子进程冲刷该缓冲区

    auto runtime_begin = chrono::steady_clock::now() ;
    if ( fork() == 0 ) {
        if ( coutStrStdin.size() ) {
            auto fd = open( coutStrStdin.data(), O_RDONLY ) ;
            dup2( fd, 0 ) ;
        }
        if (coutStrStdout.size()) {
            auto fd = open( coutStrStdout.data(), O_RDWR | O_CREAT, 0644 ) ;
            dup2( fd, 1 ) ;
        }
        if ( execv( argv[childArgsIdx], &argv[childArgsIdx] ) != 1 ) {
            cout << "\e[31mQuickrun Error: \e[33mOh~ my dear! Please give me the correct and complete execute path, OK?!" << endl ;
            exit(1) ;
        }
    }

    string exitString ;
    int status ;
    wait(&status) ;
    chrono::microseconds runtimelen = chrono::duration_cast<chrono::microseconds>(chrono::steady_clock::now() - runtime_begin) ;

    if ( WIFEXITED(status) ) {
        if ( int exitCode = WEXITSTATUS(status); exitCode == 0 ) {
            exitString = "\e[1;32mcode=0\e[m" ;
        } else {
            exitString = "\e[1;33mcode=" + to_string(exitCode) + "\e[m" ;
        }
    } else if ( WIFSIGNALED(status) ) {
        int signalNum{ WTERMSIG(status) } ;
        const char* signalName ;
        exitString = "\e[1;31mSignal=" + to_string(signalNum) ;
        switch (signalNum) {
            case 1:
                signalName = " SIGHUP " ;
                break ;
            case 2:
                signalName = " SIGINT " ;
                break ;
            case 3:
                signalName = " SIGQUIT " ;
                break ;
            case 4:
                signalName = " SIGILL " ;
                break ;
            case 5:
                signalName = " SIGTRAP " ;
                break ;
            case 6:
                signalName = " SIGABRT " ;
                break ;
            case 7:
                signalName = " SIGBUS " ;
                break ;
            case 8:
                signalName = " SIGFPE " ;
                break ;
            case 9:
                signalName = " SIGKILL " ;
                break ;
            case 10:
                signalName = " SIGUSR1 " ;
                break ;
            case 11:
                signalName = " SIGSEGV " ;
                break ;
            case 12:
                signalName = " SIGUSR2 " ;
                break ;
            case 13:
                signalName = " SIGPIPE " ;
                break ;
            case 14:
                signalName = " SIGALRM " ;
                break ;
            case 15:
                signalName = " SIGTERM " ;
                break ;
            case 16:
                signalName = " SIGSTKFLT " ;
                break ;
            case 17:
                signalName = " SIGCHLD " ;
                break ;
            case 18:
                signalName = " SIGCONT " ;
                break ;
            case 19:
                signalName = " SIGSTOP " ;
                break ;
            case 20:
                signalName = " SIGTSTP " ;
                break ;
            case 21:
                signalName = " SIGTTIN " ;
                break ;
            case 22:
                signalName = " SIGTTOU " ;
                break ;
            case 23:
                signalName = " SIGURG " ;
                break ;
            case 24:
                signalName = " SIGXCPU " ;
                break ;
            case 25:
                signalName = " SIGXFSZ " ;
                break ;
            case 26:
                signalName = " SIGVTALRM " ;
                break ;
            case 27:
                signalName = " SIGPROF " ;
                break ;
            case 28:
                signalName = " SIGWINCH " ;
                break ;
            case 29:
                signalName = "SIGIO " ;
                break ;
            case 30:
                signalName = " SIGPWR " ;
                break ;
            case 31:
                signalName = " SIGSYS " ;
                break ;
            default:
                signalName = " UNKOWN " ;
        }
        exitString += signalName + "\e[m"s ;
    }

    double timeLen ;
    string timeUnit ;
    if (runtimelen.count() > 1e6) {
        timeLen = runtimelen.count()/1e6 ;
        timeUnit = " s." ;
    } else {
        timeLen = runtimelen.count()/1e3 ;
        timeUnit = " ms." ;
    }
    cout << "\n\e[32m[END]\e[m exit with " << exitString << " in \e[36m" << timeLen << timeUnit << endl ;

    return 0 ;
}
