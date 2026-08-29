*** Settings ***
Library    Collections
Library    String


*** Variables ***
${EXPECTED_STRING}    {"firstName":"Tape","lastName":"doe","age":26,"address":{"streetAddress":"naist street","city":"Nara","postalCode":"630-0192"},"phoneNumbers":[{"type":"iPhone","number":"0123-4567-8888"},{"type":"home","number":"0123-4567-8910"}]}


*** Keywords ***

Verify Json Response
    [Documentation]    Compare actual JSON vs expected JSON string
    ...                Fail พร้อม message สรุป field ที่ต่างกัน
    [Arguments]    ${actual_json}    ${expected_string}

    ${expected}       Evaluate    json.loads($expected_string)    modules=json
    ${diffs}          _Deep Compare Json    ${expected}    ${actual_json}    $
    ${diff_count}     Get Length    ${diffs}

    IF    ${diff_count} > 0
        ${newline}        Set Variable    \n
        ${diff_report}    Evaluate        $newline.join($diffs)
        Fail    ⚠️ JSON Mismatch! Found ${diff_count} difference(s)\n════════════════════════════════════════\n${diff_report}\n════════════════════════════════════════
    END


_Deep Compare Json
    [Documentation]    Recursive keyword สำหรับ compare JSON แบบ deep
    [Arguments]    ${expected}    ${actual}    ${path}

    ${diffs}      Create List
    ${exp_type}   Evaluate    type($expected).__name__
    ${act_type}   Evaluate    type($actual).__name__

    IF    $exp_type == 'dict' and $act_type == 'dict'
        ${all_keys}    Evaluate    sorted(set(list($expected.keys()) + list($actual.keys())))
        FOR    ${key}    IN    @{all_keys}
            ${new_path}    Set Variable    ${path}.${key}
            ${in_exp}      Evaluate    $key in $expected
            ${in_act}      Evaluate    $key in $actual
            IF    not ${in_exp}
                Append To List    ${diffs}    [MISSING IN EXPECTED] ${new_path} = '${actual}[${key}]'
            ELSE IF    not ${in_act}
                Append To List    ${diffs}    [MISSING IN ACTUAL]   ${new_path} = '${expected}[${key}]'
            ELSE
                ${child_diffs}    _Deep Compare Json    ${expected}[${key}]    ${actual}[${key}]    ${new_path}
                ${diffs}          Evaluate    $diffs + $child_diffs
            END
        END

    ELSE IF    $exp_type == 'list' and $act_type == 'list'
        ${exp_len}    Get Length    ${expected}
        ${act_len}    Get Length    ${actual}
        ${min_len}    Evaluate      min($exp_len, $act_len)
        FOR    ${i}    IN RANGE    ${min_len}
            ${new_path}       Set Variable    ${path}[${i}]
            ${child_diffs}    _Deep Compare Json    ${expected}[${i}]    ${actual}[${i}]    ${new_path}
            ${diffs}          Evaluate    $diffs + $child_diffs
        END
        IF    $exp_len != $act_len
            Append To List    ${diffs}    [ARRAY LENGTH] ${path}: expected=${exp_len}, actual=${act_len}
        END

    ELSE
        ${is_equal}    Evaluate    $expected == $actual
        IF    not ${is_equal}
            Append To List    ${diffs}    [MISMATCH] ${path} | Expected: '${expected}' | Actual: '${actual}'
        END
    END

    RETURN    ${diffs}


*** Test Cases ***

TC01 - JSON Match All Fields Equal
    [Documentation]    ทดสอบกรณี JSON ตรงกันทุก field
    [Tags]    json    pass
    ${actual_json}    Evaluate
    ...    json.loads('{"firstName":"Tape","lastName":"doe","age":26,"address":{"streetAddress":"naist street","city":"Nara","postalCode":"630-0192"},"phoneNumbers":[{"type":"iPhone","number":"0123-4567-8888"},{"type":"home","number":"0123-4567-8910"}]}')
    ...    modules=json
    Verify Json Response    ${actual_json}    ${EXPECTED_STRING}


TC02 - JSON Mismatch firstName
    [Documentation]    ทดสอบกรณี firstName ต่างกัน
    [Tags]    json    fail
    ${actual_json}    Evaluate
    ...    json.loads('{"firstName":"John","lastName":"doe","age":26,"address":{"streetAddress":"naist street","city":"Nara","postalCode":"630-0192"},"phoneNumbers":[{"type":"iPhone","number":"0123-4567-8888"},{"type":"home","number":"0123-4567-8910"}]}')
    ...    modules=json
    Verify Json Response    ${actual_json}    ${EXPECTED_STRING}


TC03 - JSON Mismatch Multiple Fields
    [Documentation]    ทดสอบกรณีมีหลาย field ต่างกัน
    [Tags]    json    fail
    ${expected_multi}    Set Variable
    ...    {"firstName":"Tape","lastName":"Smith","age":30,"address":{"streetAddress":"naist street","city":"Tokyo","postalCode":"630-0192"},"phoneNumbers":[{"type":"iPhone","number":"0123-4567-8888"},{"type":"home","number":"0123-4567-8910"}]}
    ${actual_json}    Evaluate
    ...    json.loads('{"firstName":"John","lastName":"doe","age":26,"address":{"streetAddress":"naist street","city":"Nara","postalCode":"630-0192"},"phoneNumbers":[{"type":"iPhone","number":"0123-4567-8888"},{"type":"home","number":"0123-4567-8910"}]}')
    ...    modules=json
    Verify Json Response    ${actual_json}    ${expected_multi}


TC04 - JSON Mismatch phoneNumbers Array
    [Documentation]    ทดสอบกรณี array element ต่างกัน
    [Tags]    json    fail
    ${expected_arr}    Set Variable
    ...    {"firstName":"Tape","lastName":"doe","age":26,"phoneNumbers":[{"type":"iPhone","number":"0123-4567-8888"},{"type":"home","number":"0123-4567-8910"}]}
    ${actual_json}    Evaluate
    ...    json.loads('{"firstName":"Tape","lastName":"doe","age":26,"phoneNumbers":[{"type":"Android","number":"0123-4567-0000"},{"type":"home","number":"0123-4567-8910"}]}')
    ...    modules=json
    Verify Json Response    ${actual_json}    ${expected_arr}
