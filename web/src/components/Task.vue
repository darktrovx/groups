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
                Step: 0,
            }
        },
        methods: {
            GetTaskData: async function() {
                const task = await NUI.methods.NUICallback("GetTaskData")
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
        display: flex;
        flex-direction: column;
        align-items: center;
        overflow-y: scroll !important;
        -webkit-scrollbar: none;
        margin-top: 7vh;
    }

    .timeline {
        width: 80%;
        max-height: 45vh;
        margin: 0 auto;
        display: flex;
        flex-direction: column;
        padding-top: 3vh;
        overflow-y: scroll !important;
        -webkit-scrollbar: none;
    } 
</style>