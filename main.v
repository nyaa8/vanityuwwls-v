module main

import picoev
import picohttpparser

[inline]
fn vanity_template(path string) string {
    escaped_path := path.replace("<", "&lt;").replace(">", "&qt;").replace('"', "&quot;")
    return '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="go-import" content="ddd.codes$escaped_path git github.com/ddd-org/$escaped_path"><meta name="go-source" content="github.com/ddd-org$escaped_path _ github.com/ddd-org$escaped_path/tree/{/dir} github.com/ddd-org$escaped_path/blob/\{/dir}/\{file}#L\{line}"></head></html>'
}

fn callback(req picohttpparser.Request, mut res picohttpparser.Response) {
    res.http_ok()
    res.header_server()
    res.html()
    res.body(vanity_template(req.path))
}

fn main() {
    println('Listening at :3000')
    picoev.new(3000, &callback).serve()
}
