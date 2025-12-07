let write_file path content =
  try
    let parent_dir =
      Fpath.of_string path |> Result.get_ok |> Fpath.parent |> Fpath.to_string
    in
    Sys.command ("mkdir -p " ^ parent_dir) |> ignore;
    let oc = open_out path in
    Printf.fprintf oc "%s" content;
    close_out oc
  with e ->
    Printf.printf "Error writing file %s: %s\n" path (Printexc.to_string e);
    raise e

let render_homepage () =
  try
    let html = Templates2024.Home.make () |> JSX.render in
    write_file "output/2024/index.html" html;
    let html = Templates2025.Home.make () |> JSX.render in
    write_file "output/index.html" html;
    write_file "output/2025/index.html" html
  with e ->
    Printf.printf "Error rendering homepage: %s\n" (Printexc.to_string e);
    raise e

let render_session_page (s : Data2024.Sessions.t) =
  try
    let html = Templates2024.Session.render s |> JSX.render in
    write_file ("output/2024/" ^ s.slug ^ "/index.html") html
  with e ->
    Printf.printf "Error rendering session page for %s: %s\n" s.slug
      (Printexc.to_string e);
    raise e

let render_2025_session_page (s : Data2025.Sessions.t) =
  try
    let html = Templates2025.Session.render s |> JSX.render in
    write_file ("output/2025/" ^ s.slug ^ "/index.html") html
  with e ->
    Printf.printf "Error rendering session page for %s: %s\n" s.slug
      (Printexc.to_string e);
    raise e

let render_privacy_policy () =
  try
    let html = Templates2025.Privacy.make () |> JSX.render in
    write_file "output/privacy/index.html" html
  with e ->
    Printf.printf "Error rendering privacy policy: %s\n" (Printexc.to_string e);
    raise e

let base_url = "https://fun-ocaml.com"

let render_sitemap () =
  try
    let urls =
      (* Static pages *)
      [ "/"; "/2024/"; "/2025/"; "/privacy/" ]
      (* 2024 session pages *)
      @ List.map
          (fun (s : Data2024.Sessions.t) -> "/2024/" ^ s.slug ^ "/")
          Data2024.Sessions.all
      (* 2025 session pages *)
      @ List.map
          (fun (s : Data2025.Sessions.t) -> "/2025/" ^ s.slug ^ "/")
          Data2025.Sessions.all
    in
    let xml_urls =
      urls
      |> List.map (fun path ->
             Printf.sprintf "  <url>\n    <loc>%s%s</loc>\n  </url>" base_url
               path)
      |> String.concat "\n"
    in
    let sitemap =
      Printf.sprintf
        {|<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
%s
</urlset>|}
        xml_urls
    in
    write_file "output/sitemap.xml" sitemap
  with e ->
    Printf.printf "Error rendering sitemap: %s\n" (Printexc.to_string e);
    raise e

let () =
  try
    render_homepage ();
    render_privacy_policy ();
    render_sitemap ();
    Data2024.Sessions.all
    |> List.iter (fun (s : Data2024.Sessions.t) -> render_session_page s);
    Data2025.Sessions.all
    |> List.iter (fun (s : Data2025.Sessions.t) -> render_2025_session_page s)
  with e ->
    Printf.printf "Fatal error: %s\n" (Printexc.to_string e);
    exit 1
