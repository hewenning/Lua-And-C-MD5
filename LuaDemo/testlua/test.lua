--�����ļ���
require("lfs")

--��MD5��Ϊkey����һ��Table�У��Ѷ�Ӧ���ļ���·������key��Ӧ��value��
local repeated_judge = {} 

--�����ļ�����������ļ���md5��Ϣ��--
function files(path)
  for file in lfs.dir(path) do
    
    --���˵�"."��".."Ŀ¼
    if file ~= "." and file ~= ".." then
      
      local f = path.. "\\" ..file
      local attr = lfs.attributes (f)
	  --local array_length
      local length
	  
      --������ļ������֮������ݹ飬������ļ���ֱ�����
      if attr.mode == "directory" then
		print("--------------------------------------------------------------------------------")
        print(f .. "    -->    " .. attr.mode)
        files(f)
      else
		md5 = Compute_file_md5(f)
		print(f .. "-->" .. "MD5Ϊ��" .. md5)
		--���ظ���ֱ�Ӱ�·���������飬�ظ��ļ�����鳤�ȣ�Ȼ���·�����뵽����������
	  	if repeated_judge[md5] == nil then
		  repeated_judge[md5] = {f}
		else 
		  table.insert(repeated_judge[md5], f)
		end

      end
    end
  end
end


--�ڴ������ѯ���ļ�·��--
--print("������·��,·����ʽΪ�̷�:\\\\\\\\�ļ���,����E:\\\\\\\\Code\\\\\\\\Lua:\n")
--local str = io.read()
--local repeated_judge = {} 
--files(str ,repeated_judge)
files("E:\\Code\\Lua")



--��ӡ�ظ����ļ�����Ϣ
print("--------------------------------------------------------------------------------")
print("********************************************************************************")
print("********************************************************************************")
print("********************************************************************************")
print("--------------------------------------------------------------------------------")
for md5_index, file_index in pairs(repeated_judge) do
  local array_length = table.getn(file_index)
    if array_length ~= 1 then
	  print("����" .. array_length .. "���ļ���ͬ,�ļ�·��Ϊ��")
		for index, file_path in ipairs(file_index) do
		  print(file_path)
		end
	end
end