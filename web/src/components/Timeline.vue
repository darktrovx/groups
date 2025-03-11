<script>
    import Label from './Label.vue';
    export default {
        name: 'Timeline',
        components: {
            Label
        },
        props: {
            Title: String,
            Description: String,
            Completed: Boolean,
            Active: Boolean
        },
        data() { return {} },
        methods: {}
    };
</script>

<template>
    <div class="timeline-component">
        <div class="status">
            <Label class="completed" v-show="this.Completed" text="Completed" icon="fas fa-check"/>
            <Label class="active" v-show="this.Active" text="Active" icon="fas fa-circle-notch"/>
        </div>
        <div class="timeline-title"><span>{{ this.Title }}</span></div>
        <div class="timeline-description"><span>{{ this.Description }}</span></div>
    </div>
</template>

<style scoped>

    .timeline-component {
        background: var(--secondaryDarkColor);
        color: white;
        transition: 0.4s ease;
        overflow-wrap: break-word !important;
        border-radius: 6px;
        padding: 1vh;
    }

    .completed {
        background-color: #99e2b465;
    }

    .active {
        background-color: #ffaa006b;
    }

    .timeline-title {
        font-size: 1.2vh;
        font-weight: bold;
        margin-top: 0.5vh;
    }

    .timeline-description {
        font-size: 1vh;
        margin-top: 0.5vh;
    }
    
</style>