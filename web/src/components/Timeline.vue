<script>

    export default {
        props: {
            Title: String,
            Description: String,
            Completed: Boolean,
            Active: Boolean
        },
        name: 'Timeline',
        data() { return {} },
        methods: {}
    };
</script>

<template>
    <div class="timeline-component timeline-content"
        :style="this.Active ? 'border: 1px solid #fb8500; box-shadow: 5px 5px 10px #fb8500, -5px -5px 10px #fb8500;' : this.Completed ? 'border: 1px solid #b9fbc0; box-shadow: 5px 5px 10px #b9fbc0, -5px -5px 10px #b9fbc0;' : 'border: none;'">
        <div class="timeline-title"><span>{{ this.Title }}</span></div>
        <div class="timeline-description"><span>{{ this.Description }}</span></div>
    </div>
</template>

<style>

    .timeline-content {
        background: #1f1f1f;
        box-shadow: 5px 5px 10px #1a1a1a, -5px -5px 10px #242424;
        color: white;
        transition: 0.4s ease;
        overflow-wrap: break-word !important;
        border-radius: 6px;
    }

    .timeline-component {
        margin: 0px 20px 20px 20px;
    }

    .timeline-title {
        font-size: 2.0vh;
        padding: 1vh 1vh 1vh 1vh;
    }

    .timeline-description {
        font-size: 1.3vh;
        padding: 1vh 1vh 1vh 1vh;
    }
</style>