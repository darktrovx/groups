<script>
    import Button from './Button.vue';
    export default {
        name: 'NavBar',
        components: {
            Button
        },
        props: {
            isInGroup: Boolean,
            isOwner: Boolean
        },
        data() { 
            return {}
        },
        methods: {
            handleClick(event) {
                this.$root.CurrentView = event;
                this.$root.event = true;
            }
        },
    };
</script>

<template>
    <div class="nav-container">
        <Button  :class="{ inGroup: isInGroup }" icon="fa-solid fa-plus" toolTip="Create Group" @click="this.$root.Create()" :disabled="isInGroup"/>
        <Button icon="fa-solid fa-list" toolTip="View Group List" @click="this.$root.CurrentView = 'Groups'"/>
        
        <Transition name="fade">
            <div class="group-controls" v-if="isInGroup">
                <Button icon="fa-solid fa-arrow-right-from-bracket" toolTip="Leave Group" @click="this.$root.Leave(), this.$root.CurrentView = 'Groups'"/>
                <Button icon="fa-solid fa-user-friends" toolTip="My Group" @click="this.$root.CurrentView = 'Group'"/>
                <Button icon="fa-solid fa-bars-progress" toolTip="View Tasks" @click="this.$root.CurrentView = 'Tasks'"/>
                <Button v-if="isOwner" icon="fa-solid fa-hand" toolTip="View Requests" @click="this.$root.CurrentView = 'Requests'"/>
            </div>
        </Transition>

        <Button class="closebtn" icon="fa-solid fa-xmark" toolTip="Close Group" @click="this.$root.Close()"/>
    </div>
</template>

<style scoped>
    .disabled {
        opacity: 0.1;
        /* background-color: red; */
    }

    .nav-container {
        display: flex;
        flex-direction: column;
        gap: 1vh;
        padding: 0.4vh 0.4vh;
        width: 8%;
        border-right: 0.1vh solid rgba(73, 73, 73, 0.637);
    }

    .group-controls {
        display: flex;
        flex-direction: column;
        gap: 1vh;
        padding: 1vh 0 0 0;
        border-top: 0.1vh solid rgba(73, 73, 73, 0.637);
        margin: 1vh 0 0 0;
    }

    .closebtn {
        margin-top: auto;
        background-color: #ff6b6b60;
    }

    .closebtn:hover {
        background-color: rgba(255, 107, 107, 0.493);
    }
</style>