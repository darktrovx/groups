<script>
    import NUI from './components/NUI.vue';
    import NavBar from './components/NavBar.vue';
    import MyGroup from './components/MyGroup.vue';
    import Requests from './components/Requests.vue';
    import Task from './components/Task.vue';
    import GroupList from './components/GroupList.vue';
    export default {
    components: {
        NUI,
        NavBar,
        MyGroup,
        Requests,
        Task,
        GroupList
    },
    data() {
        return {
            Display: false,
            InGroup: false,
            Owner: false,
            GroupName: "Test Group",
            CurrentView: "Groups",
            GroupLimit: 10,
            Members: [],
            Groups: [],
            Requests: [],
        }
    },
    methods: {
        Open: function() {
            this.Display = true;
        },
        Close: function() {
            this.Display = false;
            NUI.methods.Callback("Close")
        },
        JoinGroup: async function(id) {
            const cb = await NUI.methods.Callback("JoinGroup", { groupID: id })
            if (!cb) { return }
        },
        Create: async function() {
            const cb = await NUI.methods.Callback("CreateGroup")
            if (!cb) { return }
            setTimeout(() => {
                this.InGroup = true;
                this.Owner = true;
                this.CurrentView = "Group";
            }, 300);
        },
        Leave: async function() {
            const cb = await NUI.methods.Callback("LeaveGroup")
            if (!cb) { return }
            this.Cleanup()
        },
        Join: function(data) {
            this.InGroup = true;
            this.Owner = false;
            this.Members = data.members;
        },
        Cleanup: function() {
            this.InGroup = false;
            this.Owner = false;
            this.Members = [];
        },
    },
    destroyed() {
        window.removeEventListener("message", this.listener);
    },
    mounted() {
        this.listener = window.addEventListener("message", (event) => {
            switch(event.data.type) {
                case "open":
                    this.Open()
                    break;
                case "updateGroups":
                    this.Groups = event.data.groups
                    break;
                case "groupJoined":
                    this.Join(event.data);
                    break;
            }
        });

        this.listener = window.addEventListener("keyup", (event) => {
            if (event.key == 'Escape') {
                this.Close()
            }
        });
    },
}
</script>

<template>
    <Transition name="fade">
        <div class="ui-wrapper" v-if="this.Display">
            <div class="group-container">
                <NavBar :isInGroup="this.InGroup" :isOwner="this.Owner"/>
                
                <div class="group-content">
                    <MyGroup v-if= "this.CurrentView === 'Group'"/>
                    <Requests v-if= "this.CurrentView === 'Requests'" />
                    <Task v-if= "this.CurrentView === 'Tasks'" :members="this.Members"/>
                    <GroupList v-if= "this.CurrentView === 'Groups'" :groups="this.Groups" :groupLimit="this.GroupLimit"/>
                </div>
            </div>
        </div>
    </Transition>
</template>

<style>
    .fade-enter-active,
    .fade-leave-active {
        transition: opacity 0.5s ease;
    }

    .fade-enter-from,
    .fade-leave-to {
        opacity: 0;
    }

    .ui-wrapper {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: transparent;
        color: white !important;
    }

    .group-container {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 44vh;
        height: 56vh;
        border-radius: var(--radius);
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        display: flex;
        text-transform: capitalize;
        background-color: var(--darkColor);
    }

    .group-content {
        flex: 1;
        padding: 1vh;
        overflow-y: auto;
    }
</style>