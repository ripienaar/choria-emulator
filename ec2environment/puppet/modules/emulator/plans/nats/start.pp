plan emulator::nats::start (
  Boolean $leafnode=false,
  Optional[String] $servers=undef,
  Optional[String] $credentials=undef,
  Integer $monitor=8222,
  Integer $clients=4222,
) {
  if $leafnode {
    if !($servers and $credentials) {
        fail("leaf nodes need servers and credentials specified")
    }

    info("Starting leafnodes")

    $_leaf_options = {
        "credentials" => base64(encode, file($credentials)),
        "leafnode_servers" => $servers
    }
  } else {
    $_leaf_options = {}
  }
  
  $_common_options = {
    "monitor_port" => $monitor,
    "port" => $clients
  }

  $_nodes = emulator::all_nodes()

  $results = choria::task("mcollective",
    "nodes" => $_nodes,
    "action" => "emulator.start_nats",
    "silent" => true,
    "properties" => $_common_options + $_leaf_options
  ) 

  $results.each |$result| {
    if $result.ok {
      info(sprintf("%s: %s: started: %s", $result["sender"], $result["statusmsg"], $result["data"]["running"]))
    } else {
      error(sprintf("%s: %s", $result["sender"], $result["statusmsg"]))
    }
  }

  undef
}