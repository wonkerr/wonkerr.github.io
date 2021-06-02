---
categories  : 博客
excerpt     : 获取所有显示器的参数，包括使用枚举函数获取显示器信息
title       : 通过系统函数获取多个显示器的信息与参数
tags        : Win32 Monitor DisplayDevice
---

* content
{:toc}

### 1、获取显示器的数量与屏幕尺寸
简单的获取屏幕的宽高

``` C++
	INT Width = GetSystemMetrics( SM_CXSCREEN );
	INT Height = GetSystemMetrics( SM_CYSCREEN );
``` 

获取显示器的数量

``` C++
	INT Numbers = GetSystemMetrics( SM_CMONITORS );
``` 

获取所有显示器的逻辑外接矩形

``` C++
	INT Width = GetSystemMetrics( SM_CXVIRTUALSCREEN );
	INT Height = GetSystemMetrics( SM_CYVIRTUALSCREEN );
``` 

### 2、枚举监视器并获取监视器信息

``` C++
///-----------------------------------------------------------------------------
struct Win32_MonitorInfo : public MONITORINFO
{
	///-------------------------------------------------------------------------
	inline Win32_MonitorInfo( void )
	{
		size_t Bytes = sizeof( *this );
		memset( this , 0 , Bytes );
		this->cbSize = Bytes;
	}
};

///-----------------------------------------------------------------------------
BOOL CALLBACK MonitorEnum( HMONITOR hMonitor , HDC , LPRECT , LPARAM lParam )
{
	Win32_MonitorInfo MonitorInfo;
	if( GetMonitorInfo( hMonitor , &MonitorInfo ) )
	{
		const RECT& rcMonitor = MonitorInfo.rcMonitor;
		STD_REINTERPRET_CAST( LPSIZE , lpSize , lParam );
		LONG Height = rcMonitor.bottom - rcMonitor.top;
		LONG Width = rcMonitor.right - rcMonitor.left;
		lpSize->cy = STD_MAX( lpSize->cy , Height );
		lpSize->cx = STD_MAX( lpSize->cx , Width );
	}

	return TRUE;
}

///-----------------------------------------------------------------------------
void MyMonitorEnumFunction( void )
{
	SIZE Monitor = { 0 , 0 } , * lpSize = &Monitor;
	STD_REINTERPRET_CAST( LPARAM , lParam , lpSize );
	EnumDisplayMonitors( 0 , 0 , MonitorEnum , lParam );

    // ...
}
``` 

注意该方法获取的监视器中给出的屏幕尺寸是逻辑尺寸，例如 4K 显示器设置了 150% 的放缩比例，那么获取的 rcMonitor 和 rcWork 里面的宽高是 2560 * 1440; 
如果要获取真实的分辨率参数，那么可以使用下面的方法

### 3、非回调的枚举方法

``` C++
///-----------------------------------------------------------------------------
struct Win32_DisplayDevice : public DISPLAY_DEVICE
{
	///-------------------------------------------------------------------------
	inline Win32_DisplayDevice( void )
	{
		size_t Bytes = sizeof( *this );
		memset( this , 0 , Bytes );
		this->cb = Bytes;
	}
};

///-----------------------------------------------------------------------------
struct Win32_DeviceMode : public DEVMODE
{
	///-------------------------------------------------------------------------
	inline Win32_DeviceMode( void )
	{
		size_t Bytes = sizeof( *this );
		memset( this , 0 , Bytes );
		this->dmSize = Bytes;
	}
};

///-----------------------------------------------------------------------------
void MyMonitorEnumFunction( void )
{
	Win32_DisplayDevice DisplayDevice;
	DWORD Width = 0 , Height = 0 , nDisplay = 0;
	while( EnumDisplayDevices( NULL , nDisplay , &DisplayDevice , 0 ) )
	{
		Win32_DeviceMode DeviceMode;
		LPCTSTR Name = DisplayDevice.DeviceName;
		CONST DWORD dwSettings = ENUM_REGISTRY_SETTINGS;
		if( EnumDisplaySettings( Name , dwSettings , &DeviceMode ) )
		{
			Height = STD_MAX( DeviceMode.dmPelsHeight , Height );
			Width = STD_MAX( DeviceMode.dmPelsWidth , Width );
		}
		nDisplay++;
	}

    // ...

}

```
