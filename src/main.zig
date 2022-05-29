const std = @import("std");
const ts = @cImport(@cInclude("tree_sitter/api.h"));

const print = std.debug.print;

extern "c" fn tree_sitter_json() ?*ts.TSLanguage;
extern "c" fn tree_sitter_c() ?*ts.TSLanguage;

var depth: u32 = 0;

fn visit(tree: ts.TSNode) void {
    if (ts.ts_node_is_null(tree)) {
        return;
    }
    var i: u32 = 0;
    while (i < depth) : (i += 1) {
        print("  ", .{});
    }
    print("type:{s}\n", .{ts.ts_node_type(tree)});
    depth += 1;
    const children = ts.ts_node_named_child_count(tree);
    i = 0;
    while (i < children) : (i += 1) {
        visit(ts.ts_node_named_child(tree, i));
    }
    depth -= 1;
}

fn testJson() void {
    var parser = ts.ts_parser_new();
    defer ts.ts_parser_delete(parser);

    _ = ts.ts_parser_set_language(parser, tree_sitter_json());

    const source = "[1, null]";

    var tree = ts.ts_parser_parse_string(
        parser,
        null,
        source,
        source.len,
    );
    defer ts.ts_tree_delete(tree);

    var node = ts.ts_tree_root_node(tree);
    visit(node);
}

fn testC() void {
    var parser = ts.ts_parser_new();
    defer ts.ts_parser_delete(parser);

    _ = ts.ts_parser_set_language(parser, tree_sitter_c());

    const source = @embedFile("../example.c");

    var tree = ts.ts_parser_parse_string(
        parser,
        null,
        source,
        source.len,
    );
    defer ts.ts_tree_delete(tree);

    var node = ts.ts_tree_root_node(tree);
    visit(node);
}

pub fn main() anyerror!void {
    testJson();
    testC();
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
