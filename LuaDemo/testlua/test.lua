--导入文件库
require("lfs")

--把MD5作为key放入一个Table中，把对应的文件的路径存入key对应的value中
local repeated_judge = {} 

--遍历文件，并且输出文件的md5信息。--
function files(path)
  for file in lfs.dir(path) do
    
    --过滤掉"."和".."目录
    if file ~= "." and file ~= ".." then
      
      local f = path.. "\\" ..file
      local attr = lfs.attributes (f)
	  --local array_length
      local length
	  
      --如果是文件夹输出之后继续递归，如果是文件就直接输出
      if attr.mode == "directory" then
		print("--------------------------------------------------------------------------------")
        print(f .. "    -->    " .. attr.mode)
        files(f)
      else
		md5 = Compute_file_md5(f)
		print(f .. "-->" .. "MD5为：" .. md5)
		--不重复的直接把路径放入数组，重复的检测数组长度，然后把路径插入到数组的最后面
	  	if repeated_judge[md5] == nil then
		  repeated_judge[md5] = {f}
		else 
		  table.insert(repeated_judge[md5], f)
		end

      end
    end
  end
end


--在此输入查询的文件路径--
--print("请输入路径,路径格式为盘符:\\\\\\\\文件夹,例如E:\\\\\\\\Code\\\\\\\\Lua:\n")
--local str = io.read()
--local repeated_judge = {} 
--files(str ,repeated_judge)
files("E:\\Code\\Lua")



--打印重复的文件的信息
print("--------------------------------------------------------------------------------")
print("********************************************************************************")
print("********************************************************************************")
print("********************************************************************************")
print("--------------------------------------------------------------------------------")
for md5_index, file_index in pairs(repeated_judge) do
  local array_length = table.getn(file_index)
    if array_length ~= 1 then
	  print("共有" .. array_length .. "个文件相同,文件路径为：")
		for index, file_path in ipairs(file_index) do
		  print(file_path)
		end
	end
end