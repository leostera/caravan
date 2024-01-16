module Telemetry = Telemetry_
module Connection = Connection
module Handler = Handler
module Transport = Transport
open Riot

let start_link ~port ?(acceptors = 100) ?(buffer_size = 1_024 * 50)
    ?(transport = Transport.tcp ()) handler initial_ctx =
  let child_specs =
    [
      Dynamic_supervisor.child_spec ~name:"atacama.connection.sup" ();
      Acceptor_pool.child_spec ~port ~acceptors ~transport ~buffer_size ~handler
        initial_ctx;
    ]
  in
  Supervisor.start_link ~restart_limit:10 ~child_specs ()
