# MariaDB Starting Problem Resolution

During the setup and verification phase, an issue was encountered where the MariaDB server could not be started or connected to, resulting in a "Can't connect to local server through socket" error.

## Problem Analysis

1.  **Initial Attempt:** The `mariadb-server start` command was initially used, which failed with a "command not found" error.
2.  **Executable Location:** A search for the `mysqld` executable using `find $PREFIX/bin -name "mysqld"` revealed its location at `/data/data/com.termux/files/usr/bin/mysqld`. This confirmed that MariaDB was installed, but the `mariadb-server` wrapper script was either missing or not in the system's PATH.

## Solution

The problem was resolved by directly executing the `mysqld` binary with the necessary parameters to ensure it started correctly in the Termux environment.

1.  **Direct Execution Command:**
    ```bash
    /data/data/com.termux/files/usr/bin/mysqld \
        --basedir=/data/data/com.termux/files/usr \
        --datadir=/data/data/com.termux/files/usr/var/lib/mysql \
        --pid-file=/data/data/com.termux/files/usr/var/run/mysqld.pid \
        --socket=/data/data/com.termux/files/usr/var/run/mysqld.sock \
        --port=3306 &> /dev/null &
    ```
    *   `--basedir`: Specifies the base installation directory.
    *   `--datadir`: Specifies the directory where MariaDB stores its databases.
    *   `--pid-file`: Specifies the file where the process ID of the MariaDB server is written.
    *   `--socket`: Specifies the Unix socket file to use for local connections.
    *   `--port`: Specifies the TCP/IP port to listen on.
    *   `&> /dev/null &`: Runs the command in the background and redirects all output (stdout and stderr) to `/dev/null` to prevent it from cluttering the terminal.

2.  **Initialization Delay:** After starting the server, a `sleep 5` command was used to allow sufficient time for the MariaDB server to fully initialize before attempting to connect.

3.  **Verification:** The connection was successfully verified by listing the database tables using the `mariadb` client:
    ```bash
    sleep 5 && /data/data/com.termux/files/usr/bin/mariadb -u academic_user -pashraf -e 'use academic_center_db; show tables;'
    ```

## Conclusion

The issue was not a missing MariaDB installation, but rather a need to bypass the standard service management commands in Termux and directly invoke the `mysqld` executable with explicit path and configuration parameters. This allowed the database server to start and become accessible for further operations.
