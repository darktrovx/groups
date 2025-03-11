<script>
    export default {
        name: 'Label',
        props: {
            text: String,
            icon: String
        },
        methods: {}
    };
</script>

<template>
    <span class="label">
        <span v-if="text && icon" class="icon-text"><i :class="icon"></i> {{ text }}</span>
        <span v-else-if="text" class="text">{{ text }}</span>
        <span v-else-if="icon" class="icon"><i :class="icon"></i></span>
    </span>
</template>

<style scoped>
    .label {
        font-size: 0.8vh;
        border-radius: var(--radius);
        padding: 0.3vh 0.6vh;
    }
</style>