module main

import picoev
import picohttpparser

const (
    github_account = "nyaascii"
    module_domain  = "pkg.nyaa.science"
    port           = 3001
)

[inline]
fn vanity_template(path string) string {
    return '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>${path[1..]}</title><meta name="go-import" content="$module_domain$path git https://github.com/$github_account$path"><meta name="go-source" content="https://github.com/$github_account$path _ https://github.com/$github_account$path/tree/{/dir} https://github.com/$github_account$path/blob/{/dir}/{file}#L{line}"></head><body><a href="https://github.com/$github_account$path" style="font-family: monospace">$module_domain$path</a></body></html>'
}

fn callback(req picohttpparser.Request, mut res picohttpparser.Response) {
    package_path := req.path.trim_suffix('?go-get=1')
    if picohttpparser.cmp(package_path, '/') {
        res.http_404()
        return
    }

    res.http_ok()
    res.header_server()
    res.html()
    res.body(vanity_template(package_path))
}

fn main() {
    println('Listening at :$port')
    picoev.new(port, &callback).serve()
}
