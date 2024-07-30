package pq

foreign import "lib/libpq.lib"

import _c "core:c"
import "core:c/libc"

LIBPQ_FE_H :: 1;
LIBPQ_HAS_PIPELINING :: 1;
LIBPQ_HAS_TRACE_FLAGS :: 1;
LIBPQ_HAS_SSL_LIBRARY_DETECTION :: 1;
PG_COPYRES_ATTRS :: 1;
PG_COPYRES_TUPLES :: 2;
PG_COPYRES_EVENTS :: 4;
PG_COPYRES_NOTICEHOOKS :: 8;
PQTRACE_SUPPRESS_TIMESTAMPS :: 1;
PQTRACE_REGRESS_MODE :: 2;
PQ_QUERY_PARAM_MAX_LIMIT :: 65535;
PQnoPasswordSupplied :: "fe_sendauth: no password supplied\n";
POSTGRES_EXT_H :: 1;

PGconn :: pg_conn;
PGresult :: pg_result;
PGcancel :: pg_cancel;
PGnotify :: pgNotify;
PQnoticeReceiver :: #type proc(arg : rawptr, res : ^PGresult);
PQnoticeProcessor :: #type proc(arg : rawptr, message : cstring);
pqbool :: _c.char;
PQprintOpt :: _PQprintOpt;
PQconninfoOption :: _PQconninfoOption;
PGresAttDesc :: pgresAttDesc;
pgthreadlock_t :: #type proc(acquire : _c.int);
PQsslKeyPassHook_OpenSSL_type :: #type proc(buf : cstring, size : _c.int, conn : ^PGconn) -> _c.int;
Oid :: _c.uint;
pg_int64 :: i64;
FILE :: libc.FILE

ConnStatusType :: enum i32 {
    CONNECTION_OK,
    CONNECTION_BAD,
    CONNECTION_STARTED,
    CONNECTION_MADE,
    CONNECTION_AWAITING_RESPONSE,
    CONNECTION_AUTH_OK,
    CONNECTION_SETENV,
    CONNECTION_SSL_STARTUP,
    CONNECTION_NEEDED,
    CONNECTION_CHECK_WRITABLE,
    CONNECTION_CONSUME,
    CONNECTION_GSS_STARTUP,
    CONNECTION_CHECK_TARGET,
    CONNECTION_CHECK_STANDBY,
};

PostgresPollingStatusType :: enum i32 {
    PGRES_POLLING_FAILED = 0,
    PGRES_POLLING_READING,
    PGRES_POLLING_WRITING,
    PGRES_POLLING_OK,
    PGRES_POLLING_ACTIVE,
};

ExecStatusType :: enum i32 {
    PGRES_EMPTY_QUERY = 0,
    PGRES_COMMAND_OK,
    PGRES_TUPLES_OK,
    PGRES_COPY_OUT,
    PGRES_COPY_IN,
    PGRES_BAD_RESPONSE,
    PGRES_NONFATAL_ERROR,
    PGRES_FATAL_ERROR,
    PGRES_COPY_BOTH,
    PGRES_SINGLE_TUPLE,
    PGRES_PIPELINE_SYNC,
    PGRES_PIPELINE_ABORTED,
};

PGTransactionStatusType :: enum i32 {
    PQTRANS_IDLE,
    PQTRANS_ACTIVE,
    PQTRANS_INTRANS,
    PQTRANS_INERROR,
    PQTRANS_UNKNOWN,
};

PGVerbosity :: enum i32 {
    PQERRORS_TERSE,
    PQERRORS_DEFAULT,
    PQERRORS_VERBOSE,
    PQERRORS_SQLSTATE,
};

PGContextVisibility :: enum i32 {
    PQSHOW_CONTEXT_NEVER,
    PQSHOW_CONTEXT_ERRORS,
    PQSHOW_CONTEXT_ALWAYS,
};

PGPing :: enum i32 {
    PQPING_OK,
    PQPING_REJECT,
    PQPING_NO_RESPONSE,
    PQPING_NO_ATTEMPT,
};

PGpipelineStatus :: enum i32 {
    PQ_PIPELINE_OFF,
    PQ_PIPELINE_ON,
    PQ_PIPELINE_ABORTED,
};

pg_conn :: struct {};

pg_result :: struct {};

pg_cancel :: struct {};

pgNotify :: struct {
    relname : cstring,
    be_pid : _c.int,
    extra : cstring,
    next : ^pgNotify,
};

_PQprintOpt :: struct {
    header : _c.char,
    align : _c.char,
    standard : _c.char,
    html3 : _c.char,
    expanded : _c.char,
    pager : _c.char,
    field_sep : cstring,
    table_opt : cstring,
    caption : cstring,
    field_name : ^cstring,
};

_PQconninfoOption :: struct {
    keyword : cstring,
    envvar : cstring,
    compiled : cstring,
    val : cstring,
    label : cstring,
    dispchar : cstring,
    dispsize : _c.int,
};

PQArgBlock :: struct {
    len : _c.int,
    isint : _c.int,
    u : AnonymousUnion0,
};

pgresAttDesc :: struct {
    name : cstring,
    tableid : Oid,
    columnid : _c.int,
    format : _c.int,
    typid : Oid,
    typlen : _c.int,
    atttypmod : _c.int,
};

AnonymousUnion0 :: struct #raw_union {
    ptr : ^_c.int,
    integer : _c.int,
};

@(default_calling_convention="c")
foreign libpq {

    @(link_name="PQconnectStart")
    connect_start :: proc(conninfo : cstring) -> ^PGconn ---;

    @(link_name="PQconnectStartParams")
    connect_start_params :: proc(keywords : ^cstring, values : ^cstring, expand_dbname : _c.int) -> ^PGconn ---;

    @(link_name="PQconnectPoll")
    connect_poll :: proc(conn : ^PGconn) -> PostgresPollingStatusType ---;

    @(link_name="PQconnectdb")
    connectdb :: proc(conninfo : cstring) -> ^PGconn ---;

    @(link_name="PQconnectdbParams")
    connectdb_params :: proc(keywords : ^cstring, values : ^cstring, expand_dbname : _c.int) -> ^PGconn ---;

    @(link_name="PQsetdbLogin")
    setdb_login :: proc(pghost : cstring, pgport : cstring, pgoptions : cstring, pgtty : cstring, db_name : cstring, login : cstring, pwd : cstring) -> ^PGconn ---;

    @(link_name="PQfinish")
    finish :: proc(conn : ^PGconn) ---;

    @(link_name="PQconndefaults")
    conndefaults :: proc() -> ^PQconninfoOption ---;

    @(link_name="PQconninfoParse")
    conninfo_parse :: proc(conninfo : cstring, errmsg : ^cstring) -> ^PQconninfoOption ---;

    @(link_name="PQconninfo")
    conninfo :: proc(conn : ^PGconn) -> ^PQconninfoOption ---;

    @(link_name="PQconninfoFree")
    conninfo_free :: proc(conn_options : ^PQconninfoOption) ---;

    @(link_name="PQresetStart")
    reset_start :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQresetPoll")
    reset_poll :: proc(conn : ^PGconn) -> PostgresPollingStatusType ---;

    @(link_name="PQreset")
    reset :: proc(conn : ^PGconn) ---;

    @(link_name="PQgetCancel")
    get_cancel :: proc(conn : ^PGconn) -> ^PGcancel ---;

    @(link_name="PQfreeCancel")
    free_cancel :: proc(cancel : ^PGcancel) ---;

    @(link_name="PQcancel")
    cancel :: proc(cancel : ^PGcancel, errbuf : cstring, errbufsize : _c.int) -> _c.int ---;

    @(link_name="PQrequestCancel")
    request_cancel :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQdb")
    db :: proc(conn : ^PGconn) -> cstring ---;

    @(link_name="PQuser")
    user :: proc(conn : ^PGconn) -> cstring ---;

    @(link_name="PQpass")
    pass :: proc(conn : ^PGconn) -> cstring ---;

    @(link_name="PQhost")
    host :: proc(conn : ^PGconn) -> cstring ---;

    @(link_name="PQhostaddr")
    hostaddr :: proc(conn : ^PGconn) -> cstring ---;

    @(link_name="PQport")
    port :: proc(conn : ^PGconn) -> cstring ---;

    @(link_name="PQtty")
    tty :: proc(conn : ^PGconn) -> cstring ---;

    @(link_name="PQoptions")
    options :: proc(conn : ^PGconn) -> cstring ---;

    @(link_name="PQstatus")
    status :: proc(conn : ^PGconn) -> ConnStatusType ---;

    @(link_name="PQtransactionStatus")
    transaction_status :: proc(conn : ^PGconn) -> PGTransactionStatusType ---;

    @(link_name="PQparameterStatus")
    parameter_status :: proc(conn : ^PGconn, param_name : cstring) -> cstring ---;

    @(link_name="PQprotocolVersion")
    protocol_version :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQserverVersion")
    server_version :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQerrorMessage")
    error_message :: proc(conn : ^PGconn) -> cstring ---;

    @(link_name="PQsocket")
    socket :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQbackendPID")
    backend_pid :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQpipelineStatus")
    pipeline_status :: proc(conn : ^PGconn) -> PGpipelineStatus ---;

    @(link_name="PQconnectionNeedsPassword")
    connection_needs_password :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQconnectionUsedPassword")
    connection_used_password :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQconnectionUsedGSSAPI")
    connection_used_gssapi :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQclientEncoding")
    client_encoding :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQsetClientEncoding")
    set_client_encoding :: proc(conn : ^PGconn, encoding : cstring) -> _c.int ---;

    @(link_name="PQsslInUse")
    ssl_in_use :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQsslStruct")
    ssl_struct :: proc(conn : ^PGconn, struct_name : cstring) -> rawptr ---;

    @(link_name="PQsslAttribute")
    ssl_attribute :: proc(conn : ^PGconn, attribute_name : cstring) -> cstring ---;

    @(link_name="PQsslAttributeNames")
    ssl_attribute_names :: proc(conn : ^PGconn) -> ^cstring ---;

    @(link_name="PQgetssl")
    getssl :: proc(conn : ^PGconn) -> rawptr ---;

    @(link_name="PQinitSSL")
    init_ssl :: proc(do_init : _c.int) ---;

    @(link_name="PQinitOpenSSL")
    init_open_ssl :: proc(do_ssl : _c.int, do_crypto : _c.int) ---;

    @(link_name="PQgssEncInUse")
    gss_enc_in_use :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQgetgssctx")
    getgssctx :: proc(conn : ^PGconn) -> rawptr ---;

    @(link_name="PQsetErrorVerbosity")
    set_error_verbosity :: proc(conn : ^PGconn, verbosity : PGVerbosity) -> PGVerbosity ---;

    @(link_name="PQsetErrorContextVisibility")
    set_error_context_visibility :: proc(conn : ^PGconn, show_context : PGContextVisibility) -> PGContextVisibility ---;

    @(link_name="PQsetNoticeReceiver")
    set_notice_receiver :: proc(conn : ^PGconn, _proc : PQnoticeReceiver, arg : rawptr) -> PQnoticeReceiver ---;

    @(link_name="PQsetNoticeProcessor")
    set_notice_processor :: proc(conn : ^PGconn, _proc : PQnoticeProcessor, arg : rawptr) -> PQnoticeProcessor ---;

    @(link_name="PQregisterThreadLock")
    register_thread_lock :: proc(newhandler : pgthreadlock_t) -> pgthreadlock_t ---;

    @(link_name="PQtrace")
    trace :: proc(conn : ^PGconn, debug_port : ^FILE) ---;

    @(link_name="PQuntrace")
    untrace :: proc(conn : ^PGconn) ---;

    @(link_name="PQsetTraceFlags")
    set_trace_flags :: proc(conn : ^PGconn, flags : _c.int) ---;

    @(link_name="PQexec")
    exec :: proc(conn : ^PGconn, query : cstring) -> ^PGresult ---;

    @(link_name="PQexecParams")
    exec_params :: proc(conn : ^PGconn, command : cstring, n_params : _c.int, param_types : ^Oid, param_values : ^cstring, param_lengths : ^_c.int, param_formats : ^_c.int, result_format : _c.int) -> ^PGresult ---;

    @(link_name="PQprepare")
    prepare :: proc(conn : ^PGconn, stmt_name : cstring, query : cstring, n_params : _c.int, param_types : ^Oid) -> ^PGresult ---;

    @(link_name="PQexecPrepared")
    exec_prepared :: proc(conn : ^PGconn, stmt_name : cstring, n_params : _c.int, param_values : ^cstring, param_lengths : ^_c.int, param_formats : ^_c.int, result_format : _c.int) -> ^PGresult ---;

    @(link_name="PQsendQuery")
    send_query :: proc(conn : ^PGconn, query : cstring) -> _c.int ---;

    @(link_name="PQsendQueryParams")
    send_query_params :: proc(conn : ^PGconn, command : cstring, n_params : _c.int, param_types : ^Oid, param_values : ^cstring, param_lengths : ^_c.int, param_formats : ^_c.int, result_format : _c.int) -> _c.int ---;

    @(link_name="PQsendPrepare")
    send_prepare :: proc(conn : ^PGconn, stmt_name : cstring, query : cstring, n_params : _c.int, param_types : ^Oid) -> _c.int ---;

    @(link_name="PQsendQueryPrepared")
    send_query_prepared :: proc(conn : ^PGconn, stmt_name : cstring, n_params : _c.int, param_values : ^cstring, param_lengths : ^_c.int, param_formats : ^_c.int, result_format : _c.int) -> _c.int ---;

    @(link_name="PQsetSingleRowMode")
    set_single_row_mode :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQgetResult")
    get_result :: proc(conn : ^PGconn) -> ^PGresult ---;

    @(link_name="PQisBusy")
    is_busy :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQconsumeInput")
    consume_input :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQenterPipelineMode")
    enter_pipeline_mode :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQexitPipelineMode")
    exit_pipeline_mode :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQpipelineSync")
    pipeline_sync :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQsendFlushRequest")
    send_flush_request :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQnotifies")
    notifies :: proc(conn : ^PGconn) -> ^PGnotify ---;

    @(link_name="PQputCopyData")
    put_copy_data :: proc(conn : ^PGconn, buffer : cstring, nbytes : _c.int) -> _c.int ---;

    @(link_name="PQputCopyEnd")
    put_copy_end :: proc(conn : ^PGconn, errormsg : cstring) -> _c.int ---;

    @(link_name="PQgetCopyData")
    get_copy_data :: proc(conn : ^PGconn, buffer : ^cstring, async : _c.int) -> _c.int ---;

    @(link_name="PQgetline")
    getline :: proc(conn : ^PGconn, buffer : cstring, length : _c.int) -> _c.int ---;

    @(link_name="PQputline")
    putline :: proc(conn : ^PGconn, string : cstring) -> _c.int ---;

    @(link_name="PQgetlineAsync")
    getline_async :: proc(conn : ^PGconn, buffer : cstring, bufsize : _c.int) -> _c.int ---;

    @(link_name="PQputnbytes")
    putnbytes :: proc(conn : ^PGconn, buffer : cstring, nbytes : _c.int) -> _c.int ---;

    @(link_name="PQendcopy")
    endcopy :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQsetnonblocking")
    setnonblocking :: proc(conn : ^PGconn, arg : _c.int) -> _c.int ---;

    @(link_name="PQisnonblocking")
    isnonblocking :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQisthreadsafe")
    isthreadsafe :: proc() -> _c.int ---;

    @(link_name="PQping")
    ping :: proc(conninfo : cstring) -> PGPing ---;

    @(link_name="PQpingParams")
    ping_params :: proc(keywords : ^cstring, values : ^cstring, expand_dbname : _c.int) -> PGPing ---;

    @(link_name="PQflush")
    flush :: proc(conn : ^PGconn) -> _c.int ---;

    @(link_name="PQfn")
    fn :: proc(conn : ^PGconn, fnid : _c.int, result_buf : ^_c.int, result_len : ^_c.int, result_is_int : _c.int, args : ^PQArgBlock, nargs : _c.int) -> ^PGresult ---;

    @(link_name="PQresultStatus")
    result_status :: proc(res : ^PGresult) -> ExecStatusType ---;

    @(link_name="PQresStatus")
    res_status :: proc(status : ExecStatusType) -> cstring ---;

    @(link_name="PQresultErrorMessage")
    result_error_message :: proc(res : ^PGresult) -> cstring ---;

    @(link_name="PQresultVerboseErrorMessage")
    result_verbose_error_message :: proc(res : ^PGresult, verbosity : PGVerbosity, show_context : PGContextVisibility) -> cstring ---;

    @(link_name="PQresultErrorField")
    result_error_field :: proc(res : ^PGresult, fieldcode : _c.int) -> cstring ---;

    @(link_name="PQntuples")
    ntuples :: proc(res : ^PGresult) -> _c.int ---;

    @(link_name="PQnfields")
    nfields :: proc(res : ^PGresult) -> _c.int ---;

    @(link_name="PQbinaryTuples")
    binary_tuples :: proc(res : ^PGresult) -> _c.int ---;

    @(link_name="PQfname")
    fname :: proc(res : ^PGresult, field_num : _c.int) -> cstring ---;

    @(link_name="PQfnumber")
    fnumber :: proc(res : ^PGresult, field_name : cstring) -> _c.int ---;

    @(link_name="PQftable")
    ftable :: proc(res : ^PGresult, field_num : _c.int) -> Oid ---;

    @(link_name="PQftablecol")
    ftablecol :: proc(res : ^PGresult, field_num : _c.int) -> _c.int ---;

    @(link_name="PQfformat")
    fformat :: proc(res : ^PGresult, field_num : _c.int) -> _c.int ---;

    @(link_name="PQftype")
    ftype :: proc(res : ^PGresult, field_num : _c.int) -> Oid ---;

    @(link_name="PQfsize")
    fsize :: proc(res : ^PGresult, field_num : _c.int) -> _c.int ---;

    @(link_name="PQfmod")
    fmod :: proc(res : ^PGresult, field_num : _c.int) -> _c.int ---;

    @(link_name="PQcmdStatus")
    cmd_status :: proc(res : ^PGresult) -> cstring ---;

    @(link_name="PQoidStatus")
    oid_status :: proc(res : ^PGresult) -> cstring ---;

    @(link_name="PQoidValue")
    oid_value :: proc(res : ^PGresult) -> Oid ---;

    @(link_name="PQcmdTuples")
    cmd_tuples :: proc(res : ^PGresult) -> cstring ---;

    @(link_name="PQgetvalue")
    getvalue :: proc(res : ^PGresult, tup_num : _c.int, field_num : _c.int) -> cstring ---;

    @(link_name="PQgetlength")
    getlength :: proc(res : ^PGresult, tup_num : _c.int, field_num : _c.int) -> _c.int ---;

    @(link_name="PQgetisnull")
    getisnull :: proc(res : ^PGresult, tup_num : _c.int, field_num : _c.int) -> _c.int ---;

    @(link_name="PQnparams")
    nparams :: proc(res : ^PGresult) -> _c.int ---;

    @(link_name="PQparamtype")
    paramtype :: proc(res : ^PGresult, param_num : _c.int) -> Oid ---;

    @(link_name="PQdescribePrepared")
    describe_prepared :: proc(conn : ^PGconn, stmt : cstring) -> ^PGresult ---;

    @(link_name="PQdescribePortal")
    describe_portal :: proc(conn : ^PGconn, portal : cstring) -> ^PGresult ---;

    @(link_name="PQsendDescribePrepared")
    send_describe_prepared :: proc(conn : ^PGconn, stmt : cstring) -> _c.int ---;

    @(link_name="PQsendDescribePortal")
    send_describe_portal :: proc(conn : ^PGconn, portal : cstring) -> _c.int ---;

    @(link_name="PQclear")
    clear :: proc(res : ^PGresult) ---;

    @(link_name="PQfreemem")
    freemem :: proc(ptr : rawptr) ---;

    @(link_name="PQmakeEmptyPGresult")
    make_empty_p_gresult :: proc(conn : ^PGconn, status : ExecStatusType) -> ^PGresult ---;

    @(link_name="PQcopyResult")
    copy_result :: proc(src : ^PGresult, flags : _c.int) -> ^PGresult ---;

    @(link_name="PQsetResultAttrs")
    set_result_attrs :: proc(res : ^PGresult, num_attributes : _c.int, att_descs : ^PGresAttDesc) -> _c.int ---;

    @(link_name="PQresultAlloc")
    result_alloc :: proc(res : ^PGresult, n_bytes : _c.size_t) -> rawptr ---;

    @(link_name="PQresultMemorySize")
    result_memory_size :: proc(res : ^PGresult) -> _c.size_t ---;

    @(link_name="PQsetvalue")
    setvalue :: proc(res : ^PGresult, tup_num : _c.int, field_num : _c.int, value : cstring, len : _c.int) -> _c.int ---;

    @(link_name="PQescapeStringConn")
    escape_string_conn :: proc(conn : ^PGconn, to : cstring, from : cstring, length : _c.size_t, error : ^_c.int) -> _c.size_t ---;

    @(link_name="PQescapeLiteral")
    escape_literal :: proc(conn : ^PGconn, str : cstring, len : _c.size_t) -> cstring ---;

    @(link_name="PQescapeIdentifier")
    escape_identifier :: proc(conn : ^PGconn, str : cstring, len : _c.size_t) -> cstring ---;

    @(link_name="PQescapeByteaConn")
    escape_bytea_conn :: proc(conn : ^PGconn, from : ^_c.uchar, from_length : _c.size_t, to_length : ^_c.size_t) -> ^_c.uchar ---;

    @(link_name="PQunescapeBytea")
    unescape_bytea :: proc(strtext : ^_c.uchar, retbuflen : ^_c.size_t) -> ^_c.uchar ---;

    @(link_name="PQescapeString")
    escape_string :: proc(to : cstring, from : cstring, length : _c.size_t) -> _c.size_t ---;

    @(link_name="PQescapeBytea")
    escape_bytea :: proc(from : ^_c.uchar, from_length : _c.size_t, to_length : ^_c.size_t) -> ^_c.uchar ---;

    @(link_name="PQprint")
    print :: proc(fout : ^FILE, res : ^PGresult, po : ^PQprintOpt) ---;

    @(link_name="PQdisplayTuples")
    display_tuples :: proc(res : ^PGresult, fp : ^FILE, fill_align : _c.int, field_sep : cstring, print_header : _c.int, quiet : _c.int) ---;

    @(link_name="PQprintTuples")
    print_tuples :: proc(res : ^PGresult, fout : ^FILE, print_att_names : _c.int, terse_output : _c.int, col_width : _c.int) ---;

    @(link_name="lo_open")
    lo_open :: proc(conn : ^PGconn, lobj_id : Oid, mode : _c.int) -> _c.int ---;

    @(link_name="lo_close")
    lo_close :: proc(conn : ^PGconn, fd : _c.int) -> _c.int ---;

    @(link_name="lo_read")
    lo_read :: proc(conn : ^PGconn, fd : _c.int, buf : cstring, len : _c.size_t) -> _c.int ---;

    @(link_name="lo_write")
    lo_write :: proc(conn : ^PGconn, fd : _c.int, buf : cstring, len : _c.size_t) -> _c.int ---;

    @(link_name="lo_lseek")
    lo_lseek :: proc(conn : ^PGconn, fd : _c.int, offset : _c.int, whence : _c.int) -> _c.int ---;

    @(link_name="lo_lseek64")
    lo_lseek64 :: proc(conn : ^PGconn, fd : _c.int, offset : pg_int64, whence : _c.int) -> pg_int64 ---;

    @(link_name="lo_creat")
    lo_creat :: proc(conn : ^PGconn, mode : _c.int) -> Oid ---;

    @(link_name="lo_create")
    lo_create :: proc(conn : ^PGconn, lobj_id : Oid) -> Oid ---;

    @(link_name="lo_tell")
    lo_tell :: proc(conn : ^PGconn, fd : _c.int) -> _c.int ---;

    @(link_name="lo_tell64")
    lo_tell64 :: proc(conn : ^PGconn, fd : _c.int) -> pg_int64 ---;

    @(link_name="lo_truncate")
    lo_truncate :: proc(conn : ^PGconn, fd : _c.int, len : _c.size_t) -> _c.int ---;

    @(link_name="lo_truncate64")
    lo_truncate64 :: proc(conn : ^PGconn, fd : _c.int, len : pg_int64) -> _c.int ---;

    @(link_name="lo_unlink")
    lo_unlink :: proc(conn : ^PGconn, lobj_id : Oid) -> _c.int ---;

    @(link_name="lo_import")
    lo_import :: proc(conn : ^PGconn, filename : cstring) -> Oid ---;

    @(link_name="lo_import_with_oid")
    lo_import_with_oid :: proc(conn : ^PGconn, filename : cstring, lobj_id : Oid) -> Oid ---;

    @(link_name="lo_export")
    lo_export :: proc(conn : ^PGconn, lobj_id : Oid, filename : cstring) -> _c.int ---;

    @(link_name="PQlibVersion")
    lib_version :: proc() -> _c.int ---;

    @(link_name="PQmblen")
    mblen :: proc(s : cstring, encoding : _c.int) -> _c.int ---;

    @(link_name="PQmblenBounded")
    mblen_bounded :: proc(s : cstring, encoding : _c.int) -> _c.int ---;

    @(link_name="PQdsplen")
    dsplen :: proc(s : cstring, encoding : _c.int) -> _c.int ---;

    @(link_name="PQenv2encoding")
    env2encoding :: proc() -> _c.int ---;

    @(link_name="PQencryptPassword")
    encrypt_password :: proc(passwd : cstring, user : cstring) -> cstring ---;

    @(link_name="PQencryptPasswordConn")
    encrypt_password_conn :: proc(conn : ^PGconn, passwd : cstring, user : cstring, algorithm : cstring) -> cstring ---;

    @(link_name="pg_char_to_encoding")
    pg_char_to_encoding :: proc(name : cstring) -> _c.int ---;

    @(link_name="pg_encoding_to_char")
    pg_encoding_to_char :: proc(encoding : _c.int) -> cstring ---;

    @(link_name="pg_valid_server_encoding_id")
    pg_valid_server_encoding_id :: proc(encoding : _c.int) -> _c.int ---;

    @(link_name="PQgetSSLKeyPassHook_OpenSSL")
    getsslkeypasshook_openssl :: proc() -> PQsslKeyPassHook_OpenSSL_type ---;

    @(link_name="PQsetSSLKeyPassHook_OpenSSL")
    setsslkeypasshook_openssl :: proc(hook : PQsslKeyPassHook_OpenSSL_type) ---;

    @(link_name="PQdefaultSSLKeyPassHook_OpenSSL")
    defaultsslkeypasshook_openssl :: proc(buf : cstring, size : _c.int, conn : ^PGconn) -> _c.int ---;

}
