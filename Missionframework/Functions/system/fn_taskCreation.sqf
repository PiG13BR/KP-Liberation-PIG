/*
	File: fn_taskCreation.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 11/01/2024 
	Last Update: 21/12/2025 
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Create task and deletes if the same taskID exists

	Parameter(s):
		_side - side that task will be assigned [SIDE, ARRAY OF SIDES]
		_taskID - custom ID name for the task [STRING, ARRAY [task ID, parent task]]
		_description - description of the task [ARRAY - description, title, marker]
		_taskPos - position of the task [POSITION ARRAY, OBJECT, ARRAY [OBJECT, PRECISION]]
		_taskType - https://community.bistudio.com/wiki/Arma_3:_Task_Framework#Task_Icons [STRING, defaults to "default"]
		_taskState - task state ("CREATED", "ASSIGNED", "AUTOASSIGNED", "SUCCEEDED", "FAILED", "CANCELED") [STRING, defaults to "ASSIGNED"]
		_notify - notify task creation [BOOL, defaults to true]

	Returns:
		-
*/

params[
	["_side", KPLIB_side_player], 
	["_taskID", "", [""]], 
	["_description", [], [[]]],
	["_taskPos", [0,0,0], [[], objNull], [2,3]],
	["_taskType", "default", [""]],
	["_taskState", "ASSIGNED", [""]],
	["_notify", true, [FALSE]]
];

// Check if the task ID already exist/was completed. Delete it if it's true.

if (typeName _taskID == typeName []) then {
	{
		private _taskCompleted = [_x] call BIS_fnc_taskCompleted;
		if (_taskCompleted) then {
			diag_log (format ["[TASK CREATION INFO] Deleting an existing task ID: %1", _taskID]); 
			[_x] call BIS_fnc_deleteTask;
		};
	}forEach _taskID;
} else {
	private _taskCompleted = [_taskID] call BIS_fnc_taskCompleted;
	if (_taskCompleted) then {
		diag_log (format ["[TASK CREATION INFO] Deleting an existing task ID: %1", _taskID]); 
		[_taskID] call BIS_fnc_deleteTask;
	};
};

[{
	_this call BIS_fnc_taskCreate;
}, [_side, _taskID, _description, _taskPos, _taskState, 1, _notify, _taskType], 1] call CBA_fnc_waitAndExecute;

// Create new task
[format["%1, %2, %3, %4, %5", _side, _taskID, _description, _taskPos, _taskType], "[TASK CREATION INFO]"] call KPLIB_fnc_log;

