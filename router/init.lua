local stats, env = pcall(require, "...env")
package.path = package.path .. ";./router/?.lua" .. (env.package_path or "")
package.cpath = package.cpath .. ";./router/?.lua" .. (env.package_cpath or "")