coolbeevip/docker-alpine-mariadb
==============

启动
-----
~~~~
docker run \
    --name mariadb \
    -p 3306:3306 \
    -v ~/mydocker/docker_volume/docker-alpine-mariadb:/app \
    -e TZ=Asia/Shanghai \
    -e  MYSQL_ROOT_PASSWORD=root \
    -e  MYSQL_DATABASE=mydb \
    -e  MYSQL_USER=mydb-user \
    -e  MYSQL_PASSWORD=mydb-pass \
    coolbeevip/docker-alpine-mariadb

~~~~

my.cnf
-----

~~~~
    [client]
    port=3306
    default-character-set=utf8
    socket=$MYSQLBASE/mysql.sock

    [mysql]
    no-auto-rehash
    default-character-set=utf8

    [mysqld]
    #************** basic ***************
    basedir                         =$MYSQLBASE
    datadir                         =$MYSQLDATA
    tmpdir                          =$MYSQLTMP
    port                            =3306
    socket                          =$MYSQLBASE/mysql.sock
    log-error                       =$MYSQLLOG/mysql.err
    pid-file                        =$MYSQLBASE/mysql.pid

    #************** connection ***************
    max_connections                 =2000
    max_connect_errors              =100000
    max_user_connections            =300
    #************** sql timeout & limits ***************
    #max_join_size                   =1000000
    max_execution_time              =10000

    lock_wait_timeout               =60
    #autocommit                      =0
    lower_case_table_names          =1
    thread_cache_size               =64      #一般设置为100-200
    disabled_storage_engines        ="MyISAM,FEDERATED"
    character_set_server            =utf8
    transaction-isolation           ="READ-COMMITTED"
    skip_name_resolve               =ON
    explicit_defaults_for_timestamp =ON
    log_timestamps                  =SYSTEM
    local_infile                    =ON           #倒数
    event_scheduler                 =OFF
    query_cache_type                =OFF
    query_cache_size                =0             #有争议
    lc_messages                     =en_US
    lc_messages_dir                 =$MYSQLBASE/share
    init_connect                    ="set names utf8"
    #sql_mode                        =NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO
    #init_file                       =$MYSQLBASE/conf/init_file.sql
    #init_slave

    #******************* err & slow & general ***************
    #log_error                       =$MYSQLLOG/mysql.err
    #log_output                      ="TABLE,FILE"
    slow_query_log                  =ON
    slow_query_log_file             =$MYSQLLOG/slow.log
    long_query_time                 =1
    log_queries_not_using_indexes   =0
    log_throttle_queries_not_using_indexes = 10
    general_log                     =OFF
    general_log_file                =$MYSQLLOG/general.log

    #************** binlog & relaylog ***************
    # expire_logs_days                =7
    # sync_binlog                     =1            #建议值8-20
    # log-bin                         =$MYSQLBINLOG/mysql-bin
    # log-bin-index                   =$MYSQLBINLOG/mysql-bin.index
    # max_binlog_size                 =500M
    # binlog_format                   =ROW               #还可以是MIXED?
    # binlog_rows_query_log_events    =ON
    # binlog_cache_size               =4M
    # binlog_stmt_cache_size          =4M
    # max_binlog_cache_size           =2G
    # max_binlog_stmt_cache_size      =2G
    # relay_log                       =$MYSQLBINLOG/relay
    # relay_log_index                 =$MYSQLBINLOG/relay.index
    # max_relay_log_size              =500M
    # relay_log_purge                 =ON
    # relay_log_recovery              =ON

    #*************** group commit ***************
    binlog_group_commit_sync_delay              =1
    binlog_group_commit_sync_no_delay_count     =1000

    #*************** gtid ***************
    gtid_mode                       =ON
    enforce_gtid_consistency        =ON
    master_verify_checksum          =ON
    sync_master_info                =1

    #*************slave ***************
    # skip-slave-start                =1
    # #read_only                      =ON
    # #super_read_only                =ON
    # log_slave_updates               =ON
    # server_id                       =$SERVER_ID
    # report_host                     =192.168.123.126
    # report_port                     =23306
    # slave_load_tmpdir               =$MYSQLTMP
    # slave_sql_verify_checksum       =ON
    # slave_preserve_commit_order     =1

    #*************** muti thread slave ***************
    # slave_parallel_type                         =LOGICAL_CLOCK
    # slave_parallel_workers                      =4
    # master_info_repository                      =TABLE
    # relay_log_info_repository                   =TABLE

    #*************** buffer & timeout ***************
    read_buffer_size                =80M
    read_rnd_buffer_size            =80M
    sort_buffer_size                =80M
    join_buffer_size                =128M
    tmp_table_size                  =64M
    max_allowed_packet              =64M
    max_heap_table_size             =64M
    connect_timeout                 =10
    wait_timeout                    =600
    interactive_timeout             =600
    net_read_timeout                =30
    net_write_timeout               =30

    #*********** myisam ***************
    # skip_external_locking           =ON
    # key_buffer_size                 =16M
    # bulk_insert_buffer_size         =16M
    # concurrent_insert               =ALWAYS
    # open_files_limit                =65000
    # table_open_cache                =16000
    # table_definition_cache          =16000

    #*********** innodb ***************
    default_storage_engine              =InnoDB
    default_tmp_storage_engine          =InnoDB
    internal_tmp_disk_storage_engine    =InnoDB
    innodb_data_home_dir                =$MYSQLDATA
    innodb_log_group_home_dir           =$MYSQLRLOG
    innodb_log_file_size                =1024M
    innodb_log_files_in_group           =3
    innodb_undo_directory               =$MYSQLULOG
    innodb_undo_log_truncate            =on
    innodb_max_undo_log_size            =1024M
    innodb_undo_tablespaces             =3
    innodb_flush_log_at_trx_commit      =2
    innodb_fast_shutdown                =1
    innodb_flush_method                 =O_DIRECT
    innodb_io_capacity                  =1000
    innodb_io_capacity_max              =4000
    innodb_buffer_pool_size             =32G
    innodb_log_buffer_size              =100M
    innodb_autoinc_lock_mode            =1
    innodb_buffer_pool_load_at_startup  =ON
    innodb_buffer_pool_dump_at_shutdown =ON
    innodb_buffer_pool_dump_pct         =15
    innodb_max_dirty_pages_pct          =85
    innodb_lock_wait_timeout            =10
    #innodb_locks_unsafe_for_binlog      =1
    innodb_old_blocks_time              =1000
    innodb_open_files                   =63000
    innodb_page_cleaners                =4
    innodb_strict_mode                  =ON
    innodb_thread_concurrency           =64
    innodb_sort_buffer_size             =64M
    innodb_print_all_deadlocks          =1
    innodb_rollback_on_timeout          =ON
    innodb_file_per_table=on
    #innodb_data_file_path=ibdata1:10M:autoextend

    [mysqldump]
    quick
    max_allowed_packet=64M

    [myisamchk]
    key_buffer=16M
    sort_buffer_size=16M
    read_buffer=8M
    write_buffer=8M

    [mysqld_safe]
    #log-error                       =$MYSQLLOG/mysql.err
    #pid-file                        =$MYSQLBASE/mysql.pid
~~~~    

端口
-----

    3306

环境变量
-----
    MYSQL_ROOT_PASSWORD root密码，默认111111
    MYSQL_DATABASE 数据库名,多个逗号分隔
    MYSQL_USER 数据库用户,多个逗号分隔
    MYSQL_PASSWORD 数据库用户密码,多个逗号分隔     

卷
-----

    /app
