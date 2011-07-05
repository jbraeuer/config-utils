## Next steps

- add --listdocs
- add --listkeys <doc>
- add --list <doc>

- add --rendersource <doc> --render <tmpl>

## Example repo

/world
  {
    id: <bla>
    s3bucket: w20110705

    role.puppetmaster: i-1234,
    role.mail: i-2345, ...
    roles: puppetmaster, mail, ...

    instances: i-1234, i-2345
    storage: vol-abcd,..
  }

/role.010.puppetmaster
  {
    type: m1.large
  }
/role.020.node
  {
    run_with: web
  }
/role.020.web
  {
    type: m1.large
  }
/role.020.storage
  {
    type: m1.large
    storage: 50
  }

