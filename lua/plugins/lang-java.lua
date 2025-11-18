-- ~/.config/nvim/lua/plugins/lang-java.lua

return {
  "mfussenegger/nvim-jdtls",
  
  -- only load this plugin when you open a .java file
  ft = { "java" }, 
  
  dependencies = {
    "mfussenegger/nvim-dap", 
    "mason-org/mason.nvim",
  },
  
  config = function()
    print("Java config loading...")

    -- nvim-jdtls needs to know where your Java Runtime is.
    local java_home = "C:/Program Files/Java/jdk-24"
    
    local jdtls_bin = java_home .. "/bin/java"

    -- This automatically finds the jdtls jar installed by mason
    local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
    
    -- Find the launcher jar
    local launchers = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", false, true)
    
    if vim.tbl_isempty(launchers) then
      print("Error: Could not find jdtls launcher jar.")
      print("Run :Mason and make sure 'jdtls' is installed.")
      print("If it is, try restarting Neovim.")
      return
    end
    
    local jdtls_launcher_jar = launchers[1]

    -- ---
    -- This section configures nvim-dap for Java debugging
    -- ---
    local dap = require("dap")

    -- 1. Configure the java-debug-adapter (installed by mason)
    dap.adapters.java = {
      type = "executable",
      command = vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/bin/java-debug-adapter",
    }
    
    -- 2. Define the DAP configuration for Java projects
    dap.configurations.java = {
      {
        type = "java",
        request = "launch",
        name = "Launch Current File",
        mainClass = function()
          -- Ask for the main class to run
          return vim.fn.input("Main class to launch: ")
        end,
        -- You can add more fields here, like `vmArgs`, `args`, etc.
        -- This example is simple, for more complex projects (Maven, Gradle)
        -- you might need a launch.json or more setup.
      },
    }
    
    -- ---
    -- This section configures the jdtls language server
    -- ---
    local jdtls = require("jdtls")
    
    -- This is the folder where jdtls will store project-specific data
    local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

    -- The command to start the server
    local jdtls_cmd = {
      jdtls_bin,
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xmx1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "-jar", jdtls_launcher_jar,
      "-configuration", jdtls_path .. "/config_win", -- Use config_win on Windows
      -- "-configuration", jdtls_path .. "/config_linux", -- Use config_linux on Linux
      -- "-configuration", jdtls_path .. "/config_mac",   -- Use config_mac on macOS
      "-data", workspace_dir,
    }

    jdtls.start_or_attach({
      cmd = jdtls_cmd,
      
      on_attach = function(client, bufnr)
        -- REMOVED: vim.g.my_lsp_on_attach(client, bufnr)
        -- The keymaps are now handled by config/keymaps.lua automatically!
        
        -- This attaches the jdtls-specific DAP configuration
        jdtls.setup_dap({ hotcodereplace = "auto" })
        
        -- Add Java-specific keymaps here
        local map = vim.keymap.set
        local opts = { buffer = bufnr, noremap = true, silent = true }
        
        map("n", "<leader>jo", jdtls.organize_imports, opts)
        map("n", "<leader>jv", jdtls.extract_variable, opts)
        map("v", "<leader>jv", "<Esc><Cmd>JavaExtractVariable<CR>", opts)
        map("n", "<leader>jc", jdtls.extract_constant, opts)
        map("v", "<leader>jc", "<Esc><Cmd>JavaExtractConstant<CR>", opts)
        map("n", "<leader>jt", jdtls.test_class, opts)
        map("n", "<leader>jT", jdtls.test_nearest_method, opts)
      end,
      
      root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
    })
    
    print("Java config loaded successfully.")
  end,
}
