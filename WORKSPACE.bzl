load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository") # buildifier: disable=load
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")  # buildifier: disable=load
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")  # buildifier: disable=load

load("@obazl_rules_ocaml//ocaml:providers.bzl", "OpamConfig", "BuildConfig")

################################################################
#####################
# def cc_fetch_rules():
#     ## Bazel is migrating to this lib instead of builtin rules_cc.
#     ## Use the http_archive rule once it is released.
#     # maybe(
#     #     http_archive,
#     #     name = "rules_cc",
#     #     urls = ["https://github.com/bazelbuild/rules_cc/archive/TODO"],
#     #     # sha256 = "TODO",
#     # )

#     maybe(
#         git_repository,
#         name = "rules_cc",
#         remote = "https://github.com/bazelbuild/rules_cc",
#         commit = "b1c40e1de81913a3c40e5948f78719c28152486d",
#         shallow_since = "1605101351 -0800"
#         # branch = "master"
#     )

#     maybe(
#         http_archive,
#         name = "rules_foreign_cc",
#         sha256 = "33a5690733c5cc2ede39cb62ebf89e751f2448e27f20c8b2fbbc7d136b166804",
#         strip_prefix = "rules_foreign_cc-0.5.1",
#         url = "https://github.com/bazelbuild/rules_foreign_cc/archive/0.5.1.tar.gz",
#     )
