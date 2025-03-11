<script>
    export default {
        name: 'Input',
        props: {
            type: String,
            placeholder: String,
            required: Boolean,
            value: String
        },
        methods: {}
    };
</script>

<template>
    <input :type="type" :placeholder="placeholder" :required="required" :value="value"/>
</template>

<style>
    input {
        padding: 0.6vh 1vh;
        border-radius: 0.8vh;
        border: 0.2vh solid rgba(255, 255, 255, 0.137);
        background-color: var(--secondaryDarkColor);
        color: white;
    }

    input::placeholder {
        color: white;
    }

    input:focus {
        outline: none;
    }
</style>