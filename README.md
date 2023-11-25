# About
Run this script from location A and symlink all files with a certain extension into location B. It first removes any symlinks in location b and then rebuilds the list. 

# Usage
For example, if I have a directory structure like this:

```
path
├── a
│   ├── scripts
│   │   ├── relink.sh
│   ├── src
│   │   ├── apps
│   │   │   ├── site.scss
│   │   │   ├── site.js
│   │   ├── common
│   │   │   ├── common.scss
│   │   │   ├── common.js
├── b
```

From location A (path/a) run the following:

`bash scripts/relink.sh --type=scss --src=. --dest=../b`

The output will be:

```
path
├── b
│   ├── a_src_apps_site.scss -> ../a/src/apps/site.scss
│   ├── a_src_common_common.scss -> ../a/src/common/common.scss
``` 

The script handles multiple types, so if you run:

`bash scripts/relink.sh --type=scss --type=js --src=. --dest=../b`

The output should look like:

```
path
├── b
│   ├── a_src_apps_site.scss -> ../a/src/apps/site.scss
│   ├── a_src_common_common.scss -> ../a/src/common/common.scss
│   ├── a_src_apps_site.js -> ../a/src/apps/site.js
│   ├── a_src_common_common.js -> ../a/src/common/common.js
```

# Use in project

To use this in a project, you can install with `npm install gather-links` add a variation of the following to your package.json:

```
  "scripts" {
    "relink:css": "bash node_modules/gather-relinks/bin/relink.sh --type=scss --src=. --dest=../b",
  }
```

Then run `npm run relink:css` from the root of your project.