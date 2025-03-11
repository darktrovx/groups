<script>
    import NUI from './NUI.vue';
    import Timeline from './Timeline.vue';
    export default {
        props: {
            GroupID: Number,
        },
        components: {
            NUI,
            Timeline,
        },
        name: 'Task',
        data() {
            return {
                Steps: [],
                Step: 2,
            }
        },
        methods: {
            GetTaskData: async function() {
                const task = await NUI.methods.Callback("GetTaskData")
                if (!task) { return }
                this.Steps = task.steps
                this.Step = task.step
            },
        },
        mounted() {
            this.GetTaskData()

            this.listener = window.addEventListener("message", (event) => {
                switch(event.data.type) {
                    case "updateTask":
                        this.Steps = event.data.steps
                        this.Step = event.data.step
                        break;
                }
            });
        },
    };
</script>

<template>
    <div class="timeline-container">
        <h2>Current Tasks</h2>
        <div class="timeline">
            <Timeline v-show="this.Steps === undefined" Title="" Description="Waiting for a job" :Completed="false" :Active="false" />
            
            <Timeline v-for="(task, index) in this.Steps" :Title="task.title" :Description="task.description" :Completed="(index < this.Step)" :Active="(index == this.Step)" />
        </div>
    </div>
</template>

<style>
    ::-webkit-scrollbar {
        display: none;
    }

    .timeline-container {
        height: 100%;
    }

    .timeline {
        margin: 0 auto;
        display: flex;
        gap: 1vh;
        flex-direction: column;
        overflow-y: scroll !important;
        -webkit-scrollbar: none;
    } 
</style>