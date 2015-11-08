open Async.Std
open Amqp

let log fmt = printf (fmt ^^ "\n%!")

let test =
  Connection.connect ~id:"fugmann" "localhost" >>= fun connection ->
  log "Connection started";
  Connection.open_channel ~id:"test" Channel.no_confirm connection >>= fun channel ->
  log "Channel opened";
  Channel.close channel >>= fun () ->
  log "Channel closed";
  Connection.open_channel ~id:"test" Channel.no_confirm connection >>= fun channel1 ->
  log "Channel opened";
  Connection.open_channel ~id:"test" Channel.no_confirm connection >>= fun channel2 ->
  log "Channel opened";
  Channel.close channel1 >>= fun () ->
  log "Channel closed";
  Channel.close channel2 >>| fun () ->
  log "Channel closed";
  Shutdown.shutdown 0

let _ =
  Scheduler.go ()
