<script>

    import NUI from './NUI.vue';
    import Task from './Task.vue';
    import Members from './Members.vue';
    import Requests from './Requests.vue';

    export default {
        components: {
            NUI,
            Task,
            Members,
            Requests
        },
        props: {
            Owner: Number,
            Members: Array,
        },
        name: 'Group',
        data() {
            return {
                Page: "NONE"
            }
        },
        methods: {
            ChangePage: function(page) {
                this.Page = page
            },
        }
    };
</script>

<template>
    <div class="group-detail">
        <div class="group-detail-header">
            <div class="group-detail-header-item task-btn" @click="ChangePage('TASK')" :style="this.Page === 'TASK' ? 'color: #fb8500' : 'color: white'"><span><i class="fa-solid fa-list-check"></i></span></div>
            <div class="group-detail-header-item members-btn" @click="ChangePage('MEMBERS')" :style="this.Page === 'MEMBERS' ? 'color: #cfbaf0' : 'color: white'"><span><i class="fa-solid fa-users"></i></span></div>
            <div v-show="this.Owner" class="group-detail-header-item requests-btn" @click="ChangePage('REQUESTS')" :style="this.Page === 'REQUESTS' ? 'color: #fcf6bd' : 'color: white'"><span><i class="fa-solid fa-person-circle-plus"></i></span></div>
        </div>

        <div class="task" v-if="this.Page==='TASK'">
            <Task />
        </div>
        <div class="members" v-if="this.Page==='MEMBERS'">
            <Members :Members="this.Members"/>
        </div>
        <div class="requests" v-if="this.Page==='REQUESTS'">
            <Requests />
        </div>

    </div>
</template>

<style>
    
    .group-detail {
        text-align: center;
        display: flex;
        overflow: hidden !important;
    }

    .group-detail-header {
        position: absolute;
        left: 50%;
        transform: translate(-50%, -50%);
        justify-content: center;
        display: flex;
        margin-top: 2vh;
    }

    .group-detail-header-item {
        margin-left: 1vh;
        margin-right: 1vh;
    }

    .task-btn:hover {
        color: #fb8500 !important;
        cursor: pointer;
    }

    .members-btn:hover {
        color: #cfbaf0 !important;
        cursor: pointer;
    }

    .requests-btn:hover {
        color: #fcf6bd !important;
        cursor: pointer;
    }

    .task {
        min-width: 40vh;
    }
</style>