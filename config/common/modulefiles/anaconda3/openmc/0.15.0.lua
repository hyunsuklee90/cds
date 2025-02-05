help([[
This module loads Anaconda3
]])

whatis("Name: Anaconda3")
whatis("Conda_dir: /opt/anaconda3")

local conda_dir = "/home/hyunsuk/.conda/envs/openmc0"

local conda_util = loadfile(pathJoin(os.getenv("CDS_HOME"), "modulefunctions/lua/conda_util.lua"))()

conda_util.setup(conda_dir)

prepend_path("PATH", pathJoin("/home/hyunsuk/.local/openmc0", "bin"))
