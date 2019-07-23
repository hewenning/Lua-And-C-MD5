#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include "md5_test/md5.h"

#define READ_DATA_SIZE	1024
#define MD5_SIZE		16
#define MD5_STR_LEN		(MD5_SIZE * 2)


//C调用Lua的函数
void load(lua_State* L, const char* fname) {
	if (luaL_loadfile(L, fname) || lua_pcall(L, 0, 0, 0)) {
		printf("Error Msg is %s.\n", lua_tostring(L, -1));
		return;
	}
}


/**
 * 在Lua中注册的C函数
 * compute the value of a file
 * @param  file_path
 * @param  md5_str
 * @return 0: ok, -1: fail
 */
static int Compute_file_md5(lua_State *L)
{
	const char *file_path;
	file_path = luaL_checkstring(L, 1);
	char md5_str[MD5_STR_LEN + 1];
	int i;
	int fd;
	int ret;
	unsigned char data[READ_DATA_SIZE];
	unsigned char md5_value[MD5_SIZE];
	MD5_CTX md5;

	fd = open(file_path, O_RDONLY);
	if (-1 == fd)
	{
		perror("open");
		return -1;
	}

	//初始化函数
	MD5Init(&md5);
	while (1)
	{
		ret = read(fd, data, READ_DATA_SIZE);
		if (-1 == ret)
		{
			perror("read");
			close(fd);
			return -1;
		}

		MD5Update(&md5, data, ret);

		if (0 == ret || ret < READ_DATA_SIZE)
		{
			break;
		}
	}
	close(fd);

	MD5Final(&md5, md5_value);
	// 把md5的值转换为字符串
	for (i = 0; i < MD5_SIZE; i++)
	{
		snprintf(md5_str + i * 2, 2 + 1, "%02x", md5_value[i]);
	}
	lua_pushstring(L, md5_str);
	return 1;
}


int main()
{
	//创建一个新的栈
	lua_State* L = luaL_newstate();
	luaL_openlibs(L);
	//luaopen_io(L);
	//在Lua中注册C的函数
	//lua_register(L, "sub", sub);
	lua_register(L, "Compute_file_md5", Compute_file_md5);

	//执行Lua文件的命令
	load(L, "E:\\Code\\VS2017\\LuaDemo\\LuaDemo\\testlua\\test.lua");

	//关闭栈
	lua_close(L);
	return 0;
}

