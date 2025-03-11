<script>
    export default {
        name: 'Button',
        props: {
            icon: String,
            toolTip: String,
            disabled: Boolean
        },
        data() { 
            return {}
        },
        methods: {},
    };
</script>

<template>
    <button :disabled="disabled">
        <i :class="icon"></i>
        <span class="tooltip" v-if="!disabled">{{ toolTip }}</span>
    </button>
</template>

<style scoped>
    button {
        text-transform: capitalize;
        padding: 0.6vh 1vh;
        border-radius: 0.8vh;
        border: none;
        background-color: var(--secondaryDarkColor);
    }

    button i {
        color: white;
        font-size: 1.2vh;
    }

    .tooltip {
        display: none;
        position: absolute;
        color: white;
        border-radius: 0.4vh;
        padding: 0.2vh 0.4vh;
        font-size: 1vh;
        margin-left: 1vh;
        background-color: var(--secondaryDarkColor);
    }

    button:hover .tooltip {
        display: block;
    }

    button:hover {
        background-color: rgba(255, 255, 255, 0.2);
        cursor: pointer;
    }

    button:disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }

    button:active {
        border: none;
        outline: none;
    }
</style>