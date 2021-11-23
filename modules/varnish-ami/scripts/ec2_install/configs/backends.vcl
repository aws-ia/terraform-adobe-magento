backend nginx {
    .host = "127.0.0.1";
    .port = "8080";
    .connect_timeout = 10s;
    .first_byte_timeout = 600s;
    .between_bytes_timeout = 5s;
}