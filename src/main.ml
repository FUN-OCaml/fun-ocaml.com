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

let render_about_page () =
  try
    let html = Templates2025.About.make () |> JSX.render in
    write_file "output/about/index.html" html
  with e ->
    Printf.printf "Error rendering about page: %s\n" (Printexc.to_string e);
    raise e

let base_url = "https://fun-ocaml.com"

let render_sitemap () =
  try
    (* Helper to create URL entry with metadata *)
    let make_url ~loc ~priority ~changefreq ~lastmod =
      Printf.sprintf
        {|  <url>
    <loc>%s%s</loc>
    <lastmod>%s</lastmod>
    <changefreq>%s</changefreq>
    <priority>%.1f</priority>
  </url>|}
        base_url loc lastmod changefreq priority
    in
    
    (* Get current date in ISO format *)
    let current_date = "2025-12-15" in (* Will be updated on each build *)
    
    let url_list =
      [
        (* Homepage - highest priority *)
        make_url ~loc:"/" ~priority:1.0 ~changefreq:"weekly" ~lastmod:current_date;
        
        (* Event year pages *)
        make_url ~loc:"/2024/" ~priority:0.9 ~changefreq:"monthly" ~lastmod:"2024-09-17";
        make_url ~loc:"/2025/" ~priority:0.9 ~changefreq:"weekly" ~lastmod:current_date;
        
        (* About page - high priority for SEO *)
        make_url ~loc:"/about/" ~priority:0.8 ~changefreq:"monthly" ~lastmod:current_date;
        
        (* Privacy page - low priority *)
        make_url ~loc:"/privacy/" ~priority:0.3 ~changefreq:"yearly" ~lastmod:current_date;
      ]
      (* 2024 session pages - archived, lower priority *)
      @ (Data2024.Sessions.all
        |> List.map (fun (s : Data2024.Sessions.t) ->
               make_url
                 ~loc:("/2024/" ^ s.slug ^ "/")
                 ~priority:0.6
                 ~changefreq:"yearly"
                 ~lastmod:"2024-09-17"))
      (* 2025 session pages - current, higher priority *)
      @ (Data2025.Sessions.all
        |> List.map (fun (s : Data2025.Sessions.t) ->
               make_url
                 ~loc:("/2025/" ^ s.slug ^ "/")
                 ~priority:0.7
                 ~changefreq:"monthly"
                 ~lastmod:current_date))
    in
    
    let sitemap =
      Printf.sprintf
        {|<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
%s
</urlset>|}
        (String.concat "\n" url_list)
    in
    write_file "output/sitemap.xml" sitemap
  with e ->
    Printf.printf "Error rendering sitemap: %s\n" (Printexc.to_string e);
    raise e

let () =
  try
    render_homepage ();
    render_privacy_policy ();
    render_about_page ();
    render_sitemap ();
    Data2024.Sessions.all
    |> List.iter (fun (s : Data2024.Sessions.t) -> render_session_page s);
    Data2025.Sessions.all
    |> List.iter (fun (s : Data2025.Sessions.t) -> render_2025_session_page s)
  with e ->
    Printf.printf "Fatal error: %s\n" (Printexc.to_string e);
    exit 1
