from robot.api.deco import keyword, library

@library
class MyLibrary:

    @keyword("Greet User")
    def greet_user(self, name):
        """Returns a greeting for the given name."""
        message = f"Hello, {name}! Welcome to Robot Framework."
        print(message)
        return message

    @keyword("Add Two Numbers")
    def add_two_numbers(self, a, b):
        """Adds two numbers and returns the result."""
        result = int(a) + int(b)
        return result

    @keyword("Is Even Number")
    def is_even_number(self, number):
        """Checks if a number is even, returns True/False."""
        return int(number) % 2 == 0
    
    # @keyword("Read Worksheet")
    # def read_worksheet(self, sheet_name=None, header=False, start_row=1):
    #     """อ่านข้อมูลทั้ง worksheet

    #     - sheet_name : ระบุ sheet ที่จะอ่าน (ไม่ระบุ = ใช้ active worksheet)
    #     - header     : True เพื่อใช้แถวแรกเป็นชื่อคอลัมน์ และคืนค่าเป็น list ของ dict
    #                    False เพื่อคืนค่าเป็น list ของ list ตรงๆ (ค่าเริ่มต้น)
    #     - start_row  : แถวที่เริ่มอ่าน (ค่าเริ่มต้น = แถวที่ 1)
    #     """
    #     self._check_workbook_opened()
    #     sheet = self.workbook[sheet_name] if sheet_name else self.active_sheet

    #     rows = list(sheet.iter_rows(min_row=start_row, values_only=True))
    #     if not rows:
    #         return []

    #     if header:
    #         headers = rows[0]
    #         return [dict(zip(headers, row)) for row in rows[1:]]

    #     return [list(row) for row in rows]