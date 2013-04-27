nas Cookbook
============
This cookbook configures a server as router.

Requirements
------------
Assume Ubuntu 12.04 or later.

Attributes
----------
None.

Usage
-----

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[router]"
  ]
}
```

License and Authors
-------------------
Author:: KIMATA Tetsuya <kimata@green-rabbit.net>
