import React from 'react';
import { connect } from 'react-redux';
import Select, { createFilter, components } from 'react-select';

import { translate as $t } from '../../helpers';

import { get } from '../../store';
import './multiple-select.css';

const REACT_SELECT_FILTER = createFilter({
    ignoreCase: true,
    ignoreAccents: true,
    trim: true,
    matchFrom: 'any',
    stringify: ({ label }) => label.toString(),
});

const Placeholder = (props: components.PlaceholderProps) => {
    return (
        <components.Placeholder {...props}>
            <span>
                {props.selectProps.value.length} {props.selectProps.placeholder}
            </span>
        </components.Placeholder>
    );
};

const Menu = (props: components.MenuProps) => {
    const { className, cx, innerProps, innerRef, children, selectProps } = props;
    const selectedOptions = props.getValue();
    const isAllSelected = !props.options.some(o => !selectedOptions.includes(o));
    function handleClick() {
        if (isAllSelected) {
            props.setValue([], 'set-value');
        } else {
            props.setValue(props.options, 'set-value');
        }
    }
    return (
        <components.Menu {...props}>
            <div
                ref={innerRef}
                className={cx(
                    {
                        menu: true,
                        'menu--is-custom': true,
                    },
                    className
                )}
                {...innerProps}
                onClick={handleClick}
                onTouchEnd={handleClick}>
                <input type="checkbox" checked={isAllSelected} readOnly={true} />
                <label>{selectProps.selectAllMessage}</label>
            </div>
            {children}
        </components.Menu>
    );
};

const ValueContainer = ({ children, ...props }: components.ValueContainerProps) => {
    const { getValue, hasValue, selectProps } = props;
    const countSelectedVal = getValue().length;
    const filter = child => (!hasValue || child.type === components.Input ? child : null);
    return (
        <components.ValueContainer {...props}>
            {React.Children.map(children, filter)}
            {hasValue &&
                !selectProps.inputValue &&
                `${countSelectedVal} ${selectProps.placeholder}`}
        </components.ValueContainer>
    );
};

const Option = (props: components.OptionProps) => {
    return (
        <components.Option {...props}>
            <input type="checkbox" checked={props.isSelected} readOnly={true} />
            <label>{props.data.label}</label>
        </components.Option>
    );
};

interface MultiSelectOptionProps {
    label: string;
    value: string | number;
}

interface MultipleSelectProps {
    // A string describing the classes to apply to the select.
    className: string;

    // A function returning the text to display when no such options are found,
    // in fuzzy mode.
    noOptionsMessage: () => string;

    // A callback to be called when the user selects a new value.
    onChange: (value: any[] | null) => void;

    // An array of options in the select.
    options?: MultiSelectOptionProps[];

    // A text to display when nothing is selected.
    placeholder?: string;

    // A boolean telling whether the field is required.
    required: boolean;

    // The value that's selected at start.
    values?: Array<string | number>;

    // A boolean telling whether display is expected with checkboxes (not filling input box)
    isCheckBox: boolean;

    // A boolean telling whether we provide Select All
    isSelectAll: boolean;

    // Text to display next to select all checkbox
    selectAllMessage?: string;
}

const MultipleSelect = connect(state => {
    const isSmallScreen = get.isSmallScreen(state);
    return {
        isSearchable: !isSmallScreen,
    };
})((props: MultipleSelectProps) => {
    function handleChange(event: any[] | null): void {
        const values: Array<string | number> = event ? event.map(e => e.value) : [];
        const currentValues = props.values || [];
        if (
            values.length !== currentValues.length ||
            values.some(v => !currentValues.includes(v)) ||
            currentValues.some(v => !values.includes(v))
        ) {
            props.onChange(values);
        }
    }

    const {
        options,
        placeholder,
        required,
        values,
        isCheckBox,
        isSelectAll,
        selectAllMessage,
    } = props;

    let className = `${props.className} Select`;
    if (required) {
        className += values ? ' valid-fuzzy' : ' invalid-fuzzy';
    }

    let currentValues: MultiSelectOptionProps[] = [];
    if (values && options) {
        currentValues = options.filter(opt => (values || []).includes(opt.value));
    }
    let cmps = {};
    if (isCheckBox) {
        cmps = { Placeholder, ValueContainer, Option, ...cmps };
    }
    if (isSelectAll) {
        cmps = { Menu, ...cmps };
    }
    return (
        <Select
            backspaceRemovesValue={true}
            className={className}
            classNamePrefix="Select"
            filterOption={REACT_SELECT_FILTER}
            isClearable={true}
            noOptionsMessage={props.noOptionsMessage}
            onChange={handleChange}
            options={options}
            placeholder={placeholder}
            value={currentValues}
            isMulti={true}
            hideSelectedOptions={!isCheckBox}
            closeMenuOnSelect={!isCheckBox}
            selectAllMessage={selectAllMessage}
            components={cmps}
        />
    );
});

MultipleSelect.defaultProps = {
    required: false,
    className: '',
    isCheckBox: false,
    isSelectAll: false,
    selectAllMessage: $t('client.general.select_all'),
};

export default MultipleSelect;
