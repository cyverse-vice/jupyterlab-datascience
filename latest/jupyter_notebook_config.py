c.ServerProxy.servers = {
  'rstudio': {
    'command': ['rserver', '--www-port={port}', '--www-address=127.0.0.1', '--www-root-path={base_url}/rstudio'],
    'timeout': 20,
    'launcher_entry': {
      'title': 'RStudio'
    }
  }
}
