-- from : https://github.com/lalondesteve/gma2plugin
-- LuaLS type annotations
--
-- based off the work of Nick N. Zinovenko
-- https://github.com/exscriber/Ma2-API/raw/refs/heads/master/gma_api.lua
--

---@alias prompt fun(title: string, message:string): boolean
---@alias handle integer

---@class gma
---@field sleep fun(seconds: number)
---@field echo fun(message: string)
---@field feedback fun(message: string)
---@field cmd fun(command: string): string?
---@field build_date fun(): string
---@field build_time fun(): string
---@field git_version fun(): string
---@field gethardwaretype fun(): string
---@field export fun(filename: string, data: table)
---@field export_csv fun(filename: string, data: table)
---@field export_json fun(filename: string, data: table)
---@field import fun(filename: string, subfolder?: string): table
---@field timer fun(callback: function, timeout: number, max_count: number, cleanup: function)
---@field gettime fun(): number
---@field textinput fun(title: string, placeholder?: string): string
---@field gui gui
---@field show show
---@field network network
---@field canbus canbus
---@field user user

---@class progress
---@field start fun(name:string): handle
---@field stop fun(handle: handle)
---@field settext fun(handle: handle, text: string)
---@field setrange fun(handle: handle, from: number, to: number)
---@field set fun(handle:handle, value:number)

---@class gui
---@field confirm prompt
---@field msgbox prompt
---@field progress progress

---@class getobj
---@field handle fun(identifier: string | handle): handle
---@field class fun(handle: handle) : string
---@field index fun(handle: handle) : number
---@field name fun(handle: handle) : string
---@field label fun(handle: handle) : string | nil
---@field number fun(handle: handle) : number   comandline number
---@field amount fun(handle: handle) : number   amount of children
---@field child fun(handle: handle) : handle
---@field parent fun(handle: handle) : handle
---@field verify fun(handle: handle) : handle
---@field compare fun(handle1: handle, handle2:handle) : boolean

---@class user
---@field getcmddest fun(): handle
---@field getselectedexec fun(): handle
---@field getvar fun(var_name: string): string
---@field setvar fun(var_name: string, value: string): nil

---@class  property
---@field amount fun(handle:handle): integer
---@field name fun(handle: handle, index: integer): string
---@field get fun(handle: handle, index: integer): string

---@class show
---@field getobj getobj
---@field property property
---@field getdmx fun(recycle?: table, dmx_addr:number, amount?:number)
---@field getvar fun(var_name: string): string
---@field setvar fun(var_name: string, value: string): nil

---@class network
---@field gethosttype fun(): string
---@field gethostsubtype fun(): string
---@field getprimaryip fun(): string
---@field getsecondaryip fun(): string
---@field getstatus fun(): string
---@field getsessionnumber fun(): number
---@field getsessionname fun(): string
---@field getslot fun(): number
---@field gethostdata fun(ip:string, recycle?: table) : table
---@field getmanetslot fun(slot: number, recycle?: table) : table
---@field getperformance fun(slot: number, recycle?: table): table

---@class canbus
---@field hardkey fun(keycode: number, pressed: boolean, hold: boolean): boolean
---@field encoder fun(encoder: number, steps: number, pressed: boolean): boolean
---@field wheel fun(steps: number): boolean
---@field ball fun(x_axis: number, y_axis: number ): boolean
