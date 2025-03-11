<script>
    import Button from './Button.vue';
    import Label from './Label.vue';
    export default {
        name: 'GroupList',
        components: {
            Button,
            Label
        },
        props: {
            groups: Array,
            groupLimit: Number
        },
        data() { 
            return {}
        },
        methods: {},
    };
</script>

<template>
    <div class="group-list">
        <div class="group-list-header">
            <h2>available groups</h2>
        </div>
        <div class="group-list-body">
            <div class="group-list-item" v-for="group in groups" :key="group.id">
                <span class="group-name">{{ group.name }}</span>
                <Label class="group-members" :text="group.members + ' / ' + groupLimit" /> 
                
                <div class="controls">
                    <Button icon="fa-solid fa-hand" toolTip="request to join" @click="JoinGroup(group.id)"/>
                </div>
            </div>
        </div>
    </div>
</template>

<style>
    .group-list {
        display: flex;
        flex-direction: column;
        gap: 1vh;
    }

    .group-list-header {
        margin: 0;
        font-size: 1.3vh;
        font-weight: bold;
    }

    .group-list-body {
        display: flex;
        flex-direction: column;
        gap: 0.6vh;
    }

    .group-list-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0.6vh 0.4vh;
        border-radius: 0.8vh;
        background-color: var(--secondaryDarkColor);
    }

    .group-list-item span {
        color: white;
    }

    .group-list-item:hover {
        background-color: rgba(255, 255, 255, 0.2);
        cursor: pointer;
    }

    .group-name {
        font-size: 1.4vh;
        width: 40%;
    }
    
    .group-members {
        font-size: 0.8vh;
        border-radius: var(--radius);
        padding: 0.3vh 0.6vh;
        background-color: #99e2b465;
    }

    .controls {
        display: flex;
        gap: 0.4vh;
    }
</style>