local lapp = require 'pl.lapp'
require 'logging.console'
local logger = logging.console()
logger:setLevel(logging.DEBUG)

local function processArgs()
    return lapp [[
    Build HTML documentation from the extracted Markdown, using Sundown.
    -i,--input  (string) input .md file
    -o,--output (string) output .html file
    ]]
end

function readFile(inputPath)
    lapp.assert(path.isfile(inputPath), "Not a file: " .. tostring(inputPath))
    logger:debug("Opening " .. tostring(inputPath))
    local inputFile = io.open(inputPath, "rb")
    lapp.assert(inputFile, "Could not open: " .. tostring(inputPath))
    local content = inputFile:read("*all")
    inputFile:close()
    return content
end

local function handleFile(markdownFile, outputPath)
    local sundown = require 'sundown'
    local content = readFile(markdownFile)
    local rendered = sundown.render(content)
    local outputFile = io.open(outputPath, 'w')
    logger:debug("Writing to " .. outputPath)
    lapp.assert(outputFile, "Could not open: " .. outputPath)
    outputFile:write(rendered)
    outputFile:close()
end

local function main()
    local args = processArgs()
    handleFile(args.input, args.output)
end

main()
